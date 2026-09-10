---
tags:
  - deepseek-ocr
  - deepseek
  - Project-Pdf-Parser-Arabic-English
  - llmops-agentops-production-frameworks
  - llm-architectures
---

---
```table-of-contents
```
---
### References



> [!info] .
>
>**[Obsidian Links]** 
> `$= dv.list(dv.current().file.outlinks.filter(l => l.path.endsWith(".md")))`
>
>---
>
>**[External Links]**
> `$= const content = await dv.io.load(dv.current().file.path); const regex = /\[(.*?)\]\((https?:\/\/[^\s)]+)\)/g; const links = []; let m; while (m = regex.exec(content)) { links.push("[" + m[1] + "](" + m[2] + ")"); } dv.list([...new Set(links)])`
>
>---
>
>**[Directory Links]**
> `$= const content = await dv.io.load(dv.current().file.path); const regex = /\[(.*?)\]\(<(file:\/\/\/.*?)>\)/g; const links = []; let m; while (m = regex.exec(content)) { links.push("[" + m[1] + "](<" + m[2] + ">)"); } dv.list([...new Set(links)])`
>
>---
>
>**[Back Links]**
> `$= dv.list(dv.current().file.inlinks)`
> 

---
### Primitives 

- [[Project-Pdf-Parser-Arabic-English-Main]]
- [[Project-Pdf-Parser-Arabic-English-Implementation-Phase-1]]
- GitHub ➝ [GitHub: DeepSeek OCR 2](https://github.com/deepseek-ai/DeepSeek-OCR-2) 
- Paper Link ➝  [Paper Online: DeepSeek OCR 2](https://github.com/deepseek-ai/DeepSeek-OCR-2/blob/main/DeepSeek_OCR2_paper.pdf)
- Model Weights on Huggingface ➝ [Huggingface: DeepSeek-OCR-2](https://huggingface.co/deepseek-ai/DeepSeek-OCR-2)   
- Pdf in Directory ➝ [Dir: DeepSeek-OCR2-Visual-Causal-Flow-2026.pdf](<file:///home/az/04-Library/03-Deep-Learning-and-Architectures/02-Architectures/Large-Language-Models-LLMs/Architecture-Families/DeepSeek-Architectures/DeepSeek-OCR2-Visual-Causal-Flow-2026.pdf>)
---
###  1. The Fundamental Problem It Solves

> - Traditional OCR systems ➝ and even many modern VLMs ➝ process images in a fixed **raster scan order** 
> 	- from top-left to bottom-right 
> 	- line by line
> 	- like a mechanical printer

> - This works for simple paragraphs ➝ but fails catastrophically on documents humans consider normal:
		- Multi-column scientific papers
		- Tables with headers that define the meaning of rows below
		- Mixed text and formulas
		- Bilingual documents where the right-to-left column should be read _after_ the left column

> [DeepSeek-OCR 2 : Changed How Machines Read Documents - Webkul Blog](https://webkul.com/blog/deepseek-ocr-2/amp/)
    
> DeepSeek-OCR 2's core thesis is that `reading order` should be **determined** ➝ by `semantic meaning` ➝ **not pixel coordinates** 

---
### 2. Core Architecture: DeepEncoder V2 & Visual Causal Flow


> The model retains the **encoder-decoder framework** of its predecessor but **replaces** the `vision encoder` with a revolutionary new design ➝ **DeepEncoder V2** 

> #llm-dual-encoder-decoder-architecture 

#### I. From CLIP ➝ LLM-based Encoder

##### I. DeepSeek Version 1

- Used a CLIP ViT encoder
- CLIP is excellent at feature extraction but poor at deep, sequential reasoning about how visual elements relate

###### I. CLIP

> - **CLIP** 
> 	- Contrastive Language-Image Pre-training 
> 	- is a **foundational vision-language model** architecture developed by OpenAI 
> - Mechanistically, it solves the problem of ➝ **aligning two completely different data distributions**
> 	- raw pixel geometry 
> 	- discrete text tokens
> - into a single + unified mathematical space

###### II. First Principles of CLIP

> - Before CLIP ➝ vision models were trained to predict fixed categories ➝  a `cat` or `dog` label
> - CLIP discarded this classification bottleneck ➝ instead used a **Contrastive Learning Objective** ➝ across massive datasets of image-text pairs scraped from the internet

> It operates using **2 separate neural networks**
> - **The Vision Encoder** 
> 	- A Vision Transformer (ViT) or ResNet that 
> 		- takes an image
> 		- processes its high-frequency and low-frequency features
> 		- and projects it into a dense, high-dimensional vector
> - **The Text Encoder** 
> 	- A standard language transformer that 
> 		- takes a text caption
> 		- processes its semantic meaning
> 		- and projects it into a vector of the exact same dimensions
    
###### III. CLIP: The Mechanistic Interpretability Perspective

> - The `magic` of CLIP happens ➝ in the **latent space** ➝ during **training**
> - It uses a **contrastive loss function** ➝ specifically **InfoNCE** ➝ to govern the geometry of this shared manifold

> - **The Matrix Multiplication** 
> 	- During training, a batch of $N$ image vectors and $N$ text vectors are multiplied against each other, creating an $N \times N$ similarity matrix

> - **Vector Alignment** 
> 	- The model calculates the cosine similarity between every image and every text snippet 
> 	- The loss function applies gradients that physically `pull` the paired vectors
> 		- example ➝ the vector for an image of a dog and the vector for the text `a picture of a dog`
> 		- closer together in the activation space
> 		- maximizing their dot product
> 	- Simultaneously, it `pushes` all mismatched pairs apart

> - **The Result**
> 	- CLIP creates an **omni-modal manifold**
> 	- If we plot the activation vectors 
> 		- the geometric coordinate for the visual features of a stop sign 
> 		- occupies the exact same region as the text token for the word `stop`    

###### IV. Why it Fails at Sequential Reasoning ➝ The OCR Problem

> CLIP is a phenomenal feature extractor but fundamentally **lacks causal reasoning**

- When CLIP processes a document page ➝ ts attention heads globally pool the visual features into a representation of `what` is on the page 
	- example ➝ `This looks like a contract with Arabic text and a table`
- However, because it relies on ➝ static, bidirectional attention and a global contrastive loss 
	- it has no structural concept of 
		- reading order
		- layout boundaries 
		- or causality 
	- It cannot traverse ➝ the visual manifold ➝ step-by-step
		- it just gives a **highly accurate static summary** of the **entire 2D space** ➝ **at once**
	- This is exactly why DeepSeek-OCR 2 had to replace it with a Qwen2 causal reasoning engine to achieve proper Left-to-Right or Right-to-Left token ordering

###### V. CLIP: Citation

> - A. Radford et al. Learning transferable visual models from natural language supervision
> - arXiv ➝ [arXiv: CLIP: Learning Transferable Visual Models From Natural Language Supervision-2021](https://arxiv.org/abs/2103.00020)

##### II. DeepSeek Version 2 

- Replaces CLIP with a **compact language model** ➝ **Qwen2-0.5** ➝ 500M parameters
- This transforms the **encoder** from a **passive feature extractor** ➝ into an **active visual reasoning engine**

###### I. Qwen2-0.5B

- Qwen2-0.5B is a miniature `brain` ➝ by Alibaba Cloud
- While most famous LLMs have hundreds of billions of parameters ➝ this one only has half a billion ➝ **500M** parameters
- Because it is so small ➝ it is incredibly fast and lightweight 
- Usually, it is used to **process text**, but in this architecture ➝ the researchers `tricked` it into **reading compressed images** ➝ as if they were a foreign language

> #llm-architectures-qwen | #llm-architectures 

###### II. Qwen2-0.5B: The Technical Analysis

- Qwen2-0.5B is a  ➝ dense **decoder-only transformer model**
- Mechanistically, it is built entirely on **causal** ➝ **autoregressive** ➝ **self-attention**
	- It is trained to ➝ **predict** the **next token in a sequence** ➝ given the **preceding context**
	- By **stripping away** its **text-embedding layer** + feeding it the 896-dimensional visual tokens from the SAM-based tokenizer
		- the model acts as a powerful sequence processor 
		- that treats visual patches as discrete vocabulary items in a high-dimensional latent space

###### II. Why Was Qwen2-0.5B Chosen?

> #deepseek | #deepseek-ocr | #llm-architectures-qwen 

> Based on the paper and the mechanistic logic of the architecture, it was chosen for **3 primary reasons**:

- **Parameter and Compute Parity**
	- Replacing a vision encoder with an LLM could easily blow up the computational budget 
	- However the original CLIP ViT used in DeepSeek-OCR v1 ➝ had roughly 300M parameters 
	- By selecting the 500M parameter Qwen2 model ➝ the DeepSeek team 
		- kept the encoder's size comparable
		- ensuring the **total model footprint remained efficient** enough for **fast inference**

- **Native Causal Reasoning** ➝ The Architecture Fit
	- CLIP is a **bidirectional encoder** ➝ it looks at everything at once but has no concept of ➝ `step 1, step 2, step 3` 
	- Qwen2 is a **decoder-only LLM** ➝ its entire architecture is fundamentally designed to handle ➝ causal flow ➝ reading sequentially
	- This perfectly aligned with the DeepSeek team's goal of appending `causal flow queries` to the visual tokens to establish a logical reading order

- **The Failure of Encoder-Decoder Alternatives**
	- The DeepSeek team actually tried using ➝ a traditional Encoder-Decoder setup ➝ mBART-style 
		- to handle this task  
		- but the training failed to converge
	- They hypothesized that separating the visual tokens from the causal queries into different blocks prevented them from interacting properly 
	- Qwen2's decoder-only structure allowed them to use ➝ `prefix-concatenation`
		- putting the visual tokens + the causal queries ➝ into the exact same sequence ➝ so they could interact effectively through all layers

- **Inheriting LLM Infrastructure**
	- By using a standard LLM block for vision encoding
		- the architecture naturally inherits all the advanced optimizations 
		- developed by the open-source LLM community
		- such as efficient attention mechanisms + scaling laws

###### III. Citations: Qwen2-0.5B

- Qwen2-vl: Enhancing vision-language model's perception of the world at any resolution ➝ arXiv preprint arXiv:2409.12191, 2024
	- [arXiv: Qwen2-VL: Enhancing Vision-Language Model's Perception of the World at Any Resolution](https://arxiv.org/abs/2409.12191)
- Qwen2 Technical Report ➝ arXiv preprint arXiv:2407.10671, 2024
	- [arXiv: Qwen2 Technical Report](https://arxiv.org/abs/2407.10671)

###### IV. The MI Perspective 

> Using Qwen2-0.5B as a vision encoder is not just a hack ➝ it is a **mathematically elegant exploitation** of modern LLM architecture

> 1. **The Context Window Economics**
> 	- When we compress a $1024 \times 1024$ image into tokens ➝ plus add causal queries ➝ we generate a sequence length ➝ of over 1000 tokens just for the `vision` phase
> 	- Older or simpler models choke on this
> 	- Qwen2-0.5B was engineered with a **native context window** of ➝ 32K tokens 
> 	- This means processing 1120 visual tokens barely scratches the surface of its positional encoding capacity 
> 		- preventing the model from losing track of spatial relationships
> 		- at the bottom of a long document

> 2. **Grouped Query Attention: GQA**
> 	- This is the real mechanical secret 
> 	- Standard Vision Transformers (like CLIP) use Multi-Head Attention (MHA) ➝  where every single attention head has to store its own Key and Value (KV) matrices 
> 	- That eats VRAM alive
> 	- Qwen2-0.5B utilizes **Grouped Query Attention (GQA)**
> 		- By forcing multiple query heads to share a single KV head ➝ it drastically reduces the KV cache memory footprint during inference
> 		- This is why it is possible to run [[Project-Proteus-Pdf-Parser-Main]] entire pipeline on a 16GB RAM Phoenix machine ➝ without triggering an Out-Of-Memory (OOM) error

| #llm-self-attention | #mechanistic-interpretability-attention-heads | [[Conceptual-Attention-Heads-MI]] | [[Project-Proteus-Pdf-Parser-Main]] 

> **3. SwiGLU and Compute Density**
> - At only 500 million parameters ➝ we need every single weight to pull its weight 
> - Qwen2 uses the **SwiGLU activation function** ➝ in its Feed-Forward Networks instead of the older ReLU
> - SwiGLU essentially **adds a gating mechanism** ➝ `inside` the MLP layer ➝ allowing the network ➝ to route information more dynamically 
> - This gives a tiny 0.5B model the `reasoning density` of a much larger, older model 
> - It has **enough parameter depth** to learn the Right-to-Left (RTL) **causal flow** without needing billions of weights

###### V. The Elegance

- They took a model originally designed to run text generation on a smartwatch ➝ Qwen2-0.5B ➝ and turned it into the `optic nerve` for a 3-Billion parameter brain 
- It proves a profound MI concept ➝  **vision and language are not fundamentally different to a transformer** 
- If we project visual data into the correct dimensional space ➝ 896 dimensions, in this case
	- a standard causal language model will `read` geometry just as easily as it reads English 
	- using the exact same attention circuits

###### VI. Causal + AutoRegressive + Self-Attention

> Mechanistically, this triad forms the engine ➝ that **enforces** ➝  the **arrow of time** ➝ within a **transformer's latent space**

> #llm-self-attention  | #llm-autoregressive-perspective | #lllm-causal | #mechanistic-interpretability | #llm-latent-space | #llm-natural-latent-geometry 


> **1. Self-Attention** ➝ The Geometric Routing
> - Within the residual stream ➝ a token does not exist in isolation 
> - It projects 3 vectors
> 	- a Query
> 	- a Key
> 	- a Value 
> - The network computes the **dot product** ➝ between a token's **Query** and all available **Keys** ➝ across the sequence
> 	- This operation measures **geometric alignment** in the **activation space** 
> 	- **High alignment** ➝ results in a large attention weight ➝ allowing the token to pull ➝ the corresponding Value vector ➝ into its own residual state 
> 	- It **dynamically updates** its **own representation** ➝ based on the context of the surrounding manifold

> **2. Causal** ➝ The Information Horizon
> - In a bidirectional setup ➝ the attention matrix is fully open and populated
> - A causal mechanism introduces a strict structural blockade ➝ a lower-triangular mask 
> 	- Mathematically ➝ **negative infinity** is added ➝ to **all attention scores** ➝ above the diagonal ➝ before the softmax activation
> 	- This completely annihilates the gradients for any future tokens
> 	- A token at position $t$ is strictly forbidden from computing dot products with any Key at position $t+1$ or beyond
> 	- It guarantees that the token's geometry in the activation space is sculpted solely by the past and present

> **3. Autoregressive** ➝ The Feedback Loop
> - Because the causal mask prevents looking ahead ➝ the network can only resolve the probability distribution ➝ for the immediate next step 
> - Autoregression is the execution loop
> 	- the network predicts the token logit at $t+1$ 
> 	- physically appends that prediction to the KV cache
> 	- and uses it as part of the causal past to compute $t+2$
> - It consumes its own topological trajectory to map the next coordinate

> **In the Context of DeepSeek-OCR 2**
> 	- When this exact mechanism ➝ of the **triads** ➝ is applied to the learnable queries in the Qwen2-0.5B encoder ➝ it **breaks the rigid 2D grid** 
> 	- The causal mask forces the queries to build a path step-by-step
> 	- Query 1 attends to the bidirectional visual tokens and finds the start of an Arabic ligature
> 	- Query 2 attends to the visual tokens `and` Query 1's resolved state in the KV cache
> 		- effectively computing ➝ `Based on where we just looked, what geometric feature logically follows?` 
> 	- This causal autoregressive sequence translates a static 2D spatial layout ➝ into a highly organized 1D semantic flow

##### III. DeepEncoder ➝ V1 vs V2 

![[fig1.png | 700]]
 
> [Paper Online: DeepSeek OCR 2](https://github.com/deepseek-ai/DeepSeek-OCR-2/blob/main/DeepSeek_OCR2_paper.pdf) | [GitHub: DeepSeek OCR 2](https://github.com/deepseek-ai/DeepSeek-OCR-2) | #deepseek-ocr | #llmops-agentops-production-frameworks | [[Project-Pdf-Parser-Arabic-English-Main]]

#### II. The Magic ➝ Causal Flow Queries

> This is the key innovation that directly solves the bilingual column problem 

##### I. Visual Tokenization 

> The image is first passed through a visual tokenizer ➝ based on SAM ➝ that compresses it into a set of visual tokens ➝  example: 256 for a whole page

![[Pasted image 20260307202830.png | 1300]]

###### I. SAM: Segment Anything Model ➝ Meta

> - **SAM** ➝ **Segment Anything Model** ➝ originally developed by Meta
> - Specifically ➝ DeepSeek-OCR 2 utilizes an 80-million parameter SAM-base variant ➝ labeled as SAM ViTDET 80M in their architecture diagram

> - If we want to read a highly complex dense document ➝ we don't look at the microscopic ink particles ➝ our eyes naturally group those particles into lines, curves, and edges 
> - SAM is the artificial equivalent of that low-level biological grouping
> - It is a pre-trained `eye` that is ➝ mathematically obsessed with boundaries and shapes 
> - Instead of forcing the main AI brain to figure out what a `line` is from scratch
> 	- SAM pre-processes the raw image 
> 	- identifying all the structural borders ➝ like table edges or the loops of letters
> 	- and hands over a much cleaner compressed summary

###### II. SAM ➝ Segmentation Model vs Standard Image Patcher 

> `Why did DeepSeek choose a segmentation model instead of a standard image patcher? `
> - It comes down to 
> 	- **activation memory** 
> 	- **feature extraction**

> #llm-activation-space-stream | [[Conceptual-Activation-Space-Level-The-Geometry-of-Machine-Thought]] | #mechanistic-interpretability-features | #llm-feature-extraction | #llm-activation-vector-hidden-state 

> - **Windowed Attention ➝ The Extraction
> 	- Standard ViTs** scale ➝ **quadratically** in memory ➝ because **every pixel patch** tries to **attend** to **every other patch** 
> 	- SAM utilizes **windowed attention** 
> 	- Mechanistically, this means ➝ the **attention heads** are ➝ **constrained** to `local grids `
> 	- They focus entirely on 
> 		- high-frequency + local details ➝ perfectly capturing the exact geometry of a formula's syntax 
> 		- or the **torsional strain** of a complex character
> 	- without wasting compute looking at the other side of the page

> #mechanistic-interpretability-attention-heads | [[Conceptual-Attention-Heads-MI]] | #vision-transformers | #llm-transformer-architecture 

- **The Convolutional Sieve** ➝ The Compression
	- SAM itself doesn't do the heavy compressionI
	- The output is passed through two subsequent convolutional layers
	- These convolutions act as a pooling mechanism ➝ physically shrinking the spatial dimensions of the activation map ➝ to achieve exactly **16x token compression**
    
- **Dimensionality Projection** 
	- The **final convolutional layer** projects the tensor's hidden dimension ➝ to exactly 896
	- This precise dimension ➝ perfectly aligns the geometric data ➝ with the embedding space expected by the subsequent Qwen2-0.5B language model
    
###### III. The MI Perspective

> - From a Mechanistic Interpretability standpoint ➝ OCR is fundamentally a dense segmentation task 
> - Before a model can map a visual token to a text logit 
> 	- it must mathematically isolate the `signal` ➝ the glyph
> 	- from the `noise` ➝ the blank paper, watermarks, or gridlines

- SAM’s weights were pre-trained on billions of object masks
	- meaning its early-layer feature maps are already perfectly tuned ➝ to carve hyperplanes in the latent space between `foreground object` and `background` 
- By using SAM as the visual tokenizer
	- DeepSeek-OCR 2 gets this highly purified structural manifold for free 
	- allowing the subsequent Causal Flow Queries to focus entirely on logical reading order ➝ rather than basic edge-detection

##### II. Introducing Causal Queries 

> - DeepEncoder V2 adds a set of special learnable tokens called ➝ **Causal Flow Queries**
> - There is one query for every visual token 
    
###### I. Dual Attention Mechanism
    
>- **Full Bidirectional Attention** ➝ The What
> 	- The original visual tokens can all `see` each other
> 	- This gives the model a complete, global understanding of the entire page layout ➝ the `cartography`      

>- **Causal Attention** ➝ The How
> 	- The causal flow queries are arranged in a strict one-way sequence ➝ causal mask 
> 	- Query #N can only look at the visual tokens and all previous queries ➝ #1 to #N-1 
> 	- This forces the model to build a `logical, sequential reading order` step-by-step.   

>- **Semantic Reordering**
> 	- The queries, guided by the global visual context, dynamically decide which visual features are most important at each step 
> 	- They effectively **reorder the visual information into a sequence that mirrors human reading logic** 
> 	- The final output to the LLM decoder is only this semantically-ordered sequence of query tokens


>- The visual tokens are all the words on the page scattered on a table 
>- The causal flow queries are a hand that picks them up in the correct order to form a coherent sentence

#### III. The Decoder: 3B MoE LLM

> - The decoder remains a powerful **3-billion parameter Mixture-of-Experts (MoE) language model** ➝ with ~500M active parameters
> - It takes the semantically-reordered sequence from DeepEncoder V2 and generates the final output in a structured format ➝ Markdown, JSON, LaTeX

#### IV. Token Budget & Efficiency

- DeepSeek-OCR 2 is extremely efficient 
- It compresses a 1024x1024 image ➝ which would be 4096 patches ➝ down to just **256-1120 visual tokens** 
	- This is a 16x compression rate ➝ allowing for high throughput 
- The famous "97% accuracy" figure comes from operating at a 10x compression rate ➝ approx. 256 tokens

| Compression Rate     | Visual Tokens | Accuracy | Use Case                                           |
| -------------------- | ------------- | -------- | -------------------------------------------------- |
| 4x                   | 1,024         | 99%+     | Maximum fidelity for dense, critical text          |
| **10x (Sweet Spot)** | **256**       | **97%**  | **Production: Balance of speed and accuracy**      |
| 16x                  | 160           | 92%      | High-speed batch processing                        |
| 20x                  | 128           | ~60%     | Rapid prototyping, not recommended for production  |

---
### 3. DeepSeek for OCR: AgentOps ➝ Pdf-parser

> [[Project-Proteus-Pdf-Parser-Main]]
> [[Project-Argus-Enterprise-Telecom-Main]]
> 

- DeepSeek-OCR 2 is not just an incremental update 
- It's an **architectural paradigm shift** that aligns perfectly with requirements

##### I. Solves the Bilingual Column Problem Natively

- The Visual Causal Flow is designed to infer the correct reading order across a complex layout
	- meaning it will treat the left English column and right Arabic column 
	- as a single, causally-linked stream of information

##### II. MI-Friendly 

- Its architecture ➝ with distinct visual tokens and causally-ordered queries 
	- provides a much cleaner interface for the kind of circuit analysis and activation space probing that is required for MI
    
##### III. Sovereign & Efficient 

- It runs locally and its token compression is perfect for low RAM systems ➝ Phoenix 16GB RAM ➝ offering a path to high throughput even on CPU
    
##### IV. Structured Output

- It outputs Markdown, which can be trivially parsed into the Pydantic schema
    

> **DeepSeek-OCR 2 moves us from a brittle, multi-model pipeline (PaddleOCR) to a unified, reasoning-centric model that understands documents the way a human would**

---















