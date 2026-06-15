import pyarrow as pa
import json
import os
import sys

base_dir = os.path.dirname(os.path.abspath(__file__))

arrow_files = []
for root, dirs, files in os.walk(base_dir):
    for f in files:
        if f.endswith(".arrow"):
            arrow_files.append(os.path.join(root, f))

if not arrow_files:
    print("No .arrow files found.")
    sys.exit(0)

for arrow_path in sorted(arrow_files):
    rel_path = os.path.relpath(arrow_path, base_dir)
    json_path = os.path.splitext(arrow_path)[0] + ".json"

    print(f"Converting: {rel_path}")
    table = pa.ipc.open_stream(arrow_path).read_all()
    rows = table.to_pylist()

    with open(json_path, "w", encoding="utf-8") as f:
        json.dump(rows, f, ensure_ascii=False, indent=2)

    print(f"  -> {len(rows)} rows written to {os.path.relpath(json_path, base_dir)}")
