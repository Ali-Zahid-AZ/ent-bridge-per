---
tags:
  - reading-list
  - mechanistic-interpretability
  - mechanistic-interpretability-techniques
  - mechanistic-interpretability-linear-probes
  - llm-manifolds-geometric-perspective
---

---
```table-of-contents
```
---
### References

- [[Conceptual-Axiom-MI-Geometric-Constraints]]
---

**Linear Probes in Large Language Models – A Manifold Perspective**

**Abstract**

Linear probing is the primary diagnostic instrument in the field of _Mechanistic Interpretability_. It operates on the hypothesis that High-Dimensional Neural Networks (like LLMs) encode semantic concepts (syntax, truth, sentiment, space, time) as linear directions within their activation space. This review synthesizes the mathematical foundations of linear probes, deriving their efficacy from the _Linear Representation Hypothesis_ and the _Manifold Hypothesis_. We critically examine the methodology, potential pitfalls (selectivity vs. capacity), and recent breakthroughs in "World Modeling" (Othello-GPT).

---

### **I. The Layman Explanation: The MRI of the AI Mind**

**The Context**

If an LLM is a brain, the "activation space" is the electrical firing pattern of its neurons. We can see the neurons firing, but we don't know what they mean.

**The Phenomenon**

Imagine we want to know if the LLM knows a specific concept, like "is this sentence angry?" We freeze the model and look at its internal state (activations) while it reads 1,000 angry sentences and 1,000 happy sentences.

We find that we can draw a straight line (a hyperplane) through the high-dimensional space that perfectly separates the "angry" states from the "happy" states.

**The "Linear Probe"**

This "straight line" is the Linear Probe. It is a simple tool (like a thermometer or a compass) inserted into the complex machine.

- **Why Linear?** If we used a complex, non-linear tool (like a separate neural network) to read the activations, that tool might learn to figure out the answer on its own, cheating the test. A linear tool is too simple to "think"; it can only report what is _already explicit_ in the LLM's brain.
    

**The Insight**

The fact that simple linear probes work tells us something profound about LLMs: **They organize concepts linearly.** To the LLM, "Happy" is one direction, and "Angry" is the opposite direction.

---

### **II. Technical Jargon: Axioms, Geometry, and Control**

We derive the validity of linear probes from two fundamental axioms regarding the geometry of High-Dimensional Data.

#### **1. First Principles & Axioms**

- **Axiom 1: The Linear Representation Hypothesis (LRH)**
    
    Neural networks represent high-level concepts as linear directions in activation space.
    
    If a concept $C$ (e.g., "Gender") is binary, there exists a vector $\vec{v}_C \in \mathbb{R}^d$ such that for any input $x$, the activation $h(x)$ satisfies:
    
    $$C(x) \approx \langle h(x), \vec{v}_C \rangle$$
    
    _Citation:_ _Elhage, N., et al. (2022). "Toy Models of Superposition."_
    
- **Axiom 2: The Manifold Hypothesis (Locally Euclidean)**
    
    The valid data distribution resides on a low-dimensional manifold $\mathcal{M}$ embedded in $\mathbb{R}^d$. While $\mathcal{M}$ may be globally curved, the _semantic transitions_ between states often manifest as global linear translations (Euclidean vectors) due to the constraints of the residual stream.
    
    _Citation:_ _Bengio, Y., et al. (2013). "Representation Learning: A Review and New Perspectives."_
    

#### **2. Mathematical Formulation of the Probe**

A linear probe is a classifier $f$ parameterized by a weight vector $\theta \in \mathbb{R}^d$ and bias $b \in \mathbb{R}$.

Given a dataset of hidden states $H = \{h_1, h_2, ..., h_N\}$ and labels $Y = \{y_1, y_2, ..., y_N\}$:

$$P(y|h) = \sigma(\theta^T h + b)$$

Where $\sigma$ is the sigmoid function (for binary) or Softmax (for multiclass).

The probe is trained by minimizing the Cross-Entropy Loss $\mathcal{L}$ with respect to $\theta$, while keeping the LLM parameters **frozen**:

$$\theta^* = \arg\min_{\theta} \sum_{i} \mathcal{L}(f(h_i), y_i)$$

_Citation:_ _Alain, G., & Bengio, Y. (2016). "Understanding intermediate layers using linear classifier probes."_ (This is the seminal paper establishing the technique).

#### **3. The Control Problem: Selectivity vs. Capacity**

A major criticism of probing is: _Does the probe find the concept, or does it learn the concept?_

If the probe has high capacity (too complex), it might memorize the mapping. To prove the LLM actually knows the concept, we use **Control Tasks**.

