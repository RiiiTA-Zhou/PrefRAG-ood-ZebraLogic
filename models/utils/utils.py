from openai import OpenAI
import re
import os
import subprocess
import json
import random
from dataclasses import dataclass
import time
import dspy

@dataclass
class LLMConfig:
    api_key: str
    llm_name: str = 'deepseek-chat'
    base_url: str = 'https://api.deepseek.com/v1'
    stop_words: str = '------'
    is_reasoning: bool = False

class OpenAIModel:
    '''call llm through openai api'''
    def __init__(self, llmconfig:LLMConfig, max_new_tokens = 1024, temp:float=0):
        self.api_key = llmconfig.api_key
        self.model = llmconfig.llm_name
        self.is_reasoning = llmconfig.is_reasoning
        self.stop_words = llmconfig.stop_words
        self.max_new_tokens = max_new_tokens
        self.temp = temp
        self.api_base_url = llmconfig.base_url

    def generate(self, prompt):
        '''num_of_ans: the number of answers that the model returns'''
        client = OpenAI(api_key=self.api_key, base_url=self.api_base_url)
        if not self.is_reasoning:
            response = client.chat.completions.create(
                model=self.model,
                messages=[
                    {"role": "user", "content": prompt},
                ],
                stream=False,
                max_tokens= self.max_new_tokens,
                temperature= self.temp
            )
        else:   # if it is a reasoning model, then do not set max tokens
            response = client.chat.completions.create(
                model=self.model,
                messages=[
                    {"role": "user", "content": prompt},
                ],
                stream=False,
                temperature= self.temp
            )
        return response.choices[0].message.content
    

def execute_logic_program(logic_program, cache_dir='./models/.cache_program'):
    '''
        cache_dir: a directory where can allow a temp file
        execute the z3 python program, return execution_dict:
        flag: the state of execution result
        error_msg: detail info when error occur
        result: program output if success (list)
    '''
    if not os.path.isdir(cache_dir):
        os.makedirs(cache_dir)
    filename = os.path.join(cache_dir, 'tmp.py')
    with open(filename, "w", encoding='utf-8') as f:
        f.write(logic_program)
    try:        
        solver_output = subprocess.run(
            ['python', filename],
            text = True,
            capture_output = True,
            check = True,
            timeout= 3.0
        )
        result = solver_output.stdout.splitlines()
        # z3 program output if no syntax error occurs. might contain multiple answers.
        if result == []:
            flag = 'semantic error'
            error_msg = 'No Output'
        else:
            flag = 'success'
            error_msg = ''
    except subprocess.CalledProcessError as e:
        flag = 'execution error'
        error_msg = e.stderr
        error_msg = re.sub(r'File "([^"]+)"', 'File "<removed>"', error_msg) # delete file path from error msg
        result = []
    except subprocess.TimeoutExpired as e:
        flag = 'execution error'
        error_msg = 'Timeout Error'
        result = []
    execution_dict = {
        'flag': flag,
        'error_msg': error_msg,
        'result': result
    }
    return execution_dict



def id_and_saving(context, question, ori_program, error_program, dataset_name, id, pref_id, err_types, ground_truth, ori_execution, cache_dir):
    '''
        for error construction, execute the error program. return a dict that is ready for storage.
    '''
    exe_result_dict = execute_logic_program(error_program, cache_dir)
    if dataset_name == 'AR-LSAT':
        pair_result = {
            'source_dataset': dataset_name,
            'source_id': id,
            'pref_id': pref_id,
            'error_type': list(err_types),
            'context': context,
            'ground_truth': ground_truth,
            'chosen_program': ori_program,
            'rejected_program': error_program,
            'chosen_execution': ori_execution,
            'rejected_execution': exe_result_dict
        }
    elif dataset_name == 'FOLIO':
        pair_result = {
            'source_dataset': dataset_name,
            'source_id': id,
            'pref_id': pref_id,
            'error_type': list(err_types),
            'context': context,
            'question': question,
            'ground_truth': ground_truth,
            'chosen_program': ori_program,
            'rejected_program': error_program,
            'chosen_execution': ori_execution,
            'rejected_execution': exe_result_dict
        }
    
    return pair_result


