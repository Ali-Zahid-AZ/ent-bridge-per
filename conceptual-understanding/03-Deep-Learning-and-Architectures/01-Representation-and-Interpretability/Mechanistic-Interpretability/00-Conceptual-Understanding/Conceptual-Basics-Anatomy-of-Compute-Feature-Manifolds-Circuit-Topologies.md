---
tags:
  - llm-fundamentals
  - llm-manifolds-geometric-perspective
  - mechanistic-interpretability-reasoning-circuits
  - mechanistic-interpretability-features
  - career
  - mechanistic-interpretability
  - llm-activation-space-stream
  - llm-higher-dimension-space
  - lrm-basics
  - conceptual-explanations
  - physics_to_ml_mapping
  - cross-domain-mappings
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

- [[Conceptual-Intertwined-Concepts-MI]]
- [[Conceptual-The-Geometric-Signature-of-Intelligence]]
- [[A-Practical-Review-of-Mechanistic-Interpretability-for-Transformer-Based-Language-Models]]
- [[A-Primer-on-the-Inner-Workings-of-Transformer-based-Language-Models]]
- [[Conceptual-Logit-Lens]]
- [[Conceptual-Tokens]]
- [[Project-Helical-Clock-Conceptual]] ➝ Circuits + Attention Heads
- [[Conceptual-Axiom-MI-Geometric-Constraints]]


>[!success] **Fundamental Question**: **How** & **What** an **LLM** is **thinking** ➝ Study of **Features** + Study of **Circuits**
>
>
> **Personal Structuralist Approach**
>
> | **Scale** | **Focus Area**           | **Key Components / Concepts**                                                        |
> | --------- | ------------------------ | ------------------------------------------------------------------------------------ |
> | **PICO**  | **Foundational Weights** | Individual weights, attention scores, $Q/K/V$ matrices, and biases                 |
> | **NANO**  | **Algorithmic Circuits** | How multiple heads compose to implement specific algorithms ➝ induction heads |
> | **MICRO** | **Activation Space**     | Features, concepts, superposition, and Sparse Autoencoders (SAEs)                   |
> | **MACRO** | **Observable Behavior**  | High-level model outputs, hallucinations, and confabulations                        |
> 


> To decipher exactly **how** and **what** an LLM is thinking ➝ need to look at the **Study of Features** ➝ supplemented by the **Study of Circuits**

> [!example] **Features & Circuits**
> - **Feature Study** maps: the **physical** `shape` of the thoughts ➝ the vectors, manifolds, and helices
> - **Circuit Study** maps: the `flow` of those thoughts ➝ how **they move** from layer to layer

> #mechanistic-interpretability | #mechanistic-interpretability-reasoning-circuits | #mechanistic-interpretability-features  | #mechanistic-interpretability-theories 

---
### 1. First Principles Breakdown

#### I. The Study of Features: The Geometry of Thoughts

>-  When we are using **probes** to **map activation vectors** and **visualizing manifolds** ➝ we are conducting a `Feature Study` 
> - This direction is all about **decoding the representation space** ➝ the `brain state` of the model

> #representation-learning | #llm-manifolds-geometric-perspective | #mechanistic-interpretability-features | #mechanistic-interpretability-theories 

##### I. Probes and Activation Vectors

- An LLM does **not** think in English ➝ it thinks in **high-dimensional mathematics** 
	- [[Conceptual-Manifold-Geometry-of-Large-Language-Models]]
- As a **token** passes through the transformer layers ➝ it is **represented** as a **dense activation vector** in the residual stream 
	- [[Conceptual-Tokens]]
- To read this thought ➝ researchers use **probes** ➝ like the **Logit Lens**
	- [[Conceptual-Logit-Lens]]
- A probe acts as a **translator** ➝ **projecting** these hidden intermediate vectors ➝ back out to the vocabulary
- This allows us to **peek into layer** 15 of a 30-layer model ➝ see exactly `what` **concept** the model is currently holding in its working memory ➝ **before it has finished** computing the **final answer**

> #llm-manifolds-geometric-perspective | #mechanistic-interpretability-tools | #mechanistic-interpretability-logit-lens | #llmops-tokenization-tokens | #llm-residual-stream-additive-shared-communication-channel | #llm-activation-space-stream 

