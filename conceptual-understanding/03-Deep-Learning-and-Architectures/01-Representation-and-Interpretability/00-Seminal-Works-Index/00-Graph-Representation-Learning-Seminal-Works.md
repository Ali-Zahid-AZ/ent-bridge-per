---
tags:
  - graph-representation-learning
  - research-article
  - seminal_works
  - conceptual-explanations
  - reading-list
---

---
#### References
- [[Graph-Representation-Learning-vs-Graph-Neural-Networks]]
- [[00-Graph-Neural-Networks-Seminal-Works]]
- [[00-The-Bronstein-Bibliography-Geometric-Graph-ML]]
- [[00-The-Velickovic-Bibliography-Graph-Attention-Reasoning]]
- [[00-Manifold-Learning-Seminal-Works]]
---
### I. Seminal Articles (The "Must-Reads")

These papers are the architectural pillars of the field. 
They moved the industry from manual feature engineering to end-to-end learning

> [!example] **Foundational Era (2000–2016)**
> - **The Graph Neural Network Model (2009)** | _Scarselli et al._
>     - **Significance:** The "Genesis" paper. It introduced the concept of learning on graph structures using recurrent neural networks to propagate information until convergence. Though computationally expensive, it laid the mathematical groundwork.
>         
> - **DeepWalk: Online Learning of Social Representations (2014)** | _Perozzi et al._
>     - **Significance:** The bridge between NLP and Graphs. It treated random walks on graphs as "sentences" and used Word2Vec (SkipGram) to learn node embeddings, sparking the "Graph Embedding" era.
>         
> - **Spectral Networks and Locally Connected Networks on Graphs (2014)** | _Bruna et al._
>     - **Significance:** The first successful attempt to generalize Convolutional Neural Networks (CNNs) to graphs using **Spectral Graph Theory** (Fourier domain). It defined the mathematical rigor for future spatial methods.
>         
> - **ChebNet: Convolutional Neural Networks on Graphs with Fast Localized Spectral Filtering (2016)** | _Defferrard et al._
>     - **Significance:** Solved the scalability issue of spectral methods by approximating the Laplacian with Chebyshev polynomials, removing the need for expensive eigendecomposition.
>---
> [!example] **The Modern GNN Explosion (2017–2020)**
> - **Semi-Supervised Classification with Graph Convolutional Networks (GCN) (2017)** | _Kipf & Welling_
>     - **Significance:** The "Hello World" of GNNs. It simplified ChebNet into a first-order approximation, creating an efficient, layer-wise propagation rule ($D^{-1/2}AD^{-1/2}XW$). It is the default baseline for almost all graph problems.
> 
> - **Inductive Representation Learning on Large Graphs (GraphSAGE) (2017)** | _Hamilton, Ying, Leskovec_    
>     - **Significance:** The shift from **Transductive** (fixed graph) to **Inductive** (dynamic/unseen nodes) learning. It introduced "neighbor sampling" and "aggregation functions" (mean, LSTM, pool), enabling GNNs to scale to billion-node graphs.
>         
> - **Graph Attention Networks (GAT) (2018)** | _Veličković et al._
>     - **Significance:** Brought the "Attention Mechanism" (Transformer-style) to graphs. Instead of static edge weights, GAT allows nodes to learn _dynamic_ importance weights for their neighbors, handling noisy graphs effectively.
>         
> - **How Powerful are Graph Neural Networks? (GIN) (2019)** | _Xu et al._
>     - **Significance:** The theoretical auditor. It proved that standard GNNs are at most as powerful as the **Weisfeiler-Lehman (WL) graph isomorphism test**. It proposed the Graph Isomorphism Network (GIN) to reach this theoretical limit.
>---
> [!example] **The Geometric & Generative Era (2021–2026)**
> - **Geometric Deep Learning: Grids, Groups, Graphs, Geodesics, and Gauges (2021)** | _Bronstein et al._
>     - **Significance:** The "Grand Unifying Theory". It unifies CNNs, GNNs, and Transformers under the umbrella of **Symmetry** and **Invariance**, framing deep learning as a study of geometric domains.
>         
> - **Graph Transformers (2021-2024)** | _Various (e.g., Dwivedi et al.)_
>     - **Significance:** Papers in this era (like "A Generalization of Transformer Networks to Graphs") decoupled the computational graph from the input graph, allowing for global information flow and solving the "over-smoothing" problem of deep GNNs.
>         
> - **Mathematical Foundations of Geometric Deep Learning (2025)** | _Sáez de Ocáriz Borde & Bronstein_
>     - **Significance:** A rigorous mathematical formalization of the field, extending the 2021 blueprint into a definitive canon for the next generation of architectures.

