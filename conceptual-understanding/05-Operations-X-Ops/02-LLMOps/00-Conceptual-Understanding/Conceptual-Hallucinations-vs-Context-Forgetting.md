---
tags:
  - llmops-hallucination
  - context_forgetting
  - large-language-models-LLMs
  - llmops
---

---
[[Hallucinations-Production-Remediation]]
[[Hallucination-Tackling]]
[[Conceptual-Basics-Anatomy-of-Compute-Feature-Manifolds-Circuit-Topologies]]

---

>[!example] These are 2 distinct, but sometimes related, technical problems

### Comparative Analysis

|Feature|**Hallucination**|**Context Forgetting**|
|---|---|---|
|**Core Problem**|**Invention of false content.**|**Failure to retain/use provided information.**|
|**Root Cause**|The model's drive to produce **plausible-sounding text** overrides truthfulness. Often a **reasoning or knowledge gap**.|Hitting the technical **context window limit** or the model's architecture losing focus on earlier parts of a long conversation.|
|**Example**|You ask for a biography of a person. The model correctly gives details but **adds a false award they never won**.|You provide a 5,000-word document and ask a question about the beginning. The model **cannot "see" that part anymore** and says it doesn't have the information.|
|**Analogy**|A **confident storyteller making up exciting but false details**.|Having **short-term memory loss** in a long conversation.|
|**Nature**|**Act of _commission_** (creating falsehoods)|**Act of _omission_** (losing information)|


>[!beware] **Hallucination is an act of _commission_ (creating falsehoods). Context forgetting is an act of _omission_ (losing information).**
>
They can interact—a model that forgets the context you provided might then hallucinate to fill in the missing details—but they stem from different causes and require different solutions (e.g., **RAG** combats knowledge-based hallucinations, while a **longer context window** helps with memory).

---
## Problem-Specific Solutions

### Combating Hallucinations (The "Fabrication" Problem)

The goal here is to tether the model to truth and punish fabrication.

| Technique                                   | How It Works                                                                                                                                                                                                                                                 | Best For                                                                                                                      |
| ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------- |
| **1. Retrieval-Augmented Generation (RAG)** | **Grounds the model in facts.** Before answering, the system retrieves relevant snippets from a trusted knowledge base (documents, databases) and forces the LLM to base its answer **only** on that provided context.                                       | **Any application requiring factual accuracy**, like customer support, Q&A on internal docs, or providing latest information. |
| **2. Fine-Tuning (especially with LoRA)**   | **Teaches domain-specific patterns.** Training the model on a high-quality dataset of your domain (e.g., medical transcripts, legal briefs) makes it an expert in that style and logic, reducing nonsense in that area.                                      | **Mastering a niche domain's language and reasoning**, making outputs more consistent and on-brand.                           |
| **3. Advanced Prompting**                   | **Guides the model in real-time.** Instructions like _"Answer based only on the context. If unsure, say 'I don't know.'"_ or asking it to _"think step by step"_ (Chain-of-Thought) reduce off-script inventions.                                            | **Quick, low-cost improvements** to any LLM application. Essential for all systems.                                           |
| **4. Output Guardrails & Detection**        | **Validates the answer post-generation.** Use rules, a second verification model, or advanced methods like **semantic entropy detection** (flagging answers whose meaning changes when asked repeatedly) to catch hallucinations before they reach the user. | **High-stakes or automated systems** where safety is critical (e.g., medical advice, legal summaries).                        |

### Fixing Context Forgetting (The "Memory" Problem)

The goal here is to expand and manage the model's "working memory."

| Technique                           | How It Works                                                                                                                                                                                                                 | Best For                                                                                                 |
| ----------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| **1. Context Window Management**    | Using models with **larger context windows** (e.g., 128K tokens) lets you provide more text upfront. **Smart chunking** of long documents ensures key info is positioned where the model attends best (often in the middle). | **Processing very long documents** (entire books, lengthy transcripts) or having extended conversations. |
| **2. Architectural Improvements**   | Techniques like **hierarchical attention** or **external memory** (vector databases) allow the model to "bookmark" and recall key information from a long conversation without putting everything in the immediate window.   | **Complex, multi-session dialogues** (e.g., AI therapists, coding assistants) where history is crucial.  |
| **3. Strategic Summarization**      | The system periodically **summarizes** the conversation so far and injects the summary into the context window. This condenses past information, freeing up space for new interaction.                                       | **Long chat sessions** where the full history is too long, but core themes must be remembered.           |
| **4. Explicit Memory Instructions** | In your prompt, you can **re-state crucial info** (e.g., _"Remember, the user's name is Alex and we are discussing their 2023 tax return..."_) to re-focus the model's attention.                                            | **Manual, prompt-level control** in applications where you can programmatically track key facts.         |

### How These Problems Interact

They often compound each other.
**`A model that forgets key context is more likely to hallucinate to fill in the gaps.`**

**Example**: If you tell an LLM in a long chat, _"My allergy is penicillin,"_ but it forgets later, it might **hallucinate** a safe medication recommendation when asked.

**The most robust systems combine solutions from both columns:**
>[!beware] **RAG (for factual grounding)** + **a Large Context Window Model (for memory)** + **Strategic Summarization (to manage memory)** forms a powerful foundation for reliable, long-context applications

