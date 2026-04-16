'''
    this script run the RAG judge on train set to populate the KB.
'''

import json
from utils.LLM_config import LLM_CONFIG
import dspy
import os
import random
import time
from tqdm import tqdm
from datetime import datetime



dataset_name = "FOLIO"

train_program_fpath = f"./SemanticPref/constructed_data_{dataset_name}/trainset-programs/"
result_saved_path = f"./SemanticPref/constructed_data_{dataset_name}/data-augmentation-result/"

KB_fpath = f"./SemanticPref/constructed_data_{dataset_name}/rule-based-result"
corpus_template_fpath = f"./prompts/corpus_for_RAG_template_{dataset_name}.json"


dpsk_reasoner_LLMargs = LLM_CONFIG['dpsk-reasoner']

dpsk_chat_LLMargs = LLM_CONFIG['dpsk-chat']

embedder_config = LLM_CONFIG['embedder']

dpsk_reasoner_lm = dspy.LM(model=dpsk_reasoner_LLMargs.llm_name, api_base=dpsk_reasoner_LLMargs.base_url, api_key=dpsk_reasoner_LLMargs.api_key, max_tokens=5000, temperature=1.0)
dpsk_chat_lm = dspy.LM(model=dpsk_chat_LLMargs.llm_name, api_base=dpsk_chat_LLMargs.base_url, api_key=dpsk_chat_LLMargs.api_key, max_tokens=2048, temperature=0.5)

dspy.configure(lm=dpsk_reasoner_lm)

with open(corpus_template_fpath, "r+", encoding='utf-8') as f:
    template = json.load(f)
corpus_template = [template["first_chosen"], template["second_chosen"]]
error_descrip_template = template["error_description"]

# constructing KB
KB_data = []
subdics = os.listdir(KB_fpath)
for dic in subdics:
    fpath = os.path.join(KB_fpath, dic)
    if os.path.isdir(fpath):
        for fname in os.listdir(fpath):
            fname = os.path.join(fpath, fname)
            with open(fname, 'r+', encoding='utf-8') as f:
                data = json.load(f)
            KB_data.extend(data)
            
if dataset_name == 'AR-LSAT':
    missing_info_corpus = []
    declaration_err_corpus = []
    inconsistent_corpus = []
    corpus_catogories = {
        'mi':[],
        'e2i':[],
        'i2e':[],
        'ic':[]
    }
    for sample in KB_data:
        template_num = random.randint(0, 1)
        err_types = sample['error_type']
        err_types_text = ''
        for i, err_type in enumerate(err_types):
            error_descrip = error_descrip_template[err_type].replace('[[NUMBER]]', str(1-template_num+1))
            err_types_text += f"{i+1}. {error_descrip}\n"
        NL_context = sample['context']
        chosen_program = sample["chosen_program"]
        rejected_program = sample["rejected_program"]
        chosen_result = str(sample["chosen_execution"])
        rejected_result = str(sample["rejected_execution"])
        text = corpus_template[template_num].replace("[[CONTEXT]]", NL_context).replace("[[CHOSEN_PROGRAM]]", chosen_program).replace("[[REJECTED_PROGRAM]]", rejected_program).replace("[[CHOSEN_EXEC]]", chosen_result).replace("[[REJECTED_EXEC]]", rejected_result).replace("[[ERRORTYPE]]", err_types_text)
        for err_type in err_types:
            corpus_catogories[err_type].append(text)
        
    missing_info_corpus = corpus_catogories["mi"]
    declaration_err_corpus = corpus_catogories["e2i"] + corpus_catogories["i2e"]
    inconsistent_corpus = corpus_catogories["ic"]

    print(f"RAG corpus loaded.\n  missing info: {len(missing_info_corpus)}\n  declaration error: {len(declaration_err_corpus)}\n  inconsistency: {len(inconsistent_corpus)}")
    
    
