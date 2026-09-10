---
tags:
  - index/engineering_stack
---

---
## Development Practices Index 

>[!abstract] Purpose 
>The software engineering discipline for production AI. Focuses on modern dependency management (UV, Mamba), architectural patterns (Factory, Adapters), and the standardization of project structures (src folder patterns). Software Engineering standards. Includes Git workflows, CI/CD patterns, testing methodologies, and clean code principles applied to Machine Learning.

---

[📂 Open: 01-Reference-Architectures](<file:///home/az/04-Library/05-Operations-X-Ops/03-AgentOps/01-Reference-Architectures>)

---

```dataview
TABLE without id 
	file.link as "Note", 
	regexreplace(file.folder, "04-Library/", "") as "Location", 
	file.mday as "Last Modified" FROM "04-Library/02-Engineering-Stack/04-Dev-Practices" 
WHERE file.name != this.file.name AND !contains(file.path, "00-Admin") 
SORT file.name ASC
```

---
