---
tags:
  - Pasqal
  - agentic-ai-methodologies
  - agentops-architecture-graph-rag
  - llmops-agentops-frameworks
  - interview_preps
---

---

> [!example] **Enterprise GraphRAG & Agentic GenAI Platform** at **Pasqal**

---
```table-of-contents
```
---
### References 

> [!info] .
>
>**[Obsidian Links]** 
>`$= dv.list([...new Map(dv.current().file.outlinks.filter(l => l.path.endsWith(".md")).map(l => [l.path, l])).values()])`
>
>---
>
> **[External Links]** 
> `$= const content = await dv.io.load(dv.current().file.path); const regex = /\[(.*?)\]\((https?:\/\/[^\s)]+)\)/g; const links = []; let m; while (m = regex.exec(content)) { links.push("[" + m[1] + "](" + m[2] + ")"); } dv.list([...new Set(links)])`
>
>---
>
> **[Directory Links]** 
> `$= const content = await dv.io.load(dv.current().file.path); const regex = /\[(.*?)\]\(<(file:\/\/\/.*?)>\)/g; const links = []; let m; while (m = regex.exec(content)) { links.push("[" + m[1] + "](<" + m[2] + ">)"); } dv.list([...new Set(links)])`
>
>---
> 
> **[Back Links]** 
> `$= dv.list([...new Map(dv.current().file.inlinks.map(l => [l.path, l])).values()])`
>
>---
> **[Document Tags]**
> 
>  `$= [...new Set(dv.current().file.tags)].join(" | ")`

---
### Primitives 

> The core achievement was moving from a research prototype to a **production-grade, governed system** that **delivered measurable scientific impact**

| Tool                | The Strategic Uses                                                                                                                                              |
| ------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Weaviate**        | - For fast + scalable **semantic search** <br>- over document chunks ➝ with built-in hybrid search capabilities                                                 |
| **Neo4j**           | - To encode <br>- **explicit, relational knowledge** ➝ facts, ontologies <br>- enabling complex, multi-hop reasoning ➝ that vectors alone cannot do             |
| **LangGraph**       | - To move beyond linear chains <br>- to **stateful, cyclic, conditional workflows** ➝ that mirror complex human scientific reasoning                            |
| **vLLM/TGI**        | - To **efficiently serve open-source LLMs** at scale <br>- with high throughput  ➝ crucial for cost-effective agent deployment                                  |
| **Kubeflow/ArgoCD** | - To enforce **GitOps + reproducibility** <br>- for both data pipelines + the application itself ➝ a must for enterprise partners                               |
| **NVIDIA Triton**   | - To achieve **low-latency, high-throughput inference** <br>- for critical models ➝ embedding, reranking ➝  in the retrieval loop                               |
| **Ray AIR**         | - To provide a **unified framework** for `scaling` <br>- **data processing** <br>- **training**<br>- **serving** of components ➝ within the `agentic ecosystem` |
| **Prometheus/W&B**  | - To implement <br>- **production ML observability** <br>- **tracking system performance** <br>- **LLM behavior** ➝ to catch **drift/regression**               |

- This architecture wasn't just about stacking tools  
	- it was about **orchestrating them into a resilient system** ➝ where the whole was greater than the sum of its parts 
	- turning a promising RAG concept into a platform that delivered tangible scientific and operational ROI

---
#### Phase 1: Data Ingestion & Knowledge Graph Construction

**Goal:** Transform raw, unstructured text into a dual-format, queryable knowledge foundation.  
**Core Concept:** Create two synchronized representations of knowledge: one for semantic similarity (vectors) and one for logical relationships (graph).

##### 1. Document Processing & Semantic Chunking:    
- **Process:** Raw PDFs/patents/reports are ingested. Text and metadata (title, authors, publication date) are extracted. Instead of splitting text arbitrarily by character count, **semantic chunking** is unstructured
- **Specifics:** A sentence embedding model (e.g., `bert-base-uncased`) analyzes sentence boundaries and topical coherence. The algorithm groups sentences into chunks that represent a single concept, experimental finding, or method description (e.g., "The E545K mutation in PIK3CA leads to increased kinase activity and alters binding affinity to Alpelisib."). This preserves context far better than fixed-size windows.
- **Output:** A corpus of clean, contextually coherent text chunks, each with associated source metadata.
        
