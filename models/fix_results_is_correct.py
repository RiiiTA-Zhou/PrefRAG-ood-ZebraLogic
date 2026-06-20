'''
Recompute is_correct for existing JSONL results from test_RAG_as_fixer-ZebraLogic.py.
The original extract_json_from_stdout failed to parse Z3's repr format (bare enum identifiers),
so many correct answers were stored as '' with is_correct=False.
This script re-parses the stored execution results, re-evaluates, and rewrites the JSONL.
'''

import sys
import os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import json
import re
import ast


def extract_json_from_stdout(stdout_lines):
    """Same fixed version as in test_RAG_as_fixer-ZebraLogic.py."""
    if not stdout_lines:
        return None
    text = "".join(stdout_lines).strip()
    if not text:
        return None
    try:
        return json.loads(text)
    except Exception:
        pass
    try:
        return ast.literal_eval(text)
    except Exception:
        pass
    try:
        fixed = re.sub(
            r'(?<=[\:\,\[])\s*([A-Za-z_]\w+)(?=\s*[\}\]\,])',
            lambda m: '"' + m.group(1) + '"',
            text,
        )
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


def recompute_jsonl(jsonl_path):
    """Read JSONL, recompute is_correct for every entry, rewrite in place."""
    if not os.path.exists(jsonl_path):
        print("File not found: %s" % jsonl_path)
        return

    print("Reading %s ..." % jsonl_path)
    with open(jsonl_path, "r", encoding="utf-8") as f:
        lines = f.readlines()

    updated = []
    changed = 0
    total = 0

    for line in lines:
        line = line.strip()
        if not line:
            continue
        rec = json.loads(line)
        total += 1

        # Re-parse answer from programs' execution results (last successful one)
        best_answer = rec.get("answer", None)

        # Try to find a better answer from the program execution logs
        programs = rec.get("programs", [])
        for prog in reversed(programs):  # last successful execution is best
            exec_dict = prog.get("execution", {})
            if exec_dict.get("flag") == "success":
                parsed = extract_json_from_stdout(exec_dict.get("result"))
                if parsed is not None and isinstance(parsed, list) and len(parsed) > 0:
                    best_answer = parsed
                    break

        # Recompute is_correct
        gold = rec.get("gold_answer")
        old_correct = rec.get("is_correct", False)
        new_correct = False
        if best_answer is not None and isinstance(best_answer, list) and len(best_answer) > 0:
            new_correct = compare_answers(gold, best_answer)

        if new_correct != old_correct:
            changed += 1
            print("  %s: is_correct %s -> %s" % (rec["id"], old_correct, new_correct))

        rec["answer"] = best_answer
        rec["is_correct"] = new_correct
        updated.append(rec)

    # Rewrite JSONL
    with open(jsonl_path, "w", encoding="utf-8") as f:
        for rec in updated:
            f.write(json.dumps(rec, ensure_ascii=False) + "\n")

    # Print summary
    size_stats = {}
    for r in updated:
        sz = r["size"]
        if sz not in size_stats:
            size_stats[sz] = {"correct": 0, "total": 0}
        size_stats[sz]["total"] += 1
        if r["is_correct"]:
            size_stats[sz]["correct"] += 1

    total_correct = sum(s["correct"] for s in size_stats.values())
    total_all = sum(s["total"] for s in size_stats.values())

    print("\nDone. %d/%d entries updated." % (changed, total))
    print("Accuracy: %d/%d = %.2f%%" % (total_correct, total_all, total_correct / total_all * 100))
    print("\nPer-size accuracy:")
    for sz in sorted(size_stats, key=lambda x: [int(v) for v in x.split('*')]):
        s = size_stats[sz]
        rate = s["correct"] / s["total"] * 100
        print("  %5s: %2d/%2d (%5.1f%%)" % (sz, s["correct"], s["total"], rate))


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python fix_results_is_correct.py <jsonl_path> [jsonl_path2 ...]")
        sys.exit(1)
    for path in sys.argv[1:]:
        recompute_jsonl(path)
