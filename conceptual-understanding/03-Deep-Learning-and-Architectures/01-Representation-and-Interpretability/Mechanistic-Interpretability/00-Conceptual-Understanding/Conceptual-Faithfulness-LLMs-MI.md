---
tags:
  - mechanistic-interpretability
  - conceptual-explanations
  - mechanistic-interpretability-faithfulness
  - reading-list
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
- [[Conceptual-Intertwined-Concepts-MI]]
- 
  
  
---
## **Faithfulness in Mechanistic Interpretability: A Structural Analysis**

In Mechanistic Interpretability (MI), **faithfulness** is the measure of how accurately a hypothesized interpretability artifact—whether a computational circuit, a decoded feature, or a geometric manifold mapping—reflects the _true causal mechanisms_ executing within the model's forward pass.

It is the strict boundary between "plausibility" (explanations that make sense to human intuition) and "causality" (explanations that mathematically govern the weight-level and activation-level reality of the network).

---

## **1. The First Principles of Faithfulness vs. Correlation**

A fundamental trap in MI is confusing correlational observations with causal reality.

- **The Logit Lens Limitation:** Applying the logit lens to early layers might show that the residual stream geometrically contains the concept of "Paris" at Layer 4. While this is mathematically true (the projection of the activation onto the unembedding matrix yields a high probability for "Paris"), it is not inherently _faithful_ to the model's computation.
    
- **The Read/Write Problem:** The logit lens proves the information is written into the stream, but it does not prove that subsequent attention heads or MLP layers actually _read_ that specific subspace to generate the final output.
    
- **The Causal Imperative:** Faithfulness requires proving that if the specific projection or circuit is altered, the model's behavioral output changes in a predictable, mathematically correlated manner.
    

---

## **2. Measuring Faithfulness in Circuit Analysis**

When we define a subgraph of the model (e.g., an Indirect Object Identification (IOI) circuit or a set of Induction Heads), we are establishing a hypothesis graph Ghyp​. Faithfulness is tested by proving Ghyp​ is causally responsible for the output of the true model graph Gtrue​.

- **Activation Patching (Causal Tracing):** This is the foundational method for isolating faithful components. It involves a "clean" run (which elicits the target behavior) and a "corrupted" run (which suppresses it). By patching activations from the clean residual stream into the corrupted stream at specific layers and heads, we measure the direct causal impact on the output logits. If patching a specific attention head's output perfectly restores the target logit, that head is a faithful participant in the circuit.
    
- **Causal Scrubbing (Chan et al., 2022):** This is a formalized, algorithmic stress-test for faithfulness. It tests a hypothesis by systematically resampling (scrubbing) the activations of every node and edge _outside_ of Ghyp​ with activations from different contexts.
    
- **The Scrubbing Metric:** If Ghyp​ is perfectly faithful, the model's performance on the specific behavioral task should remain statistically identical even when the rest of the network is fed randomized or corrupted data. The metric is usually a comparison of expected loss or KL divergence: DKL​(Ptrue​∣∣Pscrubbed​).
    

---

## **3. Faithfulness in Superposition and Sparse Autoencoders (SAEs)**

As we move from analyzing individual attention heads to dissecting the dense geometry of activation spaces, faithfulness is applied to the features we extract from superposition.

- **The Superposition Hypothesis:** Models represent a number of features f that is strictly greater than the dimensional capacity d of their residual stream (f≫d), packing them into nearly orthogonal geometric subspaces.
    
- **SAE Reconstruction:** Sparse Autoencoders are trained to reconstruct the original dense activation x into a sparse, interpretable linear combination of features: x^=∑i​fi​di​.
    
- **Loss Recovered as a Faithfulness Metric:** To prove the SAE features are faithful to the model's internal ontology, we perform a zero-ablation replacement during the forward pass. We replace the true activation x with the SAE reconstruction x^. The faithfulness is measured by the **Cross-Entropy Loss Recovered**. If replacing the true activations with the SAE's geometric mapping recovers 95% of the loss compared to a zero-ablated baseline, the SAE features are highly faithful representations of the model's true computational primitives (Bricken et al., 2023).
    

---

## **4. The Core Challenges to Faithfulness**

Proving faithfulness is often obstructed by the model's own architectural resilience.

- **Hydra Effects and Self-Repair:** Transformer architectures exhibit highly distributed computation. If you perfectly ablate a faithful node (e.g., a primary name-mover head in an IOI circuit), subsequent layers often possess "backup heads" that recognize the missing information and dynamically self-repair the computation.
    
- **The False Negative Problem:** Because of self-repair, standard zero-ablations or mean-ablations can yield false negatives. A component might be mathematically critical to the standard forward pass, but its ablation causes no drop in performance because the model routes around the damage. This requires highly targeted path-patching (intervening on specific edges rather than whole nodes) to establish true faithfulness.
    

---

## Citations

- **Anthropic's Mathematical Framework for Transformer Circuits (Elhage et al., 2021):** Established the groundwork for viewing transformers as linear combinations of independent read/write operations, making causal tracing possible.
    