elif dataset_name == 'FOLIO':
    missing_info_corpus = []
    inconsistent_corpus = []
    mismatch_predicate_corpus = []
    corpus_catogories = {
        'mi':[],
        'ic':[],
        'mp':[]
    }
    for sample in KB_data:
        template_num = random.randint(0, 1)
        err_types = sample['error_type']
        err_types_text = ''
        for i, err_type in enumerate(err_types):
            error_descrip = error_descrip_template[err_type].replace('[[NUMBER]]', str(1-template_num+1))
            err_types_text += f"{i+1}. {error_descrip}\n"
        NL_context = sample['context']
        chosen_program = sample["chosen_program"]
        rejected_program = sample["rejected_program"]
        chosen_result = str(sample["chosen_execution"])
        rejected_result = str(sample["rejected_execution"])
        text = corpus_template[template_num].replace("[[CONTEXT]]", NL_context).replace("[[CHOSEN_PROGRAM]]", chosen_program).replace("[[REJECTED_PROGRAM]]", rejected_program).replace("[[CHOSEN_EXEC]]", chosen_result).replace("[[REJECTED_EXEC]]", rejected_result).replace("[[ERRORTYPE]]", err_types_text)
        for err_type in err_types:
            corpus_catogories[err_type].append(text)
        
    missing_info_corpus = corpus_catogories["mi"]
    mismatch_predicate_corpus = corpus_catogories["mp"]
    inconsistent_corpus = corpus_catogories["ic"]


    print(f"RAG corpus loaded.\n  missing info: {len(missing_info_corpus)}\n  misused predicates: {len(mismatch_predicate_corpus)}\n  inconsistency: {len(inconsistent_corpus)}")

# embedder
embedder = dspy.Embedder(model=embedder_config.llm_name, api_key=embedder_config.api_key, api_base=embedder_config.base_url)
topk_to_retrieve = 2

# retrivers
if dataset_name == 'AR-LSAT':
    print("embedding...")
    start_time = time.time()
    missinfo_search = dspy.retrievers.Embeddings(embedder=embedder, corpus=missing_info_corpus, k=topk_to_retrieve)
    mi_time = time.time()
    print(f"missing info embeddings done, time: {mi_time-start_time : .4f} seconds")
    declarerr_search = dspy.retrievers.Embeddings(embedder=embedder, corpus=declaration_err_corpus, k=topk_to_retrieve)
    dc_time = time.time()
    print(f"declaration err embeddings done, time: {dc_time-mi_time : .4f} seconds")
    inconsis_search = dspy.retrievers.Embeddings(embedder=embedder, corpus=inconsistent_corpus, k=topk_to_retrieve)
    ic_time = time.time()
    print(f"inconsis embeddings done, time: {ic_time-dc_time : .4f} seconds")
    print(f"Embeddings are done. total time: {ic_time-start_time : .4f} seconds")
elif dataset_name == 'FOLIO':
    print("embedding...")
    start_time = time.time()
    missinfo_search = dspy.retrievers.Embeddings(embedder=embedder, corpus=missing_info_corpus, k=topk_to_retrieve)
    mi_time = time.time()
    print(f"missing info embeddings done, time: {mi_time-start_time : .4f} seconds")
    mispreds_search = dspy.retrievers.Embeddings(embedder=embedder, corpus=mismatch_predicate_corpus, k=topk_to_retrieve)
    mp_time = time.time()
    print(f"mismatch preds embeddings done, time: {mp_time-mi_time : .4f} seconds")
    inconsis_search = dspy.retrievers.Embeddings(embedder=embedder, corpus=inconsistent_corpus, k=topk_to_retrieve)
    ic_time = time.time()
    print(f"inconsis embeddings done, time: {ic_time-mp_time : .4f} seconds")
    print(f"Embeddings are done. total time: {ic_time-start_time : .4f} seconds")

