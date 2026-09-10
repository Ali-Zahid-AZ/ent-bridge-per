---
tags:
  - mechanistic-interpretability
  - mechanistic-interpretability-tools
  - mechanistic-interpretability-toolkit
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

- [[A-Practical-Review-of-Mechanistic-Interpretability-for-Transformer-Based-Language-Models]]
- [[TransformerLens-Library-MI]]
- [[Conceptual-ToolKit-Comprehensive-MI]]
- [[Conceptual-Basics-Anatomy-of-Compute-Feature-Manifolds-Circuit-Topologies]]
  
---
> - To understand the Logit Lens comprehensively ➝  we have to consider it not just as an observation tool
> - But as a deliberate mathematical `hijack` of the transformer's architecture

> - Normally ➝ a language model ➝ is a black box ➝ until the very end of its computation 
> - The Logit Lens breaks this rule ➝ by allowing us to eavesdrop on the model’s internal `thoughts` ➝ at any arbitrary point in the residual stream

---
### 1. The Baseline: How an LLM Usually Speaks

> To understand the lens ➝ we first need to look at **how a model generates its final answer**

> - After a token vector has passed through every single layer ➝ let's say Layer 0 to Layer 32  
> 	- it arrives at the end of the residual stream 
> 	- as a highly enriched, dense vector $h^L$
    
> - To convert this `mathematical vector` ➝ back into English ➝ the model applies a **final Layer Normalization** ➝ and then `multiplies` it by the **Unembedding Matrix** ➝ $W_U$
    - $W_U$ is essentially a **massive dictionary** 
    - Its shape is [d_model, d_vocab] 
    - When we **multiply** the `final vector` $h^L$ by $W_U$ ➝ we are taking the **dot product** of the model's final `thought` against **every single word** in the vocabulary

> - The words that 
> 	- geometrically align best with the thought vector ➝ get the highest scores ➝ logits  
> 	- which are then turned into probabilities via a Softmax function

---
### 2. The Logit Lens Intervention: The Hijack

> The Logit Lens asks a radical question: `What happens if we don't wait until the end?`

> - Suppose we are at Layer 15 of a 32-layer model 
> - The residual stream currently holds an intermediate activation vector ➝ $h^{15}$ 
> - The model is only halfway done processing ➝  but the Logit Lens takes this intermediate vector and forcefully projects it out to the vocabulary right then and there

**Mechanically** the operation is simply ➝ applying the final unembedding step early
$$LogitLens(h_i^l) = LayerNorm(h_i^l)W_U$$

> By doing this, we bypass the remaining 17 layers entirely 
> We trick the intermediate vector into `speaking` as if it were the final output

### 3. Why It Works: Iterative Inference

You might assume that projecting a halfway-done vector would just result in random noise. But it doesn't. Instead, it reveals that transformers operate on an **iterative inference perspective**.

The residual stream is an accumulator. As the vector moves from layer to layer, it is progressively refining its `guess` for the next token.

- At Layer 5, if the input is `The capital of France is`, the Logit Lens might show the model predicting broad geographic tokens like `Europe` or `City`.
    
- By Layer 15, the Multi-Layer Perceptrons (MLPs) have injected factual knowledge, and the Logit Lens shows the top prediction shifting to `Paris`.
    
- For the remaining layers, the model simply refines the confidence of `Paris` or checks for syntactic edge cases (like needing a period or a lowercase `p`).
    

This allows us to pinpoint the exact layer where a specific feature or fact was written into the residual stream.

### 4. The Limitation: The Basis Problem (And the Tuned Lens)

While the Logit Lens is powerful, it has a significant structural limitation, particularly in the earliest layers of the model.

