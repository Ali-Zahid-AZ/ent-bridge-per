---
tags:
  - large-language-models-LLMs
  - large-reasoning-models-LRMs
  - conceptual-explanations
  - llm-fundamentals
  - lrm-basics
  - llm-attention-mechanism
  - llm-mechanistic-architectural
  - llm-foundational-texts
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

- [[Attention-Is-All-You-Need-Vaswani]]
- [[Conceptual-Intertwined-Concepts-MI]]
- [[Conceptual-Attention-Heads-MI]]
- [[Conceptual-Dot-Product-Intuition-LLMs]]
- [[Conceptual-Basics-Anatomy-of-Compute-Feature-Manifolds-Circuit-Topologies]]
- 

- [Large Language Models explained briefly-YouTube](https://youtu.be/LPZh9BOjkQshttps://youtu.be/wjZofJX0v4Mhttps://youtu.be/eMlx5fFNoYchttps://youtu.be/9-Jl0dxWQs8)
- [Transformers, the tech behind LLMs-YouTube](https://youtu.be/wjZofJX0v4M)
- [Attention in transformers, step-by-step-YouTube](https://youtu.be/eMlx5fFNoYc)
- [How might LLMs store facts-YouTube](https://youtu.be/9-Jl0dxWQs8)
  
---

> [!example] Dissecting the **LLMs architecture** ➝ **mechanistically** focusing on 
> 	- arrays 
> 	- matrices
> 	- vectors
> 	- linear transformations

---
### 1. Phases of a LLM

#### I. Phase 1: The Untrained Blank Slate ➝ Untrained LLM

> - Consider an `untrained LLM` sitting on a server 
> - At this stage ➝ it does **not** know English, math, or logic
> - **Architecturally** ➝ it is just a **massive collection of multi-dimensional arrays** ➝ matrices ➝ filled entirely with **random floating-point numbers** 
> - These numbers ➝ **weights** or **parameters**.

> - If we feed text into this **untrained network** ➝ it will perform **billions** of `matrix multiplications` ➝ and `output` ➝ **complete garbage** 
> - The architecture is there ➝ but the `knowledge` is not 
> - The entire `goal of training` is ➝ to **systematically adjust** ➝ these **random floats** until the network `performs` a single specific task ➝ **next-token prediction**

> - An LLM is fundamentally a `function`
> 	- it takes an array of inputs
> 	- runs them through these **weight matrices** 
> 	- and `outputs` a **probability distribution** for what the next element in the array should be

---
#### II. Phase 2: Representing Information ➝ Tokenization & Embeddings

> - Matrix multiplication requires ➝ **numbers** ➝ not letters 
> - To feed text into the architecture ➝  we have to **translate words** ➝ into a **mathematical format**

##### I. Tokenization

> - First ➝ we chop the **input text** ➝ into **discrete chunks** ➝ called `Tokens`
> 	- **Tokens** ➝ characters + syllables + words 
> 	- `Hamburger` might become [`Ham`, `bur`, `ger`] 
> - Each token is assigned ➝ a **unique integer ID** from a `fixed vocabulary` ➝ like an **index** in an **array**

> #llmops-tokenization-tokens | [[Conceptual-Tokens]]

##### II. Here is why that infinite nature is both the model's greatest superpower and an interpretability nightmare:

1. The Power of Angular Infinity (The Manifold)
Because the space is continuous, the model doesn't just use orthogonal (perfectly 90-degree) axes to store facts. As you pointed out with the angles, it uses the infinite space between the axes.

In extremely high-dimensional spaces (like 4,096D), the geometry gets weird. The volume of a "hypersphere" expands so massively that you can generate millions of random vectors, and the angle between almost any two of them will naturally be hovering right around 89 to 91 degrees.

The model exploits this. It realizes, "If I don't demand perfect 90-degree independence, I can use an infinite combination of fractional angles to represent features." This is the geometrical mechanism behind Superposition. It packs a discrete concept into a continuous, fractional, tilted angle spread across hundreds of dimensions.

2. The Semantic Gradient
Because there are infinite points along these angles, concepts bleed into one another.

If you start at the exact coordinate for "Dog" and walk in a straight mathematical line toward the coordinate for "Cat," you aren't just moving through empty space. Every single microscopic decimal point along that vector pathway represents a valid, calculable concept to the model. You might pass through a coordinate that perfectly represents a "Fox," and then a coordinate that represents a "Coyote."

The model is building a continuous, smooth topological surface—a manifold—where every possible human thought is a distinct coordinate.

3. The Nightmare for Us (Why we need SAEs)
This infinite continuous space is exactly why we can't just look at the weights of an MLP layer and say, "Ah, Neuron #402 represents the concept of a Dog."

Neuron #402 is just a single continuous axis. The concept of "Dog" is actually an angle pointing 12.4 degrees away from Neuron #402, 88.1 degrees from Neuron #12, and 45 degrees from Neuron #3000.

Because the representation is continuous and angled across multiple axes, the features are tangled up (polysemantic). This is the exact problem that Anthropic and Neel Nanda use Sparse Autoencoders (SAEs) to solve. SAEs are designed to take this infinite, tangled, continuous space and force it to map onto a discrete, finite set of interpretable features so humans can actually read them.dding Space 

> Next ➝ we **translate** these `integer IDs` ➝ into a format the neural network can manipulate ➝ **vectors**

> - The model has an **Embedding Matrix** ➝ which acts as a giant lookup table 
> - Every `token ID` corresponds to a **specific row** in this matrix ➝ that `row` is a **high-dimensional vector** ➝ example ➝ an array of **4096** floating-point numbers

###### I. Why represent words as 4,096-dimensional vectors? 

> - Because it allows the model to map `semantic meaning` ➝ to `geometric space` 
> - During training ➝ the model `adjusts` the **floats in these vectors** so that **words with similar meanings** ➝ like `dog` and `cat` 
> 	- are **mathematically** `grouped closer together` in the space 
> - We can even do math with them ➝ `vking ​− vman ​+ vwoman​ ≈ vqueen`

> At this stage ➝ the `token` is simply ➝ a **point** in space

###### II. Semantic Meaning & Geometric Space ➝ Distance & Meaning 

> - To a human ➝ **semantic meaning** is the actual `concept` or `idea` behind a word 
> - It’s the definition, the `vibe,` and the **relationships** a word has with other words
> 	- For example ➝ we kow that `dog` and `puppy` have very **similar semantic meanings** 
> 	- We also know that a `dog` is an animal ➝ it can be `fluffy,` and it is the opposite of a `cat` 
> 	- We know all of this intrinsically

> - But a computer is just silicon and electricity ➝ it **only understands numbers** 
> - If we feed the word `dog` into a computer as the **text string** ➝ `d-o-g` ➝ the computer just sees **3 ASCII characters** 
> - It has no idea what a dog actually is 
> - It doesn't know it barks or has fur

> - How do we force a computer to understand the `conce- [[￼A-Survey-on-Efficient-Inference-for-Large-Language-Models]]pt` of a dog?

> [!quote] We force a computer to understand strings of text ➝ by `mapping` that **semantic meaning** ➝ into a **geometric space**

###### III. The Rule of Neighbors ➝ Distributional Semantics

> - Linguists have a famous saying ➝ `You shall know a word by the company it keeps` 
> - Consider the sentence 
> 	- `The brave fribble charged into battle with his sword drawn` 
> 	- We have no idea what a `fribble` is ➝ it's a made-up word 
> 	- But just by looking at the **surrounding words** ➝ `brave, battle, sword, charged` ➝  the **human brain** immediately `assigns` it a **semantic meaning** ➝ a fribble is likely a warrior or a knight or a soldier

> - LLMs **learn** semantic meaning the exact same way
> - During **training** ➝ the **untrained neural network** reads trillions of sentences 
> 	- It notices that the token for `dog` frequently **appears near** `bark,` `leash,` `park,` `pet` 
> 	- It notices `cat` **appears near** `meow,` `litter,` `pet`

###### IV. Building the Geometric Space

> - To map these relationships mathematically ➝ the LLM creates a **multi-dimensional coordinate system**

> - Consider a simplified 3-Dimensional graph 
> - Assign a `concept` to each axis
		- **X-axis** 
			- How `animal-like` is it? ➝ 0.0 to 1.0
		- **Y-axis** 
			- How `fluffy` is it? ➝ 0.0 to 1.0
		- **Z-axis** 
			- How `dangerous` is it? ➝ 0.0 to 1.0
    
> - Now, the model **assigns** coordinates ➝ a **vector** ➝ to words **based on the company they kept** during `training`
> 	- **Dog** 
> 		- `[0.9, 0.8, 0.3]` ➝ Very animal, very fluffy, slightly dangerous
		- **Wolf** 
			- `[0.9, 0.8, 0.9]` ➝ Very animal, very fluffy, very dangerous
		- **Car** 
			- `[0.0, 0.0, 0.8]` ➝ Not animal, not fluffy, very dangerous

###### V. Meaning Becomes Distance

> [!quote] In this **geometric space** ➝  **semantic meaning** is literally just ➝ the **physical distance** ➝ **between points**

> - If we calculate the **mathematical distance** between the vector for `Dog` and `Wolf` ➝ they are **physically right next to each other** on the graph 
> - They **share** a **neighborhood** 
> - The vector for `Car` is miles away ➝ in a completely **different sector** of the graph

> - In a real LLM like` GPT-3` or `Llama` ➝ there aren't just 3 axes ➝ there are **thousands of axes** ➝ example: **4096 dimensions** 
> - We **can't visualize** 4096 dimensions ➝ but the math works exactly the same 
> - The model **learns** 
> 	- a `dimension` for gender 
> 	- a `dimension` for royalty 
> 	- a `dimension` for grammar 
> 	- a `dimension` for sarcasm 
> 	- and thousands of `abstract dimensions` we don't even have words for

> [!quote] The `model` is **learning dimensions to map the semantic meanings**
 
> [!quote] When the model maps **semantic meaning to geometric space** ➝ implies it **translates** the human `concept of a word` into a `precise coordinate` in an **array**

> #llm-data-type-float | #llm-semantic-meaning | #llm-higher-dimension-space | #llm-models-GPTs | #llm-models-llama | #llmops-embedding-unembedding-layer-embedding-matrix 

##### III. Geometric Space:  Size & Meaning 
###### I. We Define the _Size_ ➝ the Model Defines the _Meaning_

> When AI architects build a model (like Llama or GPT), they hardcode the _number_ of dimensions. They say, "This embedding space will have 4,096 dimensions."

But they do **not** label what those axes mean. There is no code that says "Axis 1 is grammar," or "Axis 2 is gender," or "Axis 3 is fluffiness." We just hand the model a giant matrix of random floats and say, "Figure it out."

###### 2. Learning via Optimization (Gradient Descent)

The model learns these dimensions purely by trying to win the next-token prediction game.

- **Step 1:** The model sees "The fluffy dog chased the..." and guesses "car."
    
- **Step 2:** The true answer in the training data was "cat."
    
- **Step 3:** The model calculates its mathematical error (the loss) and uses **backpropagation** to send a signal backward through the entire network.
    
- **Step 4:** That signal reaches the Embedding Matrix and physically nudges the coordinate values (the floats) for "dog," "fluffy," and "cat" slightly closer together in the 4,096-dimensional space, because the math proves that grouping them makes predicting the next word easier.
    

Do this over 15 trillion tokens, and the model organically pushes and pulls these coordinates until highly complex semantic structures emerge in the geometry.

###### 3. The Latent Space Problem (Why MI is Hard)

Because the model learns these dimensions on its own without human labels, the resulting geometry is called a **latent space** (hidden space).

This is where your core MI frameworks—specifically **Superposition** and **SAEs**—become critical. Because the model is blindly optimizing to save space, it doesn't align one human concept perfectly to one mathematical axis.

It might learn that it can represent "basketball" by firing a little bit of Dimension 42, a chunk of Dimension 1,005, and a negative amount of Dimension 3. The concepts are spread out and angled across multiple axes (superposition).

So yes, the model learns the dimensions. But the dimensions it learns are alien to us. It learns the most mathematically compressed, interference-tolerant geometry possible.


Here is why that infinite nature is both the model's greatest superpower and an interpretability nightmare:

## 1. The Power of Angular Infinity (The Manifold)

Because the space is continuous, the model doesn't just use orthogonal (perfectly 90-degree) axes to store facts. As you pointed out with the angles, it uses the infinite space _between_ the axes.

In extremely high-dimensional spaces (like 4,096D), the geometry gets weird. The volume of a "hypersphere" expands so massively that you can generate millions of random vectors, and the angle between almost any two of them will naturally be hovering right around 89 to 91 degrees.

The model exploits this. It realizes, "If I don't demand perfect 90-degree independence, I can use an infinite combination of fractional angles to represent features." This is the geometrical mechanism behind **Superposition**. It packs a discrete concept into a continuous, fractional, tilted angle spread across hundreds of dimensions.

## 2. The Semantic Gradient

Because there are infinite points along these angles, concepts bleed into one another.

If you start at the exact coordinate for "Dog" and walk in a straight mathematical line toward the coordinate for "Cat," you aren't just moving through empty space. Every single microscopic decimal point along that vector pathway represents a valid, calculable concept to the model. You might pass through a coordinate that perfectly represents a "Fox," and then a coordinate that represents a "Coyote."

The model is building a continuous, smooth topological surface—a **manifold**—where every possible human thought is a distinct coordinate.

## 3. The Nightmare for Us (Why we need SAEs)

This infinite continuous space is exactly why we can't just look at the weights of an MLP layer and say, "Ah, Neuron #402 represents the concept of a Dog."

Neuron #402 is just a single continuous axis. The concept of "Dog" is actually an angle pointing 12.4 degrees away from Neuron #402, 88.1 degrees from Neuron #12, and 45 degrees from Neuron #3000.

Because the representation is continuous and angled across multiple axes, the features are tangled up (polysemantic). This is the exact problem that Anthropic and Neel Nanda use **Sparse Autoencoders (SAEs)** to solve. SAEs are designed to take this infinite, tangled, continuous space and force it to map onto a discrete, finite set of interpretable features so humans can actually read them.

##### IV. RAG: Connection 

> [!quote] **Retrieval Augmented Generation**
> - **RAG** is **fundamentally** 100% **based** on this exact same **vectorization**
> - To understand **RAGs** from a **mechanistic** perspective ➝ we have to realize that RAG is just an `externalization` of the **LLM's internal memory**

> #llmops-retrieval-augmented-generation-rag | [[RAG-for-Knowledge-Intensive-NLP-Tasks]] | #llm-internal-memory 

###### I. RAG: MLPs ➝ Noisy Hard Drive

> - During training ➝ we force the LLM to **memorize facts** ➝ by **tweaking** the `weights` inside **massive MLP blocks** 
> - It does this through **superposition** ➝ cramming millions of **nearly perpendicular concept vectors** ➝ into a `smaller dimensional space`

>[!quote] `Key Phrase` ➝ **nearly perpendicular vectors** 

> #llm-architecture-layer-multi-layer-perceptron-mlp | #llm-architecture-layer-multi-layer-perceptron-mlp | #mechanistic-interpretability-superposition | #mechanistic-interpretability-superposition | [[Conceptual-Superposition-MI-LLMs]]

> - The problem with superposition is that it is **lossy compression** 
> - When we cram **too many concepts** ➝ into the same geometric space ➝ the **vectors interfere** with each other 
> - This **interference** is the ➝ **mathematical root cause** of **hallucinations** 
> - The model tries to pull up the vector for "Revenue in Q3" but accidentally grabs a linear combination of "Revenue in Q3" and "Projected Revenue in Q4" because they are sitting too close to each other in the activation space.

> #llmops-hallucination | [[Conceptual-Hallucinations-and-Management]]

###### II. RAG: Externalizing the Geometry

Instead of relying on the LLM's lossy, superposed MLP weights to remember your specific data, RAG bypasses the model's internal memory entirely.

It does this by copying the exact vectorization math:

1. **Vectorizing the Database (External K and V):** You take your private documents (PDFs, code, notes) and run them through an embedding model. This turns every paragraph into a coordinate in that high-dimensional semantic space. You save these coordinates in a Vector Database. Mechanistically, you just built an external hard drive of **Keys** and **Values**.
    
2. **Vectorizing the Prompt (External Q):** When a user asks a question, you run that question through the exact same embedding model. It becomes a coordinate point—a **Query** vector.
    
3. **The Geometric Search (External Attention):** Now, instead of doing matrix multiplication inside a GPU, the Vector Database calculates the dot product (or cosine similarity) between your Query vector and all the Document vectors. It is literally just measuring physical distance in that geometric space. The documents physically closest to your prompt share the most semantic meaning.
    
4. **Injection:** You grab the text of those closest vectors and forcefully shove them into the user's prompt before handing it to the LLM.
    

###### III. RAG Benefits

By doing this, you are rescuing the LLM from having to use its MLP blocks to recall facts.

When you inject the retrieved text into the prompt, you are placing it directly into the LLM's **Context Window**. This means the LLM can use its **Attention Blocks** (which are highly precise and perfect at moving information between tokens currently in the prompt) instead of its **MLP blocks** (which are fuzzy, superposed, and prone to hallucination).

You recognized that the vector math is identical because it is. RAG is just the architectural realization that relying on a neural network's weights for factual recall is inefficient, so we rip the embedding layer out and use it to do geometric proximity searches in a sterile, interference-free database.

---
#### III. Phase 3: Storing Information ➝ MLP Blocks

Once a token is turned into a vector, it enters the core of the LLM. The architecture is built as a sequence of layers. The bulk of a model's factual knowledge (like `Paris is the capital of France`) is stored in the **Multi-Layer Perceptron (MLP)** blocks.

Architecturally, you can think of an MLP block as a massive, compressed key-value database.

- **The Up-Projection (Asking a Question):** The token's vector is multiplied by a massive matrix. Each row in this matrix is acting as a `feature detector.` It takes a dot product with your token's vector to see if they align. This is the model asking a geometric question, like, `Does this vector currently represent a European capital?`
    
- **The Non-Linearity:** The result passes through a simple function (like ReLU, which just turns any negative number into a 0). This acts as a digital logic gate. If the token doesn't match the feature, the signal is zeroed out. If it does, the signal fires.
    
- **The Down-Projection (Writing the Answer):** If the signal fires, it triggers the next matrix to add a specific set of numbers (a new vector) back onto the token's original vector. If the `European capital` feature fired, this step might mathematically add the geometric direction for `Paris` into the token's data stream.
    

**Why store it like this?** Because of a concept called **Superposition**. In a 4,096-dimensional space, you might think you can only store 4,096 perfectly independent facts (orthogonal vectors). But if you allow facts to be `nearly` perpendicular (e.g., 89 degrees apart instead of 90), you can cram millions of facts into the same space. The neural network learns to compress knowledge into this dense, overlapping geometry to save space and compute.

---
#### IV. Phase 4: The Routing Mechanism ➝ Attention

There is a major problem with the architecture so far: embeddings are static. The embedding vector for the word `bank` is the exact same whether the sentence is `river bank` or `bank account.` The tokens need a way to look at the other tokens in the sequence and change their geometry based on context.

This is the job of the **Attention Mechanism**.

If MLPs are where facts are stored, Attention is how information moves between words. When a sequence of token vectors enters an Attention layer, every single token gets multiplied by three separate weight matrices to create three new vectors: **Query (Q), Key (K), and Value (V)**.

- **Query (Q):** What I am looking for. (e.g., The word `fluffy` broadcasts a Q vector searching for a noun).
    
- **Key (K):** What I am. (e.g., The word `dog` broadcasts a K vector saying `I am a noun`).
    
- **Value (V):** What I will give you if we match. (e.g., The word `fluffy` prepares a V vector containing the mathematical concept of fluffiness).
    

**How it works structurally:**

1. The network calculates the dot product between the Query of Token A and the Keys of every other token.
    
2. These dot products are converted into probabilities (using a Softmax function). This creates an **Attention Matrix**—a grid of scores dictating exactly how much `attention` Token A should pay to Token B.
    
3. Token A then takes the Value (V) vectors of the other tokens, scales them by the attention scores, and adds them to its own vector.
    

If `fluffy` and `dog` have a high dot-product score, the vector for `dog` absorbs the Value vector of `fluffy.` The generic `dog` vector has now physically moved in the geometric space to represent `fluffy dog.`

---
#### V. Phase 5: The Output ➝ Unembedding

The token vectors flow through dozens of alternating Attention blocks (building context) and MLP blocks (looking up facts). With each layer, the vector accumulates more complex, abstract math representing the entire sequence.

Finally, the vector for the very last token in your input reaches the end of the network. It is multiplied by a final **Unembedding Matrix**. This matrix maps that single, highly contextualized vector back against the entire vocabulary dictionary. It assigns a raw score (logit) to every possible token ID, passes it through a probability function, and outputs the highest probability.

The model picks that token, appends it to your original input array, and runs the entire multi-billion-calculation process over again to predict the next one.
