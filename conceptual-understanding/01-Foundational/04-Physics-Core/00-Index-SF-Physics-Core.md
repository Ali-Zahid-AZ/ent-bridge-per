---
tags:
  - index/scientific_foundations
---

---
## Physic Core Index 

>[!abstract] Purpose 
>The laws of the universe.
>Foundational physics principles excluding Applied Materials/Quantum Hardware. Focuses on Classical Mechanics, Electrodynamics, and Statistical Mechanics as the physical priors for ML models. 
>This is the source code of reality.

---
[📂 Open Folder](<file:///home/az/GitHub-Repositories/Obsidian-Knowledge-Base/04-Library/01-Scientific-Foundations/02-Physics-Core>)

---

```dataview
TABLE without id 
	file.link as "Note", 
	regexreplace(file.folder, "04-Library/", "") as "Location", 
	file.mday as "Last Modified" 
FROM "04-Library/01-Scientific-Foundations/02-Physics-Core" 
WHERE file.name != this.file.name AND !contains(file.path, "00-Admin")
SORT file.name ASC
```
