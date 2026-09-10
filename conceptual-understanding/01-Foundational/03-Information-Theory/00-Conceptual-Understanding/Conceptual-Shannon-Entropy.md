---
tags:
  - information-theory
  - classical-information-theory
  - conceptual-explanations
---

---
```table-of-contents
```
---
### References

> [!info] .
>
>**[Obsidian Links]** 
>`$= dv.list([...new Map(dv.current().file.outlinks.filter(l => l.path.endsWith(".md")).map(l => [l.path, l])).values()])`
>
>---
>
> **[External Links]** 
> `$= const content = await dv.io.load(dv.current().file.path); const regex = /\[(.*?)\]\((https?:\/\/[^\s)]+)\)/g; const links = []; let m; while (m = regex.exec(content)) { links.push("[" + m[1] + "](" + m[2] + ")"); } dv.list([...new Set(links)])`
>
>---
>
> **[Directory Links]** 
> `$= const content = await dv.io.load(dv.current().file.path); const regex = /\[(.*?)\]\(<(file:\/\/\/.*?)>\)/g; const links = []; let m; while (m = regex.exec(content)) { links.push("[" + m[1] + "](<" + m[2] + ">)"); } dv.list([...new Set(links)])`
>
>---
> 
> **[Back Links]** 
> `$= dv.list([...new Map(dv.current().file.inlinks.map(l => [l.path, l])).values()])`
>
>---
> **[Document Tags]**
> 
>  `$= [...new Set(dv.current().file.tags)].join(" | ")`


---
### Primitives 

- [[Cover-Thomas-Elements-of-Information-Theory]]
- [[A-Mathematical-Theory-of-Agency-and-Intelligence-Bipredictability-Diagnostics]]
  
---

> Without entropy ➝ we have no way to quantify the `volume` of information ➝ moving through a circuit

### 1. The Basics 

At its absolute most basic ➝  **Shannon Entropy is a measure of surprise** 
Imagine you have a coin that always lands on heads. If you flip it, you learn nothing new; there is zero surprise. Its entropy is **0 bits**. Now imagine a fair coin (50/50). Every flip is a mystery. When it lands, you gain exactly **1 bit** of information. Entropy is the mathematical way we calculate the "average amount of mystery" in any variable.

### How it Works: The Math of Uncertainty

The formula for entropy is:

$$H(X) = -\sum_{i=1}^{n} p(x_i) \log_2 p(x_i)$$

- **$p(x_i)$**: The probability of a specific thing happening.
    
- **$\log_2$**: This turns probability into "bits" (the number of yes/no questions needed to figure out the result).
    
- **The Negative Sign**: Probability is always a fraction (like $0.5$), and the log of a fraction is negative. We use the minus sign to make the final entropy a positive number.
    

---

## Why the Paper Uses it for Bipredictability

The authors use entropy because it is the only way to measure **Mutual Information ($I$)**—the "overlap" between two or more things.

In a Large Language Model, we have three variables:

1. **Observation ($O$):** The input context.
    
2. **Action ($A$):** The circuit's internal firing (the weights doing work).
    
3. **Outcome ($R$):** The resulting prediction.
    

To find the bipredictability ($P$), the paper calculates the **Multivariate Mutual Information** ($I(O;A;R)$). This is the specific slice of information that is present in all three variables at the same time.

> **The "Grip" Logic:** If the Action ($A$) truly understands the Observation ($O$) and causes the Outcome ($R$), then the information in all three should overlap perfectly. If they don't overlap, the model is just guessing or relying on a memorized trick.

---

## What’s So Special About It?

1. **Universal Scale:** It doesn't matter if you are measuring a double pendulum, a stock market crash, or a 70-billion parameter transformer. Entropy treats everything as "bits," allowing the authors to compare physical systems to AI models using the exact same ruler.
    
2. **Semantic Neutrality:** Entropy doesn't care if the model is talking about "apples" or "quantum physics." It only cares about the **statistical structure**. This makes it the ultimate "truth serum" for AI—it ignores the words (which can be hallucinated) and looks purely at the mechanical coupling.
    
3. **Detecting Drift:** Traditional reward signals (did the AI get the right answer?) are binary. Entropy is continuous. It can detect that a model’s "causal grip" is slipping from $P=0.8$ to $P=0.4$ long before the model actually outputs a wrong answer.


To understand why the formula for Shannon entropy looks the way it does, we have to look at the mechanical requirements of information. Shannon didn't just invent this out of thin air; he derived it to solve a specific engineering problem: **How do we measure the "volume" of a message?**

### Why the Formula is as such ($-\sum p \log p$)

The structure of the formula is dictated by three logical necessities:

1. **Additivity:** If you have two independent events (like flipping two coins), the total information should be the _sum_ of the individual informations.
    
