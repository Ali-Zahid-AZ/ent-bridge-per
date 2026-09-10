---
tags:
  - mechanistic-interpretability
  - llm-sparsity
  - llms-mixture-of-experts-moe
  - mechanistic-interpretability-superposition
  - llm-internal-memory
  - llm-interpretability
  - llm-residual-stream-additive-shared-communication-channel
  - conceptual-explanations
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

- [[Conceptual-Intertwined-Concepts-MI]]
  
---
> [!example] **The Dual Nature of Sparsity**
>-  Sparsity has to be looked at it through two completely different lenses 
>	- **Activation Sparsity** ➝ how concepts are stored
>	- **Network/Weight Sparsity** ➝ how computation is routed
>
>---
>
>- **Sparsity** is the mathematical principle 
>	- where only a **tiny fraction of a model's possible features** or parameters **activate** for **any given input** 
>	- reflecting the reality ➝ that most distinct concepts rarely co-occur
>- In Mechanistic Interpretability ➝ this strict bottleneck is the fundamental driver of 
>	- how **models compress knowledge** into activation spaces ➝ superposition
>	- how **advanced architectures route computation** ➝ MoEs
>
>---
>
>- **Sparse** ➝ Thinly dispersed or scattered 

> #llms-mixture-of-experts-moe | [[Conceptual-Mixture-of-Experts-MOE-MI]] | [[Conceptual-Intertwined-Concepts-MI]]
---
### 1. Layman Introduction 

> - Sparsity is the absolute bedrock of modern Mechanistic Interpretability 
> - When we analyze models at the weight and activation level 
> 	- we are moving away from high-level `black box` behavior 
> 	- looking directly at the **geometry of activation spaces** ➝ to see **how concepts are actually formed**

> - In the realm of MI ➝ `sparsity` ➝ dictates how models store and retrieve knowledge ➝ splitting into **2 distinct structural phenomena**
> 	- Activation Sparsity
> 	- Weight Sparsity

#### I. Activation Sparsity: The Geometry of Superposition

- This is the core of **feature representatio**n 
- A model might need to understand millions of distinct concepts ➝ features ➝ but it only has a few thousand dimensions in its residual stream
- Because these features are `sparse` ➝ they rarely co-occur in the exact same context
	- the model can mathematically compress ➝ them into a lower-dimensional manifold ➝ using superposition
- We use tools like Sparse Autoencoders (SAEs) to disentangle this manifold back into interpretable directions

> [[Conceptual-Residual-Stream-Geometric-Mechanistic]]
>[[Conceptual-Superposition-MI-LLMs]]  
> #mechanistic-interpretability-superposition | #mechanistic-interpretability-superposition | #llm-residual-stream-additive-shared-communication-channel 
>  #llm-sparsity-activation | #llm-sparsity-weight | #llm-sparsity 

#### II. Weight Sparsity: The Routing Logic

- This is the Mixture-of-Experts ➝ **MoE** ➝ approach 
- Instead of every token passing through every weight matrix ➝ the model selectively activates a sparse sub-network
- From a mechanistic perspective ➝ this forces us to map dynamic circuits ➝ as the computational path physically changes token-by-token

> #llms-mixture-of-experts-moe | #mechanistic-interpretability-reasoning-circuits | #mechanistic-interpretability-techniques | [[Conceptual-Mixture-of-Experts-MOE-MI]]

---
### 2. Detailed Explanations 

#### I. Activation Sparsity: the Geometry of Superposition

> - At the activation level ➝ we are looking at the residual stream of a transformer
> - We want to understand how a model represents a `feature` ➝ a fundamental concept, like the idea of a `golden retriever` or the syntax of a `Python for-loop`

##### I. The Intuition of Sparse Features & Sparsity 

- Imagine a master checklist containing every single concept, object, and property in the universe
	- from `photosynthesis` and `the color blue` to `Python syntax` and `Shakespearean tragedy`

- If we look at any single object or read any single sentence, how many boxes on that infinite checklist are actually ticked?
	- Only a tiny handful.

- If we are holding an apple ➝ the features `is a fruit,` `is red,` and `is edible` are active ➝ non-zero
- But the other 99.999% of the universe's features
	- like `is made of metal,` `is a prime number,` or `compiles to C++`
	- are completely irrelevant 
- Their value is exactly zero.