def loading_pairs(data_fpath:str):
    '''loading step 2 data'''
    KB_data = []
    subdics = os.listdir(data_fpath)
    for dic in subdics:
        fpath = os.path.join(data_fpath, dic)
        if os.path.isdir(fpath):
            for fname in os.listdir(fpath):
                fname = os.path.join(fpath, fname)
                with open(fname, 'r+', encoding='utf-8') as f:
                    data = json.load(f)
                KB_data.extend(data)
    return KB_data

def pairs_to_corpus_ARLSAT(KB_data:list[dict], error_descrip_template:dict, corpus_template:list[str]):
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
        err_descrip_text = ''
        for i, err_type in enumerate(err_types):
            error_descrip = error_descrip_template[err_type].replace('[[NUMBER]]', str(1-template_num+1))
            err_descrip_text += f"{i+1}. {error_descrip}\n"
        NL_context = sample['context']
        chosen_program = sample["chosen_program"]
        rejected_program = sample["rejected_program"]
        chosen_result = str(sample["chosen_execution"])
        rejected_result = str(sample["rejected_execution"])
        text = corpus_template[template_num].replace("[[CONTEXT]]", NL_context).replace("[[CHOSEN_PROGRAM]]", chosen_program).replace("[[REJECTED_PROGRAM]]", rejected_program).replace("[[CHOSEN_EXEC]]", chosen_result).replace("[[REJECTED_EXEC]]", rejected_result).replace("[[ERRORTYPE]]", err_descrip_text)
        for err_type in err_types:
            corpus_catogories[err_type].append(text)
        
    missing_info_corpus = corpus_catogories["mi"]
    declaration_err_corpus = corpus_catogories["e2i"] + corpus_catogories["i2e"]
    inconsistent_corpus = corpus_catogories["ic"]
    
    print(f"AR-LSAT RAG corpus loaded.\n  missing info: {len(missing_info_corpus)}\n  declaration error: {len(declaration_err_corpus)}\n  inconsistency: {len(inconsistent_corpus)}")
    
    return {
        'mi': missing_info_corpus,
        'dc': declaration_err_corpus,
        'ic': inconsistent_corpus
    }

def pairs_to_corpus_FOLIO(KB_data:list[dict], error_descrip_template:dict, corpus_template:list[str]):
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
        err_descrip_text = ''
        for i, err_type in enumerate(err_types):
            error_descrip = error_descrip_template[err_type].replace('[[NUMBER]]', str(1-template_num+1))
            err_descrip_text += f"{i+1}. {error_descrip}\n"
        NL_context = sample['context']
        chosen_program = sample["chosen_program"]
        rejected_program = sample["rejected_program"]
        chosen_result = str(sample["chosen_execution"])
        rejected_result = str(sample["rejected_execution"])
        text = corpus_template[template_num].replace("[[CONTEXT]]", NL_context).replace("[[CHOSEN_PROGRAM]]", chosen_program).replace("[[REJECTED_PROGRAM]]", rejected_program).replace("[[CHOSEN_EXEC]]", chosen_result).replace("[[REJECTED_EXEC]]", rejected_result).replace("[[ERRORTYPE]]", err_descrip_text)
        for err_type in err_types:
            corpus_catogories[err_type].append(text)
        
    missing_info_corpus = corpus_catogories["mi"]
    mismatch_predicate_corpus = corpus_catogories["mp"]
    inconsistent_corpus = corpus_catogories["ic"]

    print(f"FOLIO RAG corpus loaded.\n  missing info: {len(missing_info_corpus)}\n  mismatched predicates: {len(mismatch_predicate_corpus)}\n  inconsistency: {len(inconsistent_corpus)}")
    
    return {
        'mi': missing_info_corpus,
        'mp': mismatch_predicate_corpus,
        'ic': inconsistent_corpus
    }
    

