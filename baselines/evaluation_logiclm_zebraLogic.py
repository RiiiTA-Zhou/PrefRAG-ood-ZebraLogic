'''
Logic-LM evaluation for ZebraLogic (grid_mode).
Pipeline: LLM generates Z3 program → execute → if error, correct with Z3 error (≤3 rounds) → if Z3 outputs, take first answer.
Metrics:
  - raw accuracy: Z3 never outputs → incorrect
  - main accuracy: Z3 never outputs → fall back to CoT answer from same model
Also prints per-size accuracy for both raw and main.
'''

import sys
import os

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))

from baselines.utils import OpenAIModel, execute_logic_program
from LLM_config import LLM_CONFIG
import json
import re
import ast
from tqdm import tqdm
import time
import argparse

# ------------ SETTING ------------
parser = argparse.ArgumentParser(description="Logic-LM evaluation for ZebraLogic")
parser.add_argument("--llm", type=str, default="dpsk-reasoner",
                    choices=["gpt-4o", "dpsk-chat", "dpsk-reasoner", "o3-mini", "dpsk-v4-flash", "dpsk-v4-pro"],
                    help="Model name (must match a key in LLM_CONFIG)")
args = parser.parse_args()

llm_name = args.llm
# ------------ SETTING ------------

base_dir = os.path.dirname(os.path.abspath(__file__))

# Paths
generation_prompt_path = os.path.join(base_dir, '..', 'prompts', 'z3program_generation_ZebraLogic.txt')
correction_prompt_path  = os.path.join(base_dir, '..', 'prompts', 'z3program_correction_ZebraLogic.txt')
cot_prompt_path         = os.path.join(base_dir, 'prompts', 'ZebraLogic_CoT.txt')
data_fpath              = os.path.join(base_dir, '..', 'benchmarks', 'ZebraLogic', 'grid_mode_sampled.json')
result_save_path        = os.path.join(base_dir, 'LogicLM-results', f'ZebraLogic_LogicLM_{llm_name}.jsonl')
cache_dir               = os.path.join(base_dir, '.cache_program')

llm = OpenAIModel(LLM_CONFIG[llm_name], max_new_tokens=4096, temp=0)
if LLM_CONFIG[llm_name].is_reasoning:
    # reasoning models use max_new_tokens internally (it's a soft ceiling in OpenAIModel.generate)
    pass

os.makedirs(os.path.dirname(result_save_path), exist_ok=True)
os.makedirs(cache_dir, exist_ok=True)

# Load prompts
with open(generation_prompt_path, 'r', encoding='utf-8') as f:
    GENERATION_TEMPLATE = f.read()

with open(correction_prompt_path, 'r', encoding='utf-8') as f:
    CORRECTION_TEMPLATE = f.read()

with open(cot_prompt_path, 'r', encoding='utf-8') as f:
    COT_TEMPLATE = f.read()

with open(data_fpath, 'r', encoding='utf-8') as f:
    test_data = json.load(f)

program_pattern = r"```python(.*?)```"


# ------------ Helpers ------------
def extract_json_from_stdout(stdout_lines):
    """Parse the JSON list printed by the Z3 program's print(models).
       Z3 outputs Python repr with bare enum identifiers (e.g. Arnold, prince),
       which is not valid JSON.  Handles both standard JSON and Z3 repr format."""
    if not stdout_lines:
        return None
    text = "".join(stdout_lines).strip()
    if not text:
        return None
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
    # Handle Z3 repr: bare enum identifiers like Arnold, prince (not quoted)
    # Convert them to valid JSON by quoting bare words in value positions
    try:
        # Step 1: quote bare identifiers that appear after : or , or [
        fixed = re.sub(
            r'(?<=[\:\,\[])\s*([A-Za-z_]\w+)(?=\s*[\}\]\,])',
            lambda m: '"' + m.group(1) + '"',
            text,
        )
        # Step 2: convert remaining single quotes to double quotes (JSON requires double quotes)
        fixed = fixed.replace("'", '"')
        return json.loads(fixed)
    except Exception:
        pass
    return None


