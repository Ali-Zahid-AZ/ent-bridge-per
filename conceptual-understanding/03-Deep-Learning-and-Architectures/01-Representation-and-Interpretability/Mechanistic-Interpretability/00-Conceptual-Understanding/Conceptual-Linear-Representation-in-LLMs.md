---
tags:
  - reading-list
---

---
```table-of-contents
```
---
### References

---

**The Geometry of Meaning – Linear Representations in Large Language Models**

**Abstract**

The Linear Representation Hypothesis (LRH) posits that Large Language Models (LLMs) encode high-level semantic concepts—such as syntax, truth, sentiment, space, and time—as linear directions within their high-dimensional activation spaces. This review synthesizes foundational theoretical work and empirical evidence demonstrating that these concepts are not merely distributed nebulously but are geometrically organized along extractable vector axes. We derive these phenomena from first principles, explore the specific geometries of five key semantic domains, and provide a unified methodological framework for extracting and manipulating these representations.

---

### **I. Introduction: The Cartography of Cognition**

If we view an LLM not as a "black box" but as a high-dimensional manifold, we discover that "meaning" is a coordinate system. Just as a physical map uses cardinal directions (North, South, East, West) to navigate space, LLMs use internal vector directions to navigate concepts.

- **The Phenomenon:** To change a sentence from "Present Tense" to "Past Tense," the model effectively adds a specific "Past Tense Vector" to the representation.
    
- **The Implication:** This suggests that LLMs do not just memorize statistics; they construct a structured, manipulable model of the world—a "World Model" that is surprisingly linear.
    

---

### **II. Theoretical Foundation: First Principles & Axioms**

To understand _why_ these concepts are linear, we must establish the underlying physical laws of the Transformer architecture.

#### **Axiom 1: The Residual Stream as a Scratchpad**

The Transformer architecture is defined by the residual connection:

$$x_{l+1} = x_l + F_l(x_l)$$

Where $x_l$ is the information state (activation) at layer $l$, and $F_l$ is the processing block (Attention/MLP).

- **Implication:** The model "reads" from $x_l$ and "writes" updates to it. To preserve information across layers without distortion, the most efficient method is **additive** updates.
    
- **Result:** Features tend to be linear directions so they can be added or subtracted arithmetically.
    

#### **Axiom 2: Superposition (High-Dimensional Storage)**

Models have more features to represent (millions of concepts) than dimensions to store them ($d \approx 4096$).

- **The Mechanism:** Models use **Superposition**—storing features as non-orthogonal vectors that interfere slightly but remain distinguishable.
    
- **The Johnson-Lindenstrauss Lemma:** In high-dimensional space, random vectors are nearly orthogonal. This allows the model to pack thousands of "linear directions" into a smaller space.
    
- _Citation: Elhage, N., et al. (2022). "Toy Models of Superposition."_
    

---

### **III. The "Big Five" Semantic Domains**

We review the specific geometry of five core concepts, moving from low-level structure to high-level world modeling.

#### **1. Syntax: The Structural Probe**

- **Concept:** Syntax (grammar, tree structure) is not explicitly given to the model, yet it must exist for coherent generation.
    
- **The Geometry:** Syntax is encoded via a **distance metric**.
    
    - **Tree Distance:** The distance between two words in a parse tree corresponds to the squared Euclidean distance between their transformed vectors:
        
        $$d_{tree}(w_i, w_j) \approx ||B(h_i) - B(h_j)||^2$$
        
    - **Tree Depth:** The depth of a word in the tree corresponds to the norm (length) of its vector:
        
        $$depth(w_i) \approx ||B(h_i)||^2$$
        
- _Citation: Hewitt, J., & Manning, C. D. (2019). "A Structural Probe for Finding Syntax in Word Representations."_
    

#### **2. Truth: The Mass-Mean Axis**

- **Concept:** The factual validity of a statement.
    
- **The Geometry:** Truth is a consistent direction. If we take the centroid of true statements $\mu_T$ and false statements $\mu_F$, the vector $\vec{v}_{truth} = \mu_T - \mu_F$ generalizes across topics.
    
    - **Observation:** This direction is robust to negation ("not") if handled via a 2D subspace (Truth $\times$ Polarity).
        
- _Citation: Marks, S., & Tegmark, M. (2023). "The Geometry of Truth."_
    

#### **3. Sentiment: The "Neuron" to "Direction" Shift**

- **Concept:** The emotional valence (Positive vs. Negative).
    
- **The Geometry:** Early research identified a single "Sentiment Neuron" in LSTM models. In Transformers, this expands to a **Sentiment Direction**.
    
- **The Summarization Motif:** Interestingly, sentiment is not just encoded on adjectives ("good", "bad") but is "summarized" at neutral positions like punctuation (commas, periods) to prepare for the next token prediction.
    
- _Citation: Tigges, C., et al. (2023). "Linear Representations of Sentiment in Large Language Models."_
    

