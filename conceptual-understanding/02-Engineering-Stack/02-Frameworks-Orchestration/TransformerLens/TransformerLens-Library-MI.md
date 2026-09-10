---
tags:
  - mechanistic-interpretability
  - mechanistic-interpretability-tools
  - exploring-mechanistic-interpretability
  - tools
  - mechanistic-interpretability-transformerlens
  - mechanistic-interpretability-toolkit
  - library-transformerlens
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

> - **TransformerLens** → **CircuitsVis** → **Neuronpedia** API → **pyvene**

- [[Project-MI-Concepts-Activation-Vector]]
- [[Conceptual-Logit-Lens]]
- [[Month-0-Week-1-Topology-of-Networks]]
- [[Conceptual-Data-Types-Quantization-LLMs]]
---
### 1. TransformerLens: Library 

> **TransformerLens** is essentially the `X-ray machine` for Large Language Models

- In the world of AI ➝ most people interact with models like GPT-4 through a **Black Box**
	- put text in ➝ text comes out
	- but we have no idea how the `gears` are turning inside

> If we are using standard libraries ➝ like Hugging Face ➝  we can see the results ➝ but we **can't easily reach inside** and touch **the internal mathematical signals**

> #library-huggingface | #library-transformerlens 

>- **TransformerLens** was built specifically for **Mechanistic Interpretability**
>- It is a library that allows us to treat a neural network like a physical system that we can probe, manipulate, and disassemble.

#### I. The Core Philosophy: Black Box ➝ Glass Box

> When we load a model with TransformerLens ➝ it doesn't just run the model ➝ it wraps the model in a `hooking` infrastructure

> - Analogy: Imagine a car engine
> 	- **Standard AI** 
> 		- We press the gas (input) and the car moves (output)
> 		- We can't see the combustion.
> 	- **TransformerLens** 
> 		- The entire engine casing is replaced with glass
> 		- We can see the fuel injection, the piston timing, and the exhaust flow in real-time
> 		- We can even reach in and temporarily stop a piston to see if the car still runs
    
#### II. Key Features: TransformerLens

> To understand what it actually does ➝ consider its 3 main `superpowers`

##### I. Global Hooking Infrastructure

> In standard PyTorch ➝ if we want to see the activations of Layer 7 ➝ have to write complex `wrapper` code

> - TransformerLens pre-installs **Hook Points** at every single junction:
> 	- **The Residual Stream** 
> 		- The main `highway` where information travels
> 	- **Attention Heads** 
> 		- Where the model decides which words relate to each other
> 	- **MLP Layers** 
> 		- Where the model processes factual knowledge
> 	- **LayerNorm** 
> 		- Where the model scales its data


![[Pasted image 20260226014311.png | 500]]

##### II. Activation Caching

> With one command ➝ `run_with_cache` ➝ the library **runs** the model + **saves** a `snapshot` of **every single internal number** ➝ tensor ➝  into a **dictionary**

##### III. Activation Interventions: Steering

> This is the most advanced feature 

> - We can tell TransformerLens: ➝ `During the next sentence, I want you to multiply the activations in Layer 6 by zero, but only for the third word` 
> - This allows researchers to find ➝ **exactly which part of the model** ➝ is responsible for a specific behavior ➝ like grammatical correctness or toxic output

#### III. Use: Mechanistic Interpretability

> - Mechanistic Interpretability (MI) is the study of **circuits**
> - We believe LLMs aren't just random piles of numbers ➝ they have learned `logic gates` made of weights

- **The Goal** 
	- To reverse-engineer the model back into a human-readable algorithm
    
- **The Tool** 
	- TransformerLens provides the precise surgical tools needed to find those circuits
    
| **Feature**            | **What it gives us**                                                                            |
| ---------------------- | ----------------------------------------------------------------------------------------------- |
| **Standardized Names** | Whether it's GPT-2 or Llama, the layers are always named the same way                           |
| **Ease of Access**     | We can get the internal state of the 768-dimensional manifold with one line of code             |
| **Linearity**          | It helps `linearize` the model (like `fold_ln=True`) so the math is easier for humans to follow |

---
### 2. Standardization

> In the world of AI research ➝ **standardization** is the `Rosetta Stone` ➝ that makes Mechanistic Interpretability **possible across different models**

> - Without **TransformerLens** ➝ every time we switched from a GPT-2 model to a Llama model or a Mistral model 
> 	- we would have to rewrite the entire codebase
> 	- every lab names their internal `gears` differently

#### I. The Chaos of Non-Standardization

In standard libraries ➝ like Hugging Face `transformers` ➝ models are built as nested Python objects
To get the residual stream of a specific layer ➝ we might have to type
- **GPT-2**
	- `model.transformer.h[6].resid_post`
    
- **Llama-3**
	- `model.model.layers[6].post_attention_layernorm`
    
- **Gemma** 
	- `model.model.layers[6].input_layernorm`
    