##### 2. Entity Extraction & Relationship Modeling:
- **Process:** Each text chunk from Step 1 is analyzed to extract structured scientific facts.
    - **Specifics:** A hybrid NLP pipeline is employed:
        - A pre-trained **spaCy NER model** identifies common entity types (e.g., proteins, chemicals).
        - For complex, domain-specific entities (e.g., specific mutation codes like `E545K`, proprietary compound codes), a **fine-tuned LLM (via LangChain)** performs few-shot extraction. The LLM is prompted with examples to pull out precise entities and their stated relationships from the text.
- **Schema Definition:** A labeled property graph schema is designed in **Neo4j**. Example node labels: `Protein`, `Mutation`, `Compound`, `Pathway`. Relationship types are defined based on scientific interactions: `HAS_MUTATION`, `INHIBITS`, `BINDS_TO`, `REGULATES`.
- **Output:** A list of structured triples: `(Entity A)-[Relationship]->(Entity B)`.
        
3. **Dual Storage Ingestion:**
    - **Process:** The outputs from Step 1 and Step 2 are loaded into their respective optimized databases, with a critical cross-reference link established.
    - **Specifics - Vector Store (Weaviate):**
        1. Each _text chunk_ from Step 1 is converted into a high-dimensional **vector embedding** using a model like `BAAI/bge-large-en`.
        2. The chunk text, its vector embedding, and all its metadata are stored as an object in Weaviate.
    - **Specifics - Graph Store (Neo4j):**
        1. The extracted entities and relationships (triples) from Step 2 are created as nodes and edges in Neo4j.
        2. **Crucial Link:** The unique ID of the Weaviate chunk _from which a fact was extracted_ is attached as a property to the corresponding Neo4j nodes. This creates a bidirectional link between a factual claim in the graph and its source textual evidence in the vector store.

--
### Phase 2: The Core Retrieval Engine (Hybrid GraphRAG)

**Goal:** Given a user query, retrieve the most relevant and precise information by combining semantic search with graph reasoning.  
**Core Concept:** Run vector and graph searches in parallel, then fuse and re-rank the results for comprehensive context.

1. **Query Processing & Intent Understanding:**
    - **Process:** The natural language query is analyzed.        
    - **Specifics:** Basic NLP (via spaCy) identifies key entity mentions. More importantly, **LangChain's query decomposition** can break a complex query ("Find compounds that inhibit mutant PIK3CA but avoid CYP3A4 inhibition") into sub-queries or clarify the intent for different retrieval paths.
        
2. **Parallel Retrieval Pathways:**
    - **Path A - Semantic (Vector) Search in Weaviate:**
        - The full query is embedded into the same vector space as the document chunks.
        - A **hybrid search** is performed: `Dense Vector Similarity (kNN)` finds semantically similar chunks, while `Sparse Keyword Search (BM25)` ensures key terms are matched.
        - **Output:** A list of text chunks ranked by _semantic and lexical relevance_ to the query. This provides _breadth_ and can surface conceptually related information that doesn't share exact entity names.
            
    - **Path B - Relational (Graph) Search in Neo4j:**
        - The entities extracted from the query are used to formulate a **Cypher query**
        - This query traverses the pre-defined relationship paths in the knowledge graph
        - **Example Cypher Logic:** `MATCH (p:Protein {name:'PIK3CA'})<-[:TARGETS]-(c:Compound) WHERE NOT (c)-[:INHIBITS]->(:Enzyme {name:'CYP3A4'}) RETURN c.name, c.properties`. This performs **multi-hop reasoning** (PIK3CA <- Compound -/-> CYP3A4) that is impossible with vectors alone.
        - **Output:** A list of precise, structured facts, entity names, and sub-graphs that _exactly_ match the relational logic of the query.
            
3. **Result Fusion & Context Synthesis:**
    - **Process:** The two distinct result sets (semantic chunks from Weaviate, precise facts from Neo4j) are combined
    - **Specifics:** A **Cross-Encoder Reranker** (e.g., `BAAI/bge-reranker-large`) is the key. It takes the original query and each candidate item (a text chunk _or_ a graph fact) and scores their pairwise relevance directly. This allows it to intelligently rank a graph-derived fact against a text chunk
    - **Output:** A single, re-ordered list of information items—blending detailed explanatory text with precise factual answers—that forms the **final, enriched context** sent to the LLM.