def data_aug_loading(KB_fpath:str):
    step3_corpus = []
    for fname in os.listdir(KB_fpath):
        with open(os.path.join(KB_fpath, fname), "r+", encoding='utf-8') as f:
            data = json.load(f)
        for sample in data:
            NL_story = sample["context"]
            chosen_program = sample["chosen_program"]
            rejected_program = sample["rejected_program"]
            chosen_result = sample["chosen_execution"]
            rejected_result = sample["rejected_execution"]
            chosen_num = sample["chosen_number"]
            explanation = sample["explanation"]
            
            if chosen_num == 1:
                text = f"For the given story, we have two Z3 logic programs using python API.\n{NL_story}\n# Program 1:\n{chosen_program}\nExecution Result:\n{chosen_result}\n# Program 2: {rejected_program}\nExecution Result:\n{rejected_result}\nThe first program is preferred than the second one, because:\n {explanation}"
            else:
                text = f"For the given story, we have two Z3 logic programs using python API.\n{NL_story}\n# Program 1:\n{rejected_program}\nExecution Result:\n{rejected_result}\n# Program 2: {chosen_program}\nExecution Result:\n{chosen_result}\nThe first program is preferred than the second one, because:\n {explanation}"
                
            step3_corpus.append(text)
    
    print(f"dataug corpus loaded.\n  data augmentation: {len(step3_corpus)}")
    
    return step3_corpus


def loading_kb_with_da(dataset_name:str):
    '''return ready-to-go KB (a dict) with da for the dataset.
        dataset_name: ['AR-LSAT', 'FOLIO']'''
        
    corpus_template_fpath = f"./prompts/corpus_for_RAG_template_{dataset_name}.json"
    step2_KB_fpath = f"./SemanticPref/constructed_data_{dataset_name}/rule-based-result"
    step3_KB_fpath = f"./SemanticPref/constructed_data_{dataset_name}/data-augmentation-result/"
        
    pairs_to_corpus = {
        'AR-LSAT': pairs_to_corpus_ARLSAT,
        'FOLIO': pairs_to_corpus_FOLIO
    }
    # loading step2's template
    with open(corpus_template_fpath, "r+", encoding='utf-8') as f:
        template = json.load(f)
    corpus_template = [template["first_chosen"], template["second_chosen"]]
    error_descrip_template = template["error_description"]
    # loading step 2 data
    step2_KB_data = loading_pairs(step2_KB_fpath)
    # turning data into corpus for KB
    corpus_dict = pairs_to_corpus[dataset_name](step2_KB_data, error_descrip_template, corpus_template)
    # loading step 3 data
    step3_corpus = data_aug_loading(step3_KB_fpath)
    corpus_dict['da'] = step3_corpus
    
    return corpus_dict


def get_retrievers_ARLSAT(corpus_dict, embedder:dspy.Embedder, topk_to_retrieve:int, with_da=False):
    '''with_da: if data augmentation is loaded.'''
    start_time = time.time()
    missinfo_search = dspy.retrievers.Embeddings(embedder=embedder, corpus=corpus_dict['mi'], k=topk_to_retrieve)
    mi_time = time.time()
    print(f"missing info embeddings done, time: {mi_time-start_time : .4f} seconds")
    declarerr_search = dspy.retrievers.Embeddings(embedder=embedder, corpus=corpus_dict['dc'], k=topk_to_retrieve)
    dc_time = time.time()
    print(f"declaration err embeddings done, time: {dc_time-mi_time : .4f} seconds")
    inconsis_search = dspy.retrievers.Embeddings(embedder=embedder, corpus=corpus_dict['ic'], k=topk_to_retrieve)
    ic_time = time.time()
    print(f"inconsis embeddings done, time: {ic_time-dc_time : .4f} seconds")
    if with_da:
        da_start_time = time.time()
        dataug_search = dspy.retrievers.Embeddings(embedder=embedder, corpus=corpus_dict['da'], k=topk_to_retrieve)
        da_time = time.time()
        print(f"dataug embeddings done, time: {da_time-da_start_time : .4f} seconds")
        print(f"Embeddings are done. total time: {da_time-da_start_time+ic_time-start_time : .4f} seconds")
        
        return {
            'mi': missinfo_search,
            'dc': declarerr_search,
            'ic': inconsis_search,
            'da': dataug_search
        }
    # else
    print(f"Embeddings are done. total time: {ic_time-start_time : .4f} seconds")

    return {
        'mi': missinfo_search,
        'dc': declarerr_search,
        'ic': inconsis_search
    }


