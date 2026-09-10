---
tags:
  - index/mechanistic-interpretability
  - index/llms
  - index/deeplearning_core
---

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

- [[Conceptual-Axiom-MI-Geometric-Constraints]]

---

> [!success] **Mechanistic Interpretability & Circuit Analysis**
> - **Core Focus Areas:**
>     - **Circuit Discovery:** Reverse-engineering the computational graph into human-understandable sub-modules (e.g., Induction Heads, Name Mover Heads, MLP Key-Value Memories).
>     - **Representation Geometry:** Decoding the internal language of the model, specifically exploring Manifold Theory, Linear Representations, and the `Geometry of Truth.`
>     - **Causal Intervention:** Moving beyond correlation to causation via Activation Patching, Steering Vectors, and Ablation studies to prove specific mechanisms.
> - **Concepts**
>     - Residual Stream (The Communication Bus)
>     - Superposition & Polysemanticity
>     - Sparse Autoencoders (SAEs)
>     - Key-Value Memories (Zone 2)
>     - Induction Heads
> - **Goal** ➝ Turning Alchemy into Anatomy (White-box understanding)
> - **Mech Interp (The Neuroscience/Debugging)** ➝ **What is the engine thinking?**

---
**Directory** ➝  [📂 Open: Mechanistic-Interpretability](<file:///home/az/04-Library/03-Deep-Learning-Core/03-Architectures/LLMs/Mechanistic-Interpretability>)

---
```dataview
TABLE 
    regexreplace(file.folder, ".*\/", "") AS "Category", 
    file.mday AS "Last Modified"
FROM "04-Library/03-Deep-Learning-and-Architectures/01-Representation-and-Interpretability/LLM-Mechanistic-Interpretability"
WHERE file.name != this.file.name
SORT file.mday DESC
```
