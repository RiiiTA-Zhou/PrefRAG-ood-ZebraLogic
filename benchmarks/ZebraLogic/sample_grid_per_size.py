import pyarrow as pa
import json
import os
import random

random.seed(42)

base_dir = os.path.dirname(os.path.abspath(__file__))
arrow_path = os.path.join(base_dir, "grid_mode", "data-00000-of-00001.arrow")

table = pa.ipc.open_stream(arrow_path).read_all()
rows = table.to_pylist()

size_buckets = {}
for r in rows:
    s = r["size"]
    size_buckets.setdefault(s, []).append(r)

sampled = []
for size in sorted(size_buckets):
    pool = size_buckets[size]
    k = min(20, len(pool))
    chosen = random.sample(pool, k)
    sampled.extend(chosen)
    print(f"  size={size}: sampled {k} from {len(pool)} available")

output_path = os.path.join(base_dir, "grid_mode_sampled.json")
with open(output_path, "w", encoding="utf-8") as f:
    json.dump(sampled, f, ensure_ascii=False, indent=2)

print(f"\nTotal sampled: {len(sampled)}")
print(f"Saved to: {output_path}")
