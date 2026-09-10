---
tags:
  - llmops-agentops-inference-model-optimizations-quantization
  - conceptual-explanations
  - llmops-architecture
  - llm-data-type-int
  - llm-data-type-float
  - llm-data-type-bfloat
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

- [[Systems-LTD-Telecom-Architecture-Assessment]]
- [[Project-Enterprise-Telecom-Main]]
- [[Conceptual-Basics-Anatomy-of-Compute-Feature-Manifolds-Circuit-Topologies]]
  
---
### 1. First Principles of Quantization

> At its core, quantization is a **lossy compression** mapping from a continuous ➝ or high-resolution discrete ➝  space to a lower-resolution discrete grid.

> #high-to-low-resolution-mapping

#### I. Mathematical Mapping

For any tensor $X$, the quantization function $Q(X)$ is defined by a scale $S$ and a zero-point $Z$

$$Q(x) = \text{clip}\left(\text{round}\left(\frac{x}{S} + Z\right), Q`{\text{min}}, Q`{\text{max}}\right)$$
where
- Scale ($S$) 
	- Determines the `step size` of the grid
- Zero-point ($Z$) 
	- An offset to ensure the value $0.0$ is exactly representable ➝ critical for padding + ReLU-heavy architectures
- Clipping 
	- Managing outliers that fall outside the representable range ➝ $[\text{min}, \text{max}]$

#### II. Bits, Exponent & Mantissa 

> The breakdown of the 16 bits ➝  **1 bit (Sign)** + **5 bits (Exponent)** + **10 bits (Mantissa)**

> #bits-exponent-mantissa

##### I. The Sign Bit: 1 Bit

> - This is the simplest part 
> - It’s a binary toggle

> - **0:** The number is positive
> - **1:** The number is negative 
> - **First Principle:** This bit defines the `hemisphere` of the activation space
    
##### II. The Exponent: 5 Bits ➝ The Bias ➝ The Scale

> The exponent determines the **dynamic range** of the number ➝ how incredibly large or microscopically small the value can be

> - Think of the exponent as the **magnification setting** on a microscope 
> - It tells us `where` to look on the number line
> - A **small exponent** looks at the ➝ world of $0.000001$
> - A **large exponent** looks at the ➝ world of $60,000$

> - With 5 bits ➝ we can represent $2^5 = 32$ different values ➝ 0 to 31
> - However, we need to represent both very large + very small numbers 
> - To do this, FP16 uses ➝ a **Bias of 15**
> 	- To get the `real` exponent ➝ we take the binary value and subtract 15
> 	- **Range** 
> 		- $2^{(1-15)}$ to $2^{(30-15)}$, which is roughly $2^{-14}$ to $2^{15}$ 

> - **Significance** 
> 	- This limited range is why FP16 is prone to 
> 		- **Overflow** ➝ hitting infinity 
> 		- **Underflow** ➝ vanishing to zero 
> 		- during training
> 	- which is why the `Brain Float` ➝ BF16 ➝ uses 8 bits for the exponent instead
  
##### III. The Mantissa: 10 Bits ➝  The Precision

> The mantissa (or significatnd) determines the **resolution** or the `detail` of the number

> - If the exponent is the microscope's power ➝ the mantissa is the **quality of the lens** 
> - It tells us exactly where the number sits `within` that scale
> - It represents the `digits` of the number
> - In scientific notation ($1.23 \times 10^4$) ➝ the `1.23` is the mantissa
    
> - In binary floating point ➝ we always normalize the number so it ➝ starts with a $1$ 
> - Since it `always` starts with a $1$ ➝ we don't waste a bit storing it ➝ This is called the **hidden bit**

> - We have 10 physical bits ➝ but effectively **11 bits of precision**
> - **Formula** 
> 	- $1.\text{fraction\_bits}$
> - **Precision Limit** 
> 	- With 10 bits ➝ we have about 3.31 decimal digits of precision 
> 	- This means if we have the number $123.456$ ➝ FP16 might only be able to store it as $123.4$

##### IV. The Mathematical Synthesis

