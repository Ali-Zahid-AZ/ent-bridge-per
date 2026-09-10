---
tags:
  - deepseek
  - deepseek-R1
  - deepseek-R1-distill
  - llm-architectures-deepseek
  - deepseek-V3-V3_2
  - llm-reinforcement-learning-RL
  - llm-reasoning-traces
  - research-article
  - research-2025
  - llm-training-dynamics-GRPO
  - large-reasoning-models-LRMs
  - llm-foundational-texts
  - llm-training-dynamics-reinforcement-learning-from-human-feedback-RLHF
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

- Article Pdf in Directory: [Dir: DeepSeek-R1-Incentivizing-Reasoning-Capability-in-LLMs-via-Reinforcement-Learning-2026.pdf](<file:///home/az/04-Library/03-Deep-Learning-and-Architectures/02-Architectures/LLMs-LRMs-Large-Language-Reasoning-Models/Architecture-Families/DeepSeek/DeepSeek-R1-Incentivizing-Reasoning-Capability-in-LLMs-via-Reinforcement-Learning-2026.pdf>)
- [Paper Directory: 📂 Open: DeepSeek](<file:///home/az/04-Library/03-Deep-Learning-and-Architectures/02-Architectures/LLMs-LRMs-Large-Language-Reasoning-Models/Architecture-Families/DeepSeek>)
- arXiv: [arXiv: DeepSeek-R1: Incentivizing Reasoning Capability in LLMs via Reinforcement Learning](https://arxiv.org/abs/2501.12948)
- [[DeepSeek-R1-Model-Local]]
- HuggingFace: [deepseek-ai/DeepSeek-R1 · Hugging Face](https://huggingface.co/deepseek-ai/DeepSeek-R1)
- HuggingFace: [HuggingFace: deepseek-ai (DeepSeek)](https://huggingface.co/deepseek-ai)
- GitHub: [GitHub: deepseek-ai/DeepSeek-R1 · GitHub](https://github.com/deepseek-ai/DeepSeek-R1/tree/main)

- [[Chain-of-Thought-Prompting-Elicits-Reasoning-in-LLMs]]
- [[Conceptual-Basics-LLMs-Mechanistic-Architecture]]
- [[Conceptual-Large-Reasoning-Models-LRMs-MI]]
- [[Conceptual-Basics-Anatomy-of-Compute-Feature-Manifolds-Circuit-Topologies]]
- 
---
### DeepSeek's Introduction 

> _We introduce our first-generation reasoning models, DeepSeek-R1-Zero and DeepSeek-R1
> DeepSeek-R1-Zero, a model trained via large-scale reinforcement learning (RL) without supervised fine-tuning (SFT) as a preliminary step, demonstrated remarkable performance on reasoning
> With RL, DeepSeek-R1-Zero naturally emerged with numerous powerful and interesting reasoning behaviors
> However, DeepSeek-R1-Zero encounters challenges such as endless repetition, poor readability, and language mixing
> To address these issues and further enhance reasoning performance, we introduce DeepSeek-R1, which incorporates cold-start data before RL
> DeepSeek-R1 achieves performance comparable to OpenAI-o1 across math, code, and reasoning tasks
> To support the research community, we have open-sourced DeepSeek-R1-Zero, DeepSeek-R1, and six dense models distilled from DeepSeek-R1 based on Llama and Qwen
> DeepSeek-R1-Distill-Qwen-32B outperforms OpenAI-o1-mini across various benchmarks, achieving new state-of-the-art results for dense models_

> [GitHub: deepseek-ai/DeepSeek-R1 · GitHub](https://github.com/deepseek-ai/DeepSeek-R1/tree/main?tab=readme-ov-file)

#### I. Released Full Models 

> DeepSeek-R1-Zero & DeepSeek-R1 are trained based on **DeepSeek-V3-Base**

> #deepseek-V3-V3_2 | [[DeepSeek-V3-V3.2-Technical-Report-Model-Architecture]]

|    **Model**     | **Total Params** | **Activated Params** | **Context Length** |
| :--------------: | :--------------: | :------------------: | :----------------: |
| DeepSeek-R1-Zero |       671B       |         37B          |        128K        |
|   DeepSeek-R1    |       671B       |         37B          |        128K        |
#### II. Released Distilled Models

|           **Model**           |                                   **Base Model**                                   |
| :---------------------------: | :--------------------------------------------------------------------------------: |
| DeepSeek-R1-Distill-Qwen-1.5B |         [Qwen2.5-Math-1.5B](https://huggingface.co/Qwen/Qwen2.5-Math-1.5B)         |
|  DeepSeek-R1-Distill-Qwen-7B  |           [Qwen2.5-Math-7B](https://huggingface.co/Qwen/Qwen2.5-Math-7B)           |
| DeepSeek-R1-Distill-Llama-8B  |           [Llama-3.1-8B](https://huggingface.co/meta-llama/Llama-3.1-8B)           |
| DeepSeek-R1-Distill-Qwen-14B  |               [Qwen2.5-14B](https://huggingface.co/Qwen/Qwen2.5-14B)               |
| DeepSeek-R1-Distill-Qwen-32B  |               [Qwen2.5-32B](https://huggingface.co/Qwen/Qwen2.5-32B)               |
| DeepSeek-R1-Distill-Llama-70B | [Llama-3.3-70B-Instruct](https://huggingface.co/meta-llama/Llama-3.3-70B-Instruct) |

---
### 2. Introduction 