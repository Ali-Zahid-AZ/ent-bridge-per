---
tags:
  - llm-manifolds-geometric-perspective
  - research-article
  - reading-list
  - gemini
  - Claude-Anthropic
  - deepseek
  - llm-natural-latent-geometry
  - riemannian_manifolds
  - axiom
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

- **Proceedings PDF** ➝ [proceedings.neurips.cc/paper\_files/paper/2023/file/78efbc5386c5a7c241e7fcc482d3c3dc-Paper-Conference.pdf](https://proceedings.neurips.cc/paper_files/paper/2023/file/78efbc5386c5a7c241e7fcc482d3c3dc-Paper-Conference.pdf)
- arXiv ➝ [Neural Latent Geometry Search: Product Manifold Inference via Gromov-Hausdorff-Informed Bayesian Optimization](https://arxiv.org/abs/2309.04810)
- PDF ➝ [Neural-Latent-Geometry-Search-Product-Manifold-Inference-via-Gromov-Hausdorff-Informed-Bayesian-Optimization-2023.pdf](<file:///home/az/04-Library/03-Deep-Learning-and-Architectures/01-Representation-and-Interpretability/Manifolds-Learning/Neural-Latent-Geometry-Search-Product-Manifold-Inference-via-Gromov-Hausdorff-Informed-Bayesian-Optimization-2023.pdf>)
- [📂 Open: Manifolds-Learning](<file:///home/az/04-Library/03-Deep-Learning-and-Architectures/01-Representation-and-Interpretability/Manifolds-Learning>)
- [The Complexity of the Hausdorff Distance](https://arxiv.org/abs/2112.04343)
- [[Conceptual-Manifold-The-Crumpled-Data-Perspective]]
- [[Conceptual-Manifold-Geometry-of-Large-Language-Models]]
- [[Conceptual-Manifold-Conceptualization-in-DeepLearning]]
- [[Conceptual-Manifold-Data-Journey-in-LLM]]
- [[Conceptual-Gradient-Descent-The-Geometric-Perspective]]
- [[Conceptual-Riemannian-Manfolds]]
- [[Conceptual-Hyperbolic-Space]]
- [[00-Riemannian-Manifolds-Hyperbolic-Spaces-LLMs]]
---
### 1. Latent Map

#### I. The Problem

- Standard machine learning models ➝ typically assume the latent space (where data representations live) ➝ is a flat, Euclidean space
- However complex data often has underlying structures ➝ like hierarchies or cycles ➝ that are better represented by non-Euclidean geometries (e.g., hyperbolic or spherical spaces)
- While **product manifolds** (combinations of these spaces) can model ➝ **mixed structures** ➝  manually selecting the correct combination of geometries ➝ for a specific dataset is difficult and computationally expensive

#### II. The Solution: Neural Latent Geometry Search: NLGS

The authors propose **NLGS**, a framework to automatically discover the optimal latent geometry for a given dataset and downstream task. Instead of random trial-and-error, they treat the selection of geometry as a principled search problem.

#### III. Key Methodology

1. **Search Space:** The algorithm searches through a space of "product manifolds," which are combinations of constant curvature spaces (Euclidean, Hyperbolic, and Spherical).
2. **Gromov-Hausdorff Distance:** To navigate this search space efficiently, the authors need a way to measure the "distance" or similarity between two different candidate geometries. They propose a novel metric based on the **Gromov-Hausdorff distance**.
    - To compute this, they introduce a mapping function that embeds different manifolds into a common high-dimensional ambient space, allowing for direct comparison.
3. **Bayesian Optimization:** They construct a graph where nodes are candidate product manifolds and edges represent the "smoothness" or similarity between them (derived from the inverse Gromov-Hausdorff distance). They then use **Bayesian Optimization** on this graph to efficiently search for the geometry that minimizes the loss function with the fewest number of experimental queries (training runs).

#### IV. Significance

- This work provides a mathematically grounded method for automating the selection of inductive biases related to geometry. 
- It moves beyond heuristic choices of latent spaces, allowing models to adapt their geometric structure to "fit" the data more accurately.

#### V. Personal Importance: Gemini 

This paper sits squarely at the intersection of your core interests: **Geometric Deep Learning**, **Manifold Theory** + **principled architectural design**

Here is why this specific paper is a high-priority read for you:
1. **It solves the "Which Manifold?" problem:** You are already interested in how non-Euclidean spaces (hyperbolic/spherical) better represent certain data. This paper goes a step further: instead of you _guessing_ which geometry to use, it proposes a rigorous method to _learn_ the optimal **product manifold** (e.g., $\mathbb{R}^n \times \mathbb{H}^m \times \mathbb{S}^k$).
2. **Deep Mathematical Foundation:** It doesn't just use heuristics. It builds a search space based on the **Gromov-Hausdorff distance** (a metric for measuring how far two metric spaces are from each other). This aligns perfectly with your goal to master the rigorous mathematical aspects of DL.
3. **Graph-Based Approach:** It treats the space of possible manifolds as a graph and performs Bayesian Optimization on it. Since you are interested in **Graph-Based Deep Learning**, this application of graph theory to _model selection_ is a fascinating meta-application.
    
> **Verdict:** It is high-density and mathematically heavy, but that is exactly what you are looking for to reach that "Principal Architect" level of understanding

##### Projected Mastery: End of Paper Dissection

> [!example] **By the end of our dissection, you will have mastered:**
> 
> ##### 1. Riemannian Geometry for Latent Spaces (The "Where")
> You will move beyond the default assumption that all data lives in a flat, Euclidean world ($\mathbb{R}^n$)
> - **What you will learn:** How to mathematically construct **Product Manifolds** (e.g., sticking a Cylinder $\mathbb{S}^1 \times \mathbb{R}^1$ together with a Hyperbolic disk $\mathbb{H}^2$).
> - **Why it matters:** This allows you to design architectures that naturally fit data with mixed topologies—like a dataset that has both **cyclic** features (time of day) and **hierarchical** features (taxonomy).
>--- 
> ##### 2. Spectral Geometry & The Laplace-Beltrami Operator (The "Fingerprint")
> This is the mathematical heavy lifting.
> - **What you will learn:** How to compute the "spectrum" (eigenvalues) of a manifold shape using the **Laplace-Beltrami Operator**.
> - **The Intuition:** Just like you can identify a drum's shape by the sound it makes (its frequencies), this operator lets you identify a manifold's geometry by its "spectral signature."
> - **Why it matters:** This is a fundamental tool in **Graph Signal Processing** and **Geometric DL**. If you master this, you can design algorithms that "see" structure in ways standard convolutions cannot.
>---    
> ##### 3. Metric Geometry Optimization (The "How")
> You will learn how to optimize over a **discrete graph of topologies**, not just continuous weights
> - **What you will learn:** The **Gromov-Hausdorff Distance**. This is the "ruler" used to measure how different two shapes are.
> - **Why it matters:** Most people optimize weights ($w$). You will learn how to optimize the **container** itself. This is the definition of **AutoML** for geometry.
>---  
> **In short** ➝ Reading this paper will transition you from someone who _uses_ pre-defined layers to someone who can **mathematically derive the optimal geometric space** for a problem.

#### VI. Rudimentary Explanations 

**What:** This paper introduces a method to automatically find the best "shape" for a neural network's latent space. Instead of assuming data fits on a flat sheet (Euclidean space), it searches for complex combinations of curved shapes (spheres, hyperbolas) that better fit the data structure.

**Does:** It treats the choice of geometry as a search problem. It defines a "space of spaces" (a graph where each node is a different geometric combination) and uses a smart trial-and-error method (Bayesian Optimization) to find the geometry that minimizes error. To do this efficiently, it calculates how "similar" two geometries are using a specific mathematical ruler called the Gromov-Hausdorff distance.

**Why:**
- **Euclidean is not enough:** Hierarchical data (like trees/taxonomies) fits best in Hyperbolic space. Cyclic data (like seasonal trends) fits best in Spherical space.
- **Manual choice is hard:** Guessing the right combination (e.g., "2 hyperbolic dims + 3 spherical dims") is difficult and expensive to train every time. This automates that architectural decision.

#### VII. Technical Jargon 

##### I. The Search Space: Product Manifolds
The algorithm searches for a **Product Manifold** $\mathcal{M}$. 
This is a Cartesian product of $k$ component manifolds, each with constant curvature:

$$\mathcal{M} = \bigtimes_{i=1}^k \mathcal{M}_{K_i}^{d_i}$$

- $\mathcal{M}_{K_i}^{d_i}$ is a sub-manifold of dimension $d_i$ and curvature $K_i$.
    
- **Components:**    
    - **Euclidean ($\mathbb{E}$):** $K=0$ (Flat) ➝ good for **grids/vectors**
    - **Hyperbolic ($\mathbb{H}$):** $K<0$ (Negative) ➝ good for **hierarchies/trees**
    - **Spherical ($\mathbb{S}$):** $K>0$ (Positive) ➝ good for **cycles/graphs**
    
##### II. The Metric: Gromov-Hausdorff Distance 
- To optimize efficiently, the model needs to know if two candidate manifolds are "close" to each other
	- if Manifold A performs poorly, a "close" Manifold B likely will too
- They use the **Gromov-Hausdorff distance**
	- measures how far two compact metric spaces are from being isometric (structurally identical)

$$d_{GH}(X, Y) = \inf_{Z, f, g} d_H^Z(f(X), g(Y))$$

>- where **$X$** and $Y$ ➝ are the two metric spaces (manifolds)
>- $Z$ ➝ is a common metric space they are mapped into
> - $f: X \to Z$ and $g: Y \to Z$ ➝ are **isometric embeddings**
> - $d_H^Z$ ➝ is the **Hausdorff distance** in space $Z$

   
_Key Insight:_ They approximate this computationally using the **Spectral Gromov-Wasserstein** distance, which relies on the eigenvalues of the Laplace-Beltrami operator (the "frequencies" of the shape).

##### III. The Optimizer: Manifold-GASP
They use **Gaussian Process (GP) Regression** over the graph of candidate manifolds.
- **Nodes:** Possible product manifolds (e.g., $\mathbb{H}^2 \times \mathbb{S}^1$).
- **Edges:** Weighted by the inverse of the Gromov-Hausdorff distance.
- **Process:**
    1. Train a few random geometries.
    2. Update the GP posterior (predict which geometry might be good).
    3. Select the next geometry to train using an Acquisition Function (like Expected Improvement).

---
##### IV. Image: The Manifold Optimization Trajectory

![[Pasted image 20260212023745.png | 600]]

> [!cite] **Image Description: The Manifold Optimization Trajectory**
> **1. The Axes (The Search Space)**
> - **Y-Axis (Vertical):** Represents **Model Accuracy** (or effectively, $1 - \text{Loss}$). 
>     - _Concept:_ The higher the node, the better the geometry fits the data. The goal is to maximize this.
> - **X-Axis (Horizontal):** Represents **Manifold Complexity / Type**.
>     - _Concept:_ Moving right implies shifting across the "Manifold Graph"—transitioning from simple geometries (Spherical/Euclidean) to more complex or structurally different ones (Hyperbolic).
>--- 
> **2. The Nodes (The Candidate Geometries)**
> - **$\mathbb{S} \times \mathbb{S}$ (Red/Orange Node, Bottom Left):**
>     - _Visual:_ Dim, reddish glow. Low on the accuracy axis.
>     - _Concept:_ A product of two Spherical manifolds. For this specific dataset, it is a "Poor Fit" (high loss), likely because the data is hierarchical, not cyclic.
> - **$\mathbb{E} \times \mathbb{E}$ (Purple Node):**
>     - _Visual:_ Higher up, purple glow.
>     - _Concept:_ Standard Euclidean space (flat). Better than Spherical, but still not optimal. This represents the "default" assumption in most deep learning models.
> - **$\mathbb{H} \times \mathbb{E}$ (Blue Node):**
>     - _Visual:_ Higher still, bright blue.
>     - _Concept:_ A mixed topology (Hyperbolic $\times$ Euclidean). The model is starting to capture the hierarchy in the data.
> - **$\mathbb{H} \times \mathbb{H}$ (White/Brightest Node, Top Right):**
>     - _Visual:_ Blinding white light, highest peak.
>     - _Concept:_ The Global Minimum of the loss function. A purely Hyperbolic product manifold. This is the "Truth" structure of the data that the algorithm successfully found.
>---         
> **3. The Trajectory (The Bayesian Search)**
> - **The Glowing Curve:** A connecting line that arcs through the nodes.
>     - _Concept:_ This represents the **Gaussian Process (GP)** navigating the search space. It doesn't jump randomly; it follows the "gradient" of similarity defined by the **Gromov-Hausdorff distance**. It learns that moving away from Spherical and towards Hyperbolic improves performance

>[!example] **Axiomatic:**  **Interpretability requires geometric constraints that bound the solution space**

---
### 2. Section: Abstract 

#### I. The Premise: The Why

> _"Recent research indicates that the performance of machine learning models can be improved by aligning the geometry of the latent space with the underlying data structure. Rather than relying solely on Euclidean space, researchers have proposed using hyperbolic and spherical spaces with constant curvature... to better model the latent space..."_

- **Interpretation:** This establishes the **Geometric Inductive Bias**. Standard models assume a flat world ($\mathbb{E}^n$). The paper argues that "Model Geometry" is a hyperparameter just like "Learning Rate" or "Layer Count."
    
- **Key Concept:** **Constant Curvature Spaces**. These are the "lego blocks" of geometry:    
    - $K=0$ (Euclidean/Flat)
    - $K<0$ (Hyperbolic/Tree-like)
    - $K>0$ (Spherical/Cyclic)
        
#### II. The Gap: The Problem

> _"...little attention has been given to the problem of automatically identifying the optimal latent geometry for the downstream task."_

- **Interpretation:** This is the **Manual Search Bottleneck**. Currently, researchers _guess_ the geometry ("Let's try Hyperbolic because this looks like a tree"). There is no rigorous, automated method (AutoML) for selecting the manifold topology.
    
#### III. The Formulation: The What

> _"We mathematically define this novel formulation and coin it as neural latent geometry search (NLGS)... specifically... search for a latent geometry composed of a product of constant curvature model spaces..."_

- **Interpretation:** They define the search space as **Product Manifolds**. Instead of searching for just "Hyperbolic" or "Spherical", they search for combinations:
    
    $$\mathcal{M} = \mathbb{H}^{d_1} \times \mathbb{S}^{d_2} \times \mathbb{E}^{d_3}$$
    
    This allows the model to capture mixed topologies (e.g., a dataset with both hierarchical _and_ cyclic features)
    
#### IV. The Metric: The How - Part 1

> _"...we propose a novel notion of distance between candidate latent geometries based on the Gromov-Hausdorff distance... we introduce a mapping function that enables the comparison of different manifolds by embedding them in a common high-dimensional ambient space."_

- **Interpretation:** This is the theoretical core. To optimize, you need to measure the "distance" between two candidate manifolds (e.g., "How different is $\mathbb{H}^2$ from $\mathbb{S}^2$?")
    - **Tool:** **Gromov-Hausdorff Distance ($d_{GH}$)**
    - **The Trick:** Since you cannot compare them directly, they embed both into a shared "super-space" (Ambient Space) to calculate the overlap or "gap" between them
        
#### V. The Optimizer: The How - Part 2

> _"...design a graph search space based on the notion of smoothness... and employ the calculated distances as an additional inductive bias. Finally, we use Bayesian optimization to search... in a query-efficient manner."_

- **Interpretation:**
    - **Graph Search:** The geometries are nodes in a graph
    - **Smoothness Assumption:** If Manifold A is "close" to Manifold B (small $d_{GH}$), their performance (loss) should be similar
    - **Bayesian Optimization:** Instead of training 1,000 models (Brute Force), they use a **Gaussian Process** to _predict_ which geometry will work best based on previous trials. This makes the search **Query-Efficient** (fast)

**Significance**: This abstract promises a transition from **heuristic geometry selection** (guessing) to **principled geometry optimization** (measuring)

---
### 3. Section I: Introduction 

> This section defines the **Problem Statement** and the **Solution Space** 
> Requirement:  articulate _why_ a Euclidean model fails for certain data, and _what_ specific mathematical structures this paper proposes to fix it

#### I. The Core Conflict: The Euclidean Bottleneck

The paper begins with the **Manifold Hypothesis**:

> _Real-world high-dimensional data (images, graphs, text) lies on low-dimensional manifolds embedded within that high-dimensional space_

**The Problem:**
Standard Deep Learning (VAEs, GANs, Transformers) almost exclusively uses **Euclidean Space ($\mathbb{E}^n$)** as the latent representation.
- **The Mismatch:** If your data has an intrinsic structure that is **curved** (like a hierarchy or a cycle), forcing it into a flat Euclidean box creates **distortion**.
    - _Example:_ In a hierarchy (tree), the number of nodes grows exponentially with depth. In Euclidean space, volume grows polynomially ($r^n$). You literally run out of space to put the nodes, forcing the model to squash them together. This "squashing" is the distortion.

**Perspective:** You are paying a "distortion tax" every time you use a standard vector embedding for hierarchical data. The model has to use extra parameters just to memorize positions because the geometry doesn't support them naturally.

#### II. The Proposed Solution: Product Manifolds

The authors argue that we shouldn't just swap Euclidean for _one_ other geometry (like Hyperbolic). 
Real data is complex and mixed. It might be part tree, part grid, part cycle

> [!example] **Proposed Product Manifold: The Latent Space**
> Propose using a **Product Manifold** $\mathcal{M}$ as the latent space
> 
> This is a "Mix-and-Match" geometry constructed from three specific atomic building blocks, known as **Constant Curvature Model Spaces**:
> 
> > 1. **Euclidean ($\mathbb{E}$):** Curvature $K=0$. (Good for grids/vectors)
> > 2. **Hyperbolic ($\mathbb{H}$):** Curvature $K<0$. (Good for trees/hierarchies)
> > 3. **Spherical ($\mathbb{S}$):** Curvature $K>0$. (Good for cycles/rotations)
> 
>
> $$\mathcal{M} = \mathbb{H}^{d_1} \times \mathbb{S}^{d_2} \times \mathbb{E}^{d_3}$$
>
> - _Interpretation:_ A single point in this latent space is a tuple $(h, s, e)$, where $h$ is a coordinate on a hyperbola, $s$ is an angle on a sphere, and $e$ is a vector in flat space.

#### III. The Research Gap (The "Search" Problem)

> **If Product Manifolds are so great, why isn't everyone using them?**
> **Because we don't know which combination to pick**

- **Current Approach** 
	- Manual heuristics 
	- "This looks like a graph, let's try Hyperbolic." 
	- "This looks like weather data, let's try Spherical."
- **The Combinatorial Explosion** 
	- Even with just 3 types of atoms, the number of combinations (signatures) is massive.
	    - Is it $\mathbb{H}^2 \times \mathbb{S}^2$?
	    - Or $\mathbb{H}^5 \times \mathbb{E}^1$?
	    - Or $\mathbb{S}^1 \times \mathbb{S}^1 \times \mathbb{H}^2$?
        
- **The Paper's Contribution (NLGS)**
	- They propose a framework to **automatically search** for the optimal signature.
	- Instead of training 1,000 models to see which one works (Brute Force), they treat the "Space of Geometries" as a graph and navigate it intelligently to find the best fit with minimal trials.

> [!quote] **Visualize the "Distortion" problem**
> 
> - **Scenario:** You want to embed a **World Map** (Spherical data) onto a **2D Paper** (Euclidean latent space).    
> - **Result:** The Mercator Projection.
>     - Greenland looks huge (Distortion).
>     - Antarctica is infinite (Distortion).
> - **The Fix:** Use a Spherical Latent Space. The map fits perfectly with **Zero Distortion**
> - **The Nuance:** What if your data is a World Map _plus_ a Family Tree of everyone living on it?
>     - You need $\mathbb{S}^2$ (for the map) $\times$ $\mathbb{H}^2$ (for the tree).
>     - This paper finds that specific " $\times$ " combination

#### IV. Checkpoint: Restrained Degrees of Freedom

> **Question:** Why specifically do the authors choose **Constant Curvature** spaces ($\mathbb{E}, \mathbb{H}, \mathbb{S}$) as their building blocks, rather than just learning an arbitrary, amorphous manifold shape?

> [!success] **Axiomatic**
> **Geometric spaces = bounded degrees of freedom = mathematical firewall on model behavior**
> **Spaces → Degrees of Freedom → Mathematical Firewall**
>--- 
> By constraining to ${E,H,S}$, the authors:
> 	1. **Cover the complete spectrum** (Uniformization Theorem)
> 	2. **Enable interpretability** (each choice has geometric meaning)
> 	3. **Get computational efficiency** (closed-form distance formulas)

> [!example] **Spaces → Degrees of Freedom → Mathematical Firewall**
>- **Theoretical Completeness (The "Spectrum")**
>	- **Uniformization Theorem** in geometry ➝ states that _every_ simply connected Riemann surface is conformally equivalent to one of these three:    
> 		- **Open Unit Disk ($\mathbb{H}$)**        
> 		- **Complex Plane ($\mathbb{E}$)**
> 		- **Riemann Sphere ($\mathbb{S}$)**
>	- By picking these three, they aren't just picking random shapes; they are picking the _canonical representatives_ of all possible simply connected geometries 
>         
>- **Interpretability (The "Why")**
>	- If the model learns an arbitrary "blob" manifold, we have no idea what it means
>	- But if the model selects $\mathbb{H}^2 \times \mathbb{E}^1$ ➝ we  immediately know ➝  _"Aha! This dataset has a hierarchical component and a linear component"_
>	- Gain insight into the _data itself_, not just the model performance
>         
>- **Closed-Form Analytical Formulas**
>	- In an arbitrary "amorphous" manifold, calculating the distance $d(x,y)$ requires solving a differential equation (the Geodesic Equation) numerically _every single time_. 
>		- That is computationally incredibly expensive
>	- In $\mathbb{E}, \mathbb{H}, \mathbb{S}$, we have simple, closed-form formulas (like the Poincaré distance formula) that can be computed in $O(1)$ time. 
>		- This makes the training loop millions of times faster
>---
>>  **The "Firewall" is the Symmetry Group**
>- **Transformational Degrees of Freedom**
>	- In **Euclidean Space ($\mathbb{E}$)**, the degrees of freedom are **Translation + Rotation** (The Euclidean Group $E(n)$). The model _must_ treat a cat in the top-left corner the same as a cat in the bottom-right.
> 	- In **Spherical Space ($\mathbb{S}$)**, the degrees of freedom are pure **Rotation** ($SO(n+1)$). The model _cannot_ translate; it can only rotate.
> 	- In **Hyperbolic Space ($\mathbb{H}$)**, the degrees of freedom include **Mobius Transformations** ($O(1, n)$). This allows for scaling/zooming towards the boundary.
>     
>- **Why the Mathematical Firewall Matters:**
>	- If we let the model have _infinite_ degrees of freedom (an arbitrary manifold), it will "cheat." 
> 	- It will overfit by twisting the space into a pretzel to memorize the training data.
> 
>- By **firewalling** it into one of these 3 distinct cages ($\mathbb{E}, \mathbb{H}, \mathbb{S}$), we force it to learn the _true structure_ of the data.
> 	- _"If I can't twist the space, I have to actually understand the relationship."_

#### V. Interesting Point: Bronstein

> _Traditionally, Euclidean spaces have been the preferred choice to model the geometry of latent spaces in the ML community [Weber, 2019, Bronstein et al., 2021]_

Weber 2019 ➝  [Curvature and Representation Learning: Identifying Embedding Spaces for Relational Data](https://web.math.princeton.edu/~mw25/project/files/nips_FB.pdf)
Bronstein 2021 ➝ [Geometric Deep Learning: Grids, Groups, Graphs, Geodesics, and Gauges](https://arxiv.org/abs/2104.13478)
##### Bronstein's Focus: The Geometry of the Domain: _Input_
In his 2021 Book (_Grids, Groups, Graphs, Geodesics, and Gauges_) ➝ Bronstein unifies Deep Learning by looking at the geometry of the **input structure**
- **CNNs** ➝  Work on **Grids** (Euclidean input)
- **GNNs** ➝  Work on **Graphs** (Non-Euclidean input)
- **Transformers** ➝  Work on **Sets** (discrete input)

>**However** ➝  Even when a GNN processes a complex graph (input), it typically produces a **feature vector** for each node that lives in **flat Euclidean space** ($\mathbb{R}^n$)
>- _Example:_ You feed a molecule graph into a GNN. 
>	- The GNN outputs a vector `[0.1, -0.5, 0.9]` for each atom. 
>	- That vector is Euclidean.
##### This Paper's Focus: The Geometry of the Latent Space: _Output/Internal_
This paper (NLGS) is critiquing the destination, not the origin
They are saying: _"Bronstein, you taught us how to process graphs (Input), but you are still forcing the final representation into a flat vector (Latent Space). That is a mistake."_
- **The Citation's Intent:** They are citing Bronstein (2021) as the definitive summary of the current "State of the Art" 
	- since the current SOTA (mostly) uses Euclidean embeddings
	- they cite him to say ➝ "See? Even the bible of GDL primarily deals with models that output flat vectors." ➝ LOL
##### Summary of the Conflict
- **Bronstein (2021):** "Respect the symmetry of the **input** (Translation, Rotation, Permutation)"
- **NLGS (2023):** "Respect the curvature of the **embedding** (Hierarchy, Cycle)"

#### VI. Checkpoint: Gradient Descent 
  
> Why is Gradient Descent (SGD) insufficient for finding the optimal latent geometry signature (e.g., switching from $\mathbb{E}^2$ to $\mathbb{H}^2$)?

Gradient Descent (SGD) ➝ requires a **continuous path**
We need to be able to make infinitesimally small adjustments to parameters ($w \leftarrow w - \alpha \nabla L$)

- **Problem:** We cannot **smoothly slide**  ➝ from a flat sheet ($\mathbb{E}^2$)  ➝ to a sphere ($\mathbb{S}^2$) ➝ they are topologically distinct ➝  it is a **Discrete Step** ➝  not a continuous slope
    - _Analogy_ 
    - You can walk smoothly from the bottom of a valley to the top of a hill (Continuous)
    - But you cannot walk smoothly from "Being a Square" to "Being a Circle" (Discrete Topology)
    - You have to _jump_
        
**This Paper's Genius:**
Since we cannot use gradients to slide between geometries, we need a way to measure **"How far is the jump?"**
- If we know that Manifold A ($\mathbb{H}^2$) is "close" to Manifold B ($\mathbb{H}^2 \times \mathbb{E}^1$), we can guess that if A is good, B might be good too.
- To measure that "closeness," they use the **Gromov-Hausdorff Distance**
##### Gradient Descent: The Geometrical Perspective: Gemini's Insight

> [!example] **Gradient Descent: The Geometrical Explanations**
> 
>- Geometrically ➝  Gradient Descent is **not** just  ➝ going downhill
> 	- It is a **projection operation** involving three distinct geometric objects: 
> 		- the **Manifold**, 
> 		- the **Tangent Space**,
> 		- the **Metric Tensor**
>--- 
> ##### 1. The Setup: Where do you actually stand?
> 
> Imagine the loss function $L(\theta)$ is a terrain (a scalar field) defined over a surface (the manifold $\mathcal{M}$). We are standing at a point $\theta_t$.
> - **Geometric Reality:** You cannot "look" at the whole manifold. You are an ant on a giant sphere. Locally, the world looks flat
> - **The Tangent Space ($T_\theta \mathcal{M}$):** This "local flatness" is the Tangent Space—a flat plane that touches the manifold _only_ at our current point $\theta_t$
>---     
> ##### 2. The Gradient: A Vector in the _Tangent Space_
> 
> This is the most common misconception. The gradient $\nabla L(\theta_t)$ does **not** live on the manifold. It lives in the **Tangent Space**
> - **The Math:** $\nabla L$ is a vector pointing in the direction of steepest ascent _within that flat tangent plane_.
> - **The Metric Tensor ($G$):** How do you know which direction is "steepest"? You need a ruler. The **Metric Tensor** $G(\theta)$ provides that ruler.
>     - In Euclidean GD, the ruler is constant ($I$).
>     - In Geometric GD, the ruler warps. 
>     - The true gradient is actually:
>         $$\nabla_{R} L = G^{-1}(\theta) \cdot \nabla_{E} L$$
>         
>     - _Translation:_ The geometry of the space ($G$) twists the raw derivative ($\nabla_E$) to point in the _true_ geometric direction.
>--- 
> ##### 3. The Step: The Exponential Map (Retraction)
> 
> This is the crucial part. You have a direction vector $v = -\eta \nabla L$ in your flat Tangent Space. You take a step along this straight arrow.
> - **The Problem:** If you walk in a straight line on the Tangent Plane, you fly off the manifold into the empty ambient space! (Imagine walking straight off the edge of the Earth).
> - **The Fix:** You need to "wrap" that straight line back onto the curved surface. This operation is called the **Exponential Map** (or Retraction):
>     $$\theta_{t+1} = \text{Exp}_{\theta_t}(v)$$
> - **Geometrically:** This maps the straight vector in $T_\theta \mathcal{M}$ to a **Geodesic** (the shortest curved path) on the manifold $\mathcal{M}$.
>---     
> ##### Summary: Geometric Gradient Descent
> 
> 1. **Stand** at point $\theta$.
> 2. **Construct** a flat Tangent Plane ($T_\theta$).
> 3. **Measure** the slope using the Metric Tensor ($G$) to find the arrow $v$
> 4. **Walk** along $v$ in the flat plane.
> 5. **Project (Retract)** that point back down onto the curved surface
>--- 
>- **Gradient Descent** (even Riemannian GD) **relies** on one fundamental assumption ➝  **Connectivity**
> 	- To move from $\theta_t$ to $\theta_{t+1}$, there must be a **continuous path** (a geodesic) connecting them
> 	- You can slide from any point on a Sphere to any other point on that Sphere
>---     
>- **The Paper's Problem:**
> 	- You want to find the _best geometry_
> 		- Candidate A: A Sphere ($\mathbb{S}^2$)
> 		- Candidate B: A Hyperboloid ($\mathbb{H}^2$)
>     
> - **The Geometric Block:**
> 	- There is **no continuous path** from a Sphere to a Hyperboloid.
> 		- You cannot use Gradient Descent to "slide" from positive curvature ($+1$) to negative curvature ($-1$).
> 		- Topologically, they are disjoint islands. You have to teleport.
>     
> - **Therefore:**
> 	- **Gradient Descent** optimizes your position _within_ one island (finding the minimum loss on _that_ specific geometry).
> 	    - **This Paper (NLGS)** builds a bridge _between_ the islands. It defines a "distance" (Gromov-Hausdorff) between the islands themselves so it can intelligently "hop" from the Sphere to the Hyperboloid.
#### VII. Computational Cost: What exactly is the product: H x S x E

>$\mathcal{M} = \mathbb{H}^{d_1} \times \mathbb{S}^{d_2} \times \mathbb{E}^{d_3}$
>**Question:** **Three components multiplied? That's O(n³). Why is this not computationally expensive?**
> That symbol isn't multiplication ➝ it is concatenation
##### I. Axiomatic: Product of Geometric Objects: Concatenation

> [!success] **Axiomatic: Product of Geometric Objects: Concatenation** 
>- A product of geometric objects ➝ consider: independent axes, block-diagonal structure, Pythagorean summary
>	- Not interaction 
>	- Concatenation
> 
>- Applications in 
> 	- Tensor product representations
> 	- Disentangled representation learning
> 	- Multi-modal embeddings
> 	- Product manifolds for knowledge graph embedding
> 	- Anywhere independence assumed
##### II. Gemini's Insight + My Deduction

> **The Trap**: Seeing the symbol **$\times$ (Cartesian Product)** ➝  first instinct ➝ Matrix Multiplication!  ➝ which is **$O(N^3)$ complexity**

> **The Reality**
>- In **Differential Geometry** ➝  when we say **Product Manifold ($\mathcal{M} = \mathbb{H} \times \mathbb{S} \times \mathbb{E}$)** ➝  we do **not** mean ➝  **multiply their coordinates** [X]
>	- We actually **concatenate** them
##### III. Orthogonal Decomposition of Distance 

> [!example] **Orthogonal Decomposition of Distance**
> 
> ###### Parallel Processing: NOT Interaction
> 
> Think of the Product Manifold like separate **lanes on a highway**
> - **Lane 1 ($\mathbb{H}^2$):** Handles the hierarchical features
> - **Lane 2 ($\mathbb{S}^1$):** Handles the cyclic features
> - **Lane 3 ($\mathbb{E}^5$):** Handles the linear features
> 
> A point $x$ in this combined space is just a list of independent coordinates:
> 
> $$x = [h_1, h_2, s_1, e_1, e_2, e_3, e_4, e_5]$$
> 
> ###### The Metric splits (Block-Diagonal)
> 
> Because the manifolds are orthogonal (independent), the "Metric Tensor" (the ruler) is **Block-Diagonal**
> Instead of one giant, messy matrix multiplication where everything interacts with everything, it looks like this:
> $$G = \begin{bmatrix} g_\mathbb{H} & 0 & 0 \\ 0 & g_\mathbb{S} & 0 \\ 0 & 0 & g_\mathbb{E} \end{bmatrix}$$
> 
>- **The Consequence:** To calculate the total distance between two points, you just calculate the distance in each lane **independently** and add them up 
> 	-  the Pythagorean theorem
> $$d^2_{total}(x, y) = d^2_\mathbb{H}(x_h, y_h) + d^2_\mathbb{S}(x_s, y_s) + d^2_\mathbb{E}(x_e, y_e)$$
> 
> ###### Computational Cost
> 
> - **Matrix Multiplication:** $O(D^3)$ (Nightmare)
> - **Product Manifold:** $O(D)$ (Linear)
> - This means ➝ we are just running 3 smaller, simpler distance calculations in parallel
> 	- tt is actually **faster** than calculating a complex distance on a single high-dimensional manifold ➝ because the sub-dimensions are smaller
>---  
>- **It is just the Pythagorean Theorem applied to curved spaces**: **Orthogonal Decomposition of Distance**
> 
> - Instead of $a^2 + b^2 = c^2$, it is:
> 
> $$(\text{Hyperbolic Distance})^2 + (\text{Spherical Distance})^2 + (\text{Euclidean Distance})^2 = (\text{Total Distance})^2$$
> 
>- The axes are orthogonal (independent), just like the legs of a triangle
>- You travel along one, then the other

---
### 4. Section II: Background 

This section defines the **Toolkit** the authors will use. It establishes the mathematical language for two things:
1. **The Shapes** they are building with ➝ **Product Manifolds**
2. **The Ruler** they are measuring with ➝ **Hausdorff and Gromov-Hausdorff Distances** for **Comparing Manifolds**

#### 1. Constant Curvature Model Spaces: The Lego Blocks

> The authors do not use just any geometry
> They restrict themselves to **Riemannian Manifolds with Constant Sectional Curvature ($K$)**

- **Why "Constant"?**
	- Because these spaces are perfectly uniform. 
	- Every point looks exactly the same as every other point. 
	- This symmetry allows for closed-form formulas (fast computation)
##### I. Imposed Geometrical Restrictions: 3 Model Spaces 

- They define three specific **Model Spaces** ($\mathcal{M}_K^d$) based on the sign of $K$:
	1. **Euclidean Space ($\mathbb{E}^d$):** 
	    - **Curvature:** $K = 0$
	    - **Model:** Standard vector space $\mathbb{R}^d$
	    - **Distance:** The straight line (L2 norm). $\|x - y\|$
	    - **Intuition:** The "default" flat world
	        
	2. **Hyperbolic Space ($\mathbb{H}^d_K$):**
	    - **Curvature:** $K < 0$ (Negative)
	    - **Model Used:** **Poincaré Ball Model ($\mathbb{D}_{K}^d$)**
	        - Imagine the entire infinite universe squashed into a finite ball of radius $1/\sqrt{-K}$
	    - **Distance:** As you get closer to the edge of the ball, distances grow towards infinity. You can never actually reach the edge
	    - **Intuition:** This creates "exponentially more space" near the boundary, perfect for fitting the exponentially growing nodes of a tree
	        
	3. **Spherical Space ($\mathbb{S}^d_K$):**
	    - **Curvature:** $K > 0$ (Positive)
	    - **Model Used:** **Projected Sphere Model ($\mathbb{P}_{K}^d$)**
	    - **Distance:** The shortest path is a "Great Circle" (like an airplane route)
	    - **Intuition:** If you walk far enough in one direction, you come back to where you started. Perfect for cycles
        
##### II. The Product Manifold Formulation

This is formally defined here:
$$\mathcal{M} = \bigtimes_{i=1}^N \mathcal{M}_{K_i}^{d_i}$$

- **Key Note:** The resulting manifold $\mathcal{M}$ is a "Product Metric Space." The distance between two points $x, y \in \mathcal{M}$ is the Pythagorean sum of the distances in each component space.
    

![[Pasted image 20260212071725.png | 600]]

>Schematic of a manifold $M$ and open subsets $U_{i}$ and $U_{j}$ 
>An open chart is a homeomorphism of an open subset of the manifold onto an open subset of the Euclidean hyperplane
>Here, $ψ_{ij}$ is a transition function

---
######  III. Riemannian Manifolds: Conceptual Description

Think of an **Ant walking on a giant Apple.**

- **Manifold:** To the ant, the apple looks flat locally. It can walk forward, backward, left, or right. It thinks it is on a 2D plane. But globally, the apple is curved. A **Manifold** is simply a shape that looks like flat Euclidean space if you zoom in close enough.
    
- **Riemannian:** This adds a **Ruler** (Metric) to the surface.
    
    - On a flat sheet of paper (Euclidean), the ruler is constant everywhere. 1 inch is 1 inch.
        
    - On a Riemannian Manifold, the ruler **warps** depending on where you stand.
        
    - _Example:_ If you look at a Mercator map of the world, Greenland looks huge. Why? Because the "Ruler" (Metric) at the poles is stretched. A Riemannian Manifold is a surface where we know _exactly_ how much the ruler stretches at every single point.
        

**Formal Definition:** A Riemannian Manifold is a smooth space equipped with a **Metric Tensor** ($g$) that allows you to measure distances and angles at every point.

**Significance for this Paper:**

The paper's entire premise is that different datasets have different intrinsic curvatures.

- **Hierarchies (Trees):** Have **Negative Curvature**. (Imagine the branches spreading out—you need more space as you go deeper).
    
- **Cycles (Seasons):** Have **Positive Curvature**. (Patterns repeat and come back to the start).
    
- **Grids (Images):** Have **Zero Curvature**. (Translation invariance).

######  IV. Hyperbolic Space: Conceptual Description


Hyperbolic Space is a specific _type_ of Riemannian Manifold. It is the "Opposite of a Sphere."

- **Sphere (Positive Curvature):** Parallel lines eventually meet (think longitude lines at the North Pole). Space closes in on itself.
    
- **Euclidean (Zero Curvature):** Parallel lines never meet.
    
- **Hyperbolic (Negative Curvature):** Parallel lines **diverge** (move apart) exponentially.
    

**The "Saddle" Analogy:**

Imagine a Pringle (potato chip) or a saddle. If you put two marbles side-by-side on the saddle and roll them "forward," they will roll away from each other.

- **Why it matters for AI:** In a standard flat space, the amount of "room" you have grows polynomially ($r^2$). In Hyperbolic space, the amount of room grows **exponentially** ($e^r$).
    
- This makes it perfect for **Trees and Hierarchies**. A family tree grows exponentially (2 parents, 4 grandparents, 8 great-grandparents...). You can fit that infinite tree into a Hyperbolic space perfectly without crushing the nodes together.
    

_(Look at the image: The triangles get smaller near the edge. That is the "infinite space" being squashed into a finite view. The ruler there is "tiny," so a small step covers a huge logical distance.)_

### **3. How are they connected?**

- **Riemannian Manifold** is the **Category** (like "Vehicle").
    
- **Hyperbolic Space** is a **Specific Instance** (like "Ferrari").
    
- Hyperbolic Space is just a Riemannian Manifold where the "Curvature" is set to a constant **-1**.
    

### **4. Why restrict themselves to Riemannian Manifolds?**

Why not use something weirder?

**Because we need to do Calculus (Gradient Descent).**

- **Smoothness:** To train a Neural Network, we need to take derivatives (gradients). You cannot take a derivative on a jagged, broken surface. Riemannian Manifolds are defined to be **Smooth** and **Differentiable**.
    
- **The "Ruler" Exists:** To minimize loss ("go downhill"), you need to know which way is down and how far "1 step" is. The Riemannian Metric gives you that ruler. Without it, Gradient Descent is impossible.
    

### **5. Are they all-inclusive?**

**Yes, for continuous data.**

The **Uniformization Theorem** (a famous math law) effectively says that _any_ simple, smooth 2D surface is just a variation of these three geometries:

1. **Euclidean** (Flat)
    
2. **Spherical** (Positive Curvature)
    
3. **Hyperbolic** (Negative Curvature)
    

By using these three as building blocks, the authors aren't just picking random shapes; they are covering the **fundamental basis** of all possible smooth geometries. It is like using Red, Green, and Blue pixels to make any color.

---
#### 2. Gromov-Hausdorff Distance (The "Ruler")

[The Complexity of the Hausdorff Distance](https://arxiv.org/abs/2112.04343)

Now that we have the shapes, we need to measure the distance **between two shapes**.

**The Gold Standard: Isometry**

Two metric spaces $(X, d_X)$ and $(Y, d_Y)$ are **Isometric** if there exists a bijection (a perfect mapping) $f: X \to Y$ that preserves all distances.

- _Translation:_ Shape X and Shape Y are identical, just named differently.
    
- _Mathematical Goal:_ We want a distance metric $D(X, Y)$ that is **0** if and only if $X$ and $Y$ are isometric.
    

**The Metric: Gromov-Hausdorff Distance ($d_{GH}$)**

Since we can't always overlap them perfectly, $d_{GH}$ measures "how close we can get."

**The Definition (Simplified):**

1. **Embed:** Take both Space X and Space Y and put them into a giant "Ambient Metric Space" $Z$.
    
2. **Align:** Rotate and shift them in $Z$ to get them as close as possible.
    
3. **Measure:** The **Hausdorff Distance ($d_H$)** is the maximum distance from any point in X to the nearest point in Y (and vice versa).
    
4. **Optimize:** The **Gromov-Hausdorff Distance ($d_{GH}$)** is the _smallest possible_ Hausdorff distance you can achieve by trying _every possible_ embedding and alignment.
    

$$d_{GH}(X, Y) = \inf_{Z, f, g} d_H^Z(f(X), g(Y))$$

**The Catch:**

Calculating this "infimum over all possible embeddings" is **NP-Hard**. It is computationally impossible to do exactly for complex spaces.

- _This sets the stage for Section 3, where they introduce the "Spectral" approximation to solve this._
    

---

##### **Checkpoint: Section 2 Mastery**

> **Question> Why is the **Poincaré Ball model** specifically mentioned for Hyperbolic space? Why not just say "Hyperbolic Space"?


 

---

