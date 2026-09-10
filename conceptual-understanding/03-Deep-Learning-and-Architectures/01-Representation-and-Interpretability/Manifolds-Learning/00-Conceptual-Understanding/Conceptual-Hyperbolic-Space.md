---
tags:
  - 
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
- [[Conceptual-Riemannian-Manfolds]]
- [[00-Riemannian-Manifolds-Hyperbolic-Spaces-LLMs]]
---

Hyperbolic Space is a specific _type_ of Riemannian Manifold. It is the "Opposite of a Sphere."

- **Sphere (Positive Curvature):** Parallel lines eventually meet (think longitude lines at the North Pole). Space closes in on itself.
    
- **Euclidean (Zero Curvature):** Parallel lines never meet.
    
- **Hyperbolic (Negative Curvature):** Parallel lines **diverge** (move apart) exponentially.
    

**The "Saddle" Analogy:**

Imagine a Pringle (potato chip) or a saddle. If you put two marbles side-by-side on the saddle and roll them "forward," they will roll away from each other.

- **Why it matters for AI:** In a standard flat space, the amount of "room" you have grows polynomially ($r^2$). In Hyperbolic space, the amount of room grows **exponentially** ($e^r$).
    
- This makes it perfect for **Trees and Hierarchies**. A family tree grows exponentially (2 parents, 4 grandparents, 8 great-grandparents...). You can fit that infinite tree into a Hyperbolic space perfectly without crushing the nodes together.
    


How are they connected?**

- **Riemannian Manifold** is the **Category** (like "Vehicle").
    
- **Hyperbolic Space** is a **Specific Instance** (like "Ferrari").
    
- Hyperbolic Space is just a Riemannian Manifold where the "Curvature" is set to a constant **-1**.