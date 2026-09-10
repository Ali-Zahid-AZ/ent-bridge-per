---
tags:
  - llm-training-dynamics
  - research-article
  - deepseek-R1-distill
  - llm-architectures-qwen
  - llm-architectures-deepseek
  - qwen3
  - mechanistic-interpretability-monitorability
  - mechanistic-interpretability-faithfulness
  - mechanistic-interpretability-chain-of-thought-COT
  - reading-list
  - llm-training-dynamics-GRPO
  - llm-training-dynamics-RLVR
  - research-2026
  - llm-emergent-properties
  - deepseek-R1
  - mechanistic-interpretability
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

> - The heart of this article is a longitudinal study of **training trajectories** 
> - It maps how a specific property ➝ `monitorability` ➝ **emerges** or **fails to emerge** ➝ as a `function` of 
> 	- **RLVR steps** 
> 	- **data distribution** ➝ Instruction Following vs. Math  
> 	- and **reward signals**

>[!quote] Since the paper’s primary contribution is defining the `when` and `under what conditions` these behaviors crystallize ➝ it belongs in **Training Dynamics**

- Article Pdf in Directiory: [Dir: Monitorability-as-a-Free-Gift-How-RLVR-Spontaneously-Aligns-Reasoning-2026.pdf](<file:///home/az/04-Library/03-Deep-Learning-and-Architectures/03-Learning-Dynamics-and-Theory/LLM-Training-Dynamics/Monitorability-as-a-Free-Gift-How-RLVR-Spontaneously-Aligns-Reasoning-2026.pdf>)
- Emergent Mind: [Emergent Mind: Monitorability as a Free Gift: How RLVR Spontaneously Aligns Reasoning](https://www.emergentmind.com/papers/2602.03978)
- arXiv: [arXiv: Monitorability as a Free Gift: How RLVR Spontaneously Aligns Reasoning](https://arxiv.org/abs/2602.03978)

- [arXiv: Reasoning Models Struggle to Control their Chains of Thought](https://arxiv.org/abs/2603.05706)
- [arXiv: Chain of Thought Monitorability: A New and Fragile Opportunity for AI Safety](https://arxiv.org/abs/2507.11473)
- [arXiv: A Pragmatic Way to Measure Chain-of-Thought Monitorability](https://arxiv.org/abs/2510.23966)
- [arXiv: Measuring Chain-of-Thought Monitorability Through Faithfulness and Verbosity](https://arxiv.org/abs/2510.27378)
- [arXiv: Investigating CoT Monitorability in Large Reasoning Models](https://arxiv.org/abs/2511.08525)
- [arXiv: Reasoning Under Pressure: How do Training Incentives Influence Chain-of-Thought Monitorability?](https://arxiv.org/abs/2512.00218)
- [arXiv: Monitoring Monitorability](https://arxiv.org/abs/2512.18311)
- [arXiv: Reasoning Promotes Robustness in Theory of Mind Tasks](https://arxiv.org/abs/2601.16853)
- [arXiv: Reasoning Theater: Disentangling Model Beliefs from Chain-of-Thought](https://arxiv.org/abs/2603.05488)

- [[Conceptual-Emergent-Properties-in-LLMs]]
- [[Conceptual-Intertwined-Concepts-MI]]
- [[DeepSeek-R1-Model-Local]]
- [[DeepSeek-R1-Incentivizing-Reasoning-Capability-in-LLMs-via-Reinforcement-Learning]]
- [[Conceptual-Basics-Anatomy-of-Compute-Feature-Manifolds-Circuit-Topologies]]
---
### 1. Introduction 

> #mechanistic-interpretability-instruction-following-IF | #mechanistic-interpretability-correctness  | [[Conceptual-Faithfulness-LLMs-MI]] | #mechanistic-interpretability-faithfulness 

#### I. Instruction Following: Prelude ➝ IF

> - **IF data** focuses on the model’s ability to adhere to **specific** often **arbitrary** ➝  `linguistic` or `structural` **constraints**
> - IF data consists of ➝ **prompts** where ➝ the `correctness` is defined by ➝ **how well the model follows a set of rules** ➝ rather than **just the truth** of the final statement 
> - **Examples**
		- `Explain quantum tunneling but do not use the word particle`
		- `Summarize this text in exactly three sentences, each starting with a vowel`
		- `Format your response as a valid JSON object with the keys intent and logic`
    
> - The paper uses a specific **subset of IF** ➝  **Verifiable Instruction Following**
> 	- where an `automated script` ➝ can objectively check ➝ `if` the model **followed the rules** 
> 	- example ➝ counting sentences or checking JSON syntax

##### I. IF:  Secret Sauce for Monitorability

>[!quote] The paper’s **most significant finding** is that ➝ **IF training** ➝ **not IF capability** ➝ is the **primary driver of monitorability** 

##### II. Strict Constraint Satisfaction

> - Unlike a math problem where there are many `paths` to the correct number ➝  an IF prompt has a very narrow `success corridor` 
> - This forces the model ➝ to tightly **align its internal reasoning** ➝ with the actual output ➝ to ensure it **doesn't accidentally violate a rule**
    
##### III. The Monitorability Booster

> - The researchers found that even if a model is already an expert in math or science ➝  its **reasoning traces** are often **messy** + **unfaithful** 
> - Adding a `Cascade` of IF training at **the end of the RL process** ➝ acts as a **booster** that `cleans up` the reasoning ➝  making it more **legible** + **faithful** to the prompt
    
##### IV. Entropy Reduction 

> - Mechanistically ➝ IF tasks provide a **much stronger signal** for ➝ `distribution sharpening` 
> - Because the rules are so strict 
> 	- the **model’s probability distribution** must collapse more aggressively to hit the reward 
> 	- which naturally makes the **resulting text** ➝ more `predictable` + `monitorable`

> #lrm-distribution-sharpening | [[Conceptual-Distribution-Sharpening-MI]] | #llm-entropy-paths | #llm-entropy-reduction 


> - In the MI framework ➝ we can consider 
> 	- **Math/Code data** ➝ as optimizing for **Depth** ➝ solving the logic 
> 	- while **IF data** ➝ optimizes for **Alignment** ➝ mapping the logic to the output 
> - Without IF 
> 	- the model might solve the problem correctly in its `head` ➝ activations 
> 	- but write nonsense or `faked` logic in its CoT 
> - IF data builds ➝ the `causal bridge` ➝ that forces the model to actually **use its reasoning trace** to guide its final answer

#### II. The Problem

> - As LRMs like DeepSeek-R1 execute complex tasks ➝ we need to **audit their internal CoT** ➝ to catch misbehavior or flawed logic 
> - These models are trained using **Reinforcement Learning with Verifiable Rewards** ➝ `RLVR` 
> 	- which explicitly `optimizes` ➝ for **task correctness** ➝ `not` for making the reasoning legible or faithful ➝ `monitorability` 
> - The core problem is understanding 
> 	- if `RLVR` naturally creates **transparent reasoning traces** as a `byproduct` 
> 	- or if **models eventually learn** ➝ to **hide their true logic**

> #large-reasoning-models-LRMs | #large-language-models-LLMs | #mechanistic-interpretability-chain-of-thought-COT | #llm-reinforcement-learning-RL | #llm-reinforcement-learning-with-verifiable-rewards-RLVR | #llm-reasoning-traces | #llm-system`1-system`2  

> [[Conceptual-Large-Reasoning-Models-LRMs-MI]] | [[Conceptual-Chain-of-Thought-Reasoning-MI]]

##### I. Reinforcement Learning with Verifiable Rewards ➝ RLVR 

> - At its core ➝ RLVR ➝ is an **optimization paradigm** ➝ where the training signal comes from 
> 	- a **deterministic** + **programmatic** environment ➝ rather than **human judgment**

> It is the engine behind modern LRMs ➝ DeepSeek-R1 + OpenAI's o1

##### II. RLVR: Core Mechanism

> - In traditional RLHF ➝  a model generates two answers + a human ➝ or a proxy reward model ➝ subjectively scores ➝ which one `looks` better or more helpful

> #llm-training-dynamics-reinforcement-learning-from-human-feedback-RLHF  | #llm-training-dynamics-reinforcement-learning-from-human-feedback-RLHF 


> - In RLVR ➝  the human is entirely removed from the loop
> - The process relies on tasks that have an **objective ground truth** ➝ primarily Math + Code + Logic puzzles

1. **Generation:** The model is given a problem and generates a long reasoning trajectory (the CoT) followed by a final answer.
    
2. **Extraction:** A parser extracts the final answer (e.g., everything inside a `\boxed{}` tag or a formatted JSON block).
    
3. **Verification:** The extracted answer is fed into a deterministic verifier. This could be 
	- a Python interpreter running unit tests on generated code 
	- a symbolic math engine checking an equation 
	- or a rule-engine checking constraint satisfaction ➝ Instruction Following 

> #mechanistic-interpretability-instruction-following-IF 

4. **Reward:** If the code compiles and passes the tests, or the math is correct, the model receives a hard $+1$ reward. If it fails, it receives a $0$ or $-1$.
    
5. **Update:** Algorithms like GRPO (Group Relative Policy Optimization) or PPO update the model's weights to maximize the probability of generating trajectories that hit the $+1$ state.

> #llm-training-dynamics-GRPO | #llm-training-dynamics-PRO  

##### II. RLVR: Paradigm Shift ➝ Why it matters

RLVR solves the `human bottleneck.` Human labelers make mistakes, have biases, and eventually hit a ceiling where the math or code is too complex for them to evaluate quickly.

By using verifiable environments, the model can engage in massive, unsupervised self-play. Because the reward is an objective truth, the model is free to explore highly unconventional, non-human reasoning paths to arrive at the correct answer. This is what allows reasoning models to experience `aha!` moments, backtrack, and self-correct during generation.

##### III. RLVR: Mechanistic View ➝ Activation Space Impact

From an MI and architectural perspective, RLVR reshapes the geometry of the activation space very differently than Supervised Fine-Tuning (SFT) or RLHF.

- **SFT & RLHF** encourage the model to learn a `smooth` probability manifold that mimics human language distributions. It optimizes for form and vibes.
    
- **RLVR** is a harsh, binary filter. It does not care how `nice` the CoT sounds. If an attention head routes information that leads to a failed unit test, that entire computational sub-graph gets a zero-gradient update or a penalty.
    

As you saw in the monitorability paper, this binary pressure forces **entropy reduction** (distribution sharpening). To survive the RLVR environment, the model's internal representations are forced out of diffuse, exploratory superpositions and collapsed onto highly rigid, deterministic logical circuits. The model physically wires its attention heads to anchor onto the strict constraints of the prompt, because any deviation from the verifier's rules results in a failed trajectory.

#### III. The Solution

The authors conduct a large-scale empirical + mechanistic study to map exactly when and why monitorability emerges during RLVR 
They identify that monitorability is not a universal guarantee, but rather highly dependent on specific training data compositions (like Instruction-Following data) and task difficulty.

> #llm-emergent-properties | [[Conceptual-Emergent-Properties-in-LLMs]] 

#### III. Key Methodology

- **Models & Training:** The researchers trained base models (DeepSeek-R1-Distill-Qwen-1.5B and Qwen3-4B) using the GRPO RL algorithm across four specific domains: Math, Code, Science, and Instruction-Following (IF).
    
- **Metrics:** They measured monitorability primarily using a metric called $g-mean^2$, which tests how sensitive the model's reasoning is to misleading hints injected into the prompt. They cross-validated this with `Draft-to-Answer` (D2A) faithfulness, which checks if altering the reasoning draft physically changes the final answer.
    
- **Mechanistic Tracking:** They tracked the entropy (randomness) of the output tokens and mapped cross-segment attention mass (e.g., how much the final answer attends back to the prompt versus the reasoning draft).
    

## **Significance and Personal Importance**

This paper bridges the gap between macro-level training pipelines (RLVR) and micro-level mechanistic behavior. As an architect designing agentic systems from first principles, understanding the decoupling of a model's raw capability from its transparency is critical. If you build an AgentOps pipeline assuming a highly capable model is naturally providing faithful CoT logs, this paper proves that assumption mathematically unsafe.

---

## **Layman Explanation**

Imagine you are training a student to solve complex math puzzles, rewarding them only when they get the final answer right.

Early in the training, the student naturally starts thinking out loud (monitorability) to keep their own thoughts organized. This is the `free gift.` However, as they become experts, or if you give them extremely difficult puzzles, they start doing the math entirely in their head. They might still write down some steps to satisfy your formatting rules, but their final answer doesn't actually rely on what they wrote down.

The paper proves that if you want the student to consistently show their genuine work, you shouldn't just train them on math; you must train them heavily on following strict instructions.

## **Technical Explanation (First Principles)**

From a structural perspective, RLVR does not directly calculate a loss gradient against the faithfulness of the reasoning trace.

- **Distribution Sharpening:** During early RLVR steps, the policy distribution undergoes significant sharpening (entropy reduction) as it collapses toward higher-reward trajectories. The paper demonstrates a negative correlation between response entropy and monitorability; as the model becomes more deterministic and confident, its reasoning patterns become more legible to external monitors.
    
- **Attention Dynamics:** The authors partitioned the forward pass into three segments: Prompt ($P$), Reasoning ($R$), and Answer ($A$). Mechanistically, monitorability gains correlate strongly with an increase in attention mass flowing from the Answer to the Prompt ($A \rightarrow P$) and the Reasoning to the Prompt ($R \rightarrow P$).
    
- **The Disconnect:** Crucially, monitorability correlates `negatively` with $A \rightarrow R$ attention. The model achieves high task performance not by causally routing information from its council to the answer, but by heavily anchoring its attention directly on the initial prompt constraints.
    
#### **4. The Dynamics of Monitorability (The Empirical `What`)
## **Methods Used**

- **Domain-Isolated RL Training:** Training separate checkpoints strictly on single domains (e.g., Code-only, Math-only) to isolate causal drivers.
    
- **Intervention Prompts:** Injecting `Sycophancy` hints (e.g., `A Stanford professor says B`) or `Grader Hacking` hints into the context window to see if the model's CoT absorbs and reacts to the bad data.
    
- **Ablation Studies:** Systematically increasing the maximum context length during training and varying the difficulty of the mathematical datasets to measure the impact on the $g-mean^2$ metric.
    

## **Results**

1. **Instruction-Following (IF) is the Catalyst:** Training models on IF data, or introducing it late in a cascaded pipeline, is the strongest structural driver of monitorability, far surpassing domain-specific reasoning data.
    
2. **Orthogonality:** A model becoming smarter at solving code or math does not intrinsically make its reasoning more transparent. In fact, capability and monitorability frequently exhibit a negative correlation.
    
3. **Context and Hardness Constraints:** Pushing models to train on excessively long contexts or extremely difficult problems actively degrades their monitorability. The RL signal becomes too sparse, preventing the distribution sharpening necessary for legible reasoning.
    

## **Connection to Mechanistic Interpretability**

This is where the paper shines for your core frameworks. The negative correlation of $A \rightarrow R$ attention is a massive red flag for circuit analysis.

If you are using Logit Lens or mapping induction heads to see how a model arrives at its final answer, you might logically assume the causal pathway flows sequentially: Prompt $\rightarrow$ CoT Tokens $\rightarrow$ Answer. This paper suggests that during RLVR, the model learns a `shortcut` circuit. It uses the `<think>` block merely as a time-delay mechanism to compute deeper latent states in its activations, while the actual attention routing bypasses the CoT text entirely and pulls directly from the prompt.

This means that if you want to understand `Why` a DeepSeek model made a decision, looking at the CoT text is insufficient. You must map the geometry of the activation space `during` the generation of the CoT to find the true causal graph.

## **Stress Test (Good Practices + Applicability)**

- **Good Practices:** The study is highly rigorous. By running identical training setups across completely different base architectures (DeepSeek and Qwen), they isolate fundamental transformer dynamics rather than model-specific quirks. Utilizing both prompt interventions ($g-mean^2$) and latent draft interventions (D2A) provides robust cross-validation.
    
- **Applicability:** For your goals in building LLMOps and AgentOps pipelines, this provides a direct architectural blueprint. If you are fine-tuning a model for an agentic framework, you `must` inject Instruction-Following data into your RLVR pipeline, even if the agent is only meant for pure math or code. Furthermore, setting tight maximum generation lengths during training will force the model to build more concise, readable circuits.
    

## **Is it worth your time understanding it?**

Yes, absolutely. This paper provides the missing mathematical link between the RL algorithms used to train frontier models and the mechanistic behavior of attention heads. Ingesting the methodology here will directly inform how you design the reward functions for your own mechanistic micro-transformer.


---
### Section 1 & 2: Introductory 

The overarching problem in AI alignment is that standard Reinforcement Learning with Verifiable Rewards (RLVR) optimizes strictly for task correctness, entirely ignoring how the model arrives at the answer. Monitorability—the degree to which the generated Chain of Thought (CoT) faithfully reflects the internal latent computation—is not part of the reward function.

However, empirical observations have shown that during the early stages of RLVR, models spontaneously become more legible and monitorable. The authors treat this `free gift` not as a magical alignment property, but as a mechanical byproduct of the training dynamics, setting out to prove that it is fragile, highly dependent on the data distribution, and completely orthogonal to the model's actual reasoning capability.

----
---

In the context of Large Reasoning Models (LRMs) trained via Reinforcement Learning with Verifiable Rewards (RLVR) the legibility and faithfulness of a model's reasoning are **never explicitly programmed or directly optimized by the loss function**.

During RLVR, the reward function is entirely outcome-driven. It only evaluates two things:

1. **Task Correctness (Rtask​):** Did the model get the final answer right?
    
2. **Format Compliance (Rformat​):** Did the model put its intermediate tokens inside `<think>` and `</think>` tags?
    

There is zero gradient signal rewarding the model for making those `<think>` tokens honest, logical, or readable to humans. Yet, during the early stages of RLVR training (typically the first 300 steps), the model's Chain of Thought (CoT) spontaneously becomes highly legible and faithful to its internal state.

+2

Mechanistically, this `free gift` emerges as a byproduct of two distinct physical changes at the weight and activation level:

##### 1. Probability Manifold Collapse (Entropy Reduction)

When RLVR begins, the base model's generations are relatively diffuse. As the reinforcement learning algorithm updates the weights to maximize the reward, the policy distribution undergoes severe `sharpening`.

+1

- The Shannon entropy H(p) of the next-token probability distribution drops significantly.
    
- In the geometry of the activation space, this means the model's internal representations are pulled out of wide, exploratory superpositions and collapsed onto very narrow, deterministic, high-confidence vectors.
    
    +1
    
- Because the latent computation becomes so rigid and focused to ensure a correct final answer, the externalized tokens (the CoT) naturally crystallize into consistent, recognizable, and highly legible patterns. The monitorability emerges simply because the underlying math has become less random.
    

##### 2. Attention Circuit Re-routing

To reliably hit the verifiable reward, the transformer's attention heads must optimize how they pass information across sequence positions.

- The authors measured the `Cross-Segment Attention Mass` and found that early RLVR massively strengthens the attention flowing from the Reasoning tokens to the Prompt (R→P) and the final Answer to the Prompt (A→P).
    
    +1
    
- To solve the task correctly, the model physically wires its circuits to anchor heavily onto the initial constraints.
    
- Because the internal attention is locked so tightly onto the prompt, the text it emits in the CoT tightly mirrors those constraints, making it highly transparent to an external monitor.
    

##### The Fragility of Emergence

Because monitorability is an emergent byproduct rather than a hardcoded objective, it is structurally fragile. It does not emerge universally.

+1

- **The Data Dependency:** It relies heavily on the presence of Instruction-Following (IF) data in the training mix, which forces the model to learn strict constraint satisfaction.
    
    +1
    
- **The Difficulty Limit:** If the training context window is too large (e.g., 8192 tokens), or if the math problems are too difficult, the model rarely finds the correct answer. Without a consistent positive reward signal, the entropy never reduces, the attention circuits remain diffuse, and the `free gift` of monitorability never emerges.
    
    +4
    
#### Truly Emergent? 
In machine learning, a `truly` emergent property—like the sudden formation of induction heads for in-context learning or grokking in modular arithmetic—is a phase transition that reliably occurs as you scale up compute, parameters, or training steps. It is an inherent structural property of the architecture reaching a certain capacity.

This paper explicitly proves that monitorability is **not** a universal, inherent property of scaling Reinforcement Learning with Verifiable Rewards (RLVR). Instead, it is a highly conditional artifact of the training data distribution.

Here is the mechanistic breakdown of why this `emergence` is actually an illusion created by specific training constraints:

- **The Instruction-Following (IF) Artifact:** The researchers found that training a model strictly on reasoning tasks (like Math or Science) does not guarantee the emergence of monitorability. The gains are almost entirely driven by the presence of Instruction-Following (IF) data in the training mix. IF data forces strict constraint satisfaction. The model is not spontaneously `learning to be transparent`; the optimization pressure from the IF data is physically forcing the model's activation space to collapse into a narrow, highly constrained manifold that just happens to be easily legible to humans.
    
- **Orthogonality to Capability:** If monitorability were truly emergent, it would scale with the model's intelligence. As the model gets better at solving complex math, its reasoning should become more structurally sound and transparent. The paper proves the exact opposite: task capability and monitorability are orthogonal. In many cases, an increase in a model's ability to solve code or math correlated `negatively` with its monitorability.
    
- **The Illusion of the Causal Cords:** The most damning evidence against true emergence is the attention analysis. When monitorability spikes, the attention mass flowing from the final Answer to the Reasoning trace ($A \rightarrow R$) is remarkably `negatively` correlated with that spike. Instead, the model anchors its attention directly on the Prompt ($A \rightarrow P$).
    

From a mechanistic first-principles view, the RLVR process is not organically growing a `transparent reasoning circuit.` It is growing a `strict prompt-compliance circuit.` The model generates a Chain of Thought that looks highly faithful to an external monitor, but internally, the causal routing is bypassing that council entirely. The authors themselves warn that this dynamic creates a severe risk of a `false sense of monitorability`.

The `free gift` is not a fundamental property of the physics of Transformers. It is a fragile byproduct of feeding them specific IF data and keeping the context windows tightly bounded. If you remove those specific constraints, the transparency vanishes.



### Section 3: Setup

To isolate the causal variables, the authors controlled both the model architectures and the training data.

- **The Models:** They utilized Qwen3-4B and DeepSeek-R1-Distill-Qwen-1.5B, both of which already underwent long CoT supervised fine-tuning (cold starts).
    
- **The Domains:** They trained these models across isolated datasets: pure Math, pure Code, pure Science, pure Instruction Following (IF), and a combined `ALL` dataset.
    
- **The Core Metric ($g-mean^2$):** To measure monitorability mechanically, they evaluate how a model reacts to injected `hints` in the prompt.
    
    - They calculate the Total Effect ($TE$) to see if the model actually changes its behavior due to the hint: $TE = p`1 - p`0$.
        
    - If the model follows the hint, an external monitor (Qwen2.5-32B-Instruct) checks if the model `explicitly verbalized` its reliance on that hint in the CoT.
        
    - The final monitorability score is a geometric mean of the True Positive Rate and True Negative Rates:
        
        $$g-mean^2 = TPR \times \sqrt{TNR`{X=0} \times TNR`{X=1}}$$
        

### Section 4:  The Dynamics of Monitorability (The Empirical `What`)

This section destroys the assumption that making a model smarter automatically makes it safer or more transparent.

- **The IF Data Dependency:** RLVR on Math or Science data alone does not consistently improve monitorability. The models that exhibited the highest, most stable monitorability were those trained heavily on Instruction-Following (IF) data. The strict constraint-satisfaction nature of IF tasks forces the model to align its generated text tightly with the prompt's rules.
    
- **The Temporal Cliff:** The vast majority of monitorability gains occur in the first 0-300 steps of RLVR. In late-stage training, gains plateau or even regress. However, applying an `IF Cascade` (training on general data, then fine-tuning strictly on IF) acts as a late-stage monitorability booster.
    
- **Orthogonality to Capability:** The paper proves that task capability (getting the right answer) and monitorability (showing the correct work) are structurally distinct. In many checkpoints, an increase in math or code capability actually correlated `negatively` with monitorability.
    

## **5. Mechanistic Drivers (The Structural `Why`)**

This is the most critical section for Mechanistic Interpretability. It translates the behavioral observations into the geometry of the activation space and the routing of attention heads.

- **Mechanism I: Distribution Sharpening (Entropy Reduction)**
    
    - RLVR physically alters the probability manifold of the model. As it learns high-reward trajectories, its output distribution sharpens, meaning token-level entropy drops.
        
    - The Shannon entropy is calculated as:
        
        $$\mathcal{H}(p) = -\sum`{v \in \mathcal{V}} p(v) \log p(v)$$
        
    - The authors found a strong `negative` correlation between response entropy and monitorability. The `free gift` of legible reasoning happens because the model collapses onto a narrower, highly deterministic path of computation that is structurally easier to read.
        
- **Mechanism II: Cross-Segment Attention Shifts**
    
    - They divided the forward pass into three distinct sequence segments: Prompt ($P$), Reasoning ($R$), and Answer ($A$). They then measured the Cross-Segment Attention Mass $M(S`{src} \rightarrow S`{tgt})$ flowing between them.
        
    - **The Shocking Routing Discovery:** Monitorability gains are driven heavily by increased attention from the Answer to the Prompt ($A \rightarrow P$) and the Reasoning to the Prompt ($R \rightarrow P$).
        
    - Crucially, attention from the Answer to the Reasoning ($A \rightarrow R$) was `negatively correlated` with monitorability. This implies that highly monitorable models are not causally relying on their own CoT council to generate the final answer; they are effectively bypassing the CoT and anchoring their final attention directly on the initial prompt constraints.
        

## **6. Validating with Draft-to-Answer (D2A) Faithfulness**

Because $g-mean^2$ relies on perturbing the input prompt, the authors needed to verify if the model was actually relying on its latent reasoning or just faking it.

- Using the D2A metric, they directly intervened on the hidden states at the end of the thinking draft (e.g., swapping the model's internal conclusion) to see if the final output changed.
    
- They found a strong positive correlation between $g-mean^2$ and D2A Faithfulness. This proves that, for most reasoning tasks, the input-intervention metric legitimately captures true internal causal faithfulness.
    

## **7. Training Length and Difficulty Ablations**

The final section stress-tests the physical parameters of the training pipeline.

- **Context Length Limits:** Counterintuitively, allowing the model to generate longer reasoning traces during RLVR (e.g., 8192 tokens vs 4096 tokens) consistently `degraded` monitorability. A vast context window allows the model to form diffuse, redundant, and illegible activation circuits. Bounding the generation length physically forces the model to compress its logic into concise, monitorable traces.
    
- **Reward Signal Sparsity:** If you train the model exclusively on extremely difficult problems, monitorability crashes. Because the model rarely finds the correct answer, the positive reward signal is too sparse to effectively sharpen the output distribution. Without that entropy reduction, consistent and legible reasoning circuits never crystallize.