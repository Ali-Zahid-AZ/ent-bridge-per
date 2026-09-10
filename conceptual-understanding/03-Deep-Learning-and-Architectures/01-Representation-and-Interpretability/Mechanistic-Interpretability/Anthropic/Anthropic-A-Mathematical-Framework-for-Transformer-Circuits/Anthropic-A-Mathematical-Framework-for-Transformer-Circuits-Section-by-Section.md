---
tags:
  - anthropic-research
  - mechanistic-interpretability
  - llm-lrm-mathematical-foundations
  - research-article
  - llm-attention-mechanism
  - dl-ml-mathematics
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

- Anthropic Paper: [Anthropic: A Mathematical Framework for Transformer Circuits](https://transformer-circuits.pub/2021/framework/index.html)
- [Thread: Circuits](https://distill.pub/2020/circuits/)
- [Zoom In: An Introduction to Circuits](https://distill.pub/2020/circuits/zoom-in/)
- [[Anthropic-In-Context-Learning-and-Induction-Heads]]
- [[Conceptual-Attention-Heads-MI]]
  
  
---
> [!info] **Paper Focus**
> - This paper focuses on ➝ `attention-only` transformers ➝  which don't have MLP layer
> - Authors admit ➝ that they had much less success in understanding MLP layers so far ➝  in normal transformers with both attention and MLP layers there are many circuits mediated primarily by attention heads which we can study, some of which seem very important ➝  but the MLP portions have been much harder to get traction on
> - Ignored layer normalization

---
### 1. Section: Transformer Overview 

> **The Mechanistic Interpretability Explanation**

> - The core thesis of this opening section is the distinction between 
> 	- **computational efficiency** 
> 	- **mechanistic interpretability**

> - When we build models in PyTorch or JAX 
> 	- we **group operations together** into ➝ **massive + dense matrix multiplications** 
> 	- because **GPUs** are **optimized** for **block computations**

> #llmops-hardware-gpu | #llmops-hardware-gpu-computations 

> - This creates a `black box` illusion where the model looks like a **monolithic block of weights**

> - To understand the `Why` + `How` of a model's behavior at the **activation level** ➝ we must mathematically dismantle this monolith
> - The paper establishes that there are **multiple + mathematically equivalent ways** ➝ to write the `equations` governing a Transformer

> - The overarching goal of this framework is to ➝ rewrite the **standard equations** into a **format** that exposes 
> 	- the underlying Directed Acyclic Graph ➝ `DAG`
> 	- the individual `causal pathways`

> - By reframing the math 
> 	- we **stop** seeing a **single layer of computation** 
> 	- & start seeing ➝ `distinct + isolated components` ➝ that **read** + **write** information **independently**

> - This philosophical shift is the absolute prerequisite for 
> 	- **identifying specific circuits** 
> 	- and understanding how **isolated features interact** ➝ within the high-dimensional activation space

#### I. Activation Level

> - When we talk about the **activation level** ➝ we aren't necessarily referring to an `activation layer` ➝ like a ReLU or GELU layer
> - Instead, we are referring to ➝ the **dynamic internal states** of the model ➝ as it **processes** a **specific input**

> To understand the `Why` & `How` ➝ we have to distinguish between 2 fundamental parts of the model

> #llm-activation-space-stream | #llm-activation-space-stream | #llm-residual-stream-additive-shared-communication-channel 
> [[Conceptual-Activation-Space-Level-The-Geometry-of-Machine-Thought]]

##### I. Weights: The Static Structure

> These are the fixed numbers stored in the model's matrices
> They represent the `knowledge` or `rules` the model learned during training
> They do not change based on what we type into the prompt

##### II. Activations: The Dynamic State

These are the numerical values ➝ tensors ➝ that are actually **produced** ➝ as a piece of data **moves through the model**
If we type `Paris` ➝ the activations in the hidden layers will look very different than if we type `Python`
    
> -  **`Activation level`** refers to the study of these dynamic signals
> - In Mechanistic Interpretability ➝ we aren't just looking at the `wiring` ➝ the weights 
> 	- we are looking at the `electrical signals` ➝ the activations 
> 	- flowing through that wiring ➝ to see which specific features are `on` or `off`

##### III. Seeing the Activation Vectors 

> - We can physically `see` the activation vectors 
> - Because these tensors are just high-dimensional arrays of numbers ➝  we can visualize them using two primary methods: **Heatmaps** (to see raw intensity) and **Dimensionality Reduction** (to see their geometric `shape`)
> - In a standard Transformer ➝  a single `activation` at any given point (like the residual stream) is a $1 \times d_{model}$ vector
> - If $d_{model}$ is 4,096 ➝  we have 4,096 floating-point numbers
> - While we can't `see` a 4,096-dimensional shape ➝  we can see its **footprint**

> [[Project-MI-Concepts-Activation-Vector]]

##### IV. The Raw View: Heatmaps

If we `hook` into a specific layer while the model is processing the word `Paris` ➝ we get a vector of, say, 4,096 numbers ➝  we can plot this as a **heatmap**

- **`Paris` Activations** 
	- You might see high `heat` (large numerical values) in dimensions 45, 102, and 3001. These specific dimensions might be part of the `Geography` or `European Cities` subspace.
    
- **`Python` Activations:** The heat shifts. Dimensions 45 and 102 go `cold,` and dimensions 88, 512, and 4000 spike. These are the `Programming Languages` or `Snakes` subspaces.
    

##### 2. The Geometric View: Projections (Manifolds)

Since we can't visualize 4,096 dimensions, we use techniques like **t-SNE** or **UMAP** to project these tensors into 3D space.

- When you do this for thousands of words, you see that the tensors for `Paris,` `London,` and `Berlin` all cluster together in one corner of the manifold.
    
- `Python,` `C++,` and `Java` cluster in a completely different neighborhood.
    
- The distance between these `points` (tensors) in the activation space is a physical representation of how the model perceives the relationship between concepts.
    

##### 3. How we do it (The Tooling)

In the industry, we use a library called **TransformerLens** (developed by Neel Nanda). It allows us to `stop` the model's execution at any node in the graph and pull the activations out into a NumPy array or a PyTorch tensor. We don't just guess what the model is thinking; we look at the raw electrical signals on the `conveyor belt` of the residual stream.



---

##### Here is how we physically visualize that vector:

###### 1. The Magnitude Footprint (Heatmaps)

We can take that vector and plot it as a 1D or 2D heatmap. Each `pixel` represents one dimension of the vector.

- **What you see:** Some dimensions will be bright (high positive value), some dark (high negative), and most will be grey (near zero).
    
- **The Insight:** If you process the word `Paris,` you might see a specific cluster of dimensions light up every single time. That is the physical `location` of the `Paris` concept within that vector.
    

###### 2. The Semantic Footprint (Cosine Similarity)

If you have the activation vector for `Paris` ($v_1$) and the activation vector for `Python` ($v_2$), you can calculate the angle between them.

- **What you see:** On a graph, $v_{Paris}$ and $v_{London}$ will point in almost the same direction. $v_{Paris}$ and $v_{Python}$ will be nearly perpendicular (90° apart).
    
- **The Insight:** This confirms that the model physically stores related concepts in related directions in the vector space.
    

###### 3. The `Un-rotated` View (SAE Features)

This is the most `physical` it gets in Mechanistic Interpretability. Because the raw dimensions of the residual stream are often **polysemantic** (meaning dimension #45 might handle both `French cities` and `programming syntax`), the raw vector looks like noise.

We use **Sparse Autoencoders (SAEs)** to `un-rotate` that vector. This transforms our 4,096-dimensional vector into a much larger, sparser vector (e.g., 32,000 dimensions) where **only 10 or 20 values are non-zero**.

- **What you see:** You see a list of labels like: `Feature 802: 0.85 (French Geography)`, `Feature 1024: 0.12 (Capital Cities)`.
    
- **The Physical Reality:** You are looking at the specific `switches` that are flipped `ON` inside the model's brain for that specific input.
    

---

**Summary:** We aren't looking at an abstract `thought`; we are looking at a specific point in a high-dimensional coordinate system.
#### II. Dismantling the Monolith

Usually, a model is seen as a `black box` because millions of numbers (activations) change at once. Dismantling it at the **activation level** means:

- **Isolating Features:** Instead of seeing a massive vector of 4,096 numbers, we use tools like Sparse Autoencoders to see that 5 specific numbers represent `French geography` and 2 represent `proper nouns.`
    
- **Tracking Flow:** We look at how a specific activation at Layer 1 (e.g., a `number` feature) causes a specific activation at Layer 5 (e.g., a `math` feature).
    

> In short: The **Layer** is the component; the **Activation** is the information actually living inside that component at a specific moment in time

#### III. Activations & Residual Layer 

The residual stream is a high-dimensional vector space, typically denoted as $\mathbb{R}^{d_{model}}$. Every token in your sequence has its own dedicated stream. Think of it not as a list of numbers, but as a physical space where specific directions represent specific concepts. When an embedding layer or an attention head `writes` to the stream, it is physically adding a vector to the existing one ($x_{new} = x_{old} + \text{contribution}$). Because the space is so large (e.g., 4,096 dimensions in many modern models), there are a vast number of nearly orthogonal directions available. This allows the model to store `The word is a noun,` `The context is mathematical,` and `The tone is formal` simultaneously in the same vector by pointing in different, non-interfering directions.

Components interact with this space through linear projections. An attention head `reads` the stream by multiplying the current state by its Query and Key matrices. This acts like a filter, specifically looking for vectors pointing in the directions it cares about. It doesn't `see` the whole stream; it only sees the subspace it is tuned to. After processing, it `writes` back by adding a new vector. This is why the stream is called a `communication channel`—it’s a shared whiteboard where Layer 1 can write a note that Layer 5 is specifically looking for, while Layers 2, 3, and 4 might ignore it entirely or add their own unrelated notes in other dimensions.

This leads to the concept of **subspaces**. In a well-trained model, the residual stream is partitioned. Some dimensions might be dedicated to tracking syntax, others to factual recall, and others to token position. If these subspaces were perfectly separate, the model would be easy to interpret. However, models often use **superposition**, where they squeeze more features into the stream than there are dimensions. They do this by using directions that are `almost` orthogonal. This is where the `monolith` becomes hard to dismantle: features begin to overlap slightly (interference), and we need tools like Sparse Autoencoders to mathematically `un-rotate` the stream and see the individual, hidden features clearly.

### II. Model Simplifications

**The MI-First Explanation**

To understand the fundamental mechanics of a system ➝ we must first study it in a vacuum ➝ stripped of all secondary variables
This section defines the `vacuum` for the rest of the paper ➝ the **Attention-Only Transformer**

The authors intentionally remove the MLP (Feed-Forward) layers. Why? Because Attention layers and MLP layers serve fundamentally different mechanical roles. Attention heads are the _routers_—they move information between different tokens across the sequence. MLPs are the _processors_—they operate on each token individually in isolation to retrieve or transform knowledge. By stripping out the MLPs, the researchers isolate the pure routing mechanics (the spatial topology of the graph) without getting bogged down by the complex, polysemantic transformations occurring inside the dense MLPs.

Furthermore, they drop biases and Layer Normalization. Mechanistically, biases just shift the vector space, and LayerNorm just scales it. While crucial for training stability and optimization, they are mathematically just linear adjustments that clutter the equations. By removing them, or folding them directly into the adjacent weight matrices, we are left with a pristine, linear pathway where we can perfectly trace how a vector from Token A is multiplied and written into the residual stream of Token B.

> [Notations: A Mathematical Framework for Transformer Circuits](https://transformer-circuits.pub/2021/framework/index.html#notation)

### III. High-Level Architecture

> **First Line:** `There are several variants of transformer language models. We focus on autoregressive, decoder-only transformer language models, such as GPT-3.`
> 
> **Last Line:** `The fundamental unit of transformers is the attention head (operating in parallel with other heads in a layer) and the MLP layer (if present).`

> - This section defines the `physics` of the environment
> - The authors frame the Transformer not as a sequence of layers, but as a **residual stream** that acts as a shared communication channel.

> - `Author's Note`
> - In transformers, the residual stream vectors are often called the “embedding.” We prefer the residual stream terminology, both because it emphasizes the residual nature (which we believe to be important) and also because we believe the residual stream often dedicates subspaces to tokens other than the present token, breaking the intuitions the embedding terminology suggests 

> Think of the residual stream as a high-dimensional conveyor belt ($d_{model}$) that runs through the entire model. Every component—the embedding, the attention heads, and the unembedding—interacts with this belt by `reading` from it and `writing` to it.

- **The Nodes (The Attention Heads):** Instead of one big layer, we have independent attention heads. Each head is a localized `worker` that looks at the conveyor belt, picks up specific information from a `Source` token, and writes a transformation of that info onto a `Destination` token further down the belt.
    
- **The Residual Stream as an Identity Map:** Because of the residual connections ($x_{i+1} = x_i + \text{layer}(x_i)$), the default behavior of the model is to do nothing. Information is preserved perfectly unless a head explicitly intervenes. This creates a **Direct Path** from the input embedding to the output logits.
    
- **Linear Additivity:** Because everything is added to the residual stream, the model's output is essentially a massive sum of the contributions of every single head. This is the `Aha!` moment for MI: if the model is a sum of parts, we can study the parts individually.
    

> This structural setup allows us to treat the Transformer as a graph where the nodes are the components and the edges are the additive writes to the residual stream



![[Pasted image 20260225215211.png | 600]]