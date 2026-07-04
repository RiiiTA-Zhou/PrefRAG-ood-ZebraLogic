"""Rewrite PrefRAG correction section to match LogicLM style."""

import json, os, hashlib

BASE = os.path.dirname(os.path.abspath(__file__))

MODELS = [
    ("gpt-4o", "GPT-4o"),
    ("dpsk-chat", "DeepSeek-Chat"),
    ("dpsk-reasoner", "DeepSeek-Reasoner"),
    ("o3-mini", "O3-Mini"),
    ("dpsk-v4-flash", "DeepSeek-V4-Flash"),
    ("dpsk-v4-pro", "DeepSeek-V4-Pro"),
]

def load_jsonl(path):
    recs = []
    with open(path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line:
                recs.append(json.loads(line))
    return recs

base = os.path.join(BASE, "evaluation_result", "RAG-fixer-ZebraLogic")

# Check duplicates
hashes = {}
for s, m in MODELS:
    p = os.path.join(base, f"result-{s}.jsonl")
    if os.path.exists(p):
        with open(p, "rb") as fh:
            h = hashlib.md5(fh.read()).hexdigest()
        hashes[m] = h
dup_models = set()
seen = {}
for model, h in hashes.items():
    if h in seen:
        dup_models.add(model)
        dup_models.add(seen[h])
    else:
        seen[h] = model

L = []
L.append("")
L.append("---")
L.append("## PrefRAG — Correction Effectiveness")
L.append("")
L.append("PrefRAG uses a RAG fixer to identify and correct errors in Z3 programs.")
L.append("The fixer judges whether the current program+execution has an error; if it finds one,")
L.append("it retrieves similar examples and generates a corrected program (up to 3 rounds).")
L.append("")

for s, m in MODELS:
    fpath = os.path.join(base, f"result-{s}.jsonl")
    if not os.path.exists(fpath):
        continue

    recs = load_jsonl(fpath)
    total = len(recs)

    # Duplicate warning
    if m in dup_models:
        L.append(f"> [!WARNING] {m}: result file identical to another model (MD5 match), data may be unreliable")
        L.append("")

    prog_len_dist = {}
    round_stats = {}
    init_exec_error = 0
    init_success = 0
    fixed_by_correction = 0
    still_error_after = 0
    broke_early = 0
    final_correct_fixed = 0
    fix_by_round = {}
    total_correct = sum(1 for r in recs if r.get("is_correct"))

    for r in recs:
        progs = r.get("programs", [])
        n = len(progs)
        prog_len_dist[n] = prog_len_dist.get(n, 0) + 1

        for i, p in enumerate(progs):
            if i not in round_stats:
                round_stats[i] = {"entered": 0, "success": 0, "exec_error": 0, "semantic": 0}
            round_stats[i]["entered"] += 1
            flag = p.get("execution", {}).get("flag", "unknown")
            if flag == "success":
                round_stats[i]["success"] += 1
            elif flag == "execution error":
                round_stats[i]["exec_error"] += 1
            else:
                round_stats[i]["semantic"] += 1

        # Initial state
        if len(progs) >= 1:
            first_flag = progs[0].get("execution", {}).get("flag", "")
            is_correct = r.get("is_correct", False)
            if first_flag == "execution error":
                init_exec_error += 1
                got_fixed = False
                for j, p in enumerate(progs):
                    if j == 0:
                        continue
                    if j not in fix_by_round:
                        fix_by_round[j] = {"attempted": 0, "succeeded": 0, "correct_after": 0}
                    fix_by_round[j]["attempted"] += 1
                    flag_j = p.get("execution", {}).get("flag", "")
                    if flag_j == "success":
                        fix_by_round[j]["succeeded"] += 1
                        got_fixed = True
                        if is_correct:
                            fix_by_round[j]["correct_after"] += 1
                if got_fixed:
                    fixed_by_correction += 1
                    if is_correct:
                        final_correct_fixed += 1
                else:
                    last_flag = progs[-1].get("execution", {}).get("flag", "")
                    if last_flag == "execution error":
                        still_error_after += 1
                    else:
                        broke_early += 1
            else:
                init_success += 1

    L.append(f"### {m}")
    L.append("")

    # Rounds distribution
    L.append("**Correction Rounds Distribution**")
    L.append("")
    L.append("| Rounds | Samples | % |")
    L.append("|-------:|-------:|---:|")
    for n in sorted(prog_len_dist):
        c = n - 1
        L.append(f"| {c} | {prog_len_dist[n]:4d} | {prog_len_dist[n]/total*100:.1f}% |")
    L.append("")

    # Round-by-round execution
    L.append("**Per-Round Execution Flag**")
    L.append("")
    L.append("| Stage | Entered | Success | Exec Error | Semantic Error |")
    L.append("|------:|-------:|--------:|-----------:|---------------:|")
    for ri in sorted(round_stats):
        label = "Initial" if ri == 0 else f"Corr.{ri}"
        rs = round_stats[ri]
        succ_pct = rs["success"] / rs["entered"] * 100 if rs["entered"] > 0 else 0
        err_pct = rs["exec_error"] / rs["entered"] * 100 if rs["entered"] > 0 else 0
        sem_pct = rs["semantic"] / rs["entered"] * 100 if rs["entered"] > 0 else 0
        L.append(f"| {label} | {rs['entered']:4d} | {rs['success']:3d} ({succ_pct:5.1f}%) | {rs['exec_error']:3d} ({err_pct:5.1f}%) | {rs['semantic']:3d} ({sem_pct:5.1f}%) |")
    L.append("")

    # Correction impact
    L.append("**Correction Impact**")
    L.append("")
    L.append(f"- Initial execution errors: **{init_exec_error}**")
    L.append(f"- Initial success / semantic: **{init_success}**")
    if init_exec_error > 0:
        fix_rate = fixed_by_correction / init_exec_error * 100
        L.append(f"- Fixed by correction: **{fixed_by_correction}** ({fix_rate:.1f}%)")
        if still_error_after:
            L.append(f"- Still error after all rounds: **{still_error_after}**")
        if broke_early:
            L.append(f"- Broke early (non-exec-error, can't fix): **{broke_early}**")
        L.append(f"- Fixed and answer correct: **{final_correct_fixed}**")
    L.append(f"- Total correct: **{total_correct}/{total}** ({total_correct/total*100:.1f}%)")
    L.append("")

    # Per-round fix effectiveness
    if fix_by_round:
        L.append("**Per-Round Fix Effectiveness**")
        L.append("")
        L.append("| Round | Attempted | Fixed | Fix Rate | Correct after Fix |")
        L.append("|------:|----------:|------:|---------:|------------------:|")
        for rj in sorted(fix_by_round):
            fb = fix_by_round[rj]
            fix_pct = fb["succeeded"] / fb["attempted"] * 100 if fb["attempted"] > 0 else 0
            corr_pct = fb["correct_after"] / fb["succeeded"] * 100 if fb["succeeded"] > 0 else 0
            L.append(f"| {rj} | {fb['attempted']:3d} | {fb['succeeded']:3d} | {fix_pct:.1f}% | {fb['correct_after']:3d} ({corr_pct:.1f}%) |")
        L.append("")

out = "\n".join(L)
outpath = os.path.join(BASE, "_prefrag_restyle.md")
with open(outpath, "w", encoding="utf-8") as f:
    f.write(out)
print("Written to", outpath)
