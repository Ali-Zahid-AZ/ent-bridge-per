---
tags:
  - llm-manifolds-geometric-perspective
  - llm-manifolds-geometric-perspective
  - tegmark
  - llm-manifolds-geometric-perspective
  - llm-foundational-texts
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
S>
>**[Back Links]**
> `$= dv.list(dv.current().file.inlinks)`

---
### Primitives 

- Pdf in Directory: [Dir: Language-Models-Use-Trigonometry-to-Do-Addition-Kantamneni-Tegmark.pdf](<file:///home/az/04-Library/03-Deep-Learning-and-Architectures/01-Representation-and-Interpretability/LLM-Mechanistic-Interpretability/Circuits/Language-Models-Use-Trigonometry-to-Do-Addition-Kantamneni-Tegmark.pdf>)
- GitHub Implementation ➝ [GitHub ➝ LLMs represent numbers on a helix and manipulate that helix to do addition](https://github.com/subhashk01/LLM-addition)
- arXiv ➝ [arXiv ➝ Language Models Use Trigonometry to Do Addition](https://arxiv.org/abs/2502.00873)
- Project Implementation ➝ [[Project-Helical-Clock-Main]]
- [[Coiling-Arithmetic-On-the-Differential-Geometry-of-Helical-Representations-in-LLMs-Sienicki]]
- 
