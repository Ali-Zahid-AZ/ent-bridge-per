---
tags:
  - research-2024
  - llmops
  - agentops
  - llmops-agentops-inference
  - review-survey-articles
  - llm-lrm-mathematical-foundations
  - reading-list
  - llmops-prefill-decode-disaggregation
  - llmops-prefill-phase
  - llmops-decode-phase
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

- Pdf in Directory: [Pdf Dir: LLM-Inference-Unveiled-Survey-and-Roofline-Model-Insights-2024.pdf](<file:///home/az/04-Library/05-Operations-X-Ops/02-LLMOps/Hardware-and-Inference/LLM-Inference-Unveiled-Survey-and-Roofline-Model-Insights-2024.pdf>)
- Directory: [Dir: 📂 Open: Hardware-and-Inference](<file:///home/az/04-Library/05-Operations-X-Ops/02-LLMOps/Hardware-and-Inference>)
- arXiv: [arXiv: LLM Inference Unveiled: Survey and Roofline Model Insights](https://arxiv.org/abs/2402.16363)
- [Efficient Inference for LLMs: A Survey](https://www.emergentmind.com/papers/2404.14294)
- [The Efficiency Spectrum of Large Language Models: An Algorithmic Survey](https://www.emergentmind.com/papers/2312.00678)
- [LLM Compression: A Survey](https://www.emergentmind.com/papers/2308.07633)
- [Efficient LLM Serving Survey](https://www.emergentmind.com/papers/2312.15234)
- [Faster and Lighter LLMs: A Survey on Current Challenges and Way Forward](https://www.emergentmind.com/papers/2402.01799)
- Citation arXiv: [Citation: arXiv: Retrieval-Augmented Generation for AI-Generated Content: A Survey](https://arxiv.org/abs/2402.19473)
- [Retrieval-Augmented-Generation-for-AI-Generated-Content-A-Survey-2024.pdf](<file:///home/az/04-Library/05-Operations-X-Ops/03-AgentOps/Architectures/Retrieval-Augmented-Generation-for-AI-Generated-Content-A-Survey-2024.pdf>)
- [[Retrieval-Augmented-Generation-for-AI-Generated-Content-A-Survey]] 
- [[Large-Language-Models-A-Survey]]

- [[Project-Transformer-from-Scratch-Conceptual]] ➝ Contains comprehensive breakdown of the **transformer components** ➝ #Project-Transformer-from-Scratch 
- [[Conceptual-Basics-LLMs-Mechanistic-Architecture]] ➝ #llm-transformer-architecture | #llm-keys-values-query-weight-vectors 
- [[Anthropic-In-Context-Learning-and-Induction-Heads]]
- [[Conceptual-Inference-LLMOps]] ➝ #llmops-agentops-inference | #llmops-agentops-inference-metrics 
- [[DualPath-Breaking-the-Storage-Bandwidth-Bottleneck-in-Agentic-LLM-Inference]] ➝  #llmops-prefill-decode-disaggregation | #llmops-prefill-phase | #llmops-decode-phase 
- [[A-Survey-on-Efficient-Inference-for-Large-Language-Models]] ➝  #llmops-prefill-phase | #llmops-decode-phase | #llmops-prefill-decode-disaggregation 
- [[Attention-Is-All-You-Need-Vaswani]] ➝ #llm-dual-encoder-decoder-architecture | #llm-single-decoder-architecture 
---
### 1. Introductory 

> - This paper is arguably the most critical text for understanding the **hardware-level mechanics** of LLM inference 
> - It uses the `Roofline Model` 
> 	- a **standard performance model** in **high-performance computing** 
> 	- to physically map out ➝ why **autoregressive generation** bottlenecks the hardware 

> #llm-autoregressive-perspective | #llm-roofline-model-perspective | #high-performance-computing-HPC | #llmops-bottlenecks | #llmops-memory-bottlenecks  
> #llmops-hardware-mechanics | #llmops-agentops-inference | [[Conceptual-vLLMs-LLMOps]] | [[Conceptual-Inference-LLMOps]] | [[Conceptual-KV-Cache-LLMOps]]

> - This paper spans various areas including 
> 	- model **compression** 
> 	- decoding **algorithm refinement** 
> 	- system-level + hardware-level **enhancements**

> [!quote] Have a look in the Paper for **Figure 2:  Mind-map of the Survey on Efficient LLM Inference**

#### I. The Problem

> - LLMs are heavily **constrained** by their 
> 	- colossal **parameter** counts 
> 	- **memory** requirements ➝ [[Conceptual-KV-Cache-LLMOps]]
> 	- making them exceptionally difficult to deploy efficiently 

> - During the **generation phase** 
> 	- the process of `predicting` tokens 
> 	- **sequentially** forces the hardware ➝ to constantly shuffle massive amounts of data back and forth 
> 	- **starving** the `compute units` of actual work

> - **High-level metrics** like `throughput` or `latency` do not explain `why` the GPU is stalling 
> - The paper addresses the severe variability in `Arithmetic Intensity` (the ratio of Floating Point Operations to memory bytes accessed) across different inference stages.

> #llmops-agentops-latency | #llmops-agentops-inference-metrics-latency-percentiles-p95  | #llmops-agentops-inference-metrics-latency-percentiles-p99 
> #llmops-agentops-inference-metrics-phase-specific-latency  | #llmops-agentops-inference-metrics-throughput | #llmops-agentops-inference-metrics-throughput-RPS 
> #llmops-agentops-inference-metrics-throughput-TPS | #llmops-arithemtic-intensity 

#### II. Solution

The authors systematically evaluate the current landscape of LLM optimization—spanning model compression, fast decoding algorithms, and hardware optimization. They introduce a tool called the LLM-Viewer, which applies the `Roofline Model` to mathematically diagnose whether a specific layer in an LLM is bottlenecked by computation capacity or memory bandwidth.




#### III. Rudimentary Explanations 

**Layman Explanation** Imagine a brilliant chef (the GPU's compute core) who can chop vegetables at lightning speed, but has to walk across a massive kitchen to fetch every single carrot from the fridge (the hardware memory). The bottleneck isn't the chopping; it's the walking. This paper provides a `kitchen layout map` (the Roofline model) to prove exactly where the chef is wasting time waiting for ingredients, and then reviews every known strategy to fix it—like bringing out 10 carrots at once (batching), putting a mini-fridge next to the cutting board (operator fusion), or chopping smaller, lower-quality carrots (quantization).

**Technical Explanation** The paper applies the Roofline model to LLM inference, graphing theoretical maximum hardware performance (OPS) against a layer's Arithmetic Intensity (OPs/byte).

- **Prefill Stage:** Processing the initial prompt happens in parallel, yielding high arithmetic intensity, meaning this stage is largely limited by how fast the GPU can crunch numbers (compute-bound).
- - **Prefill:** The authors model the prefill phase as a classic General Matrix Multiply (GEMM) operation. Because the entire prompt is processed simultaneously, the arithmetic intensity is high. The bottleneck hits the `computational roof` of the hardware. The model's weights and the prompt's token vectors are loaded into the GPU's SRAM once, and massive parallel matrix multiplications occur.
        
    
- **Decode Stage:** Autoregressive generation processes one token at a time, requiring the entire model's weights and the Key-Value (KV) cache to be repeatedly loaded into the chip's buffer. This results in extremely low arithmetic intensity, trapping the model strictly in the memory-bound region where compute units remain idle.

    - **Decode:** The paper mathematically demonstrates why the autoregressive decode phase crashes into the `memory bandwidth roof.` Because it operates token-by-token, the operation devolves into a Matrix-Vector Multiplication (GEMV). For every single token generated, the entire weight matrix of the model and the dynamically growing KV cache must be loaded from High-Bandwidth Memory (HBM) into SRAM. The compute cores sit idle waiting for data transfer.
        

#### Methods Used

- **Roofline Model Analysis:** Developing the LLM-Viewer to calculate and plot the OPs/byte for individual Transformer layers, quantifying exact hardware bottlenecks.
    
- **Model Compression Taxonomy:** Evaluating techniques that physically shrink the model, including Quantization-Aware Training (QAT), Post-Training Quantization (PTQ), pruning, and low-rank factorization.
    
- **Algorithmic Fast Decoding:** Reviewing methods that reduce the number of parameters loaded per token, such as early exiting (bypassing depth), contextual sparsity (bypassing width), and Speculative Decoding (using a smaller draft model to parallelize memory loads).
    
- **System and Hardware Optimization:** Analyzing compiler-level techniques like Operator Fusion (merging layers to avoid writing intermediate activations to memory) and PagedAttention for memory management.

#### Results

- Through the LLM-Viewer, the authors proved that during the decoding stage of models like Llama-2-7b, practically all operations (like `qk`matmul` and projection layers) fall well below the hardware's turning point, operating entirely in the memory-bound zone.
    
- Quantizing weights to lower bit-widths (e.g., INT8 or INT4) directly reduces the bytes transferred, increasing arithmetic intensity and significantly lowering inference time for small batch sizes.
    
- As sequence lengths scale (e.g., >50k tokens), the KV cache begins to dominate memory consumption, making KV cache quantization (like W4KV4 or KV2) an absolute necessity to prevent out-of-memory errors and maintain throughput.



**he Physics Before the Engineering (Yuan et al.)** The Roofline paper establishes the absolute mechanical ground truth. It does not start with software; it starts with the silicon. By mapping inference to the Roofline model, it defines the absolute physical boundaries of what your GPU can mathematically achieve. It forces you to look at the prefill and decode phases purely as floating-point operations colliding with memory bandwidth limits. You have to understand these hard physical constraints before you can understand why modern inference infrastructure is built the way it is.

**The System Architecture (Zhou et al.)** Once you have the physical bottlenecks locked in your mind from the first paper, read **A Survey on Efficient Inference for Large Language Models**. This paper will now read less like a list of software tricks and more like a tactical engineering manual. When Zhou et al. discuss PagedAttention or Continuous Batching, you will instantly recognize them not just as `optimizations,` but as necessary software interventions designed to bypass the exact hardware bottlenecks you just read about in the Roofline model.


#### Connection to Mechanistic Interpretability

- **Circuit Analysis & Early Exiting:** Early exiting algorithms skip deeper layers entirely because a token's representation often `saturates` early in the residual stream. This is the exact mechanical behavior you observe when using the logit lens. Understanding which layers can be safely skipped helps isolate the absolute minimum causal circuit required for a specific behavior.
    
- **Superposition Theory & Contextual Sparsity:** The paper discusses methods like Deja Vu, which exploit the fact that up to $80\%$ of contextual weights can be dynamically ignored per token. This physical sparsity is the hardware manifestation of polysemantic neurons disentangling themselves; you are looking at the runtime footprint of superposition.
    
- **Geometry of Activation Spaces & Quantization:** When activations are heavily compressed to formats like FP4 or INT2, the geometry of the activation manifolds is aggressively discretized. Studying which features survive this extreme quantization tells you which representational geometries are most robust.
    

---

#### Stress Test for Good Practices & Applicability


**Significance & Personal Importance:** For your trajectory toward becoming a Principal AI Architect who can design mathematical algorithms from scratch, understanding the physical limits of hardware is non-negotiable. When you are mapping out causal circuits or studying activation manifolds, knowing exactly `why` certain weights are bypassed or quantized physically grounds your theoretical Mechanistic Interpretability (MI) models into actual, deployable hardware realities.

This paper represents a gold standard for practical MLOps and Platform Ops engineering. Grounding algorithmic improvements in the rigorous mathematical bounds of the Roofline model bridges the gap between theoretical AI research and actual hardware deployment. The open-source nature of their LLM-Viewer makes the framework immediately applicable. The only minor limitation is that hardware architectures evolve rapidly; the specific boundaries plotted for an NVIDIA A6000 will shift with next-generation chips, though the core methodology remains universally valid.

Absolutely. If you want to master LLMOps and design neural architectures from scratch, internalizing the physics of the Roofline model is mandatory. You cannot architect an efficient, agentic MI-first system if your beautiful mathematical circuits stall out on the memory bus. Mastering this paper ensures your models will actually run in the real world.

 If you are designing LLMOps platforms or exploring Platform Ops at the metal level, these papers provide the exact first principles needed. You cannot design a highly optimized inference pipeline without modeling the arithmetic intensity of your specific hardware against the token-by-token memory bandwidth penalties outlined in these surveys.

---
### Section 1: Introduction


The core thesis of this paper is that the massive scale of modern LLMs creates a severe physical bottleneck during inference. While there is abundant research on `how` to compress these models, the authors identify a gap: the community lacks a systematic, mathematically grounded framework to measure `where` and `why` a model is bottlenecking on a specific piece of hardware.

To solve this, they introduce the **LLM-Viewer**, an analytical tool built on the `Roofline Model`. This framework allows architects to stop guessing and instead mathematically diagnose whether a specific layer in an LLM is starved for computation or starved for memory bandwidth.

---
### Section 2: Delve into LLM Inference and Deployment

#### I. LLMs: Decoder only Architecture

> This section strips down the **Transformer decoder architecture** + explains the `2` distinct physical phases of inference 

> - _'A concise overview of the (Transformer decoder architecture) fundamental structure_ ➝ refer to this survey **Zhao et al. 2023** for a more in-depth understanding
> - [[Retrieval-Augmented-Generation-for-AI-Generated-Content-A-Survey]]

> [[Attention-Is-All-You-Need-Vaswani]] ➝ this note contains the reasons for shifting from the #llm-dual-encoder-decoder-architecture to the #llm-single-decoder-architecture  

> - The **architecture** emphasied in this paper is the #llm-single-decoder-architecture ➝ which is the basis of most of the #large-language-models-LLMs + #large-reasoning-models-LRMs prevalent today 
> - This structure comprises 
> 	- an **embedding layer** 
> 	- a series of **sequential** Transformer layers 
> 	- and a **prediction head**

![[Pasted image 20260330051659.png | ]]


> [!quote] Tracing exactly how **data physically moves** through the #llm-single-decoder-architecture 

##### I. The Embedding Layer: From Text to Vectors

> - When we input a prompt ➝ the text is split into discrete `tokens` 
> - The hardware cannot compute text ➝  so the **Embedding Layer** acts as a massive lookup table 
> - It **maps** ➝ each discrete token into a **continuous** + **high-dimensional vector** called a **hidden state** ➝ #llm-activation-vector-hidden-state 
> - Mechanically this is ➝ the **translation step** that turns words into ➝ the exact shape and format ➝ required for the GPU's matrix multiplication units

###### I. Hidden State ➝ Activation Vector 

> - In strict architectural terms 
> 	- a **hidden state** 
> 	- an **activation vector** 
> 	- are the exact same physical thing

> The mechanical breakdown of **why the terms** #llm-activation-vector-hidden-state **overlap**

> - **The Vector**
> 	- When the **embedding layer** ➝ translates a discrete token ➝ into an array of ➝ 4096 numbers (considering dimensions) ➝ that specific array is the **vector**

> - **Why it's called a Hidden State** 
> 	- From a **systems design perspective** ➝ it is called `hidden`
> 	- Because it represents ➝ the **internal data state** ➝ of the `token` 
> 		- between the user's input ➝ the `prompt`
> 		- and the model's output ➝ the `prediction` 
> 	- It is the i**ntermediate math** that the user never sees

> - **Why it's called an Activation**
> 	- From a computational perspective 
> 		- those numbers are the literal `activations`
> 		- currently **held in the GPU's memory registers** ➝ at that exact step in the process
    
>- **The Stream** 
>	- What is often called the #llm-activation-space-stream ➝ or #llm-residual-stream-additive-shared-communication-channel ➝ is simply the **physical pipeline** 
>	- It is the **journey** of that specific vector 
>		- as it is `handed` from the **embedding layer** 
>		- `updated` by Layer 1 
>		- `passed` to Layer 2
>		- and so on until the `end`

> So when the paper refers to the `hidden state` ➝ it is pointing to the **exact same high-dimensional array** of numbers flowing through the **activation stream**

> #llm-residual-stream-additive-shared-communication-channel | #llmops-embedding-unembedding-layer-embedding-matrix 

###### II. Embedding & Unembedding Layer 

> - #llmops-embedding-unembedding-layer-embedding-matrix ➝ act as the **physical tollbooths** between 
> 	- discrete human language 
> 	- the model's continuous mathematical space

> - **The Embedding Layer** ➝ The Input Tollbooth
> 	- `The Physical Structure` 
> 		- Imagine a massive 2D matrix ➝ a spreadsheet ➝ stored in the hardware's memory 
> 		- The **number of rows** ➝ equals the model's total vocabulary ➝ example: $50,000$ tokens 
> 		- The **number of columns** ➝ is the **hidden dimension** ➝ example: $4096$ values
> 	- `The Mechanistic Action` 
> 		- Text is just arbitrary symbols 
> 			- When the tokenizer hands the hardware a token ID ➝ let's say `ID: 402` for the word `apple` ➝ the hardware cannot `compute` the number 402 
> 		- Instead it uses 402 as an **index**  
> 		- It goes exactly to **row 402** in that massive matrix ➝ **copies** those $4096$ numbers
> 	- `The Geometric Intuition` 
> 		- This lookup ➝ **assigns** the **token** its **initial coordinate** ➝ in the high-dimensional #llm-activation-space-stream #llm-residual-stream-additive-shared-communication-channel 
> 		- The model learned ➝ during **pre-training** ➝ to **position these rows** ➝ so that **words** with **similar meanings** ➝ start near each other 
> 		- We are physically mapping a **discrete + isolated symbol** ➝ into a **continuous spatial geometry**

> - **The Unembedding Layer: Prediction Head** ➝ The Output Tollbooth
		- `The Physical Structure` 
			- This is the **final matrix** at the very end of the network 
			- It is essentially the **exact inverse** of the **embedding matrix** ➝ its dimensions are $4096 \times 50,000$
	    - `The Mechanistic Action`
		    - After the **token's vector** has been 
			    - pushed + rotated + enriched ➝ by passing through **every Transformer layer** 
			    - it arrives at the end of the network as a **highly complex** + **context-aware** 4096-dimensional vector 
			- The hardware must now **translate** this math ➝ back into a human word
> 	- `The Geometric Intuition` 
> 		- To do this ➝ the hardware computes ➝ the #mathematics-dot-product ➝ the **geometric similarity** 
> 			- between this **final vector** and **every single token** ➝ in the $50,000$-word vocabulary matrix 
> 		- It is **measuring** how perfectly the **final vector's trajectory** aligns with the **target vector** for `apple`, `king`, `run`, etc
> 	- `The Result` 
> 		- The **word** whose vector aligns most perfectly ➝ with the final activation vector ➝ gets the **highest mathematical score** ➝ the **logit** 
> 		- The hardware then applies ➝ a #llm-functions-softmax ➝ to turn these alignment scores ➝ into the final probability distribution

![[Pasted image 20260330071509.png | 790 ]]

##### II. The Transformer Layers: The Core Engine

These hidden state vectors are then fed sequentially through a tall stack of identical **Transformer layers**. Each layer acts as a distinct processing block that updates the vector. Within every single layer, the data must pass through two specific architectural sub-modules:

- **Masked Multi-Head Attention (MHA):** This is the data routing mechanism. It allows the current token to mix with and extract information from the vectors of previous tokens. The `Masked` constraint ensures that the architecture strictly prevents the current token from looking ahead at future tokens (which is critical for autoregressive generation). Mechanically, this is where the Query, Key, and Value matrices are computed, and where the memory-heavy Key-Value (KV) cache is built and read.
    
- **Multi-Layer Perceptron (MLP):** Once the MHA has mixed information _between_ different tokens in the sequence, the output is passed to the MLP. The MLP operates on each token's vector entirely independently. Architecturally, it is a dense, fully connected feed-forward network that applies non-linear transformations to the vector. If MHA is about moving context around, the MLP is about processing and retrieving the stored features within that specific token's vector.
    

##### 3. The Prediction Head: Vectors to Probabilities

After the vector has been updated by the MHA and MLP in layer 1, it is passed to layer 2, and so on, until it exits the very last layer. This final, heavily processed hidden state is sent to the **Prediction Head**. This is a final linear projection matrix that maps the high-dimensional vector back down to the exact size of the model's vocabulary. It yields a probability distribution that mechanically dictates the most likely next token to generate.

#### 2.1 The Two Stages of Inference

- **The Prefill Stage:** The model ingests the entire prompt sequence at once to generate the initial Key-Value (KV) cache. Because it processes a massive chunk of tokens simultaneously (matrix-matrix multiplication), it is highly compute-dense. In MI terms, this is where the model rapidly calculates the initial geometry of the activation space.
    
- **The Decode Stage:** This is the autoregressive phase where the model predicts one token at a time. For every single token generated, the hardware must reload the `entire` model weight matrix and the `entire` historical KV cache from memory into the chip's buffer. Because it is only calculating a single vector against these massive matrices (matrix-vector multiplication), the compute units sit idle waiting for data to arrive.


#### The Prefill Stage (Processing the Prompt)

- **The Operation:** The model ingests your entire input sequence all at once.
    
- **The Architecture:** It runs this sequence through the Transformer layers to calculate the initial Key-Value (KV) cache for every single token in your prompt.
    
- **The Hardware Reality:** Because it processes a large batch of tokens simultaneously, this involves massive matrix-matrix multiplications. This is highly efficient for hardware; the compute cores are fully saturated and crunching numbers at peak capacity.
    

#### The Decode Stage (Generating the Answer)

- **The Operation:** The model generates the output text step by step, one token at a time.
    
- **The Architecture:** To predict just one new token, the model must load the previously stored KV cache along with the entire set of model weights. It calculates the new token, generates a new Key and Value for it, appends those to the existing KV cache, and then repeats the loop.
    
- **The Hardware Reality:** This stage relies on matrix-vector multiplication. The compute cores finish the math almost instantly but then sit idle, waiting for the massive KV cache and weight matrices to be physically moved from the memory into the computation units for the next token. This is why decoding is heavily bottlenecked by memory bandwidth.






**2.2 The Roofline Model** The authors use the Roofline model to map these physical realities onto hardware performance. It measures theoretical maximum performance (Operations Per Second) against a layer's **Arithmetic Intensity** (Operations per byte of memory accessed).

- **Compute-Bound (The Green Zone):** High arithmetic intensity. The hardware is bottlenecked by how fast the ALUs can crunch numbers. The prefill stage typically lives here.
    
- **Memory-Bound (The Red Zone):** Low arithmetic intensity. The hardware is bottlenecked by the physical speed of the memory bus fetching data. The decode stage is almost entirely trapped here.
    

**2.3 The LLM-Viewer** This is their proposed open-source diagnostic tool. It ingests model layer information (tensor shapes, dependencies), hardware specs (memory bandwidth, max FLOPS), and inference configurations (batch size, sequence length) to generate a precise Roofline report for every single layer in the network.

---

### Section 3: Model Compression

If the decode stage is choked by memory bandwidth, the most direct physical solution is to shrink the amount of data being moved. The authors categorize these strategies into four areas:

**3.1 Quantization** This involves converting high-precision floating-point weights (FP16/FP32) into discrete, lower-bit formats (INT8, INT4). By cutting the physical size of the weights in half or more, the memory bus can fetch them much faster, artificially raising the arithmetic intensity and pushing the layer closer to the compute-bound zone.

- **Post-Training Quantization (PTQ):** Quantizing after training. It is computationally cheap but risks destroying activation outliers. Techniques like AWQ are discussed, which protect a small percentage of `salient` weights to preserve the causal circuitry without retraining.
    
- **Quantization-Aware Training (QAT):** Integrating the quantization constraints directly into the training loop so the model's gradient descent adapts to the precision loss from the start.
    
- **KV Cache Quantization:** As context windows stretch (e.g., beyond 50k tokens), the KV cache eventually consumes more memory than the model weights. Quantizing the KV cache to 4-bit or 2-bit becomes a strict physical necessity to prevent Out-Of-Memory (OOM) failures.
    

**3.2 Pruning** Identifying and physically removing redundant parameters.

- **Unstructured Pruning:** Zeroing out individual weights. While this preserves the activation geometry well, it is historically terrible for actual hardware acceleration because memory access becomes irregular.
    
- **Structured Pruning:** Ripping out entire attention heads or MLP columns. This maps perfectly to hardware and provides immediate speedups, but brutally severs entire circuits and induction heads, often requiring heavy fine-tuning to recover performance.
    

**3.3 Knowledge Distillation** Transferring the capabilities of a massive `teacher` model into a smaller `student` model.

- **White-Box:** The student model is granted access to the teacher's internal weights and hidden states, learning to mimic the precise mathematical representations of the teacher.
    
- **Black-Box:** The student only sees the final input-output pairings (logits) of the teacher, essentially learning from synthetic datasets generated by the larger model.
    

**3.4 Factorization** Decomposing massive weight matrices into the multiplication of two smaller, low-rank matrices. In MI terms, this relies on the principle that the actual semantic concepts and causal mechanisms operate in a much lower-dimensional subspace than the raw parameter count of the model suggests.