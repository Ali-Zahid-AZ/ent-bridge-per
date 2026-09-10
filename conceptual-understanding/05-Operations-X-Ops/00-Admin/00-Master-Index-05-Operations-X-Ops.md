---
tags:
  - index
  - index/05
---

---
  
### Indexes 

```dataview
TABLE WITHOUT ID 
	file.link AS "Category Index", 
	regexreplace(file.folder, "04-Library/05-Operations-X-Ops/?", "") AS "Domain", 
	file.mday AS "Last Modified" 
FROM "04-Library/05-Operations-X-Ops" 
WHERE contains(file.name, "00-Index") AND file.name != this.file.name 
SORT file.name ASC
```

---
### Notes 

```dataview
TABLE WITHOUT ID
    file.link AS "Research Note",
    regexreplace(file.folder, ".*\/", "") AS "Domain",
    file.mday AS "Last Modified"
FROM "04-Library/05-Operations-X-Ops"
WHERE file.name != this.file.name
SORT file.mday DESC
LIMIT 100
```
