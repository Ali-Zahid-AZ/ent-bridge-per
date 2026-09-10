---
tags:
  - research-article
  - graph_vit
---

---
#### References


> [!example] **[Obsidian Links]** 
> `$= dv.list(dv.current().file.outlinks.filter(l => l.path.endsWith(".md")))`
> 

> [!example] **[External Links]**
> `$= const content = await dv.io.load(dv.current().file.path); const regex = /\[(.*?)\]\((https?:\/\/[^\s)]+)\)/g; const links = []; let m; while (m = regex.exec(content)) { links.push("[" + m[1] + "](" + m[2] + ")"); } dv.list([...new Set(links)])`

> [!example] **[Directory Links]**
> `$= const content = await dv.io.load(dv.current().file.path); const regex = /\[(.*?)\]\(<(file:\/\/\/.*?)>\)/g; const links = []; let m; while (m = regex.exec(content)) { links.push("[" + m[1] + "](<" + m[2] + ">)"); } dv.list([...new Set(links)])`

> [!example] **[Back Links]**
> `$= dv.list(dv.current().file.inlinks)`

---


- [[A-Generalization-of-ViT-MLP-Mixer-to-Graphs-Implementation]]
-  **[He-A-Generalization-of-ViT-MLP-Mixer-to-Graphs-2023.pdf](<file:///home/az/04-Library/04-Advanced-Paradigms/03-Advanced-Architectures/Geometric-Deep-Learning/Graph-Vision/He-A-Generalization-of-ViT-MLP-Mixer-to-Graphs-2023.pdf>)**
- [📂 Open: Graph-Vision](<file:///home/az/04-Library/04-Advanced-Paradigms/03-Advanced-Architectures/Geometric-Deep-Learning/Graph-Vision>)
- [[A-Generalization-of-ViT-MLP-Mixer-to-Graphs-Code-Deep-Dive]]
- arXiv ➝ [A Generalization of ViT/MLP-Mixer to Graphs](https://arxiv.org/abs/2212.13350)
