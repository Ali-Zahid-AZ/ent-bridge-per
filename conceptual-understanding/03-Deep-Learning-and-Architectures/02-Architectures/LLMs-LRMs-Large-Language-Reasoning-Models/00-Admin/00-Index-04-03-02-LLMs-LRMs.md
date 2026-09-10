---
tags:
  - index/deeplearning_core
  - llm-architectures
  - index/llms
---

---

## LLM Architectures: Index  

>[!success] **Research-focused analysis of Large Language Models** 
>- **Core Focus Areas:** 
>	- **Architecture Families:** Mathematical evolution of Transformers and specific lineage innovations (e.g., DeepSeek's MLA, MoE, Manifold-Constrained Hyper-Connections)
>	- **Internal Dynamics:** Mechanism discovery, causal attribution (Jacobian Scopes), and emergent reasoning capabilities (Chain-of-Thought)
>	- **Optimization Theory:** Algorithmic approaches to inference efficiency (e.g., LUT-based Quantization) and sparse attention mechanisms
>- **Concepts**
>	- Monosemanticity
>	- Superposition
>	- Attention Heads
>	- Transformers
>	- Embeddings 
>- **Goal**  ➝  Understanding and creating intelligence
>- **LLMs (The Science/Physics)** ➝ **How does the engine work?**


> [!example] **Detailed Focus Areas**
> - **Structural Blueprints (`Architecture-Families`)**
>     - **The Baseline:** The mathematical theory of the Transformer architecture.
>     - **The Innovations:** DeepSeek’s contributions (Multi-Head Latent Attention, Native Sparse Attention, Mixture-of-Experts routing).
> - **Cognitive Mechanics (`Training-Dynamics`)**
>     - **Elicitation:** How we get the model to think (Chain-of-Thought/Reasoning).
>     - **Attribution:** How we know _why_ the model thought that (Jacobian Scopes/Mechanistic Interpretability).
> - **Computational Efficiency (`Inference-Optimization`)**
>     - **Theoretical Quantization:** Research into reducing precision without losing manifold constraints (ELUTQ), as opposed to just running `bitsandbytes`.
> - **Field Overview (`Survey-Papers`)**
>     - High-level academic surveys of the LLM landscape (Minaae et al.).

---
- [📂 Open: LLMs](<file:///home/az/04-Library/03-Deep-Learning-Core/03-Architectures/LLMs>)

---

```dataview
TABLE 
    regexreplace(file.folder, ".*\/", "") AS "Category", 
    file.mday AS "Last Modified"
FROM "04-Library/03-Deep-Learning-and-Architectures/02-Architectures/LLMs-LRMs-Large-Language-Reasoning-Models"
WHERE file.name != this.file.name
SORT file.mday DESC
LIMIT 100
```

---


