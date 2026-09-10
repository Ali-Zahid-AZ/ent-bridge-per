---
tags:
  - anthropic-research
  - reading-list
---

---
```table-of-contents
```
---
### Primitives

- [Transformer Circuits Thread](https://transformer-circuits.pub/)

---

| **Article Title**                                                                                         | **Subdomain**                           | **Brief Description**                                                                                                                                     |
| --------------------------------------------------------------------------------------------------------- | --------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **[A Mathematical Framework for Transformer Circuits](https://gemini.google.com/app/229186d9e4c96659)**   | **Foundational MI / Circuit Analysis**  | The seminal paper introducing the "circuits" approach, explaining attention heads as independent "write" operations and defining induction heads.         |
| **[In-Context Learning and Induction Heads](https://gemini.google.com/app/229186d9e4c96659)**             | **Induction Heads / Learning Dynamics** | Explores how models use induction heads to perform in-context learning and identifies a "phase change" during training where these heads emerge.          |
| **[Toy Models of Superposition](https://gemini.google.com/app/229186d9e4c96659)**                         | **Superposition / Polysemanticity**     | Investigates how networks pack more features than dimensions by using non-orthogonal representations and explains the geometric roots of polysemanticity. |
| **[Superposition, Memorization, and Double Descent](https://gemini.google.com/app/229186d9e4c96659)**     | **Superposition / Generalization**      | Extends the toy models to explain how models manage memorization and why "double descent" occurs mechanistically.                                         |
| **[Privileged Bases in the Transformer Residual Stream](https://gemini.google.com/app/229186d9e4c96659)** | **Activation Spaces**                   | Investigates why individual coordinates in the residual stream often gain significance, pointing to the Adam optimizer's role.                            |
| **[Towards Monosemanticity](https://gemini.google.com/app/229186d9e4c96659)**                             | **Sparse Autoencoders (SAEs)**          | Decomposes a one-layer model using dictionary learning (SAEs) to find features that are more interpretable than raw neurons.                              |
| **[Scaling Monosemanticity (Claude 3 Sonnet)](https://gemini.google.com/app/229186d9e4c96659)**           | **SAEs / Safety**                       | Demonstrates the ability to scale SAEs to production-level models (Claude 3 Sonnet), identifying safety-relevant and highly abstract features.            |
| **[Mapping the Mind of a Large Language Model](https://gemini.google.com/app/229186d9e4c96659)**          | **SAEs / Model Control**                | Uses SAEs on Claude 3 Sonnet to find "Golden Gate Bridge" features and other abstract concepts, enabling direct steering of model behavior.               |
| **[Circuit Tracing](https://gemini.google.com/app/229186d9e4c96659)**                                     | **Computational Graphs**                | Introduces techniques to trace the step-by-step computation graph when a model responds to a specific prompt.                                             |
| **[On the Biology of an LLM](https://gemini.google.com/app/229186d9e4c96659)**                            | **Biological Analogies / Claude 3.5**   | Investigates Claude 3.5 Haiku's internal mechanisms, comparing them to biological neural system behaviors.                                                |
| **[Tracing Attention through Feature Interactions](https://gemini.google.com/app/229186d9e4c96659)**      | **Attention Mechanism / SAEs**          | Method to explain attention patterns by looking at how features (from SAEs) interact rather than just raw attention weights.                              |
| **[When Models Manipulate Manifolds](https://gemini.google.com/app/229186d9e4c96659)**                    | **Geometry / Manifold Theory**          | Analyzes the "Linebreak Circuit," showing how models represent counting and boundaries as 1D manifolds in high-dimensional space.                         |
| **Emergent Introspective Awareness**                                                                      | **Introspection / Self-Awareness**      | Finds evidence that models can "introspect" or understand their own internal states when answering certain types of questions.                            |

---
