---
tags:
  - llmops-embedding-unembedding-layer-embedding-matrix
  - llmops-embedding-unembedding-layer-embedding-matrix
---

---
#### References 
> [Official Documentation](https://docs.nomic.ai/)
> [Paper arXiv](https://arxiv.org/html/2402.01613v2)
> [Nussbam-Nomic Embed: Training a Reproducible Long Context Text Embedder-2025.pdf](<file:///home/az/04-Library/02-Computer-Science-AI/Embedding-Functions-Models/Nussbam-Nomic Embed: Training a Reproducible Long Context Text Embedder-2025.pdf>)

---


> [!NOTE]
> **Sentence Embedding** model (also called a _Text Embedding_ model)

| **Feature**  | **Word Embedding (e.g., Word2Vec, GloVe)**      | **Sentence Embedding (e.g., Nomic, OpenAI, BERT)**         |
| ------------ | ----------------------------------------------- | ---------------------------------------------------------- |
| **Input**    | A single word ("Apple")                         | A full sequence ("Apple released a new phone")             |
| **Output**   | One vector per word                             | **One single vector** for the entire sequence              |
| **Context**  | **Static:** "Bank" always means the same thing. | **Dynamic:** Understands "River _bank_" vs. "Citi _bank_." |
| **Use Case** | Old-school keyword synonyms.                    | **RAG & Vector Search** (What you are doing).              |
### How Nomic sees your PDF chunks

When you feed a chunk of your PDF into `nomic-embed-text`, it does not give you a list of vectors for every word. It performs a "Pooling" operation (usually taking the average or the specific `[CLS]` token) to compress that entire paragraph into **one specific direction** in the vector space.

- **Your PDF Chunk:** "The revenue increased by 20% due to AI adoption."
- **Nomic's Output:** `[0.12, -0.98, 0.44, ...]` (A single array of 768 numbers representing "Financial Growth" + "AI").
    
If we use a _word_ embedding model for RAG, your database would break because it wouldn't know how to match a user's question (a sentence) to your documents (also sentences).

---
#### The embedding model (Nomic) does NOT break down the PDF

- **The Application (Your Python Script/LangChain):** Breaks the PDF into chunks.
- **The Model (Nomic):** Digests those chunks and turns them into numbers.
    
---
### 1. The High-Level Explanation (The "Semantic Compressor")

Imagine Nomic as a **Master Librarian** who has read everything but isn't allowed to speak in words—only in coordinates.

1. **Input:** You hand the Librarian a page from a medical journal (your PDF chunk).
2. **Processing:** The Librarian reads the whole page at once. They don't just look at keywords like "Liver" or "Tumor"; they understand the _relationship_: "This text discusses the _progression_ of a tumor, not the _treatment_."
3. **Output:** The Librarian writes down a set of coordinates: `[Latitude: 0.4, Longitude: -0.9, Altitude: 0.1...]`.
4. **The Result:** When you later ask for "disease progression," the Librarian looks at that specific location on their map and finds your page.
    
**Key Feature:** Unlike older librarians (BERT) who panic if you give them more than a paragraph (512 tokens), Nomic can read a **whole chapter** (8192 tokens) in one go without forgetting the beginning.

### 2. The Low-Level Explanation (The "Principal" View)

**Architecture: Nomic-Embed-Text-v1.5**

- **Base Type:** Encoder-only Transformer (BERT-style), specifically adapted from `nomic-bert-2048`.
- **Parameter Count:** ~137 Million (Small, efficient).
- **Context Window:** **8192 Tokens** (This is massive; standard BERT is 512).    
- **Output Dimension:** 768 (Standard), but supports **Matryoshka Learning** (Variable sizing).
    
#### A. How it handles the "Input" (The Mechanics)

When your Python script sends a chunk to Nomic, here is the math that happens:

1. **Tokenization (The "BERT" Tokenizer):** It converts your text into integers.
    - Input: "AI Ops"
    - Tokens: `[101, 4932, 2891, 102]` (Start, AI, Ops, End).
        
2. **Rotary Positional Embeddings (RoPE):**
    - _Standard Transformers_ add a fixed number to a word to say "I am at position 5." This fails at long lengths.        
    - _Nomic_ uses **RoPE**. It rotates the vector in the complex plane to encode relative positions. This allows the model to understand that "Data" at token #5 is related to "Processing" at token #8000. This is the math that enables the **8k context window**.
        
3. **The Encoder Layers:** The tokens pass through attention layers. Every token "looks at" every other token to update its meaning based on context.
    
4. **Mean Pooling:** The model outputs 8192 vectors (one for each potential token). Nomic takes the **mathematical average** of all non-padding vectors to produce the final **single sentence embedding**.
    
#### B. The "Matryoshka" Feature (Russian Nesting Dolls)

This is Nomic's "killer feature." Most models force you to use all 768 dimensions. Nomic is trained so that the **most important information is at the front of the vector.**

- You can slice the 768-vector down to 256 or even 64 numbers.
- You lose some precision, but you save 10x the RAM in your database.
- _Analogy:_ It puts the "Genre" and "Topic" in the first few numbers, and the tiny nuances in the later numbers.
    
### 3. The Flow: PDF to Vector (Who does what?)


```bash
[PDF File]
    |
    | (Responsible: LangChain / PyPDFLoader)
    v
[Raw Text Extraction]
    |
    | (Responsible: RecursiveCharacterTextSplitter)
    | *CRITICAL STEP*: This is where the "breaking" happens.
    | You define: "Chunk Size: 1000 chars", "Overlap: 200 chars"
    v
[Text Chunks] 
    |  Chunk 1: "The patient showed signs..."
    |  Chunk 2: "...signs of recovery after..."
    |
    v
[Nomic Model] <--- The Embedding Model starts here
    |
    | 1. Tokenize (WordPieces)
    | 2. Attention Mechanism (RoPE)
    | 3. Pooling (Compress to single vector)
    v
[Vector]
[0.021, -0.55, 0.11, ...]
```

### Reference Note Summary

- **Model Name:** `nomic-embed-text-v1.5`
- **Type:** Sentence Embedding (Encoder Transformer).
- **Context:** Long-Context (8192 tokens).
- **Architecture Trick:** Rotary Positional Embeddings (RoPE) for length; Matryoshka Learning for variable storage size.
    