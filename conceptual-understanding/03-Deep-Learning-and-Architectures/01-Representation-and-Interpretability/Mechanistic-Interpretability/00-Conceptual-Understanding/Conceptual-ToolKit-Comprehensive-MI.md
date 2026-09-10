---
tags:
  - mechanistic-interpretability-tools
  - mechanistic-interpretability
  - conceptual-explanations
  - note-finalized
---

---
```table-of-contents
```
---
### References



---
### Primitives 

- [[Conceptual-Basics-Anatomy-of-Compute-Feature-Manifolds-Circuit-Topologies]]
  
  
---
### 1. Complete MI Stack

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

---
### Detailed 
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

#### V. Write own Mechanistic Interpretability Code? 

We can using standard PyTorch `register_forward_hook()`

> However, in a professional research setting, we shouldn't reinvent this wheel for **3 critical reasons**

##### I. The Naming Chaos Problem

- Every AI lab (Meta, Google, OpenAI) names their internal layers differently
- If we write our own code for GPT-2 ➝ it will break the second we try to analyze a Llama model
- TransformerLens acts as a **Universal Translator** ➝ so we can write one script and run it on any model

##### II. The Linearization Burden

- Properly extracting a residual stream vector requires handling **LayerNorm folding** and **Weight Centering**
- If we do this manually ➝ might spend 90% of the time debugging linear algebra and only 10% doing actual interpretability

##### III. The Exploration Speed

> Research is about **iteration loops**

- **Custom Code** 
	- 2 hours to set up a hook, 1 hour to debug the tensor shapes, 10 mins to plot
    
- **TransformerLens** 
	- 2 minutes to `run_with_cache`, 5 minutes to plot
    

> **The Verdict** ➝ We don't build the microscope from scratch before every biology experiment ➝ We Use the professional microscope (**TransformerLens**) ➝ so we can focus on discovering the `cells` ➝ circuits and manifolds

##### IV. When to write custom code

Write own code only when

- Working on a **brand-new architecture** ➝ like a Mamba or a State Space Model ➝ that isn't supported by the standard libraries yet
- Are trying to optimize for **extreme performance** ➝  example: extracting activations from a trillion-parameter model in a production environment)

#### VI. Neuronpedia 

> It's not just a repository
> It's the difference between spending 3 weeks training an SAE on GPT-2 and spending 3 hours actually doing interpretability work


#### VIII. Internalize before Coding

> **ModCirc: grow from Local → to Global**

- Every MI tutorial teaches to find _one_ circuit for _one_ task
	- `How does GPT-2 do indirect object identification` 
	- That's local MI 
- ModCirc is the shift to asking ➝  `what are the reusable computational primitives the model deploys across` **`all`** `tasks` 
	- That's the difference between anatomy and physiology
- We want both
	- But global MI is where original research lives

> **Neuronpedia ➝ Search Before Dig**

- Before spending 3 hours manually probing Layer 6 of GPT-2 ➝ query Neuronpedia first
- If the feature is already mapped ➝  build on top of it
- If it isn't ➝ that's the contribution
- **Search first, discover second**
- This is the same protocol we apply to primary literature before running an experiment

> **MIB ➝  Faithfulness Not Story**

- This is the one most people skip and shouldn't 
- Any circuit story can sound convincing
- MIB's CPR metric asks the hard question: `if we ablate this circuit, does model performance drop by exactly the amount your explanation predicts?` 
	- If `yes` ➝ faithful circuit 
	- If `no` ➝  convincing story ➝ not mechanistic truth

> **Never publish without this**

---
### 5. MI Stack Installation

> Environment is present to install, register and use systemwide (bashrc is updated with the env name)

[📂 Open: mienv](<file:///home/az/GitHub-Repositories/Computing-Envs/tomls/mienv>)

```python

# Install order matters
# pip install transformer-lens
# pip install circuitsvis
# pip install tuned-lens
# pip install pyvene
# pip install sae-lens
# Neuronpedia — API key, no install needed
```


