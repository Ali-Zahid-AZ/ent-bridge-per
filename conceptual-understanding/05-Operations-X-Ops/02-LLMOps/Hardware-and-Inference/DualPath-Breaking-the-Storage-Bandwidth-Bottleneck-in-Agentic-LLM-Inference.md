---
tags:
  - research-article
  - llmops
  - llmops-architecture
  - llmops-agentops-inference
  - llmops-bottlenecks
  - llm-attention-mechanism
---

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

- arXiv ➝ [arXiv: DualPath: Breaking the Storage Bandwidth Bottleneck in Agentic LLM Inference](https://arxiv.org/abs/2602.21548)
- Pdf in Directory ➝ [Dir: DualPath-Breaking-the-Storage-Bandwidth-Bottleneck-in-Agentic-LLM-Inference-2026.pdf](<file:///home/az/04-Library/05-Operations-X-Ops/02-LLMOps/Hardware-and-Inference/DualPath-Breaking-the-Storage-Bandwidth-Bottleneck-in-Agentic-LLM-Inference-2026.pdf>)
- [[LLM-Inference-Unveiled-Survey-and-Roofline-Model-Insights]]
- [[A-Survey-on-Efficient-Inference-for-Large-Language-Models]]
- [[Project-Transformer-from-Scratch-Conceptual]] ➝ Contains comprehensive breakdown of the transformer components 
---

> [!quote] **Relevanence** 
> - Understanding how to circumvent hardware limits via **Clever Network Routing** 
> - Understanding how **Prefill-Decode Disaggregation** bottlenecks LLMOps architectures 
> - Understanding how **MI** can be done in such system ➝ **LLMOps Platforms** 

---
### 1. Overview

#### I. The Problem 

> - Multi-turn agentic LLM interactions are highly I/O-bound ➝ with **KV-Cache** hit rates typically exceeding 95% 
> - In standard **disaggregated architectures** ➝ loading this massive **context history** from ➝ **persistent storage** 
> 	- bottlenecks the **prefill engines** storage Network Interface Cards ➝ NICs
> - Meanwhile ➝ the decoding engines' storage NICs sit completely idle

> #llmops-kv-cache | #llmops-storage | #llmops-platform-design | #agentops-multi-agent-system-design | #llmops-architecture | #llmops-prefill-decode-disaggregation | #llmops 
	
#### II. The Solution 

> The authors present DualPath ➝ a system that breaks this bottleneck ➝ by enabling a **secondary** `storage-to-decode` **loading path**



#### II. Key Methodologies

##### I. Dual-Path Loading 

> KV-Cache is loaded from storage into the idle decoding engines ➝ then transferred to the prefill engines using the high-bandwidth low-latency compute network ➝ **RDMA**
    
##### II. CNIC-centric Traffic Management 

> - To prevent this massive data transfer from disrupting latency-critical model operations ➝ like AllToAll communications 
> 	- the system forces all host-to-device memory copies 
> 	- through the compute NIC ➝ **CNIC** ➝ using hardware-level Quality of Service ➝ QoS ➝ virtual lanes
        
##### III. Adaptive Request Scheduler 

> - A global scheduler 
> 	- dynamically directs traffic 
> 	- to the path ➝ prefill or decode
> 	- with the shortest storage read queue to balance the load
        
##### IV. Significance 

> - If we are designing LLMOps platforms ➝ to run large-scale MI experiments ➝ on long-context agents
> 	- the physical speed at which we can load the context history dictates the iteration speed 
> - This paper provides a masterclass in treating cluster bandwidth as a 
> 	- pooled
> 	- schedulable resource 
> 	- rather than a set of isolated hardware limits

> #career  | #mechanistic-interpretability | #llmops-platform-design 


![[Pasted image 20260312021252.png | 600]]

#### III. Explanations: First Principles of the Infrastructure

> - The architecture of a modern LLM fundamentally relies 
> 	- on the **autoregressive generation** of tokens
> 	- which necessitates ➝ **caching** ➝ past key and value vectors ➝ to avoid recomputing the entire sequence
> - In an agentic setting ➝ **context** grows **linearly** over hundreds of turns
> 	- shifting the primary bottleneck ➝ from tensor core FLOPS ➝ to PCIe + storage network bandwidth
> - By recognizing that 
> 	- the `east-west` **compute fabric** ➝ Inter-GPU NVLink/RDMA ➝ has vastly more **aggregate bandwidth** and **different utilization spikes** 
> 	- than the `south-north` **storage network** 
> 	- DualPath achieves a higher global throughput without upgrading physical hardware

> #llmops-architecture | #llm-autoregressive-perspective | #agentic-platform 

##### I. The East-West Compute Fabric: The Lateral Sync

> - Think of East-West traffic as ➝ **internal, lateral movement** ➝ within the **exact same tier** ➝ of the infrastructure
> - This is 
> 	- server-to-server
> 	- node-to-node
> 	- and GPU-to-GPU communication

###### I. The Mechanics 

> - This is the InfiniBand or **RoCE** network ➝ RDMA over Converged Ethernet 
> - It connects the Compute NICs ➝ **CNICs** ➝ across all the nodes in the cluster
    
###### II. The LLM Workload

- During inference ➝ models like DeepSeek-V3 or Llama-3 ➝ are sliced across multiple GPUs using 
	- Tensor Parallelism ➝ TP
	- or Expert Parallelism ➝ EP
- When GPU 1 calculates its piece of a matrix ➝  it must instantly share that result with GPU 2, 3, and 4 to finish the layer 
- This requires operations like `AllReduce` or `AllToAll`

###### III. The Constraint

- East-West traffic is characterized by **sub-millisecond, ultra-dense bursts** 
- It demands 
	- absolutely massive bandwidth ➝ $400\text{ Gbps}$ to $800\text{ Gbps}$ per link 
	- and near-zero latency
- If this fabric stutters for even a microsecond ➝ the entire GPU cluster sits idle waiting for the math to sync
    
##### II. The North-South Storage: Ingress Fabric ➝ The Vertical Fetch

> - Think of North-South traffic as ➝ **external + vertical movement** ➝ entering or leaving the compute cluster 
> - In traditional IT ➝ this means traffic from the internet hitting the API gateway
> - In an AI hardware context ➝ it specifically refers to the compute nodes fetching massive datasets from an external storage tier ➝ like the distributed NVMe SSDs

###### I. The Mechanics 

> - This fabric relies on 
> 	- the **Storage NICs** ➝ SNICs 
> 	- on **each node** 
> 	- connecting to the **external file system** ➝ like 3FS or an object store

###### II. The LLM Workload

- This is where the **KV-Cache** lives
- When the **NOC Operations Agent** wakes up to process turn 15 of a diagnostic loop 
	- the Prefill node must reach `North` ➝ out of the compute fabric ➝ into the storage fabric 
	- to pull 50,000 tokens of historical state down into its host memory

> [[Systems-LTD-AI-Architect-Final-Interview]] | [[Project-Enterprise-Telecom-Main]]] | #systemsltd 

###### III. The Constraint

- North-South traffic handles ➝ **sustained, massive volume transfers** 
- It is highly bandwidth-intensive 
	- but slightly more latency-tolerant than East-West traffic 
	- because it is fetching static files rather than synchronizing live matrix math
    
##### III. DualPath Paper: Exploits ➝ North-South & East-West Geometry 

> The entire genius of the paper comes down to ➝ **manipulating** these **2 directional fabrics**

- In a standard system ➝ the Prefill Engine tries to pull terabytes of KV-Cache straight down the **North-South** storage connection
	- The Storage NIC physically hits its bandwidth ceiling ➝ example: $400\text{ Gbps}$) ➝ the GPU starves ➝ waiting for data
