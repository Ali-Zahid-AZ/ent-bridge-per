---
tags:
  - conceptual-explanations
  - mechanistic-interpretability
  - mechanistic-interpretability-superposition
  - mechanistic-interpretability-superposition
  - mechanistic-interpretability-tools
  - mechanistic-interpretability-reasoning-circuits
  - llmops-hallucination
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

- [[Conceptual-Basics-Anatomy-of-Compute-Feature-Manifolds-Circuit-Topologies]]
- [[Conceptual-Axiom-MI-Geometric-Constraints]]
- [[Conceptual-Manifold-Geometry-of-Large-Language-Models]]
- [[Conceptual-Truth-Concept-in-LLMs-Manifold-Perspective]]
- [[Conceptual-Linear-Representation-in-LLMs]]
- [[Conceptual-Linear-Probes-LLMs-Manifolds-Perspective]]
- [[Conceptual-PolySemanticity-MonoSemanticity-MI]]
- [[Conceptual-Superposition-MI-LLMs]]al-
- [[Conceptual-Intertwined-Concepts-MI]]
- [[Conceptual-Truth-Concept-in-LLMs-Manifold-Perspective]]
- [[Conceptual-Activation-Space-Level-The-Geometry-of-Machine-Thought]]
- [[Conceptual-Sparsity-MI]]

