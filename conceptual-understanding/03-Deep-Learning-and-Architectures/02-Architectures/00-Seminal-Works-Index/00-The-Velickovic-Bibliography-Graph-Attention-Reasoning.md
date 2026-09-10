---
tags:
  - reading-list
---


---
#### References 

---

> [!example] `Targeted Domains: Graph Attention & Algorithmic Reasoning`
>- **Anisotropic Diffusion:** Using Attention to weight neighbor importance.
>- **Algorithmic Alignment:** Designing GNNs that "align" with classical algorithms (Dijkstra, BFS).     
>- **In-Context Learning for Graphs:** Bringing Transformer-style reasoning to non-Euclidean data.
     
---
#### 1. Research Articles

|**Index**|**Status**|**Title / Reference**|**Year**|**Focus & Innovation**|**Strategic Fit**|**Access**|
|---|---|---|---|---|---|---|
|1|🔵 Reading|**Graph Attention Networks (GAT)**|2018|Introduced attentional message passing to graphs.|Standard for **GraphViT-MLP**.|[arXiv](https://arxiv.org/abs/1710.10903)|
|2|🟢 Done|**Deep Graph Infomax (DGI)**|2019|Self-supervised learning for graphs via mutual information.|Vital for **LLM-Graph** hybrid pre-training.|[arXiv](https://arxiv.org/abs/1809.10341)|
|3|🔵 Reading|**Neural Algorithmic Reasoning**|2021|Framing ML as the execution of classical algorithms.|Bedrock for **Pure-Python Agentic Flow**.|[arXiv](https://arxiv.org/abs/2105.02766)|
|4|🟢 Done|**The CLRS Algorithmic Reasoning Benchmark**|2022|A unified benchmark for 30+ classical algorithms.|Testing rig for **Agentic reasoning**.|[GitHub](https://github.com/google-deepmind/clrs)|
|5|⚪ To Read|**Everything is Connected: GNN Survey**|2023|A master survey on the structural biology of GNNs.|High-level **Principal Architect** roadmap.|[Current Opinion](https://www.google.com/search?q=https://doi.org/10.1016/j.sbi.2023.102545)|
|6|🔵 Reading|**TacticAI (Google DeepMind)**|2024|Geometric DL for football tactics/predictive systems.|Applied GDL in **real-time ops**.|[Nature/DeepMind](https://deepmind.google/blog/tacticai-ai-assistant-for-football-tactics/)|
|7|⚪ To Read|**Filter Equivariant Functions**|2025|Length-general extrapolation on lists via symmetry.|Solves **Context-Window** drift on lists.|[arXiv](https://arxiv.org/abs/2507.01234)|

#### 2. The Books

While Petar has many papers, his primary "Book" is the **Proto-Book** shared with Bronstein, which acts as the definitive curriculum for modern GDL.

- **Geometric Deep Learning: Grids, Groups, Graphs, Geodesics, and Gauges** (2021/2026 Update)
    
    - **Context:** Co-authored with Bronstein, Bruna, and Cohen. This is the "General Relativity" of AI.
        
    - **Axiom:** It proves that **Transformers are just Attentional GNNs** on a complete graph.
        

#### 3. Medium & DeepMind Blogs (Strategic Summaries)

Petar uses these to explain the "Why" behind the "How."

- **[Towards Data Science: Graph ML in 2024/2025](https://medium.com/data-science/graph-geometric-ml-in-2024-where-we-are-and-whats-next-part-i-theory-architectures-3af5d38376e1):** (Featured Expert) A series of deep dives into GNN theory and applications.
    
- **[Google DeepMind: The Evolution of Graph Learning](https://research.google/blog/the-evolution-of-graph-learning/):** Tracing the history from PageRank to modern GCNs/GATs.
    
- **[Personal Blog (petar-v.com)](https://petar-v.com/):** His central hub for research, advising notes, and lecture slides (Cambridge/Oxford).
    

---

### 🧬 GIKI Seed: Algorithmic Alignment

Petar’s most important derivation for your **Agentic Flow** project is the concept of **Algorithmic Alignment**:

> _A neural network will learn a task better if its internal architecture 'mirrors' the structure of the algorithm required to solve it._
> 
> **Application:** If your agent needs to find the "Shortest Path" in a knowledge graph, don't just use a standard LLM prompt. Use a **GAT-based layer** that mimics the update step of the **Bellman-Ford algorithm**.