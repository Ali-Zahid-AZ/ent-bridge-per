---
tags:
  - index
  - index-04-05-03-AgentOps
---

---
### Notes 

```dataview
TABLE WITHOUT ID
    file.link AS "Research Note",
    regexreplace(file.folder, ".*\/", "") AS "Domain",
    file.mday AS "Last Modified"
FROM "04-Library/05-Operations-X-Ops/03-AgentOps"
WHERE file.name != this.file.name
SORT file.mday DESC
LIMIT 100
```





---
### Notes 