--
### Phase 3: Agentic Workflow Orchestration

**Goal:** Automate multi-step, conditional scientific reasoning tasks by orchestrating LLM calls and tool use.  
**Core Concept:** Move beyond a single Q&A to a stateful workflow where an LLM "agent" decides the sequence of actions based on intermediate results.

1. **Workflow Definition as a State Machine (LangGraph):**
    - **Process:** A scientific task (e.g., "Review literature on target X and propose a novel combination therapy") is modeled as a graph.
    - **Specifics:** Nodes in the **LangGraph DAG** represent "tools" or "actions": `retrieve_background`, `query_for_compounds`, `predict_toxicity`, `generate_hypothesis`, `draft_report`. Edges between nodes are **conditional** (e.g., `IF toxicity_high THEN find_alternative ELSE proceed_to_draft`). A shared `State` dictionary is passed between nodes, accumulating context, results, and decisions.
        
2. **Tool Integration for the Agent:**
    - **Process:** All capabilities (the Hybrid GraphRAG retriever, Neo4j lookup, internal bioinformatics APIs, data calculators) are wrapped into standardized **LangChain Tools**.
    - **Specifics:** When the workflow reaches a `query_knowledge_graph` node, it calls the tool that executes the **entire Phase 2 logic**. The agent doesn't know the internal complexity; it only receives the synthesized context.
        
3. **LLM as the Stateful Reasoning Engine:**
    - **Process:** At nodes requiring decision-making or synthesis, the current workflow `State` is formatted into a prompt for the LLM.
    - **Specifics:** The LLM's role is to: a) **Decide** the next step based on instructions and results so far, b) **Interpret** the output from called tools, c) **Synthesize** information into a coherent narrative or hypothesis.
    - **Infrastructure:** Using **vLLM** or **TGI** for serving open-source LLMs (like Llama 3) allows for high-throughput, continuous batching, which is essential for handling many concurrent, long-running agent sessions cost-effectively.
    
--
### Phase 4: Productionization & MLOps

**Goal:** Transform the system into a scalable, reliable, and observable enterprise platform.  
**Core Concept:** Apply software engineering and ML operations best practices to every component.

1. **Pipeline Orchestration & GitOps:**
    - **Data Pipeline:** The **Phase 1** ingestion process is containerized and orchestrated as a **Kubeflow Pipeline**. It runs on a schedule or triggers automatically when new data lands in a storage bucket.
    - **Application Deployment:** The entire agent application (API, graphs, tools) is managed via **GitOps (ArgoCD)**. Pushing code to a Git repository automatically triggers synchronized, versioned deployments to the Kubernetes cluster, ensuring reproducibility and rollback capability.
        
2. **High-Performance, Scalable Serving:**
    - **Model Serving:** The embedding and reranking models (critical for low-latency retrieval) are deployed on **NVIDIA Triton Inference Server** for optimized GPU utilization and sub-millisecond latency
    - **API & Agent Serving:** The main application logic is served via **FastAPI**. The stateful LangGraph agent workflows are deployed using **Ray Serve**, which provides dynamic scaling, batching, and built-in state management for long-running agent sessions.
        
3. **Comprehensive Observability & Validation:**
    - **Metrics & Monitoring:** **Prometheus** collects system metrics (latency, error rates, GPU usage), visualized in **Grafana**. **Weights & Biases (W&B)** is used to track and version all LLM prompts, completions, and costs, enabling debugging of "hallucinations."
    - **RAG-Specific Validation:** A separate **RAGAS** evaluation pipeline runs routinely against a golden set of Q&A pairs. It automatically scores the system's performance on dimensions like **Answer Faithfulness** (is the answer grounded in the context?), **Context Relevance** (is the retrieved context useful?), and **Answer Correctness**, providing continuous quality assurance.
    
--
### Phase 5: Optimization & Impact Measurement

**Goal:** Quantify and improve the platform's scientific and operational return on investment (ROI).

