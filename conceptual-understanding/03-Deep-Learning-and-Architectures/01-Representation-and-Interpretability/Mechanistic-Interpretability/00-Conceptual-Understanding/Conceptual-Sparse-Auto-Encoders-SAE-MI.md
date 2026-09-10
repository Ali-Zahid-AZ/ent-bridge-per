---
tags:
  - llmops
  - llmops-hallucination
  - llm-hallucination-detection
  - llm-interpretability
  - mechanistic-interpretability-sae
  - reading-list
  - mechanistic-interpretability
  - mechanistic-interpretability-techniques
  - llm-sparsity
  - llm-sparse-auto-encoders-sae
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

----
### Primitives 

- [[01-Projects/LLMs/Project-Aletheia-Geometry-of-Truth/Project-Aletheia-Geometry-of-Truth-Implementation]]
- - arXiv ➝ [arXiv: Toy Models of Superposition](https://arxiv.org/abs/2209.10652)
- [Anthropic: Toy Models of Superposition](https://transformer-circuits.pub/2022/toy_model/index.html)
- [Anthropic: Toy Models of Superposition-Anthropic](https://www.anthropic.com/research/toy-models-of-superposition)
- [Anthropic: Toy-Models-of-Superposition-Elhage-Hume](https://www.semanticscholar.org/paper/Toy-Models-of-Superposition-Elhage-Hume/9d125f45b1d2dea01f05281470bc08e12b6c7cba)
- [Toy Models of Superposition — LessWrong](https://www.lesswrong.com/posts/CTh74TaWgvRiXnkS6/toy-models-of-superposition)
- [Cambridge: Toy Models of Superposition.pdf](https://www.mlmi.eng.cam.ac.uk/files/2022_-_2023_advanced_machine_learning_posters/toy_models_of_superposition_reduced.pdf)
- [Dir: 📂 Open: Sparse-Autoencoders](<file:///home/az/04-Library/05-Operations-X-Ops/02-LLMOps/Interpretability/Sparse-Autoencoders>)
- [arXiv: DLM-Scope: Mechanistic Interpretability of Diffusion Language Models via Sparse Autoencoders](https://arxiv.org/html/2602.05859)
- [Intuition: An Intuitive Explanation of Sparse Autoencoders for LLM Interpretability](https://adamkarvonen.github.io/machine_learning/2024/06/11/sae-intuitions.html)

---

> [!success] Why SAEs
> SAEs solve polysemanticity by extracting monosemantic features from superposition.  
> Top labs use them because they're the best current tool for understanding AND controlling model internals.  
> Project Aletheia work is conceptually similar - just focused on ONE feature instead of thousands
>---------------
>Extending [[01-Projects/LLMs/Project-Aletheia-Geometry-of-Truth/Project-Aletheia-Geometry-of-Truth-Implementation]]
>- **Train SAE on Qwen2.5-1.5B**
>- Extract 4,096-8,192 features
>- **Find** ➝  truth, emotion, toxicity, all at open-source
>- **Phoenix-compatible** (SAE training is cheap)
>---
>**Apply SAE principles to production**
>- Instead of monitoring 1 Feature using the Truth Vector Cosine Angle Approach
>- Full SAE ➝  monitoring ALL safety features simultaneously
>	- Same detection logic, broader coverage 

---
### The Problem: The Xray Machine for AI

> [!example ] **The Problem: The Xray Machine for AI**
> - Imagine trying to understand a radio by looking at individual transistors. One transistor might be involved in:
> 	- Volume control
> 	- Station tuning
> 	- Bass adjustment
> 	- Power regulation
> - This is **polysemanticity** ➝  one component does many things ➝ **LLM neurons are the same**
> 	- One neuron might activate for:
> 		- Academic citations
> 		- English dialogue
> 		- HTTP requests
> 		- Korean text
> 		- (All at once!)
> - **How do you understand what's happening?**  ➝ You can't
>---
> - **The Solution: Sparse Autoencoders**
> 	- Think of it like an X-ray machine that reveals hidden structure:
> 	- **What you see (neurons):** 512 blurry, overlapping signals  
> 	- **What SAE reveals:** 8,000 clear, distinct features
> - **Example features SAEs found:**
> 	- "Golden Gate Bridge" feature (only activates for that bridge)
> 	- "DNA sequence" feature (genetic code patterns)
> 	- "Sarcasm" feature (detects ironic statements)
> 	- "Arabic script" feature (specific to Arabic text)
> 	- "Base64 encoding" feature
> - **Each feature** is **monosemantic** ➝  one meaning, not many
>---
> **Why it's called "Sparse"**
> - For any given input, only ~10-50 features activate out of 8,000 possible.
> - Like a piano: You have 88 keys (many features), but only press 4-5 at once (sparse activation).

---
### The Superposition Hypothesis

#### The Core Problem: Superposition

> [!success] **Neural networks can represent MORE features than they have neurons.**
> - **How?** Through **superposition** - storing features as overlapping directions in activation space.
> - **The Math:**
> 	- Model has $d$ =512 neurons
> 	- But world has $n$ =1,000,000 potential features (concepts).  
> 	- **Problem:** $n>>dn$
> - **Solution (discovered by Toy Models paper):**
> 	- Features are **sparse** - most features inactive for any given input.
> 	- Model can compress features into dd d dimensions by accepting some **interference** (overlap).
>---
>**Example**
>- 512 neurons can represent ~8,000-15,000 features
>- if features are sparse (only ~1% active at once) 
>---
>Imagine 5 features in 2D space:
> - **Without superposition:** Only 2 features fit (orthogonal axes)
> - **With superposition:** All 5 features fit (overlapping directions - pentagon geometry)
> 
> **Cost**: Small interference when features co-activate.  
> **Benefit**: 2.5x compression.

---
### SAE Architecture

> [!example] **Goal**  ➝ Extract these hidden features from superposition
> **Input**  ➝  $x ∈ ℝ^d_model$ (e.g., d=512)
>        ↓
> **Encoder** ➝  $f = ReLU(W_enc · x + b_enc)$ |  $f ∈ ℝ^d_sae$  (e.g., d_sae=8,192)
>          ↓
> **L1 sparsity penalty enforces ~10-50 active features**
>          ↓
> **Decoder** ➝  $x' = W_dec · f + b_dec$
>          $x' ∈ ℝ^d_model$
> 

#### Key properties

1. **Overcomplete:** dsae>>dmodeld_{sae} >> d_{model} dsae​>>dmodel​ (typically 8x-32x expansion)
2. **Sparse:** L1 penalty → only ~1% of features active
3. **Reconstruction:** Minimize ∣∣x−x′∣∣2||x - x'||^2 ∣∣x−x′∣∣2

#### Loss function
$$L=∣∣x−x′∣∣^{2} + λ∣∣f∣∣_{1}​$$

**First term** ➝  Reconstruction accuracy  
**Second term**  ➝  Sparsity penalty

--
#### Why It Works 

> [!example] **The Geometric Intuition: Why it works**
> - [[01-Projects/LLMs/Project-Aletheia-Geometry-of-Truth/Project-Aletheia-Geometry-of-Truth-Implementation]] conclusively showed 
> 	- Truth direction emerges as single vector in 1536D space
> 	- Linear probe can find it
> 
> **SAEs do the same ➝  but for ALL concepts simultaneously**
> - Truth direction
> - Sarcasm direction
> - DNA sequence direction
> - Golden Gate Bridge direction
> - `~ 8,000-15,000` directions in total
> 
> **Each SAE feature ➝  one monosemantic concept**

#### Implementation: The Code Pattern

`Training an SAE (simplified)`

```python
import torch
import torch.nn as nn

class SparseAutoencoder(nn.Module):
    def __init__(self, d_model=512, d_sae=8192):
        super().__init__()
        self.encoder = nn.Linear(d_model, d_sae)
        self.decoder = nn.Linear(d_sae, d_model, bias=False)
        # Tie decoder weights to be normalized
        self.decoder.weight.data = self.encoder.weight.data.T
        
    def forward(self, x):
        # Encode
        f = torch.relu(self.encoder(x))  # Sparse features
        
        # Decode
        x_recon = self.decoder(f)
        
        return x_recon, f

# Loss
def sae_loss(x, x_recon, f, lambda_sparsity=1e-3):
    reconstruction_loss = (x - x_recon).pow(2).mean()
    sparsity_loss = f.abs().mean()  # L1 penalty
    
    return reconstruction_loss + lambda_sparsity * sparsity_loss

# Training loop
model = SparseAutoencoder()
activations = extract_activations_from_llm()  # Your Aletheia extraction

for epoch in range(num_epochs):
    x_recon, features = model(activations)
    loss = sae_loss(activations, x_recon, features)
    loss.backward()
    optimizer.step()
```

---

> [!example] **Why do top Labs use SAE**
> **Anthropic (leader in this space):**
> 1. **MRI for AI** - Can see what model thinks
> 2. **Safety monitoring** - Detect deception, bias, toxicity features
> 3. **Model steering** - Amplify/suppress specific features (e.g., "Golden Gate Claude")
> 4. **Circuit tracing** - Map how features connect across layers
>--- 
> **Their results (Claude 3 Sonnet):**
> - Extracted 34 million features across all layers
> - Found features for: abstract concepts, multilingual patterns, coding styles, safety concerns
> - 70% of features rated as interpretable by humans
>--- 
> **OpenAI:**
> - Feature attribution for GPT-4
> - Understanding chain-of-thought reasoning (o1 model)
> - Safety alignment verification
>--- 
> **DeepMind:**
> - Gemma Scope (SAE tooling for Gemma models)
> - Circuit discovery
> - **Note:** Recently deprioritized SAE work (March 2025) - Neel Nanda quote: "not going super well"

> [!example] **Why it matters for Production**
> **Current:** Black box → can't predict failures  
> **With SAEs:** Feature dashboard → monitor specific concepts
> 
> **Example use cases:**
> - Detect when "hallucination" features activate → halt generation
> - Monitor "bias" features → trigger review
> - Track "deception" features → flag for audit


---
### Seminal Papers

| **Category**    | **Paper Title & Year**                                               | **Authors**                            | **Key Insights & Results**                                                                                       | **Links**                                                             |
| --------------- | -------------------------------------------------------------------- | -------------------------------------- | ---------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| **Foundation**  | **1. Toy Models of Superposition** (2022)                            | Nelson Elhage et al. (Anthropic)       | **Proves superposition exists**; explains fundamental mechanics of why SAEs work.                                | [arXiv](https://arxiv.org/abs/2209.10652)                             |
| **Foundation**  | **2. Towards Monosemanticity** (Oct 2023)                            | Trenton Bricken, Adly Templeton et al. | First successful SAE on a real LLM (1-layer). Found **70% interpretable features** (e.g., "Golden Gate Bridge"). | [arXiv](https://arxiv.org/abs/2309.08600)<br>                         |
| **Foundation**  | **3. Scaling Monosemanticity** (May 2024)                            | Anthropic Interpretability Team        | Scales SAEs to production models (**Claude 3 Sonnet**). Extracted 34M features (multilingual/multimodal).        | [Web](https://transformer-circuits.pub/2024/scaling-monosemanticity/) |
| **Review**      | **4. A Survey on Sparse Autoencoders** (2025)                        | Dong Shu et al.                        | **Complete landscape overview**: covers architecture, training, evaluation, and applications.                    | [arXiv](https://arxiv.org/abs/2503.05613)                             |
| **Review**      | **5. Sparse Autoencoders Find Highly Interpretable Features** (2023) | Hoagy Cunningham et al.                | Independent validation of the SAE approach on **Pythia models**.                                                 | [arXiv](https://arxiv.org/abs/2309.08600)                             |
| **Application** | **6. Steering Language Model Refusal with SAEs** (2025)              | _Not Listed_                           | Focuses on **safety steering**; removes "refusal" features to increase model helpfulness.                        |                                                                       |
| **Application** | **7. Transcoders Find Interpretable LLM Feature Circuits** (2024)    | J. Dunefsky, P. Chlenski, N. Nanda     | Extends SAEs to **layer-to-layer transformations** (Transcoders).                                                | [arXiv](https://arxiv.org/abs/2406.11944)                             |
| **Application** | **8. Llama Scope: Extracting Millions of Features** (2024)           | _Not Listed_                           | Scales SAEs to open-source models (**Llama-3.1-8B**).                                                            | [arXiv](https://arxiv.org/abs/2410.20526)                             |
| **Biology**     | **9. SAEs Uncover Biologically Interpretable Features** (2025)       | _Not Listed_                           | Applied to protein models (**ESM2**); proves technique generalizes beyond text (Published in PNAS).              |                                                                       |
| **Critical**    | **10. AxBench: Steering LLMs?** (2025)                               | Zhengxuan Wu et al.                    | **Critical evaluation**; finds simple baselines often outperform SAEs for steering.                              | [arXiv](https://arxiv.org/abs/2501.17148)                             |

---
### Why This Matters for Principal 11

**SAEs connect to multiple Principals:**

**Principal AI Architect:**
- Design SAE-based monitoring systems
- Feature-level steering architecture

**Principal Data Scientist:**
- Manifold analysis (SAEs = discovering manifold structure)
- Dimensionality reduction with interpretability

**Principal MLOps:**
- Production monitoring via SAE features
- Real-time safety dashboards

**Principal LLMOps:**
- Feature-based debugging
- Model behavior control

