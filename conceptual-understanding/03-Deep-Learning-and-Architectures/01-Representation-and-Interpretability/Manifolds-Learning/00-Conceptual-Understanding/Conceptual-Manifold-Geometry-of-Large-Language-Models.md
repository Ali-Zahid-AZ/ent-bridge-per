---
tags:
  - llm-manifolds-geometric-perspective
  - large-language-models-LLMs
  - llm-internal-memory
  - llm-neural-signatures
  - llm-manifolds-geometric-perspective
  - llm-interpretability
  - llm-reasoning-traces
  - reading-list
  - detailed_explanations
  - llmops-semantic-similarity
  - llm-semantic-meaning
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
### 1. LLMs: Differential Geometry + Manifold Learning 

> [!quote] **LLMs: Through the lens of Differential Geometry + Manifold Learning**
> 
>- This framework posits that Large Language Models (LLMs) do not process information in a flat Euclidean space
>- Instead, they learn a high-dimensional embedding that collapses onto a low-dimensional, smooth Riemannian manifold $\mathcal{M}$
>- the model’s forward pass is equivalent to a discrete flow along geodesics on this manifold, where semantic consistency is maintained via parallel transport

|**Concept**|**Differential Geometry Equivalent**|**LLM Implementation**|
|---|---|---|
|**Representations**|Points on Manifold $x \in \mathcal{M}$|Hidden States / Residual Stream|
|**Semantic Logic**|Geodesics|Logit Lens / Vector Analogies|
|**Layer Update**|Tangent Vector $\Delta x \in T_x\mathcal{M}$|Residual Branch (Attn + MLP)|
|**Attention**|Parallel Transport / Connection|Query-Key Interaction|
|**Position**|Fiber Bundle / Rotation Group|RoPE / Positional Encodings|
|**Features**|Overcomplete Basis / Tight Frame|Neurons in Superposition (SAE)|

---
### 2. The Manifold Hypothesis for LLMs

