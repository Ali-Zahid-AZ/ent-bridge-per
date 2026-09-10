---
tags:
  - llm-transformer-architecture
  - llm-foundational-texts
  - research-article
  - llm-fundamentals
  - llm-attention-mechanism
  - llm-self-attention
  - mechanistic-interpretability-attention-heads
  - research-2023
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

- Pdf in Directory: [Pdf Dir: Vaswani-Attention-Is-All-You-Need-Article-2023.pdf](<file:///home/az/04-Library/03-Deep-Learning-and-Architectures/02-Architectures/LLMs-LRMs-Large-Language-Reasoning-Models/Transformers/Vaswani-Attention-Is-All-You-Need-Article-2023.pdf>)
- Directory: [📂 Open: Transformers](<file:///home/az/04-Library/03-Deep-Learning-and-Architectures/02-Architectures/LLMs-LRMs-Large-Language-Reasoning-Models/Transformers>)
- arXiv:  [arXiv: Attention Is All You Need](https://arxiv.org/abs/1706.03762)
- [[Conceptual-The-Illustrated-GPT-2-Visualizing-Transformer-Language-Models]]
- [[Conceptual-Intertwined-Concepts-MI]]
- [[RoPE-LIME-RoPE-Space-Locality-Sparse-K-Sampling-for-Efficient-LLM-Attribution]]
- [[RoFormer-Enhanced-Transformer-with-Rotary-Position-Embedding]]
- Contains comprehensive breakdown of the transformer components ➝ [[Project-Transformer-from-Scratch-Conceptual]]
- [[Conceptual-Basics-LLMs-Mechanistic-Architecture]]
- [[Conceptual-Basics-Anatomy-of-Compute-Feature-Manifolds-Circuit-Topologies]]
- [[Conceptual-KV-Cache-LLMOps]]
- [[Conceptual-Dot-Product-Intuition-LLMs]]
- [[Conceptual-Attention-Heads-MI]]
---

> - The original 2017 `Attention Is All You Need` paper introduced 
> 	- a dual-stack **Encoder-Decoder** architecture 
> 	- specifically designed for `sequence-to-sequence` **translation tasks** ➝ like English to French

> #llm-dual-encoder-decoder-architecture | #llm-single-decoder-architecture 

> The industry later bifurcated ➝  but for modern **generative LLMs** ➝ like GPT, Llama, Qwen, DeepSeek ➝ the architecture overwhelmingly shifted to **Decoder-Only**

> - To understand `why` this shift happened from first principles ➝ consider `how` 
> 	- the **computational graph** 
> 	- the **weight matrices**  
> 	- and the **residual stream** 
> - `behave` in these different setups

> #llm-residual-stream-additive-shared-communication-channel | #llm-residual-stream-additive-shared-communication-channel 

---
### 1. 2017 Architecture: Dual Stack

> In the original paper ➝ the **2 stacks** had fundamentally **different geometries** of `information flow`

> [[Anthropic-A-Mathematical-Framework-for-Transformer-Circuits-Main]]
> [[Anthropic-A-Mathematical-Framework-for-Transformer-Circuits-Section-by-Section]]

#### I. The Encoder: Bidirectional

> - It `processes` the `entire input` sequence **simultaneously** 
> - Its self-attention mechanism is `unmasked`  ➝ meaning token $i$ can attend to both 
> 	- token $i-1$ ➝ past 
> 	- and $i+1$ ➝ future  
> - Its job is to build a rich `static `contextualized **mathematical representation** ➝ of the `input text` in its **residual stream**
    
#### II. The Decoder: Unidirectional + Cross-Attention

> - It `generates` output **autoregressively** ➝ one token at a time 
> - It uses `masked self-attention` ➝ token $i$ **can only look at the past** ➝ so it doesn't cheat by looking at the future 
> - Crucially, it also contains **Cross-Attention** matrices 
> 	- where the $Q$ ➝ come from the **Decoder's residual stream** 
> 	- but the $K$ + $V$ ➝ are pulled from the output of the **Encoder**
    
> #llm-autoregressive-perspective | #llmops-decode-phase | #llm-self-attention | #llm-cross-attention-weight-matrices | #llm-keys-values-query-weight-vectors | #llmops-prefill-phase 

---
### 2. Why the Industry Moved to Decoder-Only

> - When the `goal` shifted from translation ➝ **generalized text generation** + **zero-shot reasoning** 
> 	- researchers realized ➝ that the **Encoder stack** + the **Cross-Attention weights**
> 	- were `mathematically redundant`

#### I. A Unified + Evolving Residual Stream

> - In an **encoder-decoder model** ➝ we have `2` **separate residual streams** + **cross-attention mapping** between them 
> - In a **decoder-only architecture** ➝ there is `1` **unified residual stream** 
> 	- The `prompt` is simply fed into this stream as ➝ **a sequence of tokens** 
> 	- Because it uses **masked self-attention**  
> 		- the model builds the `context` of the `prompt` **dynamically** in the **early tokens** 
> 		- and uses that **exact same pathway** ➝ to `generate` the new tokens

> #llm-residual-stream-additive-shared-communication-channel | #llm-residual-stream-additive-shared-communication-channel | [[Conceptual-Residual-Stream-Geometric-Mechanistic]] | #llmops-tokenization-tokens 

> [[Conceptual-Tokens]]

#### II. The Emergence of Induction Circuits

> - Mechanistic Interpretability has shown that **in-context learning**  
> 	- the ability to read a prompt + follow its pattern 
> 	- is largely driven by **Induction Heads**
> - These are **highly specific circuits** ➝ that form **across multiple attention layers** 
> - essentially performing a search operation 
> 	- `I am looking at token A, find me a previous instance of token A, and tell me what token B came immediately after it` 
> - **Decoder-only** architectures 
> 	- forced to `predict` the **next token continuously** using only past context  
> 	- naturally evolve **dense + highly efficient induction circuits** ➝ within their attention layers 
> - An **encoder** isn't needed to `understand` the prompt ➝ the **decoder's early layers** do that work naturally

> #llm-emergent-properties | [[Conceptual-Emergent-Properties-in-LLMs]] | #mechanistic-interpretability-induction-heads | #mechanistic-interpretability-induction-heads | #mechanistic-interpretability-reasoning-circuits  

> #mechanistic-interpretability-in-context-learning | [[Anthropic-In-Context-Learning-and-Induction-Heads]]
 
#### III. Elimination of Cross-Attention Overhead

> - At the matrix multiplication level ➝ Cross-Attention requires ➝ a c**omplex routing of activation spaces** ➝ from the end of one network ➝ into the middle of another 
> - By moving to `Decoder-Only` ➝ we eliminate the $W_Q, W_K, W_V$ matrices ➝ dedicated to cross-attention 
> - This vastly `simplifies` the **memory geometry** 
> - It allows for highly optimized `KV Caching` ➝ storing the **Key** and **Value** vectors of **past tokens**  
> 	- because every `token`
> 		- whether it was **part of the prompt** 
> 		- or **generated** by the model 
> 	- lives in the **exact same dimension** + follows the exact same mathematical rules

> #llm-keys-values-query-weight-vectors 

#### IV. The Pretraining Objective

> - The simplest + most scalable mathematical objective for training a neural network ➝ is next-token prediction ➝ autoregressive modeling  
> - We take 
> 	- a **massive corpus** of text 
> 	- drop it into the **sequence** 
> 	- and **train** the model to **guess** the next word 

> A decoder-only architecture ➝ perfectly mirrors this `causal structure natively` ➝ without needing parallel inputs + targets

> - The transition was a move toward **architectural purity** 
> - By forcing a `single` continuous residual stream to handle both 
> 	- `reading` the prompt 
> 	- `writing` the output 
> 	- models were **forced** to learn 
> 		- **deeper** 
> 		- more **generalized internal features** ➝ like **induction** + **multi-hop logic** 
> 	- rather than relying on a separate `encoder` to do the reading for them

----