2. **Probability Multiplication:** However, the probability of two independent events happening together is the _product_ of their individual probabilities ($P_A \times P_B$).
    
3. **The Bridge:** To turn a **product** (multiplication) into a **sum** (addition), you need a **Logarithm**. This is the fundamental reason the $\log$ exists in the formula. It allows us to add "information" even though we are multiplying "probabilities."
    

### How it converts Probability to Bits

The $\log_2$ is the "translator" that turns a decimal probability into a physical count of binary decisions (bits).

Think of it as a tree-search. If you are looking for a specific item in a set of $8$ possibilities, and all are equally likely ($p = 1/8$):

- $\log_2(1/8)$ gives you $-3$.
    
- Apply the negative sign from the formula, and you get **3 bits**.
    

Those 3 bits represent the **number of "Yes/No" questions** you must ask to perfectly identify that item.

- _Question 1:_ Is it in the first half? (Eliminates 4)
    
- _Question 2:_ Is it in the first half of the remaining? (Eliminates 2)
    
- _Question 3:_ Is it the first or second of the remaining? (Result found)
    

The higher the probability ($p \to 1$), the closer the $\log$ gets to zero—meaning you need fewer questions because you already "know" the answer. The lower the probability ($p \to 0$), the higher the $\log$ result—meaning more bits are required to resolve the high "surprise."

### Information Entropy vs. Atomic Entropy

Since you have an MS in Materials Science, you are used to the **Boltzmann Entropy** ($S = k_B \ln \Omega$), which measures the number of microscopic configurations ($\Omega$) consistent with a macroscopic state.

The transition from Atoms to Information is actually a transition from **Energy** to **Structure**:

- **Atomic (Thermodynamic) Entropy:** Measures the **physical disorder** or the "spread" of energy in a system. It’s about how many ways you can arrange atoms without changing the temperature or pressure.
    
- **Information (Shannon) Entropy:** Measures the **predictive uncertainty** in a sequence. It’s about how much "room for surprise" there is in a message.
    

**The Mechanical Link:**

In Materials Science, high entropy means a system is "smeared" across many states, making it hard to pinpoint where one atom is. In AI, high Shannon entropy in an activation layer means the model is "smeared" across many different possible predictions.

When the paper talks about **Bipredictability ($P$)**, they are essentially looking for a "Phase Transition." If the entropy of the Observation and the Action overlap perfectly, the information has "crystallized" into a specific causal structure. If they don't overlap, the information is "gaseous"—it's just random noise moving through the model without any structural grip on the environment.




### Breaking Down the 1948 Seminal Logic

Shannon’s paper, _A Mathematical Theory of Communication_, isn't about "meaning"—it's about **limits**. He wanted to find the absolute physical limit of how much data you can push through a wire before it becomes noise.

#### 1. The Variable $X$ (The Message Space)

In the paper, Shannon defines an information source as a producer of symbols ($x_1, x_2, ...$). In your MI work, $X$ is the **Activation Space** of a layer. It’s a distribution of possible states.

#### 2. The "Surprise" ($I$)

Shannon realized that **Information = Surprise**.

- If a neuron always fires (Probability = 1.0), it tells the next layer nothing. Surprise is zero.
    
- If a neuron rarely fires (Probability = 0.001), it carries massive information when it finally does.
    
- **The Math:** He used $\log(1/p)$ to measure this. The $\log$ is the "scalpel" that turns tiny probabilities into a linear scale of bits.
    

#### 3. The Average ($H$)

Entropy ($H$) is just the **weighted average** of all that surprise.

$$H(X) = \sum p(x) \log(1/p)$$

It tells you the "volume" of the message. If $H$ is high, the model is exploring many possibilities (uncertainty). If $H$ is low, the model has "collapsed" onto a single prediction.

#### 4. The "Noisy Channel" (The Agent's Environment)

This is where the ArXiv paper you shared connects to Shannon. Shannon proved that if you have a source (Observation) and a destination (Outcome), and there is **noise** (the Environment/Agency) in between, you can only communicate reliably if the **Mutual Information** is high.

---

### Why this is the "Truth Serum" for your AI Diagnosis

In your diagnostic blueprint, you are treating the **LLM's internal circuits** as Shannon's "Channel."

- **Source:** The Observation ($O$).
    
- **Channel:** The Action/Circuit ($A$).
    
- **Destination:** The Outcome ($R$).
    

If you calculate Shannon’s $H$ and it shows that $I(O;A;R)$ is low, you have mathematical proof that the "Channel" (the circuit) is full of noise. The model isn't "talking" to the environment anymore; it's just talking to itself.



### The Seminal Resource

- **The Book:** _Elements of Information Theory_ by Joy A. Thomas and Thomas M. Cover.
    
- **Why it works:** It treats Information Theory as a branch of probability and physics. It will show you exactly how entropy governs everything from gambling to thermodynamics to the data compression inside a Transformer.