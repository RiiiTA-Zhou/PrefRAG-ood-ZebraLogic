'''
this script tests with RAG module on ZebraLogic benchmark (grid_mode).
Translator generates Z3 programs; RAG fixer corrects them.
Answer is a JSON list of dicts (one per house), compared after normalization.

Supports checkpoint/resume: results are appended to a fixed JSONL file.
If interrupted, re-run the script and it will skip already-processed samples.
'''

from utils.utils import OpenAIModel, execute_logic_program, loading_kb_with_da, RAGFixer
from utils.LLM_config import LLM_CONFIG
import os
import json
import dspy
import random
import ast
from tqdm import tqdm
import time
import re
import argparse
from datetime import datetime

# ------------ SETTING ------------
parser = argparse.ArgumentParser(description="Test RAG-as-fixer on ZebraLogic")
parser.add_argument("--llm", type=str, default="dpsk-chat",
                    choices=["gpt-4o", "dpsk-chat", "dpsk-reasoner", "o3-mini"],
                    help="Model name (must match a key in LLM_CONFIG)")
args = parser.parse_args()

embedder_config = LLM_CONFIG["embedder"]
llm_name = args.llm
dataset_name = "ZebraLogic"

data_fpath = "./benchmarks/ZebraLogic/grid_mode_sampled.json"
result_save_dir = f"./evaluation_result/RAG-fixer-{dataset_name}"
os.makedirs(result_save_dir, exist_ok=True)
# Fixed JSONL path for checkpoint/resume
result_jsonl_path = os.path.join(result_save_dir, f"result-{llm_name}.jsonl")

# translator prompt
gen_prompt_path = "./prompts/z3program_generation_ZebraLogic.txt"


llm = OpenAIModel(LLM_CONFIG[llm_name], max_new_tokens=2048, temp=0)

if not LLM_CONFIG[llm_name].is_reasoning:
    dspy.configure(lm=dspy.LM(model=LLM_CONFIG[llm_name].llm_name,
                  api_base=LLM_CONFIG[llm_name].base_url,
                  api_key=LLM_CONFIG[llm_name].api_key,
                  max_tokens=2048, temperature=0))
else:
    dspy.configure(lm=dspy.LM(model=LLM_CONFIG[llm_name].llm_name,
                  api_base=LLM_CONFIG[llm_name].base_url,
                  api_key=LLM_CONFIG[llm_name].api_key,
                  max_tokens=20000, temperature=1.0))
# ------------ SETTING ------------

# ------------ RAG setup ------------
# Cache directory for precomputed embeddings
EMBEDDING_CACHE_DIR = "./.cache/embeddings"

def _load_or_create_embeddings(cache_dir, prefix, corpus_dict, embedder, topk):
    """
    Load cached embedding indexes if available, otherwise compute and cache them.
    Each error type in corpus_dict gets its own subdirectory.
    Returns a dict mapping error_type -> dspy.Embeddings retriever.
    """
    retrievers_out = {}
    for err_type, corpus in corpus_dict.items():
        cache_path = os.path.join(cache_dir, f"{prefix}_{err_type}")
        if os.path.isdir(cache_path):
            print(f"  Loading cached embeddings for {prefix}/{err_type} ...")
            retriever = dspy.Embeddings.from_saved(cache_path, embedder)
        else:
            print(f"  Computing embeddings for {prefix}/{err_type} ({len(corpus)} items) ...")
            start_t = time.time()
            retriever = dspy.retrievers.Embeddings(embedder=embedder, corpus=corpus, k=topk)
            print(f"  Done in {time.time() - start_t:.2f}s, saving to cache ...")
            os.makedirs(cache_path, exist_ok=True)
            retriever.save(cache_path)
        retrievers_out[err_type] = retriever
    return retrievers_out


# Load KB corpora from AR-LSAT and FOLIO
LSAT_corpus_dict = loading_kb_with_da('AR-LSAT')
FOLIO_corpus_dict = loading_kb_with_da('FOLIO')

# batch_size=10 to stay well under the 300k-token-per-request limit
embedder = dspy.Embedder(model=embedder_config.llm_name,
                         api_key=embedder_config.api_key,
                         api_base=embedder_config.base_url,
                         batch_size=10)
