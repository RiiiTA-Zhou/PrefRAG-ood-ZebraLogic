'''
    this script transform the fol formula in LTRAG's FOLIO translation kb into z3 programs
'''

from utils.utils import OpenAIModel, execute_logic_program
from utils.LLM_config import LLM_CONFIG
import json
import re
from tqdm import tqdm


kb_path = "./LTRAG-FOLIO-seed-set/FOLIO-translation.json"
prompt_path = "./LTRAG-FOLIO-seed-set/prompt-fol2z3.txt"
result_path = "./LTRAG-FOLIO-seed-set/FOLIO-llm-translation.json"

llm = OpenAIModel(LLM_CONFIG['dpsk-chat'], max_new_tokens=2048, temp=0)

with open(kb_path, "r+") as f:
    kb_list = json.load(f)
    
with open(prompt_path, "r+") as f:
    prompt_template = f.read()

pattern = r"```python(.*?)```"

result_list = []
for sample in tqdm(kb_list):
    prompt = prompt_template.replace('[[CONTEXT]]', sample['context']).replace('[[QUESTION]]', sample['question']).replace('[[FOL]]', sample['fol'])
    output = llm.generate(prompt)
    try:
        program = re.findall(pattern, output, re.DOTALL)[0].strip()
    except:
        program = output.replace("```python", "").replace("```", "").strip()
    if not program.startswith('from z3 import *'):
        program = "from z3 import *\n" + program
    exec_dict = execute_logic_program(program, './models')
    flag = False        
    if exec_dict["flag"] == "success":
        answer = exec_dict["result"][0]
        if sample['answer'] in answer:
            flag = True
    
    result = sample
    result['Z3program'] = program
    result['program_execution'] = exec_dict
    result['program_flag'] = flag
    
    result_list.append(result)
    
with open(result_path, "w+") as f:
    json.dump(result_list, f, ensure_ascii=False, indent=2)

print("FOLIO transformation done!")