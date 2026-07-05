# SARA v3 — Statutory Reasoning Dataset

A benchmark for evaluating **statutory reasoning** in AI systems. SARA v3 tests the ability to apply US federal tax code provisions to concrete fact patterns, requiring interpretation of conditional rules, cross-referencing between statutes, and multi-step numerical computation.

## Dataset Overview

| Property | Value |
|----------|-------|
| Total cases | 376 |
| Train split | 256 |
| Test split | 120 |
| Covered statutes | 9 US Internal Revenue Code sections |
| Question types | Binary entailment/contradiction, numerical tax computation |
| Format | Prolog case files + plain-text statutes |

## Structure

```
sara_v3/
├── statutes/
│   ├── source/          # Plain-text US tax code sections
│   │   ├── section1        §1 — Tax imposed
│   │   ├── section2        §2 — Surviving spouse / head of household
│   │   ├── section63       §63 — Taxable income defined
│   │   ├── section68       §68 — Overall limitation on itemized deductions
│   │   ├── section151      §151 — Allowance of deductions for personal exemptions
│   │   ├── section152      §152 — Dependent defined
│   │   ├── section3301     §3301 — Rate of tax (FUTA)
│   │   ├── section3306     §3306 — Definitions (FUTA)
│   │   └── section7703     §7703 — Determination of marital status
│   └── prolog/
│       └── events.pl       # Prolog event type declarations
├── cases/                # 376 Prolog case files
│   ├── s1_*.pl             # Cases testing §1 (tax brackets)
│   ├── s2_*.pl             # Cases testing §2 (filing status)
│   ├── s63_*.pl            # Cases testing §63 (taxable income)
│   ├── s68_*.pl            # Cases testing §68 (phaseout)
│   ├── s151_*.pl           # Cases testing §151 (exemptions)
│   ├── s152_*.pl           # Cases testing §152 (dependents)
│   ├── s3301_*.pl          # Cases testing §3301 (FUTA rate)
│   ├── s3306_*.pl          # Cases testing §3306 (FUTA definitions)
│   ├── s7703_*.pl          # Cases testing §7703 (marital status)
│   └── tax_case_*.pl       # 100 multi-step tax computation cases
├── splits/
│   ├── train               # 256 training case names (one per line)
│   └── test                # 120 held-out test case names
└── run_all_prolog_cases.sh # Script to run all cases via Prolog
```

## Case File Format

Each case is a Prolog file with four sections:

```prolog
% Text
% Natural language description of the factual scenario.
%
% Question
% The legal question and ground-truth answer: "Entailment", "Contradiction", or a dollar amount.
%
% Facts
% :- [statutes/prolog/init].
% Prolog facts encoding the scenario (actors, events, amounts, dates).
%
% Test
% :- s151_b("Alice","Bob",_,2015).       % for entailment
% :- \+ s151_b("Alice","Bob",2015).      % for contradiction
% :- tax("Alice",2017,4931).             % for numerical computation
% :- halt.
```

### Example — Entailment

```prolog
% Text
% Alice and Bob have been married since 2 Feb 2015. Bob has no income for 2015.
%
% Question
% Alice can receive an exemption for Bob under section 151(b) for the year 2015. Entailment

% Facts
:- [statutes/prolog/init].
marriage_(span("married",24,30)).
agent_(span("married",24,30),span("Alice",0,4)).
agent_(span("married",24,30),span("Bob",10,12)).
start_(span("married",24,30),span(20150202,38,47)).

% Test
:- s151_b("Alice","Bob",_,2015).
:- halt.
```

### Example — Contradiction (joint return disqualifies spouse exemption)

```prolog
% Text
% Alice and Bob have been married since 2 Feb 2015. Bob has no income for 2015.
% Alice and Bob file their taxes jointly for 2015.
%
% Question
% Alice can receive an exemption for Bob under section 151(b) for the year 2015. Contradiction

% Facts
:- [statutes/prolog/init].
marriage_(span("married",24,30)).
joint_return_(span("jointly",109,115)).
agent_(span("jointly",109,115),span("Alice",78,82)).
agent_(span("jointly",109,115),span("Bob",88,90)).
start_(span("jointly",109,115),span(20150101,121,124)).
agent_(span("married",24,30),span("Alice",0,4)).
agent_(span("married",24,30),span("Bob",10,12)).
start_(span("married",24,30),span(20150202,38,47)).

% Test
:- \+ s151_b("Alice","Bob",2015).
:- halt.
```

### Example — Numerical Computation

```prolog
% Text
% Alice's income for the year 2003 is $54313. Alice and Bob have been married since
% Feb 3rd, 1985. Bob had no income in 2003. Bob and Alice file a joint return for
% 2003 and take the standard deduction.
%
% Question
% How much tax does Alice have to pay in 2003? $7611

% Facts
:- [statutes/prolog/init].
income_(span("income",8,13)).
marriage_(span("married",68,74)).
joint_return_(span("joint return",145,156)).
agent_(span("income",8,13),span("Alice",0,4)).
start_(span("income",8,13),span(20030101,28,31)).
amount_(span("income",8,13),span(54313,37,41)).
...

% Test
:- tax("Alice",2003,7611).
:- halt.
```

## Covered Reasoning Types

| Reasoning Skill | Example |
|---------------|---------|
| **Conditional interpretation** | "if a joint return is not made AND spouse has no gross income..." |
| **Cross-referencing** | §151(c) exemptions depend on §152 (dependent definition); §1 tax brackets depend on §2 (filing status) and §7703 (marital status) |
| **Temporal reasoning** | Marriage date affects filing status; 2018-2025 special rules differ from pre-2018 |
| **Numerical computation** | Taxable income → apply standard deduction → apply tax brackets → compute tax |
| **Exception handling** | §§ 3306(b)(1)-(21) list 21 types of payments excluded from "wages" |

## Using SARA v3 to Test LLMs

### Recommended Protocol

1. **Select cases**: Use the provided train/test split (test = 120 held-out cases).
2. **Prepare prompt**: Feed the LLM the relevant statute text(s) and the scenario from `% Text`.
3. **Query**: Ask the question from `% Question` (strip the answer).
4. **Evaluate**: Compare the LLM's answer against the ground truth.

### Prompt Template

```
You are a legal reasoning assistant. Apply the following statute to the given facts.

Statute §{section}:
"{statute text}"

Scenario:
{scenario text}

Question: {question text}
Answer only "Yes" or "No" (or the dollar amount).
```

### Evaluation Metrics

| Question Type | Metric |
|--------------|--------|
| Entailment / Contradiction | Accuracy, Precision, Recall, F1 |
| Tax computation | Exact-match accuracy, ±$ tolerance |

### What the Benchmark Measures

- **Statutory interpretation**: Understanding hierarchical conditional rules
- **Multi-hop reasoning**: Chaining across multiple code sections
- **Arithmetic under rules**: Computing tax liability given a fact pattern
- **Memorization resistance**: Fictional names and novel fact combinations prevent rote recall

## Citation

If you use this dataset, please cite the original SARA paper:

> (Original SARA reference — add citation as appropriate)

## License

This dataset is derived from public domain US legal materials and fictional fact patterns created for research purposes.
