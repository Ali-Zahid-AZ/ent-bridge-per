---
tags:
  - research-2024
  - llmops
  - llmops-fine-tuning
  - review-survey-articles
  - reading-list
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

- Pdf in Directory:  [Dir: The-Ultimate-Guide-to-Fine-Tuning-LLMs-from-Basics-to-Breakthroughs-Ireland-Center-for-AI-2024.pdf](<file:///home/az/04-Library/05-Operations-X-Ops/02-LLMOps/Life-Cycle-Phases/The-Ultimate-Guide-to-Fine-Tuning-LLMs-from-Basics-to-Breakthroughs-Ireland-Center-for-AI-2024.pdf>)
- arXiv: [arXiv: The Ultimate Guide to Fine-Tuning LLMs from Basics to Breakthroughs: An Exhaustive Review of Technologies, Research, Best Practices, Applied Research Challenges and Opportunities](https://arxiv.org/abs/2408.13296)
- [[Conceptual-LoRA-Fine-Tuning-LLMOps]]
- [[Large-Language-Models-A-Survey]]
---
### 1. LLM Fine-Tuning: 7 Stage Pipeline

> The `7`-stage pipeline for fine-tuning LLMs

#### I. Stage 1: Dataset Preparation  

> Adapting the pre-trained model for specific tasks by updating its parameters ➝ using a new, cleaned, and formatted dataset of `<input, output>` pairs

> #llmops-dataset-preparation

#### II. Stage 2: Model Initialisation  

> Setting up the initial parameters and configurations of the LLM to ensure optimal performance, efficient training, and the avoidance of gradient issues.

> #llmops-model-intialization

#### III. Stage 3: Training Environment Setup 

> - **Configuring** the 
> 	- necessary **infrastructure**
> 	- selecting **training data** 
> 	- defining the model's **architecture** + **hyperparameters** 
> 	- running **training iterations**

> #llmops-training-environment-setup

4. **Stage 4: Partial or Full Fine-Tuning** - Updating the parameters of the LLM using the task-specific dataset, either comprehensively (full fine-tuning) or efficiently via techniques like Half Fine-Tuning (HFT) or Parameter-Efficient Fine-Tuning (PEFT).
    
5. **Stage 5: Evaluation + Validation** - Assessing the fine-tuned LLM on unseen data using metrics like cross-entropy and monitoring loss curves to detect overfitting or underfitting.
    
6. **Stage 6: Deployment** - Configuring the operational model to run efficiently on designated hardware or software platforms and establishing integration, security, and monitoring systems.
    
7. **Stage 7: Monitoring + Maintenance** - Continuously tracking performance post-deployment, addressing issues, and adapting the model to new data or evolving requirements.

---
### 2. Introductory 

The research report, "The Ultimate Guide to Fine-Tuning LLMs from Basics to Breakthroughs," functions as a comprehensive blueprint for adapting foundational models to specific tasks. It defines a full lifecycle pipeline—spanning data preparation, model initialization, training setup, fine-tuning execution, validation, deployment, and ongoing monitoring.

#### I. The Mechanics of Adaptation: Pre-training vs. Fine-Tuning 

To grasp the first principles here, it is vital to distinguish between the foundational circuitry built during pre-training and the targeted adjustments made during fine-tuning. Pre-training constructs the core mechanisms across the activation space manifold—such as induction heads for in-context learning and early-layer syntax processors. Fine-tuning does not build these massive circuits from scratch; rather, it projects the existing representations into narrower, task-specific geometries to steer the model's outputs. This allows the model to excel in specialized domains by re-weighting how features are activated.

##### I. Parameter-Efficient Innovations: PEFT

Full fine-tuning updates every parameter, which is computationally prohibitive and often destroys foundational circuits—a phenomenon known as catastrophic forgetting. The report heavily emphasizes Parameter-Efficient Fine-Tuning (PEFT) to solve this.

- **LoRA and QLoRA:** Low-Rank Adaptation (LoRA) freezes the original weight matrices and injects trainable low-rank matrices (A and B) into the transformer layers. Instead of modifying the entire high-dimensional space, LoRA finds a low-dimensional subspace to alter the activation vectors, heavily reducing the memory footprint. QLoRA takes this further by quantizing the base model parameters down to 4-bit precision, making it feasible to train robust models on highly constrained hardware nodes.


- **DoRA (Weight-Decomposed Low-Rank Adaptation):** This method decomposes the pre-trained weights into two distinct components: magnitude and direction. From a geometric perspective, changing the direction of a vector alters the actual feature being represented, while changing the magnitude alters how strongly that feature activates downstream circuits. DoRA applies low-rank updates strictly to the directional component, allowing for nuanced structural adjustments that closely mimic full fine-tuning without the latency overhead.


- **Half Fine-Tuning (HFT):** HFT selectively freezes half of the parameters within the self-attention and feed-forward blocks during training. This strategically preserves the underlying structural knowledge while allowing the active parameters to mold to new objectives.

> #llmops-fine-tuning-PEFT-LoRA  | #llmops-fine-tuning-PEFT-QLoRA | #llmops-fine-tuning-parameter-efficient-innovations-PEFT |  #llmops-fine-tuning-PEFT-DoRA 
> #llmops-half-fine-tuning-HFT


#### II. Architectural Frameworks: MoE and MoA

The document explores pushing models beyond standard dense transformer topologies:

- **Mixture of Experts (MoE):** Models like Mixtral use a routing mechanism to direct tokens to specialized sub-networks (experts) within the feed-forward layers. This sparsifies the activation patterns, allowing a token to access a massive parameter count while only computing through a fraction of them (e.g., 13 billion out of 47 billion active parameters).
    
- **Mixture of Agents (MoA):** Instead of routing inside a single model, MoA constructs a layered architecture out of entirely separate LLMs. Some models act as "proposers" to generate diverse context, while "aggregators" synthesize these into a final output. This builds a macro-circuit out of entire distinct models, enhancing reasoning by forcing an ensemble consensus.
    
- **Lamini Memory Tuning:** To combat hallucinations, Lamini introduces a Massive Mixture of Memory Experts (MoME). Standard MLPs tend to generalize and blur specific facts. Lamini attaches millions of specialized adapters via cross-attention, effectively creating isolated memory banks that can store and retrieve exact factual representations without bleeding into the general logic circuits.
    

**Alignment and Steering (PPO, DPO, ORPO)**

Aligning the adjusted weights to human preferences is the final mechanical hurdle.

- **PPO (Proximal Policy Optimization):** This requires an external reward model to grade the LLM's outputs, using reinforcement learning to update the policy while clipping gradients to prevent the model from destabilizing.
    
- **DPO (Direct Preference Optimization):** DPO bypasses the reward model entirely. It treats the language model itself as the reward mechanism, adjusting the logits directly by contrasting chosen and rejected text pairs. Viewed through a logit lens, DPO actively suppresses the probability distributions of undesired behavioral circuits.
    
- **ORPO (Odds-Ratio Preference Optimization):** This monolithic method adds a specific penalization loss to supervised fine-tuning, driving down the likelihood of rejected tokens without needing reference models.
    

**Practical Applicability and System Architecture** The seven-stage pipeline detailed here provides the exact scaffolding needed to architect enterprise-grade machine learning systems. Moving a model from initial dataset curation through HFT or DoRA, and finally into a production environment, demands strict orchestration. Training environments require high-performance compute, but techniques like QLoRA or adapters open the door to executing sophisticated fine-tuning runs locally before offloading heavier, multi-GPU workloads to scalable cloud environments like Vertex AI or Modal when constructing complex MoA frameworks.

While the text excels at detailing the engineering execution of these configurations, a deeper exploration of how these fine-tuning techniques specifically alter the superposition of features within the residual stream remains an open frontier. Investigating the shifting geometry of activation spaces before and after Lamini tuning or DoRA provides the crucial link between deploying an efficient pipeline and truly understanding the mechanical truth of the model.


---
### 3. Section 1: Introduction 

The history of language models is the history of mapping human semantics into a space that a machine can physically manipulate. Section 1 traces this evolution to explain exactly why we need the seven-stage pipeline today.

#### I. Evolution of the Manifold: From Counting to Context

> To understand how we fine-tune a model ➝ we first must look at what is being tuned.

- **Statistical Language Models (SLMs):** In the 1990s, models relied purely on probability and counting. Using techniques like Maximum Likelihood Estimation (MLE) and N-grams, they calculated the conditional probability of a word appearing next in a sequence based purely on historical text frequencies. There were no hidden layers or activation spaces—just statistical mapping.

> #statistical-language-models-SLMs

- **Neural Language Models (NLMs):** The 2000s introduced a massive structural shift. NLMs introduced vector spaces (using tools like Word2Vec), which allowed computers to understand semantic relationships by measuring the angles between word vectors in a continuous, high-dimensional space. This was the beginning of models using interconnected neurons organized into layers, resembling the human brain's structure.

> #neural-language-models-NLMs

- **Pre-trained Language Models (PLMs) + LLMs:** Following recurrent networks (RNN/LSTM), the true breakthrough arrived in 2017 with the Transformer architecture, leading to PLMs like BERT and GPT-2. Today's LLMs (like GPT-4 and Llama) are trained on massive text corpora using tens of billions of parameters.

> #pretrained-language-models-PLMs | #large-language-models-LLMs 


![[Pasted image 20260401042512.png | 600]]

> _A chronological timeline showcasing the evolution of LLMs from 1990 to 2023. This progression begins with early statistical models such as N-grams, transitions through neural language models like Word2Vec and RNN/LSTM, and advances into the era of pre-trained models with the introduction of transformers and attention mechanisms. The figure highlights significant milestones, including the development of BERT, GPT series, and recent innovations such as GPT-4 and ChatGPT, demonstrating the rapid advancements in LLM technology over time_ 

> [arXiv: History, Development, and Principles of Large Language Models-An Introductory Survey](https://arxiv.org/abs/2402.06853v3)

#### II. The Mechanics of Pre-Training vs. Fine-Tuning

The document establishes a critical mechanical boundary between the 2 phases:

- **Pre-Training:** This is the construction phase. The model is trained on a vast amount of unlabelled text to build its general linguistic knowledge. Mechanistically, this is where the foundational circuits—such as induction heads for in-context learning and early-layer syntax processors—are built across the parameter space. It is computationally expensive and takes weeks to months.
    
- **Fine-Tuning:** This is the adaptation phase. You do not build massive circuits from scratch here. Instead, you adapt the pre-trained model to specific tasks using a smaller, task-specific labelled dataset. You are physically shifting the model's existing weight matrices to amplify specific, pre-existing features while suppressing generalized behaviors. This improves task-specific performance and reduces training duration to days or weeks.

> #llmops-pretraining 

The text outlines 3 primary types of fine-tuning:

1. **Unsupervised Fine-Tuning:** The model is exposed to unlabelled text from a target domain to refine its understanding of domain-specific language (useful for broad fields like medicine).
    
2. **Supervised Fine-Tuning (SFT):** The model is given tightly formatted `<input, output>` pairs (like text snippets with class labels) to steer its predictive distribution toward a specific task.
    
3. **Instruction Fine-Tuning:** A highly specific form of SFT where data is structured as explicit natural language commands (prompts) and responses, which fundamentally alters how the model routes information to act as a specialized assistant.
    
> #llmops-fine-tuning-unsupervised | #llmops-fine-tuning-supervised  | #llmops-fine-tuning-instruction 


**Fine-Tuning vs. Retrieval-Augmented Generation ➝ RAG)

> #llmops-retrieval-augmented-generation-rag 

Finally, Section 1 introduces RAG, which provides a critical alternative to altering the model's static weights.

RAG operates entirely at inference time. Instead of changing the model's internal parameters, a RAG workflow retrieves relevant, pertinent information from an external vector database and injects it directly into the context window (the prompt). Mechanistically, this exploits the in-context learning circuits constructed during pre-training, allowing the model's attention heads to simply read and reason over the newly provided facts .

The pipeline for RAG consists of 5 steps:

1. **Data Indexing:** Chunking and storing data in a vector database.
    
2. **Input Query Processing:** Refining user queries for better search compatibility.
    
3. **Searching and Ranking:** Retrieving the most relevant data using algorithms like BM25 or deep learning models like BERT.
    
4. **Prompt Augmentation:** Appending the retrieved data to the original query.
    
5. **Response Generation:** Using the augmented prompt to generate an answer grounded in the retrieved facts.

> #llmops-retrieval-augmented-generation-rag-data-indexing | #llmops-retrieval-augmented-generation-rag-input-query-processing 
> #llmops-retrieval-augmented-generation-rag-searching | #llmops-retrieval-augmented-generation-rag-ranking 
> #llmops-retrieval-augmented-generation-rag-prompt-augmentation 
> #llmops-retrieval-augmented-generation-rag-response-generation  

**The Architectural Choice:**

The document provides a clear decision boundary for system design:

- Use **RAG** when you need up-to-date, highly accurate, dynamic external knowledge and need to strictly suppress hallucinations (as it grounds outputs in factual documents rather than static weights).
- Use **Fine-Tuning** when you need the model to fundamentally adjust its intrinsic behavior, reasoning style, or internalize a highly specific domain tone.



![[Pasted image 20260401043011.png | 600]]

> _Mind map depicting various dimensions of LLMs, covering aspects from pre-training and fine-tuning methodologies to efficiency, evaluation, inference, and application domains. Each dimension is linked to specific techniques, challenges, and examples of models that exemplify the discussed characteristics. This diagram serves as an overview of the multifaceted considerations in the development and deployment of LLMs_

>[arXiv: A Comprehensive Overview of Large Language Models](https://arxiv.org/abs/2307.06435)

---
### Section 2: Seven Stage Fine-Tuning Pipeline for LLM


