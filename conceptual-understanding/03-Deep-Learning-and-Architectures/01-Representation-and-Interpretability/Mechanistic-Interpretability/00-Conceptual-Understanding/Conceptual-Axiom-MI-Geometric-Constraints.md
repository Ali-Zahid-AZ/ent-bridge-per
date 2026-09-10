---
tags:
  - axiom
  - conceptual-explanations
  - mechanistic-interpretability
  - llm-neural-signatures
  - gemini_insights
  - deeseek_insights
  - note-finalized
---

---
```table-of-contents
```
---
### References

- [[Conceptual-Intertwined-Concepts-MI]]
- [[00-Mechanistic-Interpretability-Layer-Zones-Reading-List]]
- [[00-Mechanistic-Interpretability-Seminal-Works]]

---
### The Axiom 

>[!example] **The Fundamental Axiom: Interpretability requires geometric constraints that bound the solution space**

>[!quote] **The Fundamental Axiom: Geometric Constraints as the Source of Meaning**
>
>- **Corollary 1** 
>	- Without constraints ➝  the model's representations are rotationally symmetric → infinite equivalent representations → no privileged basis → no interpretability
>- **Corollary 2**
>	- Interpretability methods ➝ are distinguished by which constraint they impose ➝ sparsity, linearity, orthogonality, low-rank ➝  and how they break symmetry
>- **Corollary 3** 
>	- The model itself **learns constraints during training** (manifold, cone, outliers) → this is why it **becomes partially interpretable** without intervention

> [!example] **Why this Axiom is necessary and sufficient**
> - **Necessary:** If the solution space is unbounded, there are infinite equivalent representations. No amount of analysis can privilege one over another. Interpretability is impossible in principle.
> - **Sufficient:** If the solution space is geometrically constrained (sparsity, linearity, orthogonality, manifold structure), those constraints pick out a unique or privileged basis. That basis is, by definition, interpretable—because the constraint was chosen to align with human semantic categories
> 
#### Rephrasing the Axiom 

>[!example] **Rephrasing the Axiom**
>
> **Meaning is only identifiable when the solution space is geometrically bounded**
>
>- **The Corollary:**
>
>	- Without constraints, neural networks are **Rotationally Invariant** 
>		- meaning there are infinite valid ways to represent the same information
>		- none of which are inherently interpretable to humans
>	- Interpretability is the act of finding ➝ the _one_ rotation that respects a specific geometric constraint ➝ usually Sparsity

---
### I. Gemini's Insight 

#### I. The Problem: The Rashomon Effect of High Dimensions

Why is this axiom necessary? Because of **Basis Ambiguity**

1. **The Math of Invariance**
    
    In the residual stream, the model cares only about dot products (distances/angles)
    $$Attention(x, y) = x^T W y$$
    
    If we rotate the entire universe of activations by some random orthogonal matrix $U$ (where $U^T U = I$):
    $$(Ux)^T W (Uy) = x^T U^T W U y = x^T W y$$
    
    **The Math hasn't changed.** The model works exactly the same
    
1. **The Interpretability Crisis**
    
    To the model, the vector for Dog is $v_{dog}$. But to the model, the vector $U v_{dog}$ is _also_ Dog.
    - One of those vectors might look like `[1, 0, 0, 0]` (Clean: Neuron 1 = Dog).
    - The other might look like `[0.2, -0.4, 0.1, 0.9]` (Messy: Dog is a smear across 4 neurons).
    - **Without a constraint, the model has no reason to choose the Clean one.** It will happily use the Messy one (Superposition).

**Conclusion:** We cannot read the model because the model has no incentive to write legibly.

#### II. The Solution: Constraints Break the Symmetry

Your axiom states that we must **bound the solution space**. 
We impose a rule that says: _Of the infinite equivalent rotations, you must pick the one that satisfies Condition X._

##### Constraint A: Sparsity (The SAE constraint)

This is the most successful constraint in the field (used in Sparse Autoencoders)