topk_to_retrieve = 1

LSAT_retrievers = _load_or_create_embeddings(
    EMBEDDING_CACHE_DIR, "LSAT", LSAT_corpus_dict, embedder, topk_to_retrieve)
FOLIO_retrievers = _load_or_create_embeddings(
    EMBEDDING_CACHE_DIR, "FOLIO", FOLIO_corpus_dict, embedder, topk_to_retrieve)

retrievers = {}
for err_type in LSAT_retrievers:
    retrievers[f'LSAT_{err_type}'] = LSAT_retrievers[err_type]
for err_type in FOLIO_retrievers:
    retrievers[f'FOLIO_{err_type}'] = FOLIO_retrievers[err_type]

Fixer = RAGFixer(dataset_name, retrievers)
# ------------ RAG setup ------------

with open(gen_prompt_path, "r", encoding='utf-8') as f:
    generation_prompt_template = f.read()


program_pattern = r"```python(.*?)```"

with open(data_fpath, 'r', encoding='utf-8') as f:
    test_data = json.load(f)


# ------------ ZebraLogic answer helpers ------------
def extract_json_from_stdout(stdout_lines):
    """Parse the JSON list printed by the Z3 program's print(models)."""
    if not stdout_lines:
        return None
    text = "".join(stdout_lines).strip()
    # Try json.loads first (for json.dumps output)
    try:
        return json.loads(text)
    except Exception:
        pass
    # Try ast.literal_eval (for Python repr like [{'House': '1', ...}])
    try:
        return ast.literal_eval(text)
    except Exception:
        pass
    return None


def normalize_value(v):
    """Lowercase and replace underscores with spaces."""
    if isinstance(v, str):
        return v.lower().replace('_', ' ')
    return v


def solution_to_dicts(solution):
    """Convert solution {header, rows} into a list of dicts."""
    header = solution["header"]
    return [dict(zip(header, row)) for row in solution["rows"]]


def compare_answers(gold_solution, pred_list):
    """Normalize and compare gold solution with predicted list of dicts."""
    gold_dicts = [{k: normalize_value(v) for k, v in d.items()}
                  for d in solution_to_dicts(gold_solution)]
    pred_dicts = [{k: normalize_value(v) for k, v in d.items()}
                  for d in pred_list]
    gold_dicts.sort(key=lambda x: int(x.get("House", 0)))
    pred_dicts.sort(key=lambda x: int(x.get("House", 0)))
    if len(gold_dicts) != len(pred_dicts):
        return False
    for g, p in zip(gold_dicts, pred_dicts):
        for k in g:
            if k == "House":
                continue
            if g[k] != p.get(k):
                return False
    return True
# ------------ end helpers ------------


