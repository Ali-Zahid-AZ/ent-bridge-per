---
tags:
  - index/data_infrastructure
---

## Data Engineering Index 

>[!success] Purpose: **The Pipelines & Tensors.** 
>The discipline of moving, cleaning, and shaping data for ML consumption. 
>**Movement:** `ETL` (Extract-Transform-Load patterns, Airflow, batch jobs)
>**Quality:** `Data-Cleaning`, `Validation` (Ensuring schema conformity).
>**Storage Formats:** Notes on `Parquet`, `Avro`, `Protobuf`


```dataview 
TABLE without id file.link as "Note", 
	regexreplace(file.folder, "04-Library/", "") as "Location", 
	file.mday as "Last Modified" FROM "04-Library/02-Engineering-Stack/03-Data-Infrastructure/Data-Engineering" WHERE file.name != this.file.name AND !contains(file.path, "00-Admin") 
SORT file.name ASC
```
