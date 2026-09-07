---
tags:
  - mechanistic-interpretability
  - conceptual-explanations
  - llm-manifolds-geometric-perspective
  - llmops-tokenization-tokens
  - llm-fundamentals
  - large-language-models-LLMs
  - large-reasoning-models-LRMs
  - note-finalized
---

---
```table-of-contents
```
---
### References

> [!info] .
>
>**[Obsidian Links]** 
>`$= dv.list([...new Map(dv.current().file.outlinks.filter(l => l.path.endsWith(".md")).map(l => [l.path, l])).values()])`
>
>---
>
> **[External Links]** 
> `$= const content = await dv.io.load(dv.current().file.path); const regex = /\[(.*?)\]\((https?:\/\/[^\s)]+)\)/g; const links = []; let m; while (m = regex.exec(content)) { links.push("[" + m[1] + "](" + m[2] + ")"); } dv.list([...new Set(links)])`
>
>---
>
> **[Directory Links]** 
> `$= const content = await dv.io.load(dv.current().file.path); const regex = /\[(.*?)\]\(<(file:\/\/\/.*?)>\)/g; const links = []; let m; while (m = regex.exec(content)) { links.push("[" + m[1] + "](<" + m[2] + ">)"); } dv.list([...new Set(links)])`
>
>---
> 
> **[Back Links]** 
> `$= dv.list([...new Map(dv.current().file.inlinks.map(l => [l.path, l])).values()])`
>
>---
> **[Document Tags]**
> 
>  `$= [...new Set(dv.current().file.tags)].join(" | ")`


---
### Primitives 

- [[Conceptual-Basics-LLMs-Mechanistic-Architecture]]
- [[Conceptual-Basics-Anatomy-of-Compute-Feature-Manifolds-Circuit-Topologies]]
- [[Conceptual-Basic-Scale-Structural-Hierarchy-LLMs]]
- [[Conceptual-Dot-Product-Intuition-LLMs]]
  
---
### 1. The Basics

> #llmops-embedding-unembedding-layer-embedding-matrix 

> - At its most fundamental level ➝ a token is the absolute **smallest** + **indivisible unit** of computation ➝ that a language model can perceive 
> - It is `not` necessarily a **whole word** 
> 	- depending on the **tokenizer's vocabulary** 
> 		- a `token` can be 
> 			- a single character 
> 			- a syllable 
> 			- a mathematical symbol 
> 			- or a common sub-word fragment ➝ like `inter` and `pret`

> - To understand `why` + `how` ➝ a `token` becomes ➝ a **dense activation vector** ➝ look at the **structural bottleneck** of neural networks 
> - Human language is **discrete** ➝ made up of **categorical symbols** 
> - However ➝ a **transformer** ➝ **cannot perform** calculus + matrix multiplication on the **string** `dog` 
> - It requires a `continuous` + `high-dimensional geometric space` where 
> 	- semantic meaning
> 	- syntactic function 
> 	- sequential context 
> - can be mathematically manipulated

> #llm-higher-dimension-space | #llm-activation-vector-hidden-state | #llm-residual-stream-additive-shared-communication-channel 

> [!quote] `Transformer` **requirements** for **functionality**: **Discrete Human Language** ➝ `mapped` to ➝ **Continuous High Dimensional Geometric Space**

#### I. Discrete String ➝ Initial State of Residual Stream @ Layer 0

> Exact mechanistic sequence of how a **discrete string** is `transformed` into the **initial state** of the **residual stream** at `Layer 0`

##### I. The One-Hot Index: Vocabulary Space 

> #llmops-one-hot-vector-index-encoding | #llmops-vocabulary-space | #llmops-tokenization-tokens | [[Project-Concepts-in-LLMOps-AgentOps-Phase-1-Pre-RAG]] 

> - When we input text 
> 	- the tokenizer ➝ chops it into **fragments** 
> 	- assigns each fragment ➝ a `unique integer ID` from its established vocabulary ➝ example: ID `4021`  

