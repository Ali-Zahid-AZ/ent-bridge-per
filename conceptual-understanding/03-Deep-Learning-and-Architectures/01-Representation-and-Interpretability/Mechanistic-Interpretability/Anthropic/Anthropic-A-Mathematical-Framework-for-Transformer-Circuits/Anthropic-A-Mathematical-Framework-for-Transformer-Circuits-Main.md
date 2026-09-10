---
tags:
  - dl-ml-mathematics
  - llm-lrm-mathematical-foundations
  - llm-transformer-architecture
  - mechanistic-interpretability-reasoning-circuits
  - reading-list
  - llm-foundational-texts
  - llm-residual-stream-additive-shared-communication-channel
---

---
```table-of-contents
```
---
### References 

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

- **Website** ➝ [A Mathematical Framework for Transformer Circuits](https://transformer-circuits.pub/2021/framework/index.html)
- [[Conceptual-Residual-Stream-Geometric-Mechanistic]]
- [[Anthropic-In-Context-Learning-and-Induction-Heads]]
- A large understanding of the article is done in ➝ [[Month-0-Week-1-Topology-of-Networks]]
---
### 1. Rudimentary Explanations

- **The Problem** 
	- We lack a **formal, mathematical way** to decompose Transformers into human-understandable programs
	- The "black box" nature of high-dimensional weights makes direct inspection impossible
    
- **The Solution** 
	- Treat the Transformer as a collection of "circuits" 
	- Define the **Residual Stream** as a communication channel where Attention Heads act as independent operators that read/write vectors
    
- **Key Methodology:** * **Linearity Assumption:** Modeling the residual stream as a vector space where addition is the primary operation.
    
    - **QK/OV Decomposition:** Splitting the attention mechanism into two separate circuits (where to look vs. what to say).
        
    - **Eigenvalue Analysis:** Using mathematical axioms to explain how information is "composed" across layers.
        
- **Significance:** It provides the "Standard Model" of MI. Without this paper, concepts like Induction Heads, Logit Lens, and even the 2025 "Linebreaks" manifolds wouldn't have a mathematical basis.
    
- **Personal Importance (The 11 Principles):** This is the origin of the **Circuit Analysis** and **Geometry of Activation Spaces** frameworks. It's the "lattice structure" upon which all your other MI knowledge is built.

---

