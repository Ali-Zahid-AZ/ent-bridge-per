---
tags:
  - conceptual-explanations
  - llm-learning-dynamics
  - llm-manifolds-geometric-perspective
  - deeplearning-geometric-perspective
  - llm-optimization-dynamics
  - gradient-descent
---

---
```table-of-contents
```

---
### References 

> [!info] .
>
>**[Obsidian Links]** 
> `$= dv.list(dv.current().file.outlinks.filter(l => l.path.endsWith(".md")))`
>
>---
>
>**[External Links]**
> `$= const content = await dv.io.load(dv.current().file.path); const regex = /\[(.*?)\]\((https?:\/\/[^\s)]+)\)/g; const links = []; let m; while (m = regex.exec(content)) { links.push("[" + m[1] + "](" + m[2] + ")"); } dv.list([...new Set(links)])`
>
>---
>
>**[Directory Links]**
> `$= const content = await dv.io.load(dv.current().file.path); const regex = /\[(.*?)\]\(<(file:\/\/\/.*?)>\)/g; const links = []; let m; while (m = regex.exec(content)) { links.push("[" + m[1] + "](<" + m[2] + ">)"); } dv.list([...new Set(links)])`
>
>---
>
>**[Back Links]**
> `$= dv.list(dv.current().file.inlinks)`
> 


---
### Primitives

- [[Neural-Latent-Geometry-Search-Product-Manifold-Inference-via-GH-Informed-Bayesian-Optimization]]

---
> [!example] **Gradient Descent: The Geometrical Explanations**
> 
>- Geometrically ➝  Gradient Descent is **not** just  ➝ going downhill
> 	- It is a **projection operation** involving three distinct geometric objects: 
> 		- the **Manifold**
> 		- the **Tangent Space**
> 		- the **Metric Tensor**
>
>--- 
>
> ##### 1. The Setup: Where do we actually stand?
> 
> Consider the loss function $L(\theta)$ is a terrain (a scalar field) defined over a surface (the manifold $\mathcal{M}$) ➝ We are standing at a point $\theta_t$
> - **Geometric Reality** 
> 	- We cannot `look` at the whole manifold 
> 	- We are an ant on a giant sphere
> 	- Locally the world looks flat
> - **The Tangent Space ➝ $T_\theta \mathcal{M}$** 
> 	- This `local flatness` is the Tangent Space ➝ a flat plane that touches the manifold `only` at the current point $\theta_t$
>
>---     
>
>##### 2. The Gradient: A Vector in the Tangent Space
> 
> - This is the most common misconception 
> 	- The gradient $\nabla L(\theta_t)$ does **not** live on the manifold
> 	- It lives in the **Tangent Space**
> - **The Math** 
> 	- $\nabla L$ ➝ is a vector pointing in the **direction of steepest ascent** ➝ within that flat tangent plane
> - **The Metric Tensor ($G$)** 
> 	- How do we know which direction is `steepest`? 
> 		- We need a ruler 
> 		- The **Metric Tensor** $G(\theta)$ provides that ruler
> 	    - In Euclidean GD ➝ the ruler is constant ($I$)
> 	    - In Geometric GD ➝ the ruler warps
>     - The **true gradient** is actually
>         $$\nabla_{R} L = G^{-1}(\theta) \cdot \nabla_{E} L$$
> - The geometry of the space ($G$) ➝ twists the raw derivative ($\nabla_E$) ➝ to point in the **true geometric direction**
>
>--- 
>
> ##### 3. The Step: The Exponential Map: Retraction
> 
> We have a direction vector ➝ $v = -\eta \nabla L$ ➝ in the flat Tangent Space. We take a step along this straight arrow
> - **The Problem** 
> 	- If we walk in a straight line on the Tangent Plane ➝ we fly off the manifold into the empty ambient space
> - **The Fix** 
> 	- We need to `wrap` that straight line ➝ back onto the curved surface
> 	- This operation is called the **Exponential Map** ➝ Retraction)
>     $$\theta_{t+1} = \text{Exp}_{\theta_t}(v)$$
> - **Geometrically** 
> 	- This maps the straight vector in $T_\theta \mathcal{M}$ ➝ to a **Geodesic** the shortest curved path ➝ on the manifold $\mathcal{M}$
>
>---     
>
> ##### Summary: Geometric Gradient Descent
> 
> 1. **Stand** at point $\theta$
> 2. **Construct** a flat Tangent Plane ($T_\theta$)
> 3. **Measure** the slope using the Metric Tensor ($G$) to find the arrow $v$
> 4. **Walk** along $v$ in the flat plane
> 5. **Project (Retract)** that point back down onto the curved surface
>
>--- 
>
> - **Gradient Descent** (even Riemannian GD) **relies** on one fundamental assumption ➝  **Connectivity**
>	- To move from $\theta_t$ to $\theta_{t+1}$ ➝ there must be a **continuous path** ➝ a geodesic ➝ **connecting them**
> 	- We can slide from any point on a Sphere to any other point on that Sphere

> [!example] **Disconnected topology ➝  trapped optimization**
> 
> **Disconnected loss landscape ➝  gradient descent gets trapped**
> 
> Local minima aren't just `low points`
> They're topologically isolated basins ➝  regions where no geodesic connects ➝ to the global minimum without crossing a higher-energy barrier
> That's why the topology of the loss landscape determines trainability 
> Not just the shape ➝ the connectivity structure

---

