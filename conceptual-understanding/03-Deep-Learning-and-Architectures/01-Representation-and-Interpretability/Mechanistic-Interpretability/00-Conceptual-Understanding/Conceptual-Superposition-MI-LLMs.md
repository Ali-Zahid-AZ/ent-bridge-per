---
tags:
  - reading-list
  - mechanistic-interpretability
  - mechanistic-interpretability-theories
  - mechanistic-interpretability-superposition
  - conceptual-explanations
  - llm-internal-memory
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

> Superposition ➝  **The Efficient Compression of Meaning in Large Language Models**

> - Because the model only has 4096 dimensions ➝ but needs to **memorize** millions of features ➝  **perfect orthogonality** is `impossible` 
> - The model is **mathematically forced** to
> 	- **pack** features together 
> 	- **squeezing** the `angles` between them 
> - The angles are no longer at 90$^∘$ ➝ they might be pushed together to an angle of 85$^∘$ 
> - This `dense` + `non-orthogonal` packing is the state of **Superposition**

- [[Conceptual-PolySemanticity-MonoSemanticity-MI]]
- [[Conceptual-Hallucinations-and-Management]]
- [[Conceptual-Basics-LLMs-Mechanistic-Architecture]]
---
### 1. The Core Paradigm: Features vs. Dimensions

To understand a neural network mechanistically ➝ we must separate the architecture ➝ **neurons** and **weights** ➝ from the information it processes ➝ **features**

#### I. Features

- Features are the fundamental units of knowledge
- A feature is an **arbitrary, semantic concept** ➝ the model has l**earned to represent** 
	- example ➝ `the concept of plurality,` `the syntax of a Python function,` or `the tone of sarcasm`

#### II. Dimensions ➝  Neurons 

- **Dimensions** ➝ **Neurons** ➝  are the physical hardware
- These are the actual **floating-point numbers** ➝ in the model's **hidden states**  
	- example ➝  $D = 4096$ in a typical hidden layer

#### III. The Inherent Problem: Superposition

- **The Problem** 
	- The universe of features $N$ ➝ a model needs to understand to predict ➝ the next token accurately is vastly larger than the number of dimensions $D$ it possesses 
	- The model is ➝ **forced to operate** in a regime ➝ where $N \gg D$
    
- If the model strictly assigned one feature to one neuron ➝ a purely orthogonal, monosemantic mapping ➝ it would quickly run out of capacity
- To survive ➝ the model **learns** ➝ to **compress information**
- This compression mechanism is **Superposition**

#### IV. Gradient Descent: Model's Compression Learning

> [[Anthropic-Toy-Models-of-Superposition-Main]]
> [[Anthropic-Toy-Models-of-Superposition-Section-by-Section]]
> [[Conceptual-Gradient-Descent-The-Geometric-Perspective]]

> - Gradient descent ➝ learns to **compress information** ➝ because it is **constantly negotiating** a brutal economic trade-off within the **loss function**
> - To understand how the model learns this at the weight and activation level ➝ we have to look at the two competing mathematical forces acting on the feature vectors during training

#### V. The 2 Competing Forces of Gradient Descent

> During training ➝ the model's objective is to **minimize its loss** 
> To do this ➝ the **gradients** acting on the **weight matrix**  ➝ $W$ ➝  are pulled in 2 completely opposite directions

##### I. The Benefit of Representation: The Pull to Overlap

- Every time the model successfully detects a feature in the training data, its loss decreases. If the model has 1,000 important features but only 100 dimensions, gradient descent quickly figures out that discarding 900 features results in a terribly high loss. To capture the loss-reducing benefits of those remaining 900 features, the gradients start writing them into the weight matrix, forcing them to share the same dimensional space.

**2. The Penalty of Interference (The Push to Repel)**

When two features are forced to share space, their vectors are no longer orthogonal (at $90^\circ$ to each other). If the input data contains `both` features at the exact same time, their vectors activate simultaneously. Because they aren't orthogonal, their dot product is non-zero, creating interference noise. If this noise bypasses the ReLU, the model outputs garbage, and the loss function heavily penalizes the network. Therefore, interference acts as a **repulsive force**. During backpropagation, the gradients actively push the feature vectors away from each other to make the angles between them as wide as possible.

### The Catalyst: Sparsity

So, how does the model resolve this conflict? It looks at the **sparsity** of the data.

- **If the data is dense (features appear constantly):** The features will constantly collide in the same forward pass. The interference penalty is so massive that it outweighs the benefit of having the feature at all. Gradient descent `learns` that compression isn't worth it. It forces the vectors to be perfectly orthogonal (monosemantic) and simply deletes the less important features to save itself from the interference penalty.
    
- **If the data is sparse (features rarely appear):** The model realizes that Feature A and Feature B almost never show up in the same forward pass. Gradient descent calculates a new math: ``I will take a tiny penalty on the rare 1-in-10,000 chance they collide, because the massive reward of representing both features 9,999 times out of 10,000 is worth it.``
    

### The Weight-Level Reality: Geometric Settling

As the model trains step-by-step, you can actually watch this compression happen in the weight matrix.

The feature vectors are initialized randomly. As training progresses, the `repulsive force` of interference pushes the vectors around the hypersphere of the activation space. They slide and adjust, trying to maximize the distance between themselves to minimize crosstalk.

