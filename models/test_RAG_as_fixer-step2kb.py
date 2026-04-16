'''
    this script test with RAG system as the fixer. fixer kb: step 2's result
    procedure: corpus loading -> embedding -> testing
'''

from utils.utils import OpenAIModel, execute_logic_program, loading_pairs, pairs_to_corpus_ARLSAT, pairs_to_corpus_FOLIO, get_retrievers_ARLSAT, get_retrievers_FOLIO, RAGFixer
from utils.LLM_config import LLM_CONFIG
import os
import json
import dspy
import random
from tqdm import tqdm
import time
import re
from datetime import datetime

pairs_to_corpus = {
    'AR-LSAT': pairs_to_corpus_ARLSAT,
    'FOLIO': pairs_to_corpus_FOLIO
}

get_retrievers = {
    'AR-LSAT': get_retrievers_ARLSAT,
    'FOLIO': get_retrievers_FOLIO
}

# ------------SETTING------------

embedder_config = LLM_CONFIG["embedder"]

llm_name = "dpsk-reasoner"

dataset_name = "FOLIO"
test_fpath = f"./benchmarks/{dataset_name}/dev.json"
result_save_fpath = f"./evaluation_result/RAG-fixer-{dataset_name}"

# fixer KB
step2_KB_fpath = f"./SemanticPref/constructed_data_{dataset_name}/rule-based-result"
corpus_template_fpath = f"./prompts/corpus_for_RAG_template_{dataset_name}.json"

# testing prompt (translator)
prompt_template_path = f"./prompts/z3program_generation_{dataset_name}.txt"

llm = OpenAIModel(LLM_CONFIG[llm_name], max_new_tokens=2048, temp=0)

if not LLM_CONFIG[llm_name].is_reasoning:
    dspy.configure(lm=dspy.LM(model=LLM_CONFIG[llm_name].llm_name, api_base=LLM_CONFIG[llm_name].base_url, api_key=LLM_CONFIG[llm_name].api_key, max_tokens=2048, temperature=0))
else:
    dspy.configure(lm=dspy.LM(model=LLM_CONFIG[llm_name].llm_name, api_base=LLM_CONFIG[llm_name].base_url, api_key=LLM_CONFIG[llm_name].api_key, max_tokens=20000, temperature=1.0))

# ------------SETTING------------

# getting corpus for RAG
# using step 2 result as KB
with open(corpus_template_fpath, "r+", encoding='utf-8') as f:
    template = json.load(f)
corpus_template = [template["first_chosen"], template["second_chosen"]]
error_descrip_template = template["error_description"]

# loading step 2 data
step2_KB_data = loading_pairs(step2_KB_fpath)

# turning data into corpus for KB
corpus_dict = pairs_to_corpus[dataset_name](step2_KB_data, error_descrip_template, corpus_template)

# embedder
embedder = dspy.Embedder(model=embedder_config.llm_name, api_key=embedder_config.api_key, api_base=embedder_config.base_url)
topk_to_retrieve = 2

# retrivers
print("embedding...")
retrievers = get_retrievers[dataset_name](corpus_dict, embedder, topk_to_retrieve)

# RAG module as fixer
Fixer = RAGFixer(dataset_name, retrievers)
    
# testing phase: a translator to generate initial program, a RAG fixer to fix (or determine stop fixing)

with open(prompt_template_path, "r", encoding='utf-8') as f:
    generation_prompt_template = f.read()
    
pattern = r"```python(.*?)```"

with open(test_fpath, 'r+', encoding='utf-8') as f:
    test_data = json.load(f)

test_result = []
internet_issues = []
for sample in tqdm(test_data):
    print(f"*****{sample['id']}*****")
    NL_context = sample["context"]
    NL_question = sample["question"]
    NL_options = "\n".join(sample["options"])
    gold_answer = sample["answer"]
    NL_story = f"# Context:\n{NL_context}\n# Question:\n{NL_question}\n# Options:\n{NL_options}"
    print(f"gold answer: {gold_answer}")
    
    # translator generating program
    generation_prompt = generation_prompt_template.replace("[[CONTEXT]]", NL_context).replace("[[QUESTION]]", NL_question).replace("[[OPTIONS]]", NL_options)
    
    program_result = []
    answer = ''
    raw_output = ''
    for attempt in range(3):
        try:
            raw_output = llm.generate(generation_prompt)
            # print(raw_output)
            print(f"raw output length: {len(raw_output)}")
            break
        except Exception:
            time.sleep(1)
    if not raw_output:
        print(f"connection error.")
        internet_issues.append(sample['id'])
        continue
    program = ""
    try:
        program = re.findall(pattern, raw_output, re.DOTALL)[0].strip()
    except:
        program = raw_output.replace("```python", "").replace("```", "").strip()
    if not program.startswith('from z3 import *'):
            program = "from z3 import *\n" + program
    print(f"original program length: {len(program)}")
    exec_dict = execute_logic_program(program)
    result = {
        "program": program,
        "execution": exec_dict
    }
    print(f"answer: {exec_dict['result']}")
    program_result.append(result)
    if exec_dict["flag"] == "success":
        answer = exec_dict["result"][0]
    
    # fixer fixxing program
    for judge_num in range(3):
        print(f"correcting round {judge_num}")
        for attempt in range(3):
            judgement = ""
            try:
                judgement, rag_samples = Fixer(NL_story=NL_story, program=result)
                print(f"rag_samples num: {len(rag_samples)}")
                break
            except Exception:
                time.sleep(1)
        
        if not judgement:
            print(f"connection error.")
            internet_issues.append(sample['id'])
            break
        elif "There is no error." in judgement.response:
            print("no need for further correction.")
            break
        else:
            program = ""
            try:
                program = re.findall(pattern, judgement.response, re.DOTALL)[0].strip()
            except:
                program = judgement.response.replace("```python", "").replace("```", "").strip()
            if not program.startswith('from z3 import *'):
                program = "from z3 import *\n" + program
            print(f"corrected program length {len(program)}")
            exec_dict = execute_logic_program(program)
            print(f"answer: {exec_dict['result']}")
            result = {
                "program": program,
                "execution": exec_dict
            }
            program_result.append(result)
            if exec_dict["flag"] == "success":
                answer = exec_dict["result"][0]
    
    result_dict = {
        "id": sample["id"],
        "context": sample["context"],
        "question": sample["question"],
        "options": sample["options"],
        "gold_answer": sample["answer"],
        "programs": program_result,
        "answer": answer
    }
    test_result.append(result_dict)

if not os.path.exists(result_save_fpath):
    os.makedirs(result_save_fpath)

result_path = os.path.join(result_save_fpath, f"result-teston-{datetime.now().strftime('%m%d-%H%M%S')}-{llm_name}-step2.json")

with open(result_path, "w+", encoding='utf-8') as f:
    json.dump(test_result, f, indent=2, ensure_ascii=False)
    
print(f"result saved in {result_path}")
print(f"internet issues id: {internet_issues}")