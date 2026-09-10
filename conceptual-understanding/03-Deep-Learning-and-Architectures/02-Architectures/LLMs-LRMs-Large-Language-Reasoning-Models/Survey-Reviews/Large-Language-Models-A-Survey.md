---
tags:
  - review-survey-articles
  - research-article
  - large-language-models-LLMs
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

- Pdf in Directory: [Dir: Zhao-Large-Language-Models-A-Survey-2026-v19.pdf](<file:///home/az/04-Library/03-Deep-Learning-and-Architectures/02-Architectures/LLMs-LRMs-Large-Language-Reasoning-Models/Survey-Reviews/Zhao-Large-Language-Models-A-Survey-2026-v19.pdf>)
- Directory: [Dir: 📂 Open: Survey-Reviews](<file:///home/az/04-Library/03-Deep-Learning-and-Architectures/02-Architectures/LLMs-LRMs-Large-Language-Reasoning-Models/Survey-Reviews>)


---
