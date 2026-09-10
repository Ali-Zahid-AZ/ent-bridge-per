---
tags:
  - index/engineering_stack
---

---
## Languages Index 

>[!abstract] Purpose 
>Core syntax, performance patterns, and low-level specifications for the primary languages in the stack (Python, Julia, Rust). Focuses on asynchronous I/O, method resolution, and the Rust-Python bridge for high-performance ML

---

[📂 Open: 01-Reference-Architectures](<file:///home/az/04-Library/05-Operations-X-Ops/03-AgentOps/01-Reference-Architectures>)

---

```dataview
TABLE without id 
	file.link as "Note", 
	regexreplace(file.folder, "04-Library/", "") as "Location", 
	file.mday as "Last Modified" FROM "04-Library/02-Engineering-Stack/01-Languages" 
WHERE file.name != this.file.name AND !contains(file.path, "00-Admin") 
SORT file.name ASC
```

---
