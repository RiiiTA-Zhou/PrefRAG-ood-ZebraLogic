'''
Test script to verify the embedder configured in LLM_config is usable.
Tests both dspy.Embedder direct call and a small dspy.retrievers.Embeddings creation.
'''

import sys
import os
import numpy as np

# Ensure the project root is on the path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from utils.LLM_config import LLM_CONFIG
import dspy


def test_embedder_direct():
    """Test 1: Call the embedder directly on a few strings."""
    print("=" * 60)
    print("Test 1: dspy.Embedder direct call")
    print("=" * 60)

    embedder_config = LLM_CONFIG["embedder"]
    print(f"  Model: {embedder_config.llm_name}")
    print(f"  Base URL: {embedder_config.base_url}")
    print(f"  API Key: {embedder_config.api_key[:8]}...{embedder_config.api_key[-4:]}")

    embedder = dspy.Embedder(
        model=embedder_config.llm_name,
        api_key=embedder_config.api_key,
        api_base=embedder_config.base_url,
        batch_size=5,
    )

    test_texts = [
        "This is a test sentence for embedding.",
        "ZebraLogic puzzles involve logical deduction.",
        "The RAG fixer corrects Z3 programs.",
    ]

    try:
        result = embedder(test_texts)
        print(f"  [OK] Success! Embedding shape: {result.shape}")
        assert isinstance(result, np.ndarray), f"Expected numpy array, got {type(result)}"
        assert result.shape == (3, 3072 if "large" in embedder_config.llm_name else 1536), \
            f"Unexpected shape: {result.shape}"
        print(f"  [OK] Output type: {type(result).__name__}, dtype: {result.dtype}")
        return True
    except Exception as e:
        print(f"  [FAIL] Failed: {type(e).__name__}: {e}")
        return False


def test_embedder_single():
    """Test 2: Call the embedder on a single string."""
    print("\n" + "=" * 60)
    print("Test 2: Single string embedding")
    print("=" * 60)

    embedder_config = LLM_CONFIG["embedder"]
    embedder = dspy.Embedder(
        model=embedder_config.llm_name,
        api_key=embedder_config.api_key,
        api_base=embedder_config.base_url,
        batch_size=5,
    )

    try:
        result = embedder("Hello, world!")
        print(f"  [OK] Success! Embedding shape: {result.shape}")
        assert isinstance(result, np.ndarray) and result.ndim == 1
        return True
    except Exception as e:
        print(f"  [FAIL] Failed: {type(e).__name__}: {e}")
        return False


def test_small_retriever():
    """Test 3: Create a small dspy.retrievers.Embeddings (the class used in the main script)."""
    print("\n" + "=" * 60)
    print("Test 3: dspy.retrievers.Embeddings with small corpus")
    print("=" * 60)

    embedder_config = LLM_CONFIG["embedder"]
    embedder = dspy.Embedder(
        model=embedder_config.llm_name,
        api_key=embedder_config.api_key,
        api_base=embedder_config.base_url,
        batch_size=5,
    )

    corpus = [
        "Missing information about the color of the house.",
        "Declaration error in variable constraint.",
        "Inconsistency found in the puzzle rules.",
        "The cat lives in the red house.",
        "The Norwegian drinks water.",
    ]

    try:
        retriever = dspy.retrievers.Embeddings(
            embedder=embedder,
            corpus=corpus,
            k=2,
        )
        print(f"  [OK] Retriever created successfully!")
        results = retriever("What color is the house?")
        print(f"  [OK] Query returned {len(results)} results")
        for i, item in enumerate(results):
            # dspy 3.x returns (score, text, metadata_or_index) tuples
            if isinstance(item, (list, tuple)):
                score = item[0]
                text = item[1] if len(item) > 1 else ""
                meta = item[2] if len(item) > 2 else ""
                print(f"    {i+1}. score={score:.4f}  text={str(text)[:60]}...")
            else:
                print(f"    {i+1}. {item}")
        return True
    except Exception as e:
        print(f"  [FAIL] Failed: {type(e).__name__}: {e}")
        return False


def test_batch_robustness():
    """Test 4: Send a larger batch to verify batch_size works (10 docs * ~500 chars each)."""
    print("\n" + "=" * 60)
    print("Test 4: Batch robustness (20 docs, ~200 chars each)")
    print("=" * 60)

    embedder_config = LLM_CONFIG["embedder"]
    embedder = dspy.Embedder(
        model=embedder_config.llm_name,
        api_key=embedder_config.api_key,
        api_base=embedder_config.base_url,
        batch_size=10,
    )

    corpus = [f"This is test document number {i} with some padding text to make sure each "
              f"document has a reasonable length for embedding computation purposes. "
              f"We want to verify that batch processing works correctly without hitting "
              f"token limits or other API errors." for i in range(20)]

    try:
        result = embedder(corpus)
        print(f"  [OK] Success! Shape: {result.shape}")
        assert result.shape == (20, 3072 if "large" in embedder_config.llm_name else 1536)
        return True
    except Exception as e:
        print(f"  [FAIL] Failed: {type(e).__name__}: {e}")
        return False


if __name__ == "__main__":
    print("Embedder Connectivity Test")
    print(f"dspy version: {dspy.__version__ if hasattr(dspy, '__version__') else 'unknown'}")

    tests = [
        ("Direct call", test_embedder_direct),
        ("Single string", test_embedder_single),
        ("Small retriever", test_small_retriever),
        ("Batch robustness", test_batch_robustness),
    ]

    passed = 0
    failed = 0
    for name, fn in tests:
        if fn():
            passed += 1
        else:
            failed += 1

    print("\n" + "=" * 60)
    print(f"Result: {passed}/{len(tests)} passed, {failed}/{len(tests)} failed")
    print("=" * 60)

    sys.exit(0 if failed == 0 else 1)