def normalize_value(v):
    if isinstance(v, str):
        return v.lower().replace('_', ' ')
    return v


def solution_to_dicts(solution):
    header = solution["header"]
    return [dict(zip(header, row)) for row in solution["rows"]]


def compare_answers(gold_solution, pred_list):
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


def extract_code(text):
    """Extract python code block from LLM response."""
    try:
        program = re.findall(program_pattern, text, re.DOTALL)[0].strip()
    except IndexError:
        program = text.replace("```python", "").replace("```", "").strip()
    if not program.startswith('from z3 import *'):
        program = "from z3 import *\n" + program
    return program


def extract_json_list(text):
    """Extract a JSON list from model output (for CoT fallback)."""
    m = re.search(r'```(?:json)?\s*(\[[\s\S]*?\])\s*```', text)
    if m:
        try:
            return json.loads(m.group(1))
        except Exception:
            pass
    m = re.search(r'(\[[\s\S]*?\])', text)
    if m:
        try:
            return json.loads(m.group(1))
        except Exception:
            pass
    return None


def get_nl_story_and_headers(sample):
    """Build NL story text for a sample (same format as test_RAG_as_fixer)."""
    puzzle = sample["puzzle"]
    headers_str = json.dumps(sample["solution"]["header"])
    return puzzle, headers_str


def generate_program(sample):
    """Step 1: Generate an initial Z3 program."""
    puzzle, headers_str = get_nl_story_and_headers(sample)
    prompt = GENERATION_TEMPLATE.replace("[[PROBLEM]]", puzzle).replace("[[HEADERS]]", headers_str)
    for attempt in range(3):
        try:
            raw = llm.generate(prompt)
            print(f"  raw output length: {len(raw)}")
            return extract_code(raw), raw
        except Exception:
            time.sleep(1)
    return None, None


def correct_program(program_text, error_msg, puzzle, headers_str):
    """Step 2: Correct a program using the error message."""
    prompt = (CORRECTION_TEMPLATE
              .replace("[[PROBLEM]]", puzzle)
              .replace("[[HEADERS]]", headers_str)
              .replace("[[ERRORPROGRAM]]", program_text)
              .replace("[[ERRORMSG]]", error_msg))
    for attempt in range(3):
        try:
            raw = llm.generate(prompt)
            print(f"  correction output length: {len(raw)}")
            return extract_code(raw), raw
        except Exception:
            time.sleep(1)
    return None, None


def generate_cot_answer(sample):
    """Fallback: generate a CoT answer for this sample."""
    puzzle, headers_str = get_nl_story_and_headers(sample)
    prompt = COT_TEMPLATE.replace("[[PROBLEM]]", puzzle).replace("[[HEADERS]]", headers_str)
    for attempt in range(3):
        try:
            raw = llm.generate(prompt)
            parsed = extract_json_list(raw)
            return parsed, raw
        except Exception:
            time.sleep(1)
    return None, None


def run_z3_and_parse(program_text):
    """Execute a Z3 program and parse the first answer if any."""
    exec_dict = execute_logic_program(program_text, cache_dir)
    print(f"  execution: flag={exec_dict['flag']}")
    if exec_dict['flag'] == 'success':
        parsed = extract_json_from_stdout(exec_dict['result'])
        return parsed, exec_dict
    return None, exec_dict


# ------------ Checkpoint helpers (JSONL) ------------
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


# ------------ Evaluation loop ------------
checkpoint = load_checkpoint(result_save_path)
all_results = list(checkpoint.values())   # accumulated results (checkpoint + new)
internet_issues = []