- **The Rule:** You can represent 'Dog' however you want, BUT you must use as few active neurons as possible
- **The Geometric Bound:** This forces the solution vectors to align with the axes (coordinate axes)
- **Result:** The Smear `[0.2, -0.4, 0.1, 0.9]` is rejected because it has 4 active values. The Clean `[1, 0, 0, 0]` is selected because it has only 1.
- _Why this works:_ It breaks the rotational symmetry. Only one specific rotation minimizes the number of active neurons. That rotation happens to be the one humans can understand.

##### Constraint B: Linearity (The Probe constraint)

This is the constraint used in Linear Probes.
- **The Rule:** You must separate 'True' from 'False' using a flat plane.
- **The Geometric Bound:** We ignore complex, curved boundaries.
- **Result:** We find the **Truth Direction**. If we allowed non-linear boundaries (unbounded solution space), we could gerrymander a shape that circles all the true points, but it wouldn't tell us which _direction_ is truth. It would just memorize the data.

##### Constraint C: The Manifold (The Data constraint)

This is the constraint imposed by the data itself
- **The Rule:** Real words don't occur randomly. 'Queen' follows 'King' more often than 'Carburetor' does.
- **The Geometric Bound:** This forces the activations to collapse onto a thin sheet (the Manifold) rather than filling the whole void.
- **Result:** Interpretability is only possible _on_ this manifold. If we step off it (remove the constraint), we hallucinate

#### III. Reframing the Axiom 

>[!example] Can frame this as the ➝ **Symmetry Breaking Argument**
> The raw physics of a neural network contains a 'Rotational Symmetry' that hides meaning from the observer. 
> The goal of Interpretability is to apply **Geometric Constraints** (Sparsity, Linearity, Manifold Adherence) that break this symmetry and collapse the infinite possibilities down to the single, unique structure that represents the 'True' algorithm
>
>This is the Grand Unified Theory of the field

#### IV. Synthesis: The Axiom in Action

Let's re-read the major concepts through the lens of your axiom.

|**Concept**|**The Unbounded State (Chaos)**|**The Geometric Constraint (Order)**|**Result**|
|---|---|---|---|
|**Superposition**|Features are stored as random, interfering vectors. (Basis Ambiguity).|**Johnson-Lindenstrauss:** Vectors must be nearly orthogonal.|We get predictable shapes like **Pentagons** instead of random noise.|
|**SAEs**|Activations are a dense, unintelligible soup.|**$L_1$ Sparsity:** Use the fewest features possible.|We recover **Monosemantic Features** (Golden Gate Bridge).|
|**Probes**|Truth could be a complex, wiggly fractal.|**Linearity:** Truth must be a straight line.|We discover the **Truth Direction**.|
|**Intervention**|Changing a neuron might break everything.|**Orthogonality:** Move only along the Truth Vector, orthogonal to Sentiment.|We can **Steer** the model without brain damage.|
### II. DeepSeek's Insight

**Any interpretability method = A geometric constraint + A symmetry-breaking algorithm**
- **SAEs** = Sparsity constraint + dictionary learning
- **Probes** = Linearity constraint + logistic regression
- **Steering** = Orthogonality constraint + vector injection
- **Manifold learning** = Low-dimensional constraint + PCA/UMAP
- **Causal tracing** = Intervention constraint + path patching

| Constraint             | Tool             | What It Reveals                          |
| ---------------------- | ---------------- | ---------------------------------------- |
| **Sparsity**           | SAEs             | Monosemantic features                    |
| **Linearity**          | Probes           | Conceptual directions (truth, sentiment) |
| **Orthogonality**      | Steering vectors | Independent control axes                 |
| **Manifold adherence** | OOD detection    | Hallucination boundaries                 |
| **Low-rank structure** | PCA/UMAP         | Global organization                      |
#### DeepSeek's Suggestion 

> [!example] **Reading Research: Ask**
> 
>**_What geometric constraint are they imposing? What symmetry are they breaking?_**

---

