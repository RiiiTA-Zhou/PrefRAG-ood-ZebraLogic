'''
    evaluates ZebraLogic (grid_mode_sampled) with direct or CoT baseline.
    Model output is parsed as a JSON list of dicts, normalized (lowercase, underscore→space),
    and compared against the solution.
'''

import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))

from baselines.utils import OpenAIModel
from LLM_config import LLM_CONFIG
import json
import re
import argparse
from tqdm import tqdm
import time


# ------------ SETTING ------------
parser = argparse.ArgumentParser(description="Evaluate ZebraLogic with direct or CoT baseline")
parser.add_argument("--llm", type=str, default="dpsk-reasoner",
                    choices=["gpt-4o", "dpsk-chat", "dpsk-reasoner", "o3-mini", "dpsk-v4-flash", "dpsk-v4-pro"],
                    help="Model name (must match a key in LLM_CONFIG)")
parser.add_argument("--baseline", type=str, default="direct", choices=["direct", "CoT"],
                    help="Baseline type")
args = parser.parse_args()

llm_name = args.llm
baseline = args.baseline

# ------------ SETTING ------------

base_dir = os.path.dirname(os.path.abspath(__file__))
prompt_template_fpath = os.path.join(base_dir, "prompts", f"ZebraLogic_{baseline}.txt")
result_save_fpath = os.path.join(base_dir, "results", f"ZebraLogic_{baseline}_{llm_name}.json")
data_fpath = os.path.join(base_dir, "..", "benchmarks", "ZebraLogic", "grid_mode_sampled.json")

llm = OpenAIModel(LLM_CONFIG[llm_name], max_new_tokens=3000, temp=0)

with open(data_fpath, "r", encoding='utf-8') as f:
    sample_list = json.load(f)

with open(prompt_template_fpath, "r", encoding='utf-8') as f:
    prompt_template = f.read()


def extract_json_list(text):
    """Extract a JSON list from model output."""
    # Try ```json ... ``` block first
    m = re.search(r'```(?:json)?\s*(\[[\s\S]*?\])\s*```', text)
    if m:
        return json.loads(m.group(1))
    # Try bare [...] (capture the first top-level JSON array, non-greedy)
    m = re.search(r'(\[[\s\S]*?\])', text)
    if m:
        return json.loads(m.group(1))
    return None


def normalize_value(v):
    """Lowercase and replace underscores with spaces."""
    if isinstance(v, str):
        return v.lower().replace('_', ' ')
    return v


def normalize_row_dict(d):
    """Normalize all values in a dict."""
    return {k: normalize_value(v) for k, v in d.items()}


def solution_to_dicts(solution):
    """Convert solution {header, rows} into a list of dicts, sorted by House."""
    header = solution["header"]
    rows = solution["rows"]
    dicts = []
    for row in rows:
        d = dict(zip(header, row))
        dicts.append(d)
    dicts.sort(key=lambda x: int(x.get("House", 0)))
    return dicts


def normalize_solution(solution):
    """Normalize a ground-truth solution to sorted list of normalized dicts."""
    return [normalize_row_dict(d) for d in solution_to_dicts(solution)]


def normalize_prediction(pred_list):
    """Normalize a prediction (list of dicts) sorted by House."""
    pred_list.sort(key=lambda x: int(x.get("House", 0)))
    return [normalize_row_dict(d) for d in pred_list]


def compare_dicts(gold_list, pred_list):
    """Compare two lists of normalized dicts element by element, ignoring 'House'."""
    if len(gold_list) != len(pred_list):
        return False
    for g, p in zip(gold_list, pred_list):
        for k in g:
            if k == "House":
                continue
            if g[k] != p.get(k, None):
                return False
    return True


# ------------ Checkpoint: load existing results if any ------------
def load_existing_results(fpath):
    """Load existing results JSON file, return dict of id->result."""
    if not os.path.exists(fpath):
        return {}
    print(f"Loading existing results from {fpath} ...")
    with open(fpath, "r", encoding="utf-8") as f:
        data = json.load(f)
    checkpoint = {r["id"]: r for r in data}
    print(f"  Found {len(checkpoint)} samples.")
    return checkpoint

checkpoint = load_existing_results(result_save_fpath)

# ------------ Evaluation loop ------------
new_results = []
internet_issues = []

for sample in tqdm(sample_list):
    sample_id = sample["id"]

    # Skip if already processed
    if sample_id in checkpoint:
        print(f"*****{sample_id}***** (skipped, already in checkpoint)")
        continue

    print(f"*****{sample_id}*****")

    headers_str = json.dumps(sample["solution"]["header"])
    prompt = prompt_template.replace('[[PROBLEM]]', sample["puzzle"]).replace('[[HEADERS]]', headers_str)

    is_success = False
    response = None
    for attempt in range(3):
        try:
            response = llm.generate(prompt)
            print(response)
            is_success = True
            break
        except Exception:
            time.sleep(1)

    if not is_success:
        print(f"connection error.")
        internet_issues.append(sample_id)
        continue

    # Parse model output
    answer = None
    try:
        pred_raw = extract_json_list(response)
        if pred_raw is None:
            print("  WARN: could not extract JSON list from response")
        else:
            pred_norm = normalize_prediction(pred_raw)
            gold_norm = normalize_solution(sample["solution"])
            match = compare_dicts(gold_norm, pred_norm)
            answer = pred_norm if match else pred_raw
            if not match:
                print(f"  WRONG: gold={gold_norm}  pred={pred_norm}")
    except Exception as e:
        print(f"  PARSE ERROR: {e}")

    result = {
        "id": sample_id,
        "size": sample["size"],
        "gold_answer": sample["solution"],
        "raw_output": response,
        "answer": answer,
    }
    new_results.append(result)

# Merge checkpoint + new results
all_results = list(checkpoint.values()) + new_results

# Recompute is_correct for all results (consistency if logic changed)
size_stats = {}
for r in all_results:
    orig = next(s for s in sample_list if s["id"] == r["id"])
    gold_norm = normalize_solution(orig["solution"])
    if isinstance(r.get("answer"), list):
        pred_norm = normalize_prediction(r["answer"])
        r["is_correct"] = compare_dicts(gold_norm, pred_norm)
    else:
        r["is_correct"] = False

    sz = r["size"]
    if sz not in size_stats:
        size_stats[sz] = {"correct": 0, "total": 0}
    size_stats[sz]["total"] += 1
    if r["is_correct"]:
        size_stats[sz]["correct"] += 1

# Save merged results
with open(result_save_fpath, "w", encoding='utf-8') as f:
    json.dump(all_results, f, indent=2, ensure_ascii=False)

# Print summary
total_correct = sum(r["is_correct"] for r in all_results)
total_all = len(all_results)
new_count = len(new_results)
print(f"\nbaseline {baseline} on ZebraLogic done!")
print(f"  Previously completed: {len(checkpoint)}")
print(f"  Newly tested:         {new_count}")
print(f"  Total:                {total_all}")
print(f"Accuracy: {total_correct}/{total_all} = {total_correct / total_all * 100:.2f}%")
print("\nPer-size accuracy:")
for sz in sorted(size_stats, key=lambda x: [int(v) for v in x.split('*')]):
    s = size_stats[sz]
    rate = s["correct"] / s["total"] * 100
    print(f"  {sz:5s}: {s['correct']:2d}/{s['total']:2d} ({rate:5.1f}%)")
print(f"\nResults saved to: {result_save_fpath}")
if internet_issues:
    print(f"Internet errors: {internet_issues}")
