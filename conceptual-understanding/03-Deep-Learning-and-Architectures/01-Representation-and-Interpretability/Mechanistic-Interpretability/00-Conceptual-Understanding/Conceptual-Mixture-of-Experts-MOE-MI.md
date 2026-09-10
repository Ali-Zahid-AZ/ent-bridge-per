---
tags:
  - mechanistic-interpretability
  - conceptual-explanations
  - llms-mixture-of-experts-moe
  - mechanistic-interpretability-moe
---

---
```table-of-contents
```
---
### References



> [!info] .
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
> 




---
### Primitives 

- [[Conceptual-Basics-Anatomy-of-Compute-Feature-Manifolds-Circuit-Topologies]]
  
  
---



**The Problem:** Scaling dense neural networks yields diminishing returns; compute and memory costs scale linearly with parameter count, creating an insurmountable hardware bottleneck for training and deploying trillion-parameter models.

**The Solution:** Mixture-of-Experts (MoE) architectures decouple the total parameter count from the active computation required per token by introducing conditional, sparse routing.

**Key Methodology:** Replacing standard dense MLP layers with parallel "expert" MLPs and a gating (routing) network. The router uses mechanisms like Noisy Top-$k$ Softmax to dynamically assign tokens to a small subset of experts, heavily relying on auxiliary load-balancing losses to prevent routing collapse.

**Significance:** This is the foundational architecture of the current frontier models (e.g., DeepSeek-V3, Mixtral, Gemini). Understanding its mechanics is mandatory for mapping how scale interacts with feature geometry and capacity.

**Layman Explanation**

Imagine a massive hospital. In a "dense" hospital, every single doctor must briefly examine every single patient that walks through the door. This is incredibly slow and expensive. In an "MoE" hospital, the patient first meets a highly efficient triage nurse (the Router). The nurse looks at the patient's symptoms (the token's embedding) and sends them only to the two specific specialists (the Experts) suited for their ailment. The hospital can hire thousands of doctors (massive capacity/parameters) without increasing the time each patient spends getting treated (active compute).

**Technical Explanation (First Principles)**

At its core, an MoE layer transforms the standard feed-forward network (FFN) operation. Instead of a single mapping $F(x)$ from dimension $d$ to $d_{mlp}$, the architecture initializes $N$ independent FFNs: $E_1, E_2, \dots, E_N$.

A parameterized gating function $G(x)$ projects the incoming token representation $x$ into an $N$-dimensional vector of probabilities. The output of the layer is a weighted sum of the experts:

$$y(x) = \sum_{i=1}^{N} g_i(x) \cdot E_i(x)$$

To ensure sparsity, $G(x)$ is forced to output zeros for all but the top $k$ values. This means the matrix multiplications inside the unselected experts are entirely skipped. The model learns to carve the continuous embedding space into discrete routing regions.

**Methods Used**

- **Noisy Top-$k$ Routing:** Adding Gaussian noise to the routing logits before the top-$k$ selection encourages exploration during training, preventing the model from prematurely locking into suboptimal routing paths.
    
- **Load Balancing Regularization:** Auxiliary loss functions, such as $\mathcal{L}_{LB} = N_E \sum_{i=1}^{N_E} m_i P_i$, penalize the network if a few experts receive all the traffic, forcing a uniform distribution of tokens across the available parameter space.
    
- **Expert Evolution & Orthogonalization:** Advanced techniques involve initializing from dense checkpoints (upcycling) and mathematically forcing the weight matrices of different experts to remain orthogonal, preventing redundant feature learning.
    

**Results**

MoE models routinely match or exceed the accuracy of dense models that require vastly more compute. For example, a model with 47B total parameters might only activate 13B parameters per token, achieving the reasoning capabilities of a 50B dense model but running at the speed and cost of a 13B model.

**Connection to Mechanistic Interpretability (MI)**

MoEs are a structural intervention on _superposition_. By explicitly increasing the parameter count without increasing the active dimensional bottleneck, MoEs provide distinct, physical sub-spaces for features to reside in. Analyzing the gating network offers a highly privileged window into the model's feature clustering: by understanding what activates a specific expert, we can observe macroscopic "feature neighborhoods" forming.

**Stress Test (Good Practices & Applicability)**

- **Applicability:** Extremely high. This is the defacto standard for scaling post-GPT-4.
    
