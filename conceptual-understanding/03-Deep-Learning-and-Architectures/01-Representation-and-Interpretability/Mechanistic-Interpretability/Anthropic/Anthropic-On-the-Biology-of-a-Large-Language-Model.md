---
tags:
  - reading-list
  - anthropic-research
  - llm-internal-memory
  - mechanistic-interpretability
  - index/mechanistic-interpretability
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

- Anthropic Research Online ➝ [Anthropic: On the Biology of a Large Language Model](https://transformer-circuits.pub/2025/attribution-graphs/biology.html)
- [[00-Index-Anthropic-Research]]
- [[Anthropic-A-Mathematical-Framework-for-Transformer-Circuits-Main]]
- [[Anthropic-In-Context-Learning-and-Induction-Heads]]
- [[Anthropic-Toy-Models-of-Superposition-Main]]
- [[Anthropic-When-Models-Manipulate-Manifolds-The-Geometry-of-a-Counting-Task]]

---
