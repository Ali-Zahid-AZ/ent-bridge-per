---
tags:
  - llm-lrm-mathematical-foundations
  - dl-ml-mathematics
  - mechanistic-interpretability
  - mechanistic-interpretability-tools
---

---
```table-of-contents
```
---
### References



> [!info] .
>
>**[Obsidian Links]** 
> `$= dv.list(dv.current().file.outlinks.filter(l => l.path.endsWith(".md")))`
>
>---
>
>**[External Links]**
> `$= const content = await dv.io.load(dv.current().file.path); const regex = /\[(.*?)\]\((https?:\/\/[^\s)]+)\)/g; const links = []; let m; while (m = regex.exec(content)) { links.push("[" + m[1] + "](" + m[2] + ")"); } dv.list([...new Set(links)])`
>
>---
>
>**[Directory Links]**
> `$= const content = await dv.io.load(dv.current().file.path); const regex = /\[(.*?)\]\(<(file:\/\/\/.*?)>\)/g; const links = []; let m; while (m = regex.exec(content)) { links.push("[" + m[1] + "](<" + m[2] + ">)"); } dv.list([...new Set(links)])`
>
>---
>
>**[Back Links]**
> `$= dv.list(dv.current().file.inlinks)`
> 




---
### Primitives 

- 
  
  
---
first-principles breakdown of Principal Component Analysis (PCA) specifically through the lens of Mechanistic Interpretability and the geometry of activation spaces.

### The Problem: The Curse of Dimensionality

When you pass a medical prompt through Llama-3.2-1B or Qwen2.5-1.5B, the representation of that text at any given layer $l$ exists as a hidden state vector $\mathbf{h}^{(l)} \in \mathbb{R}^{d}$.

If $d = 4096$, the model represents "Aspirin" as a single coordinate point floating in a 4096-dimensional coordinate system. The human brain physically cannot visualize anything beyond 3 dimensions. If we want to see how the LoRA adapter shifts the activation trajectory of a medical prompt away from a standard prompt, we need a mathematical lens to compress this space without destroying the geometric relationships between the points.

### The Solution: Principal Component Analysis (PCA)

PCA is a linear transformation algorithm that takes a high-dimensional cloud of activation vectors and finds the specific angles (axes) from which to look at the cloud so that it appears as spread out as possible.

Instead of looking at arbitrary axes (like dimension 1 vs. dimension 2), PCA calculates the "Principal Components."

- **Principal Component 1 (PC1):** A custom-drawn axis through the activation cloud that captures the absolute maximum variance (spread) in the data.
    
- **Principal Component 2 (PC2):** A second axis, mathematically forced to be completely perpendicular (orthogonal) to PC1, that captures the second highest amount of variance.
    

By projecting our 4096-dimensional activations onto just PC1 and PC2, we compress the geometry into a 2D scatter plot while retaining the most important structural differences between the prompts.

---

### The First-Principles Mathematics

To build the MI dashboard and visualize the activation drift, we do not just call a black-box library; we must understand the tensor mechanics happening on the CPU.

**Step 1: The Activation Matrix ($X$)**

We run $n$ different prompts (some medical, some general) through the model and capture the residual stream vector at a specific layer. We stack these into a matrix $X \in \mathbb{R}^{n \times d}$.

**Step 2: Mean Centering**

We cannot find the true variance if the data is off-center. We calculate the mean vector $\mathbf{\mu}$ (the exact center of gravity of the activation cloud) and subtract it from every single vector.

$$X_{centered} = X - \mathbf{\mu}$$

**Step 3: The Covariance Matrix ($\Sigma$)**

We need to map how every single dimension in the 4096D space varies with every other dimension. We compute the covariance matrix $\Sigma \in \mathbb{R}^{d \times d}$:

$$\Sigma = \frac{1}{n-1} X_{centered}^T X_{centered}$$

This matrix holds the geometric blueprint of the activation cloud's shape.