---
### II. Books (The Definitive Texts)

> [!example] **For deep, structured learning of the derivation and proofs**
> - **Graph Representation Learning (2020)** | _William L. Hamilton_
>     - **Verdict:** Concise and rigorous. The industry-standard entry point. Best for understanding the encoder-decoder framework.
>         
> - **Deep Learning on Graphs (2021)** | _Yao Ma & Jiliang Tang_
>     - **Verdict:** Encyclopedic. Covers adversarial attacks on graphs, graph generation, and heterogeneous graphs in depth.
>         
> - **Geometric Deep Learning (The Proto-Book)** | _Bronstein, Bruna, Cohen, Veličković_
>     - **Verdict:** High-level and philosophical. It focuses on the physics and group theory behind the architectures.

---
### III. Reviews & Surveys (The Landscape Maps)

> [!example] **To understand the taxonomy and state-of-the-art (SOTA) benchmarks**
> - **A Comprehensive Survey on Graph Neural Networks (2021)** | _Wu et al._ (IEEE TNNLS)
>     - The most cited survey; categorizes GNNs into Recurrent, Convolutional, Autoencoder-based, and Spatial-Temporal.
>         
> - **Graph Neural Networks: A Review of Methods and Applications (2020)** | _Zhou et al._
>     - Focuses heavily on downstream applications (physics simulations, chemistry, recommendation systems).
>         
> - **Graph Representation Learning in Bioinformatics: Trends, Methods and Applications (2025)**
>     - A critical look at how GRL is solving the latest challenges in AlphaFold-era protein folding and drug discovery.
     
---
### IV. White Papers & Industry Reports

> [!example] **These represent "Graph Learning at Scale"—how the giants run these models in production**
> - **Graph Convolutional Neural Networks for Web-Scale Recommender Systems (PinSage) (2018)** | _Pinterest & Stanford_
>     - **Context:** Detailed how Pinterest deployed GraphSAGE to handle billions of pins and edges. It introduced "importance pooling" and hard-negative mining for production.
>         
> - **AliGraph: A Comprehensive Graph Neural Network Platform (2019)** | _Alibaba_
>     - **Context:** A systems-level paper on the distributed infrastructure required to train GNNs on Alibaba’s scale (Sampling, Storage, and Computation separation).
>         
> - **PyTorch Geometric (PyG) & Deep Graph Library (DGL) Core Papers**
>     - While technically software papers, the launch papers for PyG (Fey & Lenssen) and DGL serve as the white papers for the current ML engineering stack.

--- 

