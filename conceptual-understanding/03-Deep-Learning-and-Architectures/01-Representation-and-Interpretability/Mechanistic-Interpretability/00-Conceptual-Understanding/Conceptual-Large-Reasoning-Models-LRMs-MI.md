---
tags:
  - conceptual-explanations
  - large-reasoning-models-LRMs
  - llm-system_1-system_2
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
- [\[2509.13758v1\] A Study on Thinking Patterns of Large Reasoning Models in Code Generation](https://arxiv.org/abs/2509.13758v1)
- [Large Reasoning Models: The Complete Guide to Thinking AI (2025) \| by Nayeem Islam \| Medium](https://medium.com/@nomannayeem/large-reasoning-models-the-complete-guide-to-thinking-ai-2025-b07d252a1cca)
- [\[2509.13758v1\] A Study on Thinking Patterns of Large Reasoning Models in Code Generation](https://arxiv.org/abs/2509.13758v1)
- [\[2503.23077v2\] Efficient Inference for Large Reasoning Models: A Survey](https://arxiv.org/abs/2503.23077v2)
  
   **Adaptive Reasoning Suppression (ARS)**: Training-free approach that dynamically suppresses redundant reasoning steps, achieving up to 53% reduction in token usage, 46.1% in latency, and 57.9% in energy consumption (arXiv:2510.00071)
- **Process Reward Models (PRMs)**: Automated evaluation models that assess reasoning step quality, providing scalable alternatives to human feedback
- **Chain-of-Thought (CoT)**: Step-by-step reasoning methodology that encourages models to generate intermediate reasoning steps
- **Reinforcement Learning from Human Feedback (RLHF)**: Human-guided model optimization technique for aligning model outputs with human preferences
- **Atomic Reasoner Framework**: Cognitive inference strategy enabling fine-grained reasoning through atomic-level operations (arXiv:2503.15944)

- Comprehensive framework for constructing LRMs ➝ [arXiv: Reasoning Language Models: A Blueprint](https://arxiv.org/abs/2501.11223)
- 
- **A Survey of Efficient Reasoning for Large Reasoning Models** (arXiv:2503.21614): Review of methods to enhance reasoning efficiency
- **Training Language Models to Reason Efficiently** (arXiv:2502.04463): Techniques for dynamic compute allocation
- **ProofSketch: Efficient Verified Reasoning for Large Language Models** (arXiv:2510.24811): Verification-guided framework for reasoning
- OpenAI official documentation and release notes for o3, o3-mini, and o1 models
---
#### **Large Reasoning Models (LRMs): A Structural and Mechanistic Exhaustive Note**

Large Reasoning Models (LRMs)—epitomized by architectures like OpenAI's o1/o3 series and DeepSeek-R1—represent a fundamental architectural and paradigm shift from standard "System 1" generation to "System 2" deliberation. Instead of immediately mapping an input distribution to an output distribution in a single forward pass, LRMs allocate dynamic computational budgets during inference to explore, verify, and backtrack across latent cognitive pathways.

### System 1 vs System 2 

To understand this phrase, we have to look at how human cognitive psychology—specifically Daniel Kahneman’s dual-process theory—maps directly onto the weight and activation levels of neural networks.

When we say the transition from **System 1 generation** to **System 2 deliberation** is a "fundamental architectural and paradigm shift," we mean the model is no longer just guessing the next word based on a static reflex; it is dynamically building and navigating a structural search tree within its own activation space.

Here is the breakdown of this shift from first principles.

## **1. System 1 Generation: The Ballistic Forward Pass (Standard LLMs)**

In human psychology, System 1 is your fast, instinctive, and automatic brain. If someone asks you "What is 2+2?", you don't calculate it; you just _know_ it.

Mechanistically, a standard LLM operates entirely as a System 1 reflex.

- **Fixed Computational Depth:** When a prompt is embedded into the residual stream, it is fired through a fixed number of layers (e.g., 80 layers in Llama 3).
    
- **A Ballistic Trajectory:** The forward pass is like firing a cannonball. Once the input enters Layer 1, the computation follows a strict, unalterable trajectory through the attention heads and MLPs. The model has exactly 80 steps to project the input geometry into the correct output logits.
    
- **The Limitation:** If the problem is highly complex (e.g., "Prove Fermat's Last Theorem"), the model still only has those same 80 layers to solve it. It cannot pause to allocate more compute. If the necessary features are not immediately activated and moved into the output projection, the model will simply hallucinate the most statistically probable (but factually wrong) next token.
    

## **2. System 2 Deliberation: The Directed Manifold Walk (LRMs)**

System 2 is your slow, analytical, and deliberate brain. If someone asks you "What is 147 × 39?", you cannot rely on reflex. You need a council, intermediate steps, and the ability to catch your own mistakes.

Mechanistically, Large Reasoning Models (LRMs) achieve System 2 thinking by hacking the autoregressive nature of the transformer.

- **Dynamic Compute via the KV Cache:** Instead of trying to solve the problem in a single 80-layer forward pass, the model generates intermediate "thinking" tokens. Each generated token is folded back into the **KV (Key-Value) Cache**.
    
- **Expanding the State Space:** By writing its intermediate thoughts into the context window, the model is physically changing the geometric landscape it is operating in. When it processes the _next_ token, its attention heads can now read from the structured logic it just wrote in the previous steps.
    
- **Navigating the Manifold:** This shifts the process from a ballistic shot to a directed walk across the activation manifold. The model can explore a logical branch, trigger an internal "critique vector" that recognizes a mathematical contradiction, and then output tokens that effectively steer the generation vector away from the error (e.g., "Wait, this path is wrong, let me recalculate").
    

## **3. Why is this an "Architectural and Paradigm" Shift?**

It is a paradigm shift because we are no longer training models to minimize the cross-entropy loss of human text.

- **The SFT Paradigm (System 1):** Standard LLMs are trained via Supervised Fine-Tuning (SFT) to memorize the shortest path between an input and an output. They learn _heuristics_.
    
- **The RL Paradigm (System 2):** LRMs are trained via pure Reinforcement Learning to discover _search algorithms_. The model's weights are updated not to mimic a final answer, but to successfully execute internal mechanisms like backtracking, self-verification, and multi-branch exploration.
    

The architecture shifts from a system designed for **information retrieval** (pulling facts from dense MLP layers) to a system designed for **state-space exploration** (using the residual stream to verify logical consistency over time).

Here is the Explainer Protocol invoked for the **KV (Key-Value) Cache** and its role in System 2 deliberation, strictly from a Mechanistic Interpretability perspective.

---
### KV Cache: Role in System 2 
## **1. The Layman Explanation (What / Does / Why)**

**What it is:**

The KV Cache is the model’s dynamic, short-term working memory. If the model's static weights are its long-term memory (what it learned during training), the KV cache is the council it uses to remember the current conversation.

**What it does:**

When generating text, a transformer predicts one token at a time. To predict token 100, it needs context from the previous 99 tokens. Instead of recalculating the mathematical meaning of those 99 tokens from scratch every single time, it calculates their "Keys" and "Values" once and saves them in the cache. When token 100 is generated, it just asks the cache what happened previously.

**Why it matters for System 2 (LRMs):**

In standard LLMs, the KV cache just holds the prompt and the answer. In Large Reasoning Models (LRMs), the KV cache becomes a physical extension of the model's cognitive state space. When an LRM generates 2,000 tokens of intermediate "thinking" (System 2 deliberation), it is physically writing its hypotheses, mathematical proofs, and self-corrections into the cache. This allows the model to look back at step 3 while generating step 15, enabling it to catch logical contradictions without hallucinating.

---

## **2. Technical Jargon (Principal-Level Specs and Math Axioms)**

From a mechanistic standpoint, the KV cache is the geometric substrate that enables attention heads (specifically induction heads and circuit components) to perform search and retrieval across the time dimension.

During the forward pass at time step $t$, the input token $x_t$ is linearly projected into a Query ($q_t$), Key ($k_t$), and Value ($v_t$) vector for each attention head:

$$q_t = x_t W_Q$$

$$k_t = x_t W_K$$

$$v_t = x_t W_V$$

**The Caching Mechanism:**

Instead of recomputing the keys and values for all previous tokens $i < t$, the model retrieves the historical tensors from memory and concatenates the new projections:

$$K_t = [K_{t-1}; k_t]$$

$$V_t = [V_{t-1}; v_t]$$

The attention output for the current step is then computed using the active query against the entire cached history:

$$Attention(q_t, K_t, V_t) = softmax\left(\frac{q_t K_t^T}{\sqrt{d_k}}\right) V_t$$

**Mechanistic Implication in LRMs:**

- **Keys ($K$) as Latent Addresses:** The cached $K_t$ matrix acts as an indexed geometric landscape of the reasoning trace. If the model generated a premise earlier ("Assume $X=5$"), the key vector for those tokens occupies a specific subspace.
    
- **Queries ($q$) as Search Operations:** When the model generates a "verification" token later on, its $q_t$ acts as a directed search vector. The inner product $q_t K_t^T$ yields a high activation score if the current hypothesis needs to cross-reference the earlier premise.
    
- **Values ($V$) as State Payloads:** The $V_t$ vectors contain the actual semantic features. Once the attention mechanism zeroes in on the correct historical key, it retrieves the corresponding value vector and linearly adds it into the current residual stream, functionally moving the past logical state into the present computation.
    




---
---



Here is an exhaustive breakdown of LRMs, strictly prioritizing the mechanistic reality at the weight and activation levels.

---

## **1. The Core Paradigm: Test-Time Compute (TTC) Scaling**

Standard Large Language Models (LLMs) operate on fixed inference costs: the forward pass computation for a token is strictly bounded by the network depth and active parameters. LRMs introduce **Test-Time Compute (TTC) scaling** (or inference-time scaling), allowing the model to dynamically increase its reasoning budget based on the complexity of the prompt.

- **The Chain-of-Thought (CoT) Evolution:** While early CoT (Wei et al., 2022) relied on prompting a standard LLM to output intermediate steps, LRMs natively embed this recursive thought process into their training objective. The model generates highly structured reasoning traces, often evaluating multiple branches using internal search algorithms analogous to Monte Carlo Tree Search (MCTS), before converging on an answer.
    
- **Computational Trade-offs:** As test-time scaling becomes aggressive, the quadratic cost of the attention mechanism and the linear growth of the KV cache become severe bottlenecks (Vaswani et al., 2017). This necessitates either highly efficient Mixture-of-Experts (MoE) architectures (e.g., DeepSeek-R1 activating only 37B of its 671B parameters per token) or aggressive distillation into smaller dense networks (Guo et al., 2025).
    
    +1
    

## **2. The Training Mechanisms: RL-Driven Latent Discovery**

The most profound realization of the LRM era is that high-level reasoning is an emergent property of pure Reinforcement Learning (RL), not supervised human data.

- **Group Relative Policy Optimization (GRPO):** DeepSeek-R1-Zero bypassed Supervised Fine-Tuning (SFT) entirely, relying on GRPO. Unlike standard Proximal Policy Optimization (PPO), GRPO eliminates the need for a separate value network by computing the baseline from the average rewards of multiple outputs generated for the same query (Guo et al., 2025).
    
    +1
    
- **Emergent Latent Behaviors:** Through pure RL, the model spontaneously discovers behaviors like "reflection," "backtracking," and "self-correction." Mechanistically, the RL gradient updates sculpt the activation manifolds such that the model learns to isolate incorrect logical pathways, heavily penalize their representation, and steer the generation vector toward alternative hypothesis sub-spaces.
    

## **3. The Mechanistic Interpretability (MI) of LRMs**

Understanding LRMs requires moving past the raw text of their "thoughts" and looking at the geometric and causal structures governing their forward passes. Recent literature (Hu et al., 2026) has aggressively targeted the MI of these models.

**A. Pre-Planned Reasoning Strength (Directional Vectors)**

- A recent mechanistic analysis (NeurIPS, 2025) demonstrates that LRMs do not randomly decide to think longer. They pre-plan their reasoning strength in their early activations before generating the first reasoning token.
    
- By computing activation differences across problem difficulties, researchers isolated a pre-allocated directional vector in the latent space. The magnitude of this specific vector causally modulates the length of the reasoning chain. Linear probes on the residual stream can predict the required Test-Time Compute solely based on the question's initial activation geometry.
    
    +1
    

**B. The Latent Critique Mechanism**

- How does an LRM know it made a mistake during a long CoT? Phan et al. (2026) discovered that even when arithmetic errors propagate through the residual stream and corrupt intermediate text, the model can still route to the correct final answer.
    
- Through feature space analysis, they identified a highly interpretable **"critique vector"**. This vector activates when the model's internal representations conflict with the generated output. Steering the latent representation by amplifying this critique vector artificially enhances the model's error detection and self-verification capabilities, effectively boosting TTC performance without further training.
    
    +1
    

**C. Reasoning Hallucinations and Path Drift**

- LRMs are susceptible to "Path Drift," where the reasoning trajectory drifts from aligned paths due to input-induced semantic cues (e.g., first-person commitments like "I will...") bypassing internal safety checkpoints (ACL, 2025).
    
- To detect this mechanistically, Sun et al. (2026) introduced a "Reasoning Score." By projecting the late-layer representations directly into the vocabulary space via the unembedding matrix, they measure the divergence of the logits. Early-stage geometric fluctuations in these projections strongly correlate with shallow pattern-matching versus genuine deep reasoning, allowing for the mechanistic detection of "Reasoning Hallucinations" (where logically coherent text masks a factual breakdown in the underlying circuitry).
    
    +1
    

## **4. System Architecture & Distillation (The Ops Reality)**

For deployment (MLOps/LLMOps), serving a native 671B LRM is financially catastrophic for standard enterprise queries. The industry response is **Reasoning Distillation**.

- By generating millions of high-quality reasoning traces from the frontier model (DeepSeek-R1), researchers use SFT to distill these behaviors into smaller 7B, 14B, and 32B dense backbones (like Qwen or Llama).
    
- Fascinatingly, applying RL directly to smaller models often fails to yield deep reasoning, but distilling the outputs of an RL-trained MoE transfers the structural logic successfully. This implies the larger model maps out a highly complex, multi-basin optimization landscape that the smaller model can successfully memorize as a direct mapping, bypassing the need to structurally "discover" the reasoning from scratch.
    

---
### Citations

## **1. The LRM Architecture & Test-Time Compute (TTC)**

- **DeepSeek-R1 Architecture & RL Formulation:** DeepSeek-AI, Guo, D., Yang, D., et al. (2025). _DeepSeek-R1: Incentivizing Reasoning Capability in LLMs via Reinforcement Learning_. arXiv preprint arXiv:2501.12948.
    
    > _Relevance:_ The definitive paper on transitioning from SFT-based models to pure RL-driven reasoning (R1-Zero) and the cold-start hybrid approach (R1), establishing the modern LRM paradigm.
    
- **Test-Time Compute vs. Parameter Scaling:** Snell, C., Lee, J., Xu, K., & Kumar, A. (2024). _Scaling LLM Test-Time Compute Optimally can be More Effective than Scaling Model Parameters_. ICLR 2025 / arXiv preprint arXiv:2408.03314.
    
    > _Relevance:_ Proves the mathematical trade-off where dynamically allocating FLOPs at inference time via search algorithms (like MCTS or compute-optimal scaling) outperforms simply scaling the parameter count of the base model by 14x.
    
- **Chain-of-Thought (The Precursor to LRMs):** Wei, J., Wang, X., Schuurmans, D., et al. (2022). _Chain-of-thought prompting elicits reasoning in large language models_. Advances in Neural Information Processing Systems (NeurIPS).
    
    > _Relevance:_ The foundational paper that established the necessity of intermediate computational steps for complex logical resolution.
    
- **The Quadratic Bottleneck (Why LRMs need MoE):** Vaswani, A., Shazeer, N., Parmar, N., et al. (2017). _Attention is all you need_. Advances in Neural Information Processing Systems.
    
    > _Relevance:_ Explains the foundational $O(N^2)$ complexity of the attention mechanism, which dictates the strict limitations on the KV cache during the highly extended context windows required for LRM test-time computation.
    

## **2. Reinforcement Learning Mechanisms (GRPO)**

- **Group Relative Policy Optimization (GRPO):** Shao, Z., Wang, P., Zhu, Q., et al. (2024). _DeepSeekMath: Pushing the Limits of Mathematical Reasoning in Open Language Models_. arXiv preprint arXiv:2402.03300.
    
    > _Relevance:_ The original introduction of the GRPO algorithm. It explains the math behind eliminating the separate value network (critic) used in standard PPO and replacing it with a baseline calculated from the average rewards of multiple outputs generated for the same query.
    

## **3. Mechanistic Interpretability (MI) of Reasoning Models**

- **Mechanistic Interventions & Functional Flow in LRMs:**_(Various Authors)_ (2025). _From Reasoning to Answer: Empirical, Attention-Based and Mechanistic Insights into Distilled DeepSeek R1 Models_. arXiv preprint arXiv:2509.23676.
    
    > _Relevance:_ A critical mechanistic study that uses activation patching to prove the functional dependence of the final answer on the reasoning tokens. It proves that reasoning in R1 distilled models is not just "self-consistency" but a true causal flow where perturbing specific latent reasoning vectors reliably flips the final answer.
    
- **Reasoning as Simulated Multi-Agent Pathways:**_(Various Authors)_ (2026). _Reasoning Models Generate Societies of Thought_. arXiv preprint arXiv:2601.10825.
    
    > _Relevance:_ Uses mechanistic interpretability (specifically SAE feature steering on the DeepSeek-R1-Llama-8B distilled model) to show how LRMs allocate latent space to simulate diverse "perspectives." It isolates features responsible for "surprise" and "backtracking," proving that steering these specific activations directly improves verification and reduces hallucinations.
    
- **Locating Factual Associations (The Baseline for Causal Tracing):** Meng, K., Bau, D., Andonian, A., & Belinkov, Y. (2022). _Locating and Editing Factual Associations in GPT_. Advances in Neural Information Processing Systems (ROME).
    
    > _Relevance:_ The foundational framework for the activation patching and causal tracing techniques currently being used to isolate "critique vectors" and "reasoning circuits" inside modern LRMs.
    
---

The boundary between Large Language Models (LLMs) and Large Reasoning Models (LRMs) is not just a matter of scale or parameter count; it is a fundamental architectural and algorithmic divergence. If LLMs are optimized for statistical compression and reflex, LRMs are optimized for search, verification, and dynamic compute allocation.

Here is the exhaustive criteria for distinguishing an LRM from a standard LLM, grounded in their mechanistic and structural realities.

## **1. The Inference Paradigm: Fixed Compute vs. Test-Time Compute (TTC)**

The most definitive criterion is how the model handles computation during the forward pass.

- **LLMs (Fixed Compute):** Operate on a rigid, predictable computational budget. For a prompt of $N$ tokens, the computation required to generate the next token is strictly bound by the depth of the network and the active parameters. It is a "System 1" reflex—a direct mapping from the input manifold to the output distribution.
    
- **LRMs (Dynamic Test-Time Compute):** Decouple the complexity of the prompt from a fixed forward-pass cost. LRMs natively scale **Test-Time Compute (TTC)**. When faced with a complex prompt, the model dynamically allocates a larger computational budget—generating hundreds or thousands of intermediate "thinking" tokens—before ever committing to a final answer. The computational graph is allowed to expand based on the difficulty of the latent geometry it encounters.
    

## **2. The Training Objective: SFT vs. Process-Oriented RL**

The transition from LLM to LRM requires a complete overhaul of the loss landscape and training incentives.

- **LLMs (SFT & Outcome RLHF):** Primarily trained via Supervised Fine-Tuning (SFT) to mimic human text, followed by standard RLHF to align tone and safety. The reward is given based on the _final_ generated output. This encourages the model to memorize heuristic shortcuts rather than derive first principles.
    
- **LRMs (Pure RL & Process Reward Models):** LRMs are forged in pure Reinforcement Learning environments (like DeepSeek's GRPO) or heavily rely on Process Reward Models (PRMs).
    
    - Instead of rewarding the final answer, the RL objective penalizes logical fallacies in intermediate steps and rewards successful backtracking.
        
    - The model is not taught _what_ to say; the gradients naturally sculpt the activation space to discover search algorithms (like latent Monte Carlo Tree Search), hypothesis testing, and error-correction protocols on its own.
        

## **3. Mechanistic Signatures: Linear Flow vs. Latent Search**

From a Mechanistic Interpretability perspective, the internal activation geometries look completely different.

- **LLMs (Linear Propagation):** The residual stream builds a progressive representation of the next token. Features are retrieved from MLP layers and moved into the output projection linearly. If the model makes a factual error at Layer 10, it generally cascades, forcing the model to "hallucinate" a coherent but incorrect continuation.
    
- **LRMs (Non-Linear Trajectories & Critique Vectors):** The residual stream in an LRM exhibits non-linear "bouncing" between semantic subspaces.
    
    - **Self-Correction Circuitry:** LRMs possess active **critique vectors**. When the model generates a flawed internal premise, these specific features activate, suppressing the current reasoning trajectory and forcing a reset (e.g., generating text like _"Wait, that's incorrect, let's recalculate"_).
        
    - **Overthinking/Collapse Thresholds:** Mechanistic studies show that LRMs exhibit an "overthinking" phenomenon on simple tasks where they unnecessarily explore alternative branches, and a "collapse" threshold on hyper-complex tasks where the internal search tree exceeds the capacity of the working memory (KV cache).
        

## **4. The Structural Artifact: The "Thinking" Phase**

This is the observable, external criterion that defines modern LRMs (like OpenAI's o-series or DeepSeek-R1).

- **LLMs:** Generate standard text immediately. Any "reasoning" is implicit within the hidden states or relies on the user artificially prompting a Chain-of-Thought ("Let's think step by step").
    
- **LRMs:** Enforce a structural separation between the **reasoning trace** and the **final response**. They output a highly structured, self-contained thought process (often enclosed in `<think>...</think>` tags or hidden entirely via the API). This trace explicitly details scaffolding, flaw detection, style checks, and alternative exploration before producing the final, formatted output.