- **Locating and Editing Factual Associations in GPT (Meng et al., 2022 - ROME):** Formalized the use of activation patching (causal tracing) to identify the exact faithful locations of factual recall within MLP layers.
    
- **Interpretability in the Wild (Wang et al., 2022):** The gold standard for end-to-end faithful circuit discovery, mapping the exact geometric and mechanical flow of the IOI circuit.
    
- **Causal Scrubbing (Chan et al., 2022 / Redwood Research):** Defined the rigorous mathematical algorithm for testing the behavioral faithfulness of interpretability hypotheses.
    
- **Towards Monosemanticity (Bricken et al., 2023 / Anthropic):** Established the architecture for SAEs and formalized the "loss recovered" metric for evaluating the causal faithfulness of dictionary learning features.

---
---

## **Daniel Kahneman’s Dual-Process Theory: The Mechanics of Human Computation**

At its core, Daniel Kahneman’s dual-process theory (popularized in his book _Thinking, Fast and Slow_) is not just a psychological framework; it is a structural model of how the human brain allocates finite computational resources. It posits that human cognition is governed by two fundamentally different, yet deeply entangled, processing architectures: **System 1** and **System 2**.

To understand this from first principles, we must view the brain as an energy-constrained biological processor that must constantly balance the speed of execution against the accuracy of the output.

---

## **1. System 1: The Associative Heuristic Network**

System 1 is the brain’s default operating system. It is the fast, automatic, and largely unconscious biological forward-pass.

- **The Architecture of Reflex:** System 1 does not compute answers; it retrieves them from a highly optimized, pre-trained associative memory matrix. When you recognize a face, read a word on a billboard, or flinch from a sudden noise, System 1 is executing. It operates continuously, involuntarily, and with almost zero sensation of deliberate effort.
    
- **Heuristics and Pattern Matching:** Because the brain cannot afford the metabolic cost of fully analyzing every sensory input, System 1 relies on heuristics (cognitive shortcuts). It is an aggressive pattern-matcher that substitutes complex questions with simpler ones. If asked, "Is this investment safe?", System 1 might subconsciously substitute the question with, "Do I like the person selling this investment?"
    
- **The Cost of Speed:** The vulnerability of System 1 is its susceptibility to systemic errors and biases. It is structurally incapable of complex logic or statistical reasoning. It believes what it sees (a principle Kahneman calls _WYSIATI_: What You See Is All There Is) and jumps to conclusions based on the highest-probability associations available in its immediate memory retrieval.
    

## **2. System 2: The Sequential Algorithmic Processor**

System 2 is the slow, deliberate, and conscious analytical engine. It is the cognitive equivalent of a test-time compute protocol that dynamically allocates working memory to solve novel or complex problems.

- **Conscious Allocation of Attention:** System 2 is mobilized when you are asked to calculate $17 \times 24$, park in a tight space, or evaluate a complex logical argument. It requires strict, unbroken attention. If your attention is disrupted, the System 2 computation collapses and must be restarted.
    
- **The Constraint of Working Memory:** Unlike System 1, which processes massive amounts of parallel sensory data, System 2 is a serial processor bottlenecked by human working memory (our biological KV cache). It can only hold and manipulate a few variables at a time.
    
- **Metabolic Expense:** Operating System 2 physically dilates the pupils, elevates the heart rate, and aggressively consumes glucose. Because it is so metabolically expensive, it is inherently lazy by design.
    

## **3. The Interface: The Law of Least Effort**

The genius of Kahneman's framework lies in how these two systems interact to form human consciousness.

- **The Division of Labor:** System 1 continuously monitors the environment and generates a stream of impressions, intuitions, and impulses. When all is running smoothly, System 2 adopts these suggestions with little or no modification. You act on System 1's impulses.
    
- **The Trigger Condition:** System 2 is only activated when System 1 encounters an anomaly—a problem it cannot pattern-match its way out of, or an event that violates its predictive model of the world. System 2 acts as the overriding supervisor, capable of halting System 1's automatic impulses and replacing them with calculated logic.
    
- **Cognitive Laziness:** Because System 2 requires so much energy, the brain operates on the "Law of Least Effort." System 2 will frequently endorse System 1's flawed, heuristic-driven answers rather than expend the energy required to rigorously verify them. This systemic laziness is the root cause of most human cognitive biases.
    

---

## **4. The Architectural Bridge to Artificial Intelligence**

Understanding this biological framework reveals exactly why the AI industry is shifting its architectural paradigms.

When we train standard LLMs, we are artificially replicating **System 1**. We train a massive associative network to instinctively map an input space to an output space with extreme speed, relying on statistical heuristics. It is brilliant at pattern matching, but it hallucinates when faced with complex logic because, structurally, it possesses no System 2 to override its first instinct.

Large Reasoning Models (LRMs) are the attempt to synthetically build **System 2**. By forcing the model to halt its ballistic forward pass, allocate dynamic compute, and logically verify its own intermediate "thoughts" against a set of constraints, we are mechanically reproducing the deliberate, sequential, and energy-intensive cognitive architecture that Kahneman defined.