#### **4. Space: The Global Manifold**

- **Concept:** Physical locations (Cities, Landmarks).
    
- **The Geometry:** LLMs (specifically Llama-2) contain a literal projection of the Earth.
    
    - A linear regression can map the activation of a city name (e.g., "Paris") directly to its real-world Latitude and Longitude.
        
    - **Space Neurons:** Specific neurons fire only when the context is a specific geographic region (e.g., "The UK neuron").
        
- _Citation: Gurnee, W., & Tegmark, M. (2023). "Language Models Represent Space and Time."_
    

#### **5. Time: The Chronological Axis**

- **Concept:** Historical dates and temporal ordering.
    
- **The Geometry:** Similar to space, historical figures and events are organized along a "Time Direction."
    
    - The projection of "Napoleonic Wars" falls chronologically before "World War II" along this axis.
        
    - This suggests the model has learned a 1D timeline of human history to predict temporal sequences.
        
- _Citation: Gurnee, W., & Tegmark, M. (2023)._
    

---

### **IV. Unified Methodology: Extraction & Intervention**

To work with these concepts, we utilize a standardized pipeline of **Probing** (Extraction) and **Steering** (Intervention).

#### **1. Extraction (Finding $\vec{v}$)**

We typically use **Difference-in-Means** or **PCA** on contrastive pairs.

$$\vec{v}_{concept} = \mathbb{E}[h(x_{positive})] - \mathbb{E}[h(x_{negative})]$$

#### **2. Intervention (Steering)**

To prove causality, we inject the vector during inference. This is **Activation Addition**.

$$h_{new} = h_{original} + \alpha \cdot \vec{v}_{concept}$$

- If $\alpha > 0$: We reinforce the concept (e.g., make the output happier).
    
- If $\alpha < 0$: We suppress the concept (e.g., make the output sadder/neutral).
    

---

### **V. Code & Visualization: The Concept Compass**

#### **Visualization: The Geometry of Space and Truth**

Plaintext

```
       [Truth Axis]
            ^
            |  (Fact: "Paris is in France")
      TRUE  |      *
            |
            |              (Fact: "Cairo is in Egypt")
            |                  *
<-----------+----------------------------------> [Space Axis: Longitude]
            |
            |      *
      FALSE |  (Hallucination: "Paris is in Germany")
            |
            v
```

#### **Code: The Universal Linear Probe**

A unified Python class to extract and steer any of these five concepts.

Python

```
import torch
from sklearn.decomposition import PCA

class ConceptProbe:
    def __init__(self, model, hidden_layer_idx):
        self.model = model
        self.layer = hidden_layer_idx
        self.direction = None
        
    def extract_direction(self, positive_texts, negative_texts, tokenizer):
        """
        Extracts the linear direction separating two concepts (e.g., True vs False).
        Using Difference-in-Means (Mass-Mean Shift).
        """
        # 1. Get Activations
        pos_acts = self._get_acts(positive_texts, tokenizer)
        neg_acts = self._get_acts(negative_texts, tokenizer)
        
        # 2. Compute Centroids
        mu_pos = torch.mean(pos_acts, dim=0)
        mu_neg = torch.mean(neg_acts, dim=0)
        
        # 3. Compute Direction
        self.direction = mu_pos - mu_neg
        self.direction = self.direction / torch.norm(self.direction)
        
        return self.direction

    def steer(self, text, tokenizer, strength=5.0):
        """
        Injects the concept direction during generation.
        """
        # Hook function to add the vector
        def hook_fn(module, input, output):
            # output shape: [batch, seq, hidden]
            return output + (strength * self.direction.to(output.device))
            
        # Register hook
        handle = self.model.layers[self.layer].register_forward_hook(hook_fn)
        
        # Generate
        inputs = tokenizer(text, return_tensors="pt").to(self.model.device)
        out = self.model.generate(**inputs, max_new_tokens=50)
        
        # Remove hook
        handle.remove()
        return tokenizer.decode(out[0])

    def _get_acts(self, texts, tokenizer):
        # Helper to get hidden states (omitted for brevity)
        acts = []
        for t in texts:
            inputs = tokenizer(t, return_tensors="pt").to(self.model.device)
            with torch.no_grad():
                out = self.model(**inputs, output_hidden_states=True)
            # Get last token activation at specified layer
            acts.append(out.hidden_states[self.layer][0, -1, :])
        return torch.stack(acts)
```

---

### **VI. Next Step**

Would you like to explore the **"Summarization Motif"** in sentiment analysis further? I can provide a specific visualization of how LLMs move sentiment information from adjectives to punctuation marks (like commas) to "store" the mood for the rest of the sentence.

[Geometry of Truth](https://www.youtube.com/watch?v=7XNqsFA0Znw)

This video features Samuel Marks (author of "The Geometry of Truth") discussing the specific findings on how truth is represented as a linear direction and the "Mass-Mean" probing technique mentioned in the review.