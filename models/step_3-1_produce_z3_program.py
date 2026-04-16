'''
    this script produce z3 programs for train data, which would later be used in data augmentation.
'''
import json
from tqdm import tqdm
from utils.utils import LLMConfig, OpenAIModel, execute_logic_program
from utils.LLM_config import LLM_CONFIG
import time
import re
import os
import random
from datetime import datetime

deepseek_chat_config = LLM_CONFIG['dpsk-chat']

gpt_4o_config = LLM_CONFIG['gpt-4o']

# LM for program generation
deepseek_chat_LM = OpenAIModel(deepseek_chat_config, max_new_tokens=2048, temp=0.7)
gpt_4o_LM = OpenAIModel(gpt_4o_config, max_new_tokens=2048, temp=0.7)
LM_list = [deepseek_chat_LM, gpt_4o_LM]

dataset_name = "FOLIO"
train_data_path = f"./benchmarks/{dataset_name}/train.json"
seedset_data_paths = {
    'AR-LSAT': "LTRAG-AR-LSAT-seed-set/LSAT-examples.json",
    'FOLIO': "LTRAG-FOLIO-seed-set/FOLIO-examples.json"
    }
LTRAG_data_path = seedset_data_paths[dataset_name]
result_saved_path = f"./SemanticPref/constructed_data_{dataset_name}/trainset-programs"
prompt_template_path = f"./prompts/z3program_generation_{dataset_name}.txt"



with open(train_data_path, "r", encoding='utf-8') as f:
    train_data_dict = json.load(f)
    
with open(LTRAG_data_path, "r", encoding='utf-8') as f:
    LTRAG_data_dict = json.load(f)
    LTRAG_id_set = {item["id"] for item in LTRAG_data_dict if "id" in item} # the set of ids that their samples have been annotated
    
with open(prompt_template_path, "r", encoding='utf-8') as f:
    generation_prompt_template = f.read()
    
if dataset_name == 'AR-LSAT':
    selected_train_data = random.sample(train_data_dict, 750)  # randomly sample 750 samples to do KB population
elif dataset_name == 'FOLIO':
    selected_train_data = train_data_dict
    
pattern = r"```python(.*?)```"

result_list = []
file_num = 0
for sample in tqdm(selected_train_data):
    if sample["id"] in LTRAG_id_set:   # skip these
        continue
    print(f"******{sample['id']}******")
    NL_context = sample["context"]
    NL_question = sample["question"]
    NL_options = "\n".join(sample["options"])
    gold_answer = sample["answer"]
    NL_story = f"# Context:\n{NL_context}\n# Question:\n{NL_question}\n# Options:\n{NL_options}\n# Answer:\n{gold_answer}"
    
    # generate programs
    generation_prompt = generation_prompt_template.replace("[[CONTEXT]]", NL_context).replace("[[QUESTION]]", NL_question).replace("[[OPTIONS]]", NL_options)
    
    output_programs = []
    print("generating program..")
    for llm in LM_list:
        for attempt in range(3):
            try:
                raw_output = llm.generate(generation_prompt)
                # print(raw_output)
                print(f"{llm.model}: {len(raw_output)}")
                break
            except Exception:
                print(f"{llm.model} generation failed.")
                time.sleep(5)
        program = ""
        try:
            program = re.findall(pattern, raw_output, re.DOTALL)[0].strip()
        except:
            program = raw_output.replace("```python", "").replace("```", "").strip()
        output_programs.append(program)
    
    programs_list = []
    for i, program in enumerate(output_programs):
        if not program.startswith('from z3 import *'):
            program = "from z3 import *\n" + program
        exec_dict = execute_logic_program(program, './models')
        result = {
            "number": i,
            "program": program,
            "execution": exec_dict
        }
        programs_list.append(result)
        
    result = {
                "source_dataset": dataset_name,
                "source_id": sample["id"],
                "context": NL_story,
                "programs": programs_list
            }

    result_list.append(result)
    
    if len(result_list) >= 100:
            # save result
            save_fn = os.path.join(result_saved_path, f'{dataset_name}-{file_num}-{datetime.now().strftime("%y%m%d")}.json')
            with open(save_fn, 'w+', encoding='utf-8') as f:
                json.dump(result_list, f, indent=2, ensure_ascii=False)
            print(f'results are saved in {save_fn}.')
            file_num += 1
            result_list = []
            
if result_list:
    save_fn = os.path.join(result_saved_path, f'{dataset_name}-{file_num}-{datetime.now().strftime("%y%m%d")}.json')
    with open(save_fn, 'w+', encoding='utf-8') as f:
        json.dump(result_list, f, indent=2, ensure_ascii=False)
    print(f'results are saved in {save_fn}.')
    
print("program generation done!")