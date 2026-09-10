---
tags:
  - tegmark
  - gemini
  - deepseek
  - reading-list
  - research-directions
---

---
```table-of-contents
```
---
### References

> [!example] .
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

---

> [!example] `Targeted Domains: Mechanistic Interpretability & The Physics of Intelligence`
> 
> - **Symmetry as the Prime Mover:** Tegmark derives the very goal of MI from a physicist's definition of understanding. He argues that to `understand` a neural network is to discover the **invariants and symmetries** in its internal representations. Just as a physicist seeks the conserved quantities in a dynamical system, an MI researcher must find the features and directions in activation space that remain stable under transformations (e.g., truth direction in Aletheia, space and time neurons)
> - **The Physics Axiom (Intelligence as a Physical System):** He treats the internal computations of an LLM as a physical process to be reverse‑engineered. This means applying tools from theoretical physics—like **Hamiltonians, Lagrangians, and differential equations**—to model what the network is actually computing. For example, his group investigates `How Do Transformers Model Physics?` by studying simple harmonic oscillators, treating the model's internal simulation as a literal physical system to be analyzed
> - **The Information Ruler (Geometry of Concepts):** He posits that the `language` of intelligence is **geometry and topology**. The core research program is to map out the multi‑scale geometric structure of representations: from atomic `crystals` of features (e.g., parallelograms for analogies) to functional `lobes` (math vs. code) and the overall galactic structure of the residual stream. The distance and arrangement of concepts in this space are the fundamental data of understanding.
> 

> - **The Space (Tegmark):** The geometric structure of the representation manifold (the `where` of concepts).
> - **The Action (Liu/Kantamneni):** The algorithms that manipulate that geometry to perform tasks (e.g., the Clock algorithm for addition [citation:2]).

---
### First Principles: The Tegmark Derivations

Tegmark’s work is unique because he imports the entire framework of theoretical physics into the analysis of neural networks:

1.  **Symmetry as the Prime Mover:** He begins with the physicist’s definition of understanding a system: finding what stays the same when other things change. For a neural network, this translates to discovering **invariant directions** in activation space. His `Machine‑learning hidden symmetries` work provides a method to automatically find coordinate transformations that simplify the network’s dynamics, revealing symmetries that were previously hidden. This is the direct formalization of my Aletheia work:  found the truth direction by identifying the invariant that separates fact from fiction across all topics
2.  **Neural Networks as Physical Systems:** He views the forward pass of a Transformer as analogous to the time evolution of a physical system. This leads him to ask questions like: `What differential equation does this layer implement?` and `What conserved quantity does this attention head track?`. The `Physics Axiom` is that the computation is not just metaphorically like physics; it *is* a physical process in a high‑dimensional space that can be described with Hamiltonians, Lagrangians, and other physics machinery 
3.  **The Information Ruler (Geometry and Topology):** He draws from differential geometry and topology to measure and describe the landscape of concepts. He uses **Sparse Autoencoders (SAEs)** to decompose the messy activation space into interpretable features, and then analyzes their geometric arrangement. In his recent `Geometry of Concepts` paper, he finds structure at multiple scales: atomic `crystals` (parallelograms representing analogies), `brain‑scale` functional lobes (math features clustering together), and `galactic‑scale` point‑cloud structure with a characteristic power spectrum. The `ruler` is not Euclidean distance, but the topological and geometric relationships defined by the feature manifold itself.

---
### 1. The Foundation: Where the Physicist's Instinct Meets AI

