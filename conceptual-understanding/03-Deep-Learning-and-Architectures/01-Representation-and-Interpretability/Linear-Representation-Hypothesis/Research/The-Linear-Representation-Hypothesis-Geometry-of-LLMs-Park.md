---
tags:
  - llm-internal-memory
  - llm-mechanistic-interpretability-linear-representation-hypothesis
  - llm-higher-dimension-space
  - llm-manifolds-geometric-perspective
  - llm-diagnostics
  - llm-neural-signatures
---



---
#### References
- [[Manifold-Geometry-of-Large-Language-Models]]
- arXiv ➝ [The Linear Representation Hypothesis and the Geometry of Large Language Models](https://arxiv.org/abs/2311.03658-)
- [NeurIPS The Linear Representation Hypothesis in Language Models](https://neurips.cc/virtual/2023/77537)
- [The Linear Representation Hypothesis and the Geometry of Large Language Models with Kiho Park - YouTube](https://www.youtube.com/watch?v=ko1xVcyDt8w)
- [[The-Origins-of-Representation-Manifolds-in-LLMs-Modell]]

---

#### **1. The Layman Explanation**

**What is it?**

Imagine the LLM's "brain" is a giant 3D map. The LRH states that concepts—like "Gender," "Tense," or "Language"—are not scattered randomly. Instead, they are straight arrows (vectors) on this map.

- **The Arrow:** If you travel North, the text becomes more "French." If you travel South, it becomes "English."
    
- **The Math:** This means you can do arithmetic with meaning. `King - Man + Woman = Queen` isn't just a metaphor; it's a literal coordinate instruction in the model's space.
    

**Why does it matter?**

If concepts are linear directions, we don't need to retrain the model to change its behavior. We can just "steer" it. If the model is being toxic, we find the "Toxic Arrow" and subtract it from the model's thought process.

#### **2. Technical Jargon (Principal Specs)**

**The Core Axiom:**

The hypothesis posits that a concept $W$ is represented by a direction $v_W$ such that the probability of an output $y$ changes log-linearly with the dot product of the representation $x$ and $v_W$.

**The Causal Inner Product:**

The paper solves a major geometric problem: "Standard Euclidean distance doesn't work in high dimensions." They introduce the **Causal Inner Product**, which measures similarity based on the model's _unembedding_ matrix $W_U$.

- Two concepts are "orthogonal" (independent) not if their angle is 90°, but if changing one does not affect the logits of the other via the unembedding layer.
    
- **Formula:** The influence is defined effectively by projecting the hidden state through the covariance of the unembedding vectors.
    

#### **3. Simple Code & Visualization**

Python

```
# Conceptual implementation of Linear Steering
def steer_concept(hidden_state, concept_vector, intensity):
    # hidden_state: The model's current "thought"
    # concept_vector: The specific direction for "Honesty" or "French"
    # intensity: How hard to push (coefficient)
    
    # The Hypothesis: Linearity holds
    steered_state = hidden_state + (intensity * concept_vector)
    
    return steered_state
```

Plaintext

```
       [ Concept Geometry ]

          (French)
             ^
             |
             |   / (Polite)
             |  /
             | /
  (English) -+------------> (Rude)
             |
             |
```

- **LRH says:** You can move strictly "North" (make it French) without drifting "East" (making it Rude), because the directions are disentangled.