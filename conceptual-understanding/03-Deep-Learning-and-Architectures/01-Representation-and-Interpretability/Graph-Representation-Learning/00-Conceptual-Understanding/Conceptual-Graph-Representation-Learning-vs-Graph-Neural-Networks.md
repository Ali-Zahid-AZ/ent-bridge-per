---
tags:
  - graph_neural_networks
  - graph-representation-learning
  - reading-list
---


---
```table-of-contents
```

---
### References

- [[00-The-Bronstein-Bibliography-Geometric-Graph-ML]]
- [[Conceptual-Manifold-Geometry-of-Large-Language-Models]]

---
### Latent Map

> [!example] **Graph Representation Learning + Graph Neural Networks** 
> - **Graph Representation Learning (GRL)** is the **Destination**. It is the broad field of study focused on converting the complex, spiderweb-like structure of a graph (nodes and edges) into a simple format that computers understand well: numbers in a list (vectors).
> - **Graph Neural Networks (GNNs)** are the **Vehicle**. They are a _specific type_ of deep learning architecture designed to reach that destination.
>---        
> - **The Analogy (The Map vs. The Satellite):**
>     - Imagine you want to create a map of a city where similar neighborhoods are placed next to each other.
>     - **GRL** is the project goal: "Create a map where the distance on paper equals the similarity in real life." You could do this manually, by surveying people (heuristics), or by using math (matrix factorization).
>     - **GNNs** are the advanced satellite technology you use to automate the map-making. They look at a house (node), look at its neighbors (edges), and automatically calculate where that house belongs on the map based on who lives next door.
> - **The Mechanism (How it works):**
>     - **GRL** asks: "How do I turn this node into a vector of numbers?" (Could be _DeepWalk_, _Node2Vec_, or _Matrix Factorization_).
>     - **GNNs** answer: "Use a neural network that passes messages between neighbors to calculate those numbers."
>---
> The distinction is between the **Problem Statement** (GRL) and the **Architectural Solution** (GNN).
>#### 1. Graph Representation Learning (The Objective)
>
> 
> GRL is the superset. It defines the optimization problem of learning a mapping function $f: V \to \mathbb{R}^d$ such that structural proximity in the graph $G$ approximates Euclidean distance in the embedding space.
> - **Shallow Encoders (Pre-GNN):** Methods like _DeepWalk_ or _Node2Vec_ optimize a lookup table.
>     - _Limitation:_ They are **Transductive**. If you add a new node, you must retrain the whole model to find its embedding. There is no shared function; the "parameters" are the embeddings themselves ($|V| \times d$ parameters).
>     - _Objective:_ Maximize log-likelihood of co-occurrence (Skip-Gram).
> #### 2. Graph Neural Networks (The Deep Solution)
> 
> GNNs are **Deep Encoders**. Instead of learning a lookup table, they learn a function with shared parameters (weights).
> - **Deep Encoders (GNNs):** Methods like _GCN_, _GraphSAGE_, or _GAT_.
>     - _Advantage:_ They are **Inductive**. Because they learn a function (a set of weights $W$), they can generate embeddings for nodes they have never seen before, provided the node has features.
>     - _Mechanism:_ **Message Passing Interface (MPI)**.
>     - **The GNN Axiom (Message Passing Rule):**
>         $$h_v^{(k)} = \sigma \left( \text{COMBINE}^{(k)} \left( h_v^{(k-1)}, \text{AGGREGATE}^{(k)} \left( \{ h_u^{(k-1)} : u \in \mathcal{N}(v) \} \right) \right) \right)$$
>         
>         Where $h_v^{(k)}$ is the embedding of node $v$ at layer $k$, and $\mathcal{N}(v)$ are the neighbors.
>         
> 
> ```toml
> GRAPH REPRESENTATION LEARNING (The Field)
> │
> ├── Matrix Factorization (The Old Guard)
> │   ├── Laplacian Eigenmaps
> │   └── SVD
> │
> ├── Random Walk Approaches (The Bridge)
> │   ├── DeepWalk (Word2Vec for graphs)
> │   └── Node2Vec
> │
> └── GRAPH NEURAL NETWORKS (The Modern Era)
>     ├── Spectral (GCN, ChebNet)
>     ├── Spatial (GraphSAGE, GAT)
>     └── Generative (GraphRNN)
> ```
> 

