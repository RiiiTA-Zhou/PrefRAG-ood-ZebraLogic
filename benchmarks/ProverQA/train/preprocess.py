'''
This script transform the format of train set
'''

import json

origin_fpath = "./ProverQA/train/provergen-5000.json"
result_fpath = "./ProverQA/train/train.json"

with open(origin_fpath, "r+") as f:
    sample_list = json.load(f)

result_list = []
id = 0
for sample in sample_list:
    id += 1
    instruction = sample["instruction"]
    parts = instruction.split("\n\nQuestion:")
    context = parts[0].replace("Context:\n", "").strip()
    parts = parts[1].split("\n\nOptions:\n")
    question = parts[0].replace("\n\nQuestion:", "").strip()
    options = parts[1].strip().split("\n")
    
    output = sample["output"]
    try:
        output_dict = json.loads(output)
    except:
        print(output)
        break
    reasoning = output_dict["reasoning"].strip()
    answer = output_dict["answer"].strip()

    result = {
        "id": f"train_{id}",
        "context": context,
        "question": question,
        "options": options,
        "answer": answer,
        "reasoning": reasoning
    }
    result_list.append(result)


with open(result_fpath, "w+") as f:
    json.dump(result_list, f, ensure_ascii=False, indent=2)