Eventually, they settle into a state of perfect tension—mathematically beautiful, highly symmetrical geometric structures called **uniform polytopes**.

For example, if the model needs to compress 3 sparse features into 2 dimensions, the vectors will physically push each other during training until they form a perfect $120^\circ$ Mercedes-Benz star (a triangle). If it needs to compress 5 features into 3 dimensions, they will push each other until they form a pentagram.

The model `learns` to compress information by physically arranging its weight vectors into these symmetrical shapes to squeeze out the maximum amount of utility with the minimum amount of geometric friction.

> 

> #mechanistic-interpretability-superposition | #mechanistic-interpretability-superposition | #mechanistic-interpretability-features | #mechanistic-interpretability-features | #llm-higher-dimension-space | #llm-compression-strategy | #llm-sparsity | #gradient-descent 

---
### 2. The Geometry of Superposition: Almost-Orthogonal Vectors

Superposition relies entirely on the counterintuitive geometry of high-dimensional spaces.

- In a low-dimensional space (like 3D), you can only have exactly 3 perfectly orthogonal (90-degree) vectors.
    
- However, in high-dimensional activation spaces (e.g., a 4096-dimensional manifold), the volume of the space is so vast that you can pack `millions` of vectors that are **almost orthogonal** (e.g., 89 degrees apart) to one another.
    
- Instead of aligning a feature with a single neuron (the basis vector), the model embeds a feature as a specific `direction` across the entire activation space. A single feature is a linear combination of many neurons, and a single neuron participates in the representation of many features. This is the root cause of **polysemanticity** (neurons that fire for seemingly unrelated concepts).
    

## 3. Mechanistic `How`: Reading and Writing in Superposition

How does the model successfully encode and decode these overlapping features without them scrambling each other? It comes down to weights, sparsity, and non-linearities.

**The Weight Level (Interference):**

- When a model writes a feature into the residual stream, it projects it along its designated high-dimensional direction.
    
- Because the features are only `almost` orthogonal, their dot products are not exactly zero. Reading one feature inevitably picks up a tiny bit of mathematical noise from the other overlapping features. This noise is called **interference**.
    
- The model calculates a brutal economic trade-off: is the benefit of representing feature $X$ worth the cost of the interference it causes to feature $Y$?
    

**The Activation Level (The Role of ReLU/GELU):**

- Superposition would fail if neural networks were entirely linear. The interference would accumulate and destroy the signal.
    
- This is where non-linear activation functions (like ReLU or GELU) act as essential mechanistic filters.
    
- When the model wants to `read` a target feature, the projection yields a large positive scalar. The interference from other features yields small positive or negative scalars.
    
- The non-linearity acts as a threshold. A ReLU function ($\max(0, x)$) wipes out the negative interference entirely and dampens the noise, allowing the model to isolate the dominant feature from the superposition soup.
    

**The Sparsity Requirement:**

- Superposition only works if the features being packed together are **sparse**—meaning they rarely occur at the exact same time in the same context.
    
- If a model tries to pack `the concept of a dog` and `the concept of a cat` into the same almost-orthogonal subspace, and the text is about a pet store, both features activate simultaneously, causing catastrophic interference. Therefore, the model learns to superpose features that are anti-correlated or mutually exclusive (e.g., `Python syntax` and `18th-century French poetry`).
    

## 4. Resolving Superposition: Sparse Autoencoders (SAEs)

If features are represented as arbitrary directions in a compressed manifold, how do we, as researchers, find them? We cannot simply look at individual neurons. We need a coordinate transformation.

- **The SAE Architecture:** A Sparse Autoencoder is an unsupervised neural network trained specifically on the activations of the target LLM.
    
- It takes the dense, superposed activation state (size $D$) and maps it to a much larger, overcomplete hidden layer (size $N$, where $N \gg D$).
    
- **The Sparsity Penalty:** The SAE is trained with an L1 regularization penalty, forcing it to reconstruct the original activation using the absolute minimum number of active nodes in its larger layer.
    
- **The Result:** By forcing the representation into a high-dimensional but extremely sparse space, the SAE `untangles` the manifold. The nodes in the SAE's hidden layer align with the true, monosemantic feature directions of the LLM. We have successfully reverse-engineered the superposition.
    

## 5. Key Citations and Literature for Reference

To ground this note in the foundational literature, here are the critical papers that define this framework:

1. **`Toy Models of Superposition` (Elhage et al., 2022, Anthropic):** The foundational paper that formally defined superposition, demonstrated it in small models, and proved the relationship between feature sparsity, interference, and the geometry of activation spaces.
    
2. **`Towards Monosemanticity: Extracting Interpretable Features from Claude` (Bricken et al., 2023, Anthropic):** The breakthrough paper proving that SAEs can be scaled to untangle superposition in large, production-grade LLMs, successfully finding monosemantic features.
    
3. **`A Mathematical Framework for Transformer Circuits` (Elhage et al., 2021, Anthropic):** While focused on induction heads and the residual stream, this establishes the foundational perspective of treating the residual stream as a communication channel where features are written and read in superposition.

---
![[Pasted image 20260212235900.png | 500]]