- **The Hewitt-Liang Protocol:**
    
    We define a "Selectivity" metric. We compare the probe's accuracy on the real task ($Acc_{task}$) vs. a control task ($Acc_{control}$) where labels are randomized but fixed to word types.
    
    $$\text{Selectivity} = Acc_{task} - Acc_{control}$$
    
    A high selectivity implies the information is strictly geometric (encoded in the structure of $h$), not just memorized by the probe.
    
    _Citation:_ _Hewitt, J., & Liang, P. (2019). "Designing and Interpreting Probes with Control Tasks."_
    

#### **4. Emergent World Models (Othello-GPT & Space-Time)**

Recent work pushes probing to prove that LLMs build internal "World Models."

- **Othello-GPT:** A model trained _only_ to predict the next move in Othello (Reversi) was probed. Linear probes successfully recovered the _exact state of the board_ (which piece is where) from the internal layers, even though the model was never explicitly shown the board.
    
    _Citation:_ _Li, K., et al. (2023) / Nanda, N. (2023). "Actually, Othello-GPT Has A Linear Emergent World Representation."_
    
- **Space & Time:** Probes on Llama-2 revealed that the model encodes "Latitude" and "Longitude" as linear directions. The activations of city names physically map to a globe within the vector space.
    
    _Citation:_ _Gurnee, W., & Tegmark, M. (2023). "Language Models Represent Space and Time."_
    

---

### **III. Simple Code & Visualization**

#### **Visualization: The Hyperplane Cut**

The Manifold $\mathcal{M}$ (the wavy surface) contains all possible sentences. The Probe is the flat plane ($\Pi$) that slices the manifold to separate concepts.

Plaintext

```
       Activation Space (R^d)
             |
             |      (Manifold Surface)
             |          .~~~~~~.
             |         /  TRUE  \    <-- Points here are true facts
[Hyperplane] |________/__________\________
(The Probe)  |       /            \
             |      /    FALSE     \   <-- Points here are hallucinations
             |     .~~~~~~~~~~~~~~~~.
             |
             |
```

_Note: The distance of a point $h$ from the hyperplane (margin) represents the model's "confidence" in that concept._

#### **Code: Implementation of a Linear Probe**

Below is a PyTorch implementation of a probe using `sklearn` for the logistic regression solver (industry standard for probes).

Python

```
import torch
import numpy as np
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split

def train_linear_probe(model, tokenizer, dataset, layer_idx):
    """
    Trains a linear probe to detect a concept (binary classification).
    
    Args:
        dataset: List of tuples (text, label) where label is 0 or 1.
    """
    
    # 1. Extraction Phase (Harvesting Activations)
    features = []
    labels = []
    
    print("Extracting activations...")
    for text, label in dataset:
        # Tokenize
        inputs = tokenizer(text, return_tensors="pt").to(model.device)
        
        # Forward pass with hooks
        with torch.no_grad():
            outputs = model(**inputs, output_hidden_states=True)
            
        # Get hidden state at specific layer (usually the last token)
        # Shape: [batch, seq_len, hidden_dim] -> [hidden_dim]
        hidden_state = outputs.hidden_states[layer_idx][0, -1, :].cpu().numpy()
        
        features.append(hidden_state)
        labels.append(label)
        
    X = np.array(features)
    y = np.array(labels)
    
    # 2. Split Data (Standard ML Hygiene)
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)
    
    # 3. Train Probe (Logistic Regression)
    # C is inverse regularization. High C = Low Reg (trust data), Low C = High Reg.
    # We want a SIMPLE probe, so we use default or higher regularization.
    probe = LogisticRegression(max_iter=1000, C=1.0)
    probe.fit(X_train, y_train)
    
    # 4. Evaluation
    accuracy = probe.score(X_test, y_test)
    print(f"Probe Accuracy at Layer {layer_idx}: {accuracy:.4f}")
    
    # The 'Direction' is the coefficients of the regression
    direction_vector = probe.coef_ 
    
    return direction_vector, accuracy
```

---

### **IV. Summary of Key References for Your Notes**

1. **Alain, G., & Bengio, Y. (2016).** _Understanding intermediate layers using linear classifier probes._ (The foundational paper).
    
2. **Hewitt, J., & Liang, P. (2019).** _Designing and Interpreting Probes with Control Tasks._ (Introduced rigorous controls to prevent probes from "learning" the task themselves).
    
3. **Elhage, N., et al. (2022).** _Toy Models of Superposition._ (Explains _why_ linearity happens: features are stored in superposition in high dimensions).
    
4. **Gurnee, W., & Tegmark, M. (2023).** _Language Models Represent Space and Time._ (Applied probes to find physical world maps inside Llama-2).
    
5. **Belinkov, Y. (2022).** _Probing Classifiers: Promises, Shortcomings, and Advances._ (A great overall survey review).