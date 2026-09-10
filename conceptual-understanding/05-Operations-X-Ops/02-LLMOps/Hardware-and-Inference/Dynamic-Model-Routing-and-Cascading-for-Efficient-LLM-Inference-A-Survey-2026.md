---
tags:
  - llmops-agentops-inference
  - research-article
  - research-2026
  - review-survey-articles
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

- arXiv: [arXiv: Dynamic Model Routing and Cascading for Efficient LLM Inference: A Survey](https://arxiv.org/abs/2603.04445)
- Pdf in Directory: [Dir: Dynamic-Model-Routing-and-Cascading-for-Efficient-LLM-Inference-A-Survey-2026.pdf](<file:///home/az/04-Library/05-Operations-X-Ops/02-LLMOps/Hardware-and-Inference/Dynamic-Model-Routing-and-Cascading-for-Efficient-LLM-Inference-A-Survey-2026.pdf>)

---
> #llmops-agentops-inference-multi-LLM-routing | #llmops-agentops-inference-cascading  

> contrast to mixture-of-experts architectures ➝ which route within a single model 
> multi-LLM routing ➝ routes across multiple independently trained LLMs

> Conceptual Design Space for LLM Routing
---
### 1. Introductory 



