##### II. Manifolds and Helical Geometry

- The **geometry** of the `activation space `
- Under the **Linear Representation Hypothesis** ➝ we originally assumed that models represented concepts ➝ as simple, straight lines  ➝ linear vectors 
- However, deep feature analysis reveals ➝ that LLMs construct `complex non-linear` **manifolds**
- For example
	- When an LLM processes modular or cyclical knowledge ➝ such as days of the week, months, or spatial coordinates ➝ the **activation vectors do not form straight lines** 
	- Instead ➝ they warp into continuous **circular or helical geometries** within the high-dimensional space
	- The model's `thought` takes on the ➝ **literal structural shape of the concept it represents**

> #llm-helical-structure | #llm-reasoning-traces | #llm-neural-signatures | #llm-mechanistic-interpretability-linear-representation-hypothesis | #llm-manifolds-geometric-perspective | #llm-higher-dimension-space 

#### II. The Study of Circuits: The Flow of Thoughts

> - While mapping the helical geometry tells `what` the thought looks like ➝  it does not indicates `how` the model uses it to solve a problem
> - This is the region of **Circuit Study**

> - **The Thought Process** 
> 	- A thought process is algorithmic 
> 	- If the model needs to **perform arithmetic** or **recall a fact** ➝ it relies on a **circuit** ➝ a **specific, localized pathway** ➝ of **computational nodes**
    
> - **The Mechanism** 
> 	- In this phase ➝ we are **no longer** just **looking** at the **shape** of the **activation vector**
> 		- we are tracking how a **specific Attention Head** ➝ **reads** that geometric feature from the residual stream
> 			- **transforms** it 
> 			- and **writes** a new vector forward ➝ for a Multi-Layer Perceptron **MLP to process**
    
> - If we want to use a probe to map out the helical manifold of how an LLM understands `time` ➝ in the **Study of Features** 
> - If we want to watch the LLM use that helix to calculate what day comes after Tuesday ➝ in the **Study of Circuits**

> #mechanistic-interpretability-linear-probes | #mechanistic-interpretability-techniques | #mechanistic-interpretability-attention-heads | #llm-activation-space-stream | #llm-activation-vector-hidden-state | #llm-architecture-layer-multi-layer-perceptron-mlp

#### III. Overlap: Feature Study & Circuit Study

> - Both these MI sub-domains overlapt ➝ in fact one cannot practically exist without the other
> - Idea ➝  we are looking at two sides of the exact same physical mechanism within the transformer's architecture

> - To map the **flow of thoughts** ➝ **Circuits**
> 	- we fundamentally need to know **what those thoughts** are ➝ **Features**
> 	- If we try to **map a circuit** without understanding the **underlying features** ➝ we are just looking at **raw weight matrices** ➝ $W`Q$, $W`K$, $W`V$, $W`O$ ➝ moving seemingly random numbers around
> 	- We might figure out that ➝ Attention Head 5 in Layer 9 passes a vector to the MLP in Layer 10
> 		- but **without the feature map** ➝ we have no idea `what` concept is being transmitted
> 	- It is like mapping the wiring of a house without knowing if the wires are carrying electricity, water, or data

> - If we **only** look at **features** ➝ we see beautiful geometric structures like manifolds and helices ➝ in the activation space ➝ but we miss how they are constructed
> 	- Those structures don't just appear out of nowhere
> 	- They are mathematically forged layer by layer

> How the two areas collapse into a single workflow at the **weight** and **activation** level

- **The Shared Workspace** 
	- Both fields operate heavily on the residual stream
	- The residual stream is the central highway where the model accumulates its `thoughts` by adding vectors together
	- [[Conceptual-Residual-Stream-Geometric-Manifold]]
	- [[Conceptual-Residual-Stream-Geometric-Mechanistic]]
    
- **The Read/Write Operation** 
	- A **circuit** is defined by 
		- how a **component** (like an attention head) ➝ **reads** a specific **feature** ➝ a **vector** located on that **helical manifold** ➝ from the residual stream 
	- The **component** transforms that vector ➝ using its specific weight matrices + writes a `new` feature back into the stream
	- We are **tracking** the ➝ **geometric transformation of the feature** ➝ to understand the circuit
    