> - **The MI Takeaway** 
> 	- Because the real world is built this way ➝ information is **strictly sparse** 
> 	- At any given microsecond ➝ almost everything is a zero 
> 	- Neural networks implicitly learn this 
> 	- They realize they don't need a dedicated permanent dimension for `prime numbers` and `edible fruit` 
> 		- because those two features will almost never need to activate at the exact same time 
> 	- This is the **physical reality** ➝ that allows them to **safely compress millions of concepts** into a small number of dimensions using superposition

##### II. The Capacity Problem

> - A language model has a **fixed number of dimensions** in its hidden state ➝  $N$ 
> - However ➝ the **number of distinct features** it needs to **understand** the world ➝ $M$ ➝ is vastly larger than $N$ 
> - Mathematically, $M \gg N$

> #mechanistic-interpretability-features | #mechanistic-interpretability-features | #mechanistic-interpretability-features 

##### III. The First Principle of Activation Sparsity

> - Features in the real world are strictly `sparse`
> - If we are reading a paragraph about Quantum Physics ➝ the features for `Shakespearean tragedy` or `cake recipes` are completely inactive ➝ zero
> - Because most features are **mutually exclusive in a given context** ➝  the model does **not** need a **dedicated orthogonal dimension** ➝ for **every single feature**
    
##### IV. Superposition 

- Because features are sparsely activated ➝ models learn ➝ to pack them into the **latent space** ➝ using **non-orthogonal vectors** 
- This is called **Superposition** 
- The model compresses $M$ features into $N$ dimensions by tolerating a small amount of `interference` or noise between concepts
    
> [[Conceptual-Superposition-MI-LLMs]] | #mechanistic-interpretability-superposition | #mechanistic-interpretability-superposition | [[Conceptual-Intertwined-Concepts-MI]]

##### V. The MI Solution: SAEs

- Because features are in superposition ➝ individual neurons become `polysemantic` ➝ they fire for multiple + unrelated concepts
- To fix this ➝ researchers use ➝ **Sparse Autoencoders** 
- An SAE takes the **dense superposed activations** of a model ➝ **maps** them into a **much larger higher-dimensional space** 
- By **enforcing** an ➝ $L_{1}$ **penalty**  +  a **Top-K** activation function ➝ during the SAE's training
	- it **forces the network** ➝ to **represent** the data ➝ as a **sparse linear combination of features**:
$$x \approx \sum_{i=1}^{M} a_{i} f_{i}$$

- where
	- $x$ is the **model activation** 
	- $f_{i}$ are the learned dictionary vectors ➝ the true features 
	- and $a_{i}$ are the sparse feature activations ➝ mostly zeros

> [[Conceptual-Sparse-Auto-Encoders-SAE-MI]] | #mechanistic-interpretability-sae | #llm-sparse-auto-encoders-sae | #llm-higher-dimension-space | #llm-polysemanticity | #mechanistic-interpretability-polysemnaticity | [[Conceptual-Intertwined-Concepts-MI]]

##### VI. Citations 

> - [[Anthropic-Toy-Models-of-Superposition-Main]] 
> 	- The foundational paper defining how and why models use activation sparsity to pack features into superposition
> - [[Anthropic-Towards-Monosemanticity-Decomposing-Language-Models-with-Dictionary-Learning]]  
> 	- The breakthrough paper demonstrating that Sparse Autoencoders can successfully extract monosemantic ➝ interpretable ➝  features from a language model
  
#### II. Network + Weight Sparsity: Circuit Discovery

> While activation sparsity deals with `what` the model is thinking about ➝ network and weight sparsity deal ➝ with `how` the computation **physically flows** through the weights

##### I. Dense Entanglement

> - In a standard dense transformer ➝ every token passes through every single weight matrix 
> - This makes finding `Circuits` ➝ minimal subgraphs of the network responsible for specific behaviors ➝ like Induction Heads
> 	- incredibly difficult 
> 	- because every weight contributes a tiny fraction to the output

> #mechanistic-interpretability-attention-heads  | [[Conceptual-Attention-Heads-MI]]

##### II. Weight-Sparse Transformers  

> Recent MI research has **started training models** with strict **mathematical constraints** on their **weights** ➝  forcing the vast majority of connections to be exactly zero
    
##### III. The Result 

> - When we force a model to be **weight-sparse** from the beginning
> 	- it can no longer **rely** on ➝ dense messy entanglement
> - It is forced to build highly structured human-understandable circuits 
> - By pruning away the `noise` ➝ the actual logical pathways 
> 	- example ➝ how the model moves the subject of a sentence to the end of a sentence
> - become mathematically visible
    