1. **Workflow Time Reduction (Measured ~60%):**    
    - **Measurement Process:** Scientists were timed completing standardized tasks (e.g., "compile all known resistance mechanisms for drug Y") using traditional methods (manual database search, paper reading, note-taking). The same task was then performed using the platform.
    - **Source of Savings:** The automation of **Phases 1 & 2** (instant retrieval and synthesis of fragmented information) and **Phase 3** (automated multi-step analysis and report drafting) eliminated the majority of manual labor. The 60% figure represents the saved "wall-clock" time.
        
2. **Predictive Performance Improvement (Measured 10-15%):**
    - **Process:** The platform's output was used to enhance traditional predictive models (e.g., a GNN for protein-ligand binding).
    - **Specifics:** The **Agentic Workflow (Phase 3)** was tasked with mining the literature for novel, non-obvious features—e.g., "find allosteric sites mentioned for protein family Z" or "extract regulatory effects from phosphorylation studies." These text-mined features, which were absent from standard molecular descriptors, were added to the model's training data.
    - **Validation:** The accuracy boost (10-15%) was rigorously validated through **A/B testing** on held-out experimental datasets, comparing the model's performance with and without the agent-derived features.

--

> [!example] **Summary**: The Integrated Flow

The power of this architecture lies in the **sequential dependency and feedback** between phases:

- **Phase 1** creates the fundamental knowledge assets.
- **Phase 2** provides the core intelligence to query those assets, serving both end-users and the automated agent in **Phase 3**.
- **Phase 3** leverages this intelligence to execute complex tasks, generating valuable outputs and novel insights
- **Phase 4** ensures the entire system is robust, scalable, and measurable, providing the metrics for **Phase 5**.
- **Phase 5** uses those metrics and outputs to prove value and generate new data/requirements, which feed back into **Phase 1** for continuous refinement of the knowledge base and system capabilities.

This creates a closed-loop, continuously improving platform that turns unstructured data into validated scientific insight.


---

> [!NOTE]
> ### What This Outline Provides:
> 
> 1. **Complete Architectural Vision:** It defines the **entire data and control flow**, from raw documents to final insights, including all major subsystems and how they interconnect.
> 2. **Explicit Phase Dependencies:** The sequential and parallel processes are clearly defined (e.g., Phase 1 _must_ complete before Phase 2 can function; Phase 2 feeds both end-users and Phase 3)
> 3. **Technology Stack Justification:** For each major component (Weaviate, Neo4j, LangGraph, Triton, etc.), the document states the **strategic reason** for its selection, guiding equivalent tool choices.
> 4. **Detailed Process Specifications:**
>     - _How_ chunking should work (semantic, not fixed-size).
>     - _What_ entities and relationships to extract.
>     - _How_ to link vector and graph stores (via chunk ID references).
>     - _How_ retrieval fusion works (parallel paths + cross-encoder reranking).
>     - _How_ the agent workflow is structured (state machine with conditional edges).
>     - _How_ performance is measured (RAGAS, time trials, A/B testing).
> 5. **MLOps & Productionization Strategy:** It outlines the essential "platform" requirements: orchestrated pipelines, containerized deployment, high-performance serving, and comprehensive observability, which are often the missing pieces in research prototypes.
> 6. **Success Criteria Definition:** It specifies _what to measure_ (workflow time, predictive accuracy improvement) and _how to measure it_ (comparative studies, held-out dataset validation).

---
### Condensed Flow Chart 

