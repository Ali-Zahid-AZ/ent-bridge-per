---
tags:
  - anthropic-research
  - reading-list
  - llm-neural-signatures
  - mechanistic-interpretability-superposition
  - mechanistic-interpretability
  - mechanistic-interpretability-theories
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

- [When Models Manipulate Manifolds: The Geometry of a Counting Task](https://transformer-circuits.pub/2025/linebreaks/index.html#discussion)
---

| **MI Subdomain**                   | **Relevance to this Paper**                                                                                   |
| ---------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| **Circuit Analysis**               | High: It identifies the "Linebreak Circuit" from embeddings to logits.                                        |
| **Superposition Theory**           | Critical: It explains how "rippled" manifolds allow the model to pack more information into fewer dimensions. |
| **Mechanistic Topology**           | High: It views the counting task as a topological problem (a 1D line winding through space).                  |
| **Developmental Interpretability** | Moderate: It touches on how these "canonical" structures emerge during training (anchoring points).           |


---
