import pyarrow as pa
import random
import json
import os

random.seed(42)

base_dir = os.path.dirname(os.path.abspath(__file__))
grid_file = os.path.join(base_dir, "grid_mode", "data-00000-of-00001.arrow")
mc_file = os.path.join(base_dir, "mc_mode", "data-00000-of-00001.arrow")
output_dir = os.path.join(base_dir, "sampled")
os.makedirs(output_dir, exist_ok=True)

grid_t = pa.ipc.open_stream(grid_file).read_all()
mc_t = pa.ipc.open_stream(mc_file).read_all()

grid_rows = grid_t.to_pylist()
mc_rows = mc_t.to_pylist()

# Pick 2 random grid entries
sampled_grid = random.sample(grid_rows, 2)

output = []
for g in sampled_grid:
    # Grid entry as standalone
    output.append({
        "source": f"zebralogic-grid-{g['id']}",
        "mode": "grid",
        "id": g["id"],
        "size": g["size"],
        "puzzle": g["puzzle"],
        "solution": g["solution"],
    })

    # All matching mc entries as standalone, each with the full puzzle
    matched = [m for m in mc_rows if m["id"].startswith(g["id"] + "#mc-")]
    for m in matched:
        output.append({
            "source": f"zebralogic-mc-{m['id']}",
            "mode": "mc",
            "id": m["id"],
            "grid_id": g["id"],
            "puzzle": g["puzzle"],
            "question": m["question"],
            "choices": m["choices"],
            "answer": m["answer"],
        })

output_file = os.path.join(output_dir, "sampled_zebralogic.json")
with open(output_file, "w", encoding="utf-8") as f:
    json.dump(output, f, ensure_ascii=False, indent=2)

grid_count = sum(1 for x in output if x["mode"] == "grid")
mc_count = sum(1 for x in output if x["mode"] == "mc")
print(f"Sampled: {grid_count} grid + {mc_count} mc → {output_file}")
for x in output:
    tag = f"[{x['mode']}] {x['source']}"
    if x["mode"] == "mc":
        print(f"  {tag}")
    else:
        print(f"  {tag}  size: {x['size']}")
