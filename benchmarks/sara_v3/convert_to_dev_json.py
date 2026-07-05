"""
Convert SARA v3 (Statutory Reasoning Dataset) Prolog cases into PrefRAG-compatible JSON format.

Parses:
  - sara_v3/splits/test        -> list of 120 test case names (without .pl)
  - sara_v3/cases/<name>.pl    -> individual Prolog case files
  - sara_v3/statutes/source/*  -> plain-text US tax code sections

Output:
  - sara_v3/dev.json           -> PrefRAG evaluation format

Usage:
  python benchmarks/sara_v3/convert_to_dev_json.py
"""

import re
import os
import json
from pathlib import Path

# --------------- paths ---------------
BASE = Path(__file__).resolve().parent
CASES_DIR = BASE / "cases"
SPLITS_DIR = BASE / "splits"
STATUTES_DIR = BASE / "statutes" / "source"
OUTPUT = BASE / "dev.json"

# --------------- statute mapping ---------------
# Map filename prefix -> statute source file(s)
# For simple cases, the prefix tells us the primary statute.
# For multi-step tax_case, include all relevant tax-computation sections.
STATUTE_MAP = {
    's1': ['section1'],
    's2': ['section2'],
    's63': ['section63'],
    's68': ['section68'],
    's151': ['section151'],
    's152': ['section152'],
    's3301': ['section3301'],
    's3306': ['section3306'],
    's7703': ['section7703'],
    'tax_case': [
        'section1', 'section2', 'section63', 'section68',
        'section151', 'section152', 'section7703'
    ],
}


def get_prefix(case_name: str) -> str | None:
    """Extract the statute prefix from a case filename (e.g. 's151_d_1_pos' -> 's151')."""
    if case_name.startswith('tax_case'):
        return 'tax_case'
    m = re.match(r'^(s\d+)_', case_name)
    if m:
        return m.group(1)
    return None


# All known statute section numbers (matching statute source filenames).
KNOWN_SECTION_NUMS = {'1', '2', '63', '68', '151', '152', '3301', '3306', '7703'}
STATUTE_FILE_MAP = {num: f'section{num}' for num in KNOWN_SECTION_NUMS}


def extract_statutes_from_text(text: str) -> list[str]:
    """Extract statute names like 'section151' from text containing 'section 151(b)'.

    Scans for the pattern ``section <number>`` where <number> is one of the
    known statute section numbers.
    """
    found: set[str] = set()
    for m in re.finditer(r'\bsection\s+(\d+)', text, re.IGNORECASE):
        num = m.group(1)
        if num in KNOWN_SECTION_NUMS:
            found.add(STATUTE_FILE_MAP[num])
    return sorted(found)


def load_statute_text(statute_name: str) -> str:
    """Load a statute source file, returning its text content."""
    path = STATUTES_DIR / statute_name
    if not path.exists():
        print(f"  [WARN] Statute file not found: {path}")
        return f"[{statute_name} not found]"
    return path.read_text(encoding='utf-8').strip()


def parse_case_file(path: Path) -> dict:
    """Parse a single .pl Prolog case file into structured fields.

    Returns:
        {
            'text': str,       # scenario description (from % Text section)
            'question_raw': str,  # full % Question line (including answer suffix)
            'facts_code': str,    # Prolog facts code
            'test_code': str,     # Prolog test query
        }
    """
    content = path.read_text(encoding='utf-8')
    lines = content.split('\n')

    # The file is structured as comment sections separated by blank lines
    # % Text ... % Question ... % Facts ... % Test
    sections = {
        'text': [],
        'question': [],
        'facts': [],
        'test': [],
    }
    current_section = None

    for line in lines:
        stripped = line.strip()
        if stripped == '% Text':
            current_section = 'text'
            continue
        elif stripped == '% Question':
            current_section = 'question'
            continue
        elif stripped == '% Facts':
            current_section = 'facts'
            continue
        elif stripped == '% Test':
            current_section = 'test'
            continue

        if current_section:
            sections[current_section].append(line)

    result = {}

    # Text section: join all comment lines (strip leading % and whitespace)
    text_lines = []
    for l in sections['text']:
        cleaned = l.strip()
        cleaned = re.sub(r'^%\s*', '', cleaned).strip()
        if cleaned:
            text_lines.append(cleaned)
    result['text'] = ' '.join(text_lines)

    # Question section: single line with the question + answer
    q_lines = []
    for l in sections['question']:
        cleaned = l.strip()
        cleaned = re.sub(r'^%\s*', '', cleaned).strip()
        if cleaned:
            q_lines.append(cleaned)
    result['question_raw'] = ' '.join(q_lines) if q_lines else ''

    # Facts section: the Prolog code
    facts_lines = [l for l in sections['facts'] if l.strip()]
    result['facts_code'] = '\n'.join(facts_lines)

    # Test section: Prolog test queries
    test_lines = [l for l in sections['test'] if l.strip()]
    result['test_code'] = '\n'.join(test_lines)

    return result


