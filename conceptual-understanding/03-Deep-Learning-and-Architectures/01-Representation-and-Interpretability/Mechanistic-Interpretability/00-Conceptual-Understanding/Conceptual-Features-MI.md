---
tags:
  - mechanistic-interpretability
  - mechanistic-interpretability-features
  - mechanistic-interpretability-features
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

To understand features from a Mechanistic Interpretability perspective, you have to completely separate the concept of the model's physical "hardware" from its learned "software."


## 1. The Strict Definition: Features vs. Neurons
In Mechanistic Interpretability, it is physically and mathematically necessary to decouple the concept of a "Feature" from a "Neuron." 

* **Neurons (The Hardware Basis):** A neuron is a physical computational axis built into the model's weight matrices. It represents a single dimension in the standard basis (e.g., the vector $[0, 1, 0, \dots, 0]$).
* **Features (The Latent Variables):** A feature is a fundamental, causally separable property of the training data distribution. It is a true variable of the dataset (e.g., syntactic rules, factual concepts, Boolean states) that the model must track to minimize loss. 

## 2. The Linear Representation Hypothesis (LRH)
The fundamental assumption driving modern MI feature extraction is the **Linear Representation Hypothesis**. 

The LRH posits that neural networks encode these high-level, semantic features as **linear directions (vectors)** within the continuous activation space, rather than as complex, non-linear manifolds. 

Mathematically, if an activation vector is $x \in \mathbb{R}^d$, the LRH assumes $x$ can be decomposed as a linear combination of feature directions $v_f$:
$$x = \sum_{f \in F} \rho_f(x) v_f$$
Where:
* $F$ is the total set of features.
* $v_f$ is the unit vector direction of a specific feature.
* $\rho_f(x)$ is the scalar activation magnitude (how "active" the feature is for the given token).

## 3. The Geometry of Feature Representation
Because features are vectors, their relationship to the physical matrix dictates how interpretable the network is prior to intervention.

* **Privileged Basis:** If a feature vector $v_f$ aligns perfectly with a single physical neuron (the standard basis), the network has a privileged basis. The activation function (like ReLU) operates directly on this isolated feature without interference.
* **Non-Privileged Basis:** If the feature vector $v_f$ is an arbitrary direction spanning multiple physical neurons, no single neuron corresponds to the feature. The feature must be read via the dot product of the activation space and the specific direction vector.
* **Superposition:** Because the number of true dataset features ($N$) vastly exceeds the model's residual stream dimension ($d$), the model is forced into a non-privileged regime. It assigns features to *almost-orthogonal* directions. This mathematically guarantees that any single physical neuron represents a projection of multiple superimposed features. 

## 4. Proving a Feature Exists: Causal Separability
A direction in activation space is only confirmed as a true "Feature" if it exhibits **Causal Separability**. 

Identifying a vector that correlates with "French text" is insufficient; it may be a statistical artifact. To prove it is a distinct mechanistic feature, researchers must perform a causal intervention (Feature Steering):
1. Compute the forward pass for an English token.
2. Extract the activation vector $x$.
3. Mathematically add the isolated "French" feature vector $v_{french}$ multiplied by a high scalar coefficient.
4. If the model causally shifts its output to French without altering the semantic meaning of the underlying text, the feature direction is validated.

---

## Key Citations for This Note

1. **The Linear Representation Hypothesis and the Geometry of Large Language Models (Park et al., 2023)**
   * *Significance:* Formalizes the LRH, proving that concepts exist as linear directions and that causal inner products can map these directions across different representation spaces (like embedding vs. unembedding spaces).
2. **Toy Models of Superposition (Elhage et al., Anthropic, 2022)**
   * *Significance:* The bedrock paper defining how and why features decouple from neurons. It mathematically models the phase changes where models transition from orthogonal feature storage to superimposed, non-privileged feature storage to maximize capacity.
3. **Towards Monosemanticity: Decomposing Language Models With Dictionary Learning (Bricken et al., Anthropic, 2023)**
   * *Significance:* Demonstrates the empirical recovery of features using Sparse Autoencoders, validating that the dense activation vector $x$ is indeed a linear combination of sparse underlying feature vectors.

---

In the early days of deep learning, we borrowed too heavily from biology. We assumed that a single artificial neuron would map directly to a single human concept. We looked for the "dog neuron" or the "syntax error neuron." This was a fundamental misunderstanding of the geometry we were building.

