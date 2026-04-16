'''
this script test with RAG module for OOD benchmarks.
KBs are from AR-LSAT and FOLIO.
Retrieval: one sample for each patterns from each dataset.
'''

from utils.utils import OpenAIModel, execute_logic_program, loading_kb_with_da, get_retrievers_ARLSAT, get_retrievers_FOLIO, RAGFixer
from utils.LLM_config import LLM_CONFIG
import os
import json
import dspy
import random
from tqdm import tqdm
import time
import re
from datetime import datetime

get_retrievers = {
    'AR-LSAT': get_retrievers_ARLSAT,
    'FOLIO': get_retrievers_FOLIO
}

test_fpaths = {
    'AR-LSAT': "./benchmarks/AR-LSAT/dev.json",
    'ProverQA': "./benchmarks/ProverQA/dev/hard.json",
    'FOLIO': "./benchmarks/FOLIO/dev.json",
    'LogicalDeduction': "./benchmarks/LogicalDeduction/dev.json"
}

# ------------SETTING------------

embedder_config = LLM_CONFIG["embedder"]

llm_name = "o3-mini" # ["gpt-4o", "dpsk-chat", "dpsk-reasoner", "o3-mini"]

dataset_name = "ProverQA" # ["LogicalDeduction", "ProverQA"]

test_fpath = test_fpaths[dataset_name]
result_save_fpath = f"./evaluation_result/RAG-fixer-{dataset_name}"
if not os.path.isdir(result_save_fpath):
    os.makedirs(result_save_fpath)

# translator
prompt_template_path = f"./prompts/z3program_generation_{dataset_name}.txt"

llm = OpenAIModel(LLM_CONFIG[llm_name], max_new_tokens=2048, temp=0)

if not LLM_CONFIG[llm_name].is_reasoning:
    dspy.configure(lm=dspy.LM(model=LLM_CONFIG[llm_name].llm_name, api_base=LLM_CONFIG[llm_name].base_url, api_key=LLM_CONFIG[llm_name].api_key, max_tokens=2048, temperature=0))
else:
    dspy.configure(lm=dspy.LM(model=LLM_CONFIG[llm_name].llm_name, api_base=LLM_CONFIG[llm_name].base_url, api_key=LLM_CONFIG[llm_name].api_key, max_tokens=20000, temperature=1.0))

# ------------SETTING------------

# getting corpus for RAG
# using AR-LSAT, FOLIO's KB

# loading AR-LSAT's KB
LSAT_corpus_dict = loading_kb_with_da('AR-LSAT')

# loading FOLIO's KB
FOLIO_corpus_dict = loading_kb_with_da('FOLIO')

# embedder
embedder = dspy.Embedder(model=embedder_config.llm_name, api_key=embedder_config.api_key, api_base=embedder_config.base_url)
topk_to_retrieve = 1

# retrievers
LSAT_retrievers = get_retrievers['AR-LSAT'](LSAT_corpus_dict, embedder, topk_to_retrieve, with_da=True)

FOLIO_retrievers = get_retrievers['FOLIO'](FOLIO_corpus_dict, embedder, topk_to_retrieve, with_da=True)

retrievers = {}
for err_type in LSAT_retrievers:
    retrievers[f'LSAT_{err_type}'] = LSAT_retrievers[err_type]

for err_type in FOLIO_retrievers:
    retrievers[f'FOLIO_{err_type}'] = FOLIO_retrievers[err_type]
    
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

result_path = os.path.join(result_save_fpath, f"result-teston-{datetime.now().strftime('%m%d-%H%M%S')}-{llm_name}-unique-samples.json")

with open(result_path, "w+", encoding='utf-8') as f:
    json.dump(test_result, f, indent=2, ensure_ascii=False)
    
print(f"result saved in {result_path}")
print(f"internet issues id: {internet_issues}")