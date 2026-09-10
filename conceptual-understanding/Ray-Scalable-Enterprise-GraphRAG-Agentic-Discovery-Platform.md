---
tags:
  - Pasqal
  - llmops-retrieval-augmented-generation-rag
  - agentic-platform
  - interview_preps
---

---
```table-of-contents
```
---
#### References
- [[RAG-Prototpye-Enterprise-GraphRAG-Agentic-GenAI-Platform]]
- [[Systems-LTD-AI-Architect]]
- [[Introductory-Narrative-Interviews]]
---

```toml
IMPACT → ARCHITECTURE → SCALE → OPTIMIZATION → GOVERNANCE → OUTCOMES
   ↓           ↓           ↓           ↓             ↓           ↓
  60%      Weaviate+    200 users   Ray Tasks    ArgoCD+     GNN model
  faster    Neo4j        elastic     4s→1.2s     Kubeflow   improvement
```

| **Trigger Word**               | **The Pivot (Concept)**  | **The File / Section**                                                                                       | **The Killer Soundbite**                                                                                                             |
| ------------------------------ | ------------------------ | ------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------ |
| **Scale / Latency**        | **Ray Actors & Async**   | `Detailed-Case-Study-High-Throughput...`<br>[[Detailed-Case-Study-The-High-Throughput-RAG-Agentic-Platform]] | I don't use loops. I use **Ray Actors** with **Zero-Copy Object Stores** to keep the models hot.                                   |
| **Hallucination / Safety** | **Geometric Governance** | `Detailed-Case-Study-ASO...`<br>[[Detailed-Case-Study-The Agentic-Systems-Orchestrator-ASO]]                 | Prompt engineering isn't safety. I use **PyTorch Forward Hooks** to kill generation if the latent vector drifts.                   |
| **Agents / Orchestration** | **Cyclic Graphs**        | `RAG-Prototype-Enterprise...`<br>[[RAG-Prototpye-Enterprise-GraphRAG-Agentic-GenAI-Platform]]                | LangChain is a fragile DAG. I use **LangGraph** State Machines so the agent can _self-correct_ in a loop.                          |
| **RAG Accuracy**             | **Hybrid Retrieval**     | `Async Architecture-Graph RAG...`<br>[[Async Architecture-Graph RAG-Pasqal]]                                 | Vector search is just recall. I add a **Knowledge Graph** layer to catch the logical relationships that embeddings miss.           |
| **Deployment / Ops**       | **Sidecars & GitOps**    | `Detailed-Case-Study-ASO...`<br>[[Detailed-Case-Study-The Agentic-Systems-Orchestrator-ASO]]                 | I deploy **Kubernetes Sidecars** to monitor the agent's stdout. If it loops, the sidecar kills the pod. That’s operational safety. |
| **Why You?**                 | **Physics -> Systems**   | `Introductory-Narrative...`<br>[[Introductory-Narrative-Interviews]]                                         | I treat AI as **Probabilistic Systems**, not magic. I constrain the entropy to guarantee the outcome.                              |