for sample in tqdm(test_data):
    sid = sample["id"]

    # Skip if already processed
    if sid in checkpoint:
        print(f"\n***** {sid} ***** (skipped, already in checkpoint)")
        continue

    print(f"\n***** {sid} *****")

    puzzle, headers_str = get_nl_story_and_headers(sample)
    gold_answer = sample["solution"]

    # ---- Step 1: Generate initial Z3 program ----
    program_text, raw_gen = generate_program(sample)
    if program_text is None:
        print("  connection error during generation, skipping")
        internet_issues.append(sid)
        continue

    programs_log = [{"stage": "generation",
                     "program": program_text,
                     "raw_output": raw_gen}]

    # ---- Step 2: Execute & correct loop (up to 3 corrections) ----
    # Only syntax/runtime errors (flag='execution error') enter the correction loop.
    # Semantic errors (no output or unparseable output) are NOT corrected — the
    # program ran to completion but simply didn't produce a valid answer, which
    # means the LLM gave a flawed but runnable program; correcting without an
    # error message would be meaningless.
    z3_answer = None
    final_exec = None

    parsed_out, exec_dict = run_z3_and_parse(program_text)
    programs_log[-1]["execution"] = exec_dict
    programs_log[-1]["parsed_output"] = parsed_out

    if parsed_out is not None:
        z3_answer = parsed_out
        print(f"  Z3 succeeded on first try")
    elif exec_dict["flag"] == "execution error":
        # Only syntax/runtime errors can be corrected — we have a real error message
        for round_idx in range(3):
            error_msg = exec_dict.get("error_msg", "")
            print(f"  correction round {round_idx + 1} (flag={exec_dict['flag']})")

            new_program, raw_correct = correct_program(program_text, error_msg, puzzle, headers_str)
            if new_program is None:
                print("  connection error during correction, giving up")
                internet_issues.append(sid)
                break

            programs_log.append({
                "stage": f"correction_{round_idx + 1}",
                "program": new_program,
                "error_msg_for_correction": error_msg,
                "raw_output": raw_correct,
            })

            parsed_out, exec_dict = run_z3_and_parse(new_program)
            programs_log[-1]["execution"] = exec_dict
            programs_log[-1]["parsed_output"] = parsed_out

            if parsed_out is not None:
                z3_answer = parsed_out
                print(f"  Z3 succeeded after correction round {round_idx + 1}")
                break

            # If after correction we no longer have an execution error (e.g. success
            # but unparseable, or semantic error), stop — can't correct further
            if exec_dict["flag"] != "execution error":
                print(f"  Non-execution-error (flag={exec_dict['flag']}), stopping correction")
                break

            program_text = new_program
    else:
        # Semantic error (no output) or success but unparseable → not correctable
        print(f"  Not correctable (flag={exec_dict['flag']}), skipping correction")

    # ---- Step 3: Evaluate Z3 answer ----
    raw_is_correct = False
    if z3_answer is not None and isinstance(z3_answer, list) and len(z3_answer) > 0:
        raw_is_correct = compare_answers(gold_answer, z3_answer)

    # ---- Step 4: Main answer (fallback to CoT if Z3 never produced a valid answer) ----
    main_answer = z3_answer
    main_is_correct = raw_is_correct
    cot_answer = None
    cot_raw = None

    if z3_answer is None:
        print("  Z3 did not produce a valid answer, falling back to CoT")
        cot_answer, cot_raw = generate_cot_answer(sample)
        if cot_answer is not None and isinstance(cot_answer, list) and len(cot_answer) > 0:
            main_answer = cot_answer
            main_is_correct = compare_answers(gold_answer, cot_answer)

    result_dict = {
        "id": sid,
        "size": sample["size"],
        "puzzle": puzzle,
        "gold_answer": gold_answer,
        "z3_answer": z3_answer,
        "raw_is_correct": raw_is_correct,
        "cot_answer": cot_answer,
        "cot_raw_output": cot_raw,
        "main_answer": main_answer,
        "main_is_correct": main_is_correct,
        "programs": programs_log,
    }

    # Persist immediately to JSONL
    append_result(result_save_path, result_dict)
    all_results.append(result_dict)

    print(f"  raw_correct={raw_is_correct}  main_correct={main_is_correct}")

