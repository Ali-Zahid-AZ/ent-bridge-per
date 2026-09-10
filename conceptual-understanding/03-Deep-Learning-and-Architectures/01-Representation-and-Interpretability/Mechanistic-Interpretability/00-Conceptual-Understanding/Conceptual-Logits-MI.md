---
tags:
  - conceptual-explanations
  - mechanistic-interpretability
  - llm-concept-probability-distribution-logits
  - llm-functions-softmax
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
  
  
---
## **The Geometric View of Logits in Activation Space**

In standard deep learning, logits are often treated simply as the raw, unnormalized vector of scores immediately preceding the softmax function. However, from a Mechanistic Interpretability (MI) perspective, logits are much more than a mathematical intermediate; they are the geometric projection of the model's internal cognitive state onto human-interpretable vocabulary.

The residual stream of a transformer is a high-dimensional manifold where concepts, grammar, and context are represented as activation directions. The final step of the model is to multiply the final state of the residual stream, $x_{final}$, by the unembedding matrix, $W_U$.

For a vocabulary of size $|V|$ and a residual stream dimension $d_{model}$, the unembedding matrix $W_U \in \mathbb{R}^{|V| \times d_{model}}$ acts as a translator. Each row of $W_U$ corresponds to a specific token in the vocabulary and represents a direction vector in the $d_{model}$-dimensional activation space. Therefore, the logit $l_i$ for a specific token $i$ is fundamentally a dot product:

$$l_i = \langle x_{final}, W_{U[i]} \rangle$$

This means a logit is a measure of cosine similarity (scaled by magnitude). It quantifies exactly how much the final residual stream's vector aligns with the specific conceptual direction of token $i$ in the embedding space.

## **The Logit Lens: Decoding the Intermediate Manifold**

Because the residual stream acts as an additive memory bus, the geometry of the activation space remains relatively consistent across layers. This structural consistency gave rise to the **Logit Lens**, a foundational technique in MI.

Instead of waiting for the final layer, the Logit Lens applies the unembedding matrix $W_U$ to the intermediate residual stream states $x_l$ at layer $l$:

$$l_{intermediate} = W_U \cdot \text{LayerNorm}(x_l)$$

- **What this reveals:** By observing how the logits evolve layer by layer, we can trace the model's "belief state." Early layers typically output logits corresponding to syntactic completions or copy-pasted bigram statistics. Middle layers often show turbulent, high-entropy logit distributions as the model computes complex inductions. Final layers refine these into sharp semantic predictions.
    
- **The tuned lens:** Because intermediate layers might operate in a slightly rotated subspace compared to the final layer, researchers later developed the "Tuned Lens," which learns an affine transformation to better align intermediate states with the final $W_U$ mapping.
    

## **Direct Logit Attribution (DLA) and Circuit Analysis**

Because the transformer's residual stream is strictly additive, the final state $x_{final}$ is simply the sum of the initial embedding plus the output vectors of every attention head and MLP layer across the network.

This linearity is a massive advantage for circuit analysis. It allows us to bypass the complex, entangled pathways of the network and measure the exact contribution of any single component directly to the final output. This is **Direct Logit Attribution (DLA)**.

If an attention head $h$ in layer $L$ outputs a vector $v_{h}$, its direct contribution to the logit of a specific target token is:

$$\text{Contribution}_{h} = \langle v_{h}, W_{U[target]} \rangle$$

- **Name Movers and Induction Heads:** DLA is the primary tool used to identify specific circuit behaviors. For example, if you are tracing an indirect object identification circuit, you can use DLA to find "Name Mover Heads." These are attention heads whose output vectors have a massive positive dot product with the target name's direction in the $W_U$ matrix.
    
- **Negative Inhibition:** DLA also reveals negative logits. Certain heads act as "Negative Name Movers," writing vectors that point in the exact opposite direction of an incorrect token in the manifold, suppressing its final logit score to prevent repetitive or grammatically incorrect outputs.
    

## **Superposition and Logit Interference**