> [!quote] **The Manifold Hypothesis**
> The **Manifold Hypothesis** states that high-dimensional data (like token embeddings in $\mathbb{R}^{d_{\text{model}}}$) concentrated near a low-dimensional manifold $\mathcal{M}$ with intrinsic dimension $k \ll d_{\text{model}}$
> 
> - **Dimensionality Collapse**
> 	- While $d_{\text{model}}$ may be 4096 (Llama-3-8B) ➝  empirical research using Maximum Likelihood Estimation (MLE) ➝ suggests the intrinsic dimension of semantics often ranges between 50 and 200
> - **The Metric Tensor ($g$)** 
> 	- The manifold is equipped with a **Riemannian metric $g$** ➝ which defines the local geometry 
> 	- It determines the **distance** between concepts
> - **Citation:** **Aghajanyan et al. (2020)**: demonstrated that the Intrinsic Dimensionality of LLMs is significantly lower ➝ than their parameter count ➝ explaining why low-rank adaptation (LoRA) is so effective
>---
>- The manifold hypothesis was formally proposed in the early 2000s 
>	- alongside the development of manifold learning algorithms ➝ **Isomap** + **Locally Linear Embedding (LLE)**
>- It has since become a core theoretical justification ➝ for the success of **high-dimensional deep learning models**
>---
>- [Effective Theory Building and Manifold Learning](https://arxiv.org/html/2411.15975v1)
>- Cayton, L. (2005)-**Algorithms for manifold learning**-Technical Report CS2005-0839, University of California, San Diego
>- [📂 Open: Manifolds-Learning](<file:///home/az/04-Library/03-Deep-Learning-and-Architectures/01-Representation-and-Interpretability/Manifolds-Learning>)
>- [Algorithms-for-manifold-learning-Cayton-2005.pdf](<file:///home/az/04-Library/03-Deep-Learning-and-Architectures/01-Representation-and-Interpretability/Manifolds-Learning/Algorithms-for-manifold-learning-Cayton-2005.pdf>)

---
### 3. The Residual Stream as Geodesic Flow

[[Conceptual-Residual-Stream-Geometric-Manifold]]
[[Conceptual-Residual-Stream-Geometric-Mechanistic]]

> [!example] **Residual Stream**
>- The residual stream is the high-dimensional vector space 
> 	- that acts as the primary information highway ➝  connecting a transformer's input to its output layers
>- Each attention and MLP block ➝ performs a discrete update by adding a new vector to this stream
>	- allowing the model to refine representations ➝ without losing previous context

>[!success] **In a Transformer** ➝ the **residual stream** is the **primary axis** of **computation**

#### 1. Discrete Flow Dynamics

The update rule $\mathbf{x}_{l+1} = \mathbf{x}_l + f_l(\mathbf{x}_l)$ is a discretization of an Ordinary Differential Equation (ODE):

$$\frac{d\mathbf{x}}{dt} = \text{Attention}(\mathbf{x}) + \text{MLP}(\mathbf{x})$$

Each layer provides a **nudge** $\Delta \mathbf{x}$ that resides in the **Tangent Space** $T_{\mathbf{x}}\mathcal{M}$

#### 2. Geodesics and Semantic Logic

> A **geodesic** is the **shortest path** between **two semantic points** on **$\mathcal{M}$**
- **Analogy:** If **King** and **Man** are points ➝  the **geodesic path** between them ➝ defines the **gender** transformation
- **Citation**: **Park et al. (2024)**: **The Linear Representation Hypothesis** argues that ➝  LLMs represent concepts as linear directions within this manifold space ➝  effectively **linearizing** the geodesics ➝ for **easier computation**
	- [[The-Linear-Representation-Hypothesis-Geometry-of-LLMs-Park]]

##### I. Semantic Points & Semantic Similarity: Overview

> [!example] **Semantic Points + Semantic Similarity + Geometry of Similarity + Geodesics**
>- Semantic points are specific vector coordinates on the manifold $\mathcal{M}$ 
> 	- represent discrete concepts or tokens ➝ within the **latent space**
> - They act as the landmarks of meaning ➝ that define the start and end points for **geodesic paths** across the model's learned curvature
>---
> In a standard vector space ➝  a point is just a list of 4,096 numbers
> But on the **manifold $\mathcal{M}$** ➝  those numbers represent a specific state of meaning
> 
> 1. **The Point as a Semantic Coordinate**
> 	- Consider the manifold ➝ as a **map** of the **entire human experience** ➝ that the **model has seen**
> 	- A **semantic point** ➝ is a **specific latitude** and **longitude** on that map
> 	- A point doesn't just represent a word like Apple
> 		- It represents Apple ➝ **in the context** ➝ **of a fruit being eaten in a park on a sunny day**
> 	- As the transformer processes text ➝  the token's representation moves from a generic starting point (the embedding) ➝ to a highly specific **semantic point** at the end of the residual stream
>
>-- 
>[[Conceptual-Manifold-Conceptualization-in-DeepLearning]]
>[[Conceptual-Foundational-Manifold-Data-and-Models]]
>--
>
> 1. **The Geometry of Similarity**
> 	- Related concepts are nearby
> 	- In a flat space ➝  **nearby means a straight line** ➝  but on the manifold ➝  **nearby is defined by the metric tensor $g$**
> 	- If the manifold is crumpled ➝  two points might look close together in the 4,096-dimensional warehouse ➝  but they are actually far apart on the surface of the paper
> 		- [[Conceptual-Manifold-The-Crumpled-Data-Perspective]]
> 	- The model's job is to navigate the **surface**, not the empty space. 
> 	- Semantic similarity is the gravity ➝ that keeps these **points clustered** in **meaningful neighborhoods**
> 
>--   
>
> 2. **Geodesics: The Logic of Motion**
> 	- If a semantic point is a **destination**, a geodesic is the **logical argument** that gets we there.
> 		- When we prompt an LLM to Change the tone of this text to be more formal, the model is calculating a geodesic path.
> 		- It starts at the semantic point for Informal Text and follows the shortest path along the manifold's curvature toward the point for Formal Text.
> 		- The landmarks are the stable concepts (like Truth, Gender, or Tense) that the model uses to orient itself.
>
>-- 
>
>3. **The Manifold as the Space of the Possible**
> 	- The manifold $\mathcal{M}$ represents the boundary of **valid meaning**.
> 		- Any point _off_ the manifold is essentially gibberish or hallucination—it represents a combination of numbers that doesn't correspond to any humanly understandable concept
> 		- This is why the **Project Aletheia** is so vital: we are trying to find the specific Truth landmark on that surface. If the model drifts off the manifold, it loses the Truth vector because the geometry itself has broken down.

##### II. Semantic Points & Semantic Similarity: Emergent Property

> [!quote] **Semantic Similarity is an ➝  emergent property of the manifold's geometry**
> At the architectural level, the model doesn't decide similarity in the way a human makes a conscious choice
> Instead, semantic similarity is an **emergent property of the manifold's geometry** ➝  dictated by how the model has been forced to compress information during training
> 
> Here is the step-by-step breakdown of how that decision is encoded into the math
> 
> 4. **The Dot Product as a Proximity Sensor**
>	- In the most basic sense, the model uses the **dot product** (or cosine similarity) between two vectors to measure how much they align.
>		- If two vectors point in the same direction in the high-dimensional space, their dot product is high, and the model treats them as semantically similar.
>     - **The Geometric Trick:** During training, the model is penalized if it doesn't predict the correct next token. To minimize this penalty, it learns to place related concepts (like Doctor and Hospital) in the same neighborhood so that the math flows toward the same logical conclusions.
>
>--     
>
>4. **Metric Warping: The Metric Tensor ($g$)**
> 	- This is where the **Conceptual-Manifold** theory becomes critical
> 	- In a raw vector space, Apple (the fruit) and Apple (the tech company) might be close because they share the same word-embedding.
>	- However, as the signal moves through the layers, the **Metric Tensor ($g$)** warps the space based on context:
> 		- **Contextual Squeezing:** If the surrounding words are iPhone and Tim Cook, the metric tensor squeezes the manifold so that the Apple vector is pulled away from the fruit neighborhood and into the technology neighborhood.
> 		- **Local Curvature:** Similarity is local. On the manifold, two points are similar if the **geodesic distance** between them is short. The model decides similarity by essentially calculating: _How much energy does it take to transform representation A into representation B along the surface of what I know?_
>
>-- 
>
>5. **Feature Superposition and Interference****
>	- As we noted in the project ➝  models use **superposition** to store more concepts than they have dimension ➝ [[01-Projects/LLMs/Project-Aletheia-Geometry-of-Truth/Project-Aletheia-Geometry-of-Truth-Implementation]]
> 		- The model decides similarity based on **shared features**
> 			- If Truth and Honesty both activate the same sparse set of internal neurons (the atoms of the manifold)
> 				- the model perceives them as semantically similar
> 	   - The **Sparse Autoencoders (SAEs)** ➝  are the tools we use to see these decision points
> 		   - They reveal which specific directions in the manifold are being used to define that similarity.
>
>--
>
>6. **Attention as a Similarity Filter**
>	- The Attention mechanism is the active decider. It calculates a similarity matrix between the current token (Query) and all other tokens (Keys).
>		  $$\text{Attention}(Q, K, V) = \text{softmax}\left(\frac{QK^T}{\sqrt{d_k}}\right)V$$
>		- This **$QK^T$** operation is a literal similarity check
>        - By calculating this at every layer, the model is constantly re-evaluating: _Which other semantic points on the manifold are relevant to my current position?_
>--- 
> - **Why this matters for Truth**
> 	- When we look for a **Truth Vector**, we are looking for a direction where the model has decided that all true statements share a geometric property. 
> 	- If The Earth is round and 2+2=4 are both True, the model has learned to place them on a specific Truth Submanifold. 
> 	- They are similar in the eyes of the model, not because of their subject matter, but because they occupy the same Truth coordinate on the manifold

##### III. Emergent Properties in Nanotubes: Mapped to Manifolds Learning

> [!example] **Applying the concepts of emergent properties in Nanotubes ➝ to  Conceptual-Manifold**
> 
> 1. **Geometric Enforcement of Meaning**
>	- Just as a nanotube's strength is enforced by its hexagonal lattice ➝  an LLM’s logic is enforced by the **manifold's curvature**
> 		- During training, the model is bombarded with data ➝ to minimize loss ➝  it packs similar concepts into dense geometric clusters
> 		- This packing creates a **structural rigidity** in the latent space
> 			- once Truth is geometrically enforced as a specific direction across millions of examples
> 			- the model cannot easily deviate from it ➝ without breaking the structural integrity of its internal manifold
>     
> 2. **Emerging Directions vs. Single Points**
>	- In the nanotube example, the strength is directional (tensile strength is highest along the axis). Similarly, in an LLM:
> 		- **Semantic Strength** emerges along specific axes
> 			- A single semantic point is like a single atom ➝ it doesn't have strength or truth on its own
> 			- But when millions of points are aligned along a **geodesic** ➝ a Truth Direction emerges
> 			- this is exactly what we found in **Project Aletheia**  ➝  [[01-Projects/LLMs/Project-Aletheia-Geometry-of-Truth/Project-Aletheia-Geometry-of-Truth-Implementation]]
> 				- we weren't looking for a single neuron ➝ we were looking for the tensile axis of truth that emerged from the manifold's geometry
> 
> 3. **The Van der Waals of Data**
>	- In nanotubes, weak forces hold the bundle together. In LLMs, **Attention** acts as that binding force
> 		- Attention pulls ➝ related tokens toward each other in the residual stream ➝ creating a semantic bundle
> 		- The **strength of a concept** (how well the model understands it)  ➝ depends on **how tightly the manifold is packed** around that concept 
> 			- if the data is sparse (like a rare language) ➝  the manifold is weak and brittle, leading to hallucinations
> 
> 1. **Why Structural Integrity is Logical Consistency**
>	- If we bend a nanotube too far ➝  the geometric enforcement breaks + the tube snaps
> 		- When we steer a model using a Truth Vector ➝  we are applying a **geometric load** to the manifold
> 		- If we apply too much steering ($\alpha$ is too high) ➝  we push the representation off the manifold entirely
> 		- The geometric enforcement fails ➝  and the model starts outputting gibberish ➝ essentially a structural collapse of meaning
>
> **Treating the Residual Stream like a structural beam and the Manifold like a composite material**

##### IV. Materials Science Concepts: Mapped to Manifolds in LLMs

> [!quote] **Applying Materials Science concepts to the Manifold perspective in LLMs** 
> If **strength** is an emergent property of geometric enforcement in nanotubes ➝ consider the lattice defects and phase transitions of the **Conceptual-Manifold**
> 
> 1. **Semantic Lattice Defects (Hallucinations)**
> 	- In materials, a defect is a point where the **geometric enforcement** of the crystal lattice breaks down ➝ In an LLM, a **hallucination** is essentially a semantic dislocation
> 		- The model follows a geodesic that **should** lead to a fact
> 			- but because the manifold is brittle or undersampled in that region ➝ the vector slips into a neighboring, incorrect submanifold
> 		- we aren't just looking for wrong words ➝ we are looking for a **geometric shear** where the model's structural integrity (its truth-vector alignment) has failed
> 	    
> 2. **The Elastic Limit of Context**
> 	- Consider the **Residual Stream** ➝  having an elastic limit
> 		- As we add context (tokens), we are stretching the representation along the manifold
> 		- If the context is logically consistent, the manifold remains elastic ➝ we can recover the original truth-vector easily
> 		- But if we introduce **contradictory or garbage context** ➝  we create **plastic deformation**
> 			- the representation is pushed so far into a low-density region of the manifold ➝ that it can't spring back to the truth
> 			- the geometry is permanently warped for that session
> 
> 3. **Phase Transitions in Learning (Grokking)**
> 	- In materials science, a phase transition (like Alpha-iron to Gamma-iron) changes the fundamental properties of the substance
> 	- In LLMs, this happens during training ➝  often called **Grokking.**
> 		- Initially, the manifold is a liquid ➝ unstructured and weak.
> 		- At a certain point in training ➝  the model suddenly solidifies its internal geometry
> 			- The Truth Vector doesn't just appear ➝  it **crystallizes** out of the noise
> 		- This is a **topological change** ➝ the model goes from simply memorizing points (a cloud) to enforcing a manifold (a structure)
> 
> 4. **Anisotropy of Meaning**
> 	- Nanotubes are **anisotropic** ➝ they have different strengths in different directions ➝ the **Manifold** is the same
> 		- The Truth Direction might be a very stiff axis in the manifold ➝  meaning it's hard to displace a representation from it once it's locked in
> 		- Other axes ➝  like Style or Tone ➝  might be much softer (more compliant) ➝ allowing the model to easily drift between formal and informal without breaking the underlying semantic structure
> 

##### V. Mapping LLM terminologies: To my Domains

> [!example] **Mapping LLM domain specific terminology to MY own domain expertise**
>
>
>1. **The Residual Stream as a Stress-Bearing Backbone**
>	- Instead of a **vector space** ➝ think of the residual stream as a **1D crystal lattice** or a **polymer backbone**
>		- **Updates:** Each layer is a **structural modification** (like adding a functional group or a dopant)
>		- **Stability:** If the model is well-trained ➝ it maintains **structural integrity** (semantic consistency)
>		- If it hallucinates ➝  it’s a **lattice defect** or a **dislocation** in the logic
>
>--
>
> 2. **Attention as Long-Range Interaction Forces**
> - Attention is not **math** ➝  it’s **Electromagnetism** or **Van der Waals forces**
> 	- **Queries/Keys** ➝ These define the **dipole moment** of a token
> 	- **Attention Weights** ➝ This is the **coupling constant** between two distant sites in the lattice
> 	- **Parallel Transport** ➝ This is effectively **gauge symmetry**
> 	- To move information from site A to site B on a curved manifold ➝  must apply a transformation that accounts for the local "field" (curvature)
>
>--
>     
> 3. **MLP Layers as Phase Transformations**
> 	- The MLP blocks don't just **process** data ➝ they act like **thermal annealing** or **pressure-induced phase changes**
> 		 - **Activation Functions (GELU/ReLU)**  ➝ these are the **non-linear response functions** of the material
> 		 - **Superposition**  ➝ this is **Quantum Superposition** at a classical scale ➝ storing multiple "quantum states" (features) in a single "physical site" (neuron) to maximize density, just like high-pressure crystalline structures
>
>--
> 
> 4. **Training as Annealing and Crystallization**
> 	- **Loss Function**  ➝  consider this as the **Gibbs Free Energy** of the system ➝ the model wants to reach the lowest energy state (minimum loss)
>	- **Grokking**  ➝ consider this as a **First-Order Phase Transition**  ➝ the model goes from a disordered "liquid" state (memorization) to an ordered "crystalline" state (generalization/logic) suddenly  ➝ once the temperature (learning rate/noise) is right

---
### 4. Architectural Operations as Geometric Transformations

#### 1. Attention as Parallel Transport

[[Attention-Is-All-You-Need-Vaswani]]

>[!critical] **Attention is not just a weighted sum ➝ it is a mechanism for moving information across the manifold ➝ while accounting for its curvature**

- **Mechanism** 
	- To move a vector from token $j$ to token $i$, the model must perform **Parallel Transport**
	- The Query-Key product approximates the **Connection** (specifically the Levi-Civita connection) required to rotate the vector so it remains tangent to $\mathcal{M}$ at the new location
- **Softmax as Exponential Map:** 
	- The Softmax operation acts as a local approximation of the **Exponential Map** ($\exp_p$) ➝  mapping vectors from the tangent space back onto the manifold surface

#### 2. RoPE as a Fiber Bundle Structure

Rotary Positional Embeddings (RoPE) inject position by rotating pairs of dimensions
- **Geometric View:** This treats $\mathcal{M}$ as a **Fiber Bundle**. 
	- The base manifold is the semantic meaning, and the fiber is the positional information. 
	- RoPE ensures that as we move along the sequence, we move around the fiber without losing the semantic coordinates on the base manifold.
- _Citation:_ **Su et al. (2024)** in the _RoFormer_ paper provides the mathematical basis for how these rotations preserve the relative distances (and thus the metric $g$) between tokens.

Further Explanations about RoPE ➝ [[RoFormer-Enhanced-Transformer-with-Rotary-Position-Embedding]]

> [!quote] **Su et al. (2024) - RoFormer: Enhanced Transformer with Rotary Position Embedding**
> - The definitive peer-reviewed review of RoPE is found in the **Neurocomputing (Vol. 568)** publication of _"RoFormer: Enhanced Transformer with Rotary Position Embedding"_ by **Su et al. (2024)**. This paper formalizes the shift from additive positional biases to multiplicative geometric transformations.
>- [RoFormer: Enhanced Transformer with Rotary Position Embedding](https://arxiv.org/abs/2104.09864)
>- [RoFormer-HugginFace-Integration](https://huggingface.co/docs/transformers/model_doc/roformer)
> - **Key findings from the review:**
> 	- **Unified Encoding:** RoPE is presented as the first method to unify absolute and relative positional information by encoding position as a rotation in a high-dimensional complex space.
> 	- **Length Extrapolation:** The paper demonstrates that RoFormer handles sequences significantly longer than its training window by maintaining the "long-term decay" property—the inner product of tokens decays as their relative distance increases.
> 	- **Linear Attention Compatibility:** A critical architectural advantage noted is that since RoPE preserves the norm of representations (orthogonal transformation), it can be integrated into linear self-attention mechanisms, which traditional relative biases cannot.

---
### 5. Mechanistic Interpretability: Probing the Manifold

[[Conceptual-Introductory-MI]]
[[00-Mechanistic-Interpretability-Layer-Zones-Reading-List]]
[[A-Practical-Review-of-Mechanistic-Interpretability-for-Transformer-Based-Language-Models]]

#### I. Truth Vectors and Codimension-1 Submanifolds

As explored in the **Project Aletheia**, Truth is not a single point but a direction ➝ [[01-Projects/LLMs/Project-Aletheia-Geometry-of-Truth/Project-Aletheia-Geometry-of-Truth-Implementation]]

- **Linear Slicing**  ➝ A linear probe finds a hyperplane that bisects the manifold. If a Truth Vector exists, it is the normal vector to the **Truth Submanifold**
    
- **Layer-wise Crystallization:** Representations are often crumpled in early layers. Semantic features crystallize (linearize) in the middle layers (e.g., Layer 20 of Qwen2.5-1.5B) before collapsing toward the output vocabulary in final layers.
    
#### II. Feature Superposition (The Tight Frame)

LLMs store more features than they have dimensions ($M > d_{\text{model}}$).

- **The Geometry:** This is achieved through **Overcomplete Bases**. Features are not orthogonal; they are nearly orthogonal (Equiangular Tight Frames).
    
- _Citation:_ **Bricken et al. (Anthropic, 2023)**, _Scaling Monosemanticity_, details how Sparse Autoencoders (SAEs) can unmix these superimposed manifold directions into interpretable features.
    

---

### 6. Advanced Geometries: Hyperbolic and Spherical

Not all manifolds are flat (Euclidean).

- **Hyperbolic Space ($\mathbb{H}^n$):** Hierarchical structures (taxonomies, family trees) have exponential growth. LLMs often embed these in hyperbolic submanifolds because the volume of hyperbolic space grows exponentially with the radius.
    
- **Spherical Space ($\mathbb{S}^n$):** Cosine similarity (standard in LLMs) implies that the model primarily cares about the _direction_ of vectors, effectively projecting tokens onto a unit hypersphere.
    
- _Citation:_ **Tifrea et al. (2019)**, _Poincaré GloVe_, proves that hierarchical relationships are captured with significantly lower error in hyperbolic manifolds than in Euclidean ones.




### 7. Citations

1. **Bronstein, M. M., et al. (2021):** _Geometric Deep Learning_.
    
2. **Park, J. S., et al. (2024):** _The Linear Representation Hypothesis and the Geometry of LLMs_.
    
3. **Aghajanyan, A., et al. (2020):** _Intrinsic Dimensionality Explains the Effectiveness of Language Model Fine-Tuning_.
    
4. **Elhage, N., et al. (2021):** _A Mathematical Framework for Transformer Circuits_.
    
5. **Bricken, T., et al. (2023):** _Towards Monosemanticity: Decomposing Language Models with Sparse Autoencoders_.




















6. **Residual stream = geodesic on learned manifold**, not simple vector addition
7. **Attention = parallel transport** via approximate exponential map (softmax)
8. **Probing methods:**
    - Linear probes find **hyperplane slices** of feature manifolds
    - Causal intervention tests **feature causality** via steering
    - Geodesic probes account for **manifold curvature**
9. **Truth directions** are 1D submanifolds cutting through Rdmodel\mathbb{R}^{d_{\text{model}}} Rdmodel​
10. **Hierarchical structure:** Early layers = low-dim syntax, middle = high-dim semantics, late = task-specific collapse
11. **Superposition:** M≫dM \gg d M≫d features via overcomplete bases (tight frames)

---

### References for Deep Dive

- **Anthropic (2024):** Scaling Monosemanticity — SAE decomposition
- **Meta (2024):** The Llama 3 Herd of Models — geometric analysis
- **Elhage et al. (2021):** A Mathematical Framework for Transformer Circuits
- **Nanda et al. (2023):** Progress measures for grokking via mechanistic interpretability

---

**Ali, this framework gives we the geometric lens to:**

- Design probes that respect manifold structure
- Understand why linear methods work (tangent space approximation)
- Build intuition for multi-scale representation learning
- Connect to the GNN/graph ML expertise (same differential geometry!)