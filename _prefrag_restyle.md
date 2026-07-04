
---
## PrefRAG — Correction Effectiveness

PrefRAG uses a RAG fixer to identify and correct errors in Z3 programs.
The fixer judges whether the current program+execution has an error; if it finds one,
it retrieves similar examples and generates a corrected program (up to 3 rounds).

### GPT-4o

**Correction Rounds Distribution**

| Rounds | Samples | % |
|-------:|-------:|---:|
| 0 |  249 | 49.8% |
| 1 |   91 | 18.2% |
| 2 |   26 | 5.2% |
| 3 |  134 | 26.8% |

**Per-Round Execution Flag**

| Stage | Entered | Success | Exec Error | Semantic Error |
|------:|-------:|--------:|-----------:|---------------:|
| Initial |  500 | 245 ( 49.0%) | 254 ( 50.8%) |   1 (  0.2%) |
| Corr.1 |  251 |  91 ( 36.3%) | 155 ( 61.8%) |   5 (  2.0%) |
| Corr.2 |  160 |  25 ( 15.6%) | 135 ( 84.4%) |   0 (  0.0%) |
| Corr.3 |  134 |  18 ( 13.4%) | 115 ( 85.8%) |   1 (  0.7%) |

**Correction Impact**

- Initial execution errors: **254**
- Initial success / semantic: **246**
- Fixed by correction: **118** (46.5%)
- Still error after all rounds: **136**
- Fixed and answer correct: **95**
- Total correct: **323/500** (64.6%)

**Per-Round Fix Effectiveness**

| Round | Attempted | Fixed | Fix Rate | Correct after Fix |
|------:|----------:|------:|---------:|------------------:|
| 1 | 247 |  88 | 35.6% |  75 (85.2%) |
| 2 | 156 |  23 | 14.7% |  15 (65.2%) |
| 3 | 131 |  17 | 13.0% |   6 (35.3%) |

> [!WARNING] DeepSeek-Chat: result file identical to another model (MD5 match), data may be unreliable

### DeepSeek-Chat

**Correction Rounds Distribution**

| Rounds | Samples | % |
|-------:|-------:|---:|
| 0 |  327 | 66.9% |
| 1 |   41 | 8.4% |
| 2 |   24 | 4.9% |
| 3 |   97 | 19.8% |

**Per-Round Execution Flag**

| Stage | Entered | Success | Exec Error | Semantic Error |
|------:|-------:|--------:|-----------:|---------------:|
| Initial |  489 | 452 ( 92.4%) |  28 (  5.7%) |   9 (  1.8%) |
| Corr.1 |  162 |  52 ( 32.1%) |  94 ( 58.0%) |  16 (  9.9%) |
| Corr.2 |  121 |  25 ( 20.7%) |  79 ( 65.3%) |  17 ( 14.0%) |
| Corr.3 |   97 |  27 ( 27.8%) |  62 ( 63.9%) |   8 (  8.2%) |

**Correction Impact**

