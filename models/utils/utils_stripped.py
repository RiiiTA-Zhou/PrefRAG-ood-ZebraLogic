"""
Stripped versions of RAG utilities that remove solver sections
(# Solve / # Question) from programs before retrieval and in corpus entries.

The idea:
  - Query side: strip #Solve from the ZebraLogic program before embedding → retrieval
    focuses on declarations + constraints (the semantically meaningful parts).
  - Corpus side: strip #Question from retrieved LSAT/FOLIO examples before passing
    to the LLM → the model sees only the logic structure, not solver boilerplate.
  - The original full program (with #Solve) is still shown in the question prompt,
    so the LLM can correct it end-to-end.
"""

import re
import dspy


# ---------- Stripping helpers ----------

def strip_solver_section(program_text: str) -> str:
    """Strip solver-related sections from a Z3 program.

    For ZebraLogic programs: remove everything from '# Solve' onward.
    For LSAT/FOLIO programs: remove everything from '# Question' onward.

    If neither marker is found, returns the program unchanged.
    """
    # Try ZebraLogic-style marker (most specific first)
    idx = program_text.find('\n# Solve')
    if idx != -1:
        return program_text[:idx]
    # Try LSAT/FOLIO-style marker
    idx = program_text.find('\n# Question')
    if idx != -1:
        return program_text[:idx]
    return program_text


def strip_corpus_entry(entry_text: str) -> str:
    """Strip solver sections from embedded programs in a corpus entry.

    Corpus entries follow the template format:
        # Program 1:\n[program]\nExecution Result:
        # Program 2: [program]\nExecution Result:

    Programs embedded in these entries (typically LSAT or FOLIO programs)
    have their #Question or #Solve sections removed.
    """
    # Strip the program inside # Program 1: ... Execution Result:
    def _strip_p1(m):
        prog = m.group(1)
        stripped = strip_solver_section(prog)
        return f'{stripped}\nExecution Result:'

    # Strip the program inside # Program 2: ... Execution Result:
    def _strip_p2(m):
        prog = m.group(1)
        stripped = strip_solver_section(prog)
        return f'# Program 2: {stripped}\nExecution Result:'

    entry = re.sub(
        r'# Program 1:\n(.*?)\nExecution Result:',
        _strip_p1,
        entry_text,
        flags=re.DOTALL,
    )
    entry = re.sub(
        r'# Program 2: (.*?)\nExecution Result:',
        _strip_p2,
        entry,
        flags=re.DOTALL,
    )
    return entry


# ---------- Stripped RAGFixer ----------

class StrippedRAGFixer(dspy.Module):
    """RAGFixer variant that strips solver sections before retrieval and in examples.

    Behaviour:
      1. Before retrieval: strip #Solve from the ZebraLogic query program so that
         the embedding focuses on declarations + constraints rather than boilerplate.
      2. After retrieval: strip #Question sections from retrieved corpus entries
         (LSAT/FOLIO preference pairs) so the LLM sees only the logic parts.
      3. The question prompt still contains the *full original program* (with #Solve),
         so the LLM can correct it in its entirety.
    """

    def __init__(self, dataset_name: str, retrievers: dict):
        self.dataset_name = dataset_name
        self.retrievers = retrievers
        self.respond = dspy.ChainOfThought("sample, question -> response")

    def forward(self, NL_story, program):
        try:
            # 1. Strip #Solve from the query program for better semantic retrieval
            stripped_program = strip_solver_section(program["program"])
            query = (
                f'# Story\n{NL_story}\n'
                f'# z3 Program \n{stripped_program}\n'
                f'# Execution Result\n{program["execution"]}'
            )

            # 2. Retrieve with the stripped query
            all_samples = []
            for type_name in self.retrievers:
                samples = self.retrievers[type_name](query).passages
                all_samples.extend(samples)

            # 3. Strip solver sections from retrieved corpus entries
            cleaned = []
            for sample in all_samples:
                cleaned.append(strip_corpus_entry(sample))

            # 4. Deduplicate
            rag_samples = []
            seen = set()
            for sample in cleaned:
                if sample not in seen:
                    rag_samples.append(sample)
                    seen.add(sample)

            # 5. Build the question — keep the FULL original program (with #Solve)
            question = (
                f'# Story\n{NL_story}\n'
                f'# z3 Program \n{program["program"]}\n'
                f'# Execution Result\n{program["execution"]}\n'
                f'For the given story, we have a Z3 logic program using python API. '
                f'The program might contain syntactic errors raising errors during execution, '
                f'whose details can be detected by the execution result; they might also contain '
                f'semantic errors, including wrong declaration of sorts or functions, missing '
                f'information, inconsistent NL2SL constraint pairs, etc. '
                f'Is the program correct, and does it clearly convey the story? '
                f'If so, output this sentence exactly: "There is no error." '
                f'If not, output the whole corrected program.'
            )

            response = self.respond(sample=rag_samples, question=question)
            return response, rag_samples
        except Exception as e:
            import traceback
            print(f"[StrippedRAGFixer] error: {e}")
            traceback.print_exc()
            return None, []