# ---- Compute and print stats from all_results (checkpoint + new) ----
def print_accuracy(results, key, label):
    size_stats = {}
    for r in results:
        sz = r["size"]
        if sz not in size_stats:
            size_stats[sz] = {"correct": 0, "total": 0}
        size_stats[sz]["total"] += 1
        if r.get(key):
            size_stats[sz]["correct"] += 1

    total_correct = sum(s["correct"] for s in size_stats.values())
    total_all = sum(s["total"] for s in size_stats.values())
    rate = total_correct / total_all * 100 if total_all > 0 else 0

    print(f"\n{label}: {total_correct}/{total_all} = {rate:.2f}%")
    print(f"Per-size {label}:")
    for sz in sorted(size_stats, key=lambda x: [int(v) for v in x.split('*')]):
        s = size_stats[sz]
        r = s["correct"] / s["total"] * 100 if s["total"] > 0 else 0
        print(f"  {sz:5s}: {s['correct']:2d}/{s['total']:2d} ({r:5.1f}%)")


print("\n" + "=" * 60)
print("ACCURACY METRICS")
print("=" * 60)
print_accuracy(all_results, key="raw_is_correct",   label="Raw Accuracy (Z3-only)")
print_accuracy(all_results, key="main_is_correct",   label="Main Accuracy (Z3 + CoT fallback)")

# Execution rate & executive accuracy
size_exec = {}  # size -> {"executable": 0, "exec_correct": 0, "total": 0}
for r in all_results:
    sz = r["size"]
    if sz not in size_exec:
        size_exec[sz] = {"executable": 0, "exec_correct": 0, "total": 0}
    size_exec[sz]["total"] += 1
    if r["z3_answer"] is not None:
        size_exec[sz]["executable"] += 1
        if r["raw_is_correct"]:
            size_exec[sz]["exec_correct"] += 1

total_exec = sum(v["executable"] for v in size_exec.values())
total_all = sum(v["total"] for v in size_exec.values())
total_exec_correct = sum(v["exec_correct"] for v in size_exec.values())

print("=" * 60)
print("EXECUTION METRICS")
print("=" * 60)

exec_rate = total_exec / total_all * 100 if total_all > 0 else 0
print(f"\nExecution Rate (Z3 compiles): {total_exec}/{total_all} = {exec_rate:.2f}%")
print("Per-size Execution Rate:")
for sz in sorted(size_exec, key=lambda x: [int(v) for v in x.split('*')]):
    s = size_exec[sz]
    r = s["executable"] / s["total"] * 100 if s["total"] > 0 else 0
    print(f"  {sz:5s}: {s['executable']:2d}/{s['total']:2d} ({r:5.1f}%)")

exec_accuracy = total_exec_correct / total_exec * 100 if total_exec > 0 else 0
print(f"\nExecutive Accuracy (correct / executable): {total_exec_correct}/{total_exec} = {exec_accuracy:.2f}%")
print("Per-size Executive Accuracy:")
for sz in sorted(size_exec, key=lambda x: [int(v) for v in x.split('*')]):
    s = size_exec[sz]
    r = s["exec_correct"] / s["executable"] * 100 if s["executable"] > 0 else 0
    print(f"  {sz:5s}: {s['exec_correct']:2d}/{s['executable']:2d} ({r:5.1f}%)")

# Fallback count
n_fallback = sum(1 for r in all_results if r["cot_answer"] is not None)
n_z3_success = sum(1 for r in all_results if r["z3_answer"] is not None)
print(f"\nOut of {len(all_results)} samples:")
print(f"  Z3 produced output:   {n_z3_success}")
print(f"  Fallback to CoT:      {n_fallback}")

if internet_issues:
    print(f"\nInternet errors for IDs: {internet_issues}")

print(f"\nResults saved to: {result_save_path}")
