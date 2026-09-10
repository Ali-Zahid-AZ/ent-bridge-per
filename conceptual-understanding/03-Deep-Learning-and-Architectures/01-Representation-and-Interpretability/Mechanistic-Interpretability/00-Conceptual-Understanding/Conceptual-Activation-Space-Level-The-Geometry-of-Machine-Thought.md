---
tags:
  - llm-activation-space-stream
  - llm-interpretability
  - mechanistic-interpretability
  - conceptual-explanations
  - reading-list
  - llm-manifolds-geometric-perspective
  - llm-activation-space-stream
---

---
```table-of-contents
```
---
### References

- [[Conceptual-Basics-LLMs-Mechanistic-Architecture]]
- [[Conceptual-Basics-Anatomy-of-Compute-Feature-Manifolds-Circuit-Topologies]]
- [[Conceptual-Manifold-Geometry-of-Large-Language-Models]]
- [[Conceptual-Truth-Concept-in-LLMs-Manifold-Perspective]]
- [[Conceptual-Linear-Probes-LLMs-Manifolds-Perspective]]
- [[Conceptual-Linear-Representation-in-LLMs]]
- [[Conceptual-Intertwined-Concepts-MI]]
- [[Conceptual-Truth-Concept-in-LLMs-Manifold-Perspective]]
- [[Conceptual-Superposition-MI-LLMs]]
---
- [How Contextual are Contextualized Word Representations? Comparing the Geometry of BERT, ELMo, and GPT-2 Embeddings](https://arxiv.org/abs/1909.00512)
- [LLM.int8(): 8-bit Matrix Multiplication for Transformers at Scale](https://arxiv.org/abs/2208.07339)
---
### Introductory

- Activation Space ➝  the **high-dimensional** stage ➝ where the drama of Large Language Model (LLM) cognition plays out
- It is **not** merely a **container for data** ➝  it is a **dynamic + evolving vector space** $\mathbb{R}^d$ (where $d \approx 4096$ to $12288$) ➝ that possesses **distinct geometric properties**
	- **anisotropy**
	- **outlier dimensions**
	- **manifold structures**

> [!example] **Focus**
> - **deconstructing the Activation Space from first principles** 
> - establishing it as the **fundamental Communication Channel** of the **Transformer** 
> - explore **how semantic meaning** ➝  is **physically encoded** ➝ as **coordinates** + **directions** + **trajectories** ➝ within this **hyperspace**

>[!critical] **Interpretability requires geometric constraints that bound the solution space**

---
### I. Introductory 

To understand the "activation level," we have to draw a hard line between the model's static anatomy and its dynamic physiology.

In Mechanistic Interpretability (MI), we divide the entire neural network into two fundamental states of being: **Weights** and **Activations**.

Here is the first-principles breakdown of what the activation level actually is.

## 1. Architecturally (The Plumbing and the Water)

If the weights (the parameters) are the physical pipes, valves, and switches of the model, the **activations** are the water flowing through them.

- **Weights are static.** Once training is done, the billions of parameters ($W$) sitting in your VRAM do not change during inference. They are frozen memory.
    
- **Activations are ephemeral.** They are the transient, high-dimensional vectors that only exist during the milliseconds of a forward pass.
    

Architecturally, the "activation level" refers to the exact state of the data at any intermediate point inside the network. The central highway for this flow is the **residual stream**. At each layer, attention heads and MLPs read from this stream, compute new activations, and add them back into the stream. When we look at the activation level, we are taking a snapshot of that highway at a specific milestone.

## 2. Mechanistically (The Mathematics of the Forward Pass)

Mechanistically, an activation is simply the numerical output of a mathematical operation—specifically, a matrix multiplication followed by a non-linear function.

If you have an input vector $x$ (from the residual stream) and a weight matrix $W$ (inside an MLP), the model computes:

$h = \text{GELU}(W x + b)$

The resulting vector $h$ is the activation. It is a dynamically instantiated list of numbers. When we say we are analyzing a model "mechanistically at the activation level," it means we are stopping the forward pass at a specific sub-layer, extracting that exact vector $h$, and interrogating its values before it gets mutated by the next layer's matrix.

## 3. From an MI Perspective (The Geometry of Concepts)

This is where the true interpretability work happens. In MI, we do not view an activation simply as a list of numbers; we view it as a **coordinate in a high-dimensional semantic manifold** (for instance, a point in $\mathbb{R}^{4096}$ space).

When we analyze the activation level in MI, we rely on three core frameworks:

- **Features as Directions:** We hypothesize that human-understandable concepts (like "is an API error," "is a plural noun," or "is a Python function") do not live in individual neurons. Instead, they are represented as specific linear directions across the entire activation space.
    
- **Superposition:** Because the model knows more concepts than it has dimensions, it packs multiple features into the exact same activation space by arranging them as almost-orthogonal vectors. The activation level is a dense, compressed superposition of overlapping ideas.
    
- **Linear Probing & Logit Lens:** Because the activation space is geometric, we can decode it. If we grab the activation vector at Layer 15, we can use a Logit Lens (multiplying it by the final unembedding matrix) to translate that intermediate coordinate back into human vocabulary, effectively reading the model's "subconscious thoughts" mid-generation.
    

## Summary

When we discuss memory routing—or any model behavior—at the "activation level," we are ignoring the black-box output text. Instead, we are looking at how the model's static weights mathematically rotate, stretch, and translate the ephemeral coordinate vector through the high-dimensional space of the residual stream until it points at the correct database tool.
### II. The Mind as a Coordinate System

#### Activation Space: Physical Defintion + Implications 

> [!quote] **Activation Space: Physical Definition + Implications**
> - **Activation Space** ➝ is the electrical field generated by millions of switches (analogy: neuron as the biological switch)
> 
> - **Physical Definition** 
> 	- It is the vector space of the **Residual Stream**
> 	- At any given **layer** $L$, for any given **token position** $t$ ➝ the **state** of the model  ➝ is a **single vector** ➝ $h_{L,t} \in \mathbb{R}^d$
> 
> - **The Implications** 
> 	- Every thought, fact, grammatical rule, or hallucination the model produces ➝ is simply a point (coordinate) in this space
> 	- **Thinking** is the movement of this point ➝ from the **input embedding layer** ➝ to the **output unembedding layer**

---
### II. Theoretical Foundation: First Principles

>[!example] **To understand this space ➝ must define the rules of the road**

#### Principle 1: The Additive Residual Stream

The Transformer does not **process** data in a traditional hierarchy ➝  it **refines a signal**

$$h_{L+1} = h_L + \text{Attention}(h_L) + \text{MLP}(h_L)$$
##### The Principle
- The Activation Space is a **Scratchpad** 
-  The Attention heads and MLPs ➝ **read** the current state $h_L$ ➝  **write** (add) updates to it 
##### Consequence 
- The geometry must support ➝ **Superposition** (adding features without destroying previous ones) + **Linearity** (additive updates)  

#### Principle 2: The Curse of Dimensionality (and the Blessing)

##### The Principle
- In high dimensions ➝ properties of space ➝ change (**dynamic space properties**)
- The volume of a sphere concentrates ➝ entirely on its shell ➝ **center is empty**
##### Consequence 
- Almost **all activation vectors** ➝ live on the **surface** of a **hypersphere**
-  The **angle between vectors** (Cosine Similarity) becomes the **primary metric** of **meaning** ➝  rather than **Euclidean distance**

### III. The Geometry: Anisotropy & The Cone Effect

Ideally, Activation Space would be **Isotropic** (uniform in all directions, like a sphere)
In reality, it is highly **Anisotropic**

#### 1. The Representation Degeneration Problem (The Cone)

##### The Phenomenon   

- One might expect random vectors to be orthogonal (90 degrees apart) 
- However, empirical studies show that deep in the network, almost _all_ activation vectors point in roughly the same direction
- They occupy a narrow **Cone**
##### The Cause

- **LayerNorm:** The normalization layers push vectors away from the origin
- **Frequency Bias:** Common words (like the, a) dominate the optimization, pulling the average direction toward them
##### The Implication

- **Implication:** To find meaning ➝ we often have to **subtract the mean** (remove the cones axis) ➝ to see the subtle differences between **King** and **Queen**    

> **Citation**: Ethayarajh, K. (2019). **How Contextual are Contextualized Word Representations?** ➝ *Identified the Anisotropy Cone*
> [How Contextual are Contextualized Word Representations? Comparing the Geometry of BERT, ELMo, and GPT-2 Embeddings](https://arxiv.org/abs/1909.00512)

#### 2. Rogue Dimensions: The Outliers

##### The Phenomenon:
- In models like GPT-3 and Llama-2 ➝ **specific dimensions** (e.g. Dimension #452 out of 4096) ➝ have **consistently** massive values ➝ e.g. 100x larger than average
##### The Function 
- These are often **punctuation** or **separator** features
- They act as **anchors** for the **attention mechanism** to rest on ➝ when it doesnt know where else to look
    
>**Citation**: Dettmers, T., et al. (2022). **LLM.int8(): 8-bit Matrix Multiplication for Transformers at Scale** ➝ *Discovered that outlier features are crucial for model stability*
>[LLM.int8(): 8-bit Matrix Multiplication for Transformers at Scale](https://arxiv.org/abs/2208.07339)

### IV. The Topology: The Manifold of Meaning

> The Activation Space is **huge** ➝ but the **model** only **uses** a **sliver** of it

#### 1. The Manifold Hypothesis

##### The Concept
-  Valid English sentences form a low-dimensional **Manifold** (a curved sheet) ➝ embedded in the high-dimensional space
 - **On-Manifold**  ➝ The sky is blue ➝  Valid point
 - **Off-Manifold** ➝ Blue is sky the ➝ Invalid point, random noise
##### Adversarial Examples
- If you push a point slightly _off_ the manifold (add specific noise vectors) ➝ the model breaks 
	- It might classify a panda as a gibbon or spew nonsense
	- The **thickness** of the manifold ➝ represents the models robustness

#### 2. Linear Separability (The Planes)

##### The Concept
- The manifold is folded such that concepts (True/False, Male/Female) ➝ can be separated by flat hyperplanes
##### The visual
- Imagine a crumpled sheet of paper (the data). 
    - The models job is to uncrumple it layer by layer until the sheet is flat ➝ enabling us to draw a straight line to cut Positive Sentiment from Negative Sentiment
    - [[Conceptual-Manifold-The-Crumpled-Data-Perspective]]
    - [[Conceptual-Manifold-Data-Journey-in-LLM]]

### V. Dynamics: The Trajectory of Thought

> **How does a vector move through this space?**

#### 1. The Spiral of Refinement

- **Layer 0 (Embedding)**  ➝ The vector is purely lexical
	- When it means **Bank**  ➝ it could be river or money
- **Layers 1-10 (Contextualization)**  ➝ Attention heads read the neighbors (River)
	- They add a vector $v_{river}$ to the state
	- The vector shifts physically toward the **Nature** subspace
- **Layers 11-20 (Abstraction)** ➝ the model adds **abstract concepts** ➝ like **Geography** or **Peaceful**
- **Last Layer (Unembedding)** ➝ the vector is **rotated** to **align with the output vocabulary matrix** ➝ to predict the next token

#### 2. Transient vs. Durable Features

- **Durable**  ➝ some directions ➝ like **This is a French sentence** ➝ persist for the entire generation
- **Transient**  ➝ some directions ➝ like **The current subject is He** ➝ appear for one token to handle grammar ➝ then vanish    

### VI. Visualization: The Hyper-Cube and The Slice

To visualize 4096 dimensions ➝ we use **Projections**  ➝ **PCA/t-SNE**
	➝ See [[01-Projects/LLMs/Project-Aletheia-Geometry-of-Truth/Project-Aletheia-Geometry-of-Truth-Implementation]] for implementation details 

#### The Cloud of Meaning: PCA Slice

> Example: If we take a slice of the activation space for the word Apple

```toml
       (Technology Axis)
             ^
             |    [Apple (iPhone)]
             |        o
             |       /
             |      /  (Context Shift)
             |     /
[Apple (Fruit)] --o--------------------> (Food Axis)
             |
             |
```

- The vector `h` ➝ **starts** at Apple (Fruit)
- The **context**  ➝ **Tim Cook announced..**. ➝ **adds a vector**
- The **new** `h` ➝ moves to Apple (iPhone)
- The **word is the same** ➝ but its **location** in **Activation Space** ➝ has **changed completely**

### VII. Summary Table: The Physics of Activation Space

| **Property**        | **Definition**                        | **The Human Analogy**                                              |
| ------------------- | ------------------------------------- | ------------------------------------------------------------------ |
| **Dimension ($d$)** | The width of the vector (e.g., 4096). | The number of simultaneous details you can hold in working memory. |
| **Anisotropy**      | Vectors clustering in a cone.         | Everyone facing the stage at a concert (shared orientation).       |
| **Outliers**        | Dimensions with massive values.       | The Loudest Guy in the Room (dominates attention).                 |
| **Manifold**        | The valid region of the space.        | The paved roads on a map (dont drive off-road).                    |
| **Trajectory**      | The path from Layer 0 to Layer $N$.   | The evolution of an idea from hunch to sentence.                   |

### VIII. Conceptual Image: Gemini

![[Pasted image 20260213000007.png | 600]]

