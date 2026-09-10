---
tags:
  - chromadb
  - llmops-vector-databases
  - code-explanations
---

---

ChromaDB is primarily an **in-memory vector database**, but it has some flexibility:

- **Default:** In-memory, which is fast but **temporary**—data disappears when your script ends
- **Persistent storage:** You can specify a `persist_directory` when creating the client. Then it uses **disk-based storage** (SQLite under the hood by default) to save vectors and metadata
- **Not distributed:** ChromaDB itself does **not natively support distributed clusters**. It’s designed to be lightweight and easy to embed locally or in a single server
- **Not graph-based:** It’s not a graph database; the “vectors” are stored as flat arrays for similarity search
- **Not time-series-based:** There’s no built-in time-indexing or temporal features. You can store timestamps in metadata if needed, but Chroma won’t index them automatically
    

So you can think of it as a **fast in-memory vector DB with optional disk persistence**, ideal for RAG pipelines, semantic search, and embedding-based retrieval—but not for massive distributed or graph-specific workloads.

---

ChromaDB is lightweight and perfect for **local or small-scale embedding/vector tasks**, especially for **RAG and semantic search**. If you need **large-scale distributed storage** or specialized data models like **graphs or time-series**, other DBs are better suited.**

| Feature / Type | ChromaDB                                        | Distributed Vector DB (e.g., Milvus, Pinecone) | Graph DB (e.g., Neo4j)                   | Time-Series DB (e.g., InfluxDB) |
| -------------- | ----------------------------------------------- | ---------------------------------------------- | ---------------------------------------- | ------------------------------- |
| Storage        | In-memory by default, optional disk persistence | Disk-based, distributed across nodes           | Disk-based graph structures              | Disk-based with time indexing   |
| Persistence    | automatic(`persist_directory`)                  | Built-in, durable                              | Built-in                                 | Built-in                        |
| Distribution   | No                                              | Yes, scales horizontally                       | Usually single or cluster                | Usually single or clustered     |
| Data Model     | Vectors + metadata                              | Vectors + metadata                             | Nodes + edges (graph)                    | Time-series points              |
| Query Type     | Similarity search (nearest neighbor)            | Similarity search, large-scale ANN             | Graph traversal, relationships           | Range queries, aggregations     |
| Use Case       | RAG, semantic search, embeddings                | Large-scale embeddings, recommendation systems | Relationship analytics, knowledge graphs | Monitoring, IoT, metrics        |
| Complexity     | Lightweight, easy to embed                      | More complex, cluster management required      | Schema-heavy                             | Schema-heavy                    |

---
#### Client → Collection → Add → Query → Get/Count/Delete → Persist

- `Client()` → create the database session
- `get_or_create_collection()` → make or access a collection
- `add()` → insert vectors + metadata
- `query()` → search for nearest vectors
- `get()` → retrieve vectors by ID
- `count()` → check how many vectors are stored
- `delete()` → remove vectors by ID

---
#### Persistence

```
import chromadb
from chromadb.config import Settings

client = chromadb.Client(
    Settings(
        persist_directory="./chroma_db"
    )
)
```

---

| **Command**           | **Syntax Example**                                                                                       | **Purpose / Explanation**                                                     |
| --------------------- | -------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| Initialize client     | `import chromadb`<br>`client = chromadb.Client()`                                                        | Opens a connection to the database.                                           |
| Create/get collection | `collection = client.get_or_create_collection(name="my_collection")`<br>                                 | Collections store vectors + metadata. Acts like a table or dataset container. |
| Add vectors           | `collection.add(ids=["1","2"], embeddings=[[0.1,0.2],[0.3,0.4]], metadatas=[{"text":"A"},{"text":"B"}])` | Insert vectors with unique IDs and optional metadata.                         |
| Query / search        | `collection.query(query_embeddings=[[0.1,0.2]], n_results=2, include=["metadatas","distances"])`         | Finds nearest vectors to your query vector(s) and returns requested info.     |
| Retrieve vectors      | `collection.get(ids=["1"])`                                                                              | Fetch vectors or metadata by ID.                                              |
| Count vectors         | `collection.count()`                                                                                     | Get total number of vectors in the collection.                                |
| Delete vectors        | `collection.delete(ids=["1"])`                                                                           | Remove vectors from the collection by their IDs.                              |
| Persist database      | `client.persist()`                                                                                       | Save your database to disk if using a persistent directory.                   |

---
#### Instantiate the Client 

- `client = chromadb.Client()` **instantiates a Client object**, which is like the **database connection or manager**. It **does not store vectors itself**.
- A **Collection** is a separate object that lives inside the Client. Think of it as a **table inside a database**, where the actual vectors and metadata are stored.

```
import chromadb

# 1. Create the database connection / manager
client = chromadb.Client()

# 2. Create or get a collection (where vectors live)
collection = client.get_or_create_collection(name="my_collection")

```

- `client` → manages collections, persistence, and overall DB settings.
- `collection` → stores the vectors (`embeddings`), metadata, and IDs. All add/query/get/delete operations happen here.
---

- `Client` → the overall database manager; handles collections and persistence.
- `Collection` → container for vectors; all add/query/get/delete happens here.
	- Each **vector** inside a collection is identified by an **ID**, has an **embedding**, and optional **metadata**.

 **Client → Collection → Vectors (ID + Embedding + Metadata)**


```
Client (Database)
│
├─ Collection "my_collection" (Table)
│   │
│   ├─ Vector ID: "1"
│   │    Embedding: [0.1, 0.2, 0.3]
│   │    Metadata: {"text": "Hello"}
│   │
│   ├─ Vector ID: "2"
│   │    Embedding: [0.4, 0.5, 0.6]
│   │    Metadata: {"text": "World"}
│   │
│   └─ ...
│
└─ Collection "another_collection"
    └─ ...
```

---
#### Adding Vectors to ChromaDB collection

When you **add vectors** to a ChromaDB collection, you’re always providing **three things together**:
1. **ID** → a unique identifier for each vector (string or int)
2. **Embedding / Vector** → the numeric vector representing your data (list of floats)
3. **Metadata** → optional extra information attached to the vector (like the original text, labels, or tags)
    

Example:

```
collection.add(
    ids=["1", "2"], 
    embeddings=[[0.1, 0.2, 0.3], [0.4, 0.5, 0.6]], 
    metadatas=[{"text":"Hello"}, {"text":"World"}]
)
```

- The **ID** lets you retrieve or delete vectors later.
- The **embedding** is what Chroma uses to measure similarity.
- The **metadata** is your human-readable or structured info attached to that vector.
    
**Everything in ChromaDB revolves around this triplet when adding data**

---

	create_collection() is assertion
    get_or_create_collection() is contract
    
- Most of the time, you want **contracts**, **not assertions**

---

#### Use `get_or_create_collection()` everywhere unless you explicitly want the program to crash.**

---