```text

ENTERPRISE GraphRAG & AGENTIC GENAI PLATFORM
────────────────────────────────────────────

PHASE 1: DATA INGESTION & KNOWLEDGE CONSTRUCTION
┌──────────────────────────────────────────────┐
│ Unstructured Documents → Semantic Chunking → │
│ Entity/Relation Extraction (spaCy/LLM)       │
└────────────────┬─────────────────────────────┘
                 │
          ┌──────┴──────┐
          │ Dual Storage│
          └──────┬──────┘
          ┌──────┴──────┐
   VECTOR DB         KNOWLEDGE GRAPH
   (Weaviate)         (Neo4j)
   • Embeddings       • Entities
   • Chunk text       • Relationships
   • Metadata         • Cross-ref IDs
──────────────────────────────────────────────

PHASE 2: HYBRID RETRIEVAL ENGINE
        User Query
           │
    ┌──────┴──────┐
    ▼             ▼
Vector Search   Graph Traversal
(Weaviate)      (Neo4j Cypher)
• Dense (kNN)   • Multi-hop queries
• Sparse (BM25) • Relationship paths
    │             │
    └─────┬───────┘
          ▼
    Result Fusion & Reranking
    (Cross-encoder)
          │
          ▼
    Final Context for LLM
──────────────────────────────────────────────

PHASE 3: AGENTIC WORKFLOW ORCHESTRATION
         LangGraph DAG
┌─────────────────────────────┐
│ State Machine:              │
│ 1. Retrieve → 2. Query KG → │
│ 3. Reason → 4. Generate     │
│    (Conditional flow)       │
└─────────────┬───────────────┘
              │
       ┌──────┴──────┐
       ▼             ▼
    LLM Service   Tool Execution
    (vLLM/TGI)    (Various APIs)
       │             │
       └─────┬───────┘
             ▼
      Agent Orchestrator
──────────────────────────────────────────────

PHASE 4: SERVING & OBSERVABILITY
         High-Perf Serving
    ┌──────────────────────┐
    │ Triton (Embed/Rerank)│
    │ vLLM (LLM Inference) │
    └──────────┬───────────┘
               │
        ┌──────┴──────┐
        ▼             ▼
   API Layer     Observability
 (FastAPI/Ray)  • RAGAS Scores
                • W&B Traces
                • Prometheus Metrics
        │             │
        └─────┬───────┘
              ▼
        Final Outputs:
   • Structured Reports
   • API Responses
   • Actionable Insights
              │
              ▼
   CI/CD & Pipeline Orchestration
   (Kubeflow, ArgoCD, Tekton)
        ← Feedback Loop →
```

> The architecture shows:
> 1. **Linear left-to-right, top-to-bottom flow** that's easier to follow
> 2. **Clear phase separation** with horizontal dividers   
> 3. **All major components** preserved (Weaviate, Neo4j, LangGraph, Triton, etc.)
> 4. **Critical relationships** maintained (dual storage, hybrid retrieval, agent orchestration)
> 5. **Feedback loop** for continuous improvement

---
#### Step 1 

```
RAW DATA → KNOWLEDGE FOUNDATION
────────────────────────────────

Unstructured Documents           Entity/Relation
(PDFs, Patents, Reports)        Extraction Layer
         │                       (spaCy + Custom LLMs)
         │ Semantic Chunking             │
         ▼                               ▼
  ┌──────────────┐              ┌─────────────────┐
  │  SEMANTIC    │              │  KNOWLEDGE      │
  │   CHUNKS     │              │    GRAPH        │
  │              │              │   (Neo4j)       │
  │ • Context-preserving│       │                 │
  │ • Embedding-ready   │       │ • Proteins      │
  │                     │       │ • Compounds     │
  └──────────────┘      │       │ • Relationships │
         │              │       │ • Chunk_ID refs │
         │ Embedding    │       └─────────────────┘
         │ (bge, ada)   │
         ▼              │
  ┌──────────────┐      │
  │  VECTOR DB   │◀─────┘
  │  (Weaviate)  │
  │              │
  │ • Embeddings │
  │ • Chunk text │
  │ • Metadata   │
  │ • Cross-ref to Neo4j│
  └──────────────┘
```

---

#### Step 2 

```text 

QUERY PROCESSING → INTELLIGENT RETRIEVAL
────────────────────────────────────────

         User Query
      ("Find inhibitors for PIK3CA")
             │
    ┌────────┴────────┐
    ▼ Parse &         ▼ Entity
  Identify Intent   Extraction
             │             │
    ┌────────┴────────┐    │
    ▼                 ▼    ▼
┌──────────┐      ┌───────── ─┐
│ VECTOR   │      │ GRAPH     │
│ SEARCH   │      │ TRAVERSAL │
│(Weaviate)│      │ (Neo4j)   │
├──────────┤      ├───────── ─┤
│• Dense:  │      │• Cypher   │
│  kNN     │      │  queries  │
│• Sparse: │      │• Multi-hop│
│  BM25    │      │  paths    │
│• Hybrid  │      │• Precise  │
│  scoring │      │  facts    │
└──────────┘      └───────── ─┘
        │             │
        └──────┬──────┘
               ▼
      ┌─────────────────┐
      │ RESULT FUSION & │
      │    RERANKING    │
      │                 │
      │• Combine vector │
      │  + graph results│
      │• Cross-encoder  │
      │  reranking      │
      │• Context        │
      │  synthesis      │
      └─────────────────┘
               │
               ▼
      Enriched, Ranked Context
      (Ready for Agent Reasoning)
```

