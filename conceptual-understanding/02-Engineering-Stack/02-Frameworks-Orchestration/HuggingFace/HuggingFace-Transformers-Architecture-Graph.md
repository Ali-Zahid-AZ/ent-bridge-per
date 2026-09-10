---
tags:
  - llmops
  - llmops-tools
  - library-transformers
  - library-huggingface
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

- [[TransformerLens-Library-MI]]
- [[Transformers-Library-LLMOps-LLMs-MI]]
- [[Accelerate-Library-LLMs-LLMOps]]
- 
 ---
To understand the Hugging Face Transformers architecture graph, we must look past the Python classes and view the model as a computational Directed Acyclic Graph (DAG). For Mechanistic Interpretability (MI), this graph is not just a software execution path; it is the physical topology where information is routed, features are extracted, and geometric transformations occur in the activation space.

Here are detailed, first-principles notes on the standard Hugging Face (HF) Architecture Graph, specifically focusing on decoder-only Causal Language Models (like Llama or Mistral).

## 1. The Macroscopic Topology: The Global Graph

At the highest level, the HF model is a container wrapper (`LlamaForCausalLM`) that manages the flow of tensors from discrete token space into the continuous manifold, through the computational blocks, and back out to the vocabulary distribution.

The primary nodes at this level are:

- **`model.embed_tokens` (The Embedding Layer):** This is a simple lookup table (a matrix of size `[vocab_size, hidden_size]`). It acts as the entry point, taking discrete integer IDs and projecting them into the base activation space. In MI terms, this initializes the residual stream.
    
- **`model.layers` (The Sequential Backbone):** A PyTorch `ModuleList` containing $N$ structurally identical transformer blocks. This is where the actual computation happens.
    
- **`model.norm` (The Final LayerNorm):** Normalizes the final vector in the residual stream before unembedding.
    
- **`lm_head` (The Unembedding Matrix):** A linear projection layer (`[hidden_size, vocab_size]`). It reads the final state of the residual stream and projects it back into logits to form a probability distribution over the vocabulary.
    

## 2. The Microscopic Topology: Inside `model.layers[i]`

The core of the architecture graph lies within a single transformer block. In HF, a typical block (e.g., `LlamaDecoderLayer`) is split into two primary sub-graphs: Attention and the Multi-Layer Perceptron (MLP), connected strictly via the residual stream.

#### A. The Attention Sub-Graph (`model.layers[i].self_attn`)

This is the routing mechanism. It determines _how_ information moves between different token positions in the sequence. HF structures this into four distinct linear projections:

- **`q_proj` (Query) and `k_proj` (Key):** These parallel nodes compute the attention scores. They project the current residual stream into a lower-dimensional subspace to calculate the inner product $Q K^T$. In circuit analysis, these matrices form the **Attention Pattern**, determining _where_ the current token should look for information.
    
- **`v_proj` (Value):** This matrix reads features from the source token's residual stream.
    
- **`o_proj` (Output):** This matrix takes the weighted sum of the Values and projects it back into the full `hidden_size` dimension, orienting the vector so it can be added to the destination token's residual stream. In MI, $W_V$ and $W_O$ are often multiplied together to form the **Value-Output (OV) Circuit**, representing _what_ information is actually moved between tokens.
    

#### B. The MLP Sub-Graph (`model.layers[i].mlp`)

If Attention moves information across tokens, the MLP processes information within a single token's representation. It acts as an associative memory, recognizing complex features and writing new features to the stream. Modern HF architectures (using SwiGLU) divide this into three nodes:

- **`gate_proj` and `up_proj`:** These project the `hidden_size` vector into a much wider high-dimensional space (often $4 \times$ or $8 \times$ the hidden dimension). This is the locus of **Superposition Theory**. The model projects into this expansive space to represent vastly more features than there are dimensions in the residual stream. The `gate_proj` typically passes through a non-linear activation function (like SiLU) and is multiplied element-wise with the `up_proj`.
    
- **`down_proj`:** This reads the activated features from the wide MLP hidden state and projects the result back down to the `hidden_size`, orienting the resulting vector to be added to the residual stream.
    

#### C. The Normalization Nodes

Scattered throughout the block are normalization nodes, usually `input_layernorm` (before Attention) and `post_attention_layernorm` (before the MLP). HF models typically use RMSNorm. Mechanistically, these are non-linear transformations that constantly scale the residual stream to maintain variance, which must be mathematically accounted for when performing Logit Lens analysis.

## 3. The Residual Stream: The Implicit Edges

The most critical part of the HF graph is not a layer, but the edges connecting them: the residual stream.

In the HF source code, the forward pass of a layer looks mathematically like this:

$$x_{mid} = x_{in} + \text{Attention}(\text{Norm}(x_{in}))$$

$$x_{out} = x_{mid} + \text{MLP}(\text{Norm}(x_{mid}))$$

- **The Accumulator:** The residual stream acts as a central communication channel. Every `o_proj` and `down_proj` in the graph is tasked with computing a _delta_ (an update vector) that is explicitly added to this stream.
    
- **Linear Superposition:** Because the updates are additive, the residual stream is a linear combination of the original embedding and the outputs of every previous Attention head and MLP. This is why techniques like Sparse Autoencoders (SAEs) can be attached at any `x_out` to decode the superposition of features present at that specific depth.
    

## 4. Interfacing with the Graph for Interpretability

Understanding this specific nomenclature (`self_attn.q_proj`, `mlp.down_proj`) is essential for dissecting the model.

When you want to intervene or observe the model, you navigate this PyTorch `nn.Module` tree. By using PyTorch's `register_forward_hook`, you can attach probes to any of these specific nodes. For example, to map the activation space geometry of a specific feature, you would hook into `model.layers[15].mlp.up_proj` to capture the high-dimensional tensors right before the non-linearity is applied, bypassing the black-box abstraction entirely.