- Initial execution errors: **28**
- Initial success / semantic: **461**
- Fixed by correction: **2** (7.1%)
- Still error after all rounds: **24**
- Broke early (non-exec-error, can't fix): **2**
- Fixed and answer correct: **0**
- Total correct: **434/489** (88.8%)

**Per-Round Fix Effectiveness**

| Round | Attempted | Fixed | Fix Rate | Correct after Fix |
|------:|----------:|------:|---------:|------------------:|
| 1 |  27 |   0 | 0.0% |   0 (0.0%) |
| 2 |  25 |   1 | 4.0% |   0 (0.0%) |
| 3 |  23 |   1 | 4.3% |   0 (0.0%) |

### DeepSeek-Reasoner

**Correction Rounds Distribution**

| Rounds | Samples | % |
|-------:|-------:|---:|
| 0 |  460 | 92.0% |
| 1 |   35 | 7.0% |
| 2 |    2 | 0.4% |
| 3 |    3 | 0.6% |

**Per-Round Execution Flag**

| Stage | Entered | Success | Exec Error | Semantic Error |
|------:|-------:|--------:|-----------:|---------------:|
| Initial |  500 | 469 ( 93.8%) |  31 (  6.2%) |   0 (  0.0%) |
| Corr.1 |   40 |  31 ( 77.5%) |   9 ( 22.5%) |   0 (  0.0%) |
| Corr.2 |    5 |   0 (  0.0%) |   5 (100.0%) |   0 (  0.0%) |
| Corr.3 |    3 |   0 (  0.0%) |   3 (100.0%) |   0 (  0.0%) |

**Correction Impact**

- Initial execution errors: **31**
- Initial success / semantic: **469**
- Fixed by correction: **21** (67.7%)
- Still error after all rounds: **10**
- Fixed and answer correct: **17**
- Total correct: **458/500** (91.6%)

**Per-Round Fix Effectiveness**

| Round | Attempted | Fixed | Fix Rate | Correct after Fix |
|------:|----------:|------:|---------:|------------------:|
| 1 |  30 |  21 | 70.0% |  17 (81.0%) |
| 2 |   5 |   0 | 0.0% |   0 (0.0%) |
| 3 |   3 |   0 | 0.0% |   0 (0.0%) |

### O3-Mini

**Correction Rounds Distribution**

| Rounds | Samples | % |
|-------:|-------:|---:|
| 0 |  377 | 75.4% |
| 1 |   89 | 17.8% |
| 2 |   19 | 3.8% |
| 3 |   15 | 3.0% |

**Per-Round Execution Flag**

| Stage | Entered | Success | Exec Error | Semantic Error |
|------:|-------:|--------:|-----------:|---------------:|
| Initial |  500 | 416 ( 83.2%) |  84 ( 16.8%) |   0 (  0.0%) |
| Corr.1 |  123 |  74 ( 60.2%) |  49 ( 39.8%) |   0 (  0.0%) |
| Corr.2 |   34 |  18 ( 52.9%) |  16 ( 47.1%) |   0 (  0.0%) |
| Corr.3 |   15 |   5 ( 33.3%) |  10 ( 66.7%) |   0 (  0.0%) |

**Correction Impact**

- Initial execution errors: **84**
- Initial success / semantic: **416**
- Fixed by correction: **31** (36.9%)
- Still error after all rounds: **53**
- Fixed and answer correct: **30**
- Total correct: **421/500** (84.2%)

**Per-Round Fix Effectiveness**

| Round | Attempted | Fixed | Fix Rate | Correct after Fix |
|------:|----------:|------:|---------:|------------------:|
| 1 |  65 |  25 | 38.5% |  25 (100.0%) |
| 2 |  21 |   6 | 28.6% |   5 (83.3%) |
| 3 |  10 |   2 | 20.0% |   2 (100.0%) |

> [!WARNING] DeepSeek-V4-Flash: result file identical to another model (MD5 match), data may be unreliable

### DeepSeek-V4-Flash

**Correction Rounds Distribution**

| Rounds | Samples | % |
|-------:|-------:|---:|
| 0 |  327 | 66.9% |
| 1 |   41 | 8.4% |
| 2 |   24 | 4.9% |
| 3 |   97 | 19.8% |

**Per-Round Execution Flag**

| Stage | Entered | Success | Exec Error | Semantic Error |
|------:|-------:|--------:|-----------:|---------------:|
| Initial |  489 | 452 ( 92.4%) |  28 (  5.7%) |   9 (  1.8%) |
| Corr.1 |  162 |  52 ( 32.1%) |  94 ( 58.0%) |  16 (  9.9%) |
| Corr.2 |  121 |  25 ( 20.7%) |  79 ( 65.3%) |  17 ( 14.0%) |
| Corr.3 |   97 |  27 ( 27.8%) |  62 ( 63.9%) |   8 (  8.2%) |

**Correction Impact**

- Initial execution errors: **28**
- Initial success / semantic: **461**
- Fixed by correction: **2** (7.1%)
- Still error after all rounds: **24**
- Broke early (non-exec-error, can't fix): **2**
- Fixed and answer correct: **0**
- Total correct: **434/489** (88.8%)

**Per-Round Fix Effectiveness**

| Round | Attempted | Fixed | Fix Rate | Correct after Fix |
|------:|----------:|------:|---------:|------------------:|
| 1 |  27 |   0 | 0.0% |   0 (0.0%) |
| 2 |  25 |   1 | 4.0% |   0 (0.0%) |
| 3 |  23 |   1 | 4.3% |   0 (0.0%) |

### DeepSeek-V4-Pro

**Correction Rounds Distribution**

| Rounds | Samples | % |
|-------:|-------:|---:|
| 0 |  393 | 79.7% |
| 1 |   54 | 11.0% |
| 2 |   16 | 3.2% |
| 3 |   30 | 6.1% |

**Per-Round Execution Flag**

| Stage | Entered | Success | Exec Error | Semantic Error |
|------:|-------:|--------:|-----------:|---------------:|
| Initial |  493 | 385 ( 78.1%) | 103 ( 20.9%) |   5 (  1.0%) |
| Corr.1 |  100 |  30 ( 30.0%) |  49 ( 49.0%) |  21 ( 21.0%) |
| Corr.2 |   46 |   8 ( 17.4%) |  25 ( 54.3%) |  13 ( 28.3%) |
| Corr.3 |   30 |   9 ( 30.0%) |  10 ( 33.3%) |  11 ( 36.7%) |

**Correction Impact**

- Initial execution errors: **103**
- Initial success / semantic: **390**
- Fixed by correction: **32** (31.1%)
- Still error after all rounds: **56**
- Broke early (non-exec-error, can't fix): **15**
- Fixed and answer correct: **19**
- Total correct: **326/493** (66.1%)

**Per-Round Fix Effectiveness**

| Round | Attempted | Fixed | Fix Rate | Correct after Fix |
|------:|----------:|------:|---------:|------------------:|
| 1 |  67 |  20 | 29.9% |  18 (90.0%) |
| 2 |  32 |   5 | 15.6% |   1 (20.0%) |
| 3 |  21 |   7 | 33.3% |   0 (0.0%) |
