---
tags:
  - mechanistic-interpretability
  - llm-polysemanticity
  - mechanistic-interpretability-polysemnaticity
  - llm-monosemanicity
  - mechanistic-interpretability-monosemanicity
  - mechanistic-interpretability-features
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
    
---

### **1. The Geometric Definitions**

- **Monosemanticity:** A mathematical state where a single computational unit (such as a specific neuron or a specific vector direction) aligns strictly with one distinct, human-interpretable concept from the training distribution. When the model processes that concept, and only that concept, the unit's activation value is non-zero.
    
- **Polysemanticity:** A state where a single computational unit activates for multiple, completely unrelated statistical features. A single neuron's activation value might spike when processing Python syntax, the concept of a dog, and Arabic script.
    

### **2. The Mathematical Origin: The Superposition Hypothesis**

Polysemanticity is not a flaw in the training process; it is a mathematical necessity driven by the structural limitations of the network.

- **The Dimensional Bottleneck:** A transformer model has a fixed residual stream dimension, denoted as $d$ (e.g., $d=4096$). However, the training dataset contains a number of fundamental features, denoted as $N$. In any real-world dataset, $N \gg d$.
    
- **Orthogonal Limitations:** If the model assigned one feature to one orthogonal basis vector (a standard monosemantic alignment), it would reach its maximum capacity at exactly $d$ features. The loss function would remain extremely high because the model would be incapable of representing the remaining $N - d$ concepts.
    
- **Almost-Orthogonal Packing:** To minimize the cross-entropy loss, the network learns to represent features as almost-orthogonal vectors. In high-dimensional spaces, a massive number of vectors can exist with dot products slightly greater than zero.
    
- **The Resulting Polysemanticity:** By utilizing almost-orthogonal vectors, the model compresses $N$ features into $d$ dimensions. Because the physical neurons (the standard basis vectors of the matrix) do not perfectly align with these almost-orthogonal feature vectors, any single physical neuron will project onto multiple different feature vectors. When you observe a single neuron, you are observing the projection of multiple superimposed concepts.
    

### **3. The Functional Mechanics in the Network**

When processing data through the Multilayer Perceptron (MLP) layers, the model must retrieve specific features from this superimposed state.

- **Activation Triggers:** As a token's vector $x$ is multiplied by the up-projection matrix $W_{in}$, the dot product operation triggers multiple hidden-layer neurons. Because of superposition, these neurons are highly polysemantic.
    
- **Interference Patterns:** The model does not rely on a single neuron to execute a logic step. Instead, it relies on a specific linear combination of hundreds of polysemantic neurons firing simultaneously.
    
- **Down-Projection Resolution:** As these activated neurons multiply against the down-projection matrix $W_{out}$, their output vectors sum together. The model's weights are specifically optimized so that the vectors for the intended feature constructively interfere (amplifying the correct concept), while the vectors for the unrelated concepts destructively interfere (canceling the noise down to zero).
    

### **4. Forcing Monosemanticity via Sparse Autoencoders (SAEs)**

To perform Mechanistic Interpretability, researchers must extract the true monosemantic feature basis from the polysemantic neural activations. This is executed using Sparse Autoencoders (SAEs).

- **The Up-Projection:** An activation vector $x \in \mathbb{R}^d$ is extracted from the target LLM and passed through the SAE's encoder matrix $W_{enc}$ into a significantly higher-dimensional latent space $\mathbb{R}^M$ (where $M \gg d$).
    
    $$f(x) = \text{ReLU}(W_{enc}x + b_{enc})$$
    
- **The Sparsity Constraint:** To force the SAE to separate the superimposed features, a mathematical constraint is applied to ensure the vast majority of the values in $f(x)$ are exactly zero. Historically, this is achieved by adding an $L_1$ regularization penalty to the loss function:
    
    $$\mathcal{L} = \|x - \hat{x}\|_2^2 + \lambda \|f(x)\|_1$$
    
    _(Note: Recent 2024 and 2025 methodologies often replace the $L_1$ penalty with a Top-K activation function, which strictly enforces sparsity by zeroing out all but the $K$ highest values before calculating the reconstruction loss)._
    
