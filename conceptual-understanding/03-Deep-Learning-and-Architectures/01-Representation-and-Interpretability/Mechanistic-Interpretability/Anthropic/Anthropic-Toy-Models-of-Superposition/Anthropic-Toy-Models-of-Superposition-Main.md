---
tags:
  - mechanistic-interpretability-superposition
  - mechanistic-interpretability-superposition
  - mechanistic-interpretability
  - mechanistic-interpretability-theories
  - anthropic-research
---

---
```table-of-contents
```

---
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

- Anthropic Article ➝ [Toy Models of Superposition](https://transformer-circuits.pub/2022/toy_model/)
- [[Anthropic-Toy-Models-of-Superposition-Section-by-Section]]
---

>[!quote] See the **Primitives Section** for the detailed breakdown of the article 

---
### I. The Problem

- In an **ideal** completely interpretable neural network ➝ every **single neuron** would map flawlessly ➝ to exactly **one** human-understandable concept ➝ a `feature`
	- One neuron fires for `red` another for `dog snouts` and another for `left-facing curves` 
- In actual practice ➝ especially within the **massive architectures** of modern Large Language Models ➝ this `one-to-one` mapping is **exceedingly rare**
	- Instead ➝ we encounter `polysemantic` neurons that fire for ➝ **seemingly random** assortment of **unrelated concepts**`
	
>- The problem is `understanding why this happens` ➝ **why do neurons sometimes align cleanly with features** and **why do they usually become a tangled mess**

> #mechanistic-interpretability | #mechanistic-interpretability-features | #llm-manifolds-geometric-perspective | #mechanistic-interpretability-features | #mechanistic-interpretability-superposition 

#### I. Polysemantic Neuron

> At the most basic level, ➝ a **polysemantic neuron** ➝ is a **single neuron** that `fires` ➝ in `response` ➝ to **multiple** + **completely unrelated** concepts

##### I. Mechanistic Interpretability Perspective: Polysemanticity

- Consider the **activation space** ➝ as an $N$-dimensional coordinate system
	- where **each individual neuron** represents a **single orthogonal axis** ➝ the standard basis
	- If a model needs to represent $M$ features (where $M \gg N$) ➝  it **cannot assign one feature to one axis**
	- Instead ➝ it assigns features to **arbitrary directions** ➝ vectors ➝ spanning across that space 
	- Because these **feature vectors exist** ➝ in **superposition** to save space ➝ they are **intentionally not aligned** ➝ with the standard basis
	- Therefore, **a single neuron** ➝ is merely the **geometric projection** ➝ of **several overlapping feature vectors** ➝ onto one axis

##### II. Individual Neurons 

- So, when we look at an individual neuron in a standard LLM ➝ it might fire intensely for the concept of `dogs,` the French word for `apple,` and `Python `for` loops` 
- It looks like an uninterpretable, tangled mess, but it is actually a **highly efficient, calculated compression strategy**

> Polysemanticity is the **observable symptom** we see when we look at **individual neurons** ➝ **superposition** is the underlying **geometric cause**

> [[Conceptual-Intertwined-Concepts-MI]]
> #mechanistic-interpretability-polysemnaticity | #mechanistic-interpretability-superposition | #mechanistic-interpretability-superposition | #llm-activation-space-stream 

---
### 2. The Solution 

> The authors introduce the concept of `superposition` as the mechanical answer

- Superposition is a **mathematical** and **structural** strategy ➝ where a neural network represents ➝ **`more` features** than **it has available dimensions** ➝ neurons
- It achieves this compression ➝ by **allowing features** to **overlap** in the **activation space**
- To manage the inevitable `interference` ➝ the noise caused by overlapping concepts ➝ the network relies ➝ on **non-linear activation functions**, specifically ReLUs, to filter out the background noise and **isolate the correct feature**

> Hallucination in this context is fundamentally ➝ **a failure of the non-linear filter** ➝ to suppress the interference noise
> Hallucination is purely a mechanical failure of the ReLU filter to suppress that accumulated geometric background noise ➝ the constructive interference

> **Considertations**
> - It's not just that the filter fails
> - It's that the filter was **never designed to be perfect** ➝ under **high superposition density** 
> - ReLU was designed for a world ➝ where **features** are **sparse** and **separable** 
> - Superposition violates that assumption by design

> - Hallucination isn't a bug exactly ➝ It's the **cost of the compression strategy**
> - We pack more features than we have dimensions ➝ we gain efficiency ➝ we pay with occasional crosstalk that ReLU can't fully suppress
> - The model is simultaneously brilliant and hallucinating ➝ `for the same reason` ➝  superposition
> - The very mechanism that makes the model capable is exactly what makes it vulnerable

> #llmops-hallucination | #llm-hallucination-detection | #mechanistic-interpretability-hallucinations | #deeplearning-mechanistic-activation-functions | #mechanistic-interpretability-features | #mechanistic-interpretability-features | #llm-compression-strategy 

#### I. Detour: Hallucinations: Superposition Perspective

- Since the model packs $M$ features into $N$ dimensions ➝  the feature vectors are **not perfectly orthogonal** ➝ at $90^\circ$ to each other ➝ they are **squished** together at **acute angles** 
- When a feature is present ➝ the model activates its vector
- But because of those tight angles ➝ it also slightly activates the vectors of all the other features overlapping in that same space ➝ this is the `background noise`

- Normally ➝ the ReLU function acts as a **hard threshold** ➝ slicing off all that low-level noise ➝ only letting the strong, intended signal through
- But sometimes, **the input context triggers** ➝ several **different features** at once 
- While each feature's individual noise is weak ➝ their **vectors can align just right** and **add** up through **constructive interference**

> [!quote] **Superposition-induced Hallucination**
> - The model's geometric noise ➝ accidentally assembled ➝ into the exact mathematical shape ➝ of a completely unrelated feature ➝ pushing it past the ReLU threshold
> - The model now genuinely believes this `ghost` feature is present in the prompt ➝ and it generates text based on that false reality
> - That is a **superposition-induced hallucination**

> When the model hallucinates

- The input activates a direction in the manifold 
- But because features are packed so tightly ➝ neighboring features partially overlap with that direction
- ReLU is supposed to suppress them 
- But the signal is ambiguous ➝ the geometry in that region is crowded + the angles between features are small + the filter can't cleanly separate signal from interference
- So instead of one clean feature firing ➝ `Paris is the capital of France` ➝ we get a weighted bleed from adjacent packed features 
- The model outputs the loudest combination of what's nearby in that crowded geometric neighborhood

> **Hallucination** ➝ **Geometric crosstalk in an overcrowded Manifold**

- The model didn't forget ➝ it got confused by its own compression strategy
- The denser the superposition ➝ the more features packed per dimension ➝ the higher the crosstalk risk 
- It's the exact same problem as signal interference in overcrowded communication channels

#### II. Key Methodology in the Paper

> - Rather than attempting to dissect a multi-billion parameter `black box` model ➝ the authors construct `toy models` 
> - These are **extremely small bare-bones ReLU networks** ➝ trained on **mathematically synthesized data** where the **inputs are perfectly controlled**

- By explicitly defining the `ground truth` features in the synthetic data ➝ they eliminate the guesswork of what the model is supposed to be learning
- They systematically manipulate two specific variables 
	- feature `sparsity` ➝ how rarely a feature appears 
	- feature `importance` ➝ how heavily the loss function penalizes missing it
- Observing how the model's internal geometry shifts in response to these two variables ➝ allows them to map the exact conditions under which superposition occurs
    
#### III. Significance and Personal Importance

> This paper is apparently the absolute bedrock for a domain expert in Mechanistic Interpretability 
> It moves the conversation from **high-level behavioral observation** down to the ➝ precise, geometric reality of activation spaces

- Understanding superposition provides the fundamental mathematical justification ➝ for why Sparse Autoencoders (SAEs) are required to untangle modern LLMs
- It demonstrates that polysemanticity is not a bug or a failure of training ➝ but a **highly optimized, calculated compression strategy**
    - Mastering these phase changes and geometric structures is non-negotiable 
	    - for designing transparent + interpretable architectures from scratch
	    - directly aligning with the pursuit of the 11 Principles
	    - and the ultimate goal of building systems where the `Why` and `How` are known at the exact weight-and-activation level
    
> #mechanistic-interpretability-sae | #11-principals | #llm-interpretability 
---
### 1. Article Context 

To understand the core thesis of this paper, we have to look at the fundamental economic problem every neural network faces: **scarcity of dimensions**.

Imagine a neural network as a massive office building, and the neurons are the individual offices. The `features` (the concepts the network needs to understand to do its job) are the employees.

- If you have 1,000 employees and 1,000 offices, everything is perfect. Everyone gets their own room. When you want to find the accountant, you go to the accountant's office. This is `monosemanticity.`
    
- But what if you have 10,000 employees and only 1,000 offices? The network cannot simply fire 9,000 employees; it needs them to solve the complex tasks it was trained for.
    

If the employees are there all the time (dense features), the network is forced into a brutal choice. It will give offices to the top 1,000 most important employees (similar to what Principal Component Analysis would do) and simply ignore the rest. The lesser features are lost entirely.

However, the real world is **sparse**. In language, for example, the concept of `apple` or `quantum physics` doesn't appear in every single sentence. Most features are intrinsically rare.

Because features are sparse, the network realizes it can share the offices. It can take five employees who rarely work on the same day and assign them to the same two offices.

- When they share the space, they create non-orthogonal angles in the geometric space.
    
- Because they are sharing, if employee A and employee B happen to show up on the exact same rare day, they will bump into each other. This is called **interference**.
    
- To solve the interference problem, the network uses a non-linear filter—the ReLU function. The ReLU acts like a bouncer at the office door. It essentially says, `Unless the signal for an employee is overwhelmingly strong and positive, I am going to silence the background noise to zero.`
    

By tolerating a tiny bit of interference noise and filtering it out with ReLUs, the network can pack an astonishing number of features into a very small number of dimensions. This is **superposition**.

The authors made several profound discoveries in this introduction:

1. **It is a deliberate ground truth:** Superposition isn't just a hallucination by researchers trying to interpret models post-hoc. In these toy models, the authors proved that the network actively and deliberately constructs these compressed geometric structures.
    
2. **Computation in Superposition:** The network doesn't just store these concepts like a compressed zip file that needs to be unpacked to be used. It can actually perform mathematical operations (like calculating absolute values) on these features `while` they are still squished together in superposition.
    
3. **Simulating larger networks:** This leads to a beautiful hypothesis. The dense, messy, polysemantic neural networks we train today are actually just noisily simulating the `perfect,` massively wide, highly sparse neural networks we `wish` we could train. They are holographic projections of a much larger, idealized model.
    

The authors note that the idea of packing information isn't completely new—it echoes concepts from compressed sensing and neuroscience. But the critical contribution here is proving it mathematically within artificial neural networks, showing that the transition between monosemantic (clean) and polysemantic (messy) neurons is governed by a strict, observable phase change.