##### IV. Citations 

> - arXiv ➝ [arXiv: Weight-sparse transformers have interpretable circuits](https://arxiv.org/abs/2511.13653)
> - [[Weight-Sparse-Transformers-have-Interpretable-Circuits]]
> - Demonstrates that training models with extreme weight sparsity 
> 	- example ➝ 1 in 1000 weights being non-zero
> - naturally yields highly interpretable causal graphs

---
### 3. Mixture of Experts (MoE) as Intrinsic Sparsity

> - The frontier of modern architectures like DeepSeek, Mixtral, and Kimi ➝ the Mixture of Experts 
> - MoEs are the ultimate marriage of **scaling laws** and **sparsity**

> #llm-sparsity-routing 

#### I. Routing Sparsity 

- Instead of passing a token through a massive dense Multi-Layer Perceptron (MLP) 
	- an MoE ➝ uses a router to send the token to only 1 or 2 small `expert` networks ➝ out of dozens or hundreds

> [[Conceptual-Multi-Layer-Perceptron-Feed-Forward-Networks-MLP-FNN-MI]] | [[Conceptual-Mixture-of-Experts-MOE-MI]] | #llm-architecture-layer-multi-layer-perceptron-mlp | #llms-mixture-of-experts-moe | [[Conceptual-Intertwined-Concepts-MI]]

#### II. The MI Perspective on MoEs

- From an interpretability standpoint ➝ MoEs are fundamentally different from dense models 
- Because an MoE model has **Network Sparsity** ➝ only activating a fraction of its total parameters per token
	- it does not have to rely as heavily on Superposition

#### III. Expert Specialization

- Recent studies show that MoEs can afford to ➝ dedicate entire experts ➝ to specific feature combinations
- Instead of packing sparse features into shared neurons ➝ which creates `polysemanticity `
	- the router learns to naturally cluster concepts
- This makes MoE architectures natively ➝ more `monosemantic` at the expert level ➝ than dense models of the same active parameter count

| #llm-polysemanticity | #mechanistic-interpretability-polysemnaticity | #llm-monosemanicity | [[Conceptual-PolySemanticity-MonoSemanticity-MI]]

#### IV. Citations

> - arXiv ➝ [arXiv: Mixture of Experts Made Intrinsically Interpretable](https://arxiv.org/abs/2503.07639)
> 	- [[Mixture-of-Experts-Made-Intrinsically-Interpretable]]
> 	- Establishes the mathematical connection that an MoE layer is essentially equivalent to a massive, highly sparse MLP + shows how sparsity-aware routing enhances interpretability
>- arXiv ➝ [arXiv: Sparsity and Superposition in Mixture of Experts](https://arxiv.org/abs/2510.23671)
>	- [[Sparsity-and-Superposition-in-Mixture-of-Experts]]
> 	- Explores how MoEs experience less superposition than dense models because network sparsity allows them to cleanly separate semantic features

#### V. Summary 

- **Activation Sparsity** 
	- Features are sparse in reality $\rightarrow$ Models use Superposition to compress them $\rightarrow$ We use SAEs to decompress them
    
- **Weight Sparsity** 
	- Dense weights hide circuits $\rightarrow$ Forcing zero-weights during training $\rightarrow$ Reveals clean, causal computational graphs
    
- **MoE Sparsity** 
	-  Routing tokens to specific experts $\rightarrow$ Reduces the need for superposition $\rightarrow$ Creates intrinsic, structural interpretability

#### VI. Schematic: Courtesy Gemini 

![[Pasted image 20260309030700.png | 800]]

---
### 4. How did NN inherently learn Sparsity for Information Storage 

> - This behavior is entirely an **emergent property**
> - It is the natural result of 
> 	- **mathematical optimization** ➝ Gradient Descent 
> 	- colliding with a **physical constraint** ➝ the model's dimensional capacity

> #llm-emergent-properties | #gradient-descent | #llm-higher-dimension-space 
> [[Conceptual-Emergent-Properties-in-LLMs]]  
> [[Conceptual-Gradient-Descent-The-Geometric-Perspective]]

#### I. The Bottleneck vs. The Loss Function

> - During training ➝ the model has only one goal ➝ minimize the cross-entropy loss ➝ predict the next token accurately
> - To do this perfectly ➝ it realizes it needs to track millions of distinct concepts ➝ features ➝ from the training data

> #mechanistic-interpretability-features | #mechanistic-interpretability-features | [[Conceptual-Features-MI]]

- However the model hits a hard physical wall ➝ its residual stream only has a few thousand dimensions ➝ let's say $N=4096$
- If it assigns a perfectly orthogonal ➝ independent ➝ dimension to every single feature ➝ it will run out of space almost instantly 
- If it simply ignores the remaining features ➝ it won't be able to predict the next token accurately ➝  and its loss will remain high

#### II. Gradient Descent Discovers the Hack

> - Gradient descent is essentially water flowing down a mountain ➝ looking for the lowest possible point ➝ the lowest loss
> - When it encounters this dimension bottleneck ➝ it discovers a mathematical compromise:
		- Instead of using perfect 90-degree orthogonal vectors for every feature
			- the model starts assigning features to vectors that are ➝ for example ➝ 85 degrees apart
> - This allows the model to pack far more than $4096$ features into a $4096$-dimensional space

#### III. Why Sparsity Makes the Hack Work

- If we pack vectors closely together ➝ non-orthogonal ➝ they cause ➝ `interference` or noise with each other
- If two closely packed features are active at the `exact same time` ➝ the model gets confused ➝ makes a bad prediction ➝ and the loss shoots up

- But gradient descent learns from the data that ➝ the real world is **sparse** 
- It realizes ➝  `Concept A `(Quantum Physics) and `Concept B` (Cake Recipes) ➝ almost never appear in the same paragraph
- Because they never activate together ➝ the model realizes it can safely map them to nearly the exact same space in the residual stream 
- The network mathematically calculates that ➝ the tiny penalty of occasional interference is far smaller than the massive penalty of completely forgetting a concept

---
### 5. Citations

- This exact phenomenon was proven in [[Anthropic-Toy-Models-of-Superposition-Main]]
- They trained a tiny simple neural network on artificially generated data where they controlled how `sparse` the features were
- They proved that as soon as features become sparse enough
	- the network will spontaneously stop assigning them dedicated dimensions 
	- and will spontaneously start packing them into superposition to lower its loss

>- The network doesn't `know` it's doing this 
>- It is just blindly following the gradient to lower its error rate
>	- and the geometry of superposition happens to be the mathematically optimal shape for a sparse universe

---
### 6. Tabular Concepts 

| **Category**                        | **Term**                                       | **The Intuition**                                                                                                               | **First Principles**                                                                                                                                                                                     |
| ----------------------------------- | ---------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **The Architecture of the Mind**    | **Residual Stream**                            | The central highway or spinal cord of the model                                                                                 | - The main vector path moving layer-by-layer through the Transformer<br>- Attention heads and FFNs read from it, compute updates, and add those updates back into the stream                             |
|                                     | **Neurons vs. Features**                       | Hardware vs. Concepts                                                                                                           | - `Neurons` are the physical computational axes built into the matrix<br>- `Features` are the true fundamental variables of the dataset (concepts) that exist as vectors across multiple neurons         |
| **The Geometry of Concept Storage** | **Superposition (Activation Sparsity)**        | Packing 10,000 items into a 4,000-slot box by overlapping them at slight angles so they don't perfectly collide                 | The mathematical phenomenon where a network represents more features ($N$) than dimensions ($d$) by assigning them to _almost-orthogonal_ directions, accepting slight interference to maximize capacity |
|                                     | **Polysemanticity**                            | A single dashboard gauge that randomly twitches for speed, engine temperature, and radio volume all at once                     | When a single neuron fires for multiple unrelated concepts. This is the direct, observable symptom of Superposition, making single neurons uninterpretable                                               |
|                                     | **Monosemanticity**                            | One dial, one single job                                                                                                        | A vector or direction in the activation space that corresponds strictly to one human-interpretable concept without interference from others. Finding these is the goal of MI                             |
| **The Tools of the Trade**          | **Sparse Autoencoder (SAE)**                   | A mathematical prism that takes white light (dense, tangled concepts) and refracts it into distinct, pure colors                | A secondary network trained on activations that projects the dense stream into a higher-dimensional space. An $L_1$ penalty forces it to find sparse, monosemantic directions, untangling superposition  |
| **The Physical Engineering**        | **Weight Sparsity (Mixture of Experts / MoE)** | A corporate router that sends a legal question only to the two lawyers on staff, rather than making all 1,000 employees read it | An architecture replacing dense FFNs with multiple sub-networks (experts). A routing algorithm dynamically selects active parameters per-token, decoupling knowledge capacity from active compute cost   |

---
