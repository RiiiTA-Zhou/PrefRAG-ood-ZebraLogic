---
language:
- en
size_categories:
- 1K<n<10K
task_categories:
- question-answering
---
# ProverQA: A First-Order Logic Reasoning Dataset

This repository contains the dataset described in the paper [Large Language Models Meet Symbolic Provers for Logical Reasoning Evaluation](https://openreview.net/forum?id=C25SgeXWjE).

Code: https://github.com/opendatalab/ProverGen

## Dataset Description

ProverQA is a high-quality First-Order Logic (FOL) reasoning dataset created using the ProverGen framework, which synergizes the generative strengths of Large Language Models (LLMs) with the rigor and precision of symbolic provers. The dataset is designed to evaluate and improve the logical reasoning capabilities of language models, particularly in chain-of-thought (CoT) contexts.

### Key Features

- **Scalable**: Generated using an automated framework enabling expansion with minimal manual intervention
- **Natural and Diverse Language**: Captures a wide range of natural language expressions to reflect real-world linguistic variability
- **Symbolic Representations**: Includes formal symbolic structures validated through automated symbolic provers (Prover9)
- **Faithful Reasoning Chains**: Each instance includes intermediate reasoning steps clearly articulated in both symbolic and natural language formats

## Dataset Structure

The dataset consists of two main parts:

### 1. Development Set (`dev/`)
The benchmark evaluation set containing **1,500 instances** across three difficulty levels:
- **Easy**: 500 instances (1-2 reasoning steps)
- **Medium**: 500 instances (3-5 reasoning steps)  
- **Hard**: 500 instances (6-9 reasoning steps)

### 2. Training Set (`train/`)
Contains **5,000 instances** used for finetuning experiments, generated using the same ProverGen framework with data augmentation techniques.

## Data Format

### Development Set Example (`dev/easy.json`)

```json
{
  "id": 0,
  "options": [
    "A) True",
    "B) False", 
    "C) Uncertain"
  ],
  "answer": "B",
  "question": "Based on the above information, is the following statement true, false, or uncertain? Brecken has never experienced heartbreak.",
  "reasoning": "fact1: Brecken has experienced heartbreak.\nrule: Either Brecken has experienced heartbreak or he has never experienced heartbreak, but not both.\nconclusion: Brecken has experienced heartbreak.\n\nTherefore, it is false that Brecken has never experienced heartbreak. The correct option is: B.",
  "context": "Brecken has experienced heartbreak. Either Brecken has experienced heartbreak or he has never experienced heartbreak, but not both.",
  "nl2fol": {
    "Brecken has experienced heartbreak.": "has_experienced_heartbreak(Brecken)",
    "Either Brecken has experienced heartbreak or he has never experienced heartbreak, but not both.": "has_experienced_heartbreak(Brecken) ⊕ has_never_experienced_heartbreak(Brecken)"
  },
  "conclusion_fol": "has_never_experienced_heartbreak(Brecken)"
}
```

**Field Descriptions:**
- `id`: Unique identifier for the instance
- `options`: Multiple choice options (True/False/Uncertain)
- `answer`: Correct answer (A/B/C)
- `question`: The reasoning question to be answered
- `reasoning`: Step-by-step logical reasoning chain
- `context`: Background premises and rules
- `nl2fol`: Natural language to first-order logic mappings
- `conclusion_fol`: The conclusion in first-order logic format

### Training Set Example (`train/provergen-5000.json`)

```json
{
  "system": "Given a problem statement as contexts, the task is to answer a logical reasoning question. Your answer should be in JSON format with keys: reasoning, answer.",
  "output": "{\n  \"reasoning\": \"Jayce pursues historical interests. Jayce does not develop expertise. If Jayce pursues historical interests, then he either gains practical skills or develops expertise (or both). Jayce gains practical skills...\",\n  \"answer\": \"C\"\n}",
  "input": "The correct option is:",
  "instruction": "Context:\nJayce earns academic credentials. If someone earns academic credentials and gains practical skills, then they can participate in excavations...\n\nQuestion: Based on the above information, is the following statement true, false, or uncertain? If Jayce studies Seljuk history or explores Anatolian landscapes, then he uncovers hidden archaeological treasures.\n\nOptions:\nA) True\nB) False\nC) Uncertain\n"
}
```

**Field Descriptions:**
- `system`: System prompt for the model
- `instruction`: Full problem context, question, and options
- `input`: Input prompt continuation
- `output`: Expected model response with reasoning and answer

## FOL Coverage

The dataset covers all seven First-Order Logic relationships:
- **Conjunction** (∧): AND operations
- **Disjunction** (∨): OR operations  
- **Negation** (¬): NOT operations
- **Implication** (→): IF-THEN relationships
- **Exclusive Disjunction** (⊕): XOR operations
- **Universal Quantifier** (∀): FOR ALL statements
- **Existential Quantifier** (∃): THERE EXISTS statements

## Usage

### Loading the Dataset

```python
from datasets import load_dataset

# Load development set
dev_dataset = load_dataset("opendatalab/ProverQA", data_files="dev/*.json")

# Load training set  
train_dataset = load_dataset("opendatalab/ProverQA", data_files="train/provergen-5000.json")

# Load specific difficulty level
easy_dev = load_dataset("opendatalab/ProverQA", data_files="dev/easy.json")
medium_dev = load_dataset("opendatalab/ProverQA", data_files="dev/medium.json") 
hard_dev = load_dataset("opendatalab/ProverQA", data_files="dev/hard.json")
```

### Evaluation

The dataset supports both standard prompting and chain-of-thought (CoT) prompting evaluation strategies. Models are evaluated on their ability to:

1. Parse complex logical premises and rules
2. Perform multi-step reasoning
3. Handle distracting information
4. Determine whether conclusions are True, False, or Uncertain

### Training

The training set can be used for:
- Finetuning language models on FOL reasoning
- Improving chain-of-thought reasoning capabilities
- Enhancing logical inference abilities

## Benchmark Results

State-of-the-art models show significant room for improvement on ProverQA:

| Model | Easy | Medium | Hard |
|-------|------|--------|------|
| GPT-4o (CoT) | 94.2% | 79.4% | 50.0% |
| Claude-3.5-Sonnet (CoT) | 95.2% | 83.6% | 56.4% |
| Llama3.1-70B (CoT) | 90.4% | 73.2% | 46.8% |
| o1-preview-2024-09-12 | 89.8% | 78.8% | 66.2% |
| DeepSeek-R1	 | 91.8% | 78.4% | 66.6% |

Even with chain-of-thought prompting, top models barely exceed 50% accuracy on the hard subset, demonstrating the challenging nature of this benchmark.

## Dataset Creation

ProverQA was created using the ProverGen framework through a three-stage process:

1. **Background Story Generation**: LLMs generate unique contextual stories guided by subject names and characteristic keywords
2. **Logic Skeleton Generation**: Symbolic provers (Prover9) construct reasoning trees using a novel top-down approach
3. **Statement Translation**: LLMs translate logical expressions into natural language within the established context

## Citation

If you use ProverQA in your research, please cite:

```bibtex
@inproceedings{
qi2025large,
title={Large Language Models Meet Symbolic Provers for Logical Reasoning Evaluation},
author={Chengwen Qi and Ren Ma and Bowen Li and He Du and Binyuan Hui and Jinwang Wu and Yuanjun Laili and Conghui He},
booktitle={The Thirteenth International Conference on Learning Representations},
year={2025},
url={https://openreview.net/forum?id=C25SgeXWjE}
}
```

## License and Ethics

- Dataset sources comply with public repository licenses (MIT for names, WordNet for keywords)
- No human participants involved in data collection
- Dataset does not contain harmful or biased content
- Designed for academic and research purposes in advancing logical reasoning capabilities


## Contact
For questions or issues regarding the dataset, please contact the authors or open an issue in the GitHub repository. 

- Chengwen Qi (chengwen_qi@buaa.edu.cn)
- Ren Ma (maren@pjlab.org.cn)
- Bowen Li (libowen@pjlab.org.cn)