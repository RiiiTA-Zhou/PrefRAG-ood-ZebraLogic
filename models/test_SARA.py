"""
Evaluate PrefRAG baselines (Direct / CoT) on SARA v3 — Statutory Reasoning Dataset.

Tests ability to apply US federal tax code provisions to concrete fact patterns,
with binary (Entailment / Contradiction) and numerical ($amount) answer types.

Usage:
    python models/test_SARA.py --llm gpt-4o --baseline CoT
    python models/test_SARA.py --llm dpsk-reasoner --baseline direct

Output:
    ./evaluation_result/SARA/{baseline}_{llm_name}.json
"""

import argparse
import json
import os
import re
import sys
import time
from pathlib import Path
from datetime import datetime
from tqdm import tqdm

# Add models/ to path for utils import
sys.path.insert(0, str(Path(__file__).resolve().parent))
from utils.LLM_config import LLM_CONFIG
from utils.utils import OpenAIModel


# ── paths ──────────────────────────────────────────────────────────────────
BENCHMARK_DIR = Path(__file__).resolve().parent.parent / "benchmarks" / "sara_v3"
PROMPT_DIR = Path(__file__).resolve().parent.parent / "baselines" / "prompts"
RESULT_DIR = Path(__file__).resolve().parent.parent / "evaluation_result" / "SARA"

DEV_JSON = BENCHMARK_DIR / "dev.json"
PROMPT_TEMPLATES = {
    "direct": PROMPT_DIR / "SARA_direct.txt",
    "CoT": PROMPT_DIR / "SARA_CoT.txt",
}


# ── answer extraction ─────────────────────────────────────────────────────

def extract_binary_answer(response: str) -> str | None:
    """Extract 'Entailment' or 'Contradiction' from model output.

    Priority:
      1. Explicit marker like ``Answer: Entailment`` or ``Answer: Contradiction``.
      2. The words Entailment / Contradiction appearing as a standalone term.
    """
    # look for explicit marker first (CoT uses "Answer:")
    m = re.search(
        r'(?:Answer|answer|the\s+correct\s+answer\s+is)\s*[:\-]?\s*(Entailment|Contradiction)',
        response, re.IGNORECASE,
    )
    if m:
        return m.group(1).capitalize()

    # fallback: find the last occurrence of Entailment / Contradiction in text
    for keyword in ("Entailment", "Contradiction"):
        if re.search(rf'\b{keyword}\b', response, re.IGNORECASE):
            return keyword
    return None


def extract_numerical_answer(response: str) -> str | None:
    """Extract a dollar amount from model output.

    Matches patterns like ``$1234``, ``$1,234``, ``Answer: $1234``, etc.
    Returns the canonical form ``$<number>`` (commas stripped).
    """
    # explicit marker first
    m = re.search(
        r'(?:Answer|answer|the\s+correct\s+answer\s+is)\s*[:\-]?\s*\$?(\d[\d,]*)',
        response, re.IGNORECASE,
    )
    if m:
        val = m.group(1).replace(",", "")
        return f"${val}"

    # fallback: any $<amount> in the response
    m = re.search(r'\$(\d[\d,]*)', response)
    if m:
        val = m.group(1).replace(",", "")
        return f"${val}"
    return None


def extract_answer(response: str, answer_type: str) -> str | None:
    """Route to the correct extractor based on answer type."""
    response_clean = response.strip()
    if answer_type in ("entailment", "contradiction"):
        return extract_binary_answer(response_clean)
    elif answer_type == "numerical":
        return extract_numerical_answer(response_clean)
    else:
        return response_clean


# ── evaluation ─────────────────────────────────────────────────────────────

def normalize_answer(ans: str) -> str:
    """Normalize answer for comparison: strip $, commas, lowercase."""
    if not ans:
        return ""
    a = ans.strip().lower()
    a = a.replace(",", "").replace("$", "")
    return a


def answers_match(predicted: str, gold: str) -> bool:
    """
    Compare predicted vs gold answer.

    - For binary (Entailment / Contradiction): case-insensitive exact match.
    - For numerical: strip $, commas, compare as integers (tolerant to ±1 rounding).
    """
    if not predicted or not gold:
        return False

    pred_norm = predicted.strip().lower()
    gold_norm = gold.strip().lower()

    # Binary match
    if pred_norm in ("entailment", "contradiction") and gold_norm in ("entailment", "contradiction"):
        return pred_norm == gold_norm

    # Numerical match — compare integer values
    pred_num = re.sub(r'[^\d]', '', predicted)
    gold_num = re.sub(r'[^\d]', '', gold)
    if pred_num and gold_num:
        return int(pred_num) == int(gold_num)

    return pred_norm == gold_norm