> If we are trying to build a universal tool for extracting activation vectors ➝ this inconsistency makes the code brittle and hard to scale

#### II. How TransformerLens Standardizes

> - When we load a model via `HookedTransformer.from_pretrained()` ➝ the library performs a `Transcoding` process
> - It maps the messy, inconsistent internal names of the original model ➝  onto a **Unified Naming Schema**

> Regardless of the model's origin, the hook points in TransformerLens always follow this predictable structure:

- `blocks.{n}.hook_resid_pre` 
	- The residual stream _before_ layer $n$
    
- `blocks.{n}.hook_resid_mid` 
	- The residual stream _between_ the Attention and MLP sub-layers
    
- `blocks.{n}.hook_resid_post` 
	- The residual stream _after_ layer $n$ 
    
- `blocks.{n}.attn.hook_z` 
	- The output of the attention heads
    
- `blocks.{n}.mlp.hook_post` 
	- The activations inside the MLP
    
#### III. Standardization: Details

Standardization isn't just about names ➝ it’s about **Mathematical Consistency**

> TransformerLens ensures: 

- **Tensor Shapes** 
	- All tensors are **reshaped** into a consistent `[batch, position, head_index, d_model]` or `[batch, position, d_model]` format
	- We don't have to guess the dimensions
    
- **Activation Caching** 
	- Because the names are standardized ➝ we can use a single dictionary (the `cache`) to look up any part of the model's `brain` ➝ without knowing the specific underlying architecture
    
- **Weight Folding** 
	- It physically alters the model ➝ to make it behave more like a ➝ `Linear Communication Bus` ➝ which is the gold standard for mechanistic analysis
    
#### IV. Official Documentation

> The library was primarily developed by **Neel Nanda** and is now maintained by a community of MI researchers.

