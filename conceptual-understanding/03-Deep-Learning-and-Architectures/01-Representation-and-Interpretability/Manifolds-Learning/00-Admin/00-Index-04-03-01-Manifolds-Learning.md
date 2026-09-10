---
tags:
  - research-article
  - reading-list
  - llm-manifolds-geometric-perspective
  - llm-manifolds-geometric-perspective
---

---

>[!success] **Exploration of the Manifold Hypothesis, which posits that high-dimensional data (like natural images or LLM activations) actually lies on low-dimensional, non-linear subspaces**
>- The index focuses on the geometric "unrolling" of these manifolds to understand how neural networks perform feature extraction and representation learning. 
>- By treating the transformation of data as a series of topological deformations, this research area investigates the curvature, intrinsic dimensionality, and disentanglement of latent spaces. 
>- It serves as the bridge between raw data topology and the functional capabilities of deep learning architectures, providing a geometric lens to view why certain models generalize better than others

---

[📂 Open: Manifolds-Learning](<file:///home/az/GitHub-Repositories/Obsidian-Knowledge-Base/04-Library/03-Deep-Learning-and-Architectures/01-Representation-and-Interpretability/Manifolds-Learning>)

---

```dataview
TABLE 
    regexreplace(file.folder, ".*\/", "") AS "Category", 
    file.mday AS "Last Modified"
FROM "04-Library/03-Deep-Learning-and-Architectures/01-Representation-and-Interpretability/Manifolds-Learning"
WHERE file.name != this.file.name
SORT file.mday DESC
```
