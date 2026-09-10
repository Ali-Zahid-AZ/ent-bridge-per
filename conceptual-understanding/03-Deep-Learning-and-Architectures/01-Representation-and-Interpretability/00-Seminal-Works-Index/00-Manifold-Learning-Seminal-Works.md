---
tags:
  - reading-list
  - seminal_works
---

---
### 1. The Origins (Classic Manifold Learning)

These papers defined the core "Manifold Hypothesis": _High-dimensional data lies on low-dimensional manifolds embedded in Euclidean space._

|**Title & Year**|**Core Innovation**|**Mathematical Relevance**|**Link**|
|---|---|---|---|
|**A Global Geometric Framework for Nonlinear Dimensionality Reduction** (Tenenbaum et al., 2000)|**Isomap**<br><br>  <br><br>The first algorithm to learn the "true" geodesic distance on a manifold using shortest-path graph algorithms, rather than Euclidean distance.|Defines **Geodesic Distance** estimation. Essential for understanding why "Euclidean distance" fails in high dimensions.|[Science PDF](https://www.science.org/doi/pdf/10.1126/science.290.5500.2319)|
|**Nonlinear Dimensionality Reduction by Locally Linear Embedding** (Roweis & Saul, 2000)|**LLE**<br><br>  <br><br>Proved that you can recover global non-linear geometry by preserving _local_ linear symmetries (neighbors).|Introduces **Local-to-Global** mapping. The mathematical precursor to how attention patches work locally to build global context.|[Science PDF](https://www.science.org/doi/pdf/10.1126/science.290.5500.2323)|
|**Laplacian Eigenmaps for Dimensionality Reduction and Data Representation** (Belkin & Niyogi, 2003)|**Laplacian Eigenmaps**<br><br>  <br><br>Used the _Laplace-Beltrami operator_ to map data onto a manifold.|Connects **Graph Theory** (Spectral Graph Theory) to **Differential Geometry**. The basis for Graph Neural Networks (GNNs).|[MIT Press PDF](https://www2.imm.dtu.dk/projects/manifold/Papers/Laplacian.pdf)|

---
### 2. The Deep Learning Integration (Pre-LLM)

These works integrated the manifold hypothesis into Neural Networks, treating layers as transformations that "unfold" the data manifold.

|**Title & Year**|**Core Innovation**|**Mathematical Relevance**|**Link**|
|---|---|---|---|
|**Representation Learning: A Review and New Perspectives** (Bengio et al., 2013)|**The Manifold Assumption**<br><br>  <br><br>Formally stated that Deep Learning works _because_ it disentangles twisted manifolds into flat representations.|The foundational review that defined **Disentanglement** in the context of manifolds.|[ArXiv PDF](https://www.google.com/search?q=https://arxiv.org/pdf/1206.5538.pdf)|
|**The Manifold Tangent Classifier** (Rifai et al., 2011)|**Tangent Propagation**<br><br>  <br><br>penalizing the derivative of the classifier along the manifold's tangent plane.|Introduces **Tangent Spaces** to DL training. Crucial for understanding how to make models robust to perturbations along the manifold.|[NIPS PDF](https://www.google.com/search?q=https://papers.nips.cc/paper/2011/file/522778c1875150c95066a34739414264-Paper.pdf)|
|**Poincaré Embeddings for Learning Hierarchical Representations** (Nickel & Kiela, 2017)|**Hyperbolic Geometry**<br><br>  <br><br>Showed that hierarchical data (like language/trees) cannot be embedded in Euclidean space, but fits perfectly in Hyperbolic space.|Introduces **Non-Euclidean Metrics** (Riemannian optimization) to DL.|[ArXiv PDF](https://www.google.com/search?q=https://arxiv.org/pdf/1705.08039.pdf)|

---
### 3. Geometric Deep Learning (The Modern Standard)

These are the most important papers for your goal of "designing from scratch." They unify CNNs, GNNs, and Transformers under one geometric framework (Group Theory).

|**Title & Year**|**Core Innovation**|**Mathematical Relevance**|**Link**|
|---|---|---|---|
|**Geometric Deep Learning: Grids, Groups, Graphs, Geodesics, and Gauges** (Bronstein et al., 2021)|**The Erlangen Program for DL**<br><br>  <br><br>Unifies all major architectures (CNN, Transformer, GNN) as instances of **Symmetry** and **Invariance** on manifolds.|**MUST READ.** It derives the Transformer mathematically as a Graph Neural Network on a complete graph with positional symmetries.|[ArXiv PDF](https://www.google.com/search?q=https://arxiv.org/pdf/2104.13478.pdf)|
|**Geometric Deep Learning: Going beyond Euclidean data** (Bronstein et al., 2017)|**Spectral Conv**<br><br>  <br><br>The earlier version focusing on non-Euclidean domains (Graphs/Manifolds).|Defines convolution on manifolds using the **Spectral Domain** (Fourier Transform on graphs).|[ArXiv PDF](https://www.google.com/search?q=https://arxiv.org/pdf/1611.08097.pdf)|

---

### 4. LLMs & The Geometry of Thought (Current Era)

These works apply manifold theory specifically to **Transformers** and **Large Language Models**, explaining "Superposition" and "Intrinsic Dimension."

| **Title & Year**                                                                                                | **Core Innovation**                                                                                                                                                            | **Mathematical Relevance**                                                                                                                      | **Link**                                                                          |
| --------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| **Intrinsic Dimensionality Explains the Effectiveness of Language Model Fine-Tuning** (Aghajanyan et al., 2020) | **Intrinsic Dimension (ID)**<br><br>  <br><br>Proved that while LLMs have billions of parameters, the "solution manifold" they live on has a very low dimension (e.g., d=200). | Explains why **LoRA** (Low Rank Adaptation) works. The optimization happens on a low-rank manifold inside the high-dimensional parameter space. | [ArXiv PDF](https://www.google.com/search?q=https://arxiv.org/pdf/2012.13255.pdf) |
| **Visualizing the Loss Landscape of Neural Nets** (Li et al., 2018)                                             | **Loss Geometry**<br><br>  <br><br>Showed that ResNets/Transformers create "smooth" manifolds for optimization, while standard RNNs create "chaotic" ones.                     | Introduces **Hessian Analysis** of the loss landscape. Essential for understanding "why" Transformers train stably.                             | [ArXiv PDF](https://www.google.com/search?q=https://arxiv.org/pdf/1712.09913.pdf) |
| **Toy Models of Superposition** (Elhage et al., 2022)                                                           | **Superposition**<br><br>  <br><br>Demonstrates that LLMs store more features than they have dimensions by using "almost orthogonal" directions in high-dimensional space.     | Defines the **Geometry of Features**. Shows that features form polytopes (geometric shapes) in the activation space.                            | [Anthropic HTML](https://transformer-circuits.pub/2022/toy_model/index.html)      |
| **The Linear Representation Hypothesis** (Park et al., 2023)                                                    | **Linearity on Manifolds**<br><br><br>Argues that LLMs linearize concepts in the activation space, making "vector arithmetic" (King - Man + Woman = Queen) possible.           | Validates the **Flat Manifold** assumption in the latent space of pre-trained transformers.                                                     | [ArXiv PDF](https://www.google.com/search?q=https://arxiv.org/pdf/2311.03658.pdf) |
