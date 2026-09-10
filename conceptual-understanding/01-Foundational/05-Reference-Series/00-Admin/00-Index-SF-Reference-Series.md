---
tags:
  - index
  - index/scientific_foundations
---

---
## Reference Series Index

---

>[!abstract] Purpose 
>Collections of lecture notes, paper series, or multi-volume sets that do not fit into a single domain bucket. Includes broad scientific surveys and handbook series.

---

[📂 Open Folder](<file:///home/az/GitHub-Repositories/Obsidian-Knowledge-Base/04-Library/01-Scientific-Foundations/05-Reference-Series>)

----

```dataview
TABLE without id 
	file.link as "Note", 
	regexreplace(file.folder, "04-Library/", "") as "Location", 
	file.mday as "Last Modified" 
FROM "04-Library/01-Scientific-Foundations/06-Reference-Series" 
WHERE file.name != this.file.name AND !contains(file.path, "00-Admin")
SORT file.name ASC
```


---
