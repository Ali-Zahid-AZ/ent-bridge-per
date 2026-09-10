---
tags:
  - llmops-embedding-unembedding-layer-embedding-matrix
  - code-explanations
  - conceptual-explanations
---


---
```table-of-contents
```

---
### References

- [[Conceptual-Vector-Databases-Encoding]]
- [[Comparison-Popular-Vector-Databases]]

---

**Custom learned embeddings** are embeddings that you create by **training a neural network on your own dataset**, instead of using a pre-trained model. The goal is to have the network learn **representations (vectors) that capture relationships specific to your domain or task**. Here’s a precise breakdown:

---
### 1. Why use custom embeddings?

- Pre-trained embeddings (like Sentence Transformers or CLIP) are trained on general-purpose data.
- In specialized domains (e.g., **medical texts, chemical molecules, proprietary products**), pre-trained embeddings may **not capture the nuances** of your data.
- Custom embeddings allow the model to **learn features that are directly relevant to your task**, improving downstream performance in search, recommendation, or classification.

### 2. How it works

1. **Choose a neural network architecture** suitable for your data:
    - Text → Transformer, LSTM, or CNN
    - Images → CNN (e.g., ResNet, EfficientNet)
    - Graphs → GNNs (Graph Neural Networks)
        
2. **Define the training objective** so the network learns meaningful embeddings:
    - **Supervised:** Use labels to train the embeddings (e.g., similar/dissimilar pairs).
        - Example: Triplet Loss, Contrastive Loss, or Cross-Entropy Loss.
    - **Unsupervised/Self-supervised:** Learn embeddings without labels.
        - Example: Autoencoders, SimCLR (for images), or BERT-style masked language modeling.
            
3. **Training process:**
    - Feed raw data into the network.
    - Network outputs vectors (embeddings).        
    - Loss function encourages embeddings to **cluster similar items together** and **separate dissimilar items**.
        
4. **Use the embeddings:**
    - Store them in a **vector database** for semantic search.
    - Use them as input features for downstream ML models.
    - Compute similarity or distance between items in embedding space.
        

### 3. Example (Text)

Suppose you have a dataset of **legal documents**, and you want to retrieve similar cases:

```
import torch
from torch import nn
from torch.utils.data import DataLoader

# Simple example network
class TextEmbeddingNet(nn.Module):
    def __init__(self, vocab_size, embed_dim):
        super().__init__()
        self.embedding = nn.Embedding(vocab_size, embed_dim)
        self.fc = nn.Linear(embed_dim, embed_dim)

    def forward(self, x):
        x = self.embedding(x).mean(dim=1)  # average word embeddings
        x = self.fc(x)
        return x  # vector embedding

# Train with contrastive loss or triplet loss to cluster similar cases

```

After training, each legal document has a **custom embedding vector** capturing its unique legal semantics.

---

In short: **custom learned embeddings tailor the vector representation to your data**, which can give **much better results** than generic embeddings in specialized domains.