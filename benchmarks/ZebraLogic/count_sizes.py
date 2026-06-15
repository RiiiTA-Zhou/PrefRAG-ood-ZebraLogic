import pyarrow as pa
import os

base_dir = os.path.dirname(os.path.abspath(__file__))
arrow_path = os.path.join(base_dir, "grid_mode", "data-00000-of-00001.arrow")

table = pa.ipc.open_stream(arrow_path).read_all()
rows = table.to_pylist()

size_counts = {}
for r in rows:
    s = r["size"]
    size_counts[s] = size_counts.get(s, 0) + 1

print(f"Total instances in grid_mode: {len(rows)}")
print(f"Distinct sizes: {len(size_counts)}")
print()
for size in sorted(size_counts):
    print(f"  size={size}: {size_counts[size]}")
