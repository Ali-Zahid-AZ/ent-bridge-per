---
tags:
  - agentops
  - llmops-agentops-production-frameworks
  - agentops-memory
  - conceptual-explanations
  - reading-list
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

> - **Working** Memory ➝ In-Context
> - **Episodic** Memory ➝ Experiences & Trajectories
> - **Semantic** Memory ➝ Factual Knowledge
> - **Procedural** Memory ➝ Skills & Rules

- [[Conceptual-Basics-LLMs-Mechanistic-Architecture]]
- [[Conceptual-Agent-Architectures-Evolution-Latest-and-Mathematics]]
- [[Conceptual-Production-Grade-Methodology-Tools-AgentOps]]
- [[Conceptual-KV-Cache-LLMOps]]
- [[Conceptual-Activation-Space-Level-The-Geometry-of-Machine-Thought]]
- [[Conceptual-Basics-Anatomy-of-Compute-Feature-Manifolds-Circuit-Topologies]]
   
---
### 1. Working Memory: In-Context 

#### I. The Basics

> The active `council` of the **current interaction**

#### II. The Why & How at the Activation Level 

> Working memory is **strictly bound** by the model's `context window` but structurally ➝ it is just the **KV Cache** ➝ sitting in the hardware's VRAM

> - When an LLM **processes a sequence** ➝ each token ➝ is `multiplied` by **learned weight matrices** to produce 
> 	- Query ($Q$) 
> 	- Key ($K$) 
> 	- Value ($V$) vectors 
> - To predict the `next` token ➝ the **attention heads** need to compute how much `focus` to allocate to previous tokens

> - Instead of **recomputing** the $K$ + $V$ vectors ➝ for **all past tokens** ➝ for **every single new word** ➝ the architecture `caches` them 
> - Working memory is therefore ➝ a **physical** + **continuously updating tensor** ➝ of `cached activations` 
> - Once the session ends or the context limit is hit ➝ this VRAM cache is flushed ➝  and the memory ceases to exist ➝ **volatile memory**

#### III. Technical Schematic: Linear Projection in Self Attention

![[Pasted image 20260327030243.png | 700]]

> - Technical schematic illustrating the **linear projections** that `transform` token embeddings ($X$) ➝ into the Query ($Q$) + Key ($K$) + Value ($V$) vectors ➝ during **self-attention**
> - Consider the parallel pathways ➝ the `Linear Projections`
> 	- **The Input Activation (X)**  
> 		- The diagram starts with the Input Sequence (Tokens) ➝  which are embedded into the high-dimensional matrix Input Embeddings ($X$)
> 	- **The Dynamic Multiplication** 
> 		- We take a specific embedded vector 
> 			- for example ➝ the vector representing the token `cat` ➝ which is highlighted in blue/green/orange 
> 		- This single activation vector is simultaneously passed through **3 distinct operations** 
> 		- It is mathematically multiplied ($\times$) by the Learned Weight Matrices ➝  $W_q$, $W_k$, and $W_v$
> 	- **The Resulting Memories** 
> 		- The outcome of these 3 operations is the generation of 3 completely new activation vectors ➝ $q_{cat}$, $k_{cat}$, $v_{cat}$ 
> 		- As the diagram shows ➝ these are vectors containing the encoded semantic purpose of that token for this specific processing layer
> - By looking at this snapshot of the forward pass ➝ we can see how the model's static, parametric weights shape the dynamic geometry of the activation flow ➝ preparing the necessary vectors to compute where attention must be focused
    
> #llm-activation-vector-hidden-state | #llm-in-context-memory | #llmops-kv-cache |  #llm-keys-values-query-weight-vectors | #llm-activation-space-stream | #llmops-tokenization-tokens | #mechanistic-interpretability-attention-heads 

>  - [[Conceptual-Activation-Space-Level-The-Geometry-of-Machine-Thought]]
>  - [[Conceptual-KV-Cache-LLMOps]]
>  - [[Conceptual-Tokens]]
>  - [[Conceptual-Attention-Heads-MI]]

---
### 2. Episodic Memory: Experiences & Trajectories

#### 1. The Basics

> - The agent's **historical log** of 
> 	- specific **events** 
> 	- **actions** taken 
> 	- and the **outcomes** of those actions

#### II. The Why & How at the Activation Level 

- Because the KV Cache cannot hold infinite data, episodic memory relies on projecting data into a geometric space (a vector database).
    
- When an agent takes an action (e.g., `I called the search API and it failed`), that exact state-action pair is passed through an embedding model. This converts the sequence into a single, high-dimensional coordinate (a vector) on a mathematical manifold.
    
- When the agent faces a similar situation later, its current prompt is also vectorized. The system calculates the geometric distance—usually using cosine similarity—between the current state vector and the stored episodic vectors.
    
- The closest vectors (past experiences) are retrieved and injected directly into the Working Memory. This mathematically biases the LLM's current attention mechanism toward mimicking the historically successful trajectory or avoiding a past error.

> #llm-episodic-memory | 
---


## 3. Semantic Memory (Factual Knowledge)

**What it is:** The agent's library of static world knowledge, facts, and user profiles, entirely decoupled from chronological time.

**The `Why` and `How` at the Activation Level:**

