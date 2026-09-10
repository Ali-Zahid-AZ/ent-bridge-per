---
tags:
  - riemannian_manifolds
  - hyperbolic_spaces
  - differential_geometry
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

- [[Conceptual-Riemannian-Manfolds]]
- [[Conceptual-Hyperbolic-Space]]
- 
---


### **1. The Comprehensive Review (Start Here)**

**Title:** **_"Hyperbolic Large Language Models"_**

- **Authors:** Sarang Patil, Zeyong Zhang, et al.
    
- **Date:** September 2025
    
- **Link:** [arXiv:2509.05757](https://arxiv.org/abs/2509.05757)
    

**Why this is the one:**

This paper is not just a list of citations; it builds a **Taxonomy** of how Riemannian geometry is currently applied to LLMs. It breaks the field down into four distinct "Architecture Styles" which you can use to organize your mental model:

- **Type 1: Input/Output Wrappers (The "Lite" Approach)**
    
    - _Concept:_ Keep the Transformer Euclidean (standard matrix math), but project the input embeddings into Hyperbolic space and map the output back.
        
    - _Pros:_ Easy to implement with existing pre-trained models (LLaMA, GPT).
        
- **Type 2: Hyperbolic Fine-Tuning (The "Adapter" Approach)**
    
    - _Concept:_ Freeze the massive Euclidean weights. Only learn a small "Hyperbolic Adapter" (like LoRA, but on a manifold) to capture the hierarchy of the specific downstream task.
        
- **Type 3: Fully Hyperbolic LLMs (The "Native" Approach)**
    
    - _Concept:_ Rewrite the entire Attention Mechanism to operate on the Manifold using **Gyro-vector spaces** (Möbius addition instead of vector addition).
        
    - _Cons:_ Computationally expensive; still experimental.
        
- **Type 4: Hyperbolic State-Space Models (The "Hybrid" Approach)**
    
    - _Concept:_ Combining Mamba/SSMs (which are continuous) with Hyperbolic geometry.
        

---

### **2. The "Must-Read" Application Papers (Deep Dives)**

Once you read the survey, you need to see it in action. These two papers show exactly _how_ the math improves the model.

#### **A. For Fine-Tuning: "HypLoRA"**

**Title:** **_"Hyperbolic Fine-Tuning for Large Language Models"_** (NeurIPS 2025)

- **The Insight:** They analyzed LLaMA's token embeddings and found they **naturally form a tree**.
    
    - High-frequency tokens (like "the", "is") cluster near the origin (Root).
        
    - Low-frequency, specific tokens (like "pomegranate", "quantum") are pushed to the edge (Leaves).
        
- **The Fix:** Standard LoRA (Low-Rank Adaptation) assumes flat updates. **HypLoRA** performs the update steps on the **Poincaré Ball**.
    
- **Result:** Massive gains in **Reasoning Tasks** (where A implies B implies C) because the geometry enforces the logical hierarchy.
    

#### **B. For Inference: "RiemannInfer"**

**Title:** **_"RiemannInfer: Improving Transformer Inference through Riemannian Geometry"_** (January 2026)

- **The Insight:** The "Attention Map" in a Transformer can be viewed as defining a **metric tensor** on the sequence of tokens.
    
- **The Innovation:** Instead of just picking the next token with the highest probability (Softmax), they treat the inference process as **finding a Geodesic path** (shortest curve) on the manifold defined by the attention weights.
    
- **Significance:** This is one of the first papers to use Riemannian geometry for the _decoding strategy_ (inference) rather than just the training.
    

---

### **3. The "Gemini" Synthesis**

To save you time, here is the synthesis of these papers into your **"Riemannian Perspective"**:

1. **The Embedding Space is a Hyperboloid:**
    
    LLMs naturally learn to shove "general" concepts to the center and "specific" concepts to the edge. Euclidean space runs out of room at the edge (volume grows as $r^n$). Hyperbolic space has infinite room at the edge (volume grows as $e^r$).
    
2. **The Attention Mechanism is a Metric:**
    
    When Token A attends to Token B, it is effectively "shortening the distance" between them in the manifold. A Transformer is just a dynamic engine for warping space to bring related concepts close together.
    
3. **The Optimization is Manifold-Constrained:**
    
    When we fine-tune, we shouldn't just add a random vector $\Delta W$. We should move $W$ along a **Geodesic** on the manifold of "Valid Language Models." This prevents "Catastrophic Forgetting" because we aren't jumping off the manifold into "Gibberish Space."
    

**Recommendation:**

Start with **Patil et al. (2025)**. It references almost everything else and gives you the broad map. Then read **HypLoRA** to see the code-level implementation of the math we discussed (Tangent Spaces/Exponential Maps).