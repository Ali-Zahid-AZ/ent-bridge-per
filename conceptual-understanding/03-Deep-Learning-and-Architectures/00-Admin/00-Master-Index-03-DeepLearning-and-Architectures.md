---
tags:
  - index/deeplearning_core
---

---
## Deep Learning and Architecture: Master Index

```dataview
TABLE WITHOUT ID 
	file.link AS "Category Index", 
	regexreplace(file.folder, "04-Library/03-Deep-Learning-and-Architectures/?", "") AS "Domain", 
	file.mday AS "Last Modified" 
FROM "04-Library/03-Deep-Learning-and-Architectures" 
WHERE contains(file.name, "00-Index") AND file.name != this.file.name 
SORT file.name ASC
```