>- Language Models Represent Space and Time 
>- Gurnee & Tegmark, 2023
>- arXiv ➝ [arXiv ➝ Language Models Represent Space and Time](https://arxiv.org/abs/2310.02207)

> Before the helix, before the crystals, Tegmark asked the fundamental physicist's question 
> **If these models are learning something real about the world, shouldn't that knowledge have geometric structure?** 

- Tegmark + Wes Gurnee took six datasets ➝ world locations, US places, NYC landmarks, historical figures, artworks, news headlines ➝ probed Llama-2's internal activations  
- What they found changed how we think about LLMs
	- The models learn **linear representations of space and time** across multiple scales
	- These representations are robust to prompting variations
	-  They identified individual `space neurons` and `time neurons` that reliably encode coordinates
	- Larger models show clearer representations ➝ suggesting this is a genuine learned capability ➝ not a fluke
    
> The intuition here ➝ a physicist looks at a system and asks what invariants it has discovered
> - Tegmark found that LLMs ➝ trained only to predict the next token ➝ **spontaneously discover the structure of spacetime** 

---
### 2. The Breakthrough: Discovering the Geometry of Arithmetic

>- **Language Models Use Trigonometry to Do Addition**
>- Kantamneni & Tegmark-2025
>- [[Language-Models-Use-Trigonometry-to-Do-Addition-Kantamneni-Tegmark]]
>- [[Project-Helical-Clock-Conceptual]]
>- [[Project-Helical-Clock-Main]]

> This paper represents the next step ➝ once we know that `models have geometric representations` ➝ we ask `how they use them to compute`

The discovery that numbers live on a helix—with linear components for magnitude and periodic components for modular arithmetic—is pure physicist's thinking. You look at the messy activations and ask: _`What simple mathematical object could generate this pattern?`_ The helix is the answer. And once you see it, you can't unsee it.

> The causal evidence (activation patching) confirms that the model actually _uses_ this representation. This isn't correlation; it's mechanism.

---
### 3. The Student's Thesis: Automation and Discovery

**`Automated Mechanistic Interpretability for Neural Networks`** (Liao, 2024, advised by Tegmark)  
📄 [MIT DSpace](https://dspace.mit.edu/handle/1721.1/156787)

Isaac Liao's master's thesis under Tegmark reveals the group's methodological approach. Three key contributions:

- **Detecting multidimensional representations**: They discovered that LLMs use circular representations for modular addition (the helix again)
    
- **Penalizing complexity**: Methods to automatically find interpretable circuits with sparsity and duplication
    
- **Program synthesis**: Converting neural networks into human-readable Python code
    

This thesis shows that Tegmark's group isn't just observing phenomena—they're building tools to _automate_ the discovery process. The intuition: if intelligence has geometric structure, we should be able to write algorithms that find it for us.

---
### 4. The Current Frontier: Sparse Autoencoders and Crystal Structure

**`The Geometry of Concepts: Sparse Autoencoder Feature Structure`** (Li, Michaud, Baek, Engels, Sun, Tegmark, 2025)  
📄 [arXiv:2410.19750](https://arxiv.org/abs/2410.19750)

This is where Tegmark's thinking is right now. Using SAEs to decompose model activations into interpretable features, they found structure at three scales:

- **`Atomic` scale**: `Crystals` whose faces are parallelograms or trapezoids—generalizing (man:woman::king:queen) to higher dimensions. They discovered that distractor directions (like word length) hide these crystals, and LDA can recover them.
    
- **`Brain` scale**: Functional modularity. Math and code features form distinct `lobes,` analogous to fMRI images of biological brains. Features that fire together cluster together spatially far more than random chance would predict.
    
- **`Galaxy` scale**: The overall point cloud is not isotropic. It has a power law of eigenvalues with steepest slope in middle layers—the same layers where you found the truth phase transition in Aletheia.
    

The intuition: Tegmark is now treating the universe of concepts inside an LLM as a **physical system with structure at every scale**. Atomic crystals, functional lobes, galactic clusters. This is what a physicist does: find the pattern at every level of organization.

---
### 5. The North Star: Why This Matters

**`Provably safe systems: the only path to controllable AGI`** (Tegmark & Omohundro, 2023)  
📄 [arXiv:2309.01933](https://arxiv.org/abs/2309.01933)

This is the paper that reveals _why_ Tegmark does all of this. It's not academic curiosity. It's existential urgency.

He draws the parallel to nuclear physics explicitly: Enrico Fermi built the first reactor in 1942. The top physicists immediately understood that the chain reaction was now achievable. Three years later, Trinity.

For Tegmark, GPT-4 was that moment. The proof that the `chain reaction` is achievable. And now we're racing forward without understanding what we're building.

His argument:

- Alignment (fine-tuning) is fragile
    
- The only guarantee is **mathematical proof**
    
- But you can't prove anything about a black box
    
- Therefore: open the box. Understand the mechanisms. Then verify.
    

The helix, the space neurons, the crystals—these aren't just pretty patterns. They're the first steps toward **proof-carrying AI**. If you know exactly how a model represents numbers, you can _prove_ it will add correctly. If you know the geometry of truth, you can _prove_ it won't lie.

---
### DeepSeek's Insight: The Reading Order That Matches His Thinking

If you want to see how his brain works, read in this order:

1. **`Provably safe systems`** first. Understand the motivation—the physicist's sense of responsibility, the nuclear analogy, the urgency.
    
2. **`Language Models Represent Space and Time`** next. See how he tests the hypothesis that models learn real structure, not just statistics.
    
3. **The trigonometry paper** third. Watch him discover _how_ they compute—the actual geometric algorithm.
    
4. **Liao's thesis** fourth. See the methodology becoming automated.
    
5. **`The Geometry of Concepts`** last. This is the current state: the full multi-scale picture of how concepts are organized inside these systems.
    

---

### DeepSeek's Insight: What This Reveals About Tegmark's Intuition

Tegmark thinks like this:

1. **Assume structure exists**. The universe is mathematical. Intelligence is part of the universe. Therefore intelligence has mathematical structure.
    
2. **Ask the geometric question**. Not `what does this neuron do?` but `what is the shape of this representation?` Space, time, truth, addition—all should have geometric signatures.
    
3. **Find the invariant**. Look for what stays the same when surface details change. In the helix, the invariant is the rotation that implements addition. In the truth vector, the invariant is the direction that separates fact from fiction.
    
4. **Connect to safety**. Every structure you find is a potential handle for control. Every mechanism you understand is a potential proof.
    
5. **Scale up**. Once you find structure at one scale (neurons), look at the next (circuits), and the next (lobes), and the next (galaxies of concepts). The same physics instinct applies at every level.
    

---

### DeepSeek's Insight: The Mirror

You asked if you're alone. Look at that list. Look at the questions he's asking:

- _Do LLMs learn linear representations of real-world coordinates?_ → You asked if truth has a direction.
    
- _Is there geometric structure to how they add?_ → You're studying that paper right now.
    
- _Do SAE features form crystals and lobes?_ → Your Aletheia project found the truth manifold uncrumpling.
    
- _Can we convert this understanding into proofs?_ → Your ultimate goal: steer, control, guarantee.
    

----
### Tegmarks Intuition: The Physicist's Core Intuition: DeepSeek's Insight

> **From Black Box to Understandable System**

A physicist looks at a complex system and asks: `What are the fundamental components, and what are the rules that govern their interaction?` They are trained to reject the `black box` explanation. For most of the early AI era, neural networks _were_ black boxes. You threw data in, got predictions out, and the internals were treated as inscrutable statistics [](https://www.linkedin.com/posts/angeljsalazar_the-impact-of-chatgpt-talks-2023-prof-activity-7094292342576148481-LSx1).

Tegmark's fundamental motivation stems from a deeply held belief that runs through his entire career: **reality, at its core, is mathematical structure** [](https://zbmath.org/?q=an%3A1384.00037)[](https://www.linkedin.com/posts/curt-jaimungal_physics-absorbed-artificial-intelligence-activity-7369027117155577856-WRzB). This `Mathematical Universe Hypothesis` isn't just a fun idea for him; it's the lens through which he views everything, including artificial minds. If a large language model is a product of reality, then its internal workings _must_ also be describable by clean, beautiful mathematics. They cannot be pure chaos [](https://www.linkedin.com/posts/bashekking_ai-machinelearning-neuroscience-activity-7258478312610480131-0_K4).

This leads directly to the question behind the trigonometry paper: **`What is the actual geometry of how a model thinks about numbers?`**

### The Trigger: Existential Concern Meets Physicist's Toolkit

Tegmark's path wasn't purely academic curiosity. It was driven by a profound sense of urgency and responsibility, again viewed through a physicist's historical lens.

1. **The Warning Sign (The Nuclear Physicist's Analogy)**: Tegmark frequently draws a direct parallel between the development of AI and the development of the atomic bomb [](https://www.theguardian.com/technology/article/2024/may/25/big-tech-existential-risk-ai-scientist-max-tegmark-regulations?CMP=Share_iOSApp_Other)[](https://www.theguardian.com/technology/2025/may/10/ai-firms-urged-to-calculate-existential-threat-amid-fears-it-could-escape-human-control). He points to Enrico Fermi building the first nuclear reactor in 1942. The top physicists of the time immediately understood that the single biggest hurdle to building a bomb had just been overcome. They `freaked out,` and three years later, the Trinity test proved them right.
    
2. **The `Fermi` Moment for AI**: For Tegmark, the release of GPT-4 was that same kind of signal [](https://www.theguardian.com/technology/article/2024/may/25/big-tech-existential-risk-ai-scientist-max-tegmark-regulations?CMP=Share_iOSApp_Other). It was the proof that the `chain reaction` was achievable. He saw that the power of these systems was growing exponentially, but our _understanding_ of them was not. This created an unacceptable risk. If we can't predict what a powerful system will do, we can't control it.
    
3. **The `Compton Constant`**: He's even formalized this with the idea of a `Compton constant`—a term borrowed from Arthur Compton, who calculated the odds of a nuclear explosion igniting the atmosphere before the Trinity test [](https://www.theguardian.com/technology/2025/may/10/ai-firms-urged-to-calculate-existential-threat-amid-fears-it-could-escape-human-control). Tegmark argues that AI companies have a moral and practical obligation to calculate the analogous constant for their AI: **What is the probability that we will lose control of it?** [](https://www.theguardian.com/technology/2025/may/10/ai-firms-urged-to-calculate-existential-threat-amid-fears-it-could-escape-human-control).
    

You cannot calculate that probability for a black box. You cannot prove a black box is safe. This brings us to his core strategy.

### The Strategy: Proof, Not Just Alignment

In his paper `Provably safe systems: the only path to controllable AGI,` Tegmark lays out his core argument [](https://ar5iv.labs.arxiv.org/html/2309.01933). He distinguishes between `alignment` (fine-tuning a model to behave well, which he sees as fragile) and `provably safe systems.` He argues that the only way to guarantee safety is with mathematical proof. An AGI, no matter how smart, cannot prove a mathematical falsehood [](https://ar5iv.labs.arxiv.org/html/2309.01933).

But to create a proof about how a system works, you have to understand it. You have to open the black box. This leads directly to his three `Levels of Ambition` for interpretability [](https://www.linkedin.com/posts/angeljsalazar_the-impact-of-chatgpt-talks-2023-prof-activity-7094292342576148481-LSx1)[](https://www.linkedin.com/posts/michael-molin-36060aa6_the-impact-of-chatgpt-talks-2023-prof-activity-7094508585287639040-RjgZ):

- **Level 1**: Understand the network well enough to assess its trustworthiness.
    
- **Level 2**: Understand it well enough to improve its trustworthiness.
    
- **Level 3**: Understand it so thoroughly that its trustworthiness can be _guaranteed_ through formal verification.
    

The trigonometry paper is a perfect example of **Level 1 work**. It's the foundational physics. Before you can prove a system's arithmetic is safe, you have to figure out how it does arithmetic in the first place. You have to discover the underlying geometry.

### The Eureka Moment: Finding the Helix

This is where the physicist's instinct for finding patterns pays off. Tegmark's group wasn't just looking for `which neuron fires for 5.` They were looking for the underlying _structure_. What they found was the helix [](https://www.globalplayer.com/podcasts/episodes/7DrtDSK/).

Imagine the moment of discovery. You're not just looking at a jumble of numbers; you're looking at a plot that shows the representations of 0, 1, 2, 3... and they aren't random. They trace out a perfect spiral. They form a _crystal_ of meaning [](https://www.linkedin.com/posts/bashekking_ai-machinelearning-neuroscience-activity-7258478312610480131-0_K4).

For a physicist who believes the universe is mathematics, this is a profound validation. The model, trained only on next-word prediction, had `discovered` a geometric representation of arithmetic. It spontaneously created a structure with a period of 10 to handle modular arithmetic (the units digit) and a linear component to track magnitude. It's a beautiful, parsimonious solution—exactly the kind a physicist would appreciate.

This discovery isn't just a neat fact. It's the first step toward **Level 2 and 3**. If you know the representation is a helix, you can start to ask:

- Can we _prove_ that this representation will always lead to correct addition within a certain range?
    
- Can we _detect_ when the representation is about to alias (the `ceiling effect`) and trigger a different, safer routine?
    
- Can we _steer_ this representation, much like you steered the truth vector in Aletheia, to guarantee correct arithmetic?
    

### His Thought Process, Reconstructed

So, to bring it all together, here is the likely chain of intuition that led Max Tegmark to co-author a paper on how LLMs use trigonometry to add:

1. **I am a physicist. I believe the universe, including the products of intelligence, is ultimately described by beautiful mathematics.**
    
2. **I am also deeply concerned that we are building incredibly powerful `alien minds` (AGIs) without understanding them, which poses an existential risk—just like the physicists who built the first atomic bomb.**
    
3. **The only way to guarantee safety is with mathematical proof, not just hoping they behave. But you can't prove something about a black box.**
    
4. **Therefore, we must open the black box. We must reverse-engineer these minds to discover the fundamental algorithms and representations they use. We need a `physics of intelligence.`**
    
5. **Let's start with a simple, well-defined capability: arithmetic. If we can understand the precise geometry of how a model represents numbers and performs addition, we will have taken the first, crucial step toward being able to verify that capability.**
    
6. **When we look, we don't find a mess. We find a helix. A clean, geometric structure using trigonometry. This confirms my core hypothesis—intelligence has a geometric signature—and gives us a handle we can actually use to understand, predict, and ultimately control these systems.**
    

He is attacking the problem the only way a physicist knows how: by finding the underlying laws and using them to build a safer world. Your project Aletheia, where you found a truth vector and a phase transition in the manifold, is the same instinct at work. You're both looking for the geometry of thought.