---
#### Step 3


```
STATEFUL AGENT REASONING
────────────────────────

         LangGraph DAG
    (State Machine Workflow)
    ┌─────────────────────┐
    │ STATE: {            │
    │   query, context,   │
    │   history, tools    │
    │ }                   │
    └─────────┬───────────┘
              │
    ┌─────────┴─────────┐
    ▼ Conditional Node Execution ▼
┌─ ──────┐ → ┌───────┐ → ┌───────┐
│RETRIEVE│   │ANALYZE│   │REASON │
│Context │   │ KG    │   │w/ LLM │
└── ─────┘   └───────┘   └───────┘
    │           │           │
    │           │           ▼
    │           │    ┌──────────┐
    │           │    │  LLM     │
    │           │    │ SERVICE  │
    │           │    │(vLLM/TGI)│
    │           │    └──────────┘
    │           │           │
    │           └─────┬─────┘
    │                 │
    ▼                 ▼
┌─────────────────────────────────┐
│      TOOL EXECUTION LAYER       │
│                                 │
│• Query Knowledge Graph          │
│• Call internal APIs             │
│• Execute scientific calculators │
│• Fetch real-time data           │
└─────────────────────────────────┘
              │
              ▼
       ┌────────────  ──┐
       │  AGENT         │
       │ ORCHESTRATOR   │
       │ (LangGraph)    │
       │                │
       │• Manages state │
       │• Routes flow   │
       │• Handles errors│
       └─────────────  ─┘
              │
              ▼
      Final Structured Output
```


---
#### Step 4


```
PRODUCTION SERVING & FEEDBACK LOOP
──────────────────────────────────

        Inference Layer
   ┌──────────────────────┐
   │ HIGH-PERFORMANCE     │
   │   MODEL SERVING      │
   ├──────────────────────┤
   │• Triton: Embedding,  │
   │  Reranking models    │
   │• vLLM: LLM inference │
   │  with optimization   │
   └──────────┬───────────┘
              │
        ┌─────┴─────┐
        ▼           ▼
┌─────────────┐ ┌─────── ──────┐
│   API       │ │ OBSERVABILITY│
│   LAYER     │ │   STACK      │
├─────────────┤ ├────── ───────┤
│• FastAPI/   │ │• RAGAS:      │
│  Ray Serve  │ │  Retrieval   │
│• Webhooks   │ │  quality     │
│• Async      │ │• W&B: LLM    │
│  processing │ │  traces      │
└─────────────┘ │• Prometheus: │
        │       │  metrics     │
        ▼       └───────────── ┘
┌─────────────┐        ↑
│   OUTPUT    │        │ Monitoring
│   FORMATS   │        │ triggers
├─────────────┤        │
│• Structured │        │
│  reports    │◀───────┘
│• API resp.  │
│• Insights   │
└─────────────┘
        │
        ▼
┌─────────────────────┐
│ CI/CD & GOVERNANCE  │
│   (GitOps Engine)   │
├─────────────────────┤
│• Kubeflow Pipelines │
│• ArgoCD deployments │
│• Tekton CI/CD       │
│• MLflow lineage     │
│• Automated retraining│
│  on drift detection │
└─────────────────────┘
        ↑
        │
    Feedback Loop:
    Performance metrics →
    trigger pipeline updates
```


> [!NOTE]
> 1. **Dual Knowledge Representation**: Vector (semantic) + Graph (relational)    
> 2. **Hybrid Retrieval**: Parallel search paths with fusion
> 3. **Stateful Agents**: LangGraph DAGs with conditional execution
> 4. **Production Resilience**: Serving + Observability + GitOps automation
> 5. **Closed Feedback Loop**: Metrics drive continuous improvement

