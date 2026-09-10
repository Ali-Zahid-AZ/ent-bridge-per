---
tags:
  - dl-ml-mathematics
  - deeplearning-foundations
  - book
---

---
```table-of-contents
```
---
### References

- [[Mathematical-Foundations-of-Deep-Learning-Models-and-Algorithms-Book]]
- **Book** ➝ [Mathematical-Foundations-of-Deep-Learning-Models-and-Algorithms.pdf](<file:///home/az/04-Library/03-Deep-Learning-and-Architectures/03-Learning-Dynamics-and-Theory/Mathematical-Foundations/Mathematical-Foundations-of-Deep-Learning-Models-and-Algorithms.pdf>)
- 
---
### 1. The Premise: Universal Approximation (The Double-Edged Sword)

The text starts by referencing **Uniform Approximation Theory**

- **In simple terms**
	- given enough neurons (width $N \to \infty$) ➝ a neural network can fit _any_ continuous function
	- it can trace any curve ➝ perfectly memorize any dataset ➝ or simulate any logic gate

- **The Problem**
	- If a model can learn _anything_ ➝ why does it learn the _right_ thing?

> Out of the infinite possible functions the network _could_ represent ➝ which one does it actually choose during Gradient Descent?


> - **Input Layer** ➝ $d$ dimensions (e.g., 784 pixels)
> - **Hidden Layer** ➝ **$N$ neurons**
> - **Output Layer** ➝  $k$ classes
> - $N \to \infty$  ➝ we are mathematically treating the hidden layer as if it has an infinite number of neurons
> - In the NTK Regime, letting $N \to \infty$ turns the messy ➝ discrete neural network into a smooth, continuous Gaussian Process that we can solve exactly

#### I. The Three Natural Questions 

##### I. To where does the optimization converge?

- **Textbook Meaning:** When you run Gradient Descent (SGD), you are moving a point $\theta$ in the high-dimensional weight space. Where does it stop?
    
- **MI/Manifold Connection:** This is exactly what the **Universal Weight Subspace** paper answers. The optimization doesn't stop at a random point; it converges to a specific, low-dimensional Spectral Subspace.
    
    

#### **• How does the loss surface look?**

- **Textbook Meaning:** The Loss Surface is the energy landscape. In classical convex optimization (like finding the bottom of a bowl), there is one global minimum.
    
- **The Reality:** In Deep Learning, the landscape is non-convex and rugged. It should be full of bad local minima where the model gets stuck.
    
- **MI Connection:** Surprisingly, deep networks are connected. You can walk from one solution to another without accuracy loss (Mode Connectivity). This implies the Manifold of Good Solutions is a vast, connected valley, not isolated holes.
    

#### **• Why do neural networks typically generalize well?**

- **The Paradox:** In classical statistics, if you have more parameters than data points, you **overfit** (memorize noise). Deep Learning models have billions of parameters and only millions of data points. They _should_ fail.
    
- **The Reality:** They perform better as they get bigger. This defies classical intuition.
    
- **MI Connection:** This is the **Feature Learning** argument. The model isn't memorizing data points; it is learning **Circuits** (like Induction Heads) that compress the data's logic. It finds the Truth Vector because that is the most efficient way to lower the loss, rather than memorizing every specific example.
    

---

### **Summary**

This paragraph sets the stage for the **Neural Tangent Kernel (NTK)**. The NTK is the mathematical tool that answers these questions by proving that, under specific conditions (infinite width), the rugged landscape smooths out, and the training trajectory becomes predictable and linear.


### References 19.2

| **Reference**                                                                                | **What it is about**                                                                                                                                                                                                                      | **Why the book references it**                                                                                                                                                                   |
| -------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **[CHM+15]** [Choromanska et al. (2015)](https://arxiv.org/abs/1412.0233)                    | A seminal paper relating the loss landscape of neural networks to **Spin Glass** models in physics. It uses Random Matrix Theory to show that for large networks, most local minima are equivalent and located in a specific energy band. | To support the claim that finding bad local minima is a low-probability event in large networks, justifying why simple gradient descent works despite non-convexity.                           |
| **[PDGB14]** [Pascanu et al. (2014)](https://arxiv.org/abs/1406.2572)                        | This paper argues that the real difficulty in optimizing high-dimensional non-convex functions is not local minima, but **saddle points** surrounded by plateaus. It introduces Saddle-Free Newton methods.                             | To reinforce the idea that in high dimensions (large $N$), the optimization landscape is qualitatively different from low-dimensional intuition, supporting the move to infinite-width analysis. |
| **[PB17]** [Pennington & Bahri (2017)](https://proceedings.mlr.press/v70/pennington17a.html) | A study on the geometry of loss surfaces using **Random Matrix Theory**, explicitly calculating the distribution of Hessian eigenvalues at critical points.                                                                               | Cited alongside [CHM+15] to provide theoretical backing for the observation that for sufficiently wide networks, the optimization landscape becomes benign.                                      |
| **[GB10]** [Glorot & Bengio (2010)](https://proceedings.mlr.press/v9/glorot10a.html)         | The famous **Xavier Initialization** paper. It analyzes signal propagation in deep networks and proposes scaling weights by $1/\sqrt{N}$ to maintain constant variance across layers.                                                   | This is the core motivation for Section 19.2. The book uses this paper's derivation to mathematically justify the scaling factors ($1/\sqrt{N}$) that define the **NTK Regime**.                 |
| **[HZRS15]** [He et al. (2015)](https://arxiv.org/abs/1502.01852)                            | The **He Initialization** paper (Kaiming Init). It adapts Xavier initialization for **ReLU** activation functions (which cut variance in half) by scaling weights by $\sqrt{2/N}$.                                                      | Referenced in **Remark 19.1** to contrast with Xavier initialization, showing how the choice of activation function (ReLU vs Tanh) dictates the precise geometric scaling required.              |
| **[JGH18]** [Jacot et al. (2018)](https://arxiv.org/abs/1806.07572)                          | The foundational paper introducing the **Neural Tangent Kernel (NTK)**. It proves that infinite-width networks evolve as linear models governed by a frozen kernel.                                                                       | This is the primary subject of Section 19.3. The book cites it as the origin of the Linear Asymptotic Regime theory that the entire chapter is dedicated to explaining.                        |

### References 19.3
