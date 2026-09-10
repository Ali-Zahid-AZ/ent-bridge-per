---
tags:
  - deepseek
  - llmops-architecture
  - research-article
  - reading-list
topic: LLMs:Architectures
status: In Progress
---

---
```table-of-contents
```


---
### References
- [[DeepSeek-mHC-Manifold-Constrained-Hyper-Connections]]
- [[DeepSeek-Native-Sparse-Attention-Hardware-Aligned-and-Natively-Trainable-Sparse-Attention]]
- [[DeepSeek-R1-Incentivizing-Reasoning-Capability-in-LLMs-via-Reinforcement-Learning]]
- [[DeepSeek-V3-V3.2-Technical-Report-Model-Architecture]]
- [[DeepSeek-V3-V3.2-Technical-Report-Model-Architecture]]
- [[DeepSeekMoE-Towards-Ultimate-Expert-Specialization-in-Mixture-of-Experts-Language-Models]]

---
### I. Reasoning & Logic Flagships (The "Thinking" Models)

These models focus on Reinforcement Learning (RL) and search-based reasoning (CoT).

|**Paper Title**|**Key Innovation**|**Date**|**Link**|
|---|---|---|---|
|**DeepSeek-R1**|**GRPO** RL without SFT; emergent "aha moments."|Jan 2025|[arXiv:2501.12948](https://arxiv.org/abs/2501.12948)|
|**DeepSeekMath-V2**|Self-verifiable mathematical reasoning.|Nov 2025|[arXiv:2511.22570](https://arxiv.org/abs/2511.22570)|
|**DeepSeek-Prover-V2**|RL for subgoal decomposition in formal Lean 4.|Apr 2025|[arXiv:2504.21801](https://arxiv.org/abs/2504.21801)|
|**DeepSeekMath**|Introduction of **Group Relative Policy Optimization**.|Feb 2024|[arXiv:2402.03300](https://arxiv.org/abs/2402.03300)|

---
### II. Foundation & Architecture (The MoE Powerhouses)

The "backbone" research focusing on efficiency, sparse attention, and Multi-head Latent Attention (MLA).

|**Paper Title**|**Key Innovation**|**Date**|**Link**|
|---|---|---|---|
|**DeepSeek-V3.2**|Successor to V3; reasoning-first agentic core.|Dec 2025|[V3.2 Report](https://huggingface.co/deepseek-ai/DeepSeek-V3.2/resolve/main/assets/paper.pdf)|
|**DeepSeek-V3**|**MLA** + Auxiliary-Loss-Free MoE (671B params).|Dec 2024|[arXiv:2412.19437](https://arxiv.org/abs/2412.19437)|
|**Native Sparse Attention**|Hardware-aligned, natively trainable sparse attn.|Feb 2025|[arXiv:2502.11089](https://arxiv.org/abs/2502.11089)|
|**DeepSeek-V2**|Introduction of **DeepSeekMoE** & MLA.|May 2024|[arXiv:2405.04434](https://arxiv.org/abs/2405.04434)|
|**DeepSeekMoE**|Ultimate Expert Specialization (fine-grained MoE).|Jan 2024|[arXiv:2401.06066](https://arxiv.org/abs/2401.06066)|

---
### III. Multimodal, Vision & OCR (Visual-Causal Flow)

Focusing on decoupling visual encoding for better generation and understanding.

|**Paper Title**|**Key Innovation**|**Date**|**Link**|
|---|---|---|---|
|**DeepSeek-OCR 2**|**Visual Causal Flow** for document compression.|Jan 2026|[arXiv:2601.20552](https://arxiv.org/abs/2601.20552)|
|**Janus-Pro**|Scaling multimodal understanding & generation.|Jan 2025|[arXiv:2501.17811](https://arxiv.org/abs/2501.17811)|
|**DeepSeek-VL2**|MoE-based Vision-Language models.|Dec 2024|[arXiv:2412.10302](https://arxiv.org/abs/2412.10302)|
|**JanusFlow**|Harmonizing Autoregression & Rectified Flow.|Nov 2024|[arXiv:2411.07975](https://arxiv.org/abs/2411.07975)|
|**Janus**|Decoupling visual encoding pathways.|Oct 2024|[arXiv:2410.13848](https://arxiv.org/abs/2410.13848)|

---
### IV. Coding & Specialized Reasoning

|**Paper Title**|**Key Innovation**|**Date**|**Link**|
|---|---|---|---|
|**CodeI/O**|Reasoning patterns via Input-Output prediction.|Feb 2025|[arXiv:2502.07316](https://arxiv.org/abs/2502.07316)|
|**DeepSeek-Coder-V2**|Mixture-of-Experts for SOTA code intelligence.|Jun 2024|[arXiv:2406.11931](https://arxiv.org/abs/2406.11931)|
|**DeepSeek-Coder**|The "Rise of Code Intelligence" foundation.|Jan 2024|[arXiv:2401.14196](https://arxiv.org/abs/2401.14196)|

---
### V. Theoretical Highlight: The Manifold Connection

> **mHC: Manifold-Constrained Hyper-Connections**
> 
> - **Date:** Dec 31, 2025
>     
> - **Key Innovation:** Proposes a novel architecture where skip-connections (residual streams) are constrained by the **intrinsic manifold geometry** of the representation.
>     
> - **Physics Analogy:** This is essentially **Gauge Theory** applied to transformers—it ensures that the "parallel transport" of information doesn't deviate from the semantic manifold $\mathcal{M}$.
>     
> - **Link:** [arXiv:2512.24880](https://arxiv.org/abs/2512.24880)

---
### VI. Infrastructure & Hardware Insights

- **Fire-Flyer AI-HPC (Aug 2024):** Details their cost-effective software-hardware co-design using H800 clusters.
- **Insights into DeepSeek-V3 (May 2025):** A retrospective on scaling challenges and hardware reflections.