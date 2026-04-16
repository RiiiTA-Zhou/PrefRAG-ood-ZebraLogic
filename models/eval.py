'''
 evaluate the test result
'''

import json

result_path = "./evaluation_result/... .json" # the PrefRAG result to be evaluated
is_baseline = False
bakcup_path = "./baselines/results/... .json" # the CoT backup result path

with open(result_path, "r+", encoding='utf-8') as f:
    result_list = json.load(f)

with open(bakcup_path, "r", encoding='utf-8') as f:
    backup_list = json.load(f)
    
correct_count = 0
exe_success = 0
correct_backup = 0
for i, sample in enumerate(result_list):
    if is_baseline:
        if sample["gold_answer"] in sample["answer"]:
            correct_count += 1
    else:
        program = sample["programs"][-1]
        if program["execution"]["flag"] == "success":
            exe_success += 1
            if sample["gold_answer"] in sample["answer"]:
                correct_count += 1
                correct_backup += 1
        else:
            backup_ans = backup_list[i]["answer"]
            if sample["gold_answer"] in backup_ans:
                correct_backup += 1
                

print(f"total accuracy w/ backup: {correct_backup} / {len(result_list)} = {correct_backup/len(result_list)}")
print(f"total accuracy w/o backup: {correct_count} / {len(result_list)} = {correct_count/len(result_list)}")
if not is_baseline:
    print(f"exec rate: {exe_success} / {len(result_list)} = {exe_success/len(result_list)}")
    print(f"exec acc: {correct_count} / {exe_success} = {correct_count/exe_success}")
