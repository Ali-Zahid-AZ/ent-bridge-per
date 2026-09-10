---
tags:
  - llm-manifolds-geometric-perspective
  - llm-manifolds-geometric-perspective
  - seminal_works
  - llmops-positional-embeddings-encoding
---

---
```table-of-contents
```

---
> [!example] .
>
>**[Obsidian Links]** 
> `$= dv.list(dv.current().file.outlinks.filter(l => l.path.endsWith(".md")))`
>
>---
>
>**[External Links]**
> `$= const content = await dv.io.load(dv.current().file.path); const regex = /\[(.*?)\]\((https?:\/\/[^\s)]+)\)/g; const links = []; let m; while (m = regex.exec(content)) { links.push("[" + m[1] + "](" + m[2] + ")"); } dv.list([...new Set(links)])`
>
>---
>
>**[Directory Links]**
> `$= const content = await dv.io.load(dv.current().file.path); const regex = /\[(.*?)\]\(<(file:\/\/\/.*?)>\)/g; const links = []; let m; while (m = regex.exec(content)) { links.push("[" + m[1] + "](<" + m[2] + ">)"); } dv.list([...new Set(links)])`
>
>---
>
>**[Back Links]**
> `$= dv.list(dv.current().file.inlinks)`

---
### Primitives 