**Step 4: Eigendecomposition**

This is the core engine of PCA. We solve for the eigenvectors ($\mathbf{v}$) and eigenvalues ($\lambda$) of the covariance matrix:

$$\Sigma \mathbf{v} = \lambda \mathbf{v}$$

- **Eigenvectors ($\mathbf{v}$):** These are the physical directions (the new axes) in the 4096D space. These are your Principal Components.
    
- **Eigenvalues ($\lambda$):** These are scalar numbers that tell you exactly how much variance (information) is captured by each eigenvector.
    

We sort the eigenvectors by their eigenvalues from highest to lowest. We take the top 2 eigenvectors, multiply our original activation matrix $X$ by them, and we get our 2D coordinates for the dashboard.

---

### What PCA Reveals in Mechanistic Interpretability

When we apply this to the residual stream of a Transformer, PCA allows us to track **Activation Trajectories**.

Instead of just looking at one layer, we extract $\mathbf{h}^{(l)}$ for all 32 layers. We fit a single PCA model to all of these vectors. When we plot them, we can literally see the "path" a prompt takes as it flows from the input embeddings to the final unembedding matrix.

In the context of the medical adapter, we would plot the trajectory of a prompt through the base model, and the trajectory of the exact same prompt through the LoRA-modified model. At early layers, the two lines will be identical. But at the exact layer where your $\Delta W$ matrix injects the medical knowledge, you will see the PCA trajectory violently diverge and steer into a different geometric cluster.

### The Blindspot of PCA: Superposition and Orthogonality

While PCA is a standard MI tool for macro-level clustering, it has a fatal mathematical flaw when trying to understand individual neurons or specific semantic features.

PCA mathematically forces every Principal Component to be **orthogonal** ($90^\circ$ perpendicular) to the others.

However, **Superposition Theory** dictates that Transformers do not store features orthogonally. Because models want to store more features than they have dimensions, they pack them in as non-orthogonal, slightly overlapping vectors in an overcomplete basis.

Because PCA forces right angles onto a geometry that does not use right angles, it often blends distinct superimposed features together, creating visual "mirages." It is excellent for showing us _that_ the medical prompt shifted away from the general prompt, but it cannot isolate the exact specific medical sub-feature (e.g., "toxicity" vs. "dosage") causing the shift. To resolve that non-orthogonal entanglement, we eventually have to step past PCA and utilize Sparse Autoencoders (SAEs).


> the foundational papers demonstrating the use—and the critical limitations—of PCA within the activation geometry of neural networks.

|Paper Name|Brief Description|Link|
|---|---|---|
|**Toy Models of Superposition** _(Anthropic, 2022)_|Demonstrates how neural networks pack more features than dimensions. Explicitly highlights how PCA fails to disentangle non-orthogonal, superimposed features, establishing the theoretical need for Sparse Autoencoders (SAEs).|[Transformer Circuits Thread](https://transformer-circuits.pub/2022/toy_model/index.html)|
|**The Geometry of Truth: Emergent Linear Structure in LLMs** _(Marks & Tegmark, 2023)_|Applies PCA to the residual stream of LLMs to discover "truth directions," mathematically proving that models construct low-dimensional, linear manifolds to separate true from false statements.|[arXiv:2310.06824](https://arxiv.org/abs/2310.06824)|
|**Transformer Dynamics: A Neuroscientific Approach to Interpretability** _(2025)_|Uses PCA and activation trajectory perturbation to analyze the residual stream as a continuous dynamical system, mapping how activations geometrically evolve across Transformer layers.|[arXiv:2502.12131](https://arxiv.org/abs/2502.12131)|
|**From Neurons to Neutrons: A Case Study in Interpretability** _(2024)_|Uses PCA to extract classical physics equations from a model trained on raw data, proving that high-dimensional networks compress domain knowledge into highly interpretable principal components.|[arXiv:2405.17425](https://arxiv.org/abs/2405.17425)|
