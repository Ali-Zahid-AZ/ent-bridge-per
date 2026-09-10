---
tags:
  - vector-steering
  - reading-list
  - llm-training-dynamics
---


---
#### References
- [GeoSteer: Faithful Chain-of-Thought Steering via Latent Manifold Gradients](https://arxiv.org/html/2601.10229v1#:~:text=GeoSteer%3A%20Faithful%20Chain%2Dof%2D,experimental%20HTML%20to%20improve%20accessibility.)
- [[Vector-Steering-The-Mechanics-of-Representation-Engineering]]
-  [Analyzing the Generalization and Reliability of Steering Vectors](https://arxiv.org/html/2407.12404v1)
- [Steering Large Language Models with Activation Vectors: A Practical Guide \| by Rupak (Bob) Roy - II \| Medium](https://bobrupakroy.medium.com/steering-large-language-models-with-activation-vectors-a-practical-guide-45866b3697ac)
- [Understanding Reasoning in Thinking Language Models via Steering Vectors](https://arxiv.org/html/2506.18167v1)
- [Analyzing the Generalization and Reliability of Steering Vectors](https://arxiv.org/html/2407.12404v1)



#### **The Layman Explanation**

**The Problem:**

Sometimes an LLM gets the right answer (e.g., "The answer is 5") but the steps it took to get there are garbage (hallucinations or wrong logic). This is "Unfaithful Reasoning."

**The Solution (GeoSteer):**

Think of the LLM's reasoning process as walking a tightrope.

- **Standard Steering:** Pushes the walker left or right (Linear Steering).
    
- **GeoSteer:** Builds a guardrail (Manifold) shaped like the path of a "Smart Expert."
    
- It trains a small map (VAE) of what "Good Reasoning" looks like. If the LLM starts to wobble off the path of logic, GeoSteer gently nudges it back toward the center of the "Good Reasoning" path, not just in a straight line, but following the curve of the logic.
    

#### **2. Technical Jargon (Principal Specs)**

**Manifold Hypothesis:**

Standard steering assumes a flat, Euclidean space (Linear). GeoSteer assumes high-quality CoT trajectories lie on a **low-dimensional non-linear manifold** embedded in the latent space.

**The Architecture:**

1. **VAE Training:** Train a Variational Autoencoder (VAE) on a dataset of _high-quality_ Chain-of-Thought trajectories. The VAE learns the latent manifold $\mathcal{M}$.
    
2. **Latent Manifold Gradients:** During inference, instead of adding a static vector, they compute the gradient of a "quality score" with respect to the latent variable $z$ within the VAE's bottleneck.
    
3. **Update Rule:**
    
    $$h_{t+1} = h_t + \alpha \cdot \nabla_z Q(D(z))$$
    
    (Where $D$ is the decoder and $Q$ is the quality estimator).
    

#### **3. Simple Code & Visualization**

Python

```
# Conceptual GeoSteer Logic
def geosteer_step(model, current_hidden_state, vae, quality_model):
    # 1. Project to Latent Manifold (Encode)
    z_latent = vae.encode(current_hidden_state)
    
    # 2. Calculate Gradient towards "High Quality" region
    # We want to maximize Quality(z)
    loss = -quality_model(z_latent)
    grad = torch.autograd.grad(loss, z_latent)
    
    # 3. Move in Latent Space (Steer)
    z_new = z_latent + (learning_rate * grad)
    
    # 4. Project back to Model Space (Decode)
    steering_vector = vae.decode(z_new) - current_hidden_state
    
    return current_hidden_state + steering_vector
```

---