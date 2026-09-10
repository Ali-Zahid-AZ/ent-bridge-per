---
tags:
  - mechanistic-interpretability
  - mechanistic-interpretability-reasoning-circuits
  - mechanistic-interpretability-attention-heads
  - llm-architectures
  - llm-internal-memory
  - llm-interpretability
  - conceptual-explanations
  - llm-attention-mechanism
  - llm-self-attention
  - note-finalized
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

- [[Anthropic-A-Mathematical-Framework-for-Transformer-Circuits-Main]]
- [[Anthropic-In-Context-Learning-and-Induction-Heads]]
- [[A-Primer-on-the-Inner-Workings-of-Transformer-based-Language-Models]]
- [[A-Practical-Review-of-Mechanistic-Interpretability-for-Transformer-Based-Language-Models]]

- [[Conceptual-Residual-Stream-Geometric-Manifold]]
- [[Conceptual-Residual-Stream-Geometric-Mechanistic]]
- [[Conceptual-Intertwined-Concepts-MI]]
- [[Conceptual-Basics-Anatomy-of-Compute-Feature-Manifolds-Circuit-Topologies]]
- [[Conceptual-Dot-Product-Intuition-LLMs]]
   
---

> - To understand an attention head from a first-principles mechanistic perspective ➝ abandon the `black box` analogy of a model `paying attention` to words

> - Instead, consider the residual stream ➝ the 768-dimensional manifold ➝ as a **continuous communication bus** 
> - An **attention head** is simply an ➝ **independent read-write operation** that ➝ **moves specific geometric features** ➝ from one token's **position** on that bus to another

> [[Conceptual-Tokens]] | [[Conceptual-Residual-Stream-Geometric-Mechanistic]] | [[Conceptual-Residual-Stream-Geometric-Manifold]] | #llm-residual-stream-additive-shared-communication-channel | #llm-residual-stream-additive-shared-communication-channel | #llmops-tokenization-tokens | [[Conceptual-Tokens]]

---
### 1. The Anatomy of an Attention Head

> - Every attention head is composed of ➝ **2** `distinct` + `low-rank` ➝ **linear circuits** 
> 	- The `QK` Circuit 
> 	- The `OV` Circuit
> - They operate **entirely independently** of one another

> - [[Conceptual-Intertwined-Concepts-MI]]
> - [[Conceptual-Dot-Product-Intuition-LLMs]]
> - [[Conceptual-Basics-Anatomy-of-Compute-Feature-Manifolds-Circuit-Topologies]]
> - [[A-Primer-on-the-Inner-Workings-of-Transformer-based-Language-Models]]
> - [[A-Practical-Review-of-Mechanistic-Interpretability-for-Transformer-Based-Language-Models]]

#### I. The QK Circuit ➝ The Routing Mechanism

- This circuit determines ➝ **where** `information` should move
- It is composed of **2 weight matrices**

##### I. Query $W_{Q}$: The Query Weight Matrix

- `What feature am I looking for?`
- Maps the destination token's residual stream into the query space 
- This matrix isolates and projects the specific features that represent: `What information does this current token need to extract from the context?`

##### II. Key $W_{K}$:  Key Weight Matrix

- `What feature do I have?`
- Maps the source token's residual stream into the key space 
- This matrix isolates and projects the specific features that represent: `What information does this past token contain that might be useful to others?`
    
> - The **head** ➝ **multiplies** the current token's vector by $W_{Q}$ ➝ and compares it ➝ via a dot product ➝ against the $W_{K}$ vectors ➝ of **all previous tokens** 
> - A high score creates an open channel between those two positions
    
#### II. The OV Circuit  ➝ The Payload Mechanism

> - This circuit determines **what** information to move through that open channel
> - It also uses **2 matrices**

##### I. Value $W_{V}$

> Extracts the `specific feature` from the **source token**
    
##### II. Output $W_{O}$ 

> - Projects that extracted feature back into the 768-dimensional geometry of the residual stream at the destination token's position

> In circuit analysis, we rarely look at $W_Q$ or $W_K$ in isolation ➝ because they **operate sequentially** to form a **single bilinear operator**

- When we want to determine how strongly a destination token (using its query) attends to a source token (using its key) ➝ we calculate their **inner product**
- This interaction is governed by the combined **Query-Key matrix** ➝  denoted as $W_{QK}$

The **mathematical relationship** is:
$$W_{QK} = W_Q W_K^T$$

The **attention score** between a destination token $x_i$ and a source token $x_j$ is simply the bilinear form calculating how well the `What am I looking for?` vector aligns with the `What feature do I have?` vector:
$$Score = x_i^T W_{QK} x_j$$
---
### 2. The Mechanical Example: Pronoun Resolution

Consider the following sentence 

> `Alice traveled to Paris. **She** found it beautiful`

> We want to understand what happens mechanically when the **model is processing** the **token** `She`

#### I. Step 1: The Broadcast ➝ Query

At the position of the token `She` ➝ a specific attention head (let's call it the `Pronoun Resolution Head` ➝ reads the residual stream
It multiplies the `She` vector by its $W_{Q}$ matrix
This generates a Query vector pointing in a specific direction that mathematically represents ➝ ``Find a female entity``

#### II. Step 2: The Match ➝ Key

> All preceding tokens have already been multiplied by the head's $W`K$ matrix

- The token `Paris` generates a **Key vector** pointing toward ➝ `Geographic Entity`
- The token `Alice` generates a **Key vector** pointing toward ➝ `Female Entity`
    
> - The **dot product** between the Query for `She` and the Key for `Alice` yields a massive spike
> - An **information channel** is instantly **opened** from `Alice` to `She`
    
#### III. Step 3: The Extraction ➝ Value

- Now that the channel is open ➝ the head needs to move data
- It does `not` move the whole `Alice` vector
- Instead ➝ it multiplies the `Alice` vector by the $W_{V}$ matrix 
- This extracts only the specific sub-features needed
	- example ➝ her grammatical gender, singularity, and perhaps her name's specific token ID

#### IV. Step 4: The Write Operation ➝ Output

- Finally, the head ➝ **multiplies** that **extracted Value vector** by the $W_{O}$ matrix 
- This mathematically aligns the payload with the 768-dimensional residual stream and adds it directly into the vector sitting at the `She` position

#### V. The Result

- Before this head activated ➝ the vector at `She` was just a generic pronoun
- After this head writes to the residual stream ➝ the vector at `She` has been geometrically shifted
- It now physically contains the contextual features of `Alice`

> This is how an LLM builds context ➝ layer by layer ➝ dozens of heads are **simultaneously reading from the past** + **writing geometric updates** into the present token


---