> [!example] **Specific Questions**
> - **The Hook:** I assume all Agents will eventually eventually hallucinate. So, instead of just prompt engineering ('Please be  '), I implemented **Geometric Governance**.
> 	- **The Technical Flex:** I bypassed LangChain and used **PyTorch Forward Hooks** to intercept the model's latent state before the decoding layer. I calculate the cosine similarity of the 'intent vector' against a 'safe manifold.' If it drifts, I kill the token generation before it happens. It’s physics-based safety, not language-based.
> 	    - _Why this wins:_ It proves you know **PyTorch**, **Latent Spaces**, and **System Design** simultaneously.
> 
> - The RAG / Scale Question ➝  Deploy **Ray & GraphRAG**
> 	- When he asks about RAG latency or Scaling to enterprise, pivot to your **High-Throughput RAG** notes.
> 	- **The Hook:** Standard RAG is synchronous and slow. I architected an **Async GraphRAG** platform using **Ray**.    
> 	- **The Technical Flex:** I used **Ray Actors** to keep the LLM and Vector DB connections stateful (hot), which eliminated the overhead of re-initializing for every query. I also used the **Plasma Object Store** for zero-copy data transfer between the CPU (embedding) and GPU (inference) workers. This cut our indexing time from 6 hours to 20 minutes.    
> 	    - _Why this wins:_ It hits the JD requirement for **High-performance architecture** and **AWS/Cloud Scaling** perfectly.        
> 
> - The LangGraph Question ➝  Deploy **State Machines**
> 	- If the JD specifically mentions **LangGraph**. You have the perfect answer in your **Enterprise GraphRAG** notes.
> 	- **The Hook:** Linear chains (LangChain) are fragile. I model scientific discovery as a **State Machine** using **LangGraph**. 
> 	- **The Technical Flex:** I built cyclic graphs where the agent has a 'Reflection Step.' If the retrieved data is low confidence, the graph loops back to the 'Query Generator' node to try a different search strategy. It allows the system to self-correct, which is impossible in a linear DAG.

> [!quote] **Engineering Perspective**
> 1. **When he asks about Multi-Agent Systems:**
>     - _Don't start with:_ I used Ray to scale them. (That's the Systems answer).
>     - _Start with:_ I used **LangGraph State Machines** to create cyclic feedback loops. The agent plans, executes, reflects, and _corrects itself_. Ray was just the engine; LangGraph was the brain.
>         
> 2. **When he asks about RAG:**
>     - _Don't start with:_ I optimized the vector DB latency.        
>     - _Start with:_ I moved beyond simple RAG to **GraphRAG**. I linked the unstructured vectors in Weaviate to structured facts in Neo4j. This allows the agent to do 'multi-hop reasoning' that vector search can't handle.
>         
> 3. **The Safety Nuke:**
>     - If the conversation gets dry, drop the **Geometric Governance** bomb.
>     - Tell him: Most people use Guardrails on the output text. I went deeper. I used PyTorch hooks to measure the **Cosine Similarity** of the hidden state against a 'Safe Manifold.' It’s physics-based safety.
>         - _Why:_ This proves you are a **Principal**. Seniors use APIs; Principals hack the model layers.
> 

---
#### The Narrative

**1. THE PROBLEM**  
“At Pasqal, we faced a critical challenge: scientists needed to query 100TB+ of physics literature, but standard RAG systems hallucinated in ~30% of queries—catastrophic for drug discovery where ‘inhibits’ vs ‘promotes’ is life-or-death.”

**2. THE ARCHITECTURAL DECISION**  
“I architected a hybrid GraphRAG + agentic system that enforced factual correctness through Neo4j relationship modeling while preserving the semantic richness of vector search.”

**3. THE RAY TRANSITION**  
“The next challenge was serving 200+ concurrent users with sub-2-second latency, which is where Ray became the orchestration backbone.”

---

> **The Scalability Transition** 

After initial prototpying the GraphRAG architecture proved itself in pilot tests ➝  **reducing hallucinations from 30% to under 5%**
- the mandate was clear ➝  productionize it for the entire R&D organization

> But moving from prototype to production exposed three hard constraints that the pilot environment had masked:
> 	1. **Concurrency**: The pilot served five users sequentially. Production required 200+ concurrent sessions with no queueing.
> 	2. **Latency**: Multi-step agentic workflows were taking up to 40 seconds due to strictly sequential tool execution—retrieve, reason, then calculate.
> 	3. **Cost**: We couldn’t scale by adding A100s. The CFO capped GPU spend at a 2× increase despite a 40× growth in users.
> 

> **Ray became the orchestration backbone that solved all 3 problems**

--