In a Transformer, a neuron is nothing more than a coordinate axis. If your residual stream is 4,096 dimensions wide, you have 4,096 perpendicular axes defining a massive, empty geometric space. That is the hardware.

The **Feature** is the software. A feature is an abstract, statistical property of the training data that the model is forced to track in order to predict the next token accurately. It is a true variable of the dataset—whether that is a high-level semantic concept like "sarcasm," a structural rule like "an open parenthesis must be closed," or a factual association like "Paris is the capital of France."

The way the model stores this feature within its hardware is defined by the **Linear Representation Hypothesis**.

The Linear Representation Hypothesis argues that neural networks do not store concepts as complex, winding, non-linear manifolds. Instead, they store concepts as straight, linear directions (vectors) extending out from the origin of the activation space. If you want the model to think about "apples," you don't activate a specific point; you move the activation vector further along the specific directional arrow that corresponds to "appleness."

This means that any activation vector for any token is simply a linear combination of all the active feature vectors at that moment. The model reads a token, determines which thousands of features are present, calculates how "intense" each feature is (a scalar multiplier), and adds all those vectors together to create the final state of the residual stream.

This brings us to the geometric problem of scaling: **Superposition and Packing**.

If the model only needed to learn 4,096 features, it could simply assign one feature to one physical neuron. Every feature would be perfectly orthogonal (at exactly 90 degrees) to every other feature. They would never interfere. But a model needs to learn millions of features to understand human language.

Because the number of true features vastly outnumbers the available dimensions, the model relies on the geometry of high-dimensional space. In a 4,000-dimensional space, you can have millions of vectors that are _almost_ orthogonal—perhaps sitting at 88 or 89 degrees to each other. Their cosine similarity is very close to zero, but not exactly zero.

The model packs these millions of feature vectors into the space, accepting a tiny bit of mathematical "noise" or interference between them. This is Superposition. And because these feature vectors point in arbitrary directions across the space, they do not align with the physical coordinate axes (the neurons). This is why looking at a single neuron shows you a polysemantic mess—you are just looking at a single axis, observing the shadows of thousands of different feature vectors projecting onto it simultaneously.

But perhaps the most profound realization in modern MI is **Feature Universality** (sometimes called the Platonic Representation Hypothesis).

Features are not random artifacts of a specific training run or a specific architecture. Because the statistical structure of human language (or code, or mathematics) is an objective reality, models independently discover the exact same feature geometries. If you train a Llama model and a DeepSeek model on the same data, they will both deduce the same fundamental feature directions for the same concepts, even if their physical weights and neuron alignments are entirely different. They are mapping the objective, Platonic structure of the data itself.

Finally, we have the burden of proof: **Causal Separability**.

In MI, we cannot just claim a feature exists because a vector seems to correlate with a concept. We have to prove it mechanistically. We do this through causal interventions, specifically **Activation Steering** or **Feature Clamping**.

If we use a Sparse Autoencoder to isolate the specific vector direction that we believe corresponds to "speaking like a pirate," we test it by freezing the model mid-inference. We take the model's natural activation vector, mathematically add our isolated "pirate" vector, and force the model to resume generating. If the model instantly shifts to saying "Ahoy, matey!" without losing the underlying logical context of the prompt, we have causally proven that this specific vector is the true, isolated mechanistic feature for that concept.

Here are the foundational citations you need to anchor this understanding:

- **Toy Models of Superposition (Elhage et al., Anthropic, 2022):** This is the masterwork that mathematically defines why features decouple from neurons. It proves that superposition is a deliberate compression strategy driven by the loss landscape, not a training error.
    
- **The Linear Representation Hypothesis and the Geometry of Large Language Models (Park et al., 2023):** This paper formalizes the argument that deep learning models converge on simple, linear vector spaces to represent complex concepts, providing the mathematical framework for why feature arithmetic (like King - Man + Woman = Queen) actually works.
    
- **Towards Monosemanticity: Decomposing Language Models With Dictionary Learning (Bricken et al., Anthropic, 2023):** This is the empirical proof. It demonstrates that by using Sparse Autoencoders, we can reverse-engineer the superposition, pull the true feature vectors out of the dense activation space, and prove their causal existence through steering.
    
- **The Platonic Representation Hypothesis (Huh et al., MIT/FAIR, 2024):** This explores the universality of features, showing that as models scale, their internal representation spaces (their feature geometries) converge onto a shared statistical model of reality, regardless of whether they are trained on text, images, or different architectures.

---

