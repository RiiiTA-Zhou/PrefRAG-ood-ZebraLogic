from openai import OpenAI
import re
import os
import subprocess
from subprocess import check_output
from dataclasses import dataclass

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
    

def execute_logic_program(logic_program, cache_dir):
    '''
        cache_dir: a directory where can allow a temp file
        execute the z3 python program, return execution_dict:
        flag: the state of execution result
        error_msg: detail info when error occur
        result: program output if success (list)
    '''
    filename = os.path.join(cache_dir, 'tmp.py')
    with open(filename, "w") as f:
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
        pattern = r'File "([^"]+)"(, line \d+, .*)'
        error_msg = re.sub(pattern, r'File "<removed>"\2', error_msg)
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


def extract_after_phrase(text, phrases=None):
    """
    extract the first sentence after indicating phrases
    """
    if phrases is None:
        phrases = ["correct option is", "correct answer is"]
    
    text = text.strip()
    
    pattern = r'(?:' + '|'.join(phrases) + r')\s*[.:]?\s*([^.!?]+)'
    
    match = re.search(pattern, text, re.IGNORECASE)
    if match:
        return match.group(1).strip()
    
    return text

def is_option(candidate:dict, text:str):
    '''
    check if the candidate is an option answer
    '''
    pos = candidate['position']
    option = candidate['option']
    # check left side: if the option is the beginning or if it follows a space
    left_valid = False
    if pos == 0:  # beginning
        left_valid = True
    else:
        left_char = text[pos-1]
        # follows a space or left brackets or markdown format
        if left_char.isspace() or left_char in '([{*':
            left_valid = True
    
    # right side: if the option is the and of if it is followed by a space
    right_valid = False
    if pos == len(text) - 1:  # at the end
        right_valid = True
    else:
        right_char = text[pos+1]
        # followed by space or bracket or period or markdown format
        if right_char in ').:、，,;!?*':
            right_valid = True
        elif right_char.isspace():
            right_valid = True
    
    if left_valid and right_valid:
        return True
    
    return False