| **Challenge**            | **Naive Approach**                      | **Ray Solution**                    | **Technical Mechanism**                           |
| ------------------------ | --------------------------------------- | ----------------------------------- | ------------------------------------------------- |
| **200 concurrent users** | 200 separate processes (12 GB RAM each) | Ray Actors (shared cluster memory)  | **Actors** on **Ray Serve** with **auto-scaling** |
| **40s latency**          | Sequential tool calls (await each)      | Parallel Ray Tasks                  | `ray.get([task1.remote(), task2.remote()])`       |
| **12 A100s needed**      | 1 GPU per 16 users (fragmentation)      | 1 GPU per 64 users (PagedAttention) | vLLM on Ray with dynamic batching                 |

--

>**Constraint 1**:  Concurrency ➝ (5 users → 200+ concurrent sessions)

- **The problem**  
>- In the prototype, each agent workflow ran as a single Python process.  
>- When user six arrived, they queued.  
>- At 200 users, average wait time exceeded 90 seconds—unacceptable for scientists mid-experiment.
>
- **How Ray solved it**  
>- Ray Serve enabled ➝  elastic, stateful deployment
> - Each agent became a Ray **Actor** ➝ a long-lived Python object with its own memory space 
>- Unlike stateless FastAPI workers  ➝ Actors persist chat history + retrieved documents ➝  across the multi-turn reasoning loop
>- Ray’s scheduler automatically distributed these Actors across the cluster
>- When traffic spiked ➝  Ray spun up new Actor replicas on idle nodes
>- When traffic dropped ➝ it scaled them down

>- Critical detail: Ray **Placement Groups** allowed me to co-locate the Agent Actor with its vLLM inference server on the same GPU node, eliminating network latency for LLM calls

- **Result** 
>- We went from **queueing** ➝  to **instant response** for all 200 users

--

> **Constraint 2**: Latency ➝  (40s → sub-2s multi-step workflows)

- **The problem**
>- The agent workflow had **three retrieval steps**: vector search in Weaviate, graph traversal in Neo4j, and SQL lookup.  
>- They were executed sequentially.
>- Even with async/await, each step waited for the previous one to finish.  
>- End-to-end latency was 40 seconds

- **How Ray solved it**  
>- Ray Tasks enabled ➝ **true parallelization** ➝  through **scatter–gather execution**
>- At the **RETRIEVE** node in the LangGraph state machine ➝ the agent spawns three Ray Tasks simultaneously (vector search Weaviate + graph traversal Neo4j + SQL lookup.)
>- Ray executes these on different workers across the cluster ➝ If Weaviate is slow ➝  Neo4j still completes independently
>- Latency becomes the maximum of all tools, not the sum
>- The cross-encoder reranking step then runs on the merged results

- **Result**  
>- Retrieval latency dropped from 4 seconds sequential to 1.2 seconds parallel.
>- Total workflow time dropped from 40 seconds to 6 seconds
>- With caching, we reached 1.8 seconds p95 ➝ 95% of user requests finished in 1.8 seconds or less> 

--

> **Constraint 3** ➝ COST ➝  (40× user growth, 2× GPU budget)

- **The problem**  
>- The prototype ran vLLM on a single A100 with batch size 16.
>- Scaling naively to 200 users required 12 or more A100s—about $30k per month
>- The CFO capped spend at 2×, not 12×

- **How Ray solved it**  
> - Ray and vLLM together unlocked two critical cost optimizations
> - **1. Dynamic batching across users**  
> 	- vLLM on Ray Serve batches requests from multiple agents
> 	- If 30 agents call the LLM within a 50ms window, they are served in a single forward pass
> 	- Ray’s internal request queue maximizes batch utilization without adding user-visible latency
> - **2. PagedAttention memory efficiency**  
> 	- vLLM’s PagedAttention allows the KV cache to use non-contiguous GPU memory blocks, similar to virtual memory in operating systems
> 	- Before: 16 concurrent sessions per A100 due to memory fragmentation.
> 	- After: 64 concurrent sessions on the same hardware
> 	- Ray’s scheduler routes agents only to GPUs with sufficient KV cache capacity, preventing OOM failures

