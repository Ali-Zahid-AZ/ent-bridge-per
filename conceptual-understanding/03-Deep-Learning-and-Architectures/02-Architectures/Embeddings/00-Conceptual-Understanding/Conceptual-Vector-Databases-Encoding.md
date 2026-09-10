---
tags:
  - llmops-vector-databases
  - similarity
  - conceptual-explanations
  - similarity_search
topic: Vector-Databases
priority: Medium
status: In Progress
---

---
[[Comparison-Popular-Vector-Databases]]
[[Custom-Vector-Embeddings]]
[[Embedding-Functions]]
[[Similarity Search-IBM]]
[[Similarity Search and HNSW in Chroma DB-IBM]]

---
### 1. What is being encoded?

Vector databases encode **latent relationships**. Instead of storing words as strings, they store them as coordinates in a high-dimensional space (often 768 or 1536 dimensions).

- **Contextual Meaning:** The position encodes how a chunk of text relates to every other possible concept the model was trained on
- **Semantic Proximity:** If a chunk discusses "quantum computing" and another discusses "Schrödinger's cat," the model places them near each other in this space because it learned during training that these concepts frequently appear together.
    
### 2. How the Vector is "Decided"

The decision is made by the **weights** of a neural network.
- **The Transformation:** The model treats your text chunk as a sequence of tokens.5 It passes these through layers of mathematical operations (matrix multiplications). The final layer outputs a fixed-length array of numbers—this is your vector $\vec{v} = [x_1, x_2, \dots, x_n]$.
- **Learned Features:** Each dimension in that vector represents an abstract "feature" the model learned during training.6 One dimension might (very loosely) correspond to "formality," another to "scientific vs. artistic," and another to "temporal vs. static."

### 3. Direction vs. Magnitude

In the context of your PDF chunks, here is how those two components function:
#### Direction (The "What")

The direction is the most important part of the vector for semantic search. It represents the **topic or meaning**.
- Two vectors pointing in the same direction are "talking about the same thing," even if one is a short sentence and the other is a long paragraph.
- In most RAG (Retrieval-Augmented Generation) systems, we use **Cosine Similarity**, which looks exclusively at the angle ($\theta$) between vectors, effectively ignoring magnitude.
    
#### Magnitude (The "How Much")

Magnitude represents the **intensity or weight** of the features
- **In raw embeddings:** A longer chunk or a chunk with very specific, rare keywords might have a larger magnitude (a "longer" arrow) because the model is "more certain" or has "stronger signals" for those features
- **In frequency models (like TF-IDF):** Magnitude is directly tied to how often a word appears
- **Normalization:** Most modern embedding models **normalize** their output to a magnitude of 1. This means all vectors are converted into "unit vectors" that sit on the surface of a hyper-sphere. This simplifies the math so that the **Dot Product** and **Cosine Similarity** become identical.

--

1. **Input:** Your PDF chunk.
2. **Inference:** The embedding model runs the text through its pre-trained neural weights.8
3. **Placement:** The weights determine the specific coordinates ($x, y, z, \dots$) in the $n$-dimensional space
4. **Result:** The resulting "arrow" (vector) has a specific direction (pointing toward its semantic neighbors) and a magnitude (indicating the strength of those attributes).

--
```bash
+--------------------------+
| Source PDF Document(s)   |
+--------------------------+
             |
             |  [1. Extraction & Cleaning]
             |  (Pulling raw text from binary PDF format)
             v
+--------------------------+
| Continuous Raw Text      |
+--------------------------+
             |
             |  [2. Chunking Strategy]
             |  (Splitting based on tokens, sentences, or semantics)
             v
+--------------------------+
| Text Chunks (Sequence)   |  <-- e.g., Chunk 1: "Quarterly results show growth."
+--------------------------+      Chunk 2: "However, headwinds remain..."
             |
             |
    (Process each chunk individually)
             |
             v
    +-----------------------------------+
    | [3. Embedding Function / Model]   |
    | (e.g., OpenAI, Cohere, HuggingFace)|
    |                                   |
    |   Input: "Text Chunk"             |
    |     |                             |
    |   [Black Box Neural Net]          |
    |     |                             |
    |   Output: Numerical Array         |
    +-----------------------------------+
             |
             |  (Results in a high-dimensional point)
             v
+--------------------------+
| Dense Vector             |
| [0.15, -0.89, 0.33, ...] | <-- Encodes the meaning (direction/magnitude)
+--------------------------+
             |
             |  [4. Upsert / Indexing]
             |  (Storing vector + original text ID/metadata)
             v
+=====================================+
||                                   ||
||      VECTOR DATABASE STORAGE      ||
||                                   ||
+=====================================+
```
---
#similarity
#llmops-vector-databases 
#llm-semantic-meaning
## Similarity in Vector Databases

In a vector database, "similarity" isn't a single thing; it’s a mathematical relationship that changes based on whether you care about the _direction_ of the vector, its _size_ (magnitude), or both.
### 1. The Trio of Similarity

Most vector databases (Pinecone, Milvus, Weaviate, etc.) offer three main ways to calculate how "similar" two vectors are:1

|**Metric**|**What it considers**|**Best For...**|
|---|---|---|
|**Cosine Similarity**|**Direction only**|NLP and text. It ignores document length/magnitude and focuses on the "topic" (angle).|
|**Dot Product**|**Direction + Magnitude**|Recommendation systems. Magnitude often represents "popularity" or "intensity."|
|**Euclidean (L2)**|**Straight-line distance**|Image search or physical data where the absolute "position" in space matters most.|
### 2. Direction vs. Magnitude: The Semantic Split

To understand why we use one or the other, think of it this way:

- **Direction = The "What":** This encodes the **semantic meaning**. In a 768-dimensional space, the direction tells you if a word is more like "Apple" (the fruit) or "Apple" (the tech company). If two vectors point in the same direction, they are talking about the same concept.
    
- **Magnitude = The "How Much":** This encodes **intensity or importance**. In a recommendation system, a user who has bought 100 items might have a vector with a massive magnitude, while a new user has a small one.3 Even if they point in the same direction (same taste), the Dot Product will rank the "intense" user as a stronger match.4
    
### 3. The "Great Equalizer": Normalization

You’ll often see people say that Dot Product and Cosine Similarity are the same. This is only true if the vectors are **normalized** (scaled to a magnitude of exactly 1).

$$\text{Cosine Similarity} = \frac{\mathbf{A} \cdot \mathbf{B}}{\|\mathbf{A}\| \|\mathbf{B}\|}$$

If 5$\|\mathbf{A}\|$ and 6$\|\mathbf{B}\|$ are both 1, then the denominator disappears, and the **Dot Product is the Cosine Similarity**.7 This is why many high-end embedding models (like OpenAI’s `text-embedding-3`) output normalized vectors by default—it makes the search extremely fast and focuses purely on semantic direction.

- **Magnitude** = Frequency / Intensity / Confidence.
- **Direction** = Semantic Topic / Meaning.8
- **Similarity** = The bridge between them, defined by whichever math formula you pick for your specific use case.
---

