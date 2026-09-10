---
tags:
  - interviews
  - Pasqal
  - agentic-ai-methodologies
  - job_interviews
---

---
#### References
- [[Introductory-Narrative-Interviews]]
- [[Ray-Scalable-Enterprise-GraphRAG-Agentic-Discovery-Platform]]
- [[Ray-Scalable-Enterprise-GraphRAG-Agentic-Discovery-Platform]]
---
#### The Case Study: The High-Throughput RAG & Agentic Platform

**The Context:** At Pasqal, we needed to build an internal "Scientific Discovery Agent."

> This wasn't just a chatbot  
> - it was an agent that had to read thousands of Quantum Physics papers  
> - parse molecular datasets  
> - answer complex queries from PhD physicists

--

#### 1. What was the Issue? (The Bottleneck)

The problem wasn't the AI model; the problem was **Physics & I/O Latency.**

- **The Sequential Trap:** Standard RAG pipelines (using simple LangChain or Python scripts) are **synchronous**
    - _Step 1:_ User asks a question.
    - _Step 2:_ Agent searches Vector DB (Wait 200ms).
    - _Step 3:_ Agent retrieves 50 documents (Wait 500ms).
    - _Step 4:_ Agent parses documents and re-ranks them (Wait 2s).
    - _Step 5:_ Agent calls LLM for synthesis (Wait 5s).
    - _Total Time:_ ~8-10 seconds.  
        
- **The "Agentic" Loop**
    
    > - When we moved to **Agentic Workflows** (where the AI "thinks" and performs multiple tool calls), this latency multiplied
    > - An agent that needs to check 3 different databases and perform a calculation sequentially took **30+ seconds**.
    
- **The Data Ingestion Bottleneck**
    
    > - Re-indexing our document store (embedding thousands of new PDFs) was taking hours because we were bottlenecked by **single-node processing speeds**
    

--

#### 2. Why we settled on Ray (The Strategic Choice)

> We needed a framework that could handle **Asynchronous Fan-Out** and **Stateful Execution**.

> - **FastAPI/Celery was not enough:** Celery is great for background tasks, but it's too slow for real-time interactive agents (high overhead). FastAPI is great for serving, but it doesn't manage the _compute_ behind the scenes
> - **Ray was the sweet spot:** It allowed us to mix **Serving** (HTTP requests via Ray Serve), **Processing** (embedding docs via Ray Data), and **Reasoning** (LLM inference) in a single, unified cluster

--

#### 3. The Implementation: What Ray Offered (The Architecture)

Here is how you architected the solution using Ray's specific primitives

##### A. Parallel Ingestion with Ray Data (The ETL Layer)

- **The Challenge:** Processing 10,000 PDF papers. Extracting text, chunking it, and embedding it.  
    
- **The Ray Solution:**
    
    > "I utilized **Ray Data** to create a streaming ingestion pipeline. Instead of processing files one by one, Ray acts as a distributed map-reduce engine. I spun up 50 CPU actors to OCR and chunk the PDFs in parallel. As soon as a batch was chunked, it was pushed to the **Plasma Object Store** and immediately picked up by GPU actors for embedding. This cut our indexing time from 6 hours to 20 minutes."
    

##### B. "Fan-Out" Retrieval with Ray Tasks (The Retrieval Layer)

- **The Challenge:** The Agent needs to query the Vector DB (Weaviate), the Graph DB (Neo4j), and an internal SQL database simultaneously to answer a question.  
    
- **The Ray Solution:**
    
    > "I implemented the **Scatter-Gather pattern** using Ray Tasks. When a query comes in, the Agent spawns 3 asynchronous tasks: `query_vector_db.remote()`, `query_graph_db.remote()`, and `query_sql.remote()`. These run in parallel. The Agent then `ray.get()`s the results. This reduced the retrieval latency to the speed of the _slowest_ single query, rather than the sum of all three."
    

##### C. Stateful Agents with Ray Actors (The Cognitive Layer)

- **The Challenge:** Agents need "Memory." They need to remember the conversation context and the intermediate steps of their reasoning chain. Stateless REST APIs require reloading the entire history for every token generation.  
    
- **The Ray Solution:**
    
    > "I used **Ray Actors** to host the Agent instances. An Actor is a **Stateful Worker**. When a user starts a session, we spawn an Actor dedicated to that conversation. The Actor holds the conversation history and the loaded tool definitions in memory. This eliminates the overhead of context reloading and database lookups for every single interaction."
    

--

#### 4. Why is this good for Scalable RAG Agents? (The Enterprise Pitch)

This is the section where you sell this to Systems Ltd for their Banking/Retail clients.