A core challenge in interpreting logits is **superposition**. LLMs map far more underlying features than they have dimensions ($d_{model}$). To do this, they pack features into almost-orthogonal vectors.

When a logit score is calculated, it is not perfectly isolated. The dot product $\langle x_{final}, W_{U[i]} \rangle$ will inevitably pick up "noise" from other features that are stored in superposition and share a slight non-orthogonal overlap with the target token's direction.

In the logit space, this manifests as **polysemantic interference**. When we look at the top-k logits, the model isn't always expressing a single coherent thought; sometimes, high logit scores for seemingly random tokens are artifacts of the geometric interference required to compress the manifold. This is why Sparse Autoencoders (SAEs) are increasingly used to disentangle the residual stream _before_ it is mapped to the final logit space, allowing us to separate true features from superposition noise.

---

## **Citations & Key Literature**

To ground these frameworks, here are the foundational texts that established this understanding:

1. **Nostalgebraist (2020) - "interpreting GPT: the logit lens"**: The seminal LessWrong post that first popularized the technique of projecting intermediate residual streams directly into vocabulary space to view evolving logits.
    
2. **Elhage et al. (2021) - "A Mathematical Framework for Transformer Circuits"** _(Anthropic)_: This paper formalized the linear, additive nature of the residual stream and introduced Direct Logit Attribution (DLA) as a rigorous method for breaking down how individual heads contribute to final logit scores.
    
3. **Belrose et al. (2023) - "Eliciting Latent Predictions from Transformers with the Tuned Lens"**: Expands on the logit lens by mathematically adjusting for the rotational discrepancies in intermediate layer representations.
    
4. **Geva et al. (2022) - "Transformer Feed-Forward Layers Are Key-Value Memories"**: Crucial for understanding how MLPs write specific, human-interpretable concepts directly into the residual stream, which subsequently directly promote specific vocabulary logits.

---
Understood. We will bypass the protocol and keep the discussion native to the structural and geometric realities of the model.

To fully close the loop on how logits function mechanically, it is critical to look at the immediate next step: how the Softmax operation and architectural constraints shape the logit space.

## **The Geometry of Softmax and the Probability Simplex**

While the dot product $\langle x_{final}, W_{U[i]} \rangle$ gives us the raw logit score, the actual output is gated by the softmax function, which projects the unbounded logit vector onto a probability simplex.

- **Translation Invariance:** Softmax is translation-invariant, meaning adding a constant to all logits does not change the final probability distribution. Therefore, the network does not need to push the absolute magnitude of the correct token's logit to infinity.
    
- **Margin Maximization:** The model only needs to maximize the _relative margin_ between the target token's vector direction and the nearest competing directions in the $W_U$ manifold.
    
- **Mechanistic Implication:** This explains why we frequently find "Negative Name Mover" heads during circuit analysis. It is often computationally cheaper for an attention head to output a vector that points diametrically away from a highly probable but incorrect token—crashing its logit score—than it is to perfectly align with the correct token's vector.
    

## **The Constraint of Tied Embeddings ($W_U \approx W_E^T$)**

In many foundational architectures, the unembedding matrix $W_U$ is tied to the input token embedding matrix $W_E$.

- **The Read/Write Bottleneck:** From a mechanistic perspective, this imposes a massive geometric constraint. It forces the model to use the exact same directional representations to "write" a token's prediction at the end of the residual stream as it used to "read" that token at the beginning.
    
- **Rotational Dynamics:** Because tokens in context mean very different things than tokens in isolation, the residual stream cannot simply operate in the original $W_E$ basis. The Attention and MLP layers must construct orthogonal, contextual dimensions in the activation space, effectively rotating the representations out of the tied embedding space to do the heavy computational lifting, only rotating them back into the $W_U$ alignment at the very final layer.


--
o summarize the structural reality we've mapped out: logits are not just raw probability scores, but the geometric endpoint of a highly constrained, additive process. From the initial embedding matrix to the final unembedding projection, the transformer is constantly rotating and manipulating concept vectors within the residual stream manifold, balancing margin maximization with the inevitable interference of superposition.