# ------------ Checkpoint helpers ------------
def load_checkpoint(jsonl_path):
    """Load previously saved results from JSONL, return dict of id->result."""
    checkpoint = {}
    if not os.path.exists(jsonl_path):
        return checkpoint
    print(f"Loading checkpoint from {jsonl_path} ...")
    with open(jsonl_path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            rec = json.loads(line)
            checkpoint[rec["id"]] = rec
    print(f"  Found {len(checkpoint)} completed samples.")
    return checkpoint


def append_result(jsonl_path, result_dict):
    """Append one result as a JSON line to the JSONL file."""
    with open(jsonl_path, "a", encoding="utf-8") as f:
        f.write(json.dumps(result_dict, ensure_ascii=False) + "\n")


def compute_and_print_accuracy(results):
    """Compute and print accuracy stats from a list of result dicts."""
    size_stats = {}
    for r in results:
        sz = r["size"]
        if sz not in size_stats:
            size_stats[sz] = {"correct": 0, "total": 0}
        size_stats[sz]["total"] += 1
        if r.get("is_correct"):
            size_stats[sz]["correct"] += 1

    total_correct = sum(s["correct"] for s in size_stats.values())
    total_all = sum(s["total"] for s in size_stats.values())

    print(f"Accuracy: {total_correct}/{total_all} = {total_correct / total_all * 100:.2f}%")
    print("\nPer-size accuracy:")
    for sz in sorted(size_stats, key=lambda x: [int(v) for v in x.split('*')]):
        s = size_stats[sz]
        rate = s["correct"] / s["total"] * 100
        print(f"  {sz:5s}: {s['correct']:2d}/{s['total']:2d} ({rate:5.1f}%)")

# ------------ evaluation loop ------------
checkpoint = load_checkpoint(result_jsonl_path)
# Collect all results in memory (loaded checkpoint + newly computed)
all_results = list(checkpoint.values())
internet_issues = []

for sample in tqdm(test_data):
    # Skip if already processed in a previous run
    if sample["id"] in checkpoint:
        print(f"*****{sample['id']}***** (skipped, already in checkpoint)")
        continue

    print(f"*****{sample['id']}*****")

    puzzle = sample["puzzle"]
    headers_str = json.dumps(sample["solution"]["header"])
    gold_answer = sample["solution"]

    # ---- Translator: generate Z3 program ----
    generation_prompt = generation_prompt_template.replace(
        "[[PROBLEM]]", puzzle).replace("[[HEADERS]]", headers_str)

    program_result = []
    answer = ''
    raw_output = None

    for attempt in range(3):
        try:
            raw_output = llm.generate(generation_prompt)
            print(f"raw output length: {len(raw_output)}")
            break
        except Exception:
            time.sleep(1)

    if not raw_output:
        print(f"connection error.")
        internet_issues.append(sample['id'])
        continue

    program = None
    try:
        program = re.findall(program_pattern, raw_output, re.DOTALL)[0].strip()
    except IndexError:
        program = raw_output.replace("```python", "").replace("```", "").strip()
    if not program.startswith('from z3 import *'):
        program = "from z3 import *\n" + program
    print(f"original program length: {len(program)}")

    exec_dict = execute_logic_program(program)
    result = {"program": program, "execution": exec_dict}
    print(f"execution: flag={exec_dict['flag']}, result={exec_dict['result']}")
    program_result.append(result)

    if exec_dict["flag"] == "success":
        parsed = extract_json_from_stdout(exec_dict["result"])
        if parsed is not None:
            answer = parsed

    # ---- Fixer: correct program (up to 3 rounds) ----
    NL_story = puzzle  # the puzzle text serves as the NL story for the fixer

    for judge_num in range(3):
        print(f"correcting round {judge_num}")
        for attempt in range(3):
            try:
                judgement, rag_samples = Fixer(NL_story=NL_story, program=result)
                print(f"rag_samples num: {len(rag_samples)}")
                break
            except Exception:
                time.sleep(1)

        if not judgement:
            print(f"connection error.")
            internet_issues.append(sample['id'])
            break
        elif "There is no error." in judgement.response:
            print("no need for further correction.")
            break
        else:
            try:
                program = re.findall(program_pattern, judgement.response, re.DOTALL)[0].strip()
            except IndexError:
                program = judgement.response.replace("```python", "").replace("```", "").strip()
            if not program.startswith('from z3 import *'):
                program = "from z3 import *\n" + program
            print(f"corrected program length: {len(program)}")
            exec_dict = execute_logic_program(program)
            print(f"execution: flag={exec_dict['flag']}, result={exec_dict['result']}")
            result = {"program": program, "execution": exec_dict}
            program_result.append(result)
            if exec_dict["flag"] == "success":
                parsed = extract_json_from_stdout(exec_dict["result"])
                if parsed is not None:
                    answer = parsed

    # ---- Evaluate ----
    is_correct = False
    if isinstance(answer, list) and len(answer) > 0:
        is_correct = compare_answers(gold_answer, answer)

    result_dict = {
        "id": sample["id"],
        "size": sample["size"],
        "puzzle": puzzle,
        "gold_answer": gold_answer,
        "programs": program_result,
        "answer": answer,
        "is_correct": is_correct,
    }

    # Persist immediately to JSONL
    append_result(result_jsonl_path, result_dict)
    all_results.append(result_dict)
    print(f"is_correct: {is_correct}")

# ---- Print accuracy from all results ----
print(f"\nAll results saved in {result_jsonl_path}")
compute_and_print_accuracy(all_results)

if internet_issues:
    print(f"\ninternet issues id: {internet_issues}")