**1. Latency Reduction via Model Composition**

> In a complex RAG system, you often have a small model (Router), an Embedding Model, and a Large Generator Model. With **Ray Serve**, I can deploy all these models in a single cluster and compose them into a graph. Data flows between models via shared memory (zero-copy), not over HTTP. This cuts the internal network latency to near zero

**2. Fractional GPU Allocation (Cost Efficiency)**

> Most RAG requests don't need a full A100 GPU. Ray allows **Fractional GPUs**. I can assign 0.2 GPUs to the Embedding Model and 0.8 GPUs to the LLM. This allows me to pack multiple services onto a single piece of hardware, maximizing the client's ROI and reducing cloud bill

**3. Autoscaling that Actually Works**

> Ray Serve has 'scale-to-zero' capabilities. If no one is using the Scientific Agent at 3 AM, Ray shuts down the replicas. When a request hits, it spins them up instantly using the Object Store cache. For an enterprise client paying by the second, this is a massive differentiator

---

#### Architect Conclusion

When they ask about your Agentic AI experience, you conclude with:

> "I didn't just write prompts in LangChain. I architected the **compute substrate** that allows Agents to scale. By using **Ray**, I turned a slow, synchronous RAG script into a **high-concurrency, parallelized Agentic Platform**. We achieved **10x faster indexing** and **sub-second latency** for multi-database queries, all while keeping GPU costs under strict control via fractional scheduling."

---

#### Implementation at Pasqal: The Blue Print

[[RAG-Prototpye-Enterprise-GraphRAG-Agentic-GenAI-Platform]]
[[Ray-Scalable-Enterprise-GraphRAG-Agentic-Discovery-Platform]]


> Describing a **design decision** you made to solve a specific problem: **Heterogeneous, Hybrid Compute Latency**

--

##### The Strategic Context: The "Why"

**The Problem at Pasqal:** We were building a **Hybrid Loop**

> 1. **Classical Step:** A Neural Network (GNN/Transformer on GPU) proposes a set of laser parameters.
> 2. **Quantum Step:** The Neutral Atom QPU (Quantum Processing Unit) executes the pulse sequence and returns a measurement.
> 3. **The Bottleneck:** Standard tools like **Celery** or **Kubernetes Jobs** are designed for _stateless_ tasks. Tearing down and spinning up a container for every quantum shot introduced massive latency (seconds vs. milliseconds). We needed a system that could keep the hardware "warm" and stateful.
> 4. **The Data Issue:** We were processing massive molecular graph datasets. Moving these tensors between CPU (preprocessing) and GPU (training) using standard IPC (Inter-Process Communication) meant constant **serialization/deserialization overhead** (pickling), which bottlenecked the training.

**The Solution: Ray.** Ray was the only framework that provided

> 1. **Stateful Actors:** To wrap the QPU interface and keep connections open.
> 2. **Zero-Copy Shared Memory (Plasma):** To pass massive tensors between processes without copying data.
> 3. **Fine-Grained Resource Scheduling:** To explicitly say "This task needs 1 GPU and 0.5 CPU," and "This task needs the QPU."

--

##### Deep Dive 1: Ray Actors (The "Stateful Worker" Pattern)

**The Concept**

> - In standard Python (multiprocessing) or Celery, functions are stateless ➝ You call them, they run, they die
> - In Ray ➝ an **Actor** is a class transformed ➝ into a stateful worker that lives in the cluster

**Your Pasqal Implementation:** Creating a **"QPU Manager" Actor**

> - **The Code Logic**
>     - Instead of initializing the connection to the Quantum Hardware for every experiment ➝ spin up a `QPUActor`
>     - ## This actor holds the socket connection/driver handle open
>         
> - **The Benefit:** When the Neural Network needs a measurement, it sends a message to the _existing_ Actor. Zero initialization cost

**The "Principal" Explanation:**

> We treated our Quantum Processor like a database connection pool.  
> I implemented **Ray Actors** to maintain persistent sessions with the hardware.  
> This reduced our 'shot latency' from 2 seconds (container startup) to 20 milliseconds (RPC call), enabling real-time variational quantum algorithms

--

##### Deep Dive 2: The Plasma Object Store (Zero-Copy Data)

**The Concept**

> Ray puts large objects in a shared memory space called the **Plasma Object Store**
> 
> - **Normal Python:** Process A creates an array -> Pickles it -> Sends bytes -> Process B unpickles it -> New array ➝ Slow, 2x memory
> - **Ray:** Process A puts array in Plasma -> Ray gives Process B a _pointer_ (ObjectId) -> Process B reads directly from memory ➝ Instant, 1x memory

