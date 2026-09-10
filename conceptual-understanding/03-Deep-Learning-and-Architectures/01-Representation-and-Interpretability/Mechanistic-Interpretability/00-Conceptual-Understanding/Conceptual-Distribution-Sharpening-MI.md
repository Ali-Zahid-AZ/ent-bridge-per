---
tags:
  - large-reasoning-models-LRMs
  - lrm-distribution-sharpening
  - conceptual-explanations
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

- [[Conceptual-Large-Reasoning-Models-LRMs-MI]]
- [[Conceptual-Basics-Anatomy-of-Compute-Feature-Manifolds-Circuit-Topologies]]
  
  
---
### The Thermodynamic Collapse of the Logit Space

In Mechanistic Interpretability, **distribution sharpening** is the mathematical process of artificially reducing the entropy of a model's output probabilities, forcing it to become hyper-confident in its top predictions while ruthlessly suppressing alternative tokens.

To bypass the standard layman analogies and view this structurally, we must treat the final layer of the transformer as a system undergoing a thermodynamic phase transition.

---

## **1. The First Principle: The Statistical Mechanics of the Vocabulary**

When the final residual stream vector $x_f$ is multiplied by the unembedding matrix $W_U$, it projects the model's internal geometry into the vocabulary space, generating raw, unnormalized logits $z_i$. To convert these into probabilities, the model uses the softmax function, which is mathematically identical to the **Boltzmann distribution** in statistical mechanics.

The probability $p_i$ of selecting a specific token $i$ is defined as:

$$p_i = \frac{\exp(z_i / T)}{\sum_j \exp(z_j / T)}$$

Here, $T$ is the "Temperature" hyperparameter.

- **High Entropy (Paramagnetic State):** When $T = 1$ (or higher), the thermal energy of the system is high. The probabilities are relatively flat and smeared across the vocabulary. The model is exploring; multiple token pathways are statistically accessible.
    
- **Distribution Sharpening (The Phase Transition):** When we apply distribution sharpening by lowering the temperature ($T < 1$), we are effectively _quenching_ the system. As $T \to 0$, the exponential function dramatically amplifies the largest logit ($z_{max}$) and crushes the others. We force a spontaneous symmetry breaking—the probability distribution collapses from a disordered, probabilistic gas into a highly ordered, deterministic crystalline state where $p_{max} \approx 1$.
    

---

## **2. The Mechanistic Reality at the Activation Level**

From an MI perspective, distribution sharpening is a geometric distortion of the model's final output mapping.

- **Superposition and "Blurry" Vectors:** Often, the final activation vector in the residual stream does not point perfectly at a single concept in the $W_U$ matrix. Due to superposition, the vector might be a linear combination of several plausible next steps (e.g., $0.6 \cdot |\text{Equation}\rangle + 0.4 \cdot |\text{Text}\rangle$).
    
- **The Logit Lens View:** If we apply the logit lens without sharpening, we see the model "hedging its bets." The raw logits represent a superposition of thoughts.
    
- **The Amplification:** Sharpening artificially stretches the geometry. It takes the vector component with the highest magnitude and exponentially distances it from orthogonal noise. It is the mathematical enforcement of "Winner-Takes-All" dynamics at the very edge of the network.
    

---

## **3. Why LRMs Command Distribution Sharpening**

In standard LLMs, sharpening is just a user-toggled parameter to make the model less creative and more robotic. In **Large Reasoning Models (LRMs)**, distribution sharpening is a critical, dynamic survival mechanism during Test-Time Compute (TTC).

- **The Exploration vs. Exploitation Manifold:** When an LRM is in the early stages of a reasoning trace (System 2 deliberation), it needs a softer distribution to explore multiple branches of a latent Monte Carlo Tree Search. It needs the "thermal energy" to hypothesize.
    
- **The Collapse to Formal Logic:** However, once the model's internal _critique vector_ validates a specific mathematical or logical pathway, the model must transition to execution. If the model is outputting the steps of a rigid mathematical proof, it cannot afford "creativity" (entropy).
    