---
### The Implementation Difference (Python Pseudo-code)

> **Option A: Shallow GRL (e.g., Node2Vec)**: We learn a unique vector for every single node. No parameter sharing

```python
import torch

# THE LOOKUP TABLE APPROACH
# If you have 1 Million nodes, you need 1 Million vectors.
# num_embeddings=1000, embedding_dim=64
embedding_table = torch.nn.Embedding(1000, 64) 

def get_embedding(node_id):
    # Direct lookup. No features used. 
    # Fails if node_id > 1000.
    return embedding_table(node_id)
```

> **Option B: GNN (e.g., GCN)**: We learn a function (weights). We can handle infinite nodes.

```python
import torch.nn as nn

# THE FUNCTION APPROACH (GNN)
# We don't store vectors; we store a transformation matrix W.
class GCNLayer(nn.Module):
    def __init__(self, in_dim, out_dim):
        super().__init__()
        self.W = nn.Linear(in_dim, out_dim) # Shared Weights!

    def forward(self, node_features, adjacency_matrix):
        # 1. Aggregate: Sum neighbor features (A * X)
        neighbor_msg = torch.matmul(adjacency_matrix, node_features)
        
        # 2. Combine: Apply learned weights (W)
        # Works for ANY node, even new ones, as long as they have features.
        return self.W(neighbor_msg)
```

---
### Seminal Works 

| **Year** | **Title**                                                                  | **Authors**              | **Type** | **Role in the Distinction**                                                                                                                                                  | **Link**                                             |
| -------- | -------------------------------------------------------------------------- | ------------------------ | -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------- |
| **2014** | **DeepWalk: Online Learning of Social Representations**                    | Perozzi et al.           | Article  | Defines **Shallow GRL**. Introduced the "Lookup Table" approach (Transductive), where every node gets a unique vector without shared weights.                                | [ArXiv](https://arxiv.org/abs/1403.6652)             |
| **2016** | **node2vec: Scalable Feature Learning for Networks**                       | Grover & Leskovec        | Article  | Refined **Shallow GRL**. Showed how to bias random walks (BFS/DFS) to capture structure vs. homophily, still using lookup tables.                                            | [ArXiv](https://arxiv.org/abs/1607.00653)            |
| **2017** | **Semi-Supervised Classification with Graph Convolutional Networks (GCN)** | Kipf & Welling           | Article  | Defines **Deep GNNs**. Replaced the lookup table with a function ($f(X, A)$) using shared weights, enabling "Message Passing."                                               | [ArXiv](https://arxiv.org/abs/1609.02907)            |
| **2017** | **Inductive Representation Learning on Large Graphs (GraphSAGE)**          | Hamilton et al.          | Article  | The **Inductive** breakthrough. Proved GNNs could generate embeddings for _unseen_ nodes (dynamic graphs), which Shallow GRL cannot do.                                      | [ArXiv](https://arxiv.org/abs/1706.02216)            |
| **2018** | **Representation Learning on Graphs: Methods and Applications**            | Hamilton, Ying, Leskovec | Review   | The **Rosetta Stone**. Explicitly categorizes the field into "Shallow Embeddings" (matrix factorization/random walk) vs. "Graph Neural Networks" (neighborhood aggregation). | [IEEE](https://arxiv.org/abs/1709.05584)             |
| **2020** | **Graph Representation Learning (Book)**                                   | William L. Hamilton      | Book     | Formalizes the **Encoder-Decoder** framework. Chapters 2-3 cover Shallow GRL; Chapter 5 introduces GNNs as the "Deep Encoder" solution.                                      | [Book Site](https://www.cs.mcgill.ca/~wlh/grl_book/) |
| **2021** | **A Comprehensive Survey on Graph Neural Networks**                        | Wu et al.                | Review   | The **Taxonomy**. Maps the evolution from GRL (Network Embedding) to Recurrent GNNs, Convolutional GNNs, and Graph Autoencoders.                                             | [ArXiv](https://arxiv.org/abs/1901.00596)            |

---