The **value** of an **FP16 number** is calculated as
$$Value = (-1)^{Sign} \times (1 + \sum_{i=1}^{10} b_{10-i} 2^{-i}) \times 2^{(Exponent - 15)}$$
#### III. MI Intuition: Manifold Discretization

> - From an MI perspective ➝ consider quantization as ➝ **imposing a grid on the activation manifold** 
> - If the `grid` is too coarse ➝ the model loses the ability to represent ➝ small angular differences ➝ between feature vectors
> 	- potentially causing **feature interference** or `collapsing` distinct circuits ➝ into the same activation pattern

> - If the **Mantissa** is too small ➝ low precision ➝ the `features` in the activation manifold become blurry 
> - We can't distinguish between two similar neurons because the `rounding` has merged them into the same coordinate

#### IV. High-Precision & Floating-Point Formats

> These are the `standard` formats where the **exponent** allows for a **wide dynamic range**

##### I. FP16 & BF16 ➝ 16-bit

###### I. FP16 

> - 5 bits for exponent + 10 for mantissa 
> - High precision but prone to overflow if gradients or activations spike
    
###### II. BF16 ➝ Brain Float 

> - 8 bits for exponent (same as FP32) + 7 for mantissa 
> - It **sacrifices precision** for the same `dynamic range` as FP32 ➝ making it the **industry standard for stable training**
    
> #llmops-industry-standards 

##### II. FP8 ➝ The Inference Powerhouse

> Standardized by NVIDIA + Intel + ARM ➝ FP8 is the current `sweet spot` for H100/B200 inference

> - **E4M3** 
> 	- 4-bit exponent + 3-bit mantissa 
> 	- Used for **Weights** and **Forward Pass Activations** where ➝ precision matters more than range
> - **E5M2** 
> 	- 5-bit exponent + 2-bit mantissa 
> 	- Used for **Gradients** in the backward pass where ➝ handling wide ranges (spikes) is more critical than the exact decimal value
    
#### V. INT8: The Threshold of Efficiency

> INT8 was the first major leap in LLM serving ➝ example ➝ `LLM.int8()`

##### I. Symmetric vs. Asymmetric 

> - Symmetric quantization assumes the data is **centered at zero** ➝ no zero-point needed ➝ which is **common for weights** 
> - Asymmetric is used for activations ➝ like GELU/ReLU outputs ➝ that are **strictly positive**
    
##### II. The Outlier Problem 

> - LLMs naturally produce `outlier features` ➝ **high-magnitude activations** ➝ in specific channel 
> - In INT8 ➝ these outliers force the Scale $S$ to be very large ➝ effectively `crushing` the precision of all other values to near-zero
    
##### III. Solution ➝ SmoothQuant 

> Migrates the `difficulty` of quantizing activations over to the weights ➝ which are much easier to quantize
        
#### VI. Sub-8-bit Revolution: INT4 + NF4

> This is where 2025-2026 research has peaked for edge deployment

##### I. 4-bit ➝ GPTQ & AWQ

###### I. GPTQ

> Uses the **Hessian matrix** ➝ inverse ➝ to determine which weights are ➝ most sensitive to rounding errors + adjusts the remaining weights to compensate
    
###### II.  AWQ ➝ Activation-aware Weight Quantization 

> Protects `salient` weights ➝ those corresponding to large activations ➝ by keeping them in higher precision or scaling them up before quantization
    
##### II. NF4 ➝ NormalFloat 4-bit

> - Commonly used in QLoRA 
> - It doesn't use a linear grid 
> - Instead, it assumes ➝ the weights follow a **Normal Distribution** ➝ creates a non-linear grid ➝ that provides more resolution ➝ where the data is most dense ➝ near zero

#### VII. The Extreme Frontier: 2-bit & 1.58-bit

##### I. 2-bit ➝ QuIP# & HQQ

> - Techniques like **Incoherence Processing** ➝ QuIP ➝ apply a random rotation to the weight matrix ➝ before quantization 
> - This spreads out the information so that no single weight is `too important` ➝ making the rounding errors less catastrophic

##### II. BitNet 1.58b ➝ Ternary Weights

> The `1.58-bit` moniker comes from ➝ $\log_2(3)$ ➝ as it uses three states ➝  $\{-1, 0, 1\}$

