# PrefRAG


In this project, we propose a novel approach to semantic error correction via program preference RAG.

First, we conduct an in-depth analysis of semantic error patterns, and then automatically synthesize **SemanticPref**, a program preference dataset to model these patterns. Utilizing the dataset as knowledge base, we introduce **PrefRAG**, a general retrieval‑augmented generation framework for refinement in auto-formalization, which enables LLMs to detect and repair both syntactic and semantic errors.

Extensive evaluations across both in‑distribution (AR‑LSAT and FOLIO) and out‑of‑distribution benchmarks show that PrefRAG consistently outperforms strong baselines, achieving an average improvement of 2.39\% on ID and 6.23\% on OOD datasets.



Environment installation:

```bash
pip install -r requirements.txt
```


### Semantic Error Patterns

We manually perform case studies on Z3 programs produced by Logic-LM, and identify following error patterns:

1. Declaration Errors: unsuitable daclaration of sorts of functions.
2. Missing Information: missing explicit or implicit constraints.
3. Inconsistent constraints: semantic mis-alignment between NL2FOL pairs.

Although we perform our case studies only on results on AR-LSAT, our classification of error patterns is based on Z3 program structure rather than specific tasks in dataset, thus the generalizability is ensured.



### KB Construction

**Step 1. collect a seed set semi-automatically.**

For AR-LSAT, where LTRAG collects 151 correct programs as translator KB, we use them as a seed set for the next step. Data is in `./LTRAG-AR-LSAT-seed-set/LSAT-examples.json`

For FOLIO, we translate the fol in translator KB of LTRAG into Z3 programs, then conduct manual correction on incorrect programs. Data is in `./LTRAG-FOLIO-seed-set/FOLIO-examples.json`

**Step 2. automatically construct error programs with rules with rule-based operations.**

We define several rules and regular expressions to identify the structure of a Z3 program in the seed set, and then modify them according to the possible error patterns, thus constrcuting program preference pairs.

Implementation: `./models/error_program_constructor.py` and `./models/step_2_construct_error.py`

Result: `./SemanticPref/constructed_data/rule-based-result`

**Step 3. data augmentation on train set.**

To advoid data scarcity, we perform data augmentation on the trainset. First deepseek and gpt-4o each produce a Z3 program for every sample, then a judge with RAG, where step 2's result is used as KB, output a judgement of which one is better and explanation.

Implementation: `./models/step_3-1_produce_z3_program.py` and `./models/step_3-2_judge.py`

Result: `./constructed_data/data-augmentation-result/`



### Test

There are three implementations for ARLSAT, FOLIO and ood datasets respectively. All in `./models`, prefix is `test`.

❗ Before running, set the LLM config in `./models/utils/LLM_config.py`. There is a template for reference `./models/utils/LLM_config_template.py`.

Evaluation: `./models/eval.py`


### Running Evaluation Scripts

All evaluation scripts accept the model name via `--llm`. Available choices: `gpt-4o`, `dpsk-chat`, `dpsk-reasoner`, `o3-mini`.

**RAG-as-fixer (OOD):**
```bash
python models/test_RAG_as_fixer-ZebraLogic.py --llm gpt-4o
python models/test_RAG_as_fixer-ZebraLogic.py --llm dpsk-reasoner
# Default: --llm dpsk-chat
```

**Logic-LM baseline (Z3 generation + correction loop):**
```bash
python baselines/evaluation_logiclm_zebraLogic.py --llm dpsk-reasoner
# Default: --llm dpsk-reasoner
```

**Direct / CoT baseline:**
```bash
python baselines/evaluation_zebralogic.py --llm gpt-4o --baseline CoT
python baselines/evaluation_zebralogic.py --llm dpsk-chat --baseline direct
# Default: --llm dpsk-reasoner --baseline direct
```
