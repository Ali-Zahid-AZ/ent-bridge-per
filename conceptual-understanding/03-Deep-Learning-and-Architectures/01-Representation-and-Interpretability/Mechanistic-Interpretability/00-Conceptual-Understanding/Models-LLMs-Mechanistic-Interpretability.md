---
tags:
  - mechanistic-interpretability
  - llm-models
  - models-mechanistic-interpretability
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

- [[DeepSeek-R1-Model-Local]]
- [[Evo-2-Model-Local]]
- [[Gemma-3-Series-Model-Local]]
- [[GPT-2-Small-Model-Local]]
- [[Pythia-Series-Model-Local]] 
- [[OLMo-3-Model-Local]]
---
### The MI Heavy-Hitters for 2026

| **Model**                 | **Parameter Scale** | **Why it’s Best for MI**                                                                             | **Primary Tool/Infra**        |
| ------------------------- | ------------------- | ---------------------------------------------------------------------------------------------------- | ----------------------------- |
| **Gemma 3 (Series)**      | 270M – 27B          | **SAE Dominance:** Gemma Scope 2 provides high-fidelity feature maps for all internal activations    | TransformerLens + Gemma Scope |
| **GPT-2 Small**           | 124M                | **Maturity:** Hundreds of papers have mapped its circuits. Ideal for `Hello World` MI research       | TransformerLens               |
| **Pythia Series**         | 70M – 12B           | **Training Dynamics:** 143 saved checkpoints let us study the `Physics of Learning` across time      | TransformerLens               |
| **DeepSeek-R1 (Distill)** | 1.5B – 8B           | **Reasoning Manifolds:** Best for studying how `Chain-of-Thought` is represented in activation space | nnsight / Custom Logit Lens   |
| **Evo 2**                 | 7B+                 | **Domain MI:** Optimized for biological sequences; great for studying MI outside of human language   | Arc Institute Visualizers     |

---
#### I. Gemma 3 ➝ 4B & 12B

- Thanks to **Gemma Scope 2** these are the most `interpreted` models in history 
- Google released trillions of SAE parameters for these, covering every layer 
- If we want to study how an induction head handles a specific token sequence in a manifold ➝ Gemma 3 is the primary laboratory
    
#### II. GPT-2 Small ➝ 124M

- Still the `Drosophila` of MI 
- Because its circuits are already so well-documented ➝ Induction Heads, IOI circuits 
	- it remains the best baseline for testing new interpretability algorithms before scaling them

| **Format**      | **The Target Repository** | **Architectural Purpose (The "For What")**                                                                                   |
| --------------- | ------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| **Safetensors** | `openai-community/gpt2`   | **The MI Microscope:** Used for deep-dive residual stream mapping, activation patching, and circuit discovery.               |
| **GGUF**        | `mradermacher/gpt2-GGUF`  | **The Behavioral Sandbox:** Used for high-speed CPU inference to verify prompt responses before executing heavy MI analysis. |

#### III. Pythia ➝ 70M - 12B

- These are vital because they were saved at multiple checkpoints during training
- If we want to see the **geometry of activation spaces** evolve ➝ watching a `truth vector` crystallize over time ➝ Pythia is the only reliable choice
    
#### IV. DeepSeek-R1 ➝ Distilled 7B/8B

- These are unique for MI because they allow us to study `Reasoning Circuits` 
- We can use the Logit Lens to see the model `thinking` through its `<think>` tags ➝ providing a rare look at internal state-tracking in real-time
  
#### IV. OLMo 3 

| **Format**  | **The Target Repository**      | **Architectural Purpose (The For What)**                                                                                                                                                        |
| ----------- | ------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Safetensors | `allenai/Olmo-3-7B-Think`      | **The MI Microscope:** Used for deep-dive residual stream mapping, activation patching, and circuit discovery (with the unique addition of tracing circuits back to the Dolma 3 training data). |
| GGUF        | `unsloth/Olmo-3-7B-Think-GGUF` | **The Behavioral Sandbox:** Used for high-speed CPU inference to verify prompt responses and reasoning logic before executing heavy MI analysis.                                                |