- DualPath realizes that the **East-West** compute fabric ➝ which connects the Prefill nodes to the Decode nodes 
	- has far more aggregate bandwidth and different utilization spikes 
	- So, the system does this:
		1. It tells the `idle` Decode node to fetch the KV-Cache via its own **North-South** connection
		2. Once the data hits the Decode node ➝ it blasts it laterally across the **East-West** compute network directly into the Prefill node's memory
    
>- By **routing** the data through the **East-West fabric** ➝ they **bypass** the **North-South bottleneck entirely** 
>- It's essentially using the **Decode nodes** as high-speed data smugglers to feed the Prefill nodes

##### IV. The Mechanics of Autoregressive Generation

- The term **autoregressive** means ➝ that the system **predicts future values** ➝ based **entirely** on its own **past values** 
- In the context of LLMs it means 
	- the model can only generate one token at a time 
	- and every new token becomes part of the input for the next token

> Mathematically ➝ the model is computing the **conditional probability of the next token** $x_{t+1}$ ➝ given the **entire history** of **preceding tokens** $x_{1}, \dots, x_{t}$

$$P(x_{t+1} | x_{1}, x_{2}, \dots, x_{t})$$

> - If we **give** an LLM a prompt of **100 tokens** and ask it to **generate 50 tokens** ➝ it does not spit out 50 tokens in 1 forward pass 
> 	- It must run a **complete forward pass** ➝ through all 80+ layers ➝ just to **calculate the logits** ➝ for token 101
> 	- Then, it appends token 101 to the input ➝ and runs `another` complete forward pass of 101 tokens ➝ to predict token 102
> 	- Because token 102 strictly depends on the **physical existence of token 101** ➝ this process is strictly **sequential** 
> 	- It **cannot** be **parallelized**