- [Towards Monosemanticity: A Step Towards Understanding Large Language Models \| by Anish Dubey \| TDS Archive \| Medium](https://medium.com/data-science/towards-monosemanticity-a-step-towards-understanding-large-language-models-e7b88380d7b3)
- [Mechanistic Interpretability](https://www.aussieai.com/research/mechanistic-interpretability)
- [Mechanistic Interpretability: Peeking Inside an LLM \| Towards Data Science](https://towardsdatascience.com/mechanistic-interpretability-peeking-inside-an-llm/)
- [Understanding Mechanistic Interpretability in AI Models \| IntuitionLabs](https://intuitionlabs.ai/articles/mechanistic-interpretability-ai-llms)
- [Anthropic drops an amazing report on LLM interpretability \| by Lee Fischman \| Medium](https://medium.com/@lee.fischman/anthropic-drops-an-amazing-report-on-llm-interpretability-d3fbcd5ba762)

---
### 0. The Axiom 

>[!critical] **Interpretability** requires **geometric constraints** that **bound** the **solution space**

>[!quote] **The Fundamental Axiom: Geometric Constraints as the Source of Meaning**
>
>- **Corollary 1** 
>	- Without constraints ➝  the model's representations are rotationally symmetric → infinite equivalent representations → no privileged basis → no interpretability
>- **Corollary 2**
>	- Interpretability methods ➝ are distinguished by which constraint they impose ➝ sparsity, linearity, orthogonality, low-rank ➝  and how they break symmetry
>- **Corollary 3** 
>	- The model itself **learns constraints during training** (manifold, cone, outliers) → this is why it **becomes partially interpretable** without intervention

> #axiom | [[00-Admin-Axiom-Tracker-DeepLearning-ALL]] 

---
### 1. Introductory 

> [!success] **Mechanistic Interpretability** ➝ **is the study of reverse-engineering deep learning models**
> - We are moving from `Behaviorism` ➝ Input/Output observations ➝  to `Neuroscience` ➝ reading the neurons`
> 
> 1. **Theories** 
> 	- The fundamental laws of how models represent information 
> 	- example ➝ `Meaning is a direction`
> 2. **Techniques** 
> 	- The tools we use to touch and measure the model 
> 	- example ➝ `Probes,` `SAEs`
> 3. **Features** 
> 	- The atomic units of thought we discover using those tools 
> 	- example ➝ `The Truth Neuron`
> 4. **Circuits** 
> 	- The wiring diagrams of how those atoms connect to perform tasks 
> 	- example ➝ `How the model does Math`

#### I. Purpose of the Sub-Field: Mechanistic-interpretability

> [!example] **Purpose of the Sub-Field: Mechanistic-interpretability**
> 
> - While traditional AI research focuses on `creating` better models ➝ capabilities
> 	- Mechanistic Interpretability focuses on ➝ `reverse engineering` existing ones ➝ to understand how they work algorithmically
> 
> #### Key Distinctions
> 
> - **Behavioral Interpretability** 
>     - Focuses on inputs and outputs ➝ Old School Methodology
>     - `Example:` `If I change the prompt to be polite, the model becomes less biased`
>     - `Analogy:` Psychology ➝ observing behavior
>         
> - **Mechanistic Interpretability**
>     - Focuses on weights, neurons, and activation patterns
>     - `Example:` `Neuron 452 in Layer 14 activates when it sees a French noun, and it writes to the residual stream to trigger a gender agreement circuit in Layer 16`
>     - `Analogy:` Neuroscience
> 	    - tracing neural pathways 
> 	    - Debugging ➝ stepping through code

#### II. The Connected Components of Mechanistic Interpretability

> [!success] **MI** ➝  **Phenomenon** + **Consequences** + **Solutions**
>
>##### The Phenomenon: Superposition
> - The phenomenon where a neural network represents **more features than it has dimensions**
> 	- If a model has 512 dimensions but needs to track 10,000 concepts ➝ features ➝ it cannot give each concept its own dimension
> 	- Instead, it stores them in **Superposition** ➝ it packs multiple concepts into the same neurons using non-orthogonal interference patterns
> ##### The Consequences
> 1. **Polysemanticity** 
> 	- Because concepts are overlapping, individual neurons become `Polysemantic` ➝ doing 5 jobs at once
> 2. **Interference** 
> 	- The model has to tolerate a small amount of `noise` ➝ interference ➝ between concepts ➝ but it learns to keep this noise manageable
> ##### The Solution
> - **Sparse Autoencoders (SAEs)** 
> 	- We use SAEs to `unpack` the superposition ➝ taking the compressed signal ➝ expanding it back out into a clean monosemantic dictionary 

> [[Conceptual-Superposition-MI-LLMs]] | [[Conceptual-PolySemanticity-MonoSemanticity-MI]] | [[Conceptual-Sparsity-MI]] | [[Conceptual-Sparse-Auto-Encoders-SAE-MI]]
> #llm-sparse-auto-encoders-sae | #llm-polysemanticity | #mechanistic-interpretability-polysemnaticity | #llm-monosemanicity | #mechanistic-interpretability-monosemanicity 

#### III. MI: LMMs & LLMOps 

> [!example] **LLMs & LLMOps** 
> - **LLMs ➝ Mechanistic Interpretability** ➝ The Science
>     - This is where we study the `anatomy` of the model
>     - **SAEs live here** because they are a tool for `understanding` how the neural network thinks 
>     - We are using them to 
> 	    - map the brain 
> 	    - discover features
> 	    - and prove theorems about superposition
> 	  - We aren't `operating` anything yet ➝ we  are dissecting
>     - `Analogy` 
> 	    - This is like using a microscope to find a virus
>---         
> - **LLMOps ➝ Interpretability** ➝ The Engineering
>     - This is where  apply that understanding to `production`
>     - **Monitoring Tools live here** 
>     - If  take the trained SAE and put it in a server to flag `Toxic Features` in real-time for customers ➝ `that` specific deployment is LLMOps
>     - `Analogy` 
> 	    - This is like building a fever scanner at an airport

#### IV. The Interpretability Stack

> There are **9 critical concepts** in mechanistic interpretability

> - They establish a **unified framework** for **how** LLMs 
> 	- **store**
> 	- **process** 
> 	- and occasionally **mishandle information**

> - These phenomena can be **derived** from **2 fundamental physical constraints**
> 	- the **Information Bottleneck**  
> 		- indicative of limited dimensions
> 	- the **Optimization Pressure** 
> 		- forceful next-token prediction

> #llm-information-bottleneck | #llm-optimization-pressure 

| **Layer**     | **Concept**          | **Axiom**             | **The `Human` Analogy**                                               |
| ------------- | -------------------- | --------------------- | --------------------------------------------------------------------- |
| **Storage**   | **Superposition**    | Johnson-Lindenstrauss | Storing 5 files on a 2GB drive using compression                      |
| **Storage**   | **Privileged Basis** | Non-Linearity         | The few files you keep unzipped on your desktop                       |
| Circuit       | Induction Heads      | Pattern Matching      | Using `Ctrl+C / Ctrl+V` to write an essay                             |
| Circuit       | Binding Problem      | Vector Addition       | Confusing `Red Car` with `Red Apple` in a blurry photo                |
| **Pathology** | **Sycophancy**       | Reward Hacking        | A `Yes Man` employee who fears being fired                            |
| **Pathology** | **Confabulation**    | Manifold Continuity   | A smooth talker who lies to keep the conversation flowing             |
| Tool          | SAE                  | Dictionary Learning   | A prism splitting white light (activations) into a rainbow (features) |
| Tool          | ROME/MEMIT           | Key-Value Pairs       | Brain surgery to surgically alter a specific memory                   |

---
### 2. The Storage Crisis: How to Pack the Universe

>- The fundamental constraint of an LLM ➝ is that it **knows more concepts** ($N$) ➝ than it **has neurons** ($d$)
>- This **discrepancy** ($N \gg d$) ➝ forces the model to ➝ invent **exotic geometric solutions**

#### I. Superposition & Polysemanticity

> [[Conceptual-Superposition-MI-LLMs]] | [[Conceptual-PolySemanticity-MonoSemanticity-MI]] | #mechanistic-interpretability-superposition | #mechanistic-interpretability-superposition | #llm-polysemanticity | #mechanistic-interpretability-polysemnaticity 

##### I. First Principles

- The **Johnson-Lindenstrauss** Lemma
- In high-dimensional Euclidean space 
	- there are **exponentially** many **directions**
	- that are `nearly` **orthogonal**

###### I. The Details: Johnson-Lindenstrauss Lemma

> If we want to understand why neural networks can be so small yet know so much ➝ the Johnson-Lindenstrauss (JL) Lemma is the first principle we must master

> #llm-first-principles | #johnson-lindestrauss

> - We have to completely discard our human intuition about space
> - We live in 3 dimensions ➝ which makes us terribly unequipped to visualize ➝ what happens to geometry when dimensions scale into the thousands

> The physical geometry of what `nearly orthogonal` means across different dimensions:

- **In 2D Space** ➝ A piece of paper
	- We can draw **exactly two lines** that are **perfectly orthogonal** ➝ 90 degrees to each other ➝ like the X and Y axes
	- If we relax the rules and say:  `I will accept any lines that are between 85 and 95 degrees to each other`
		- we can still **only squeeze in a handful of lines** ➝ before they start crowding each other and violating that rule
    
- **In 3D Space** ➝ A room
	- We have **three perfectly orthogonal lines** ➝ X, Y, and Z
	- If we **relax the rule** to 85–95 degrees
		- we can fit a few more vectors ➝ like porcupine quills sticking out of a center point ➝ but the **space fills up very quickly**
    
- **In High-Dimensional Space** ➝ example: $d = 4096$
	- The geometry fundamentally breaks our intuition 
	- The **volume** of the space and the **surface area** of a **hypersphere** ➝ **expand** so **aggressively** 
		- that the `equator` of the sphere ➝ relative to any random point ➝ becomes massive
	- If we pick one random vector in a 4,096-dimensional space
		- and then **randomly** draw another vector 
		- the mathematical **probability** ➝ that the **second vector** is ➝ nearly 90 degrees to the first one ➝ approaches 100%
	- Because **almost all the volume** of a high-dimensional sphere is ➝ **concentrated** near its **equator** 
		- we can pack an **exponentially large number of vectors** into this space ➝  such that `every single one of them` is **nearly 90 degrees** to **all** the others

> #llm-activation-space-stream | [[Conceptual-Activation-Space-Level-The-Geometry-of-Machine-Thought]] | #llm-residual-stream-additive-shared-communication-channel | #llm-residual-stream-additive-shared-communication-channel 
> [[Conceptual-Residual-Stream-Geometric-Manifold]] | [[Conceptual-Residual-Stream-Geometric-Mechanistic]] | #llm-orthogonality | #llm-higher-dimension-space | #llm-higher-dimension-space

###### II. The Formal Mathematics: The JL Lemma Corollary

> - The Johnson-Lindenstrauss Lemma is formally ➝ a **theorem** about **dimensionality reduction**
> - It states that we can **embed** $N$ points **from** a very high-dimensional space ➝ **into** a much lower-dimensional space of dimension $d$ 
> 	- while **preserving** the **pairwise distances** between all points **within a small error margin** of $1 \pm \epsilon$

$$d = O \left( \frac{\log N}{\epsilon^2} \right)$$

> - For Mechanistic Interpretability ➝ we flip this equation around ➝ to **calculate capacity** 
> - If we have a **residual stream** of dimension $d$ 
> 	- how **many feature vectors** $N$ can **we pack** into it 
> 	- such that **their maximum interference** ➝ their cosine similarity or dot product 
> 	- is **bounded** by **a tiny noise factor** $\epsilon$?

> - Solving for $N$ ➝ we get an exponential relationship:
$$N \sim \exp(c \epsilon^2 d)$$

where $c$ is a mathematical constant

> - This equation is the holy grail of model capacity
> - It proves mathematically that ➝ the number of `nearly orthogonal` directions ➝ $N$ ➝ grows exponentially 
> 	i.  as we **increase** the **dimensions** ($d$) 
> 	ii. or as we **allow** a **slightly higher noise tolerance** ($\epsilon$)

###### III. The Direct Connection to MI

> This lemma is the exact reason why **Superposition** is `mathematically possible` ➝ it is why LLMs actually work

- **The Problem** 
	- A model like a 7B parameter LLM might have a residual stream dimension of $d = 4096$ 
	- However the true number of features in human language ➝ syntax + facts + logic rules ➝  is $N = 10,000,000$
    
- **The Impossibility of Perfection** 
	- If the model demanded that **every feature be perfectly independent** ➝ perfectly orthogonal ➝ dot product = 0
		- it would hit maximum capacity at exactly 4,096 features 
	- It would be mathematically blind to the remaining 9,995,904 concepts
    
- **The JL Solution** 
	- `Gradient descent discovers the Johnson-Lindenstrauss Lemma naturally `
	- The loss landscape ➝ **forces** the model **to realize** 
		- that if it **accepts** a tiny bit of interference ($\epsilon \approx 0.05$) ➝ it doesn't just gain a few more slots 
	- Thanks to the **exponential scaling** in the JL Lemma ➝  a 4,096-dimensional space can suddenly ➝  hold millions of feature vectors
	- The model assigns each of the 10 million concepts ➝ to **one** of these **nearly orthogonal directions** 
	- When it processes a token ➝ it activates the necessary vectors
	- Because the vectors are `nearly` orthogonal ➝ they don't catastrophically interfere with each other 
	- The $\epsilon$ interference ➝ acts as a low-level static buzz ➝ in the background of the residual stream

> `nearly orthogonal` ➝ is the key 

> #mechanistic-interpretability-superposition | #mechanistic-interpretability-superposition  | [[Conceptual-Superposition-MI-LLMs]] | #llm-residual-stream-additive-shared-communication-channel | [[Conceptual-Gradient-Descent-The-Geometric-Perspective]] | #gradient-descent | #llm-higher-dimension-space 

##### II. The Concepts

###### I. Superposition 

- The model stores features not as individual neurons ➝ but as `directions`  ➝ vectors
- Because it **runs out of orthogonal axes** (X, Y, Z) ➝ it starts using `in-between` angles

> #mechanistic-interpretability-superposition | #mechanistic-interpretability-superposition | [[Conceptual-Superposition-MI-LLMs]]

###### II. Polysemanticity 

- As a result ➝ a single neuron ➝ hardware ➝ participates in multiple feature vectors ➝ software
- Neuron #402 ➝ might **fire for both** `DNA Helix` and `Traffic Lights` ➝ because **those two feature vectors happen to intersect at that neuron**   

> #llm-polysemanticity | #mechanistic-interpretability-polysemnaticity | [[Conceptual-PolySemanticity-MonoSemanticity-MI]]

###### III. The Axiom of Interference
    $$Activation = \text{Signal} + \text{Interference}$$

> The model ➝ **accepts a small amount of `noise`** ➝ crosstalk between DNA + Traffic Lights ➝ as the **price for storing both**
    
###### IV. Visualizing the Geometry

> - Imagine trying to fit 5 sticks ➝ **features** ➝ into a 2D box ➝ **neurons** ➝ so they are **as far apart as possible**
> - They **don't form a cross (+)** ➝  they form a **Pentagon**

#### II. The Privileged Basis

##### I. First Principles

> Rotation Invariance vs. Non-Linearity

##### II. The Concept

###### I. Rotation Invariance

- In the `Residual Stream` ➝ the highway between layers ➝ can **rotate the entire vector space** ➝ and the **math** still **holds**
- There is no `up` or `down`    

> #llm-residual-stream-additive-shared-communication-channel | #llm-residual-stream-additive-shared-communication-channel | [[Conceptual-Residual-Stream-Geometric-Mechanistic]] | [[Conceptual-Residual-Stream-Geometric-Manifold]]
> [[Conceptual-Drifts-in-LLMOps-Architectural-Journey]]

###### II. The Privileged Basis

- However, the **Activation Function** ➝ ReLU/GELU ➝ is the ➝  `Privileged Basis` 
- It **applies a threshold** ➝ $x > 0$ ➝ to **specific individual neurons**

###### III. The Conflict 

- Features `want` to align with the Privileged Basis  ➝ individual neurons ➝ to be processed cleanly
	- But Superposition `forces` them off-axis
	- This tension creates an observable messy **polysemantic** web

> #mechanistic-interpretability-superposition | #mechanistic-interpretability-superposition | [[Conceptual-Superposition-MI-LLMs]]

#### III. The Binding Problem

##### I. First Principles

>  Vector Addition ➝ **destroys structural information**

##### II. The Concept

- If the model **represents a scene** by **adding vectors**
    $$V_{scene} = V_{red} + V_{square} + V_{blue} + V_{circle}$$
- It mathematically **cannot distinguish** between a **Red Square + Blue Circle** and a **Red Circle + Blue Square**
- The **sum** is **identical**
    
##### III. The Solution 

- The model likely uses specific **Attention Heads** ➝ to move attribute information **into** a specific `Object Subspace` 
- Or uses **frequency-based binding** ➝ like **RoPE** ➝ to **tag features with positional information** ➝ effectively `gluing` Red to Square ➝ **before the addition happens**

> [[Conceptual-Attention-Heads-MI]] | [[RoPE-LIME-RoPE-Space-Locality-Sparse-K-Sampling-for-Efficient-LLM-Attribution]] | [[RoFormer-Enhanced-Transformer-with-Rotary-Position-Embedding]]

---
### 3. The Computation Engine: Moving Information

>- Once information is stored ➝ **how does the model** `think`?
>- It uses **specific circuits** ➝ to **move information across time**

#### I. Induction Heads: The Copy-Paste Mechanism

##### I. First Principles

> Pattern Matching is the basis of Intelligence
    
##### II. The Concept
    
- Induction Heads are the `Ctrl+C, Ctrl+V` of the LLM
- They are responsible for the majority of In-Context Learning ➝ **ICL**

> #llm-in-context-memory
    
##### III. The Mechanism: The 2-Step Circuit

 1. **The Detective** ➝ Head 1
	- Scans the past 
	- `I see token [A] currently. Where did I see [A] before?`
        
    2. **The Copier** ➝ Head 2 
	- Looks at what came `after` the previous [A] ➝ which was [B] 
		- and increases the probability of [B] happening now

> #mechanistic-interpretability-attention-heads  | [[Conceptual-Attention-Heads-MI]] | #llm-self-attention 

##### IV. Visualizing the Circuit

![[Pasted image 20260213023427.png | 500]]
    
#### II. Circuit Analysis

##### I. First Principles 

> Modularity
    
##### II. The Concept
    
- We can reverse-engineer the `Neural Soup` into a ➝ legible **Computation Graph**
- Instead of saying `Layer 4 did it` ➝ we say `The Indirect Object Identification (IOI) Circuit did it` 

##### III. The Method: Circuit Analysis

> - A circuit consists of:
>     - **Previous Token Heads** ➝  Look at the last word
>     - **Induction Heads**  ➝ Look at the pattern
>     - **Inhibition Heads** ➝  Suppress wrong answers
>     - **Name Mover Heads** ➝  Output the correct name

---
### 4. The Pathologies: When Geometry Fails

> When the **geometric organization** or the **circuits** **malfunction** ➝ we see specific `mental illnesses` in the model

#### I. Sycophancy

##### I. First Principles

> Reward Hacking
    
##### II. The Concept
    
- The model is trained on RLHF (Reinforcement Learning from Human Feedback). Often, humans rate `Agrees with me` higher than `Is objectively true.`
    
- **The Geometry:**
    
    There exists a **Sycophancy Vector** ($V_{syc}$) in the activation space.
    
    - When the User's Opinion conflicts with the Truth ($V_{truth}$), the model computes the dot product of both vectors against the potential output.
        
    - If $V_{syc}$ is stronger (due to RLHF), the model lies to please you.
        
- **Visualizing the Tug-of-War:**
    
    Plaintext
    
    ```
                 [User: `The Earth is flat, right?`]
                                 |
    (Truth Vector) <-------------+-------------> (Sycophancy Vector)
    `No, it's round.`                                `You are correct.`
    (Low Reward)                                     (High Reward)
    ```
    

#### **7. Hallucination vs. Confabulation**

- **First Principle:** _Manifold Validity._
    
- **The Distinction:**
    
    - **Hallucination (The `Off-Road` Error):**
        
        The model's internal state drifts _off the manifold_ of valid language. The resulting vector points to `nowhere` in semantic space. The output becomes nonsensical or random.
        
        - _Cause:_ High temperature or out-of-distribution input.
            
    - **Confabulation (The `Smooth` Lie):**
        
        The model stays firmly _on the manifold_ but follows the wrong path. It is driven by **Induction Heads** prioritizing _fluency_ and _consistency_ over factuality.
        
        - _Cause:_ The model knows the _shape_ of the answer (e.g., `A citation looks like [Author, Date]`), so it fills in the blanks to maintain the shape, even if the data is fake.
            

---

### **Part IV: The Surgical Tools (Fixing the Mind)**

How do we interact with these axioms to repair the model?

#### **8. Sparse Autoencoders (SAEs)**

- **First Principle:** _Dictionary Learning._
    
- **The Concept:**
    
    Since neurons are polysemantic (messy), we cannot `read` them directly. SAEs act as a **Microscope**.
    
    - We feed the messy activation vectors into an SAE with a **Sparsity Penalty**.
        
    - The SAE expands the compressed signal back into its original, vast number of features ($N$).
        
    - **Result:** We get `Monosemantic Features.` We can finally find the single switch for `Golden Gate Bridge` without triggering `Traffic Lights.`
        

#### **9. Model Editing (ROME / MEMIT)**

- **First Principle:** _The Key-Value Memory Hypothesis._
    
- **The Concept:**
    
    We assume the MLP (Feed-Forward) layers act as **Associative Memory** stores.
    
    - **Key ($k$):** The subject (`Eiffel Tower`).
        
    - **Value ($v$):** The attribute (`is in Paris`).
        
- **The Surgery:**
    
    - **ROME (Rank-One Model Editing):** We calculate exactly which weights matrix $W$ stores this pair. We perform a linear algebra operation (Rank-1 update) to rewrite $v$ so that `Eiffel Tower` $\to$ `Rome.`
        
    - **MEMIT:** A massive generalization of ROME. It spreads the edit across thousands of neurons in multiple layers to ensure the model doesn't `forget` other things (Catastrophic Forgetting) while accepting the new fact.
        

---

![[Pasted image 20260310044502.png]]