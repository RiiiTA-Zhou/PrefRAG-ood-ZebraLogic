'''
    this script evaluates baselines(direct, COT, autoformalize) on logiQA and Reclor.
'''

from utils import OpenAIModel, extract_after_phrase, is_option
from LLM_config import LLM_CONFIG
import json
import re
from tqdm import tqdm
import time


#------------SETTING------------

llm_name = "dpsk-reasoner" # ["dpsk-chat", "dpsk-reasoner", "gpt-4o", "o3-mini"]
baseline = 'CoT'  # ['direct', 'CoT']
dataset_name = 'ProverQA'  # ['LogiQA', 'ReClor', 'AR-LSAT', 'ProverQA', 'FOLIO', "LogicalDeduction"]

prompt_template_fpath = f"./baselines/prompts/{dataset_name}_{baseline}.txt"
result_save_fpath = f"./baselines/results/{dataset_name}_{baseline}_{llm_name}.json"

test_fpath = {
    'LogiQA': "./LogiQA/preprocessed/test.json",
    'ReClor': "./ReClor/preprocessed/val.json",
    'AR-LSAT': "./AR-LSAT/dev.json",
    'ProverQA': "./ProverQA/dev/hard.json",
    'FOLIO': "./FOLIO/dev.json",
    'LogicalDeduction': "./LogicalDeduction/dev.json"
}

llm = OpenAIModel(LLM_CONFIG[llm_name], max_new_tokens=2048, temp=0)

#------------SETTING------------

with open(test_fpath[dataset_name], "r+", encoding='utf-8') as f:
    sample_list = json.load(f)

with open(prompt_template_fpath, "r+", encoding='utf-8') as f:
    prompt_template = f.read()
    

result_list = []
internet_issues = []
for sample in tqdm(sample_list):
    print(f"*****{sample['id']}*****")
    options = '\n'.join(sample['options'])
    prompt = prompt_template.replace('[[CONTEXT]]', sample['context']).replace('[[QUESTION]]', sample['question']).replace('[[OPTIONS]]', options)
    is_success = False
    for attempt in range(3):
            try:
                response = llm.generate(prompt)
                print(response)
                is_success = True
                break
            except Exception:
                time.sleep(1)
    if not is_success:
        print(f"connection error.")
        internet_issues.append(sample['id'])
        continue
    try:
        text = extract_after_phrase(response).strip()
        candidate_positions = []
        for match in re.finditer(r'[A-G]', text):
            candidate_positions.append({
                'option': match.group().upper(),
                'position': match.start()
            })
        if not candidate_positions:
            answer = text
        else:
            for candidate in candidate_positions:
                if is_option(candidate, text):
                    answer = candidate['option']
    except:
        try:
            line = response.split('\n')[0]
            answer = re.split(r'[.!?]', line)[0]
        except:
            answer = response
    
    print("------")
    print(answer)
    result = sample
    result['gold_answer'] = sample['answer']
    result['raw_output'] = response
    result['answer'] = answer
    result_list.append(result)
    

with open(result_save_fpath, "w+", encoding='utf-8') as f:
    json.dump(result_list, f, indent=2, ensure_ascii=False)

print(f"baseline {baseline} on {dataset_name} done! result saved in {result_save_fpath}")
print(f"internet error: {internet_issues}")