- **Result**  
> - We supported 200 users on three A100s instead of twelve
> - That’s a 4× hardware efficiency gain, staying under the 2× budget cap

---
#### Critical Addition: The Why Not X? Defense

Interviewers testing Ray expertise will probe:
- **Why not just use Kubernetes + Celery?**
- **Why not FastAPI + Redis?**

>- Kubernetes alone requires you to **manually orchestrate**: 
> 	- **Task distribution**, which would mean Celery or RabbitMQ
> 	- **State management**, typically Redis or Postgress
> 	- **Dynamic scaling**, using HPA plus custom metrics

**That’s three separate systems.** 
- Ray gives you all of this natively through Actors and placement groups
- plus something Kubernetes fundamentally can’t offer ➝ **zero-copy shared memory** for our 100TB data pipeline

> For the agentic workflows specifically
> Ray’s Actor model was a perfect fit
>	- because each agent needed persistent state ➝ chat history and retrieved documents ➝ across a multi-step reasoning loop

> Replicating that with **stateless FastAPI services** would require constant database round-trips, adding latency, cost, and architectural complexity

--
##### Why couldn’t Kubernetes do this?

- Kubernetes is an orchestrator for stateless containers
- Our agents required three **capabilities** that Kubernetes does not provide natively

>**1. Stateful execution**  
> 	Ray Actors maintain in-memory state—chat history and retrieved documents—across multi-turn reasoning loops.  
> 	In Kubernetes, every state update would require an external store such as Redis or a database, introducing constant network round-trips and significant latency
> 	
>**2. Task-level parallelism**  
> 	Ray schedules individual tasks, not just pods.  
> 	When we execute scatter–gather retrieval, Ray guarantees that all three retrieval tasks run simultaneously on different workers.  
> 	In Kubernetes, this would require layering a job queue such as Celery with RabbitMQ on top
> 	
>**3. GPU memory sharing and locality**  
> 	Ray Placement Groups allow the Agent Actor and the vLLM inference server to be co-located on the same GPU node, enabling efficient KV cache usage
> 	In Kubernetes, this would require custom resource definitions, manual affinity rules, and careful hand-tuning`

> The alternative was stitching together Kubernetes, Celery, Redis, and custom schedulers ➝ **Ray delivered all of this in a single framework**

--

```toml
┌─────────────────────────────────────────────────┐
│          USER REQUEST (200+ concurrent)         │
└───────────────────┬─────────────────────────────┘
                    │
         ┌──────────▼──────────┐
         │   RAY SERVE         │  ← Elastic Agent Deployment
         │   (Load Balancer)   │     (Solves CONCURRENCY)
         └──────────┬──────────┘
                    │
    ┌───────────────┼───────────────┐
    │               │               │
    ▼               ▼               ▼
┌────────┐     ┌────────┐     ┌────────┐
│ AGENT  │     │ AGENT  │ ... │ AGENT  │  ← Ray Actors
│ ACTOR 1│     │ ACTOR 2│     │ ACTOR N│     (Stateful)
└───┬────┘     └───┬────┘     └───┬────┘
    │              │              │
    │  Scatter-Gather Retrieval (Parallel)
    │              │              │
    ├──────────────┼──────────────┤
    │              │              │
    ▼              ▼              ▼
┌────────┐    ┌────────┐    ┌────────┐
│Weaviate│    │ Neo4j  │    │  SQL   │  ← Ray Tasks
│ (1.2s) │    │ (0.8s) │    │ (0.5s) │     (Solves LATENCY)
└────────┘    └────────┘    └────────┘
    │              │              │
    └──────────────┼──────────────┘
                   │
                   ▼
          ┌────────────────┐
          │   RERANKING    │
          │ (Cross-Encoder)│
          └────────┬───────┘
                   │
                   ▼
          ┌────────────────┐
          │  vLLM on Ray   │  ← Dynamic Batching
          │  (PagedAttn)   │     + Memory Efficiency
          └────────┬───────┘     (Solves COST)
                   │
                   ▼
            FINAL RESPONSE