def evaluate():
    parser = argparse.ArgumentParser(description="Evaluate baselines on SARA v3")
    parser.add_argument("--llm", type=str, default="gpt-4o",
                        choices=list(LLM_CONFIG.keys()),
                        help="LLM model name (key in LLM_CONFIG)")
    parser.add_argument("--baseline", type=str, default="CoT",
                        choices=["direct", "CoT"],
                        help="Prompting strategy")
    parser.add_argument("--max-tokens", type=int, default=4096,
                        help="Max tokens for non-reasoning models")
    parser.add_argument("--overwrite", action="store_true",
                        help="Re-run even if result file already exists")
    args = parser.parse_args()

    llm_name = args.llm
    baseline = args.baseline
    result_fpath = RESULT_DIR / f"{baseline}_{llm_name}.json"

    # ── setup ──────────────────────────────────────────────────────────
    # ensure result directory
    RESULT_DIR.mkdir(parents=True, exist_ok=True)

    # load test data
    if not DEV_JSON.exists():
        print(f"[ERROR] Test data not found at {DEV_JSON}")
        sys.exit(1)
    with open(DEV_JSON, encoding="utf-8") as f:
        sample_list = json.load(f)
    print(f"Loaded {len(sample_list)} test samples from {DEV_JSON}")

    # load prompt template
    prompt_fpath = PROMPT_TEMPLATES.get(baseline)
    if not prompt_fpath or not prompt_fpath.exists():
        print(f"[ERROR] Prompt template not found: {prompt_fpath}")
        sys.exit(1)
    with open(prompt_fpath, encoding="utf-8") as f:
        prompt_template = f.read()
    print(f"Prompt template: {prompt_fpath.name}")

    # init LLM
    llm_config = LLM_CONFIG.get(llm_name)
    if not llm_config:
        print(f"[ERROR] Unknown LLM '{llm_name}'. Available: {list(LLM_CONFIG.keys())}")
        sys.exit(1)
    llm = OpenAIModel(llm_config, max_new_tokens=args.max_tokens, temp=0)
    print(f"LLM: {llm_name} (reasoning={llm_config.is_reasoning})")

    # ── load checkpoint ────────────────────────────────────────────────
    existing_results = []
    processed_ids = set()
    if result_fpath.exists() and not args.overwrite:
        with open(result_fpath, encoding="utf-8") as f:
            existing_results = json.load(f)
        processed_ids = {r["id"] for r in existing_results}
        print(f"Loaded checkpoint with {len(processed_ids)} existing results.")

    # ── main loop ──────────────────────────────────────────────────────
    result_list = list(existing_results)
    internet_issues = []
    stats = {"total": len(sample_list), "correct": 0, "wrong": 0, "skip": 0}
    # Re-count existing results
    for r in existing_results:
        if r.get("is_correct"):
            stats["correct"] += 1
        else:
            stats["wrong"] += 1

    for sample in tqdm(sample_list, desc=f"SARA {baseline}"):
        sid = sample["id"]

        # skip if already processed
        if sid in processed_ids:
            continue

        print(f"\n{'='*60}")
        print(f"[{sid}]  gold: {sample['answer']}  type: {sample['answer_type']}")

        # build prompt
        context_str = sample["context"]
        question_str = sample["question"]
        options_str = "\n".join(sample["options"]) if sample.get("options") else ""

        prompt = (
            prompt_template
            .replace("[[CONTEXT]]", context_str)
            .replace("[[QUESTION]]", question_str)
            .replace("[[OPTIONS]]", options_str)
        )

        # call LLM (with retries)
        response = None
        for attempt in range(3):
            try:
                response = llm.generate(prompt)
                break
            except Exception as e:
                print(f"  [retry {attempt + 1}/3] {e}")
                time.sleep(2 ** attempt)

        if not response:
            print(f"  [ERROR] Connection failed for {sid}")
            internet_issues.append(sid)
            result_list.append({
                "id": sid,
                "answer_type": sample["answer_type"],
                "gold_answer": sample["answer"],
                "statutes_used": sample.get("statutes_used", []),
                "raw_output": "",
                "answer": None,
                "is_correct": False,
                "error": "connection_error",
            })
            stats["wrong"] += 1
            continue

        # extract answer
        predicted = extract_answer(response, sample["answer_type"])
        gold = sample["answer"]
        is_correct = answers_match(predicted, gold) if predicted else False

        if is_correct:
            stats["correct"] += 1
        else:
            stats["wrong"] += 1

        print(f"  gold:      {gold}")
        print(f"  predicted: {predicted}")
        print(f"  correct:   {is_correct}")

        result_entry = {
            "id": sid,
            "answer_type": sample["answer_type"],
            "gold_answer": gold,
            "statutes_used": sample.get("statutes_used", []),
            "raw_output": response,
            "answer": predicted,
            "is_correct": is_correct,
        }
        result_list.append(result_entry)

        # ── save checkpoint periodically ──────────────────────────────
        if len(result_list) % 10 == 0:
            with open(result_fpath, "w", encoding="utf-8") as f:
                json.dump(result_list, f, indent=2, ensure_ascii=False)

    # ── final save ──────────────────────────────────────────────────────
    with open(result_fpath, "w", encoding="utf-8") as f:
        json.dump(result_list, f, indent=2, ensure_ascii=False)

    # ── print summary ───────────────────────────────────────────────────
    accuracy = stats["correct"] / (stats["correct"] + stats["wrong"]) * 100 if (
        stats["correct"] + stats["wrong"]
    ) > 0 else 0.0

    print(f"\n{'='*60}")
    print(f"RESULTS — {baseline} / {llm_name}")
    print(f"{'='*60}")
    print(f"  Total samples:  {stats['total']}")
    print(f"  Correct:        {stats['correct']}")
    print(f"  Wrong:          {stats['wrong']}")
    print(f"  Accuracy:       {accuracy:.2f}%")
    print(f"  Result saved:   {result_fpath}")

    # Per-type breakdown
    type_stats: dict[str, dict] = {}
    for r in result_list:
        t = r.get("answer_type", "unknown")
        if t not in type_stats:
            type_stats[t] = {"correct": 0, "total": 0}
        type_stats[t]["total"] += 1
        if r.get("is_correct"):
            type_stats[t]["correct"] += 1

    print(f"\n  Per-type breakdown:")
    for t in ["entailment", "contradiction", "numerical"]:
        if t in type_stats:
            s = type_stats[t]
            acc = s["correct"] / s["total"] * 100 if s["total"] > 0 else 0.0
            print(f"    {t:15s}: {s['correct']:3d}/{s['total']:<3d} ({acc:.2f}%)")

    if internet_issues:
        print(f"\n  Internet issues ({len(internet_issues)}): {internet_issues}")


if __name__ == "__main__":
    evaluate()
