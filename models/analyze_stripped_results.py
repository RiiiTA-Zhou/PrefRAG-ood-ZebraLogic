"""
Analyze and compare the stripped vs original PrefRAG results on ZebraLogic.
"""

import json
import sys
from collections import Counter, defaultdict

# ---- Load data ----
def load_results(path):
    results = []
    with open(path, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.strip()
            if line:
                results.append(json.loads(line))
    return results

stripped_path = "evaluation_result/RAG-fixer-ZebraLogic/result-dpsk-v4-flash-stripped.jsonl"
original_path = "evaluation_result/RAG-fixer-ZebraLogic/result-dpsk-v4-flash.jsonl"

stripped = load_results(stripped_path)
original = load_results(original_path)

print(f"Stripped version: {len(stripped)} samples")
print(f"Original version: {len(original)} samples")

# ---- Helper: per-sample info ----
def get_program_count(programs):
    """Count how many programs were generated (1 initial + N corrections)."""
    return len(programs)

def get_correction_rounds(programs):
    """Return number of correction rounds (total programs - 1)."""
    return len(programs) - 1

# ---- 1. Overall accuracy ----
def compute_accuracy(results):
    correct = sum(1 for r in results if r.get("is_correct"))
    total = len(results)
    return correct, total, correct / total * 100 if total else 0

print("\n" + "=" * 60)
print("OVERALL ACCURACY")
print("=" * 60)
for name, data in [("Original", original), ("Stripped", stripped)]:
    c, t, p = compute_accuracy(data)
    print(f"  {name:12s}: {c:3d}/{t:3d} = {p:5.2f}%")

# ---- 2. Size-wise accuracy ----
def size_accuracy(results):
    sizes = defaultdict(lambda: {"correct": 0, "total": 0})
    for r in results:
        sz = r.get("size", "unknown")
        sizes[sz]["total"] += 1
        if r.get("is_correct"):
            sizes[sz]["correct"] += 1
    return sizes

print("\n" + "=" * 60)
print("SIZE-WISE ACCURACY")
print("=" * 60)
all_sizes = sorted(set(list(size_accuracy(stripped).keys()) + list(size_accuracy(original).keys())),
                   key=lambda x: [int(v) for v in x.split('*')])
print(f"  {'Size':8s} {'Orig':>10s} {'Strip':>10s} {'Diff':>8s}")
for sz in all_sizes:
    orig_s = size_accuracy(original).get(sz, {"correct": 0, "total": 0})
    strip_s = size_accuracy(stripped).get(sz, {"correct": 0, "total": 0})
    orig_p = orig_s["correct"] / orig_s["total"] * 100 if orig_s["total"] else 0
    strip_p = strip_s["correct"] / strip_s["total"] * 100 if strip_s["total"] else 0
    diff = strip_p - orig_p
    print(f"  {sz:8s} {orig_p:6.1f}%({orig_s['correct']}/{orig_s['total']:2d}) "
          f"{strip_p:6.1f}%({strip_s['correct']}/{strip_s['total']:2d}) "
          f"{diff:+7.2f}%")

# ---- 3. Correction rounds distribution ----
print("\n" + "=" * 60)
print("CORRECTION ROUNDS DISTRIBUTION")
print("=" * 60)
for name, data in [("Original", original), ("Stripped", stripped)]:
    rounds = Counter()
    for r in data:
        rnd = get_correction_rounds(r.get("programs", []))
        rounds[rnd] += 1
    print(f"\n  {name}:")
    for r in sorted(rounds.keys()):
        n = rounds[r]
        print(f"    {r} round(s): {n:3d} samples ({n/len(data)*100:5.1f}%)")

# ---- 4. Correction rounds vs accuracy ----
print("\n" + "=" * 60)
print("ACCURACY BY CORRECTION ROUNDS")
print("=" * 60)
for name, data in [("Original", original), ("Stripped", stripped)]:
    print(f"\n  {name}:")
    print(f"    {'Rounds':>8s} {'Correct':>10s} {'Total':>6s} {'Acc':>7s}")
    round_stats = defaultdict(lambda: {"correct": 0, "total": 0})
    for r in data:
        rnd = get_correction_rounds(r.get("programs", []))
        round_stats[rnd]["total"] += 1
        if r.get("is_correct"):
            round_stats[rnd]["correct"] += 1
    for rnd in sorted(round_stats.keys()):
        s = round_stats[rnd]
        p = s["correct"] / s["total"] * 100
        print(f"    {rnd:8d} {s['correct']:4d}/{s['total']:2d} ({p:5.1f}%)")

# ---- 5. Initial translation success rate ----
print("\n" + "=" * 60)
print("INITIAL TRANSLATION (BEFORE ANY FIX)")
print("=" * 60)
for name, data in [("Original", original), ("Stripped", stripped)]:
    init_success = 0
    init_correct = 0
    init_total = 0
    for r in data:
        programs = r.get("programs", [])
        if programs:
            init_total += 1
            exec_flag = programs[0].get("execution", {}).get("flag", "")
            if exec_flag == "success":
                init_success += 1
                # Check if initial answer was already correct
                # (We can't easily check this without re-evaluating, skip for now)
    print(f"  {name:12s}: initial execution success = {init_success}/{init_total} ({init_success/init_total*100:.1f}%)")

# ---- 6. Execution status distribution per round ----
print("\n" + "=" * 60)
print("EXECUTION STATUS PER PROGRAM")
print("=" * 60)
for name, data in [("Original", original), ("Stripped", stripped)]:
    max_programs = max(len(r.get("programs", [])) for r in data)
    print(f"\n  {name}:")
    print(f"    {'Prog#':>6s} {'Success':>10s} {'ExecErr':>10s} {'SemErr':>10s}")
    for prog_idx in range(max_programs):
        flags = Counter()
        for r in data:
            progs = r.get("programs", [])
            if prog_idx < len(progs):
                flags[progs[prog_idx].get("execution", {}).get("flag", "unknown")] += 1
        n = sum(flags.values())
        if n > 0:
            succ = flags.get("success", 0)
            exe = flags.get("execution error", 0)
            sem = flags.get("semantic error", 0)
            print(f"    {prog_idx:6d} {succ:4d}/{n:2d} ({succ/n*100:5.1f}%) "
                  f"{exe:4d}/{n:2d} ({exe/n*100:5.1f}%) "
                  f"{sem:4d}/{n:2d} ({sem/n*100:5.1f}%)")

# ---- 7. Execution-to-correct conversion rate ----
print("\n" + "=" * 60)
print("SUCCESS-TO-CORRECT CONVERSION (per round)")
print("=" * 60)
for name, data in [("Original", original), ("Stripped", stripped)]:
    print(f"\n  {name}:")
    max_programs = max(len(r.get("programs", [])) for r in data)
    for prog_idx in range(max_programs):
        success_and_correct = 0
        success_total = 0
        has_answer = 0
        for r in data:
            progs = r.get("programs", [])
            if prog_idx < len(progs):
                exec_flag = progs[prog_idx].get("execution", {}).get("flag", "")
                if exec_flag == "success":
                    success_total += 1
                    # Check if this program's answer led to final correctness
                    # For prog_idx 0 (initial), check if answer was set from initial
                    if prog_idx == 0 and r.get("is_correct"):
                        # The initial answer might have been overwritten by later rounds
                        # This is tricky; let's just show the final answer state
                        pass
        print(f"    Round {prog_idx}: {success_total} successful executions")

# ---- 8. Overlap analysis: which samples differ? ----
print("\n" + "=" * 60)
print("SAMPLE-LEVEL COMPARISON")
print("=" * 60)
stripped_by_id = {r["id"]: r for r in stripped}
original_by_id = {r["id"]: r for r in original}
common_ids = set(stripped_by_id.keys()) & set(original_by_id.keys())

both_correct = 0
both_wrong = 0
strip_correct_orig_wrong = 0
strip_wrong_orig_correct = 0
strip_only = 0
orig_only = 0

for sid in sorted(common_ids):
    s = stripped_by_id[sid]["is_correct"]
    o = original_by_id[sid]["is_correct"]
    if s and o:
        both_correct += 1
    elif not s and not o:
        both_wrong += 1
    elif s and not o:
        strip_correct_orig_wrong += 1
    elif not s and o:
        strip_wrong_orig_correct += 1

for r in stripped:
    if r["id"] not in original_by_id:
        strip_only += 1
for r in original:
    if r["id"] not in stripped_by_id:
        orig_only += 1

print(f"  Common samples: {len(common_ids)}")
print(f"  Both correct  : {both_correct}")
print(f"  Both wrong    : {both_wrong}")
print(f"  Strip OK / Orig FAIL : {strip_correct_orig_wrong}  (stripped improved)")
print(f"  Strip FAIL / Orig OK : {strip_wrong_orig_correct}  (stripped regressed)")
print(f"  Stripped only : {strip_only}")
print(f"  Original only : {orig_only}")

# List the changed samples
if strip_correct_orig_wrong > 0 or strip_wrong_orig_correct > 0:
    print(f"\n  Changed samples:")
    for sid in sorted(common_ids):
        s = stripped_by_id[sid]["is_correct"]
        o = original_by_id[sid]["is_correct"]
        if s != o:
            direction = "OK->FAIL" if o and not s else "FAIL->OK"
            sz = stripped_by_id[sid].get("size", "?")
            print(f"    {direction} {sid} (size={sz})")
            if s:
                print(f"      Strip rounds: {get_correction_rounds(stripped_by_id[sid].get('programs',[]))}")
                print(f"      Orig  rounds: {get_correction_rounds(original_by_id[sid].get('programs',[]))}")

# ---- Summary ----
print("\n" + "=" * 60)
print("SUMMARY")
print("=" * 60)
print(f"  Stripped accuracy: {compute_accuracy(stripped)[2]:.2f}%")
print(f"  Original accuracy: {compute_accuracy(original)[2]:.2f}%")
strip_improved = strip_correct_orig_wrong - strip_wrong_orig_correct
print(f"  Net improvement: {strip_improved:+d} samples")
print("=" * 60)
