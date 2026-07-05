'''
    evaluates SARA v3 (Statutory Reasoning Dataset) with direct or CoT baseline.
    Handles binary answers (Entailment / Contradiction) and numerical ($amount).
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


# ------------ Answer extraction ------------

def extract_binary_answer(response: str) -> str | None:
    """Extract 'Entailment' or 'Contradiction' from model output."""
    # Explicit marker first (used by CoT: "Answer: Entailment")
    m = re.search(
        r'(?:Answer|answer|the\s+correct\s+answer\s+is)\s*[:\-]?\s*(Entailment|Contradiction)',
        response, re.IGNORECASE,
    )
    if m:
        return m.group(1).capitalize()

    # Fallback: standalone keyword
    for kw in ("Entailment", "Contradiction"):
        if re.search(rf'\b{kw}\b', response, re.IGNORECASE):
            return kw
    return None


def extract_numerical_answer(response: str) -> str | None:
    """Extract dollar amount like '$10598' from model output."""
    # Explicit marker first
    m = re.search(
        r'(?:Answer|answer|the\s+correct\s+answer\s+is)\s*[:\-]?\s*\$?(\d[\d,]*)',
        response, re.IGNORECASE,
    )
    if m:
        return '$' + m.group(1).replace(',', '')

    # Fallback: any $<amount>
    m = re.search(r'\$(\d[\d,]*)', response)
    if m:
        return '$' + m.group(1).replace(',', '')
    return None


def extract_answer(response: str, answer_type: str) -> str | None:
    if answer_type in ("entailment", "contradiction"):
        return extract_binary_answer(response)
    elif answer_type == "numerical":
        return extract_numerical_answer(response)
    return response.strip()


def answers_match(predicted: str, gold: str) -> bool:
    if not predicted or not gold:
        return False
    p, g = predicted.strip().lower(), gold.strip().lower()
    # Binary
    if p in ("entailment", "contradiction") and g in ("entailment", "contradiction"):
        return p == g
    # Numerical — compare as integers
    pn = re.sub(r'[^\d]', '', predicted)
    gn = re.sub(r'[^\d]', '', gold)
    if pn and gn:
        return int(pn) == int(gn)
    return p == g


# ------------ Main ------------

def main():
    parser = argparse.ArgumentParser(description="Evaluate SARA v3 with direct or CoT baseline")
    parser.add_argument("--llm", type=str, default="dpsk-reasoner",
                        choices=["gpt-4o", "dpsk-chat", "dpsk-reasoner", "o3-mini",
                                 "dpsk-v4-flash", "dpsk-v4-pro"],
                        help="Model name (must match a key in LLM_CONFIG)")
    parser.add_argument("--baseline", type=str, default="direct",
                        choices=["direct", "CoT"],
                        help="Baseline type")
    parser.add_argument("--max-tokens", type=int, default=4096,
                        help="Max tokens for non-reasoning models")
    args = parser.parse_args()

    llm_name = args.llm
    baseline = args.baseline

    # ------------ Paths ------------
    base_dir = os.path.dirname(os.path.abspath(__file__))
    prompt_template_fpath = os.path.join(base_dir, "prompts", f"SARA_{baseline}.txt")
    result_save_fpath = os.path.join(base_dir, "results", f"SARA_{baseline}_{llm_name}.json")
    data_fpath = os.path.join(base_dir, "..", "benchmarks", "sara_v3", "dev.json")

    # ------------ Load data ------------
    with open(data_fpath, "r", encoding='utf-8') as f:
        sample_list = json.load(f)
    print(f"Loaded {len(sample_list)} test samples.")

    with open(prompt_template_fpath, "r", encoding='utf-8') as f:
        prompt_template = f.read()

    llm = OpenAIModel(LLM_CONFIG[llm_name], max_new_tokens=args.max_tokens, temp=0)
    print(f"LLM: {llm_name}  Baseline: {baseline}")

    # ------------ Checkpoint ------------
    def load_existing_results(fpath):
        if not os.path.exists(fpath):
            return {}
        print(f"Loading existing results from {fpath} ...")
        with open(fpath, "r", encoding="utf-8") as f:
            data = json.load(f)
        ckpt = {r["id"]: r for r in data}
        print(f"  Found {len(ckpt)} samples.")
        return ckpt

    checkpoint = load_existing_results(result_save_fpath)

    # ------------ Evaluation loop ------------
    new_results = []
    internet_issues = []

    for sample in tqdm(sample_list, desc=f"SARA {baseline}"):
        sid = sample["id"]

        if sid in checkpoint:
            print(f"*****{sid}***** (skipped, already in checkpoint)")
            continue

        print(f"*****{sid}*****  gold: {sample['answer']}  type: {sample['answer_type']}")

        # Build prompt
        context_str = sample["context"]
        question_str = sample["question"]
        options_str = "\n".join(sample.get("options", []))

        prompt = (
            prompt_template
            .replace("[[CONTEXT]]", context_str)
            .replace("[[QUESTION]]", question_str)
            .replace("[[OPTIONS]]", options_str)
        )

        # Call LLM
        response = None
        is_success = False
        for attempt in range(3):
            try:
                response = llm.generate(prompt)
                print(response[:300])
                is_success = True
                break
            except Exception:
                time.sleep(1)

        if not is_success:
            print(f"connection error.")
            internet_issues.append(sid)
            new_results.append({
                "id": sid,
                "answer_type": sample["answer_type"],
                "gold_answer": sample["answer"],
                "statutes_used": sample.get("statutes_used", []),
                "raw_output": "",
                "answer": None,
                "is_correct": False,
                "error": "connection_error",
            })
            continue

        # Extract answer
        predicted = extract_answer(response, sample["answer_type"])
        gold = sample["answer"]
        correct = answers_match(predicted, gold) if predicted else False

        print(f"  gold: {gold}  predicted: {predicted}  correct: {correct}")

        new_results.append({
            "id": sid,
            "answer_type": sample["answer_type"],
            "gold_answer": gold,
            "statutes_used": sample.get("statutes_used", []),
            "raw_output": response,
            "answer": predicted,
            "is_correct": correct,
        })

    # ------------ Merge & save ------------
    all_results = list(checkpoint.values()) + new_results

    # Recompute is_correct for all (consistency)
    for r in all_results:
        gold = r.get("gold_answer", "")
        pred = r.get("answer")
        r["is_correct"] = answers_match(pred, gold) if pred else False

    with open(result_save_fpath, "w", encoding='utf-8') as f:
        json.dump(all_results, f, indent=2, ensure_ascii=False)

    # ------------ Statistics ------------
    total_correct = sum(1 for r in all_results if r["is_correct"])
    total_all = len(all_results)

    type_stats: dict[str, dict] = {}
    for r in all_results:
        t = r.get("answer_type", "unknown")
        if t not in type_stats:
            type_stats[t] = {"correct": 0, "total": 0}
        type_stats[t]["total"] += 1
        if r["is_correct"]:
            type_stats[t]["correct"] += 1

    print(f"\n{'='*60}")
    print(f"RESULTS — {baseline} / {llm_name} on SARA v3")
    print(f"{'='*60}")
    print(f"  Previously completed: {len(checkpoint)}")
    print(f"  Newly tested:         {len(new_results)}")
    print(f"  Total:                {total_all}")
    print(f"  Correct:              {total_correct}")
    print(f"  Accuracy:             {total_correct}/{total_all} = {total_correct/total_all*100:.2f}%")
    print()

    print("  Per-type breakdown:")
    for t in ["entailment", "contradiction", "numerical"]:
        if t in type_stats:
            s = type_stats[t]
            acc = s["correct"] / s["total"] * 100 if s["total"] > 0 else 0.0
            print(f"    {t:15s}: {s['correct']:3d}/{s['total']:<3d} ({acc:5.2f}%)")

    print(f"\n  Results saved to: {result_save_fpath}")
    if internet_issues:
        print(f"  Internet errors ({len(internet_issues)}): {internet_issues}")


if __name__ == "__main__":
    main()