> - Mechanistically ➝ the architecture treats this integer ➝ as a **massive** + **sparse** `one-hot-vector`
> - If the model has a vocabulary of 50000 tokens ➝ this is a 50000-dimensional vector ➝ consisting entirely of zeros ➝ except for a single `1` at position `4021`

> #llmops-embedding-unembedding-layer-embedding-matrix | [[Conceptual-Sparsity-MI]] | [[Conceptual-Intertwined-Concepts-MI]]
> #llm-sparsity 

##### II. The Embedding Matrix: $W_E$

> - This **one-hot vector** is then ➝ `multiplied` by the ➝ **Embedding Matrix** ➝ $W_E$ 
> - Because of the zeros ➝ $W_E$ functions purely as ➝ a **massive lookup table** 
> - Its shape is ➝ `[d_vocab, d_model]` 
> - The `multiplication` physically plucks out the `4021st` row of the matrix
    
##### III. The Geometric Projection 

> - That specific row is  
> 	- a dense vector of floating-point numbers 
> 	- with a length of `d_model` ➝ example: 4096 dimensions 
> - During training 
> 	- the model learned ➝ to project the discrete token ➝ into this specific continuous direction 
> 	- placing it in a geometric manifold ➝ where its coordinates ➝ represent its semantic meaning relative to all other tokens

> #llm-semantic-meaning | #llm-manifolds-geometric-perspective 

##### IV. The Positional Addition 

> - Because transformers `process` all tokens **simultaneously** across the sequence ➝ the model has **no inherent concept** of **word order** 
> - To solve this 
> 	- a second vector ➝ the **Positional Embedding** ➝ $W_{pos}$ 
> 	- is mathematically `added` to the token's dense vector  
> - This injects the **spatial context** ➝ example: `this token is the 4th token in the sequence`

> #llmops-positional-embeddings-encoding   

> - At the exact millisecond the **positional vector** ➝ is `added` to the token embedding vector ➝ the `token` ceases to be a discrete word or a static vocabulary concept 
> - It formally becomes 
> 	- the **initial activation state** ➝ $h_0$
> 	- a dynamic + living **coordinate** ➝ flowing into the residual stream  ➝ #llm-residual-stream-vector | #llm-residual-stream-additive-shared-communication-channel 
> 	- completely prepared to be `read` + `routed` + `transformed` ➝ by the **Q-K/O-V circuits** + **MLPs** of the subsequent layers

> #llm-keys-values-query-weight-vectors | #llm-architecture-layer-multi-layer-perceptron-mlp | #mechanistic-interpretability-reasoning-circuits 

#### II. Citations

> **The Foundational Transformer Architecture**: Tokens, Embeddings, and Positional Math
> - [[Attention-Is-All-You-Need-Vaswani]]
> - This is the root paper where the mechanism of taking input tokens $X=(x_1,...,x_n)$, performing a lookup in an embedding matrix $W_E$, and adding positional embeddings to create the initial continuous vector state $h_i^0$ is formally mathematically defined

> **Auto-Regressive Token Processing**: GPT Architecture
> - [Pdf @ OpenAI: Language models are unsupervised multitask learners](https://cdn.openai.com/better-language-models/language_models_are_unsupervised_multitask_learners.pdf)
> - [[Language-Models-are-Unsupervised-Multitask-Learners-OpenAIResearch]]
> - This is the GPT-2 paper ➝  which the review highlights as the primary architecture used to study how tokens are processed sequentially through the residual stream and how the vocabulary space ($\mathcal{V}$) is defined for next-token prediction

> **The Geometry of Word Embeddings**: Pre-Transformer Context
> - [arXiv: Distributed Representations of Words and Phrases and their Compositionality](https://arxiv.org/abs/1310.4546)
> - [[Distributed-Representations-of-Words-and-Phrases-and-their-Compositionality-Google]]
> - While older than transformers ➝ this review cites this as the foundational proof of the Linear Representation Hypothesis ➝ demonstrating that discrete words ➝ tokens ➝ map to a continuous vector space where semantic meanings are represented as structural + geometric directions

> #llm-mechanistic-interpretability-linear-representation-hypothesis 

