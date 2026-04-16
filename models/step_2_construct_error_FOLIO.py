'''
    This program calls the ErrorConstruction and construct program pairs with rule-based operations given a seed set.
    outcomes are in ./data/error-programs-result/
    data sample: {
        'source_dataset': dataset_name,
        'source_id': id,
        'pref_id': pref_id,
        'error_type': err_types,
        'context': context,
        'ground_truth': ground_truth,
        'chosen_program': ori_program,
        'rejected_program': error_program,
        'chosen_execution': ori_execution,
        'rejected_execution': exe_result_dict
    }
    ops name: see execute_op
'''

from utils.error_program_constructor_FOLIO import ErrorConstruction
from utils.utils import id_and_saving, execute_logic_program
from utils.LLM_config import LLM_CONFIG
import json
from tqdm import tqdm
import os

cache_dir = './models/.cache_program'
seed_set_file_name = './LTRAG-FOLIO-seed-set/FOLIO-examples.json'
saved_dir = './SemanticPref/constructed_data_FOLIO/rule-based-result'
dataset_name = 'FOLIO'

LLMargs = LLM_CONFIG['dpsk-chat']

with open(seed_set_file_name, 'r+', encoding='utf-8') as file:
    seed_set_list = json.load(file)
    
if not os.path.exists(saved_dir):
    os.makedirs(saved_dir, exist_ok=True)

def execute_op(operation: str, input_program: str, id:str, ground_truth:str, context:str, Fol_formulas:str):
    '''conduct a single op on the input program. the error constructor should be a temperary one.'''
    error_constructor = ErrorConstruction(input_program, dataset_name, id, ground_truth, context, Fol_formulas, LLMargs)
    error_constructor.ori_program = input_program
    error_constructor.parse_program()
    if error_constructor.parse_flag:
        if operation == 'mi':
            error_constructor.missing_info_error()
            return error_constructor.missing_info_error_programs
        elif operation == 'mp':
            error_constructor.mismatch_predicates()
            return error_constructor.mismatch_predicates_err_programs
        elif operation == 'ic':
            error_constructor.inconsistent_pairs()
            return error_constructor.inconsistent_error_programs
    else:
        return []
    

result_list = [[], [], []]
file_nums = [0, 0, 0]
all_types = {'ic', 'mp', 'mi'}

for sample in tqdm(seed_set_list):
    id = sample['id']
    context = sample['context']
    ori_program = sample['Z3program']
    ground_truth = sample['answer']
    Fol_formulas = sample['fol']
    ori_execution = execute_logic_program(ori_program, cache_dir)
    error_constructor = ErrorConstruction(ori_program, dataset_name, id, ground_truth, context, Fol_formulas, LLMargs)
    if not error_constructor.parse_flag:
        print(f"skip {id}.")
        continue
    
    print(f'******{id}******')
    # use BFS to produce combinations of all error types
    processed_combinations = set()
    
    queue = [] 
    err_types = set()
    queue.append((err_types, ori_program))
    
    while queue:
        err_types, program = queue.pop(0)
        if len(err_types) >= 3:
            continue
        
        available_types = all_types - err_types
        
        # conduct an available op on the program to form new programs, then save pair (ori_program, new_program)
        for op in available_types:
            new_types = err_types | {op}
            new_types_frozen = frozenset(new_types)
            if new_types_frozen in processed_combinations:
                continue
            else:
                processed_combinations.add(new_types_frozen)
            try:
                new_programs = execute_op(op, program, id, ground_truth, context, Fol_formulas)
                types_num = len(new_types)
                print(f'{new_types} produce {len(new_programs)} programs')
                
                for iter, new_program in enumerate(new_programs):
                    sorted_types = sorted(new_types)
                    pref_id = f"{id}_{'_'.join(sorted_types)}_{iter}"
                    NL_context = f"# Context: {sample['context']}\n\n# Question: {sample['question']}\n\n# Options:\n{'\n'.join(sample['options'])}"
                    pair_result_dict = id_and_saving(context, ori_program, new_program, dataset_name, id, pref_id, new_types, ground_truth, ori_execution, cache_dir)
                    result_list[types_num-1].append(pair_result_dict)
                    queue.append((new_types, new_program))
            except:
                print(f'an error somehow occurred when {new_types}. skip this.')
                processed_combinations.remove(new_types_frozen)
                
    # save result  
    for i, result in enumerate(result_list):
        if len(result) >= 200:
            save_fn = os.path.join(saved_dir, f'types-{i+1}', f'{dataset_name}-{file_nums[i]}.json')
            with open(save_fn, 'w+', encoding='utf-8') as f:
                json.dump(result, f, indent=2, ensure_ascii=False)
            print(f'results are saved in {save_fn}.')
            file_nums[i] += 1
            result_list[i] = []
            
for i, result in enumerate(result_list):
    if result:
        save_fn = os.path.join(saved_dir, f'types-{i+1}', f'{dataset_name}-{file_nums[i]}.json')
        with open(save_fn, 'w+', encoding='utf-8') as f:
            json.dump(result, f, indent=2, ensure_ascii=False)
        print(f'results are saved in {save_fn}.')
    


    
    