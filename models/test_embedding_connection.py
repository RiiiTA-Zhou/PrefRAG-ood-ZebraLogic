"""
Quick test for the embedding API connection.
Tests both a direct OpenAI call and a DSPy embedding call.
"""

import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from utils.utils import LLMConfig
from utils.LLM_config import LLM_CONFIG
import dspy
import time

embed_cfg = LLM_CONFIG["embedder"]
print(f"Embedder config:")
print(f"  model:    {embed_cfg.llm_name}")
print(f"  base_url: {embed_cfg.base_url}")
print(f"  api_key:  {embed_cfg.api_key[:8]}...{embed_cfg.api_key[-4:]}")

# Test 1: Direct OpenAI API call
print("\n--- Test 1: Direct OpenAI embedding call ---")
from openai import OpenAI
client = OpenAI(api_key=embed_cfg.api_key, base_url=embed_cfg.base_url)
try:
    t0 = time.time()
    response = client.embeddings.create(
        model=embed_cfg.llm_name,
        input="This is a test query for embedding."
    )
    t1 = time.time()
    emb = response.data[0].embedding
    print(f"  OK ({t1-t0:.2f}s) — embedding dim={len(emb)}")
except Exception as e:
    print(f"  FAILED: {type(e).__name__}: {e}")

# Test 2: DSPy embedder with a single string
print("\n--- Test 2: DSPy embedder (single query) ---")
try:
    embedder = dspy.Embedder(
        model=embed_cfg.llm_name,
        api_key=embed_cfg.api_key,
        api_base=embed_cfg.base_url,
        batch_size=10,
    )
    t0 = time.time()
    result = embedder("This is a test query for DSPy embedding.")
    t1 = time.time()
    print(f"  OK ({t1-t0:.2f}s) — result type={type(result).__name__}, len={len(result)}")
except Exception as e:
    print(f"  FAILED: {type(e).__name__}: {e}")

# Test 3: DSPy embedder with a batch (simulating the retrieval scenario)
print("\n--- Test 3: DSPy embedder (batch, simulating retrieval query) ---")
try:
    # Build a query similar to what the RAGFixer would send
    story = "There are 2 houses... Each house has a person and a car..."
    program = """
from z3 import *

# Declarations
house_sort, (house1, house2) = EnumSort('house', ['house1', 'house2'])
person_sort, (Eric, Arnold) = EnumSort('person', ['Eric', 'Arnold'])
car_sort, (tesla, ford) = EnumSort('car', ['tesla', 'ford'])
person_of_house = Function('person_of_house', house_sort, person_sort)
car_of_house = Function('car_of_house', house_sort, car_sort)

# Constraints
pre_conditions = []
pre_conditions.append(Distinct([person_of_house(h) for h in [house1, house2]]))
pre_conditions.append(Distinct([car_of_house(h) for h in [house1, house2]]))
"""
    query = f'# Story\n{story}\n# z3 Program \n{program}\n# Execution Result\n{{"flag": "success"}}'

    t0 = time.time()
    result = embedder(query)
    t1 = time.time()
    print(f"  OK ({t1-t0:.2f}s) — result type={type(result).__name__}, len={len(result)}")
except Exception as e:
    print(f"  FAILED: {type(e).__name__}: {e}")

print("\nDone.")
