---
tags:
  - index
  - index/engineering_stack
---

---
## Frameworks & Orchestration Index

>[!success] Purpose: **The Execution Layer**
> Software libraries, SDKs, and frameworks used to implement the mathematical architectures.
> * **Core Frameworks:** `PyTorch`, `Keras` (The computational engines).
> * **Ecosystem Extensions:** `GraphGym`, `LangChain` (Domain-specific toolkits).
> * **Orchestration:** `Ray`, `Temporal-io` (Distributed computing and workflow management).

---

[📂 Open Folder](<file:///home/az/GitHub-Repositories/Obsidian-Knowledge-Base/04-Library/02-Engineering-Stack/02-Frameworks-Orchestration>)

---

```dataview
TABLE without id 
	file.link as "Note", 
	regexreplace(file.folder, "04-Library/", "") as "Location", 
	file.mday as "Last Modified" FROM "04-Library/02-Engineering-Stack/02-Frameworks-Orchestration" WHERE file.name != this.file.name AND !contains(file.path, "00-Admin") 
SORT file.name ASC
```



---

---

```dataview
LIST
FROM "04-Library/02-Engineering-Stack/02-Frameworks-Orchestration"
WHERE file.name != this.file.name
SORT file.name Abstract
```