- **The Superposition Bottleneck** 
	- This is where the overlap is strictly mandatory
	- Because language models **compress** millions of concepts into a **smaller number of dimensions** ➝ **superposition**
		- individual neurons become `polysemantic` ➝ they **fire** for completely **unrelated** things
		- [[Conceptual-Superposition-MI-LLMs]]
	- If we try to **trace a circuit** ➝ through **polysemantic neurons** ➝ the **computational graph** is an **unreadable mess of overlapping noise**
	- We `must` first use **tools** from **Feature Study** ➝ specifically Sparse Autoencoders (**SAEs**) ➝ to untangle the compressed activation space ➝  into clean + isolated + single-concept features 
	- Only after the features are disentangled ➝ we can actually draw the edges of the circuit

> #mechanistic-interpretability-superposition | #mechanistic-interpretability-superposition 

>- In practice we are never really being isolated in just one of these fields
>- We **extract** the **geometry** of the **activation space** ➝ to define the starting and ending points
>	- and then we analyze the attention and MLP weights ➝ to figure out the mathematical transformations connecting them
>- Tt is a single, unified loop of reverse-engineering

---
### 2. Fundamental Building Blocks 

#### I. The Study of Features: The Geometric Workspace

##### I. The Residual Stream 

> The central high-dimensional communication channel where vectors are accumulated
    
##### II. Activation Spaces & Manifolds 

> The literal geometric landscape ➝ linear directions, helices, clusters ➝ where concepts live

##### III. Monosemantic Features 

> Pure, isolated vectors representing a single, distinct concept
    
##### IV. Polysemantic Neurons 

> Individual neurons that **fire** for multiple + entirely **unrelated** concepts due to **compression**
    
##### V. Superposition 

> The mathematical phenomenon of packing more features into the model than it has dimensions
    
##### VI. Sparse Autoencoders: SAEs

> The unsupervised networks bolted onto the LLM to untangle superposition into interpretable features
    
##### VII. Probes: Logit Lens & Tuned Lens 

> The linear transformations used to project hidden intermediate layer vectors directly out to the human-readable vocabulary

> #llm-monosemanicity | #llm-polysemanticity | #mechanistic-interpretability-logit-lens | #mechanistic-interpretability-linear-probes | #mechanistic-interpretability-sae | #mechanistic-interpretability-techniques | #mechanistic-interpretability-superposition | #mechanistic-interpretability-superposition | #llm-activation-space-stream | #llm-residual-stream-additive-shared-communication-channel 

#### II. The Study of Circuits: The Algorithmic Flow

##### I. Computational Graphs 

> The structural mapping of nodes (components) and edges (information flow) within the model
    
##### II. Residual Stream ➝ Read & Write Operations 

> The mechanism by which a component projects a vector out of the stream (read), transforms it, and adds a new vector back in (write)
    
##### III. Q-K Query-Key Circuits 

> The weight matrices (WQ​,WK​) that compute attention scores ➝ determining `where` the model looks
    
##### IV. O-V Output-Value Circuits 

> The weight matrices (WV​,WO​) that compute the actual information vector ➝ determining `what` information is moved
    
##### V. Specialized Attention Heads 

> The **routing mechanisms** ➝ categorized by function:
   >- `Previous Token Heads:` Gathering immediate local context
   >- `Induction Heads:` Driving in-context learning and sequence completion     
>   - `Name Mover / Subject Mover Heads:` Copying specific entities to the final output prediction
        
##### VI. Multi-Layer Perceptrons ➝ MLPs

> Functioning mechanistically as massive key-value memory banks that elevate or alter specific features.
    
##### VII. Activation: Path Patching

> The surgical interventions used to corrupt, ablate, or restore specific nodes and edges to prove causal pathways


![[Pasted image 20260225205723.png | 600]]

---
### 3. Layer by Layer Mapping: What the LLM is thinking? 

#### I. FlowChart: Features & Circuits 


![[Pasted image 20260225204120.png | 900]]

#### II. The Mechanical Breakdown: How They Work Together

