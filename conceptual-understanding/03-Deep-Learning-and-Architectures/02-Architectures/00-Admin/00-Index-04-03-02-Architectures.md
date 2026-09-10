---
tags:
  - index/04
  - index/deeplearning_core
---

---
## Deep Learning Architectures: Index  

>[!success] **Master Index of Model Topologies and Structural Research**
>- **Core Focus Areas:**
>	- **Foundational Topologies:** Evolution from MLP and CNNs to Sequence Models (RNN/LSTM) and Attention-based Transformers [cite: 2025-12-25].
>	- **Geometric & Topological DL:** Graph Neural Networks (GNNs), Manifold Learning, and Symmetry-preserving architectures.
>	- **Advanced Paradigms:** State Space Models (Mamba), Mixture-of-Experts (MoE), and Neuro-Symbolic integration.
>- **Key Objectives**
>	- **Mastery of GitOps/DevOps** in the context of model deployment [cite: 2025-12-25].
>	- **Designing from Scratch:** Deep mathematical understanding of backpropagation and structural axioms [cite: 2025-12-25].
>- **The Goal** ➝ Principal AI Architect level understanding of how structure dictates function [cite: 2025-12-16].


> [!example] **Structural Pillars**
> - **Legacy & Core (`Standard-Architectures`)**
>     - **Convolutional Systems:** Spatial feature extraction and translation invariance.
>     - **Recurrence & Memory:** RNNs, LSTMs, and GRUs—the precursors to modern context handling.
> - **Modern Dominance (`Transformer-Architectures`)**
>     - **Attention Mechanisms:** Multi-head attention, Latent Attention (MLA), and Sparse implementations.
>     - **Scaling Laws:** How depth, width, and compute interact within the architecture manifold.
> - **Emergent & Hybrid Paradigms (`Advanced-Research`)**
>     - **Symmetry & Graph Theory:** Applying Geometric Deep Learning to non-Euclidean data.
>     - **Energy-Based & Diffusion:** Generative architectures and the physics of denoising manifolds.
>     - **Sparsity & Routing:** Mixture-of-Experts (MoE) and conditional computation for efficiency.

---
- [📂 Open: Architectures](<file:///home/az/04-Library/03-Deep-Learning-and-Architectures/03-Architectures>)

---

```dataview
TABLE WITHOUT ID 
    file.link AS "Index File", 
    regexreplace(file.folder, ".*\/", "") AS "Sub-Domain"
FROM "04-Library/03-Deep-Learning-and-Architectures/02-Architectures"
WHERE contains(file.name, "00-Index") AND file.name != this.file.name
SORT file.name ASC
```

---
```dataview
TABLE 
    regexreplace(file.folder, ".*\/", "") AS "Category", 
    file.mday AS "Last Modified"
FROM "04-Library/03-Deep-Learning-and-Architectures/02-Architectures"
WHERE file.name != this.file.name
SORT file.mday DESC
```
