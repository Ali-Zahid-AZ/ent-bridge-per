---
tags:
  - mechanistic-interpretability
  - mechanistic-interpretability-reasoning-circuits
  - conceptual-explanations
  - note-finalized
---

---
```table-of-contents
```
---
### References

- [Zoom In: An Introduction to Circuits](https://distill.pub/2020/circuits/zoom-in/)
- [[Zoom In-An Introduction to Circuits]]
- [A Mathematical Framework for Transformer Circuits](https://transformer-circuits.pub/2021/framework/index.html#technical-details)
- [[A-Mathematical-Framework-for-Transformer-Circuits]]
- 
---
#### I. Definition from 2020

>- **Circuits: The Old Definition**
>	- A subgraph of a neural network. 
>	- Nodes correspond to neurons or directions (linear combinations of neurons). 
>	- Two nodes have an edge between them if they are in adjacent layers. 
>	- The edges have weights which are the weights between those neurons (or $n_{1}Wn_{2}^{T}$ if the nodes are linear combinations). 
>	- For convolutional layers, the weights are 2D matrices representing the weights for different relative positions of the layers.
>---
>- The notation $n_1 W n_2^T$ represents the **functional coupling** between two features (or nodes) that aren't necessarily single neurons
>--- 
>- Assume we have two layers, Layer A and Layer B, connected by a weight matrix $W$
> 	1. **$n_1$ (Source Direction):** A vector representing a specific feature in Layer A. It is a linear combination of neurons (e.g., "the direction that represents dog ears").
>    
> 	2. **$W$ (The Weight Matrix):** The full set of learned weights connecting all neurons in Layer A to all neurons in Layer B.
>    
> 	3. **$n_2^T$ (Destination Direction):** A vector representing a specific feature in Layer B (e.g., "the direction that represents a dog's head"). We use the transpose ($^T$) to perform the proper dot product.
>
> - In the 2020 paper, researchers realized that the "meaning" of a network doesn't always live in a single neuron. Sometimes a feature is "spread out" across many neurons.
> 	- **The Calculation** 
> 		- The expression $n_1 W n_2^T$ effectively "projects" the influence of the first feature through the weight matrix and measures how much of that influence "lands" on the second feature.
>    - **The Result** 
> 	   - It gives a single scalar value ➝ a **connection strength** ➝ between two abstract concepts rather than just two physical wires

#### II. Modern Definition 

>- **Circuits: Modern Definition**
>	- A circuit is a **minimal** + **computationally sufficient** **subgraph** of a model ➝ that **implements** a specific **human-interpretable algorithm**

#### III. 4 Structural Components of Circuits 

##### I. Nodes (The Features) 

- These are no longer just neurons. 
- They are **directions in activation space** (often called features). 
- A node can be a single neuron, but in modern MI, it is more often a latent discovered by a Sparse Autoencoder (SAE) or a specific Attention Head
- **Analogy**: If a neuron is a single atom, a node is a specific crystal lattice orientation that governs how a signal moves.
        
##### II. Edges (The Interactions) 

- An edge represents the **causal influence** of one node on another. 
- This is mathematically quantified by the weights ($W$), but specifically through how one feature’s activation is read by the next layer's weights to write into a new feature direction.
    
##### III. The Manifold: The Residual Stream

- In Transformers, circuits do not just hop from layer 1 to layer 2
- They exist as operations on the **Residual Stream** ➝ a high-dimensional vector space that acts as a shared communication bus
	- A circuit is a ➝ **sequence** of **Read-Transform-Write** operations ➝ on this bus
    
##### IV. The Algorithm

- A subgraph is only a circuit if it performs a consistent task (e.g., If I see 'A', and then 'B', then predict 'A')
- If the subgraph's activity doesn't map to a logical rule ➝ it's just a collection of weights ➝ not a circuit
    
#### IV. The Formal Mechanistic Interpretability First Definition

> **For Mechanistic Interpretability**
$$C = (V, E, \mathcal{A})$$

where
- $V$ is a set of **interpretable features** ➝ directions in the $d_{model}$ space
- $E$ is the set of **weighted causal paths** ➝ composition of weights and activations ➝ that connect these features
- $\mathcal{A}$ is the **functional mapping** ➝ the algorithm ➝ such that for a given input $x$ ➝ the activation of the final node $v_{out}$ is a direct consequence of the path through $E$

#### V. The Rapid Conceptual Evolution in Mechanistic Interpretability: 2020–2026

> The jump from **Zoom In** (March 2020) to where Mechanistic Interpretability has now reached (February 2026) ➝ represents a massive shift in the **scale of complexity** and the **tools of observation**

- **2020 (The Microscope Era)** 
	- Researchers were manually hand-labeling neurons in InceptionV1 
	- It was like a biologist drawing cells by hand under a microscope
    
- **2022 (The Map Era):** 
	- The discovery of **Induction Heads** and the **Mathematical Framework** shifted the focus to LLMs
	- We realized that Transformers don't just detect features ➝ they move information in a structured residual stream
    
- **2024-2025 (The Collider Era)** 
	- We moved to **Sparse Autoencoders (SAEs)**
	- We realized that the atoms (neurons) we were looking at in 2020 were actually blurry mixtures of hundreds of different features (Superposition)
	- SAEs allow us to de-mix these into clean, pure features
    
- **2026 (The Engineering Era)** 
	- Today, we aren't just looking at circuits to understand them; we are starting to **edit** them (Circuit Breaking) to prevent hallucinations or remove dangerous knowledge without retraining the whole model.