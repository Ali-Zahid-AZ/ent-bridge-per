---
tags:
  - programming-paradigms
  - gemini
topic: Programming:Paradigms
---

---
[[LangChain-Runnables in LCEL]]

---

**Interface-Based Programming** is the architectural strategy of `writing code` that talks to a **"Contract"** (what an object can do) rather than the **"Concrete Implementation"** (how it actually does it). 

In the context of your LCEL, the `Runnable` is the interface, and the local **DeepSeek-R1** is the concrete implementation.

### The "Wall Socket" Logic

Think of the electrical outlet in your wall as the **Interface**. Technically, it is a **Contract** that guarantees a specific voltage and physical shape (the "bumps and holes" we discussed). From a layman's perspective, you don't care if the electricity is coming from a nuclear plant, a wind farm, or a diesel generator (the **Concrete Implementations**); you just know that if you plug in your toaster, it will get power.

In the code, when you use the `Runnable` protocol, you are building the "socket." Whether you plug in **DeepSeek-R1**, **Qwen 2.5**, or **GPT-4**, the rest of your pipeline doesn't have to change because they all fulfill the `invoke()` contract.
print('

---
### The Principal Architect's Specifications

- **Decoupling & Modularity:** By programming to an interface, you decouple the **Consumer** (your application logic) from the **Provider** (the LLM). This allows for "Hot-Swapping" components. If DeepSeek-R1 is too slow for a specific task, you can swap it for Qwen 2.5 without rewriting your prompt or your parser, because the "socket" remains the same.
- **Polymorphism in Practice:** The `Runnable` wrapper allows for **Polymorphism**. This means one interface can represent many forms. You can call `.invoke()` on a single LLM, or you can call `.invoke()` on a chain of 10 components. The interface hides the complexity, treating the entire chain as a single unit of work.
- **The Liskov Substitution Principle:** This is a core SOLID principle which states that if **S** is a sub-type of **T**, then objects of type **T** may be replaced with objects of type **S**. In LCEL, any object that implements the `Runnable` interface can be swapped into your pipeline without breaking the execution flow.


```bash
[ APPLICATION LOGIC ]  <-- Only knows the "Runnable" Interface
        |
        v
    [ INTERFACE: invoke() ] 
        |
   ---------------------------
   |           |             |
[ GPT-4 ] [ DeepSeek-R1 ] [ Qwen 2.5 ]  <-- Concrete Implementations
```

#### Why this is your "Principal" Edge

As you build the **Liver Tumor pipeline**, you will inevitably face a scenario where a new, better model is released. If you use **Interface-Based Programming**, your migration path is zero-effort. You simply update the "Provider" inside the "Runnable" wrapper, and the rest of your production-grade architecture stays exactly as it is.

---