- **Algorithmic Sharpening (Contrastive Decoding):** Advanced systems do not just lower $T$; they use contrastive distribution sharpening. They compute the logits of a "strong" reasoning pathway and subtract the logits of an "amateur" pathway: $z_{final} = z_{expert} - \alpha \cdot z_{amateur}$. This mechanistically purges the probability space of common human errors, resulting in an ultra-sharp, hyper-aligned distribution that flawlessly executes the chosen algorithm.
---
---
Here are the foundational and cutting-edge citations that ground the concepts of distribution sharpening, temperature scaling, and contrastive decoding, specifically within the contexts of Large Language Models and Mechanistic Interpretability.

## **1. The Physics of the Output Layer: Softmax & Temperature**

The concept of treating the final probability distribution as a thermodynamic system (where temperature $T$ scales the logits) is foundational to modern deep learning, originally formalized to transfer knowledge between networks.

- **Distilling the Knowledge in a Neural Network**
    
    - _Authors:_ Geoffrey Hinton, Oriol Vinyals, Jeff Dean (2015).
        
    - _Relevance:_ The classic paper that introduced the explicit use of a "Temperature" hyperparameter in the softmax function for neural networks. It established the mathematical foundation for how raising $T$ creates a "softer" distribution to reveal the dark knowledge (secondary relationships) of a model, while lowering $T$ (distribution sharpening) forces a rigid, low-entropy collapse toward the top prediction.
        

## **2. Contrastive Decoding: Algorithmic Distribution Sharpening**

Contrastive Decoding is the formal mechanism for subtracting "amateur" or "noisy" logits from "expert" logits to artificially sharpen the distribution around high-quality logic.

- **Contrastive Decoding: Open-ended Text Generation as Optimization**
    
    - _Authors:_ Xiang Lisa Li, Ari Holtzman, et al. (ACL 2023 / originally arXiv 2022).
        
    - _Relevance:_ The foundational paper for Contrastive Decoding (CD). It mathematically proves that by subtracting the log-probabilities of a smaller model from a larger model, you aggressively penalize high-entropy, repetitive, or generic tokens. It frames decoding as an optimization problem where distribution sharpening directly eliminates "System 1" generation flaws.
        
- **Contrastive Decoding Improves Reasoning in Large Language Models**
    
    - _Authors:_ Sean O'Brien, Mike Lewis (2023).
        
    - _Relevance:_ This paper directly bridges CD to the System 2 deliberation we discussed. It proves that applying contrastive distribution sharpening out-of-the-box allows models to avoid abstract reasoning errors and perform significantly better on math and logic benchmarks (like GSM8K) compared to standard greedy decoding.
        
- **DoLa: Decoding by Contrasting Layers Improves Factuality in Large Language Models**
    
    - _Authors:_ Yung-Sung Chuang, et al. (ICLR 2024).
        
    - _Relevance:_ A brilliant mechanistic evolution of CD. Instead of using two different models, DoLa contrasts the logits projected from _early/middle layers_ against the logits from the _final layer_. It mechanistically sharpens the distribution by subtracting the model's own immature, early-layer "guesses" from its final, fully computed output, drastically reducing hallucinations.
        

## **3. The Logit Lens & Vocabulary Projection**

To mechanistically observe the "blurriness" or "sharpness" of a distribution before it hits the final unembedding matrix, the field relies on the Logit Lens framework.

- **interpreting gpt: the logit lens**
    
    - _Author:_ nostalgebraist (2020, Alignment Forum).
        
    - _Relevance:_ The origin of the Logit Lens. It demonstrated that you can multiply the intermediate residual stream vectors $x_l$ by the final unembedding matrix $W_U$ to see what the model is "thinking" at early layers, showing how the distribution starts as a high-entropy blur and sharpens as it moves deeper into the network.
        
- **Eliciting Latent Predictions from Transformers with the Tuned Lens**
    
    - _Authors:_ Nora Belrose, Zach Furman, et al. (2023).
        
    - _Relevance:_ A rigorous, peer-reviewed formalization of the Logit Lens. It addresses the geometric drift in the residual stream and proves how intermediate features are mapped to output distributions, providing the mechanistic baseline for understanding how and why distributions need to be sharpened during complex reasoning tasks.