> #llm-autoregressive-perspective 

##### V. The Computational Waste: Without Caching

> - Consider the Attention mechanism at a specific layer 
> - To calculate attention ➝ the model **projects** the **input** into 
> 	- **Query** ➝ $Q$
> 	- **Key** ➝ $K$
> 	- **Value** ➝ $V$ 
> - **matrices**

$$\text{Attention}(Q, K, V) = \text{softmax}\left(\frac{QK^T}{\sqrt{d_{k}}}\right)V$$

Imagine we are generating token 102. To figure out what token 102 should pay attention to, we generate a Query vector for it ($Q`{102}$). This $Q`{102}$ must compute the dot product against the Key vectors of `all` previous tokens ($K`1$ through $K`{101}$) to get the attention scores.

**If we do not cache:**

The model would have to take the embeddings for tokens 1 through 101, push them through the residual stream, and multiply them by the $W`K$ and $W`V$ weight matrices all over again just to recreate $K`1 \dots K`{101}$ and $V`1 \dots V`{101}$.

Doing this for every single generation step results in $O(n^2)$ redundant matrix multiplications. It is an astronomical waste of Tensor Core FLOPS because the history (tokens 1 through 100) `has not changed`.

##### VI. The KV-Cache: Freezing the Activation Space

Because the past tokens are immutable, their projections into the Key and Value spaces at every single layer are also immutable.

Instead of throwing these vectors away after predicting token 101, the system writes them to a dedicated memory block: the **KV-Cache**.

When it is time to predict token 102, the GPU only has to push `one single token` (token 101) through the weights. It calculates a single $Q`{102}$, a single $K`{102}$, and a single $V`{102}$. It then concatenates this new $K$ and $V$ with the frozen history sitting in the KV-Cache, computes the attention scores, and moves on.

##### VII. The MI Perspective

From an MI standpoint, the KV-Cache is not just a storage optimization; it is the physical manifestation of the residual stream's history.

When you study **induction heads**—the circuits responsible for copying patterns like `if you see 'Barack' followed by 'Obama' in the past, output 'Obama' now`—those heads are mechanically scanning the KV-Cache. The Query of the current token is mathematically sweeping across the frozen Key vectors in the cache, searching for specific geometric alignments in the activation space.

If you purge the cache, you purge the agent's memory. This is why in multi-turn telecom agent workflows, saving that cache to an external SSD is required; it is the physical `state` of the agent's reasoning up to that point.

#### III. The Results

- **Offline Inference (e.g., RL Training Rollouts):** DualPath improved end-to-end throughput by up to $1.87\times$ over the baseline system when tested on models like DeepSeek-V3.2 660B.
    
- **Online Serving:** It improved the online serving throughput by an average factor of $1.96\times$ without violating the Service Level Objectives (SLO) for time-to-first-token.
    
- **Load Balancing:** The dynamic scheduler successfully improved the storage NIC maximum-to-average traffic ratio from $1.53$ down to $1.18$.
    

#### IV. Connection to Mechanistic Interpretability (MI)

While this paper lives purely in the systems domain (hardware, RDMA, networking), it solves a critical mechanical friction point for MI.

At the weight and activation level, the KV-Cache is the physical manifestation of the residual stream's history. When we study attention circuits—specifically how **induction heads** copy historical tokens to predict the next token—those heads are mathematically querying the $K$ matrices stored in this exact cache.

If you are running Logit Lens experiments or causal tracing over 100k-token agentic trajectories, your GPUs spend the vast majority of their time just waiting for the storage disks to feed them the historical activations. By utilizing a dual-path pipeline, you are essentially parallelizing the delivery of the geometric activation space to the GPU memory, allowing you to run large-scale circuit analyses at nearly double the speed.

----
### 2. LLMOps: 3 Core Architectural Patterns  

> These 3 core architectural patterns from first principles, focusing on the mechanical `Why` and `How` at the weight and activation level.

### 1. Prefill-Decode (PD) Disaggregation

- **The Concept:** Physically separating the GPUs that process the prompt (Prefill) from the GPUs that generate the response (Decode).
    
- **The Mechanical `Why`:** These two phases are mechanically hostile to each other. Prefill is **compute-bound**. It takes a massive block of new tokens, multiplies them by the $W`K$ and $W`V$ weight matrices simultaneously, and saturates the GPU's Tensor Cores with dense matrix multiplications. Decode is **memory-bandwidth bound**. To generate just `one` new token, the model must read the entire historical KV-Cache from memory just to calculate attention scores, leaving the compute cores mostly idle while waiting for data. Forcing them to share a GPU ruins efficiency.
    

### 2. Layer-Wise Prefill

- **The Concept:** Computing the prefill phase one transformer layer at a time, moving the KV-Cache in and out of the GPU's High Bandwidth Memory (HBM) sequentially.
    
- **The Mechanical `Why`:** When calculating the geometry of the activation space for a massive batch of long prompts, the resulting Key and Value tensors are too enormous to fit in the GPU's HBM all at once. If you try to hold the KV-Cache for all 80 layers simultaneously, your maximum batch size shrinks to near zero. By processing Layer 1, saving its cache, and then clearing the memory for Layer 2, the system fundamentally bypasses the HBM capacity bottleneck, allowing for massively parallel prompt processing.
    

### 3. External KV-Cache Storage

- **The Concept:** Dumping the historical KV-Cache onto distributed, persistent external storage (like SSDs) rather than keeping it in expensive GPU HBM or host DRAM.
    
- **The Mechanical `Why`:** In agentic loops, the context history (the persistent state of the residual stream) grows turn by turn. Because over 95% of these tokens are reused across turns, recomputing their activations from scratch every time would be a colossal waste of FLOPS. However, storing millions of tokens of KV vectors across thousands of concurrent agents requires terabytes of space. HBM is too small and too expensive, so the cache is parked on cheaper external SSDs and fetched only when needed.
    

---

### The Architecture in Motion

When an agent invokes a multi-turn task, the system dances through these steps:

1. **Load:** The Prefill Engine grabs the historical KV-Cache (from previous turns) off the massive external SSD.
    
2. **Crunch:** It computes the initial Keys and Values for any `newly appended` tokens layer-by-layer, packing as many requests as possible into the batch to maximize GPU utilization.
    
3. **Handoff:** Once the full context is digested into a complete KV-Cache, the Prefill Engine blasts this massive tensor state across a high-speed compute network (RDMA) directly to a dedicated Decode Engine.
    
4. **Generate:** The Decode Engine takes over, running the autoregressive loop to tick out tokens one by one.
    
5. **Persist:** Once the generation turn finishes, the Decode Engine writes its newly updated, longer KV-Cache back to the external SSD, freezing the state until the agent makes its next move.

> #axiom | #llmops-architecture | #llmops-prefill-decode-disaggregation | #llmops-platform-design 