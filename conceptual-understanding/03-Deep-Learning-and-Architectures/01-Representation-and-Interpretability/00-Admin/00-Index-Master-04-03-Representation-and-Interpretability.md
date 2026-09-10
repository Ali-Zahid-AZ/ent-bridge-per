---
tags:
  - index
  - index/representation-and-interpretability
---


---
### 1. Indexes in Representation & Interpretability

```dataview
TABLE WITHOUT ID 
	file.link AS "Topic Index", 
	regexreplace(file.folder, ".*\/", "") AS "Sub-Domain", 
	file.mday AS "Last Modified" 
FROM "04-Library/03-Deep-Learning-and-Architectures/01-Representation-and-Interpretability" 
WHERE contains(file.name, "00-Index") AND file.name != this.file.name 
SORT file.name ASC
```
---
### 2. Folders

```dataviewjs
let folders = dv.pages('"04-Library/03-Deep-Learning-and-Architectures/01-Representation-and-Interpretability"')
    .groupBy(p => p.file.folder)
    .sort(g => g.rows.file.mday.max(), "desc")
    .limit(100);

dv.table(["Sub-Domain Folder", "Domain", "Last Activity"], 
    folders.map(g => {
        const pathParts = g.key.split('/');
        const domain = pathParts[pathParts.length - 2] || "Root";
        const folderName = pathParts.pop();
        
        // Ensure the date is a Luxon object before formatting
        const maxMday = g.rows.file.mday.max();
        const lastActiveDate = maxMday.toISODate ? maxMday.toISODate() : "N/A";

        return [
            `[[${g.key}/00-Index|${folderName}]]`, 
            domain,
            lastActiveDate
        ];
    })
);
```

---
### 3. Notes

```dataview
TABLE WITHOUT ID
    file.link AS "Research Note",
    regexreplace(file.folder, ".*\/", "") AS "Domain",
    file.mday AS "Last Modified"
FROM "04-Library/03-Deep-Learning-and-Architectures/01-Representation-and-Interpretability"
WHERE file.name != this.file.name
SORT file.mday DESC
LIMIT 100
```

---