- **Official Documentation** 
	- [TransformerLens Docs](https://neelnanda-io.github.io/TransformerLens/)
- **GitHub Repository** 
	- [Main GitHub Repo](https://github.com/TransformerLensOrg/TransformerLens)
- **Core Tutorial** 
	- [Main Tutorial (Cleanest Entry Point)](https://www.google.com/search?q=https://neelnanda-io.github.io/TransformerLens/generated/tutorials/Main_Demo.html)

---
### 3. Detailed Components: TransformerLens

> The `Scientific Method` implemented in Python code for LLMs

#### I. The Core Architecture: HookedTransformer

> - Every interaction begins with the `HookedTransformer` class
> - Unlike a standard model that only has an **Input** and an **Output** ➝  a `HookedTransformer` is built around **HookPoints**

-  A **HookPoint** is a specific location in the model's neural circuitry ➝ like a probe in a biological brain ➝ where we can: 
	- **Read** 
		- View the raw activations (vectors) ➝ without stopping the calculation
	- **Cache** 
		- Save those activations to a dictionary ➝ for later analysis
	- **Edit: Intervene** 
		- Inject a different vector or `ablate` (set to zero) ➝ a specific dimension mid-calculation to see how the model's `behavior` changes
    
#### II. The Standardized Naming Schema

> TransformerLens solves the `Naming Chaos` of different AI labs
> No matter what model we load ➝ the keys to its `brain` are always the same

|**Key Name**|**Mathematical Location**|
|---|---|
|`blocks.{n}.hook_resid_pre`|The Residual Stream **before** Layer $n$.|
|`blocks.{n}.hook_resid_post`|The Residual Stream **after** Layer $n$ (Our target).|
|`blocks.{n}.attn.hook_z`|The mixed output of the **Attention Heads**.|
|`blocks.{n}.attn.hook_pattern`|The **Attention Scores** (who is looking at whom).|
|`blocks.{n}.mlp.hook_post`|The **MLP activations** (where facts are often stored).|
#### III. Causal Tracing: Activation Patching

> - This is the library's most powerful feature
> - It allows us to find **Circuits** ➝ learned algorithms

- **The Clean Run** 
	- `The Eiffel Tower is in [Paris]`
    
- **The Corrupted Run** 
	- `The Colosseum is in [Rome]`
    
- **The Patch** 
	- We take the `Eiffel Tower` vector from Layer 6 of the Clean Run ➝ surgically paste it into the Corrupted Run
    
- **The Result** 
	- If the model suddenly says `Paris` instead of `Rome`  ➝ we have mathematically proven that **Layer 6 is the seat of geographic location knowledge.**
    
#### IV. Technical Magic Flags

> When we initialize the model ➝ we use specific flags to `linearize` the system for better math

- `fold_ln=True` 
	- Absorbs the non-linear LayerNorm parameters into the weights
	- This makes the residual stream a purely additive communication bus
    
- `center_writing_weights=True`
	- Ensures that the weights writing to the residual stream have a mean of zero, preventing `drift` in the manifold
    
- `refit_embedding_ln=True`
	- Recalibrates the initial embedding layer so the scale of the input vectors is consistent with the rest of the model
    
#### V. Utility Superpowers

TransformerLens handles the annoying `plumbing` of AI work

- `to_tokens` / `to_string` 
	- Effortless conversion between text and integers
    
- `run_with_cache`
	- Executes the model and returns a dictionary of `every` activation in one go
    
- `all_head_labels` 
	- Instantly gives ➝ a list of every attention head ➝ example: `L0H7` for Layer 0, Head 7
    
#### VI. Domain Expert Tool

> TransformerLens is designed to move at the **speed of thought**
> Instead of spending 4 hours writing PyTorch boilerplate to find a specific neuron ➝ we can find it in 4 lines of code.

---
### 4. TransformerLens: Place in MI ToolKit 

> #mechanistic-interpretability-transformerlens | #mechanistic-interpretability-tools | [[Conceptual-ToolKit-Comprehensive-MI]]

#### I. TransformerLens: The Infrastructure

- **What it is** 
	- The X-ray machine    
- **Why we need it** 
	- It allows  to load models, hook into any layer, extract vectors, and perform `Activation Patching` 
    
#### II. Circuitsvis: The Visualization

- **What it is** 
	- A specialized library for visualizing attention patterns and attribution
		- also by Neel Nanda
    
- **Why we need it** 
	- TransformerLens gives us the `numbers`
	- Circuitsvis gives us the interactive, browser-based heatmaps that show exactly which tokens a specific head is looking at 
	- example: `Look at how Head 7 in Layer 0 is acting as a Name Mover`
    
#### III. SAELens: The Feature Discovery

- **What it is** 
	- A library for **Sparse Autoencoders SAEs**
    
- **Why we need it** 
	- For **Superposition Theory** and **SAEs** 
	- While TransformerLens lets us see the `neurons` ➝ SAEs lets us see the `features` ➝ which are often spread across many neurons
	- SAELens is the industry standard for training and using SAEs to `de-noise` the activations we get from TransformerLens
    
#### IV. Garcon: The Helper

- **What it is** 
	- A small utility for loading models and managing caches
    
- **Why we need it** 
	- It’s often used in professional research to keep code clean when running massive sweeps across different models
    
> Reference ➝ [Tranformer Circuits ➝ Garcon](https://transformer-circuits.pub/2021/garcon/index.html#:~:text=For%20small%20models%2C%20interpretability%20work,from%20scripts%20for%20automated%20analyses:)

---
### 5. The Complete MI Stack

| **Phase**               | **Category**        | **Tools**              | **The `Why` for an Architect**                                                                                                                                         |
| ----------------------- | ------------------- | ---------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Phase 1: Foundation** | Core Infrastructure | **TransformerLens**    | **The Base Layer** <br>We cannot do MI without it. It standardizes model internals and provides the hooking infrastructure needed to `see` the manifold                |
|                         | Visualization       | **CircuitsVis**        | **The Microscope** <br>Browser-based, interactive visualizations for attention patterns and logit attribution. Best paired with TransformerLens for immediate feedback |
|                         | Feature Repository  | **Neuronpedia API**    | **The Search Engine** <br>Saves training heavy models. Look up pre-discovered features (example ➝ `The Python Neuron`) to see if the findings match existing research  |
| **Phase 2: Depth**      | Logit Analysis      | **Tuned Lens**         | **The Translator** <br>Maps activations at middle layers to the final vocabulary. Feeds the intuition about how `thoughts` evolve layer-by-layer                       |
|                         | Vision MI           | **Prisma (HookedViT)** | **Cross-Domain MI** Extends the same standardized hooking architecture to Vision Transformers. Crucial for understanding image-to-text manifolds.                      |
| **Phase 3: Causal**     | Interventions       | **pyvene**             | **The Surgical Scalpel.** The industry standard for `Interchange Interventions.` Graft activations from one prompt into another to prove a causal link.                |
|                         | Feature Discovery   | **SAELens**            | **The De-Noiser.** Used to train and run **Sparse Autoencoders (SAEs)**. Essential for splitting `messy` neurons into clean, monosemantic features.                    |
| **Phase 4: Global**     | Global MI           | **ModCirc**            | **The Systems Architect.** Identifies `Modular Circuits`—reusable sub-graphs (like a `Grammar Checker`) that the model uses across thousands of different tasks.       |
|                         | Scaling             | **nnsight**            | **The Remote Link.** When you want to analyze models too large for **Phoenix** (like Llama-3 70B). It hooks into remote clusters and streams activations back to you.  |
| **Phase 5: Mastery**    | Benchmarking        | **MIB**                | **The Quality Gate.** The **Mechanistic Interpretability Benchmark.** Quantifies how well your discovered circuit actually explains the model's behavior.              |

> - **Phase 1** gives visibility ➝  can `see` the manifold
> - **Phase 2** gives translation ➝  understand what is been `seen`
> - **Phase 3** gives causality ➝  can `prove` what is seen is real
> - **Phase 4** gives  scale ➝  can `generalize` beyond one model or task
> - **Phase 5** gives  integrity ➝  can `defend` every claim  make