> It replaces expensive floating-point multiplications with simple **additions and subtractions** in the residual stream

> - **MI Note** 
> 	- This is a radical shift in the **Geometry of Activation Spaces** 
> 	- Instead of a continuous manifold, the model operates on a `hyper-discrete` lattice
> 	- Remarkably, research shows that at 3B+ parameters, these models match FP16 performance
    
#### VIII. Mechanistic Interpretability Implications

> How does `quantization` affect the `core frameworks`?

##### I. Induction Heads 

> - Lower precision ➝ **especially below 4-bit**
> 	- can degrade ➝ the `matching` mechanism of induction heads 
> 	- as the attention scores ➝ become too coarse ➝ to distinguish between similar-but-different tokens in a long context

##### II. Superposition ➝ SAEs 

> - Quantization error can be viewed ➝ as `noise` ➝ in the sparse recovery process 
> - If we train an SAE on a 4-bit model ➝ we may find that **features are more polysemantic** ➝ because the model has `smudged` them together to fit the bit-budget
    
##### III. Logit Lens 

> - Quantization shifts the `residual stream` trajectory 
> - We may see `jumpier` logit predictions between layers as the model rounds intermediate states
    
#### IX. Key Citations 

1. Dettmers et al. (2022) ➝ `LLM.int8(): 8-bit Matrix Multiplication for Transformers at Scale` ➝ The foundation for modern 8-bit
	- [LLM.int8(): 8-bit Matrix Multiplication for Transformers at Scale](https://arxiv.org/abs/2208.07339)
2. Ma et al. (2024) ➝ `The Era of 1-bit LLMs: All Large Language Models are in 1.58 Bits` ➝ BitNet 1.58b
	- [The Era of 1-bit LLMs: All Large Language Models are in 1.58 Bits](https://arxiv.org/abs/2402.17764)
3. Chee et al. (2024) ➝  `QuIP: 2-Bit Quantization of Large Language Models with Guarantees` ➝ Incoherence processing
	- [QuIP: 2-Bit Quantization of Large Language Models With Guarantees](https://arxiv.org/abs/2307.13304)
4. TABv2 (2026) ➝ `A Faster Ternary and Binary Neural Network Inference Library` ➝ Latest on edge optimization
	- [IEEE Pdf Article: TABv2: A Faster Ternary and Binary Neural Network Inference Library on the Edge](https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=11360778)
---
### 2. Details: 4-bit quantization

> - To understand 4-bit quantization ➝ we have to look at the **information density** problem 
> - In a 16-bit world ➝ we have 65,536 possible `slots` for a number 
> - In a 4-bit world ➝ we only have **16**

> #information-theory | #information-density 

> - Imagine trying to paint a masterpiece using only 16 colors 
> - If we just pick the 16 closest colors to the original ➝ **Naive Quantization** ➝  the image will look `blocked` + lose all its subtle textures 
> - **GPTQ** and **AWQ** are two different philosophies on how to pick those 16 colors so the `painting` ➝ the model's logic ➝  still works

> #llmops-agentops-inference-model-optimizations-quantization-awq | #llmops-agentops-inference-model-optimizations-quantization-gptq  | #llmops-agentops-inference-model-optimizations-quantization-4bit 

#### I. GPTQ: The Mathematical Surgeon ➝ The Hessian Matrix

- **GPTQ ➝ Generalized Post-Training Quantization** 
	- is like a surgeon who realizes that ➝ if they have to cut something out ➝ lose precision 
	- they should adjust the surrounding tissue to compensate for the loss

>- GPTQ is based on ➝ **Optimal Brain Quantization** 
>- It looks at a layer and asks ➝  `If I round this specific weight $w$ to one of my 16 available 4-bit values, how much does the output error increase?`
>- It uses the **Hessian matrix** ➝ a matrix of second-order derivatives ➝ to calculate this sensitivity
>- **The Magic Trick** 
>	- Once it rounds a weight + creates an error ➝ it doesn't just leave it 
>	- It **updates all the remaining unquantized weights** ➝ in that row ➝ to `cancel out` the error ➝ introduced by the rounding

> #hessian-matrix-calculations 

> - GPTQ is excellent because it is **data-agnostic** ➝ it only needs a tiny calibration set ➝ and handles the `static` weight matrix very well 
> - However, it treats all **weights** ➝ as if they `contribute equally` to the loss ➝ which we know isn't true in real LLM circuits

#### II. AWQ: The Strategic Guardian ➝ Saliency & Scaling

> - **AWQ ➝ Activation-aware Weight Quantization** ➝ takes a more `biological` approach 
> 	- It realizes that ➝ not all weights are born equal 
> 	- Some weights are `VIPs` because ➝ they process the most important information

> - Instead of trying to find the perfect math ➝ **to compensate for error like GPTQ** ➝ AWQ looks at the **Activations** 
> - It notices that about 1% of the weights process 99% of the important signal ➝ the `outliers`

##### I. Saliency 

> AWQ identifies these `salient` weights by looking at ➝ **which ones produce the largest activations** ➝ during a forward pass
    
##### II. The Protective Scale 

> - Instead of keeping these VIP weights in FP16 ➝ which would be slow ➝ AWQ **scales them up** 
> - By `multiplying` the weight by a **factor** ➝ and `dividing` the input activation by the **same factor** ➝ to keep the math identical 
> 	- it pushes the weight ➝ into a range where the 4-bit rounding error ➝ is mathematically insignificant
    
#### III. Comparison: GPTQ vs. AWQ

| **Feature**    | **GPTQ**                          | **AWQ**                                  |
| -------------- | --------------------------------- | ---------------------------------------- |
| **Philosophy** | Error Compensation ➝ Mathematical | Saliency Protection ➝ Heuristic          |
| **Core Tech**  | Inverse Hessian Matrix            | Activation-based Scaling                 |
| **Speed**      | Very fast to quantize             | Slightly slower calibration              |
| **Hardware**   | Optimized for V100/A100/H100      | Excellent for edge devices               |
| **MI Impact**  | Can `smear` small circuits        | Preserves `Heavy Hitter` features better |

#### IV. MI Perspective 

> When we are doing **Circuit Analysis** on a 4-bit model ➝ these two methods create different `artifacts` in the activation manifold

> - **In GPTQ** 
> 	- Because the weights have been `shifted` to compensate for each other ➝ we might find that the individual weights no longer make sense in isolation 
> 	- The `logic` of an induction head ➝ might be spread across the row in a way that looks like noise ➝ but functions correctly as a collective
    
> - **In AWQ** 
> 	- Since the core structure of the `salient` weights is preserved ➝ just scaled 
> 	- the primary circuits ➝ like the `Previous Token Head` ➝ usually remain much cleaner and easier to find with a Logit Lens
    
> - If we want to understand LLMs at the weight/activation level ➝ we must understand how 4-bit quantization `distorts` the geometry of the activation space 
> - Most 2026 models running on local hardware  will be using a variant of these

---
### 3. AWQ: Activation-aware Weight Quantization ➝ Detailed

> - AWQ is widely considered the state-of-the-art for 4-bit weight-only quantization because it doesn't just `crush` the numbers 
> 	- it intelligently reshapes the weight distribution ➝ to protect the model's most critical circuits

#### I. The Core Intuition: The 1% Salience Rule

> - Traditional quantization treats every weight as equally important 
> - However, MI research ➝ and the AWQ paper ➝ confirms that LLMs are **sparse in their importance**
> - [arXiv: AWQ: Activation-aware Weight Quantization for LLM Compression and Acceleration](https://arxiv.org/abs/2306.00978)

##### I. The Observation

- About **1% of the weights** ➝ salient weights ➝ are responsible for maintaining the model’s reasoning capabilities 
- These weights typically correspond to ➝ channels with **very large activation magnitudes** ➝ outliers
    
##### II. The Problem

> In a naive 4-bit world ➝ these outliers force the quantization scale to be so wide ➝ that the `normal` weights lose all their resolution
    
##### III. The AWQ Solution 

> - Instead of keeping these 1% weights ➝ in a separate FP16 list ➝ which is slow for hardware 
> 	- AWQ **scales the weights up** ➝ so they occupy the higher-value `buckets` of the **4-bit range**
> 		- making them **more resistant** to rounding noise
    
#### II. The Mathematical Framework

> - The brilliance of AWQ lies in its `mathematical transparency` 
> - It performs a transformation ➝ that is **exactly reversible during the forward pass** ➝ ensuring **0 theoretical error** before quantization is applied

##### I. The Linear Transformation

- Consider a **linear** layer $Y = WX$ 
- AWQ introduces a **per-channel scaling factor** $s$ such that
$$Y = (W \cdot s) \cdot (s^{-1} \cdot X)$$

> By multiplying the weight by $s$ and the input activation by $1/s$ ➝ the output $Y$ remains `mathematically identical`

##### II. Finding the Optimal Scale ➝ $s$

- The goal is to **find a scale** ➝ that **minimizes the quantization error** for the **most important weights** 
- The scaling factor $s$ is typically derived from the activation statistics
$$s = s_x^{\alpha}$$

where: 
>  - **$s_x$** 
> 	 - The maximum (or average) magnitude of the activations for that channel`
> - **$\alpha$** 
> 	- A tunable hyperparameter (usually $0.5$) that balances protecting the salient weights versus preserving the dynamic range of the others

##### III. The Rounding Error

When we quantize the scaled weight $Q(W \cdot s)$ ➝ the rounding error $\delta$ is introduced. The effective error on the output becomes
$$\text{Error} = | (Q(W \cdot s) \cdot s^{-1} \cdot X) - (W \cdot X) |$$

> By increasing $s$ for salient channels ➝ we **reduce** the **relative impact of the rounding error** $\delta$ on those `critical pathways`

#### III. Benefits vs. Disadvantages

| **Feature**    | **Benefits**                                                                  | **Disadvantages**                                                                   |
| -------------- | ----------------------------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| **Accuracy**   | Retains ~99% FP16 performance & superior to GPTQ for instruction-tuned models | Requires a small calibration dataset (128–512 samples) to `see` activations         |
| **Hardware**   | **Hardware-friendly.** Uses uniform INT4; no mixed-precision kernels required | Small storage overhead (~1%) for the scaling factors                                |
| **Speed**      | 3x faster than FP16 on most GPUs; works excellently with **Marlin** kernels   | Slower to quantize than `Round-To-Nearest` (but faster than GPTQ)                   |
| **Generative** | Preserves multi-modal and reasoning `circuits` much better                    | Accuracy can still degrade if the calibration set is wildly different from the task |

#### IV. The MI Pespective 

> From the perspective of an MI expert ➝  AWQ is preferable because it ➝ **preserves feature geometry**

##### I. Feature Preservation: Protecting the Anchors

> To understand feature preservation ➝ we must first look at the geometry of the residual stream and how `outlier` activations function within it

###### I. The Anatomy of an Outlier

- In the high-dimensional space of an LLM ➝ **concepts** are represented by `direction` + `magnitude` 
- While **most features** share the mathematical load ➝ superposition 
	- a **tiny fraction of features** ➝ often representing critical syntactic markers + exact entity names + strong grammatical rules
	- exhibit incredibly **massive activation magnitudes** 
- These are the `outliers`

> #mechanistic-interpretability-superposition | #mechanistic-interpretability-superposition | [[Conceptual-Superposition-MI-LLMs]] 

###### II. The Anchor Effect in MI 

- When we apply the **Logit Lens** ➝ multiplying intermediate residual stream states by the unembedding matrix ➝ we rely on dot products 
- A high-magnitude outlier acts as a geometrical `anchor` 
- Its massive vector length guarantees that 
	- its dot product with the target token's unembedding vector 
	- will completely overwhelm the background noise of millions of other polysemantic features

- Similarly, **Induction Heads** rely on these sharp magnitude spikes ➝ in the Key + Query matrices 
- If an induction head cannot produce a distinctly sharp attention score ➝ a spike approaching $1.0$ in the softmax ➝ it cannot cleanly `copy` the previous token

> #mechanistic-interpretability-logit-lens  | [[Conceptual-Logit-Lens]]

- **The Quantization Threat:** Algorithms like GPTQ are designed to minimize _global_ mathematical error. Because these outliers represent less than 1% of the total weights/activations, global error minimization will happily `crush` the magnitude of an outlier to secure more precision for the other 99% of the matrix.
    
- **The AWQ Mechanism:** AWQ explicitly monitors the activation magnitudes during its calibration phase. When it spots an outlier channel, it multiplies the corresponding weights by a scaling factor $S$ (pushing them into a safer, higher-precision bucket on the 4-bit grid) and divides the incoming activation by $S$. The anchor's magnitude is explicitly protected by the quantization grid, ensuring your Logit Lens still detects a clean, powerful signal rather than a suppressed, noisy projection.
    

## 2. Linearity: Preserving the Activation Manifold

This is where the distinction between `math-first` and `activation-first` quantization becomes critical for circuit analysis and Sparse Autoencoders (SAEs).

- **The Linear Representation Hypothesis:** The foundational axiom of Mechanistic Interpretability is that neural networks represent features as linear directions in the activation space (the manifold). When we perform circuit analysis or train SAEs to untangle superposition, we assume we can isolate features using linear algebra.
    
- **The GPTQ Distortion (Shearing):** GPTQ uses the inverse Hessian matrix to compensate for rounding errors. If it rounds Weight A and loses some value, it mathematically alters Weight B, Weight C, and Weight D in that same row to make up the difference.
    
    - In the activation manifold, this creates a `shearing` effect. A feature that used to point perfectly along a specific vector $v$ has now been deliberately smeared across adjacent vectors to hide the quantization noise. The model still outputs the right answer, but the internal mechanical pathway has been convoluted.
        
- **The AWQ Transformation (Stretching/Compressing):** AWQ does not mix weights to hide errors. It relies purely on the per-channel scaling matrix $S$.
    
    - Mathematically, the transformation is $Y = (W \cdot S) (S^{-1} \cdot X)$.
        
    - In linear algebra, multiplying by a diagonal matrix $S$ is purely an orthogonal transformation. It does not rotate or shear the space; it only stretches or compresses the existing axes.
        
- **Impact on Circuit Analysis:** Because AWQ strictly scales the space linearly, the core geometry of the manifold is intact. If you train an SAE on the FP16 model to find monosemantic features, those learned feature directions will still largely map onto the AWQ-quantized model. If you tried that with a GPTQ model, the SAE features would appear `dead` or highly polysemantic because the underlying linear basis of the circuits was warped during the Hessian compensation step.
    

---

## Citations for Further Deep Dives

1. **Lin, J., Tang, J., et al. (2024).** _`AWQ: Activation-aware Weight Quantization for LLM Compression and Acceleration.`_ (The primary source detailing the linearity of the scaling matrix and the preservation of salient channels).
2. [\[2306.00978\] AWQ: Activation-aware Weight Quantization for LLM Compression and Acceleration](https://arxiv.org/abs/2306.00978)
    
3. **Frantar, E., et al. (2023).** _`GPTQ: Accurate Post-Training Quantization for Generative Pre-trained Transformers.`_ (Essential for understanding the Hessian-based error compensation that causes the manifold distortion).
    
4. **Elhage, N., et al. (2022).** _`Toy Models of Superposition.`_ Anthropic. (The foundational text for understanding why preserving the orthogonal/linear structure of the manifold is necessary for resolving superposition).
    
5. **Dar, G., et al. (2022).** _`Analyzing Transformers in Embedding Space.`_ (Context for how the Logit Lens interacts with high-magnitude anchor vectors).
    

---

## 5. Major Models Using AWQ

As of 2025-2026, almost every major open-weights model has an `official` or community-standard AWQ version:

- **Llama 3.1 / 3.2 (8B, 70B, 405B):** AWQ is the preferred format for local deployment on NVIDIA RTX 4090/5090.
    
- **Mistral & Mixtral:** AWQ handles the `Sparse MoE` architecture better than GPTQ because it respects the routing activations.
    
- **Qwen 2.5:** Widely used in the `Project-Glass-Manifold-Qwen` context you mentioned.
    
- **Multi-modal Models:** Since image/video activations have different `spikiness,` AWQ’s activation-aware nature is critical here.
    

---

## 6. Citations for Your Research

> **Primary Paper:**
> 
> Lin, J., Tang, J., et al. (2024). ``AWQ: Activation-aware Weight Quantization for LLM Compression and Acceleration.`` **MLSys 2024.** (This is the `bible` of AWQ).

> **Secondary Support:**
> 
> Dettmers, T., et al. (2022). ``LLM.int8(): 8-bit Matrix Multiplication for Transformers at Scale.`` (Established the `outlier activation` problem that AWQ solved for 4-bit).

---

## Implementation on Your Hardware

Since you are using **Phoenix (AMD)** and **Domina (Intel)**:

- **Phoenix:** AWQ is natively supported in **vLLM** via ROCm, giving you near-GPU speeds on your Ryzen APU.
    
- **Domina:** You can run AWQ-quantized weights through **Intel's OpenVINO** or **AutoAWQ** for CPU-only inference, which is much more efficient than FP16 for your 16GB RAM limit.


---
---
### Self-Quantization the Models

In fact, compiling and quantizing models from scratch is a foundational skill for an MLOps and AI Architect.

Mechanically, you are simply applying a mathematical mapping function to the model's weight tensors, converting them from a high-resolution continuous space (FP32) into a lower-resolution discrete lattice (FP16 or INT8), and saving the new matrix to your disk.

Here is the operational reality of how you do this, focusing on the first principles and the physical constraints of your hardware.

---

## The Physics of the Conversion

Converting from FP32 to a lower precision takes two distinct mechanical paths depending on your target format.

- **FP32 to FP16 (Truncation):** This is mathematically trivial. You are literally just dropping the last 16 bits of the mantissa. It requires no calibration data because the dynamic range (the exponent) is largely preserved. You just cast the tensor types in memory and save.
    
- **FP32 to INT8 (Grid Mapping):** This is an active transformation. You must calculate the Scale ($S$) and Zero-point ($Z$) for every weight matrix. For a purely symmetric weight quantization, you find the absolute maximum value in the FP32 tensor, divide it by 127 (the max value of an INT8 integer), and use that as your scale.
    

## The Physical Constraint: System Memory

The primary obstacle in doing this yourself is not the math, but the RAM.

To quantize a model, the standard methodology requires loading the entire FP32 model into your system memory first. In FP32, every single parameter takes exactly 4 bytes. If you attempt to quantize a small 7B parameter model, the raw weights alone will consume roughly 28GB of RAM.

When executing this on Domina or Phoenix, your 16GiB of physical RAM will immediately hit an Out-Of-Memory (OOM) error if you try to load the FP32 model naively. On Domina, the OS will automatically begin paging into your 55.9GiB NVMe swap partition. This will prevent a crash, but the constant read/write swapping between the NVMe and RAM will make the quantization process exceptionally slow. On Phoenix, without that massive swap space, the process will likely be killed by the Linux kernel.

## The Standard Execution Pipelines

To bypass these memory constraints and perform the quantization yourself, you rely on specific engineering pipelines.

## 1. The C++ Edge Pipeline (GGUF / Llama.cpp)

This is the industry standard for CPU-only inference and is highly optimized for Kaby Lake, Whiskey Lake, and Renoir architectures. You use the `llama.cpp` library, which contains a dedicated quantization script.

- You download the raw FP32/FP16 weights (usually `.safetensors` format).
    
- You convert them into a flat `gguf` format.
    
- You run the `quantize` command, specifying the target grid (e.g., `q8_0` for standard INT8).
    
- The brilliance here is that it maps the tensors out-of-core (reading chunk by chunk from the disk), preventing your 16GiB RAM from overflowing.
    

## 2. The Native PyTorch Pipeline (Dynamic Quantization)

If you are building your own `Mechanistic-Micro-Transformer` from scratch and training it in FP32, you can use PyTorch's native `torch.quantization` engine. You simply pass your FP32 model object through a quantization API before saving it. This is excellent for small, custom architectures where the FP32 model easily fits into your 16GiB RAM.

## 3. The Auto-Calibration Pipeline (AWQ / GPTQ)

For advanced 4-bit or 8-bit activation-aware quantization, you use libraries like `AutoAWQ`. This requires passing a small dataset (like 128 rows of text) through the FP32 model so the algorithm can measure the activation manifold and calculate the optimal scaling factors before crushing the weights.