def get_retrievers_FOLIO(corpus_dict, embedder:dspy.Embedder, topk_to_retrieve:int, with_da=False):
    '''with_da: if data augmentation is loaded.'''
    start_time = time.time()
    missinfo_search = dspy.retrievers.Embeddings(embedder=embedder, corpus=corpus_dict['mi'], k=topk_to_retrieve)
    mi_time = time.time()
    print(f"missing info embeddings done, time: {mi_time-start_time : .4f} seconds")
    mispreds_search = dspy.retrievers.Embeddings(embedder=embedder, corpus=corpus_dict['mp'], k=topk_to_retrieve)
    mp_time = time.time()
    print(f"mismatch preds embeddings done, time: {mp_time-mi_time : .4f} seconds")
    inconsis_search = dspy.retrievers.Embeddings(embedder=embedder, corpus=corpus_dict['ic'], k=topk_to_retrieve)
    ic_time = time.time()
    print(f"inconsis embeddings done, time: {ic_time-mp_time : .4f} seconds")
    if with_da:
        da_start_time = time.time()
        dataug_search = dspy.retrievers.Embeddings(embedder=embedder, corpus=corpus_dict['da'], k=topk_to_retrieve)
        da_time = time.time()
        print(f"dataug embeddings done, time: {da_time-da_start_time : .4f} seconds")
        print(f"Embeddings are done. total time: {da_time-da_start_time+ic_time-start_time : .4f} seconds")
        
        return {
            'mi': missinfo_search,
            'mp': mispreds_search,
            'ic': inconsis_search,
            'da': dataug_search
        }
    # else
    print(f"Embeddings are done. total time: {ic_time-start_time : .4f} seconds")
    
    return {
        'mi': missinfo_search,
        'mp': mispreds_search,
        'ic': inconsis_search
    }


class RAGFixer(dspy.Module):
    def __init__(self, dataset_name:str, retrievers):
        self.dataset_name = dataset_name
        self.retrievers = retrievers
        self.respond = dspy.ChainOfThought("sample, question -> response")
        
    def forward(self, NL_story, program):
        query = f'# Story\n{NL_story}\n# z3 Program \n{program["program"]}\n# Execution Result\n{program["execution"]}'
        question = f'{query}\nFor the given story, we have a Z3 logic program using python API. The program might constain syntactic errors raising errors during execution, whose details can be detected by the execution result; they might also contain semantic errors, including wrong declaration of sorts or functions, missing information, inconsistent NL2SL constraint pairs, etc. Is the program correct, and does it clearly convey the story? If so, output this sentence exactly: "There is no error." If not, output the whole corrected program.'
        
        all_samples = []
        for type in self.retrievers:
            samples = self.retrievers[type](query).passages
            all_samples.extend(samples)

        rag_samples = []  # union set
        appeared_samples = set()
        for sample in all_samples:
            if sample not in appeared_samples:
                rag_samples.append(sample)
                appeared_samples.add(sample)
        try:
            response = self.respond(sample = rag_samples, question = question)
            return response, rag_samples
        except:
            print("no response")
            return None, rag_samples