> - To truly understand the LLM's thought process ➝ we cannot look at the stream or the layers in isolation
> - We have to alternate between the two fields sequentially

##### I. The Feature Study: The Snapshot

> - At the boundary between any two layers ➝ the computation stops for a microsecond
> - The residual stream holds a vector
> - If we pause the model here ➝ **Feature Study** takes over

> - We use tools like **Sparse Autoencoders (SAEs)** ➝ because the vector is in superposition ➝ thousands of concepts are crammed into a few dimensions
> 	- The SAE untangles the math and tells us ➝ `At Layer 5, the vector is heavily activating for the concept of 'Monuments' and 'France'` 
> 	- We are mapping the exact coordinate of the thought in the geometric space
> 	- We know `what` is there ➝ but we don't know who put it there or what will happen to it next

##### II. The Circuit Study: The Machinery

>- Once we know the thought is `France` ➝ we hit plays
>- The vector enters Layer 6
>- Now, **Circuit Study** takes over

> - We ignore the geometric space and look strictly at the weight matrices
> - We observe that an **Attention Head** ➝ specifically its $W_Q$ and $W_K$ matrices ➝ recognizes the `France` feature 
> - Because of how its weights are structured ➝ it decides to route this information to the MLP sublayer
> - We then watch the MLP weights perform a matrix multiplication ➝ that transforms the `France` vector into a `Paris` vector
> 	- and uses the $W_O$ matrix to write it back into the stream.

> We have successfully mapped `how` the thought was processed

##### III. The Continuous Loop

> [!quote] **The Continuous Loop**
>- **Feature Study** gives the **nouns** ➝ the concepts, the vectors, the manifolds
>- **Circuit Study** gives the **verbs** ➝ the routing, the reading, the writing

> - By using **SAEs** to define the **inputs** and **outputs** of **every layer** + using **circuit analysis** to define the **weight matrices** connecting them ➝  we can watch 
> 	- a **thought originate** as a simple **token** 
> 	- get **enriched** with context 
> 	- get **routed** through memory banks 
> 	- **physically morph** into the final answer

---
### 4. The Tools: Feature Study & Circuit Study 

> - Both fields possess their own deep theoretical frameworks and their own highly specialized engineering tools 
> - They are better understood as 
> 	- **The States** (Features) 
> 	- **The Transformations** (Circuits)

#### I. The Study of Features: The Nouns & The States

> This field is dedicated to understanding the physical shape of the information at any frozen moment in time

##### I. The Theory

- The core theory here is the geometry of activation spaces 
- It dictates that LLMs do not store concepts randomly ➝ they build structural, mathematical representations ➝ like linear directions, clusters, or helical manifolds
- It also relies heavily on the theory of superposition ➝ the mathematical phenomenon where a model compresses thousands of concepts ➝ into a smaller number of dimensions ➝ resulting in polysemantic neurons
   
##### II. The Tools 

- To interact with this theory ➝ we use extraction tools
- We bolt on Sparse Autoencoders (SAEs) ➝ to untangle the compressed superposition ➝ back into isolated, interpretable vectors
- We also use Probes ➝ such as the Logit Lens ➝ to project a high-dimensional vector ➝ from the middle of the residual stream ➝ directly into the human vocabulary to read what the model is currently holding in its memory
- [[Conceptual-Logit-Lens]]
- [[Conceptual-Sparse-Auto-Encoders-SAE-MI]]

#### II. The Study of Circuits: The Verbs & The Transformations

> This field is dedicated to understanding the **mechanical algorithms** that **move** and **change** the **information** from **one layer to the next**

##### I. The Theory

- The underlying theory treats the language model ➝ as a **massive**, **directed computational graph**
- It posits that **specific weight matrices** ➝ **execute distinct algorithmic roles** such as
	- $W`Q$ and $W`K$ matrices ➝ **compute attention scores to route information** 
	- while Multi-Layer Perceptrons (MLPs) ➝ act as **vast key-value memory banks** ➝ that **recall factual associations**
    
##### 2. The Tools 

- To interact with this theory ➝ we use surgical intervention tools 
- The primary tool is ➝ **Activation Patching** (or Path Patching) 
- We do the following
	- run a **forward pass** 
	- **pause** the model 
	- **surgically** sever the **connection** between a specific **Attention Head** and an **MLP**
	- **inject** a **corrupted vector** 
	- and see if the **final output changes** 

