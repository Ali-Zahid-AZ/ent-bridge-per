---
tags:
  - index/engineering_stack
  - index
---

---
## ES-Engineering-Stack Index

>[!abstract] Purpose 
>The implementation layer. Contains language specifications, framework documentation, and orchestration tools. This is the "How" that supports the theoretical "Why."

---

[📂 Open: 01-Reference-Architectures](<file:///home/az/04-Library/05-Operations-X-Ops/03-AgentOps/01-Reference-Architectures>)

---

```dataview
TABLE without id 
	file.link as "Category Index", 
	regexreplace(file.folder, "04-Library/02-Engineering-Stack", "") as "Domain", 
	file.mday as "Last Modified" FROM "04-Library/02-Engineering-Stack" 
WHERE contains(file.name, "00-Index") AND file.name != this.file.name 
SORT file.name ASC
```

---