**Your Pasqal Implementation:** You used this for **Molecular Graph Datasets**.

- **The Workflow:**
    
    > 1. **CPU Workers (Ray Tasks)**
    >     - Load raw molecular data, compute features (angles/bonds), and convert to dense tensors.
    >     - They `ray.put()` these tensors into the Object Store
    > 2. **GPU Workers (Trainers):** Receive the _Object Reference_. They read the tensor directly from shared memory to feed the model.
    

> - **The Benefit:** No CPU bottlenecks blocking the GPU. The GPU never waits for data serialization.

**The "Principal" Explanation (Soundbite):**

> We were dealing with 100TB+ of molecular data  
> The serialization overhead of standard Python multiprocessing was killing our GPU utilization  
> I leveraged **Ray's Plasma Object Store** to enable **Zero-Copy** data sharing  
> The preprocessing workers write to shared memory, and the training workers read from it instantly. This saturated our GPUs and cut training time by 40%

--

##### Deep Dive 3: Ray Tune & PBT (The Optimization Engine)

**The Concept**

> Training complex models (like SE(3)-Transformers) requires finding the **perfect hyperparameters** (Learning Rate, Batch Size, Attention Heads)
> 
> - **Grid Search** is too slow
> - **Bayesian Optimization** is sequential (hard to parallelize)
> 
> --
> 
> **Ray Tune** offers **Population Based Training (PBT)**

> **Your Pasqal Implementation:** You used PBT to "**evolve**" your models.

> - **The Logic:** Start 50 models with random parameters.
> - **The Checkpoint:** Every 5 epochs, pause.
> - **The Mutation:** Take the bottom 25% of models (worst performers), kill them, and replace them with a _copy_ of the top 25%, but with slightly "mutated" hyperparameters (e.g., increase LR by 1.2x)  
>     --
> - **The Benefit:** You don't waste compute on bad ideas. You focus resources on promising candidates.

**The "Principal" Explanation (Soundbite):**

> "For our Geometric Deep Learning models, the search space was too vast for Grid Search. I implemented **Population Based Training (PBT)** using Ray Tune. It allowed us to dynamically reallocate compute from failing trials to promising ones mid-training. We effectively got the results of a 500-model search for the compute cost of 50 models."

--

##### Deep Dive 4: Custom Resource Scheduling (The "Heterogeneous" Aspect)

**The Concept**

> - Ray allows you to define custom resources, not just CPU/GPU
> - You can define abstract resources like "QPU" or "HighMemNode"

> **Your Pasqal Implementation:** You used decorators to enforce hardware affinity.

```python
    @ray.remote(num_gpus=1)
    def train_model():
        # Runs only on nodes with GPUs
        pass
    
    @ray.remote(resources={"QPU": 1})
    def execute_quantum_circuit():
        # Runs only on the node connected to the Quantum Hardware
        pass
```

> **The Benefit**  
> This abstracted the infrastructure  
> Data Scientists didn't need to know _IP addresses_  
> They just requested resources, and Ray's **Global Control Store (GCS)** scheduled the task on the correct machine

---

#### Possible Question

- **The Scenario:** "You have a client in the Middle East wanting to run a massive RAG pipeline on 10 million documents."
- **Your Answer:** "I wouldn't use a simple `for` loop. I would use **Ray** to scale the embedding generation. I'd set up a pool of **Ray Actors** wrapping the embedding model (e.g., Voyage or OpenAI) to handle the requests asynchronously, and use the **Object Store** to manage the document chunks without memory overflow. This ensures we maximize throughput without crashing the nodes."

--

#### The "Trap" Questions

**Trap 1: "Why Ray and not Spark?"**

- Spark is excellent for **ETL** and SQL-like queries on static data (IO-bound). Ray is designed for **Compute-bound** tasks (AI/ML). Spark uses the BSP (Bulk Synchronous Parallel) model—everyone waits for the slowest task. Ray uses an asynchronous task graph—fast tasks finish and trigger the next step immediately. For dynamic AI workloads, Ray is superior  
    

**Trap 2: "What happens when the Object Store fills up?"**

- Ray creates **Spilled Objects**. If the shared memory fills up, Ray spills objects to disk. This kills performance. As an Architect, I monitor the **Object Store Memory** usage in the Ray Dashboard and ensure our actors are releasing references to objects once they are consumed, to prevent memory leaks  
    

**Trap 3: "How do you handle fault tolerance?"**

- Ray has **Lineage Reconstruction**. If a node dies, Ray knows which tasks produced the lost objects and automatically re-runs _only_ those tasks to reconstruct the data. However, for Actors (stateful), we need to implement checkpointing (saving state to disk) so they can recover their state upon restart