- **The Assumption:** The Logit Lens assumes that the geometric space (the basis) of Layer 5 is exactly the same as the geometric space of the final layer, because it uses the exact same $W`U$ matrix to translate both.
    
- **The Reality:** In reality, the earlier layers are often doing low-level syntactic processing and operating in a slightly different mathematical space. When you multiply a Layer 2 vector by the final $W`U$ matrix, the output is often unreliable or just predicts the exact same token that was just inputted.
    

**The Solution:** To fix this, researchers developed the **Tuned Lens**. Instead of just applying $W`U$ directly, the Tuned Lens trains a specific affine translator for each layer. This translator takes the intermediate vector, physically rotates and maps it into the final layer's representation space, and `then` applies the $W`U$ matrix. This results in a much more faithful decoding of what the early layers are actually computing.

+3

By using the Logit Lens (and its Tuned variants), you transition from tracking meaningless floating-point numbers in a vector to reading a step-by-step, English-language transcript of the model's evolving logic.

### Citations


**The Foundational Logit Lens**

- **nostalgebraist (2020):** nostalgebraist. Interpreting gpt: the logit lens. `AI Alignment Forum`, 2020. Available at: [https://www.lesswrong.com/posts/AcKRB8wDpdaN6v6ru/interpreting-gpt-the-logit-lens](https://www.lesswrong.com/posts/AcKRB8wDpdaN6v6ru/interpreting-gpt-the-logit-lens).
    

**Advancements: Reliability and Tuned Lens**

- **Belrose et al. (2023):** Nora Belrose, Zach Furman, Logan Smith, Danny Halawi, Igor Ostrovsky, Lev McKinney, Stella Biderman, and Jacob Steinhardt. Eliciting latent predictions from transformers with the tuned lens. `arXiv preprint arXiv:2303.08112`, 2023.
    
- **Din et al. (2023):** Alexander Yom Din, Taelin Karidi, Leshem Choshen, and Mor Geva. Jump to conclusions: Short-cutting transformers with linear transformations. `arXiv preprint arXiv:2303.09435`, 2023.
    

**Advancements: Decoding Positions (Attention, Weights, and Gradients)**

- **Sakarvadia et al. (2023) [Attention Lens]:** Mansi Sakarvadia, Arham Khan, Aswathy Ajith, Daniel Grzenda, Nathaniel Hudson, André Bauer, Kyle Chard, and Ian Foster. Attention lens: A tool for mechanistically interpreting the attention head information retrieval mechanism. `arXiv preprint arXiv:2310.16270`, 2023.
    
- **Geva et al. (2022) [Projecting Weights]:** Mor Geva, Avi Caciularu, Kevin Wang, and Yoav Goldberg. Transformer feed-forward layers build predictions by promoting concepts in the vocabulary space. In `Proceedings of the 2022 Conference on Empirical Methods in Natural Language Processing`, pp. 30–45, 2022.
    
    +1
    
- **Katz et al. (2024) [Backward Lens]:** Shahar Katz, Yonatan Belinkov, Mor Geva, and Lior Wolf. Backward lens: Projecting language model gradients into the vocabulary space. `arXiv preprint arXiv:2402.12865`, 2024.
    

**Advancements: Decoding Expressivity (Relations and Future Tokens)**

- **Hernandez et al. (2023) [Attribute Lens]:** Evan Hernandez, Arnab Sen Sharma, Tal Haklay, Kevin Meng, Martin Wattenberg, Jacob Andreas, Yonatan Belinkov, and David Bau. Linearity of relation decoding in transformer language models. `arXiv preprint arXiv:2308.09124`, 2023.
    
- **Pal et al. (2023) [Future Lens]:** Koyena Pal, Jiuding Sun, Andrew Yuan, Byron C Wallace, and David Bau. Future lens: Anticipating subsequent tokens from a single hidden state. `arXiv preprint arXiv:2311.04897`, 2023.
    
- **Cancedda (2024) [Logit Spectrology]:** Nicola Cancedda. Spectral filters, dark signals, and attention sinks. `arXiv preprint arXiv:2402.09221`, 2024.
    
    +1