---
tags:
  - index/engineering_stack
---

---
## Data Infrastructure Index 

>[!success] **The Engineering Backbone.**
>This directory manages the lifecycle of data from ingestion to serving. It separates the "Plumbing" (Pipelines) from the "Storage" (Databases).
>* **Storage & Retrieval:** `Vector-Databases` (Chroma, Pinecone, Indexing strategies).
>* **Compute & Serving:** `Platforms` (Vertex AI, Docker containers, Model Serving).
>* **Movement:** `ETL` & `Data-Engineering` (Ingestion pipelines, cleaning, and normalization).

---

[📂 Open: 01-Reference-Architectures](<file:///home/az/04-Library/05-Operations-X-Ops/03-AgentOps/01-Reference-Architectures>)

---

```dataview
TABLE without id 
	file.link as "Note", 
	regexreplace(file.folder, "04-Library/", "") as "Location", 
	file.mday as "Last Modified" FROM "04-Library/02-Engineering-Stack/03-Data-Infrastructure" 
WHERE file.name != this.file.name AND !contains(file.path, "00-Admin") 
SORT file.name ASC
```