- **The Decoding:** The sparse vector $f(x)$ is multiplied by the SAE's decoder matrix $W_{dec}$ to output a reconstructed vector $\hat{x}$.
    
- **The Monosemantic Basis:** Once the SAE is trained to minimize the reconstruction error, the column vectors of $W_{dec}$ represent the isolated, monosemantic feature directions. The dense, uninterpretable space of $\mathbb{R}^d$ has been successfully mapped to a sparse space $\mathbb{R}^M$ where each dimension corresponds to a single variable.
    

### **5. Causal Interventions and Frontier Scaling**

The extraction of monosemantic features allows for precise, causal control over model outputs without fine-tuning.

- **Feature Clamping:** By identifying the specific monosemantic vector in the SAE's decoder corresponding to a concept, researchers can inject that vector directly into the model's residual stream during the forward pass.
    
- **Proven Steering:** Multiplying a monosemantic vector by a high scalar forces the model's output to rigidly adopt that concept. If the vector for "base64 encoding" is clamped to a high positive value, the model will output subsequent tokens in base64 format, proving the causal validity of the extracted feature.
    
- **Frontier Validation:** Recent literature (such as Anthropic's work on Claude 3 Sonnet) has demonstrated that this monosemantic extraction scales to state-of-the-art models, revealing highly abstract, monosemantic features for concepts ranging from code vulnerabilities to precise geographic locations.


Here are the foundational citations that establish the frameworks of Polysemanticity, Superposition, and Monosemantic feature extraction via Sparse Autoencoders. I have structured them chronologically to show how the field progressed from theoretical math to frontier-scale application.


citations
### **1. The Foundation of Superposition**

- **Title:** _Toy Models of Superposition_
    
- **Authors:** Nelson Elhage, Tristan Hume, Catherine Olsson, et al. (Anthropic)
    
- **Date:** September 2022
    
- **Significance:** This is the bedrock paper for understanding _why_ polysemanticity exists. It mathematically proves that neural networks use almost-orthogonal vectors to compress more features than they have dimensions, establishing the "Superposition Hypothesis" as a feature of the loss landscape, not a bug.
    

### **2. The Introduction of Dictionary Learning (SAEs)**

- **Title:** _Towards Monosemanticity: Decomposing Language Models With Dictionary Learning_
    
- **Authors:** Trenton Bricken, Adly Templeton, Joshua Batson, et al. (Anthropic)
    
- **Date:** October 2023
    
- **Significance:** This paper introduced the use of Sparse Autoencoders (SAEs) to the interpretability field. It proved that by training an SAE with an $L_1$ sparsity penalty on a one-layer transformer's activations, researchers could successfully extract highly interpretable, monosemantic features (like DNA sequences or base64 text) that were completely invisible when looking at individual neurons.
    

### **3. Scaling to Frontier Models & Causal Steering**

- **Title:** _Scaling Monosemanticity: Extracting Interpretable Features from Claude 3 Sonnet_
    
- **Authors:** Adly Templeton, Tom Conerly, Jonathan Marcus, et al. (Anthropic)
    
- **Date:** May 2024
    
- **Significance:** This paper proved that the SAE methodology scales to massive, state-of-the-art production models. They successfully extracted millions of features from Claude 3 Sonnet (including abstract concepts like sycophancy, security vulnerabilities, and famous tourist attractions). Crucially, it demonstrated **feature steering**—proving that clamping these monosemantic vectors causally alters the model's output.
    

### **4. The Math Update: Top-K Sparsity**

- **Title:** _Scaling and Evaluating Sparse Autoencoders_
    
- **Authors:** Leo Gao, Collin Burns, John Schulman, et al. (OpenAI)
    
- **Date:** June 2024
    
- **Significance:** If you are taking notes on the exact mathematical implementation of modern SAEs, this paper is vital. It proposed replacing the traditional $L_1$ regularization penalty with a **Top-K activation function**. This strictly forces the SAE to only keep the $K$ highest magnitude latents during the forward pass, effectively solving the "shrinkage" problem caused by the $L_1$ penalty and making it much easier to train SAEs at scale.