```

---
#### Project Implementation Details: Enterprise GraphRAG & Agentic Discovery Platform

>[!example] **Objective**
>**Project Title:** Enterprise GraphRAG & Agentic Discovery Platform 
>**Role:** Principal Architect 
>**Objective:** Build a scalable, hallucination-resistant Cognitive Engine for scientific discovery (Physics/Genomics).


```toml
[User Interface] <--> [Load Balancer]
      |
      v
[Gateway API (FastAPI)]
      |
      +---> [Orchestrator Layer: Ray Serve Cluster]
      |       |
      |       +-- [Agent Actor (LangGraph)] <---(State Sync)---> [Postgres DB]
      |               |
      |               +--> [Router: Haiku vs Sonnet]
      |
      +---> [Retrieval Layer: Ray Tasks (Scatter-Gather)]
      |       |
      |       +-- [Vector Search: Weaviate] (Semantic Context)
      |       +-- [Graph Search: Neo4j] (Structured Facts)
      |       +-- [SQL DB] (Tabular Data)
      |
      +---> [Inference Layer: vLLM Server]
              |
              +-- [LLM: Llama-3-70B / Claude]
              +-- [Optimization: PagedAttention / Quantization]
```

--
#### Phase 1: Conceptualization & The Why

**The Business Problem:** Standard RAG (Vector-only) failed in scientific contexts
- _Issue 1:_ **Loss of Relationship Directionality.** Vectors map X inhibits Y and X promotes Y closely. This is catastrophic in drug discovery.
- _Issue 2:_ **Latency at Scale.** Sequential chaining of tools (Search -> Read -> Calculate) took 40s+ per query.
- _Issue 3:_ **State Amnesia.** Stateless APIs couldn't handle multi-turn reasoning (Go back to the second paper and compare it to the first).
    
**The Architectural Decision:** We moved from a **Retrieval-Augmented Generation (RAG)** model to a **Graph-Augmented Agentic Workflow**.
- **Graph:** To enforce factual correctness via structured edges.
- **Agentic:** To allow the system to think in loops (Plan -> Act -> Observe -> Correct).
- **Ray:** To solve the concurrency and latency bottlenecks.

--
#### Phase 2: The Data Plane (Ingestion & Indexing)

>**Methodology: The Dual-Path Ingestion Strategy**

**1. The Ingestion Engine (Ray Data)**
- **Tool:** **Ray Data**.
- **Why:** We needed to process 100TB+ of PDFs. Python `multiprocessing` bottlenecks at serialization (pickling). Ray Data offers streaming execution and zero-copy shared memory.
- **Process:**
    - _Step A:_ **OCR & Parsing.** Used `Unstructured.io` to strip text from PDFs.
    - _Step B:_ **Semantic Chunking.** Instead of fixed 512-token windows, we used a BERT-based segmenter to break text by topical coherence.

**2. The Knowledge Graph Construction (Neo4j)**
- **Tool:** **Neo4j** + **LLM Extraction**.
- **Logic:** For every chunk, an LLM extracts entities (Nodes) and relationships (Edges).
    - _Schema:_ `(Molecule)-[INHIBITS {confidence: 0.9}]->(Protein)`
- **Why Neo4j:** Its native **Cypher** query language allows for multi-hop reasoning (e.g., Find all proteins inhibited by molecules similar to Caffeine).
    
**3. The Vector Store (Weaviate)**
- **Tool:** **Weaviate**.
- **Why:** Low-latency HNSW (Hierarchical Navigable Small World) indexing and hybrid search capabilities.
- **Linkage:** Every Vector ID in Weaviate was stored as a property on the corresponding Node in Neo4j, creating a **Hard Link** between unstructured text and structured fact.

--
#### Phase 3: The Cognitive Plane (The Agentic Loop)

>**Methodology: Cyclic Reasoning via LangGraph**

**1. The Orchestrator (LangGraph)**
- **Tool:** **LangGraph**.
- **Why:** LangChain `AgentExecutor` is a Black Box loop. LangGraph allows us to define the reasoning flow as a **State Machine (Graph)**. We needed **cycles**: if the agent retrieves bad data, it loops back to search again.
- **The State Schema:**
        
    ```python
    class AgentState(TypedDict):
        query: str
        chat_history: List[Message]
        documents: List[Document]
        plan: List[str]
        current_step: int
    ```
    
**2. The Router Pattern (Cost Optimization)**
- **Concept:** Not every query needs GPT-4.
- **Implementation:** A classifier node (DistilBERT or small LLM) routes the query.
    - _Simple:_ -> Haiku (Fast/Cheap) -> Answer.
    - _Complex:_ -> Sonnet (Reasoning) -> Decompose -> Search -> Synthesize.

**3. State Persistence (Postgres)**
- **Tool:** **Postgres Checkpointer**.
- **Why:** Human-in-the-loop. If the agent gets stuck, it pauses. A human expert can inspect the state, edit the Plan, and resume execution. This requires durable state storage, not in-memory variables.

--
#### Phase 4: The Compute Plane (Infrastructure & Scale)

>**Methodology: The Ray Operating System**

**1. Serving the Agents (Ray Serve)**
- **Architecture:** **Ray Serve** manages the LangGraph deployments.
- **Pattern:** **Scatter-Gather**.
    - When the Agent reaches the `RETRIEVE` node, it fans out 3 asynchronous tasks:
        1. `weaviate_search.remote()`
        2. `neo4j_traversal.remote()`
        3. `sql_lookup.remote()`
    - It waits for all three (`ray.get()`) and re-ranks the combined results.
- **Why:** Reduced retrieval latency from 4s (sequential) to 1.2s (parallel).

**2. Inference Optimization (vLLM)**
- **Tool:** **vLLM** (Logical Flow).
- **Problem:** Fragmentation. With 50 concurrent agents, the KV (Key-Value) cache for the LLM was consuming massive GPU memory, leading to OOMs.
- **Solution:** **PagedAttention**.
    - It manages GPU memory like an OS manages RAM (pages). It allows non-contiguous memory allocation for the KV cache.
    - _Result:_ Increased **Concurrent Batch Size** by 4x on the same A100 hardware.
   
--
#### Phase 5: Governance & Deployment (MLOps)

>**Methodology: GitOps & Evaluation**

**1. The Guardrails (NVIDIA NeMo)**
- **Tool:** **NVIDIA NeMo Guardrails**.
- **Implementation:** An Input Rail checks if the user is asking for restricted IP (e.g., proprietary formulas). An Output Rail checks the answer for hallucination or toxicity before sending it to the user.

**2. Evaluation (RAGAS)**
- **Tool:** **RAGAS** (Retrieval Augmented Generation Assessment).
- **Metrics:**
    - **Faithfulness:** Does the answer contradict the retrieved context?
    - **Answer Relevancy:** Did we answer the user's question? 
- **CI/CD Gate:** We ran a Gold Set of 100 physics questions. If `Faithfulness` dropped below 0.85, the deployment pipeline failed.
    
**3. Deployment (ArgoCD)**
- **Tool:** **ArgoCD** + **Helm**.
- **Strategy:** The entire platform (Ray Cluster, Weaviate, App) is defined in Kubernetes manifests. ArgoCD ensures the cluster state matches the Git repo (GitOps).   

--
#### The Principal Soundbite

> I designed this platform not just to 'answer questions,' but to **model reasoning**. By integrating **GraphRAG**, I solved the accuracy problem inherent in vector search. By using **LangGraph**, I enabled the system to self-correct. And by underpinning it all with **Ray and vLLM**, I ensured that we could scale this reasoning to thousands of concurrent users without bankrupting the company on GPU costs. It is an **Enterprise-Grade System**, not a prototype.

