'''Print overall and per-size accuracy from a ZebraLogic result JSON file.'''

import json
import sys
import os
from collections import defaultdict

if len(sys.argv) < 2:
    print("Usage: python print_accuracy.py <result_file>")
    print("Example: python baselines/print_accuracy.py baselines/results/ZebraLogic_CoT_dpsk-chat.json")
    sys.exit(1)

fpath = sys.argv[1]

with open(fpath, encoding='utf-8') as f:
    results = json.load(f)

size_stats = defaultdict(lambda: {"correct": 0, "total": 0})
for r in results:
    sz = r["size"]
    size_stats[sz]["total"] += 1
    if r.get("is_correct"):
        size_stats[sz]["correct"] += 1

total_correct = sum(s["correct"] for s in size_stats.values())
total_all = sum(s["total"] for s in size_stats.values())

basename = os.path.splitext(os.path.basename(fpath))[0]

print(f"File: {basename}")
print(f"Accuracy: {total_correct}/{total_all} = {total_correct / total_all * 100:.2f}%")
print()
print("Per-size accuracy:")
print(f"  {'Size':5s}  {'Correct':>7s}  {'Rate':>6s}")
for sz in sorted(size_stats, key=lambda x: [int(v) for v in x.split('*')]):
    s = size_stats[sz]
    rate = s["correct"] / s["total"] * 100
    print(f"  {sz:5s}  {s['correct']:2d}/{s['total']:2d}  {rate:5.1f}%")
