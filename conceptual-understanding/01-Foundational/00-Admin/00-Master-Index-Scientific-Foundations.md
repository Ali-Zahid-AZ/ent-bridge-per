---
tags:
  - index
  - index/scientific_foundations
---

---
## SF-Scientific Foundations Index

>[!abstract] Purpose
>The bedrock of the library. Aggregates fundamental knowledge across Mathematics, Physics, and Information Theory. This is the root node for all theoretical derivation and first-principles thinking.

---

[📂 Open Folder](<file:///home/az/GitHub-Repositories/Obsidian-Knowledge-Base/04-Library/01-Scientific-Foundations>)

---

```dataview
TABLE without id
   file.link as "Category Index",
   regexreplace(file.folder, "04-Library/01-Scientific-Foundations", "") as "Domain",
   file.mday as "Last Modified"
FROM "04-Library/01-Scientific-Foundations"
WHERE contains(file.name, "00-Index") AND file.name != this.file.name
SORT file.name ASC
```
