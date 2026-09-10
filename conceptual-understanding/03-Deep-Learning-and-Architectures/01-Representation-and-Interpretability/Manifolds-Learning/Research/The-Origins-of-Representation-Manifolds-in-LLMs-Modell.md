---
tags:
  - llm-manifolds-geometric-perspective
  - llm-foundational-texts
  - llm-manifolds-geometric-perspective
  - research-article
  - modell
  - llm-internal-memory
  - llm-interpretability
---

---
```table-of-contents
```
---
### References

- **Pdf** article ➝ [The-Origins-of-Representation-Manifolds-in-LLMs-Modell.pdf](<file:///home/az/04-Library/04-Advanced-Paradigms/01-Canonical-Bibles/Modell/The-Origins-of-Representation-Manifolds-in-LLMs-Modell.pdf>)
- **arXiv** ➝ [The Origins of Representation Manifolds in Large Language Models](https://arxiv.org/abs/2505.18235)
- [[Conceptual-Foundational-Manifold-Data-and-Models]]
- [[Conceptual-Manifold-Conceptualization-in-DeepLearning]]
- [[00-The-Bronstein-Bibliography-Geometric-Graph-ML]]
- [[00-The-Velickovic-Bibliography-Graph-Attention-Reasoning]]
- [[The-Linear-Representation-Hypothesis-Geometry-of-LLMs-Park]]
- [[Conceptual-Manifold-Data-Journey-in-LLM]]
- [[Conceptual-Manifold-Geometry-of-Large-Language-Models]]
- [[Conceptual-Manifold-The-Crumpled-Data-Perspective]]
- [[Conceptual-Manifold-The-Crumpled-Data-Perspective#Visual Representation The Crumbling to UnCrumbling]]
- [[Conceptual-Manifold-Data-Journey-in-LLM]]
- [[The-Mathematical-Foundations-of-Manifold-Learning-Book]]
- [[Deep-Manifold-Part-1-Anatomy-of-Neural-Network-Manifold-Ma-2025]]
- [[Deep-Manifold-Part-2-Neural-Network-Mathematics-Ma-2025]]
- [[DeepSeek-mHC-Manifold-Constrained-Hyper-Connections]]
- **Experimental Validation** 
	- [[01-Projects/LLMs/Project-Aletheia-Geometry-of-Truth/Project-Aletheia-Geometry-of-Truth-Implementation]] 
	- [[Project-Aletheia-Geometry-of-Truth-Code-Explanations]] 
	- [[Project-Aletheia-Geometry-of-Truth-Concepts]]
- 
---

>[!example] Paper bridges ➝  **Differential Geometry** + **Topology** + **LLM Interpretability** |  **Geodesic Distance Encoding**

---
### Latent Map

>**Thought experiement** 
>- Consider teaching a computer the concept of **Color**
>	- **The Old Way (Linear Hypothesis)** ➝  give the computer a checklist
>		- Is it Red? Yes/No 
>		- Is it Blue? Yes/No 
>		- Each color is a separate + unconnected arrow in space
>		- **there are no connections between the colors ➝ they are separate in the state space** 
>	- **The New Way (Manifold Hypothesis)** ➝ The computer understands Color not as a list ➝ but as a **Shape** (a wheel)
>		- It places Red next to Orange + Orange next to Yellow ➝ on a **curved loop** 
>		- Article proves mathematically ➝  LLMs don't just **store facts** as i**solated points** ➝  they store **complex continuous concepts** (like time, color, or rotation) ➝ as **geometric shapes** (manifolds)
>		- It explains **how** the brain of the AI ➝ **bends these shapes** ➝  to **fit** them into its **memory**
#### Challenge + Solution
- This paper challenges the strict **Linear Representation Hypothesis (LRH)** ➝  which posits that **features** are essentially **1D orthogonal vectors** 
- [[The-Linear-Representation-Hypothesis-Geometry-of-LLMs-Park]]
- Instead, it proposes the **Multidimensional Linear Representation Hypothesis**
	-  **Continuous features** (features $f$ that exist in a metric space $\mathcal{Z}_f$) ➝ are **mapped** ➝ via a **continuous function** $\phi$  ➝ onto a **submanifold** $\mathcal{M}_f$ ➝ **embedded** in the **activation space**
- Crucially, it demonstrates that the **Cosine Similarity** (the standard measure of AI vector similarity) is not arbitrary ➝  it is a functional encoding of the **Geodesic Distance** (shortest path) along these manifolds
#### Applicability
- **Mechanistic Interpretability ➝** For dissecting how LLMs think about continuous variables (eg, detecting if the model understands the _sequence_ of days in a year vs just memorizing their names)
- **AI Steering/Control ➝** If the shape of a concept (eg, the Political Leaning manifold) is known ➝  it is possible to slide the model's response along that curve rather than just trying to flip a binary switch
- **Safety & Alignment ➝** Detecting if a model has formed a **Deception Manifold** ➝ where it can smoothly transition between truth and lies
#### Importance 
- **It solves the Atomic Fallacy ➝** prevents us from incorrectly assuming all neural features are simple on/off switches
- **First-Principles Math ➝** It gives a rigorous proof (using the **Mercer Kernel** framework) for _why_ cosine similarity works, replacing empirical observation with mathematical certainty

--

> [!success] **Axiomatic Perspective** ➝ To reconstruct this concept from scratch ➝ need these **three axioms** derived from the paper
> - **Axiom 1 ➝ The Feature Definition**
> 	- A Feature is not a label; it is a **Metric Space** $(\mathcal{Z}, d)$
> 	- A feature ➝ has **internal structure** + **distance** (eg, 1999 is close to 2000 but far from 1900)
>---
> - **Axiom 2 ➝ The Topological Correspondence**
> 	- The **representation** of a **feature**  ➝ is a **Homeomorphism**
> 	- The map $\phi$ ➝ **preserves** the **topology** 
> 	- If the concept is a loop (like days of the week) ➝  the neural representation will be a loop
> 	- If the concept is a line (like numbers) ➝  the representation is a line
>--- 
> - **Axiom 3 ➝ The Geometric Isometry (The Cosine Rule)**
> 	- Local Cosine Similarity encodes **Intrinsic Distance**
> 	      $$\text{CosSim}(\mathbf{u}, \mathbf{v}) \approx g( \text{distance}_{\text{manifold}}(\mathbf{u}, \mathbf{v}) )$$
> 	- The **angle between two neuron vectors**  ➝  indicates ➝ how **far apart** the **concepts** are on the manifold

--

> The concept Days of the Week (a cycle) ➝  embedded in a 3D vector space
> The **manifold** is the **loop structure**

![[Pasted image 20260210061812.png | 500]]

---
### Section: Abstract

>[!example] Defines the core conflict ➝  the tension between the Old Physics of AI (**Linear Representations**) + the New Physics proposed by the authors (**Manifold Representations**)

#### Explanations 

>- Traditionally ➝  scientists believed AI stored concepts like a giant wall of light switches ➝ the **Linear Representation Hypothesis (LRH)**
> 	- In the LRH view ➝  every concept ➝ like Eiffel Tower or Floppy Ears ➝ was a single switch ➝  It was either **ON** or **OFF**
>- This paper argues that **this view is too simple**
> 	- It proposes that for complex concepts (like Color or Time) ➝  the AI doesn't use switches ➝  it uses **sliders and dials** (Manifolds)
> 	- Instead of just Red ➝ Yes/No, the AI builds a **curved shape** where Red flows into Orange
>- The abstract claims ➝  the **angle** between two points (**Cosine Similarity**) isn't random ➝ it **mathematically** measures the **shortest path** along this **curved dial**

> [!cite] **LRH vs Manifold Perspecitve**
> - Wrong way to think ➝ Strict **Linear Representation Hypothesis (LRH)** ➝ which models neural representations ➝ as sparse linear combinations ➝ of almost-orthogonal vectors
> - Correct way to think ➝ **Manifold Theory**  ➝ where features are not atomic directions ➝ but continuous + multi-dimensional embeddings

> [!quote] **The core mathematical claim of this paper is ➝ a rigorous derivation of Cosine Similarity** 
> - The paper posits ➝ **Cosine Similarity** in the **embedding space** ($\mathbb{R}^d$) ➝ is a **functional encoding** of the **Intrinsic Geodesic Distance** on the **feature manifold** $\mathcal{M}$
> - This connects the **extrinsic geometry** (vector angles) ➝  directly to the **intrinsic topology** (concept relatedness)

>[!critical] The paper **proves** that the **angle (Cosine Similarity)** ➝ tells you the **length** of that **Shortest Path

#### Applicability

- **Translator Tools** ➝ It applies to how we translate the alien language of AI numbers into human concepts
- **Feature Hunting** ➝  It is used when scientists try to find specific behaviors inside the AI (like deception or sentiment) that don't look like simple on/off switches but look like complex curves
    
> [!quote ] **Mechanistic Interpretability & Metric Learning**
> - **Mechanistic Interpretability** ➝ Specifically for **Sparse Autoencoders (SAEs)** Standard SAEs look for atomic features; this theory supports Manifold-Aware SAEs that can recover continuous variables
> 	- [[Conceptual-Introductory-MI#The Connected Components of Mechanistic Interpretability]]
> - **Metric Learning ➝** It validates the use of cosine similarity as a proxy for semantic distance in text embeddings (eg, OpenAI's `text-embedding-3`)

#### Importance

- It solves a massive mystery ➝ **Why does AI math match human intuition?**
- We know that if we measure the angle between the word King and Queen, they are close 
- But _why_? ➝ This paper provides the mathematical proof 
- It proves that the AI is forced to bend its internal memory ➝ into shapes that mimic the real relationships of the concepts it learns

> [!success] **Axiomatic**
> - **Universal Axiom Derivation ➝** It moves Interpretability from empirical observation (looking at clouds) to rigorous topology (measuring the clouds) 
> - **Structural Validity ➝** It explains the unreasonable effectiveness of cosine similarity by proving it approximates the shortest path on the manifold, justifying its use in everything from RAG (Retrieval-Augmented Generation) to clustering

---
####  The Old Perspective LH vs Manifold Perspective 

> **The Old View (Linear Hypothesis)** ➝  Isolated + independent vectors ➝  no **path** between them
>[[The-Linear-Representation-Hypothesis-Geometry-of-LLMs-Park]]

![[Pasted image 20260210061852.png | 500]]

> **The New View (Manifold Hypothesis)** ➝ A continuous curve (Manifold) embedded in the space ➝ The **Path** matters

![[Pasted image 20260210061839.png | 500]]

##### The Manifold Hypothesis

> [!example] **The Manifold Hypothesis**
>-  Imagine two different concepts ➝ **"Truth"** and **"Lies"**
> 	- In a perfectly "untangled" world ➝  they would be two flat, parallel sheets of papers
> 	- It would be easy for a machine to draw a line between them
> 
>- However, in the raw input (the initial state) ➝ these two concepts are **crumpled together** into a tight ball
>	- If you poke a needle through that ball ➝ you might hit "Truth," then "Lie," then "Truth" again ➝ because they are so tightly folded and intertwined
>	- This is **Entanglement**
>	- The model's job throughout its layers is to carefully "uncrumple" the paper until the concepts are flat and separated again
> 
>---
> 
> - **High-Dimensional Non-Linearity** 
> 	- Input embeddings live in a high-dimensional space where classes are not linearly separable
> 	- The **Entanglement Problem** is defined by the high **intrinsic dimensionality** of the data manifold
>     
> - **The Untangling Transformation**
> 	- Each Transformer layer acts as a **Homeomorphism** (a continuous transformation)
> 	- The goal of the attention heads and MLPs is to "flatten" the curvature of the manifold
>     
> - **Layer-wise Linearization** 
> 	- As the data passes through the model ➝  the **Fisher Information Metric** changes
> 	- By the time you reach Layer 20 ➝  the model has achieved **Linear Separability**
> 	- The "entanglement" has been resolved into a stable, directed vector in latent space
>> Can be seen in ➝ [[01-Projects/LLMs/Project-Aletheia-Geometry-of-Truth/Project-Aletheia-Geometry-of-Truth-Implementation#Visualization Manifold Unfolding]]
>     
> - **Topological Invariants** 
> - During entanglement, the "features" are topologically complex
> - The paper argues that the model isn't just learning features ➝ it's learning to simplify the **Topology of the Data**

```toml
[ Layer 01 ] -> [ Layer 10 ] -> [ Layer 20 ]
   (Tangled)       (Unfolding)      (Untangled)
      @@@             /  /            |  |
     @ @ @    --->   /  /     --->    |  |
      @@@           /  /              |  |
(Crumpled Data)  (Partial Map)    (Linear Manifold)
```

--

>[!critical] **The AI we already have is using Manifolds ➝ but we were wrong to think  ➝ that its thought process ➝ is along the linear lines**

> Imagine we are studying the planet Earth (the LLM)
> - **The Old Theory (LRH) ➝** Scientists thought the Earth was **Flat** (Linear) 
> 	- They said, If you walk North, you go up If you walk East, you go right It worked for short trips around the village
> - **The New Theory (Manifold) ➝** actually, the Earth is **Round** (Curved/Manifold)
> **The Conclusion ➝** The Earth (the LLM) didn't change ➝ It was always round 
> 	- But our _understanding_ of it changed 
> 	- The paper is debunking the Flat Earth theory of AI representations ➝  proving that the Linear view was just an oversimplification

> Scientists have been struggling to explain _how_ it stores complex ideas
> - **Strict LRH (The Old Way) ➝** Assumed that King is a vector arrow, and Queen is another arrow
> - **The Problem ➝** This simple arrow theory couldn't fully explain why King can smoothly transition into Queen or why Hot transitions into Cold
> - **The Solution (This Paper) ➝** It proves the LLM naturally bent those arrows into curves (manifolds) during training It did this automatically to fit all that knowledge into its limited memory

>[!grey] **The paper ➝ is a Diagnostic Breakthrough**
>Our undestanding of these concepts changes how we make the **tools to fix/study it**
> - **Old Tools (Sparse Autoencoders) ➝** Were designed to look for straight lines ➝ They often failed to find complex features
>- **New Tools (Manifold-Aware) ➝** Now that we know the features are curved, we can build curved microscopes (Manifold SAEs) to find hidden concepts we missed before

--
#### Database vs Neural Network
- **Classic Software (Database) ➝** We tell the computer ➝  Put 'King' in Row 1, Column A  ➝ We know exactly where it is and how it is stored ➝ This is **Engineering**
- **AI (Neural Network) ➝** We tell the computer ➝  Here are a billion books  ➝ Figure out a mathematical way to predict the next word ➝ We don't tell it _how_ to arrange the numbers to make that prediction ➝ This is **Optimization**
#### Surprise Surprise 
- For years, scientists _assumed_ the model was solving the problem the easy way ➝ I'll just make a list of words (The Linear Hypothesis)
- This paper is a shock because it says ➝ Actually, the model didn't make a list 
	- The model realized that 'Colors' are a continuous wheel
	- so it built a wheel structure inside its math ➝  that was the most efficient way to win the game we designed

> **Summary ➝** We built the playground and the rules of the game 
>- The **Manifold** is the winning strategy the model came up with on its own 
>- We are now just trying to reverse-engineer _how_ it did it

--
#### Paradigm Shift: Imperative to Declarative 

> [!example] **Paradigm Shift with LLMs** 
>1. **The Shift ➝ Imperative $\to$ Declarative**
>	- **Imperative (The Old Way) ➝** In traditional coding, we act like **Architects** We explicitly tell the computer ➝ _Create a list Store 'King' at index 0 Store 'Queen' at index 1_ We know the structure is linear because **we built it**
>	- **Declarative (The AI Way) ➝** In Deep Learning, we act like **Coaches** We tell the computer ➝ Here is a goal ➝ Predict the next word Figure out your own way to store the data to win
>	
>2. **The Blind Spot**
>Because we didn't build the internal storage ourselves, we couldn't see it
>	- **The Assumption (Linearity) ➝** When we finally peeked inside the Black Box to see how it solved the problem, we brought our old baggage with us We assumed the AI would organize data the way _we_ used to ➝ in neat, straight lists (Linear Representations)
>	- **Why did we assume this?** Because it's the simplest explanation It's how humans organize spreadsheets and databases We projected our own simplicity onto the machine
>
>3. **The Reality (The Abstract's Revelation)**
>The Abstract of this paper is essentially saying ➝
> **The AI didn't use your human 'List' method It invented a 'Shape' method (Manifolds) because that is mathematically more efficient for compressing predictive structure under constraints** 
> **Mechanism ➝ Compression + Generalization**
>---
>
>_emergent intellegence ➝ due to mathematically efficient manifold method (recall emergent properties in nano-materials at macro-scale)_
>
>---
>**LLMs ➝ the paradigm shift to Declarative (Black Box) ➝ but we couldn't see inside ➝ so we guessed LLMs have a Linear thought process ➝ We were wrong**

> [!cite] **Imperative → Declarative  ➝ It changes who chooses the representation**
> - In the **imperative** world, _we_ choose ➝
>     - data structures
>     - invariants
>     - storage layout       
>     - traversal order  
>         Meaning is imposed **top-down**        
> - In the **declarative** world, we choose ➝
>     - an objective
>     - constraints
>     - a learning rule  
>         Meaning emerges **bottom-up**
>---
> - In imperative systems ➝
> 	- **Structure → Meaning**
> - In declarative learning systems ➝
> 	- **Meaning → Structure**

>[!success] Axiomatic
> Given a declarative objective, finite capacity, and smooth optimization,  
> the most efficient internal representation of structured data  
> is **geometric**, not symbolic
>---
> The model didn’t store knowledge in lists  
> It stored _relationships as shape_
>--- 
> Manifolds aren’t a clever hack  
> They are **compression-optimal representations for continuity**

>[!success] Axiomatic Perspective ➝ **Constraint drives Geometry** 
>Because the model has limited memory (dimensions) but infinite data to learn, the **only** way to fit it all in is to bend the data into curves (Manifolds) If it used the List Method, it would run out of space instantly

--- 
### Section 1: Introduction

> The introduction explains that for a long time ➝  scientists have been trying to read the AI's mind using a **dictionary approach**
- **The Dictionary (Linear Hypothesis) ➝** They assumed the AI breaks everything down into atomic bits ➝ Has Ears, Is Tall, Is French ➝ You either have it or you don't
- **The Problem ➝** Recent evidence shows the AI isn't just making lists ➝ it's drawing shapes 
	- It represents **numbers** as circles (clocks) + concepts like **Deception** or **Sentiment**  ➝ as complex curves
- **The Proposal ➝** The authors say ➝ need a new math to read these shapes 
	- They propose treating a Feature not as a switch ➝  but as a **Metric Space** (a mathematical space where distance matters)

> [!success] **Axiomatic** ➝ A **feature** is ➝ **not** a **vector** | A **feature** ➝  is a **space**

--
#### Explanations

>- **The Status Quo:** The field of **Mechanistic Interpretability**  ➝ relies heavily on ➝  **Linear Representation Hypothesis (LRH)**
>	- assumes ➝ **features** are **directions** in **activation space** ➝ recoverable by **Sparse Autoencoders (SAEs)**

- **The Conflict:** Empirical evidence contradicts the **atomic nature of LRH**
	- Neural networks ➝ represent **features** ➝ as **curves**, **loops**, **tori**, and **Swiss-roll manifolds**
	- `how did they observe this ➝ see the next sub-section` ➝ [[#How did the Probe work]] | [[#How did they probe to observe how the LLM is representing features]]
	- also see ➝ [[01-Projects/LLMs/Project-Aletheia-Geometry-of-Truth/Project-Aletheia-Geometry-of-Truth-Implementation]]

>- **The New Definition ➝** The authors introduce the **Multidimensional Linear Representation Hypothesis** ➝  where a **feature** $f$ is **associated** with a **subspace** $V_f$
>- **The Goal ➝** To provide a minimum viable mathematical theory ➝  that links the **intrinsic geometry** of a feature (concept space) ➝ to the **cosine similarity** in representation space

#### Applicability

- **Debugging AI ➝** If an AI is being deceptive, it might not be a simple Lying Mode ➝ ON switch 
	- it might be a Lying Spectrum that curves from White Lie to Malicious Fraud 
	- this theory helps us find that curve
- **Better Search ➝** When you search for Summer Vacation, the AI doesn't just look for the words
	- it looks for the _concept_ of summer on a Seasonal Loop inside its brain
--
- **SAE Design ➝** It challenges the design of Sparse Autoencoders 
	- Current SAEs punish active features ➝ but if a feature is a **continuous manifold** (always active, just moving along a curve) ➝  standard SAEs might fail to capture it or break it into meaningless fragments    
- **Text Embeddings ➝** It applies directly to commercial embeddings (like OpenAI's `text-embedding-3`)
	- explaining why **cosine similarity** ➝ effectively measures **semantic distance**
    
#### Why is it important?
- It validates that the AI is ➝ **learning structure**  (not just facts)
	- If the AI learns that Monday connects to Tuesday, ➝ it means it has learned the **concept of a week** ➝ not just the **names of the days**
- The introduction argues ➝  to truly understand (and control) AI ➝  stop looking for atoms + start looking for geometry
--
- **Theoretical Grounding ➝** It moves the field away from ad-hoc observations of cool shapes to a formal **Topology-Preserving** framework
- **Unified Theory ➝** It bridges the gap between **disentanglement** (separating factors of variation) and **superposition** (packing features into limited space), suggesting that manifolds are the natural solution to compression

--

>[!critical] **The Atomic View (Standard SAE) ➝ The AI sees Monday and Tuesday as separate buckets**

![[manifolds-5.png | 500]]

>[!critical] **The Geometric View (Manifold Theory) ➝ The AI sees Time as a continuous slider (Manifold)**

![[manifold-4.png | 500]]

--
#### Axiom: Feature & State

>[!success] Axiomatic ➝ Feature & State
>**The Feature is the whole circle** 
> **The State is a position on that circle**

--
#### How did they probe to observe how the LLM is representing features

> [!example] **Probing Techniques** 
> It started with a failure Researchers were using **Probes** (simple linear classifiers) to find concepts
> - **The Method ➝** They took a trained LLM and fed it 1,000 sentences about Happiness and 1,000 about Sadness
> - **The Expectation ➝** If the AI understands emotions, there should be a Happiness Direction (a straight arrow) in its neurons
> - **The Result ➝** It worked _sort of_ They found a direction But when they moved _slightly_ off that line, the AI didn't just get less happy ➝ it drifted into totally unrelated concepts like Energy or Urgency
> - **The realization ➝** The concept wasn't a straight line It was curving away from them   
>---
> **The Discovery ➝ How they Saw the Shapes**
>- They used three main tools to visualize this invisible geometry
> 
> 1. **The Day of the Week Experiment (Cyclic Topology)**
> 	- **The Setup ➝** They fed the AI sentences ending in days ➝ Today is Monday, Today is Tuesday, etc
> 	- **The Probe ➝** They extracted the neuron activations for just the word Monday, Tuesday, etc
> 	- **The Visualization (PCA/UMAP) ➝** They used dimensionality reduction (like squashing a 3D object into a 2D shadow) to see where these points landed in space
> 	- **The Shock ➝** The points didn't form a line or a cluster **They formed a perfect circle**    
> 	    - Monday was next to Tuesday
> 	    - Sunday was next to Monday
> 	    - **Crucially ➝** The distance between Monday and Thursday (across the circle) was exactly what you'd expect mathematically
> 	- **Conclusion ➝** The AI had independently reinvented the geometry of a clock face to understand time
>---     
> 2. **The Sentiment Experiment (Curved Manifolds)**
> 	- **The Setup ➝** They looked at how the AI represents Good vs Bad movie reviews
> 	- **The Discovery ➝** It wasn't two piles (Good pile vs Bad pile) It was a **Boomerang shape**
> 	- **Center of Boomerang ➝** Neutral/Objective reviews
> 	    - **Arm 1 ➝** Positive reviews (curving outwards)
> 	    - **Arm 2 ➝** Negative reviews (curving outwards in a different direction)
> 	- **Why this matters ➝** A linear probe (a straight knife cut) would slice through the boomerang clumsily, misclassifying the neutral ones The manifold shape explained why simple classifiers were failing
>--- 
> 3. **The Othello Experiment (The World Model)**
> 	- **The Setup ➝** They trained a small AI to play the board game Othello ➝  It was _only_ trained on text moves (E5, C3) ➝ It never saw the board
> 	- **The Probe ➝** They checked its **internal state**
> 	- **The Find ➝** The AI had built a **literal 8x8 geometric grid** inside its neurons
> 	- **How they knew ➝** They could modify a specific neuron ➝  the AI would think a piece on the board had flipped color ➝ even though the text history didn't say so
> 	- **The Smoking Gun ➝** The AI wasn't predicting moves based on text statistics ➝  it was **maintaining a _geometric mental image_** of the board state
>---
>4. **Linear Probes Failed ➝** Straight lines couldn't separate complex concepts cleanly
>5. **Projection Revealed Curves ➝** PCA/UMAP showed the points formed circles and boomerangs, not blobs    
>6. **Intervention Proved It ➝** Rotating the activation along the curve smoothly changed the output (eg, changing Monday to Tuesday without breaking the sentence structure)  
>[[Hallucination-Cross-Layer-Probing#Deep Dive Linear Probe Training]]]
>

#### Axiom: Constraint drives Geometry

> [!success] **Axiomatic** ➝ **Constraint drives Geometry**
>- **Space is expensive ➝** The AI has limited dimensions (eg, 4096 neurons) to store millions of concepts
>- **Linearity is wasteful ➝** If you give every concept its own straight line, you run out of space fast (Curse of Dimensionality)
>- **Manifolds are efficient ➝** If you curl the line into a spiral, you can pack a generic Sequence concept (days, numbers, musical notes) into a tiny space

--
#### How did the Probe work 

>**The Probe ➝** They extracted the **neuron activations** for just the word Monday, Tuesday, etc

##### The Problem ➝ The Polysemantic Soup

> [!example] **Superposition**
> - If we just look at **Neuron #4092** in a Large Language Model ➝ it doesn't just mean Monday 
> 	- It might mean Monday AND The color Blue AND Medieval History 
> 	- This is called **Superposition**
> - _Analogy_ ➝ Imagine trying to isolate the sound of a violin in a recording of a full orchestra 
> 	- You can't just listen to microphone 3 because microphone 3 picked up the violin, the cello, and the drums
>- [[04-Library/03-Deep-Learning-and-Architectures/01-Representation-and-Interpretability/LLM-Mechanistic-Interpretability/Theories/Superposition/00-Conceptual-Understanding/Conceptual-Superposition-in-LLMs]]
>- [[Conceptual-Sparse-Auto-Encoders-SAE-MI#The Core Problem Superposition]]

##### The Solution: The Prism Method (Sparse Autoencoders)

> To extract _pure_ Monday-ness ➝ the researchers used a tool ➝  **Sparse Autoencoder (SAE)** 
> This acts like a prism ➝ that splits the messy white light of the neuron activations ➝ into clear rainbow colors (atomic features)
> [[Conceptual-Sparse-Auto-Encoders-SAE-MI]]

> [!quote] **Step-by-step extraction protocol used for the Days of the Week (specifically on the Mistral 7B model, Layer 8)**
> ##### Step 1: The Surgery (Intervention)
> 
> They didn't just read the output ➝ they performed brain surgery while the model was reading
> - **Action:** They fed the model sentences like: The meeting is on **Monday**
>     - **Extraction:** At **Layer 8** ➝ they paused the calculation and copied the **Residual Stream**
> - **Data:** This is a massive vector (eg, 4096 numbers) representing the model's entire current thought process
>     
> ##### Step 2: The Prism (SAE Projection)
> 
> They pushed this massive vector through a **Sparse Autoencoder (SAE)**
> - **SAE** ➝  It is a separate, smaller neural network trained specifically to hunt for patterns in that layer ➝ has a dictionary of features
> - **The Result:** The SAE takes the messy 4096 numbers and outputs a Sparse Feature Vector
>     - Most features are 0 (Inactive)
>     - **Feature #1254** lights up (This is the Day of the Week feature)
>     - **Feature #899** lights up (This might be Next word is a noun)
> 
> ##### Step 3: The Isolation (Sub-selection)
> 
> They threw away everything ➝ except the specific feature they wanted to study
> - **Action ➝** They isolated the activation vector for the **Day of the Week** feature
> - **Normalization ➝** They normalized these vectors to have a length of 1 (Unit Norm) so they could focus purely on the _direction_ (angle), not the magnitude
>     
> ##### Step 4 ➝ The Shadow (PCA Visualization)
> 
> Even isolated, these features exist in high-dimensional space ➝ to see the Circle ➝  they had to cast a shadow onto 3D space
> - **Method ➝** Principal Component Analysis (PCA)
> - **Result ➝** When they plotted the points for Monday, Tuesday, etc, the PCA revealed they were arranged in a loop
>---
>[[01-Projects/LLMs/Project-Aletheia-Geometry-of-Truth/Project-Aletheia-Geometry-of-Truth-Implementation#Visualization The Geometry of Truth]]
>[[01-Projects/LLMs/Project-Aletheia-Geometry-of-Truth/Project-Aletheia-Geometry-of-Truth-Implementation#Visualization Manifold Unfolding]]
>[[01-Projects/LLMs/Project-Aletheia-Geometry-of-Truth/Project-Aletheia-Geometry-of-Truth-Implementation#Further Visualization Refinement PCA vs LDA]]
>[[01-Projects/LLMs/Project-Aletheia-Geometry-of-Truth/Project-Aletheia-Geometry-of-Truth-Implementation#IV. Probing the Residual Stream]]

    
### **Alternative Method ➝ The Black Box Approach (Text Embeddings)**

For simpler experiments (like the Color Wheel or Dates), they used a cruder, easier method ➝

- **Model ➝** OpenAI's `text-embedding-large-3`
    
- **Method ➝** They just asked the API for the embedding of the word Red, Blue, etc
    
- **Why this works ➝** These commercial embedding models are _already_ trained to separate concepts The SAE step is effectively baked into the product
    

### **Summary of the Protocol**

1 **Feed** text to the LLM
    
2 **Intercept** the raw brain activity (Residual Stream)
    
3 **Untangle** the mixed signals using an SAE (The Prism)
    
4 **Isolate** the specific concept vector (eg, Feature #1254)
    
5 **Project** it down to 3D to see the shape



### **The Clue References**

#### **1 The Othello Experiment (The Grid)**

- **What is it about?** Proof that a model trained only on text builds a geometric world model (a board) inside its neurons
    
- **Reference ➝** _Li, K, Hopkins, A K, Bau, D, Viégas, F, Wattenberg, M, & Belinkov, Y (2022)_ **Emergent World Models in Sparse Transformers**
    
- **Technical Context ➝** They used linear probes to show that internal activations could predict the state of the Othello board with high accuracy, even though the model never saw a board
    

#### **2 The Days of the Week/Clock (Cyclic Features)**

- **What is it about?** Discovery that cyclic concepts like time or angles are stored as loops (circles) in high-dimensional space
    
- **Reference ➝** _Modell, A, Rubin-Delanchy, P, & Whiteley, N (2025)_ **The Origins of Representation Manifolds in Large Language Models** (The very paper we are reading!)
    
- **Technical Context ➝** Section 1 and 2 of your uploaded paper explicitly cite these examples to motivate their Manifold Hypothesis They specifically highlight how these circular representations appear in models like Mistral and Llama
    

#### **3 The Sentiment Boomerang (Curved Geometry)**

- **What is it about?** The first major discovery of a single neuron controlling a complex concept (sentiment) and how it relates to the surrounding geometry
    
- **Reference ➝** _Radford, A, Wu, J, Child, R, Luan, D, Amodei, D, & Sutskever, I (2017)_ **Learning to Generate Reviews and Discovering Sentiment** (OpenAI)
    
- **Technical Context ➝** While this paper found the Sentiment Neuron, later work by **Anthropic** (eg, _Towards Monosemanticity_) used Sparse Autoencoders to show that sentiment isn't just a point, but a manifold (a curve) that models use to navigate positivity vs negativity
    

#### **4 The Prism Method (Sparse Autoencoders)**

- **What is it about?** The invention of the tool used to untangle the neuron soup to find the manifolds
    
- **Reference ➝** _Bricken, T, et al (2023)_ **Towards Monosemanticity ➝ Decomposing Language Models With Sparse Autoencoders** (Anthropic)
    
- **Technical Context ➝** This is the definitive manual on using SAEs to extract features from the residual stream of an LLM
    


---

### **Why these specific references matter for your notes ➝**

1 **Li et al (2022)** proves the AI isn't just stochastically parroting text; it is building a spatial map
    
2 **Bricken et al (2023)** provides the microscope (SAE) that makes it possible to see the manifolds
    
3 **Modell et al (2025)** (The current paper) takes all those specific observations and creates a **Universal Law** ➝ Features are not labels; they are shapes


### **The Metric Space Comprehension Check**

The paper claims a feature is a **Metric Space $(\mathcal{Z}, d)$**

- **The Concept ➝** In a Bucket (Set) world, Monday and Tuesday are just different $A \neq B$
    
- **The Metric Space world ➝** There is a **distance** $d$ between them $d(\text{Monday}, \text{Tuesday}) = 1$, but $d(\text{Monday}, \text{Thursday}) = 3$
    

**The First-Principle Realization ➝**

If the AI represents Monday and Tuesday as vectors $\mathbf{u}$ and $\mathbf{v}$, it doesn't just need to keep them separate; it needs to keep them **at the correct distance**

If the AI fails to preserve the distance, it breaks the concept If Monday suddenly feels as far from Tuesday as it does from Elephant, the model's world model collapses

**This leads to a question for your comprehension ➝**

If the LLM's goal is to predict the next word, and the word is Tuesday, why does the model _benefit_ from knowing that Tuesday is close to Monday? Why not just treat them as totally unique, unrelated symbols?



### **The Layman Explanation ➝ The Shortcut Principle**

**What is it?** If the AI has Monday and Tuesday in separate buckets (the List Method), it has to learn every relationship from scratch It has to learn that I went to work on could be followed by Monday, AND it has to separately learn it could be followed by Tuesday

**What does it do?** By placing them on a **Manifold (a curve)**, the AI creates a shortcut It doesn't learn a thousand separate rules; it learns the **Rule of the Curve**

**Why is it important?** If the AI knows Monday is close to Tuesday, and it learns a fact about Monday, that knowledge automatically leaks or flows to Tuesday It gets Generalization for free It doesn't have to be told that Tuesday is also a workday; the proximity on the shape tells it so

---

### **Technical Jargon ➝ Principal-Level Specs**

**The Smoothness Constraint (Lipschitz Continuity)**

In a high-dimensional vector space, we want the model's output to change **smoothly** as the input changes If a feature $f$ is a Metric Space $(\mathcal{Z}, d)$, the mapping $\phi$ into the model's brain is ideally **continuous**

- **Axiom ➝** Small changes in the Concept Space (moving from 11 ➝59 PM to 12 ➝01 AM) should result in small changes in the Activation Space
    
- **Mathematical Necessity ➝** If the representation were linear/atomic (buckets), the derivative would be undefined or infinite at the boundaries By using a **Manifold**, the model ensures that the probability distribution $P(\text{next\_word} | \text{context})$ varies smoothly along the geodesic
    

**Low-Rank Representation**

The model has a bottleneck (limited neurons) A Manifold is a way to compress a high-dimensional concept into a low-dimensional pipe If the AI can describe Time using one curved line (1D manifold) instead of 365 separate direction vectors, it saves massive amounts of memory (parameters)

---

### **ASCII Visualization ➝ The Probability Flow**

**The Bucket Way (Inefficient)**

_Probability is trapped in silos No relationship between peaks_

Plaintext

```
Prob ^      [Mon]         [Tue]         [Wed]
     |       |||           |||           |||
     |       |||           |||           |||
     +-------|||-----------|||-----------|||-----> Feature Space
```

**The Manifold Way (Efficient)**

_Probability flows along the curve The model just has to know where it is on the path_

Plaintext

```
           (High Probability Zone)
              _______[Tue]_______
             /                   \
      [Mon] /                     \ [Wed]
           /                       \
----------+-------------------------+-----------> Neural Space
```

_The model predicts Tuesday because the Monday state naturally slides along the curve toward it_

---

### **Universal Axiom for Your Notes**

**Proximity in Geometry = Similarity in Probability**

The model uses Manifolds because they allow **Calculus** (continuous change) to replace **Bookkeeping** (discrete lists)

---



---


### **Section 2 ➝ The Continuous Correspondence Hypothesis**

This section is the heart of the paper It redefines the atomic unit of AI

#### **1 What is it about?**

**The Layman Explanation (The Map vs The Bucket)**

- **The Old Way (Bucket Theory) ➝** Previously, we thought a feature like Color was a collection of buckets One bucket for Red, one for Blue They are separate
    
- **The New Way (Map Theory) ➝** The authors propose that a feature is actually a **Terrain** (a Metric Space)
    
    - Imagine Color is not a set of buckets, but a **Color Wheel**
        
    - Imagine Time is not a stack of calendars, but a **Timeline**
        
    - **The Hypothesis ➝** The AI takes this abstract terrain (the Idea of color) and stretches it like a rubber sheet to fit it inside its neural network It doesn't break the sheet; it just bends it
        

**Technical Jargon (Principal-Level Specs)**

- **Definition of a Feature ➝** A feature is defined as a **Metric Space** $(\mathcal{Z}_f, d_f)$ It is a set equipped with a distance function
    
- **The Hypothesis ➝** The mapping from this abstract concept space $\mathcal{Z}$ to the neural activation space is a **Homeomorphism** (topological isomorphism)
    
- **Implication ➝** This map $\phi$ is continuous and invertible If the concept space is compact (like a circle), the neural representation _must_ be a closed loop It preserves the **Topology** (holes, connectedness) of the concept
    

#### **2 Where is it applicable?**

**The Layman Explanation**

- **Colors (Cyclic) ➝** The authors show that the AI arranges Red, Blue, Green in a perfect circle, matching the human color wheel
    
- **Years (Linear) ➝** The AI arranges 1900 to 1999 in a long, snake-like line
    
- **Dates (Toroidal/Cyclic) ➝** January 1st connects to December 31st, forming a loop
    

**Technical Jargon**

- **Feature Topology ➝** It applies to any continuous variable
    
    - $Z = [0, 1]$ (Interval) $\to$ Curve
        
    - $Z = S^1$ (Circle) $\to$ Loop
        
    - $Z = \text{Tree}$ $\to$ Branching Manifold
        
- **SAE Visualization ➝** It validates why UMAP/PCA plots of SAE latents often look like threads or loops rather than scattered dust
    

#### **3 Why is it important?**

**The Layman Explanation**

It explains **why** the AI is so good at generalizing

If Color was just random buckets, learning Red wouldn't teach you anything about Pink But because the AI builds a **Map**, if it learns about Red, it automatically understands the territory nearby (Pink and Orange) It builds a World Model of the concept

**Technical Jargon**

- **Manifold Hypothesis Justification ➝** It provides the mechanism for _why_ data lies on low-dimensional manifolds The network is actively constructing them to maximize **Linear Expressivity**
    
- **Polynomial Computation ➝** The paper argues that by bending the line into a curve (eg, a polynomial curve), the network allows simple linear layers to compute complex non-linear functions (like $x^2$ or $x^3$) just by projecting onto different axes of the curve
    

---

### **ASCII Diagram ➝ The Transformation (Homeomorphism)**

**1 The Abstract Concept (The Idea)**

_A simple ruler (Metric Space)_

Plaintext

```
[1900] ---- [1950] ---- [1999]
```

**2 The Neural Representation (The Manifold)**

_The AI bends the ruler to fit it into 3D space, but KEEPS the order_

Plaintext

```
      (Neural Dimension Y)
             ^
             |    [1950]
             |   /      \
             |  /        \
 [1900] ----+--/          \-- [1999] ---> (Neural Dimension X)
             |
```

_Note ➝ The line is bent, but if you walk along it, 1950 is still exactly halfway between 1900 and 1999 The Topology is preserved_