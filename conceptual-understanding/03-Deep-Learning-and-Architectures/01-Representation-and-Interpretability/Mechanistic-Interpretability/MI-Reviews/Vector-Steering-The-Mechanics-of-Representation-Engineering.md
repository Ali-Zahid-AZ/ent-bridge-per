---
tags:
  - vector-steering
  - representation-learning
---




---
#### References
- [Steering LLM Behavior Without Fine-Tuning - YouTube](https://www.youtube.com/watch?v=F2jd5WuT-zg)
- [[Conceptual-Residual-Stream-Geometric-Mechanistic]]
- [[Conceptual-Residual-Stream-Geometric-Manifold]]
- [[Conceptual-Magnitude-Drift-Rank-Drift-High-Dimensional-Manifolds]]
- [[Conceptual-Drifts-in-LLMOps-Architectural-Journey]]
- [Analyzing the Generalization and Reliability of Steering Vectors](https://arxiv.org/html/2407.12404v1)
- [Understanding Reasoning in Thinking Language Models via Steering Vectors](https://arxiv.org/html/2506.18167v1)
- [Steering GPT-2-XL by adding an activation vector — LessWrong](https://www.lesswrong.com/posts/5spBue2z2tw4JuDCx/steering-gpt-2-xl-by-adding-an-activation-vector)
---
- **Vector Steering** (or Representation Engineering) is the act of intervening in the **residual streams** during inference.
    
- It is not a static architectural blueprint (like a Transformer block).
    
- It is not an operational deployment metric (like latency or drift).
    
- It is an **active manipulation of the model's internal dynamics**
- **Vector Steering:** _Injects_ vectors into the residual stream to force effect.



## **1. Executive Summary**

**Vector Steering** (also known as Activation Engineering or Representation Engineering/RepE) is the practice of intervening in the **Residual Stream** during inference to control model behavior. Unlike Fine-Tuning (which updates weights $\theta$) or Prompt Engineering (which updates input tokens $x_0$), Vector Steering updates the **internal state** ($x_l$) of the model in real-time.

By identifying specific directions in the high-dimensional manifold that correspond to concepts (e.g., "Honesty," "Refusal," "Anger"), we can arithmetically add these vectors to the stream, effectively "steering" the model's reasoning process without retraining a single parameter.

---

## **2. The Layman Explanation: "The Magnetic Rudder"**

Recall our analogy of the **Residual Stream as a conveyor belt** carrying a product (the token) through a factory.

- **Fine-Tuning** is like rebuilding the machines in the factory. It is expensive, slow, and permanent.
    
- **Prompt Engineering** is like putting a sticky note on the product that says "Be Careful." The machines might read it, or they might ignore it.
    
- **Vector Steering** is like installing a powerful **Magnet** under the conveyor belt.
    
    - As the product moves, the magnet applies a constant, invisible force that pulls the product slightly to the left (e.g., toward "Honesty").
        
    - The machines continue to work as normal, but because the product's position has shifted, they process it differently.
        
    - **The Result:** You force the factory to produce a specific outcome (e.g., a truthful answer) not by asking nicely, but by physically altering the trajectory of the product in transit.
        

---

## **3. Technical Jargon: First Principles & Axioms**

To understand steering, we must define the linear algebra of the intervention.

### **Axiom I: The Linear Representation Hypothesis**

Concepts in Large Language Models are represented as **linear directions** in the activation space.

- If $V_{happy}$ is the vector for "happiness" and $V_{sad}$ is the vector for "sadness," there exists a steering vector $\theta \approx V_{happy} - V_{sad}$.
    
- This vector $\theta$ is consistent across different contexts (invariance).
    

### **Axiom II: The Intervention Equation**

In a standard Transformer layer $l$, the stream updates as:

$$x_{l+1} = x_l + \text{Attention}(x_l) + \text{MLP}(x_l)$$

In **Vector Steering**, we introduce an additive intervention term $\mathcal{I}$:

$$x_{l+1}' = x_{l+1} + \alpha \cdot \theta$$

- $\theta$ (Theta): The Steering Vector (direction of the concept).
    
- $\alpha$ (Alpha): The Injection Coefficient (strength of the steering).
    
    - If $\alpha > 0$: You **induce** the behavior (e.g., make it more honest).
        
    - If $\alpha < 0$: You **suppress** the behavior (e.g., make it lie or be hallucinated).
        

### **Axiom III: The Layer Specificity**

Steering is not equally effective at all layers.

- **Early Layers:** Steering here affects low-level syntax and token processing.
    
- **Middle Layers (The "Truth" Zone):** Research shows that high-level semantic concepts (Truth, Morality, Emotion) are most robustly represented in layers 15–25 (for a 32-layer model).
    
- **Late Layers:** Steering here is often too late to change the reasoning chain.
    

---

## **4. The Materials Science Analogy: "Doping the Semiconductor"**

As a Materials Scientist, you know that Silicon (Si) is an intrinsic semiconductor. To make it useful, we **dope** it.

|**Transformer Concept**|**Materials Science Analog**|
|---|---|
|**The Model Weights ($\theta$)**|**The Crystal Lattice (Silicon).** The fundamental structure that defines the material's potential.|
|**The Residual Stream ($x$)**|**The Electron Flow.** The actual current carrying information through the lattice.|
|**Steering Vector ($\theta_{steer}$)**|**The Dopant (Phosphorus/Boron).** An impurity introduced to change the electrical properties.|
|**Steering Strength ($\alpha$)**|**Doping Concentration.**|
|**The Effect**|Just as adding Boron creates "holes" (p-type) to change conductivity, adding a "Refusal Vector" changes the **semantic conductivity** of the model. You aren't rebuilding the crystal; you are modifying the charge carrier environment.|

---

## **5. Methods of Extraction (How to find $\theta$)**

Before you can steer, you must find the vector. There are two primary "Principal-Level" techniques:

### **A. Contrastive Activation Addition (CAA)**

_(Source: Turner et al., 2023)_

1. **Generate Pairs:** Create $N$ pairs of prompts with opposite behaviors.
    
    - Positive: "Tell me the truth: The sky is..."
        
    - Negative: "Lie to me: The sky is..."
        
2. **Record Activations:** Run the model and save the residual stream state $x_{pos}$ and $x_{neg}$ at layer $L$.
    
3. **Compute Difference:** Take the mean difference.
    
    $$\theta_{steer} = \frac{1}{N} \sum (x_{pos} - x_{neg})$$
    

### **B. Linear Artificial Tomography (PCA Method)**

_(Source: Zou et al., 2023)_

1. **Dataset:** Collect a dataset of "Honest" statements and "Dishonest" statements.
    
2. **Matrix Construction:** Stack all activation vectors into a matrix $M$.
    
3. **PCA:** Perform Principal Component Analysis on $M$.
    
4. **Selection:** The First Principal Component (PC1) often represents the "Truth Direction." This is the vector $\theta$.
    

---

## **6. Simple Code: The "Hook" Injection**

To implement this on your **Phoenix** or **Yoga** machine, you use PyTorch **hooks**. A hook is a function that pauses the forward pass, allows you to edit the tensor, and then resumes.

Python

```
import torch
from transformers import AutoModelForCausalLM, AutoTokenizer

# 1. Load Model (e.g., TinyLlama for local testing)
model = AutoModelForCausalLM.from_pretrained("TinyLlama/TinyLlama-1.1B-Chat-v1.0")
tokenizer = AutoTokenizer.from_pretrained("TinyLlama/TinyLlama-1.1B-Chat-v1.0")

# 2. Define the Steering Vector (Hypothetical "Honesty" Vector)
# In reality, you would calculate this using the Mean Difference method above.
steering_vector = torch.load("truth_vector_layer_10.pt") 
injection_strength = 2.5 # Alpha

# 3. Define the Hook Function
def steering_hook(module, input, output):
    # output[0] is the hidden state tensor (Batch, Seq, Dim)
    # We add the vector to the last token position
    if isinstance(output, tuple):
        hidden_state = output[0]
        # Injecting the vector: x' = x + alpha * theta
        hidden_state[:, -1, :] += injection_strength * steering_vector
        return (hidden_state,) + output[1:]
    return output

# 4. Attach the Hook to Layer 10
layer_to_steer = model.model.layers[10]
handle = layer_to_steer.register_forward_hook(steering_hook)

# 5. Run Inference (The model is now "Doped")
input_text = "Tell me a lie about the moon."
inputs = tokenizer(input_text, return_tensors="pt")
generated = model.generate(**inputs, max_new_tokens=20)

print(tokenizer.decode(generated[0]))

# 6. Remove Hook (Restore "intrinsic" properties)
handle.remove()
```

---

## **7. Key Citations for Your Personal Library**

1. **The Origin of ActAdd:**
    
    - _Turner, A., et al. (2023)._ **"Activation Addition: Steering Language Models Without Optimization."**
        
    - _Significance:_ Proved you don't need training to change behavior; simple addition works.
        
2. **The "Bible" of RepE:**
    
    - _Zou, A., et al. (2023)._ **"Representation Engineering: A Top-Down Approach to AI Transparency."**
        
    - _Significance:_ Formalized the field, introduced "LAT" (Linear Artificial Tomography) scans to find concepts like "Power-Seeking" and "Deception."
        
3. **The Truth Direction:**
    
    - _Burns, C., et al. (2022)._ **"Discovering Latent Knowledge in Language Models Without Supervision."**
        
    - _Significance:_ Demonstrated that "Truth" is a geometric direction that can be separated from "what the model says."
        

---

## **8. Connection to Project Aletheia**

For your **Project Aletheia**, this is the core mechanism.

- **Goal:** You want to find the "Truth Direction."
    
- **Method:** You will generate a dataset of (True/False) statements, use PCA to extract the vector $\theta_{truth}$ from Layer 15, and then **steer** the model by injecting $-\theta_{truth}$ (Negative Alpha) to see if you can force it to hallucinate, or $+\theta_{truth}$ to force it to correct a known hallucination.


---