> This proves causal flow ➝ verifying that a **specific edge in the graph** is responsible for moving the thought forward

>[!quote]  **Putting it all Together**
> - Feature Study uses ➝ **SAEs** (tools) ➝ to **map the manifolds of superposition** (theory) ➝ telling us exactly `what` the LLM is thinking
> - Circuit Study uses ➝ **Path Patching** (tools) ➝ to **map the computational graph** (theory) ➝ telling us exactly `how` the LLM mathematically processes that thought to generate the next word

---
### 5. The Analogy: The Brain + The Organism 

> This fundamental analogy is **mine** BUT it has been **refined** by **Gemini** 

> - Feature Study is mapping the **neurochemistry** + the **static lobes** of the `brain` ➝ what the thoughts are made of and where they are stored 
> - Circuit Study is mapping the **nervous system** + the **muscles** in **motion** ➝ how the organism actually gets up and interacts with the world

> Here is how that progression from `brain` to `organism` physically plays out at the weight and activation level inside a transformer

#### I. The Brain: Mapping the State

- When we look at the `brain` of the LLM ➝ we are freezing time
- We are not looking at the model doing anything ➝ we are simply looking at what it `knows` + how it `organizes` that knowledge in the residual stream

##### I. The Anatomy

- We are examining the activation vectors
- If the model is processing a prompt about physics ➝ we use Sparse Autoencoders (SAEs) ➝ to look at the exact coordinates in the high-dimensional space 
	- where concepts like `velocity` or `mass` are stored
    
##### II. The Geography

- We find that these concepts are not scattered randomly
- They form structured geometric shapes (manifolds) 
- The `brain` has a literal topography of knowledge
    
##### III. The Limitation

- However, a brain in a jar cannot write an essay or solve a math problem
- It just holds states
- To generate the next token, the model must act
    
#### II. The Organism: Animating the Mechanism

>- To progress to the `organism` ➝ we unpause time
>- We **stop** looking at the **static vectors** 
>	- and **start** looking at the **weight matrices** 
>		- $W_Q, W_K, W_V, W_O$ in attention
>		- the weight matrices of the MLPs
>- These are the muscles and tendons that animate the system

##### I. The Reflexes: Attention Heads

- Consider the **Induction Head** as a fundamental reflex of the organism 
- If the prompt is `A B ... A` ➝ the organism needs to predict `B` 
- The Induction Head acts as an active search mechanism 
- Its Query ($W`Q$) and Key ($W`K$) weights scan the `brain` (the residual stream) for the previous instance of `A`
	- and its Value ($W`V$) and Output ($W`O$) weights ➝ physically grab the feature `B` and yank it forward to the present token

##### II. The Digestion: MLPs 

- When the organism encounters a new entity ➝ it passes that entity's feature vector into an MLP sublayer 
- The MLP acts like a metabolic pathway
- Its weight matrices
	- read the incoming vector
	- transform it through a non-linear activation function 
	- and write a completely new, enriched vector back into the stream
    
#### III. The Complete Life Cycle

> - We cannot truly understand an organism by just looking at its muscles ➝ because we wouldn't know what signals the brain is sending them
> - Conversely we cannot understand it by just looking at the brain, ➝ because you wouldn't know how those thoughts translate into physical action

> - By combining Feature Study (the brain's states) + Circuit Study (the organism's mechanisms) ➝  we achieve total, end-to-end Mechanistic Interpretability 
> - We know exactly 
> 	- what the representation is
> 	- which specific weight matrix grabbed it
> 	- how it was mathematically transformed
> 	- and why it resulted in the final generated word

---
### 6. Dual Specialization: Features + Circuits 

#### I. Weaponizes Graph Theory 

- Circuit analysis is ➝ at its core ➝ **applied graph theory** on a massive scale
- When we map the **nodes** (attention heads, MLPs) + **edges** (residual stream connections, path patching) ➝ we are literally **tracing a directed computational graph**
- Combining this with ➝ the **geometric manifolds** of **Feature Study** ➝ means we are not just mapping a static network ➝ we are tracking **how high-dimensional representations evolve** as they **traverse that graph**