# RAG module as judge
class RAGJudge(dspy.Module):
    def __init__(self, dataset_name:str):
        self.dataset_name = dataset_name
        self.respond = dspy.ChainOfThought("sample, question -> judgement:int, explanation:str")
        
    def forward(self, NL_story, program1, program2):
        query = f'# Story\n{NL_story}\n\n# z3 Program 1\n{program1["program"]}\n# Execution Result\n{program1["execution"]}\n# z3 Program 2\n{program2["program"]}\n# Execution Result\n{program2["execution"]}\n'
        question = f'{query}\nFor the given story, we have two Z3 logic programs using python API. The program might contain syntactic errors raising errors during execution, whose details can be detected by the execution result; they might also contain semantic errors, including wrong declaration of sorts or functions, missing constraints, inconsistent NL-SL constraint pairs, etc. Which one is preferred and has less errors, program 1 or program 2? Output the number 1 or 2 as the final judgement, then output an detailed explanation for it.'
        if self.dataset_name == 'AR-LSAT':
            mi_sample = missinfo_search(query).passages
            dc_sample = declarerr_search(query).passages
            ic_sample = inconsis_search(query).passages
            all_sample = mi_sample + dc_sample + ic_sample
        elif self.dataset_name == 'FOLIO':
            mi_sample = missinfo_search(query).passages
            mp_sample = mispreds_search(query).passages
            ic_sample = inconsis_search(query).passages
            all_sample = mi_sample + mp_sample + ic_sample
        rag_samples = []
        appeared_samples = set()
        for sample in all_sample:
            if sample not in appeared_samples:
                rag_samples.append(sample)
                appeared_samples.add(sample)
        return self.respond(sample = rag_samples, question = question), rag_samples
     
Judge = RAGJudge(dataset_name)

programs_list = []
fnames = os.listdir(train_program_fpath)
for fname in fnames:
    fpath = os.path.join(train_program_fpath, fname)
    if os.path.isfile(fpath):
        with open(fpath, "r+", encoding='utf-8') as f:
            data = json.load(f)
        programs_list.extend(data)

file_num = 0
result_list = []
for sample in tqdm(programs_list):
    print(f"*****{sample['source_id']}*****")
    NL_story = sample["context"]
    program1 = sample["programs"][0]
    program2 = sample["programs"][1]
    dspy.configure(lm=dpsk_reasoner_lm)
    for attempt in range(3):  # trying dpsk_reasoner
        try:
            response, rag_samples = Judge(NL_story, program1, program2)
            # response = Prediction(reasoning:str, judgement:int, explanation:str)
            print(f"rag_samples num: {len(rag_samples)}")
            break
        except Exception:
            time.sleep(1)
    print(f"dpsk reasoner's response:\n{response}")
    if response == None or response.judgement == None:
        print("reaonser's response is null, switch to dpsk chat")
        dspy.configure(lm=dpsk_chat_lm)
        for attempt in range(3):  # trying dpsk_reasoner
            try:
                response, rag_samples = Judge(NL_story, program1, program2)
                # response = Prediction(reasoning:str, judgement:int, explanation:str)
                print(f"rag_samples num: {len(rag_samples)}")
                break
            except Exception:
                time.sleep(1)
        print(f"dpsk chat's response:\n{response}")
    if response.judgement == 1:
        chosen_program = program1
        rejected_program = program2
    else:
        chosen_program = program2
        rejected_program = program1
        
    result = {
        "source_dataset": dataset_name,
        "source_id": sample['source_id'],
        "pref_id": f"{sample['source_id']}_da_0",
        "context": NL_story,
        "chosen_program": chosen_program["program"],
        "rejected_program": rejected_program["program"],
        "chosen_execution": chosen_program["execution"],
        "rejected_execution": rejected_program["execution"],
        "chosen_number": response.judgement,
        "explanation": response.explanation
    }
    result_list.append(result)
    
    if len(result_list) >= 50:
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
    
print("data augmentation done!")