- **Good Practices:** The literature correctly identifies that without aggressive load balancing ($\mathcal{L}_{LB}$), MoEs fail due to "representation collapse" (the rich-get-richer problem where a few experts get all gradients and others die). The use of capacity factors (dropping tokens if an expert's queue is full) is a necessary, albeit physically messy, engineering hack to keep hardware utilization high.
    
- **Weaknesses:** All-to-all communication. In distributed training, tokens must be sent across GPUs to where their assigned expert lives. This creates a massive networking bottleneck that often overshadows the compute savings if not handled via specialized CUDA kernels and topology-aware sharding.
    

**Is it worth your time?**

Absolutely. You cannot design or interpret modern frontier models without a rigorous understanding of sparse routing dynamics.

---

## Part 2: Exhaustive Note on MoE (Architectural + MI Perspective)

To master MoEs from the ground up, we must observe them not just as engineering optimizations, but as geometric routing systems operating on the residual stream.

#### 1. The Mechanics of the Gating Network

The gating network $G(x)$ is simply a linear projection from the residual stream dimension $d_{model}$ to the number of experts $N$, followed by a Softmax.

Let $W_g$ be the routing weights. The routing logits are $h(x) = W_g \cdot x$.

- **The Geometry:** $W_g$ consists of $N$ direction vectors in the activation space. The router is essentially computing the cosine similarity (plus magnitude) between the token's current state in the residual stream and these $N$ direction vectors.
    
- **Voronoi Tessellation:** By using a Top-$k$ mechanism, the router divides the high-dimensional activation space into intersecting decision boundaries. If a token's vector lands in a specific region, it is routed to Expert $i$.
    

#### 2. The Mechanics of Representation Collapse (The Dead Expert Problem)

If left unregularized, MoEs mathematically naturally degrade.

- **The Feedback Loop:** If Expert $A$ is randomly initialized slightly better at processing verbs than Expert $B$, the router $G(x)$ learns to send verbs to $A$. Expert $A$ then receives gradients for verbs and gets _even better_. Expert $B$ receives no verb tokens, receives no gradients, and learns nothing.
    
- **The Result:** The router's weights for $A$ grow larger, pulling in more tokens. Expert $B$ becomes "dead."
    
- **The Fix:** This is why $\mathcal{L}_{LB}$ (Load Balancing Loss) is non-negotiable. It forces the router to spread tokens, acting as a repulsive force against the natural gravity of early-converging experts.
    

#### 3. Mechanistic Interpretability: MoEs and Superposition

In dense models, the MLP layers act as key-value memories. Because the number of features the model needs to learn far exceeds the MLP hidden dimension ($d_{mlp}$), the model relies heavily on _superposition_—compressing multiple unrelated features into almost-orthogonal vectors within the same space.

- **Relieving the Pressure:** MoEs expand the total $d_{mlp}$ by a factor of $N$. If $N=8$, the model has 8 times the "storage space" for features. Because tokens only route to 1 or 2 experts, features that rarely co-occur in the same token context can be stored in completely different experts without interfering with each other.
    
- **Polysemanticity Reduction?** A central MI hypothesis is that MoE experts should be more _monosemantic_ (interpretable) than dense MLPs. However, empirical MI research (e.g., Anthropic's work on routing) shows that experts rarely align with clean human concepts (like "The Biology Expert").
    
- **Shallow vs. Deep Routing:** Early layer experts tend to route based on syntax (e.g., punctuation tokens go to Expert 1, verbs to Expert 2). Middle layers route based on shallow semantics. Late layers often exhibit highly polysemantic routing, optimizing for the final vocabulary projection rather than clean semantic separation.
    

#### 4. Applying MI Tools to MoEs

To reverse-engineer an MoE, standard MI toolkits must be adapted:

- **Logit Lens on the Router:** If we take the weight matrix of the router $W_g$ and multiply it by the unembedding matrix $W_U$, we can project the "routing directions" directly into vocabulary space. This tells us precisely which tokens heavily activate which experts, providing a macroscopic view of the model's clustering strategy.
    
- **Circuit Analysis Intersections:** How do Attention Heads interact with MoEs? If an Induction Head fires and moves a specific feature $f$ into the residual stream, the MoE router in the next layer must have a vector in $W_g$ that aligns with $f$ to trigger the correct expert. Tracing the covariance between specific attention head outputs and specific expert activations reveals the macroscopic circuitry of the model.
    

#### 5. Architectural Variations & Evolution

- **Multi-Head MoE (MH-MoE):** Instead of routing the whole token $x$, the token is split into multiple sub-vectors (heads), and each is routed independently. This massively increases the combinatorial capacity of the model and forces even finer-grained feature separation.
    
- **Orthogonalization:** Techniques like OMoE (Liu et al., 2023) add a loss term that penalizes the cosine similarity between the weight matrices of different experts. From an MI perspective, this forcefully pushes experts to map to entirely different sub-manifolds in the feature space, guaranteeing diversity.


----


This comprehensive search identifies the cutting-edge Mechanistic Interpretability (MI) research focused specifically on Mixture-of-Experts (MoE) architectures between 2025 and early 2026. The field has moved beyond treating MoE models as simple sparse variants of dense models, developing tools that explicitly account for **routing entropy**, **expert specialization**, and **cross-node communication bottlenecks**.

---

## I. Sparse Autoencoder (SAE) & Transcoder Advancements

SAEs remain the primary tool for disentangling superposition, but recent work has adapted them for the sparse nature of MoE experts.

1. **Sparse Crosscoders for diffing MoEs and Dense Models (March 2026)**
    
    - **Exact Method:** This research utilizes **BatchTopK Crosscoders** with explicitly designated **Shared Features**. Crosscoders jointly model multiple activation spaces (e.g., across layers or model versions).
        
    - **Key Innovation:** By designating specific latents as shared across the "Shared Expert" and "Routed Experts," researchers can isolate which features are truly domain-specific versus architectural commonalities.
        
    - **First Principle Realized:** **Feature Locality**. MoEs learn significantly fewer unique features than dense models because the routing mechanism enforces a tighter "information bottleneck," leading to higher activation density in specific experts.
        
2. **Causal Feature-to-Feature Circuit Tracing (March 2026)**
    
    - **Exact Method:** Extends **Activation Patching** and **Sparse Feature Circuits** (Marks et al., 2024) to MoEs by systematically **ablating source SAE features** at specific depths to measure the change in downstream feature logits.
        
    - **Finding:** It identifies "Inhibitory Dominance" in reasoning circuits, where specific experts act as "gatekeepers" that suppress irrelevant semantic manifolds during complex logic tasks.
        

---

## II. Routing Dynamics & Expert Specialization Probes

These methods focus on the "Model inside a Model" (the router) and how it organizes human knowledge.

3. **MoE Lens - An Expert Is All You Need (March 2026)**
    
    - **Exact Method:** Combines **Early Decoding (Logit Lens)** with **Expert-Usage Profiling**.
        
    - **Procedure:** It applies the model's pre-trained unembedding matrix $W_U$ to the hidden states $h_t$ _immediately after_ the routing decision but _before_ expert execution.
        
    - **Significant Finding:** MoE models exhibit **Concentrated Expertise**; for specific domains like "Quantum Chemistry" or "Lattice Dynamics," the model's logic is often localized to a single digit number of experts across all layers, making them easier to prune or steer.
        
4. **Multilingual Routing Interventions (October 2025 / March 2026)**
    
    - **Exact Method:** Analyzes routing patterns using **Parallel Multilingual Datasets**. It calculates the **Routing Divergence** (U-shaped curve) across layers.
        
    - **The Intervention:** Researchers promote "Language-Universal" middle-layer experts (frequently activated in English) at inference time to improve multilingual performance in zero-shot tasks.
        

---

## III. Circuit Analysis & Reasoning Manifolds

For your **Project Aletheia** and **Project-Noesis-Causal-Circuits**, these papers provide the formal mathematical framework for "Truth" and "Reasoning."

5. **REMA: Reasoning Manifold Framework (January 2026)**
    
    - **Exact Method:** Defines the **Reasoning Manifold** as a low-dimensional geometric structure formed by representations of _correctly_ reasoned tokens.
        
    - **Evaluation Metric:** Uses **k-Nearest Neighbors (k-NN) Distance** to quantify the geometric deviation of an "Erroneous" representation from the "Truth" manifold.
        
    - **MI Connection:** It localizes the **Divergence Point** where the model's reasoning chain first drifts into the "Hallucination" space.
        
6. **Circuit-based Reasoning Verification (CRV) (OpenReview 2025)**
    
    - **Exact Method:** Treats **Attribution Graphs** as execution traces. It uses autoencoders to encode MLP/Expert layers and constructs a computational graph of the trace.
        
    - **Significance:** It detects errors in reasoning paths by identifying subgraphs that do not align with the established functional interpretations of those experts.
        
7. **Scaling Sparse Feature Circuits for In-Context Learning (2025/2026)**
    
    - **Exact Method:** Adapts the attribution methodology to 2B+ models (like your **Distilled DeepSeek** targets).
        
    - **Procedure:** Discovers "Task-Detecting" SAE latents that activate early in a prompt to "configure" the downstream experts for a specific context (e.g., switching from "Coding Mode" to "Proving Mode").
        

---

## IV. Intrinsic Interpretability & Architecture

This research explores models that are "interpretable by design" rather than post-hoc.

8. **MoE-X: Intrinsically Interpretable Mixture of Experts**
    
    - **Exact Method:** Rewrites the MoE layer as an **Equivalent Sparse Large MLP**. It enforces high **Activation Sparsity** within each expert and redesigns the routing to prioritize experts that have already specialized.
        
    - **Result:** It achieves interpretability levels surpassing traditional post-hoc SAE-based methods because the "features" are forced into individual experts at training time.
        

---

## Significance for Your Goals

- **DeepSeek V3/V3.2 Synergy:** The **Auxiliary-Loss-Free** strategy you noted in the Technical Report is cited in the 2026 literature as the gold standard for creating the "monosemantic" experts required for **Crosscoder** analysis.
    [[DeepSeek-V3-V3.2-Technical-Report-Model-Architecture]]
    
- **Applicability to Phoenix Hardware:** While you cannot run the 671B model, the **CRV** and **Logit Lens for MoE** methods are highly applicable to the 7B/14B distilled versions you plan to use.
    

**Worth your time?**

**Yes.** Specifically, focus on **REMA** (Reasoning Manifolds) for your "Truth" probing and **Crosscoders** to see how your "Shared Expert" baseline separates syntax from the domain-specific physics manifolds you are tracking.