



---
```dataview
TABLE WITHOUT ID
	file.link AS "File Name",
	file.mday AS "Last Modified"
FROM "04-Library/03-Deep-Learning-and-Architectures/01-Representation-and-Interpretability/Graph-Representation-Learning"
WHERE file.name != this.file.name
SORT file.name ASC
```