def parse_answer(question_raw: str) -> tuple:
    """Parse the full question line to extract (question_text, answer, answer_type).

    Answer types:
      - 'entailment': the statement is true
      - 'contradiction': the statement is false
      - 'numerical': a dollar amount
    """
    q = question_raw.strip()

    # Pattern 1: ends with ". Entailment" (case-insensitive)
    m = re.search(r'\.\s*Entailment\s*$', q, re.IGNORECASE)
    if m:
        question_text = q[:m.start()] + '.'
        return question_text.strip(), 'Entailment', 'entailment'

    # Pattern 2: ends with ". Contradiction"
    m = re.search(r'\.\s*Contradiction\s*$', q, re.IGNORECASE)
    if m:
        question_text = q[:m.start()] + '.'
        return question_text.strip(), 'Contradiction', 'contradiction'

    # Pattern 3: ends with "? $<number>"
    m = re.search(r'\?\s*\$(\d[\d,]*)\s*$', q)
    if m:
        question_text = q[:m.start() + 1]  # include the question mark
        answer = '$' + m.group(1)
        return question_text.strip(), answer, 'numerical'

    # Pattern 4: statement ending with "$<amount>." (e.g., "equal to $2000.")
    # followed by nothing — should have been caught above as entailment/contradiction
    # but just in case:
    m = re.search(r'\$(\d[\d,]*)', q)
    if m:
        # Try extracting just the dollar amount as answer
        return q, m.group(0), 'numerical'

    # Fallback: return raw
    print(f"  [WARN] Could not parse answer from: {q[:80]}...")
    return q, q, 'unknown'


def build_question_text(scenario: str, question_text: str) -> str:
    """Combine scenario and question into a single question field."""
    return f"{scenario}\n\n{question_text}"


def main():
    # ---- load test split ----
    test_path = SPLITS_DIR / "test"
    if not test_path.exists():
        print(f"ERROR: Test split not found at {test_path}")
        return

    case_names = [
        line.strip()
        for line in test_path.read_text(encoding='utf-8').splitlines()
        if line.strip()
    ]
    print(f"Found {len(case_names)} test cases in split file.")

    # ---- preload all statutes ----
    statute_texts = {}
    for fname in sorted(STATUTES_DIR.iterdir()):
        if fname.is_file() and not fname.name.startswith('.'):
            statute_texts[fname.name] = fname.read_text(encoding='utf-8').strip()
    print(f"Loaded {len(statute_texts)} statute sections.")

    # ---- process each case ----
    entries = []
    errors = []

    for idx, case_name in enumerate(case_names):
        case_path = CASES_DIR / f"{case_name}.pl"
        if not case_path.exists():
            errors.append(f"Missing case file: {case_name}.pl")
            continue

        # Parse Prolog file
        parsed = parse_case_file(case_path)

        if not parsed['question_raw']:
            errors.append(f"Empty question in: {case_name}")
            continue

        # Parse question + answer
        question_text, answer, answer_type = parse_answer(parsed['question_raw'])

        # Determine which statutes to include.
        # Strategy: extract all "section N" references from the question and scenario
        # text, then merge with the prefix-based default mapping (important for
        # tax_case files that don't explicitly enumerate every referenced section).
        search_text = parsed['question_raw'] + ' ' + parsed['text']
        text_statutes = extract_statutes_from_text(search_text)
        prefix = get_prefix(case_name)
        prefix_statutes = STATUTE_MAP.get(prefix, [])
        # Union, preserving order: text-derived first, prefix-based as fallback
        all_statute_names = list(dict.fromkeys(text_statutes + prefix_statutes))

        statutes_loaded = []
        statute_context_parts = []
        for sn in all_statute_names:
            text = statute_texts.get(sn)
            if text:
                statute_context_parts.append(text)
                statutes_loaded.append(sn)
            else:
                print(f"  [WARN] Statute '{sn}' not loaded for case {case_name}")

        context = '\n\n'.join(statute_context_parts)

        # Build the question field (scenario + question)
        question = build_question_text(parsed['text'], question_text)

        # Options
        if answer_type in ('entailment', 'contradiction'):
            options = ["Entailment", "Contradiction"]
        else:
            options = []

        entry = {
            "id": case_name,
            "context": context,
            "question": question,
            "options": options,
            "answer": answer,
            "answer_type": answer_type,
            "statutes_used": statutes_loaded,
        }
        entries.append(entry)

        if (idx + 1) % 20 == 0:
            print(f"  Processed {idx + 1}/{len(case_names)} cases...")

    # ---- summary statistics ----
    type_counts = {}
    for e in entries:
        t = e['answer_type']
        type_counts[t] = type_counts.get(t, 0) + 1

    print(f"\n{'='*50}")
    print(f"Processed {len(entries)} cases successfully.")
    print(f"Errors: {len(errors)}")
    print(f"\nAnswer type distribution:")
    for t, c in sorted(type_counts.items()):
        print(f"  {t}: {c}")
    print(f"\nStatute usage:")
    statute_usage = {}
    for e in entries:
        for s in e['statutes_used']:
            statute_usage[s] = statute_usage.get(s, 0) + 1
    for s, c in sorted(statute_usage.items()):
        print(f"  {s}: {c} cases")

    if errors:
        print(f"\nErrors ({len(errors)}):")
        for err in errors[:10]:
            print(f"  - {err}")
        if len(errors) > 10:
            print(f"  ... and {len(errors) - 10} more")

    # ---- write output ----
    with open(OUTPUT, 'w', encoding='utf-8') as f:
        json.dump(entries, f, indent=2, ensure_ascii=False)

    print(f"\nOutput written to: {OUTPUT}")
    print(f"File size: {os.path.getsize(OUTPUT) / 1024:.1f} KB")


if __name__ == '__main__':
    main()
