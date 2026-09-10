---
tags:
  - graph_neural_networks
  - research-article
  - seminal_works
  - reading-list
---
---
#### References 
- [[04-Library/04-Advanced-Paradigms/02-Theoretical-Foundations/Graph-Representation-Learning/00-Admin/00-Graph-Representation-Learning-Seminal-Works]]
- [[00-The-Bronstein-Bibliography-Geometric-Graph-ML]]
- [[00-The-Velickovic-Bibliography-Graph-Attention-Reasoning]]
- [[00-Manifold-Learning-Seminal-Works]]

---
>[!example] **Works that introduced paradigm shifts (e.g., Spectral $\to$ Spatial) + established theoretical bounds (e.g., Weisfeiler-Lehman isomorphism) + defined modern industry standards (e.g., GraphRAG, Geometric DL)**

### I. The Theoretical Foundations (2000–2013)

> [!example] **The "Pre-Deep Learning" era. These works established the mathematical link between graph topology and function approximation**
> - **The First GNN:** The concept of processing graphs with neural mechanisms was born here, relying on recursive state updates until convergence (fixed-point theorem).    
>     - **Article:** Scarselli, F., Gori, M., Tsoi, A. C., Hagenbuchner, M., & Monfardini, G. (2009). The graph neural network model. _IEEE Transactions on Neural Networks_, _20_(1), 61–80. [https://doi.org/10.1109/TNN.2008.2005605](https://doi.org/10.1109/TNN.2008.2005605)
>         
> - **Graph Kernels (The Precursor):** Before GNNs took over, graph kernels were the standard for measuring similarity between graphs. Understanding this helps you appreciate _why_ GNNs (which learn the kernel) became dominant.
>     - **Article:** Vishwanathan, S. V. N., Schraudolph, N. N., Kondor, R., & Borgwardt, K. M. (2010). Graph kernels. _Journal of Machine Learning Research_, _11_, 1201–1242.

---
### II. The Deep Learning Explosion (2014–2018)


> [!example] **The "Golden Era." These papers are mandatory reading. They moved GNNs from obscure theory to the powerhouse of structural deep learning.**
> - **Spectral Graph Convolutions (The Mathematical Bridge):** The first successful attempt to generalize CNNs to graphs using the Fourier domain (Eigen-decomposition of the Laplacian).    
>     - **Article:** Bruna, J., Zaremba, W., Szlam, A., & LeCun, Y. (2014). Spectral networks and locally connected networks on graphs. _International Conference on Learning Representations (ICLR)_.
>         
> - **GCN (The "Hello World" of GNNs):** Kipf & Welling simplified spectral convolutions into a first-order approximation, creating the efficient "spatial" message passing rule used everywhere today: $\mathbf{H}^{(l+1)} = \sigma(\tilde{\mathbf{D}}^{-1/2}\tilde{\mathbf{A}}\tilde{\mathbf{D}}^{-1/2}\mathbf{H}^{(l)}\mathbf{W}^{(l)})$.
>     - **Article:** Kipf, T. N., & Welling, M. (2017). Semi-supervised classification with graph convolutional networks. _International Conference on Learning Representations (ICLR)_.
>         
> - **GraphSAGE (Inductive Learning):** Moved beyond processing a fixed graph (transductive) to generating embeddings for unseen nodes (inductive), essential for production systems (Pinterest, Uber).
>     - **Article:** Hamilton, W. L., Ying, Z., & Leskovec, J. (2017). Inductive representation learning on large graphs. _Advances in Neural Information Processing Systems_, _30_.
>         
> - **GAT (Attention Mechanism):** Introduced the Transformer concept of "attention" to graphs, allowing nodes to weigh the importance of their neighbors differently.
>     - **Article:** Veličković, P., Cucurull, G., Casanova, A., Romero, A., Lio, P., & Bengio, Y. (2018). Graph attention networks. _International Conference on Learning Representations (ICLR)_.
>         
> - **MPNN (The Unifying Framework):** Gilmer et al. proved that most GNNs are just variations of a single "Message Passing" framework (Message $\to$ Aggregate $\to$ Update). Crucial for chemistry and quantum ML.
>     - **Article:** Gilmer, J., Schoenholz, S. S., Riley, P. F., Vinyals, O., & Dahl, G. E. (2017). Neural message passing for quantum chemistry. _International Conference on Machine Learning (ICML)_, 1263–1272.
        
---
### III. Maturation: Theoretical Limits & Scalability (2019–2022)

> [!example] **The era of "Why does this work?" and "How do we scale it to billions of nodes?"**
> - **GIN (The Expressive Power Limit):** This paper mathematically proved that standard GNNs are at most as powerful as the Weisfeiler-Lehman (WL) graph isomorphism test and proposed GIN to reach that theoretical limit.
>     - **Article:** Xu, K., Hu, W., Leskovec, J., & Jegelka, S. (2019). How powerful are graph neural networks? _International Conference on Learning Representations (ICLR)_.
>         
> - **ClusterGCN (Industrial Scalability):** A field-defining white paper/article on how to train GCNs on massive graphs by clustering the graph to preserve local structures during mini-batching.
>     - **Article:** Chiang, W. L., Liu, X., Si, S., Li, Y., Bengio, S., & Hsieh, C. J. (2019). Cluster-GCN: An efficient algorithm for training deep and large graph convolutional networks. _Proceedings of the 25th ACM SIGKDD International Conference on Knowledge Discovery & Data Mining_, 257–266. [https://doi.org/10.1145/3292500.3330925](https://doi.org/10.1145/3292500.3330925)
>         
> - **Graph Transformers:** The shift from MPNNs (which suffer from over-smoothing and lack long-range dependency) to full Graph Transformers.
>     - **Article:** Dwivedi, V. P., & Bresson, X. (2020). A generalization of transformer networks to graphs. _arXiv preprint arXiv:2012.09699_.

---
### IV. The Modern Era: Generative, Geometric & LLMs (2023–2026)


> [!example] **The current frontier. The focus is on GraphRAG, Generative AI (Diffusion on Graphs), and AI for Science.**
> 
> - **Geometric Deep Learning (The Bible):** This is **the** definitive text that unifies CNNs, GNNs, Transformers, and RNNs under the umbrella of symmetry and group theory (Erlangen Programme for AI).
>     - **Book:** Bronstein, M. M., Bruna, J., Cohen, T., & Veličković, P. (2021). _Geometric deep learning: Grids, groups, graphs, geodesics, and gauges_. MIT Press.
>         
> - **GraphRAG (The 2024-2026 Trend):** The seminal white paper from Microsoft Research that defined how to use Knowledge Graphs to ground LLMs, moving beyond simple vector similarity search.
>     - **White Paper/Preprint:** Edge, D., Trinh, H., Cheng, N., Bradley, J., Chao, A., Mody, A., ... & Larson, J. (2024). From local to global: A graph RAG approach to query-focused summarization. _arXiv preprint arXiv:2404.16130_.
>         
> - **Generative Graphs (Diffusion):** Adapting the diffusion models (like Stable Diffusion) to discrete graph structures. This is seminal for drug discovery and material design.
>     - **Article:** Vignac, C., Krawczuk, I., Siraudin, A., Wang, B., Cevher, V., & Frossard, P. (2023). DiGress: Discrete denoising diffusion for graph generation. _International Conference on Learning Representations (ICLR)_.
>         
> - **GRAG (Retrieval Augmented Generation with Graph Context):** A key 2024/2025 paper establishing the formal framework for "GRAG," integrating topological information into LLM generation.
>     - **Article:** Hu, Y., Lei, Z., Zhang, Z., Pan, B., Ling, C., & Zhao, L. (2025). GRAG: Graph retrieval-augmented generation. _Findings of the Association for Computational Linguistics: NAACL 2025_. [https://doi.org/10.48550/arxiv.2405.16506](https://www.google.com/search?q=https://doi.org/10.48550/arxiv.2405.16506)

---
### V. Comprehensive Reviews & Surveys

> [!example] **Use these for "night time revision" to get a holistic view.**
> 
> - **The "Big" Survey:** The most cited comprehensive survey that covers the entire history up to 2020.
>     
>     - **Review:** Wu, Z., Pan, S., Chen, F., Long, G., Zhang, C., & Yu, P. S. (2021). A comprehensive survey on graph neural networks. _IEEE Transactions on Neural Networks and Learning Systems_, _32_(1), 4–24. [https://doi.org/10.1109/TNNLS.2020.2978386](https://doi.org/10.1109/TNNLS.2020.2978386)
>         
> - **Graph Transformers Survey:** Crucial for understanding the 2023+ landscape.
>     
>     - **Review:** Min, E., Chen, R., Bian, Y., Xu, T., Zhao, K., Huang, W., ... & Rong, Y. (2022). Transformer for graphs: An overview from architecture perspective. _arXiv preprint arXiv:2202.08455_.
>         
> - **Graph Databases & GNNs:** A 2025 survey linking traditional DB concepts with GNNs, relevant for your Platform/DataOps roles.
>     
>     - **Review:** Li, Z., Li, Y., Luo, Y., Li, G., & Zhang, C. (2025). Graph neural networks for databases: A survey. _Proceedings of the 34th International Joint Conference on Artificial Intelligence (IJCAI-25)_. [https://doi.org/10.48550/arxiv.2502.12908](https://www.google.com/search?q=https://doi.org/10.48550/arxiv.2502.12908)
>         

---
### VI. Architectural Evolution 

```toml
Timeline of Graph Neural Networks (2000-2026)

[2005] GNN (Scarselli)
   │   (Fixed-point iteration, Recurrent)
   ▼
[2014] Spectral Networks (Bruna/LeCun)
   │   (Fourier Domain, computationally heavy)
   ▼
[2017] GCN (Kipf/Welling) ◄─── THE TIPPING POINT
   │   (1st Order Approx, Spatial Message Passing)
   ├─── [2017] GraphSAGE (Inductive/Sampling)
   ├─── [2018] GAT (Attention Mechanisms)
   ▼
[2019] GIN (Xu)
   │   (Theoretical limit reached: WL-Test equivalent)
   ▼
[2021] Geometric Deep Learning (Bronstein)
   │   (Unified Theory: Grids, Groups, Graphs)
   ▼
[2023+] Graph Transformers & GraphRAG
       (Global Attention, LLM Integration, Generative)
```

---

|**Year**|**Title**|**Authors**|**Type**|**Link**|
|---|---|---|---|---|
|**2009**|_The Graph Neural Network Model_|Scarselli et al.|Article|[IEEE Xplore](https://doi.org/10.1109/TNN.2008.2005605)|
|**2010**|_Graph Kernels_|Vishwanathan et al.|Article|[JMLR PDF](https://www.jmlr.org/papers/volume11/vishwanathan10a/vishwanathan10a.pdf)|
|**2014**|_Spectral Networks and Locally Connected Networks on Graphs_|Bruna et al.|Article|[arXiv](https://arxiv.org/abs/1312.6203)|
|**2017**|_Semi-Supervised Classification with Graph Convolutional Networks (GCN)_|Kipf & Welling|Article|[arXiv](https://arxiv.org/abs/1609.02907)|
|**2017**|_Inductive Representation Learning on Large Graphs (GraphSAGE)_|Hamilton et al.|Article|[arXiv](https://arxiv.org/abs/1706.02216)|
|**2017**|_Neural Message Passing for Quantum Chemistry (MPNN)_|Gilmer et al.|Article|[arXiv](https://arxiv.org/abs/1704.01212)|
|**2018**|_Graph Attention Networks (GAT)_|Veličković et al.|Article|[arXiv](https://arxiv.org/abs/1710.10903)|
|**2019**|_How Powerful are Graph Neural Networks? (GIN)_|Xu et al.|Article|[arXiv](https://arxiv.org/abs/1810.00826)|
|**2019**|_Cluster-GCN: An Efficient Algorithm for Training Deep and Large GCNs_|Chiang et al.|Article|[arXiv](https://arxiv.org/abs/1905.07953)|
|**2021**|_A Comprehensive Survey on Graph Neural Networks_|Wu et al.|Review|[arXiv](https://arxiv.org/abs/1901.00596)|
|**2021**|_Geometric Deep Learning: Grids, Groups, Graphs, Geodesics, and Gauges_|Bronstein et al.|Book|[arXiv (Proto-Book)](https://arxiv.org/abs/2104.13478)|
|**2022**|_Transformer for Graphs: An Overview from Architecture Perspective_|Min et al.|Review|[arXiv](https://arxiv.org/abs/2202.08455)|
|**2023**|_DiGress: Discrete Denoising Diffusion for Graph Generation_|Vignac et al.|Article|[arXiv](https://arxiv.org/abs/2209.14734)|
|**2024**|_From Local to Global: A Graph RAG Approach to Query-Focused Summarization_|Edge et al. (Microsoft)|White Paper|[arXiv](https://arxiv.org/abs/2404.16130)|
|**2025**|_GRAG: Graph Retrieval-Augmented Generation_|Hu et al.|Article|[arXiv](https://arxiv.org/abs/2405.16506)|
|**2025**|_Graph Neural Networks for Databases: A Survey_|Li et al.|Review|[arXiv](https://arxiv.org/abs/2502.12908)|

---

