---
tags:
  - llm-architecture-layer-multi-layer-perceptron-mlp
  - feed-forward-networks
  - mechanistic-interpretability
  - conceptual-explanations
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

- [[Conceptual-Intertwined-Concepts-MI]]
    
---
While Attention heads are the "routers" that move information between different tokens, MLPs are the "processors" and "memory banks" that operate strictly within a single token. They take up roughly two-thirds of a Transformer's parameter count, meaning the vast majority of a model's world knowledge is stored directly in these weights.

### **1. The Macro Function: What is the MLP actually doing?**

From a mechanistic perspective, an MLP layer acts as a massive **Key-Value (KV) Memory Bank** for the residual stream.

- **Attention vs. MLP:** Attention heads look across the sequence context (e.g., matching the pronoun "it" to "the dog" from five tokens ago). The MLP, however, does not look at the context at all. It only looks at the exact state of the residual stream vector for its specific token at that specific layer.
    
- **The Translation Mechanism:** The MLP's job is to read the current features in the residual stream, recognize specific patterns or combinations of concepts, and write _new_ features back into the stream based on what it recognized.
    

### **2. The Mechanics of the Matrices (The "How" and "Why")**

Mathematically, a standard MLP operates via two massive weight matrices and a non-linear activation function in the middle:

$MLP(x) = f(xW_{in})W_{out}$

Here is the step-by-step physical mechanism of how this alters the activation space.

#### **Step A: The Up-Projection (The "Key" Search)**

The residual stream vector $x$ (dimension $d$) is multiplied by the first weight matrix $W_{in}$ to project it into a much wider "hidden dimension" (typically $4d$ or $8d$).

- **Mechanistic View:** You can think of the rows of $W_{in}$ as individual "feature detectors" or "Keys." The model is calculating the cosine similarity (the dot product) between the current state of the residual stream and thousands of different learned patterns.
    
- If the residual stream contains the feature direction for "Barack" and "President," a specific neuron in this wider hidden layer that looks for that exact combination will register a high dot product.
    

#### **Step B: The Activation Function (The Gatekeeper)**

The expanded vector passes through a non-linear function $f$, such as GELU, ReLU, or SwiGLU.

- **Mechanistic View:** This is where the magic of "logic" happens. Functions like ReLU effectively zero out any negative values. If a feature detector in $W_{in}$ didn't find a strong enough match, the activation function suppresses it to zero.
    
- This creates **Activation Sparsity**. Only a small percentage of the neurons in this massive hidden layer will "fire" for any given token. This non-linearity is what allows the model to learn complex, non-linear representations rather than just adding vectors together continuously.
    

#### **Step C: The Down-Projection (The "Value" Write)**

The activated, sparse vector is then multiplied by $W_{out}$ to project it back down to the original residual stream dimension $d$.

- **Mechanistic View:** The columns of $W_{out}$ act as "Values." If a specific hidden neuron fired in Step B, it now acts as a scalar multiplier for a specific column in $W_{out}$.
    
- That column is a vector containing _new_ concepts or feature directions. For example, if the hidden neuron detected "Barack President," the corresponding column in $W_{out}$ might contain the vector direction for "Obama." The MLP simply adds this new "Obama" vector directly into the residual stream.
    

### **3. MLPs and the Polysemanticity Problem**

In early MI research, researchers hoped that because the hidden dimension is so wide (e.g., 16,384 neurons in a 7B model), each individual neuron would represent a clean, Monosemantic concept. This turned out to be false.

- **Superposition in MLPs:** Because models are trained to minimize loss across billions of data points, they compress far more features into the MLP than there are neurons. A single neuron in the hidden layer might fire for "HTML syntax," "German pronouns," and "the concept of sadness."
    
- **The Geometry of Firing:** The MLP doesn't rely on a single neuron to write a clean concept. Instead, a concept is represented by a specific _linear combination_ of hundreds of polysemantic neurons firing simultaneously. Their combined output vectors in $W_{out}$ constructively interfere to create the correct feature direction (e.g., "Obama") while destructively interfering to cancel out their irrelevant noise (e.g., the HTML and German features).
    

### **4. Key Citations for Your Notes**

To ground these mechanics in the literature, here are the foundational papers that established this framework:

1. **Transformer Feed-Forward Layers Are Key-Value Memories (Geva et al., 2020)**
    
    - _Significance:_ This is the foundational paper that proved the $W_{in}$ matrix acts as a pattern-matching "Key" and the $W_{out}$ matrix acts as a "Value" memory bank. It shifted the field's understanding of MLPs from "black-box math" to a readable memory retrieval system.
        
2. **A Mathematical Framework for Transformer Circuits (Elhage et al., 2021 - Anthropic)**
    
    - _Significance:_ While famous for defining Attention heads, this paper formalized the concept of the "Residual Stream" as a central communication channel that MLPs simply read from and write to independently.
        
3. **Toy Models of Superposition (Elhage et al., 2022 - Anthropic)**
    
    - _Significance:_ This paper mathematically demonstrated _why_ the neurons in the MLP hidden layers are polysemantic. It proved that models use orthogonal/almost-orthogonal directions to pack more features into the MLP than it has dimensions.
        
4. **Locating and Editing Factual Associations in GPT (Meng et al., 2022 - "ROME" Paper)**
    
    - _Significance:_ This paper proved that factual knowledge (like "The Eiffel Tower is in Paris") is physically stored in the MLP layers. They demonstrated that by mathematically altering a specific rank-one vector in the $W_{out}$ matrix, they could rewrite the model's factual memory without retraining it.