|**Year**|**Title**|**Authors / Org**|**Type**|**Key Contribution**|**Link**|
|---|---|---|---|---|---|
|**2004**|**The Graph Neural Network Model**|Scarselli et al.|Article|The seminal definition of GNNs using recursive processing states.|[IEEE](https://ieeexplore.ieee.org/document/4773279)|
|**2014**|**DeepWalk: Online Learning of Social Representations**|Perozzi et al.|Article|Applied NLP (Word2Vec) to random walks on graphs; started the embedding era.|[ArXiv](https://arxiv.org/abs/1403.6652)|
|**2014**|**Spectral Networks and Locally Connected Networks on Graphs**|Bruna et al.|Article|First generalization of CNNs to graphs using spectral graph theory.|[ArXiv](https://arxiv.org/abs/1312.6203)|
|**2016**|**ChebNet: CNNs on Graphs with Fast Localized Spectral Filtering**|Defferrard et al.|Article|Solved spectral scalability using Chebyshev polynomials.|[ArXiv](https://arxiv.org/abs/1606.09375)|
|**2017**|**Semi-Supervised Classification with Graph Convolutional Networks (GCN)**|Kipf & Welling|Article|**The "Hello World" of GNNs.** Simplified ChebNet into an efficient layer-wise rule.|[ArXiv](https://arxiv.org/abs/1609.02907)|
|**2017**|**Inductive Representation Learning on Large Graphs (GraphSAGE)**|Hamilton et al.|Article|Introduced **Inductive Learning** (handling unseen nodes) and neighbor sampling.|[ArXiv](https://arxiv.org/abs/1706.02216)|
|**2018**|**Graph Attention Networks (GAT)**|Veličković et al.|Article|Applied the Attention Mechanism to weigh neighbor importance dynamically.|[ArXiv](https://arxiv.org/abs/1710.10903)|
|**2018**|**Graph Convolutional Neural Networks for Web-Scale Recommender Systems (PinSage)**|Pinterest / Stanford|White Paper|First billion-scale industrial application of GNNs.|[ArXiv](https://arxiv.org/abs/1806.01973)|
|**2019**|**How Powerful are Graph Neural Networks? (GIN)**|Xu et al.|Article|Theoretical audit proving standard GNNs are limited by the **WL Test**; proposed GIN.|[ArXiv](https://arxiv.org/abs/1810.00826)|
|**2019**|**AliGraph: A Comprehensive Graph Neural Network Platform**|Alibaba|White Paper|System design for distributed graph training at massive scale.|[VLDB](http://www.vldb.org/pvldb/vol12/p2094-zhu.pdf)|
|**2020**|**Graph Representation Learning**|William L. Hamilton|Book|**The standard textbook.** Concise, rigorous, and covers the Encoder-Decoder framework.|[Book Site](https://www.cs.mcgill.ca/~wlh/grl_book/)|
|**2021**|**Geometric Deep Learning: Grids, Groups, Graphs, Geodesics, and Gauges**|Bronstein et al.|Article / Proto-Book|**The Unified Theory.** Frames GNNs, CNNs, and Transformers under Group Theory & Symmetry.|[ArXiv](https://arxiv.org/abs/2104.13478)|
|**2021**|**Deep Learning on Graphs**|Ma & Tang|Book|Comprehensive reference covering adversarial attacks, generation, and heterogeneity.|[Book Site](https://www.google.com/search?q=https://web.njit.edu/~ym329/dlg_book/)|
|**2021**|**A Comprehensive Survey on Graph Neural Networks**|Wu et al.|Review|The most cited taxonomy of the field (IEEE TNNLS).|[ArXiv](https://arxiv.org/abs/1901.00596)|
|**2022**|**Graph Neural Networks with Learnable Structural and Positional Representations**|Dwivedi et al.|Article|Addressed the limitations of GNNs in capturing position/structure (Graph Transformers).|[ArXiv](https://arxiv.org/abs/2110.07875)|
|**2023**|**Foundation Models for Graph Learning**|Mao et al.|Review|Survey on applying Large Language Model (LLM) pre-training techniques to graphs.|[ArXiv](https://arxiv.org/abs/2302.08721)|
|**2024**|**Graph Mamba: Towards Efficient Graph Learning with Selective State Spaces**|Wang et al.|Article|Adapting State Space Models (Mamba) to graphs for linear complexity scaling.|[ArXiv](https://arxiv.org/abs/2402.00789)|
|**2025**|**Geometric Deep Learning (Full Text)**|Bronstein et al.|Book|The finalized, definitive mathematical text on the geometric unification of ML.|[Site](https://geometricdeeplearning.com/)|