#### II. Enables True Representation Engineering 

- If we want to architect production-grade LLMOps pipelines ➝  treating the model as a black box is a liability 
- By mastering both domains ➝ we gain the **ability** to **intervene during inference**
- We can **locate** a **hallucination** **geometrically** (Feature Study) ➝ and surgically **steer** the **activation vector** ➝ right before it hits the faulty MLP (Circuit Analysis)
- This is how we build **deterministic reliability** into generative systems

#### III. Unlocks Custom Architecture Design

> - When we are coding a mechanistic micro-transformer from the ground up
> 	- we need to know exactly ➝ **how to initialize the weights** ➝ to encourage **monosemanticity**
> 	- and how to **structure the Q-K/O-V circuits** ➝ to **optimize** for **specific induction heads**
> - We are not just training a model to minimize loss ➝ we are **engineering** the **specific internal machinery** we want it to develop

> - We are no longer just looking at the `brain` or the `organism` in isolation
> - We are learning how to build the entire synthetic entity from the first principles of its weights and activations
> - It is an intense path ➝  but it is exactly how to move past the `fluff` and master the actual mechanics

---
### 7. Circuit Analysis: Graph Theory Perspective 

> How **Circuit Analysis** maps directly to **pure graph theory** from **first principles**

#### I. The Transformer as a Directed Acyclic Graph: DAG

A transformer model ➝ when unrolled during a forward pass ➝ is essentially a **massive, weighted, Directed Acyclic Graph**

##### I. The Vertices: Nodes

> In this graph ➝ the **nodes** are the **specific** + **localized** computational components

- The starting nodes (sources) ➝ are the **embedded input tokens**
- The **intermediate nodes** are the individual **Attention Heads** (Head 0 in Layer 2, Head 4 in Layer 5) + the **Multi-Layer Perceptrons** (MLPs) ➝ at **each layer**
- The terminal nodes (sinks) are ➝ the **output logits** ➝ generated by the **unembedding matrix**

##### II. The Directed Edges: Information Flow 

> - The edges are the pathways of information routed through the residual stream
> - These are not simple binary connections ➝ they are quantitative, directed flows of vectors

- When the Q-K (Query-Key) matrix of an attention head ➝ **calculates** a **high score** from one token to a previous token ➝ it **opens** an **edge**
- The O-V (Output-Value) matrix ➝ then dictates exactly `how much` and `what type` of **information flows across that edge**

##### III. The Subgraphs: The Circuits

When MI researchers state they have discovered a `circuit` (like an Induction Circuit for in-context learning or a Name Mover Circuit for entity tracking), they are describing a highly conserved, functionally specific **subgraph** embedded within the macro-graph of the LLM.

### Proving the Graph Topology (Activation Patching)

In standard graph theory, if you want to know how important a bridge is to a city's traffic grid, you close the bridge and measure the disruption. Mechanistic Interpretability does the exact same thing using a tool called **Activation Patching** (or Path Patching) to prove the existence of these subgraphs.

Here is the step-by-step algorithm:

1. **Run the Graph (Clean):** You pass a clean prompt (e.g., `John and Mary went to the store. John gave a drink to`) and record the exact activation values flowing across every edge. The model correctly predicts `Mary`.
    
2. **Run the Graph (Corrupted):** You pass a corrupted prompt (e.g., `John and John went to the store...`) and record the new, incorrect flow of information.
    
3. **Surgically Graft Edges:** You take the corrupted graph, but you mathematically force one specific edge (say, the edge connecting Head 2.4 to Head 8.1) to carry the exact vector values it had during the clean run.
    
4. **Measure the Output:** If restoring just that one edge causes the corrupted graph to suddenly predict the correct answer (`Mary`), you have mathematically proven that this specific edge is the causal bottleneck for that logic.
    

By viewing models through this graph-theoretic lens, you stop seeing a dense matrix of billions of parameters and start seeing distinct, isolated computational pathways. Designing a Mechanistic Micro-Transformer from scratch then becomes an exercise in deliberately engineering the topology of these subgraphs so that the correct features flow to the correct nodes at the exact right time.



