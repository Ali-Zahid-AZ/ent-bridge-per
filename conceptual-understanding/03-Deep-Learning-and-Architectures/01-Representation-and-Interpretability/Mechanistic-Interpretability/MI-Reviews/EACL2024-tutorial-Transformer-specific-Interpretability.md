---
tags:
  - reading-list
---




---
[GitHub - interpretingdl/eacl2024\_transformer\_interpretability\_tutorial: Materials for EACL2024 tutorial: Transformer-specific Interpretability](https://github.com/interpretingdl/eacl2024_transformer_interpretability_tutorial?tab=readme-ov-file)
[Tutorials](https://projects.illc.uva.nl/indeep/tutorial/)

**Reading List**
**Part 1: Model-agnostic Interpretability**
**General Interpretability:**

Doshi-Velez & Kim (2017) - Towards a rigorous science of interpretable machine learning
Lipton (WHI 2016) - The Mythos of Model Interpretability
Feature Attributions:

Lundberg & Lee (NeurIPS 2017) - A Unified Approach to Interpreting Model Predictions
Sundararajan & Najmi (PMLR 2020) - The many Shapley values for model explanation
Chen et al. (2020) - True to the Model or True to the Data?
Covert et al. (JMLR 2021) - Explaining by removing: a unified framework for model explanation
Probing:

Hewitt & Manning (EMNLP-IJCNLP 2019) - Designing and Interpreting Probes with Control Tasks
Voita & Titov (EMNLP 2020) - Information-Theoretic Probing with Minimum Description Length
Elazar et al. (TACL 2020) - Amnesic Probing: Behavioral Explanation with Amnesic Counterfactuals
Pimentel et al. (ACL 2020) - Information-Theoretic Probing for Linguistic Structure
Jumelet et al. (ACL 2021) - Language Models Use Monotonicity to Assess NPI Licensing
White et al. (NAACL 2021) - A Non-Linear Structural Probe
Faithfulness:

McCoy et al. (ACL 2019) - Right for the Wrong Reasons: Diagnosing Syntactic Heuristics in Natural Language Inference
Hao (BlackboxNLP 2020) - Evaluating attribution methods using white-box LSTMs
Pruthi et al., (TACL 2022) - Evaluating Explanations: How Much Do Explanations from the Teacher Aid Students?
Bastings et al. (EMNLP 2022) - “Will You Find These Shortcuts?” A Protocol for Evaluating the Faithfulness of Input Salience Methods for Text Classification
Madsen et al. (EMNLP 2022) - Evaluating the Faithfulness of Importance Measures in NLP by Recursively Masking Allegedly Important Tokens and Retraining
Jumelet & Zuidema (ACL 2023) - Feature Interactions Reveal Linguistic Structure in Language Models
On the limitation of general-purpose interpretability methods
Sixt et al. (PMLR 2020) - When Explanations Lie: Why Many Modified BP Attributions Fail
Atanasova et al. (EMNLP 2020) - A Diagnostic Study of Explainability Techniques for Text Classification
Neely et al. (2022) - A Song of (Dis)agreement: Evaluating the Evaluation of Explainable Artificial Intelligence in Natural Language Processing
Krishna et al. (2022) - The Disagreement Problem in Explainable Machine Learning: A Practitioner's Perspective
Bilodeau et al. (PNAS 2024) - Impossibility Theorems for Feature Attribution
Part 2: Context Mixing
Limitations of Attention:

Clark et al. (BlackboxNLP 2019) - What Does BERT Look at? An Analysis of BERT’s Attention
Bastings & Filippova (BlackboxNLP 2020) - The elephant in the interpretability room: Why use attention as explanation when we have saliency methods?
Bibal et al. (ACL 2022) - Is Attention Explanation? An Introduction to the Debate
Hassid et al. (Findings of EMNLP 2022) - How Much Does Attention Actually Attend? Questioning the Importance of Attention in Pretrained Transformers
Bondarenko et al. (2023) - Quantizable Transformers: Removing Outliers by Helping Attention Heads Do Nothing
Measures of context-mixing beyond attention:

Clark et al. (BlackboxNLP 2019) - What Does BERT Look at? An Analysis of BERT’s Attention
Abnar & Zuidema (ACL 2020) - Quantifying Attention Flow in Transformers
Kobayashi et al. (EMNLP 2020) - Attention is Not Only a Weight: Analyzing Transformers with Vector Norms
Kobayashi et al. (EMNLP 2021) - Incorporating Residual and Normalization Layers into Analysis of Masked Language Models
Ferrando et al. (EMNLP 2022) - Measuring the Mixing of Contextual Information in the Transformer
Modarressi et al. (NAACL 2022) - GlobEnc: Quantifying Global Token Attribution by Incorporating the Whole Encoder Layer in Transformers
Mohebbi et al. (EACL 2023) - Quantifying Context Mixing in Transformers
Chefer et al. (CVPR 2021) - Transformer Interpretability Beyond Attention Visualization
Ferrando et al. (ACL 2023) - Explaining How Transformers Use Context to Build Predictions
Modarressi et al. (ACL 2023) - DecompX: Explaining Transformers Decisions by Propagating Token Decomposition
Mohebbi et al. (EMNLP 2023) - Homophone Disambiguation Reveals Patterns of Context Mixing in Speech Transformers
Kobayashi et al. (ICLR spotlight 2024) - Analyzing Feed-Forward Blocks in Transformers through the Lens of Attention Map
Part 3: Mechanistic Interpretability / Circuits
Circuits:

Wang et al. (ICLR 2023) - Interpretability in the Wild: a Circuit for Indirect Object Identification in GPT-2 small
Hanna et al. (NeurIPS 2023) - How does GPT-2 compute greater-than?: Interpreting mathematical abilities in a pre-trained language model
Prakash et al. (ICLR 2024) - Fine-Tuning Enhances Existing Mechanisms: A Case Study on Entity Tracking
Merullo et al. (ICLR 2024) - Circuit Component Reuse Across Tasks in Transformer Language Models
Nanda et al. (ICLR 2023) - Progress measures for grokking via mechanistic interpretability
Automated circuit finding:

Conmy et al. (NeurIPS 2023) - Towards Automated Circuit Discovery for Mechanistic Interpretability
Edge Attribution Patching:
Blog post by Nanda (2023) - Attribution Patching: Activation Patching At Industrial Scale
Syed et al. (NeurIPS 2023 ATTRIB Workshop) - Attribution Patching Outperforms Automated Circuit Discovery
Kramár et al. (2024) - AtP*: An efficient and scalable method for localizing LLM behaviour to components
EAP-IG (coming soon!)
Studies of individual components:

Gould et al. (ICLR 2024) - Successor Heads: Recurring, Interpretable Attention Heads In The Wild
McDougall et al. (2024) - Copy Suppression: Comprehensively Understanding an Attention Head
Mechanistic Interpretability Methods:
Vig et al. (NeurIPS 2020) - Causal Mediation Analysis for Interpreting Neural NLP: The Case of Gender Bias
Geiger et al. (NeurIPS 2021) - Causal Abstractions of Neural Networks
Goldowsky-Dill et al. (2023) - Localizing Model Behavior with Path Patching
Makelov et al. (ICLR 2024) - Is This the Subspace You Are Looking for? An Interpretability Illusion for Subspace Activation Patching
Wu et al. (2024) - A Reply to Makelov et al. (2023)'s "Interpretability Illusion" Arguments
hang and Nanda (ICLR 2024) - Towards Best Practices of Activation Patching in Language Models: Metrics and Methods
Chan et al. (2022) - Rigorously Testing Interpretability Hypotheses Using Causal Scrubbing
Anthropic’s Transformer Circuits Thread:

Elhage et al. (2021) - A Mathematical Framework for Transformer Circuits
Olsson et al. (2022) - In-context Learning and Induction Heads
Elhage et al. (2022) - Toy Models of Superposition
See all work in the thread here
Other mechanistic work:

Meng et al. (NeurIPS 2022) - Locating and Editing Factual Associations in GPT
Hase et al. (NeurIPS 2023) - Does Localization Inform Editing? Surprising Differences in Causality-Based Localization vs. Knowledge Editing in Language Models
Todd et al. (ICLR 2024) - Function Vectors in Large Language Models
Li et al. (NeurIPS 2022) - Emergent World Representations: Exploring a Sequence Model Trained on a Synthetic Task
Follow-up blog post by Nanda (2022) - Actually, Othello-GPT Has A Linear Emergent World Representation
Olah / Cammarata et al. (2020) - Circuits Thread