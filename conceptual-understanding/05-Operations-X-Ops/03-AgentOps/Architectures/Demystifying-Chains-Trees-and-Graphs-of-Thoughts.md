---
tags:
  - monte-carlo-tree-search-mcts
  - agentops-language-agent-tree-search-lats
  - agentops
  - agentops-multi-agent-system-design
  - research-article
  - review-survey-articles
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

- Research Article ➝ [Dir: Demystifying-Chains-Trees-and-Graphs-of-Thoughts-v5-2025.pdf](<file:///home/az/04-Library/05-Operations-X-Ops/03-AgentOps/Architectures/Demystifying-Chains-Trees-and-Graphs-of-Thoughts-v5-2025.pdf>)
- [[Conceptual-Graph-Theory-Fundamentals-AgentOps]]
- arXiv ➝ [arXiv: Besta-Demystifying-Chains-Trees-and-Graphs-of-Thoughts](https://arxiv.org/abs/2310.04406) Real paper. Top tier venue.
- [[Conceptual-Basics-Anatomy-of-Compute-Feature-Manifolds-Circuit-Topologies]]

> - The paper builds the first taxonomy of structure-enhanced LLM reasoning schemes
> 	- referring to these structures as `reasoning topologies`
> 	- because their representation becomes spatial, contained within the LLM context

> - CoT 
> - ToT 
> - GoT 
> - LATS
> - are not separate techniques 
> - These are **different topological subsets** ➝ of 1 unified graph

> - The paper decomposes the **architecture** into **4 explicit modules** 
> 	- generator 
> 	- evaluator
> 	- halter 
> 	- controller 
> 	- which maps directly onto **Graph Theory framework**
> - [LanguageAgentTreeSearch - ICML 2024 - Official repository for ➝ Language Agent Tree Search Unifies Reasoning Acting and Planning in Language Models](https://lapisrocks.github.io/LanguageAgentTreeSearch/)
> 	- Generator ➝  edge expansion
> 	- Evaluator ➝ scalar weight assignment 
> 	- Halter ➝  termination condition on traversal 
> 	- Controller ➝ routing logic

---
### 1. Introduction

>**Authors Prologue**
> - To facilitate the understanding of this growing field + pave the way for future devs we devise a `general blueprint` for **effective** and **efficient** `LLM reasoning schemes`
> - For this, we conduct an in-depth analysis of the prompt execution pipeline, clarifying and clearly defining different concepts 
> - We then build the first taxonomy of structure-enhanced LLM reasoning schemes 
> - We focus on identifying fundamental classes of harnessed structures, and we analyze the representations of these structures, algorithms executed with these structures, and many others 
> - We refer to these structures as reasoning topologies, because their representation becomes to a degree spatial, as they are contained within the LLM context
> - Our study compares existing prompting schemes using the proposed taxonomy, discussing how certain design choices lead to different patterns in performance and cost
> - We also outline theoretical underpinnings, relationships between prompting and other parts of the LLM ecosystem such as knowledge bases, and the associated research challenges 
> - Our work will help to advance future prompt engineering techniques

####  I. Prompting & Prompts

- When this paper ➝ and the broader 2026 SOTA literature ➝ talks about `prompting schemes` like 
	- Chain of Thought (CoT) 
	- Tree of Thoughts (ToT)
	- Graph of Thoughts (GoT) 
- **they do not mean typing a static message into a chat interface.**

> - Because the field evolved out of basic NLP ➝ academia still uses the word `prompting` 
> - However, in the context of this framework ➝ mentally translate 
> 	- the phrase `prompting scheme` ➝  an **Inference-Time Control Algorithm** or a **Graph Traversal Strategy**.

##### I. It is a Python Script ➝ Not a Text String

> - A `prompting scheme` in this paper refers to ➝ the external programmatic scaffolding
> 	- the loops 
> 	- the state management
> 	- the conditional logic
> - wrapped around the LLM API

> - It is the system that 
> 	- parses the LLM's output 
> 	- decides if it is mathematically sound 
> 	- and then automatically constructs + injects the `next` hidden prompt ➝ to force the model down a specific path

> - For example ➝ the LATS `prompting scheme` requires 
> 	- running a Monte Carlo Tree Search algorithm in Python 
> 	- to dynamically assemble + fire off dozens of micro-prompts under the hood
    
##### II. Manifold Navigation Protocol

> Mechanistically a `prompting scheme` ➝ is the set of rules ➝ dictating how we force the LLM's attention mechanism ➝ to traverse its own activation space

> - If we use a **CoT prompting scheme** ➝  the algorithm forces the model into a linear path graph 
> - We are feeding its previous output back into its context window ➝ restricting its next token prediction to that single trajectory
    
> - If we use a **GoT prompting scheme** ➝ the algorithm is physically managing ➝ an array of different context windows ➝ vertices ➝ simultaneously
> 	- and then programmatically injecting them together 
> 	- to force the model to merge those activation states ➝ Synergy
    
##### III. Decoupling the Engine from the Steering Wheel

> - The authors use this taxonomy to prove a massive point for platform architects 
> 	- the LLM is just the engine 
> 		- the generator $\mathcal{G}$  
> 		- the evaluator $\mathcal{E}$

The `prompting scheme` is the steering wheel. It is the deterministic control flow (like LangGraph) that decides _when_ to call the LLM, _what_ specific subset of the graph to put in its context window, and _how_ to route the output.

When the authors say they are `analyzing existing prompting schemes,` they mean they are taking all these different GitHub repos and Python scripts (ToT, GoT, LATS, etc.) and stripping away their code to reveal the raw, underlying graph topologies driving their control loops.


the _prompting scheme_ (like LATS or GoT) is that overarching mechanistic process and traversal algorithm you just described. But the _prompt_ itself, in this architecture, is the precise, dynamic assembly of context injected into the model at a specific moment in time to force a calculation.

From a Mechanistic Interpretability perspective, think of the `prompt` as the physical tensor payload. When your control flow decides it is time to perform an _Expansion_ operation from Node A to Node B, it compiles the mathematical state of Node A, any external environment data from a tool call, and the specific routing instructions into a token sequence.

That sequence—the prompt—is then fired into the LLM's context window. Its sole purpose is to initialize the residual stream and force the model's attention heads into a highly specific geometric configuration on the activation manifold. It constrains the model so it can only compute the next logical edge in your graph. It is not a conversation; it is an algorithmic forcing function.



----

#### II. The Autoregressive Trap: The Baseline

> The authors start by pointing out that standard LLMs operate on greedy + next-token prediction

> #llm-autoregressive-perspective 
>  **Section:** The Mechanics of Autoregressive Generation ➝ [[DualPath-Breaking-the-Storage-Bandwidth-Bottleneck-in-Agentic-LLM-Inference]]

> - Mechanistically we can view this as ➝ a `linear` + `forward-only` **trajectory** ➝ through the model's activation space
> - At every step 
> 	- the model samples a token
> 	- which updates the context window
> 	- which strictly determines the next state

> #llm-activation-space-stream | [[Conceptual-Activation-Space-Level-The-Geometry-of-Machine-Thought]]

> - **The Problem** 
> - If an `early` token generation 
> 	- shifts the activation trajectory ➝ into a degenerate subspace ➝ a logical error or hallucination
> 	- the system has no structural mechanism to realize ➝ it made a mistake ➝  nor the ability to reverse course 
> - It is forced ➝ to continue predicting tokens conditioned ➝ on a flawed prefix

> #llmops-tokenization-tokens | [[Conceptual-Tokens]] | #llmops-hallucination 

#### III. The Topological Evolution of Thoughts

> - To escape this trap ➝ the industry started inventing new prompting paradigms
> - The paper argues that these are not just text tricks ➝ they are literal changes to the underlying graph topology of the reasoning process

- **Chain of Thought (CoT) — _The Path Graph_:** CoT forces the LLM to generate intermediate reasoning steps before the final answer. Structurally, it extends the graph into a longer Path Graph (a tree with a branching factor of 1). It gives the model more inference-time compute to navigate the manifold, but it still lacks a rollback mechanism. If step 2 is wrong, step 3 is doomed.
    
- **Tree of Thoughts (ToT) — _The Directed Out-Tree_:** This is the topological leap that enables systems like LATS. Instead of one path, the LLM generates multiple possible next steps (branches). Crucially, it introduces an _Evaluator_ function to grade these branches. If a branch hits a dead end, the algorithm (like MCTS in LATS) abandons it and explores a different branch.
    
- **Graph of Thoughts (GoT) — _The Cyclic Graph_:** The authors highlight their previous work, GoT, which removes the strict tree structure entirely. In a tree, branches never cross. In a Graph of Thoughts, you can have cyclic connections. Two independent reasoning paths can be mathematically merged (a vertex taking multiple incoming edges) to create a synergistic, superior thought.
    

#### IV. The Core Unification Thesis (The "Why")

The final paragraphs of this block identify a critical vulnerability in the field: the hype cycle. The literature is flooded with fragmented, branded paradigms—"Algorithm of Thoughts," "Forest of Thoughts," "Skeleton of Thoughts."

The authors argue this fragmentation makes it impossible to rigorously compare, optimize, or calculate the inference costs of these systems.

Therefore, the explicitly stated goal of this paper (and its 5 contributions) is to strip away the NLP marketing and reduce the entire field to pure discrete mathematics. They are defining a universal **blueprint**:

1. **Taxonomy:** Classifying every prompting technique by its exact graph structure.
    
2. **Unification:** Proving they all run on the same fundamental engine (Vertices, Edges, Generators, Evaluators).
    
3. **Cost Analysis:** Mathematically modeling the token/compute cost of traversing these different topologies.
    
4. **Extensibility:** Showing how systems like LATS fit perfectly into this blueprint via specific search algorithms.
    
5. **Future Directions:** Identifying where the math breaks down and what needs to be researched next.
    

---

By the end of this introduction, you are meant to stop looking at LLM reasoning as "predicting text" and start viewing it as a calculable routing problem over a geometric space.



---
### Evolution of Reasoning Topologies

This section is the historical and mathematical core of the paper. It maps exactly how the industry realized that an LLM’s context window isn't just a text buffer; it is a geometrical space that can be structured into increasingly complex graphs to force better mechanistic reasoning.

Here is the evolution from first principles.

## 1. The Baseline: Input-Output (IO) Prompting

- **The Topology:** A single edge connecting two vertices: Vinput​→Voutput​.
    
- **The Mechanics:** This is standard zero-shot prompting. You give the model a prompt, and it attempts a single, direct, greedy jump across the semantic manifold to the final answer.
    
- **The Vulnerability:** It relies entirely on the model's pre-trained weights to instantly construct the perfect activation trajectory. For complex math or logic, this almost always fails because the geometric distance between the problem and the solution is too vast for a single computational step.
    

## 2. The Linear Expansion: Chain of Thought (CoT)

- **The Topology:** A Path Graph. It is a sequence of connected vertices: v1​→v2​→⋯→vn​.
    
- **The Mechanics:** Instead of one massive jump, CoT forces the LLM to take smaller, intermediate steps. Mechanistically, each generated step (vertex) acts as an anchor in the activation space, conditioning the prefix for the next token prediction.
    
- **The Vulnerability:** It is strictly linear and non-reversible. It suffers from error compounding. If v2​ contains a hallucinated fact, the attention heads will attend to that flawed token, irrevocably dragging v3​ and v4​ into a degenerate mathematical subspace. There is no mechanism to branch out or look back.
    

## 3. The Branching Expansion: Tree of Thoughts (ToT)

- **The Topology:** A Directed Out-Tree. A single root node branches into multiple child nodes, which in turn branch further.
    
- **The Mechanics:** This is the exact structural prerequisite for the Language Agent Tree Search (LATS) framework. Instead of committing to a single path, the system uses the LLM (the Generator G) to propose multiple distinct next steps. It then uses an Evaluator E to score them. If a path is mathematically unsound, the search algorithm halts that branch and explores a parallel one.
    
- **The Vulnerability:** Trees cannot merge information. If Branch A figures out half the problem and Branch B figures out the other half, a strict tree topology has no physical mechanism to combine those two isolated states.
    

## 4. The Ultimate Unification: Graph of Thoughts (GoT)

- **The Topology:** A Directed Graph (often a DAG, but can contain cycles).
    
- **The Mechanics:** This is the current apex of reasoning topologies, breaking the constraints of trees. It introduces two fundamental graph operations that map directly to advanced cognitive synthesis:
    
    - **Synergy (Vertex Convergence):** Multiple independent reasoning paths can be merged into a single node. The LLM is prompted to look at vA​, vB​, and vC​, and generate a unified state vnew​ that combines their strengths.
        
    - **Refinement (Cyclic Loops):** A node can loop back on itself or a previous node. This is self-correction. The model critiques its own output, appending a correction edge, effectively refining its position on the manifold before moving forward.
        

---

## The Convergence with LATS

While Besta et al. map the _structure_ of these topologies, LATS maps the _navigation_ of them.

When you deploy a ToT or GoT architecture, the graph becomes too massive to explore exhaustively. You cannot generate every possible thought. The LATS framework injects the Monte Carlo Tree Search (MCTS) algorithm directly over these Tree and Graph topologies. It uses the UCT formula to mathematically decide whether to explore a new edge or exploit an existing high-value path, heavily anchoring the Evaluator's scores in external environment simulations (like code execution or tool use) rather than just the LLM's internal bias.