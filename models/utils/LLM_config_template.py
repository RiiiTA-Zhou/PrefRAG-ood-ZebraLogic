'''
    !!ATTENTION!!  HANDLE WITH CARE
    This file stores the llm configs and api key.
'''

from utils.utils import LLMConfig

APIS = {
    'qdd': {
        'url': 'https://api2.aigcbest.top/v1', 
        'api_key': "sk-"
        },
    'v3': {
        'url': 'https://api.gpt.ge/v1',
        'api_key': "sk-"
        },
    'dpsk': {
        'url': 'https://api.deepseek.com/v1',
        'api_key': 'sk-'
    }
}

api = APIS['v3']

LLM_CONFIG = {
    "dpsk-chat": LLMConfig(
    api_key= APIS['dpsk']['api_key'],
    llm_name= 'deepseek-chat',
    base_url= APIS['dpsk']['url']
    ),
    "dpsk-reasoner": LLMConfig(
    api_key= APIS['dpsk']['api_key'],
    llm_name= 'deepseek-reasoner',
    base_url= APIS['dpsk']['url'],
    is_reasoning= True
    ),
    "gpt-4o": LLMConfig(
    api_key= api['api_key'],
    llm_name= 'gpt-4o',
    base_url = api['url']
    ),
    "o3-mini": LLMConfig(
    api_key= APIS['qdd']['api_key'],
    llm_name= "o3-mini",
    base_url = APIS['qdd']['url'],
    is_reasoning=True
    ),
    "embedder": LLMConfig(
    api_key= APIS['qdd']['api_key'],
    llm_name= "text-embedding-3-large",
    base_url = APIS['qdd']['url']
    )
}