- Mechanically, Semantic memory operates almost identically to Episodic memory through Retrieval-Augmented Generation (RAG). External documents or facts are chunked, embedded, and stored as coordinates in a latent space.
    
- The distinction lies in the nature of the retrieval. Episodic memory searches for `What sequence of actions did I take last time?`, whereas Semantic memory searches for factual grounding.
    
- By computing the dot product between the current query and the semantic knowledge base, the agent pulls exact factual tokens into its KV Cache. This forces the model to attend to external, hard-coded facts rather than relying purely on the superposition of abstract concepts hidden and compressed within its own neural weights.
    

## 4. Procedural Memory (Skills & Rules)

**What it is:** The fundamental `muscle memory` that dictates `how` the agent operates, formats outputs, and utilizes tools.

**The `Why` and `How` at the Activation Level:**

- In basic agents, procedural memory is artificially forced into Working Memory via a System Prompt.
    
- However, true procedural memory resides in the model's **Parametric Weights**—specifically within the Feed-Forward Network (FFN) layers (the MLPs).
    
- You can think of the MLP layers as massive associative memory banks. The first layer acts as a `Key` (recognizing a specific geometric pattern in the residual stream) and the second layer acts as a `Value` (adding the learned procedural rule back into the stream).
    
- When an agent is fine-tuned for tool-calling or specific reasoning formats, you are physically altering the weights of these MLPs. You are reshaping the geometry of the activation space so that the agent naturally routes toward specific behaviors without needing explicit instructions taking up space in the KV Cache.
    

---

### Citations

> The foundational literature that formalized this architecture

1. **Cognitive Architectures for Language Agents (CoALA)** * `Sumers, T. R., Yao, S., Narasimhan, K., & Griffiths, T. L. (2023).` * **Significance:** This is the definitive paper that maps the four memory types (Working, Episodic, Semantic, Procedural) to LLM agent design, drawing heavily from cognitive science and symbolic AI to create a unified framework. (arXiv:2309.02427)
    
2. **Generative Agents: Interactive Simulacra of Human Behavior** * `Park, J. S., O'Brien, J. C., Cai, C. J., Morris, M. R., Liang, P., & Bernstein, M. S. (2023).` * **Significance:** This paper is famous for the `Stanford Virtual Town` experiment. It provides a phenomenal structural breakdown of how to build memory streams, retrieval functions, and reflection mechanisms to create robust Working and Episodic memory loops. (arXiv:2304.03442)

---
---
#### map out how an agent's routing mechanism physically decides whether to query the Episodic or Semantic vector space during an active reasoning loop


To understand how an agent physically routes a query between Episodic (past experiences) and Semantic (factual knowledge) memory, we have to look past the Python wrappers of frameworks like LangChain. At the mechanistic level, this decision is not an `if/else` statement; it is entirely a geometric transformation happening inside the model's residual stream.

Here is the step-by-step breakdown of how this routing physically occurs at the weight and activation level:

## 1. The Initial State and the Residual Stream

- When an agent enters a reasoning loop and realizes it lacks information, this state of uncertainty is encoded as a sequence of tokens (e.g., the agent's internal monologue generating: ``I need to figure out why this specific API call failed last time``).
    
- These tokens are projected into the model's initial embedding space and injected into the **residual stream**. You can visualize the residual stream as a central, high-dimensional highway carrying a continuously evolving vector. Every layer of the transformer will read from this highway, perform a calculation, and write a new geometric vector back into it.
    

## 2. Attention Heads as Feature Extractors

- As this vector passes through the transformer blocks, the attention mechanism scans the context. Specific attention heads act as localized circuits designed to detect the `flavor` of the missing information.
    
- If the context contains chronological markers or experiential uncertainty (``last time,` `the error I got,` `my previous step``), specific induction heads activate. They read these tokens and write a directional vector back into the residual stream that shifts the overall geometry toward an `episodic` subspace.
    
- Conversely, if the context is strictly factual (``What is the architecture of a transformer?``), a completely different circuit of attention heads fires, steering the residual stream vector in a different mathematical direction on the manifold.
    

## 3. MLPs as Associative Memory Routers

- After the attention heads move the information around, the Multi-Layer Perceptrons (MLPs) act as the physical routers. They take the updated vector from the residual stream and pass it through a non-linear activation function.
    
- This is where **superposition** is crucial. The model has compressed thousands of routing behaviors into these weights. The MLP acts as a massive key-value lookup: if the incoming vector (the `key`) geometrically aligns with the pattern for `I need historical context,` the MLP outputs a `value` vector that strongly biases the model toward episodic retrieval.
    

## 4. The Logit Lens and the Final Token Decision

- If we were to apply a **logit lens** at these late layers—meaning we take the hidden state of the residual stream and project it directly to the vocabulary to see what the model is `thinking` before the final layer—we would see the probability mass shifting dramatically as it passes through each MLP.
    
- By the final layer, the geometry of the activation space has been so heavily rotated and skewed by the attention heads and MLPs that the highest probability logit corresponds to the exact syntax needed to trigger the correct tool (for example, generating the specific string `<Call`Episodic`DB>` instead of `<Call`Semantic`DB>`).
    

Ultimately, the routing mechanism is a deterministic sequence of matrix multiplications. The shape of the agent's uncertainty forces a geometric rotation in the activation space, which naturally points the final output toward the correct database.