- [RoFormer-Enhanced-Transformer-with-Rotary-Position-Embedding-2023.pdf](<file:///home/az/04-Library/03-Deep-Learning-and-Architectures/01-Representation-and-Interpretability/Manifolds-Learning/RoFormer-Enhanced-Transformer-with-Rotary-Position-Embedding-2023.pdf>)
- [RoFormer: Enhanced Transformer with Rotary Position Embedding](https://arxiv.org/abs/2104.09864)
- [RoFormer-HugginFace-Integration](https://huggingface.co/docs/transformers/model_doc/roformer)
- [[Conceptual-Manifold-Geometry-of-Large-Language-Models]]
- [Why Rotating Vectors Solves Positional Encoding in Transformers | Rotary Positional Embeddings(ROPE)](https://www.wetube.com/watch?v=qKUobBR5R1A)
- [Relative Position Encoding with RoPE](https://www.youtube.com/watch?v=qKUobBR5R1A)

---
#### What is it about?

> [!quote] **Su et al. (2024) - RoFormer: Enhanced Transformer with Rotary Position Embedding**
> - The definitive peer-reviewed review of RoPE is found in the **Neurocomputing (Vol. 568)** publication of _RoFormer: Enhanced Transformer with Rotary Position Embedding_ by **Su et al. (2024)**. This paper formalizes the shift from additive positional biases to multiplicative geometric transformations.
>- [RoFormer: Enhanced Transformer with Rotary Position Embedding](https://arxiv.org/abs/2104.09864)
>- [RoFormer-HugginFace-Integration](https://huggingface.co/docs/transformers/model_doc/roformer)
> - **Key findings from the review:**
> 	- **Unified Encoding:** RoPE is presented as the first method to unify absolute and relative positional information by encoding position as a rotation in a high-dimensional complex space.
> 	- **Length Extrapolation:** The paper demonstrates that RoFormer handles sequences significantly longer than its training window by maintaining the long-term decay property—the inner product of tokens decays as their relative distance increases.
> 	- **Linear Attention Compatibility:** A critical architectural advantage noted is that since RoPE preserves the norm of representations (orthogonal transformation), it can be integrated into linear self-attention mechanisms, which traditional relative biases cannot.

#### Understanding of the Concept 

![[Pasted image 20260211060351.png | 500]]

> [!example] **The Molecular Analogy for RoPE**
> 1. **The Polymer Backbone (The Residual Stream)**
> 	- Imagine the entire sequence of tokens ➝ is a long covalent polymer backbone (like a carbon chain)
> 		- Each **token** ➝ is a repeating monomer unit in this chain
> 		- The **Hidden State ($\mathbf{x}$)**  ➝ is the specific functional group (the identity) attached to each carbon atom
>
>--     
>
> 2. **Torsional Angles as Position ($\theta$)****
> 		- In traditional positional encodings ➝ we'd try to label each monomer with a tag: Monomer 1, Monomer 2
> 		- With **RoPE**  ➝ position is encoded as a **Torsional Rotation** along the backbone
> 		- As we move from Monomer $m$ to Monomer $m+1$ ➝  the functional group doesn't just sit there; it **twists** by a specific angle
> 			- **Monomer 1:** Torsional angle = $10^\circ$
> 			- **Monomer 2:** Torsional angle = $20^\circ$
> 			- **Monomer $n$:** Torsional angle = $n \times \theta$
>
>--
> 
> 3. **The Multi-Bond System (Subspaces as Independent Rotations)**
> 	- A molecule doesn't just have one axis of rotation
> 	- Because the semantic vector is 4,096-dimensional ➝  imagine each monomer has **2,048 different bonds** that can rotate independently
> 		- **High-Frequency Bonds:** These spin rapidly as we move down the chain ➝  they represent **local syntax**—how a word interacts with its immediate neighbors
> 		- **Low-Frequency Bonds:** These drift slowly ➝  they represent **long-range structure** ➝ how the beginning of a polymer folds to interact with a distant section
>
>-- 
>    
> 4. **Semantic Interaction (The Relative Twist)**
> 	- When two functional groups on the chain want to interact (Self-Attention) ➝ they don't care about their absolute position in the lab
> 	- They care about their **Relative Orientation**
> 		- If Group A is twisted at $50^\circ$ and Group B is at $80^\circ$ ➝ their **relative torsional difference is $30^\circ$**
> 		- The Meaning (the chemical identity/bond length) stays the same ➝  but the **angle of interaction** tells the model exactly how far apart they are on the chain
>
>--     
>
> 1. **The Fiber Bundle as Stereoisomerism**
> 	- In the **Manifold** ➝ the Meaning is the **Constitutional Isomer** (the formula and connectivity) ➝ and the Position is the **Stereoisomer** (the 3D orientation)
> 		- **Base Manifold** ➝  the chemical formula (e.g., $C_4H_{10}$)
> 		- **Fiber**  ➝ the infinite set of possible **conformations** (e.g., _staggered_ vs. _eclipsed_)
>---
> RoPE allows the molecule to change its **Conformation** (position) without ever changing its **Constitution** (meaning)
> It rotates through the fiber of space ➝ allowing the attention mechanism to feel the relative twist of the entire sequence ➝ as if it were a folding protein
>---
>- **Bond Length ($d_{\text{model}}$):** Constant.    
>- **Torsional Angle ($\theta_m$):** Position-dependent.
>- **Chemical Affinity:** The Attention Score, which is highest when the relative twist aligns perfectly for a bond to form.
>---
>RoPE turns the Transformer from a black box into a **molecular machine** where:
>- **Bond Lengths = Semantic Vectors** (Preserved through rotation)
>- **Torsional Twist = Positional Encoding** (The relative angle defines the interaction).
>- **Chemical Affinity = Attention Weights** (Determined by how well the angles of two groups align)
---

####  Technical Explanation

>[!success] **Technical** ➝ The implementation of RoPE operates as a **block-diagonal orthogonal transformation** applied directly to the **query** and **key** vectors
>
>--
>[[Attention-Is-All-You-Need-Vaswani]]
> 
> ##### 1. Subspace Decomposition
> 
> Let $\mathbf{x} \in \mathbb{R}^d$ be a hidden representation (where $d = d_{\text{model}}$)
> We decompose the $d$-dimensional space into $d/2$ orthogonal 2D subspaces
> For each subspace $j \in \{1, \dots, d/2\}$, we consider the pair of coordinates $(x_{2j-1}, x_{2j})$
> 
> ##### 2. Frequency Formulation
> 
> The rotation angle for each subspace is determined by the token's position $m$ and a predefined frequency $\theta_j$:
> 
> $$\theta_j = 10000^{-2(j-1)/d}$$
> 
> The specific angle of rotation at position $m$ for the $j$-th subspace is $m\theta_j$
> 
> ##### 3. The Rotation Matrix
> 
> The transformation is applied by multiplying each coordinate pair by the 2D rotation matrix $\mathbf{R}_{m,j}$:
> 
> $$\begin{pmatrix} x'_{2j-1} \\ x'_{2j} \end{pmatrix} = \begin{pmatrix} \cos(m\theta_j) & -\sin(m\theta_j) \\ \sin(m\theta_j) & \cos(m\theta_j) \end{pmatrix} \begin{pmatrix} x_{2j-1} \\ x_{2j} \end{pmatrix}$$
> 
> In the full $d$-dimensional space, this results in a block-diagonal matrix $\mathbf{R}_m$:
> 
> $$\mathbf{q}_m = \mathbf{R}_m \mathbf{W}_q \mathbf{x}_m, \quad \mathbf{k}_n = \mathbf{R}_n \mathbf{W}_k \mathbf{x}_n$$
> 
> ##### 4. Relative Distance Invariance
> 
> The self-attention score is the inner product of the rotated query and key. Due to the properties of rotation matrices:
> 
> $$\langle \mathbf{q}_m, \mathbf{k}_n \rangle = \mathbf{q}_m^\top \mathbf{k}_n = (\mathbf{R}_m \mathbf{q})^\top (\mathbf{R}_n \mathbf{k}) = \mathbf{q}^\top \mathbf{R}_m^\top \mathbf{R}_n \mathbf{k} = \mathbf{q}^\top \mathbf{R}_{n-m} \mathbf{k}$$
> 
> This proves that the attention score is a function solely of the relative distance $(n-m)$, effectively linearizing the manifold logic relative to the sequence flow
> 
> ##### 5. Complex Domain Representation
> 
> In the complex plane, if we represent each 2D subspace as a complex number $z_j = x_{2j-1} + i x_{2j}$, the RoPE transformation at position $m$ is simply:
> 
> $$z'_j = z_j e^{i m \theta_j}$$
> 
> This demonstrates that position is a phase shift applied to the semantic vector


---




