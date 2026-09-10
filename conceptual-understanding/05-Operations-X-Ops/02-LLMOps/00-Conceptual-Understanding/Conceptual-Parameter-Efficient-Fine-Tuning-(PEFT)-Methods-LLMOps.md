---
tags:
  - llm-fine-tuning
  - llmops
  - llmops-fine-tuning-PEFT-LoRA
---

---
[[Hallucination-Tackling]]
[[Hallucinations-LoRA-Fine-Tuning]]
[[Hallucination-Cross-Layer-Probing]]
[[Hallucinations-Production-Remediation]]

---
>[!WARNING] There are multiple parameter-efficient fine-tuning (PEFT) techniques beyond LoRA including 
>- **Adapter Layers** (insert small bottleneck modules between transformer layers)
>- **Prefix Tuning** (prepend trainable soft prompts to each layer)
>- **(IA)³ (Infused Adapter by Inhibiting and Amplifying Inner Activations)** which scales activations with learned vectors
>- **Prompt Tuning** (optimize continuous prompt embeddings)
>- **BitFit** (only train bias parameters)
>- **QLoRA** (quantized LoRA), all of which modify/augment the base model with minimal trainable parameters while keeping the foundation frozen

---

Imagine you have a massive encyclopedia (the pre-trained LLM) that cost millions to create
You want to specialize it for medical terminology without rewriting the entire thing

>[!WARNING] PEFT methods are different strategies for adding "sticky notes" (adapters), "bookmarks" (prefixes), or "highlighter marks" (scaling vectors) that guide how the encyclopedia is read, without changing the original text.

**`Why Multiple Methods Exist`**
Each technique makes different trade-offs between:
- **Memory efficiency** (how much GPU RAM needed)
- **Inference latency** (does it slow down predictions?)
- **Task performance** (how close to full fine-tuning?)
- **Flexibility** (can you swap adapters easily?)

---
## 1. Adapter Layers

**`What Are Adapters?`** : Small neural network "modules" inserted between the frozen layers of a transformer. Think of them as translation boxes: the main model speaks "general English," and adapters translate to "medical jargon" or "legal terminology" on the fly.
**`What Do They Do?`** :Add 2-10% trainable parameters while keeping 90-98% of the model frozen. At inference, the adapter processes every token, adding minimal latency (~5-15%).
**`Why Use Them?*`* : Historically the first PEFT method (Google, 2019). More stable training than LoRA for very small datasets (<500 examples) because the bottleneck architecture acts as strong regularization.

--
### The Architecture

#### Bottleneck Design

```bash

Original Transformer Layer:
┌─── ──────────────────────────────────────┐
│ Input (x)                                │
│   ↓                                      │
│ Multi-Head Attention                     │
│   ↓                                      │
│ Add & Norm                               │
│   ↓                                      │
│ Feed-Forward Network                     │
│   ↓                                      │
│ Add & Norm                               │
│   ↓                                      │
│ Output                                   │
└──── ─────────────────────────────────────┘

With Adapter Layers:
┌ ─────────────────────────────────────────┐
│ Input (x)                                │
│   ↓                                      │
│ Multi-Head Attention (FROZEN)            │
│   ↓                                      │
│ Add & Norm                               │
│   ↓                                      │
│ ┌─────────────────────────────────────┐  │
│ │ ADAPTER MODULE                      │  │
│ │  ↓ Down-project (d → r)             │  │
│ │  ↓ Non-linearity (GELU/ReLU)        │  │
│ │  ↓ Up-project (r → d)               │  │
│ │  ↓ Residual connection              │  │
│ └─────────────────────────────────────┘  │
│   ↓                                      │
│ Feed-Forward Network (FROZEN)            │
│   ↓                                      │
│ Add & Norm                               │
│   ↓                                      │
│ ┌─────────────────────────────────────┐  │
│ │ ADAPTER MODULE                      │  │
│ └─────────────────────────────────────┘  │
│   ↓                                      │
│ Output                                   │
└──────────────────────────────────────── ─┘
````

--
### Mathematical Formulation

**`Adapter Forward Pass`**

```python
def adapter_forward(x, W_down, W_up, bias_down, bias_up):
    """
    x: Input activations (batch, seq_len, d_model)
    W_down: Down-projection (d_model, r)
    W_up: Up-projection (r, d_model)
    r: Bottleneck dimension (typically d_model / 16)
    """
    # Down-project
    h = x @ W_down + bias_down  # (batch, seq_len, r)
    
    # Non-linearity (critical for expressivity)
    h = nn.GELU()(h)  # or ReLU, SiLU
    
    # Up-project
    h = h @ W_up + bias_up  # (batch, seq_len, d_model)
    
    # Residual connection (CRITICAL)
    return x + h  # Skip connection prevents gradient vanishing
```

**`Parameter Count`**

- For a single adapter in a layer with dimension **d**:

```bash
Parameters = d × r + r + r × d + d
           = 2dr + r + d
           ≈ 2dr  (dominant term)
```

- For BERT-base (d=768, r=64):

```bash
Adapter params = 2 × 768 × 64 = 98,304 per adapter
Full layer params = 768² × 4 = 2,359,296
Reduction: 24x fewer parameters
```

--
### Configuration Schema

#### Bottleneck Size Selection

|**Bottleneck (r)**|**% of Layer**|**Use Case**|**Performance**|
|---|---|---|---|
|r = d/32 (24)|0.3%|Extreme efficiency|75-80% of full FT|
|r = d/16 (48)|0.6%|Standard setting|85-90% of full FT|
|r = d/8 (96)|1.2%|High capacity|92-95% of full FT|
|r = d/4 (192)|2.5%|Maximum quality|95-98% of full FT|

**`IBM Recommendation:`** Start with **r = d/16** (BERT: 48, RoBERTa: 48, GPT: 128-256)

#### Placement Strategy

```python
class AdapterConfig:
    """Adapter hyperparameters"""
    
    bottleneck_size: int = 64           # Bottleneck dimension
    non_linearity: str = "gelu"         # Activation function
    adapter_dropout: float = 0.1        # Dropout INSIDE adapter
    add_layer_norm: bool = True         # Stabilize training
    
    # Placement options
    adapter_placement: str = "after_attention_and_ffn"  
    # Options: 
    # - "after_attention_and_ffn" (2 adapters per layer)
    # - "after_ffn_only" (1 adapter per layer, faster)
    # - "after_attention_only" (rare, for attention-heavy tasks)
    
    # Initialization (CRITICAL)
    init_scale: float = 1e-3  # Near-zero init prevents disruption

```

--
### Implementation Blueprint

#### Adapter Module Code

```python
class AdapterLayer(nn.Module):
    """Bottleneck adapter following Houlsby et al. (2019)"""
    
    def __init__(self, d_model, bottleneck_size, dropout=0.1):
        super().__init__()
        
        self.down_project = nn.Linear(d_model, bottleneck_size)
        self.up_project = nn.Linear(bottleneck_size, d_model)
        self.activation = nn.GELU()
        self.dropout = nn.Dropout(dropout)
        self.layer_norm = nn.LayerNorm(d_model)
        
        # Critical: Near-zero initialization
        nn.init.normal_(self.down_project.weight, std=1e-3)
        nn.init.normal_(self.up_project.weight, std=1e-3)
        nn.init.zeros_(self.down_project.bias)
        nn.init.zeros_(self.up_project.bias)
    
    def forward(self, x):
        residual = x
        
        # Adapter pathway
        x = self.down_project(x)
        x = self.activation(x)
        x = self.dropout(x)
        x = self.up_project(x)
        x = self.dropout(x)
        
        # Residual connection
        x = residual + x
        x = self.layer_norm(x)
        
        return x
```

#### Injection into Transformer

```python
def inject_adapters(model, adapter_config):
    """Add adapters to all transformer layers"""
    
    for layer_idx, layer in enumerate(model.encoder.layer):
        # After attention
        layer.attention.adapter = AdapterLayer(
            d_model=model.config.hidden_size,
            bottleneck_size=adapter_config.bottleneck_size,
            dropout=adapter_config.adapter_dropout
        )
        
        # After feed-forward
        layer.output.adapter = AdapterLayer(
            d_model=model.config.hidden_size,
            bottleneck_size=adapter_config.bottleneck_size,
            dropout=adapter_config.adapter_dropout
        )
        
        # Freeze base weights
        for param in layer.parameters():
            if 'adapter' not in param.name:
                param.requires_grad = False
    
    return model
```

--
### Memory & Compute Analysis

#### Memory Comparison (BERT-Base, 110M parameters)

```bash
┌────────────────────────────────────────────────────────┐
│ Method           │ Trainable │ Memory │ Checkpoint     │
│ Full Fine-Tune   │ 110M      │ 8.5 GB │ 440 MB         │
│ Adapters (r=64)  │ 3.2M (3%) │ 4.8 GB │ 13 MB          │
│ LoRA (r=8, QKV)  │ 2.1M (2%) │ 4.2 GB │ 8 MB           │
└────────────────────────────────────────────────────────┘

Note: Adapters use more memory than LoRA because:
1. Two adapters per layer vs. LoRA on select weight matrices
2. Activation storage for bottleneck computations
```

#### Inference Latency Impact

```
Latency Overhead (relative to base model):
┌─────────────────────────────────────────────────┐
│ Method          │ Extra Compute │ Latency +%  │
├─────────────────┼───────────────┼─────────────┤
│ LoRA (merged)   │ 0%            │ 0%          │
│ LoRA (unmerged) │ 5-8%          │ 3-5%        │
│ Adapters        │ 10-15%        │ 8-12%       │
│ Prefix Tuning   │ 3-5%          │ 2-4%        │
└─────────────────────────────────────────────────┘

Why adapters are slower:
- Must compute through bottleneck on EVERY forward pass
- Cannot merge into base weights (unlike LoRA)
````

--
### Training Protocol

#### Learning Rate Strategy

```python
# Adapters are more stable than LoRA, can use higher LR
optimizer = AdamW([
    {
        'params': adapter_parameters,
        'lr': 3e-4,  # Higher than LoRA (1e-4)
        'weight_decay': 0.01
    }
], betas=(0.9, 0.999))

# Aggressive warmup
scheduler = get_linear_schedule_with_warmup(
    optimizer,
    num_warmup_steps=0.1 * total_steps,  # 10% warmup
    num_training_steps=total_steps
)
```

#### Hyperparameter Priorities
```
Impact Ranking:
1. ██████████ Bottleneck size (r)       [Critical]
2. ████████ Initialization scale         [High]
3. ██████ Placement strategy             [Medium]
4. ████ Dropout rate                     [Low-Medium]
5. ██ Non-linearity choice               [Low]
```

--
### Adapter Variants

##### Parallel Adapters (Pfeiffer et al., 2020)

```bash
Standard (Sequential):
x → Attention → Adapter → FFN → Adapter → output

Parallel (Faster):
        ┌─ Attention ─┐
 x ─────┤             ├───── (+) → output
        └─ Adapter ─ ─┘
        
# Trade-off: 20% faster, 2-3% lower accuracy
```

##### Compacter (Mahabadi et al., 2021)

Uses **Kronecker product** for ultra-low parameter count:

```python
# Standard adapter: W_down (d × r), W_up (r × d)
# Compacter: W_down = A ⊗ B where A (d/n × r/m), B (n × m)

# For d=768, r=64, n=m=8:
# Standard params: 2 × 768 × 64 = 98,304
# Compacter params: 2 × (96×8 + 8×8) = 1,664
# Reduction: 59x fewer parameters!
```

--
#### When to Use Adapters vs. LoRA

| **Criterion** | **Adapters Better** | **LoRA Better** |
|---------------|---------------------|-----------------|
| Dataset size | <1000 examples (strong regularization) | >5000 examples |
| Inference latency | Can tolerate +10% | Need minimal overhead |
| Multi-task setup | Easier to isolate tasks | Requires careful merging |
| Stability | More stable training | Needs careful α tuning |
| Memory | Slightly higher | More efficient |
| Checkpoint size | Larger (~13 MB) | Smaller (~8 MB) |

---
## 2. Prefix Tuning

**What is Prefix Tuning?** : Instead of modifying the model's weights or adding modules, you prepend learnable "prompt tokens" to every layer. Imagine whispering instructions to the model before it processes each sentence: "You're a medical expert now..."
**What Does It Do?** : Adds 0.1-3% trainable parameters (depending on prefix length). The "virtual tokens" condition the model's behavior without touching its internals.
**Why Use It?** : Fastest inference (minimal overhead), extremely parameter-efficient, and works remarkably well for generation tasks (summarization, translation, question answering).

### The Mechanism

#### Virtual Token Architecture

```bash
Standard Transformer Attention:
Q = W_q × [x₁, x₂, ..., x_n]
K = W_k × [x₁, x₂, ..., x_n]
V = W_v × [x₁, x₂, ..., x_n]

With Prefix Tuning:
Q = W_q × [x₁, x₂, ..., x_n]  (unchanged)
K = W_k × [P_k₁, P_k₂, ..., P_kₘ, x₁, x₂, ..., x_n]
V = W_v × [P_v₁, P_v₂, ..., P_vₘ, x₁, x₂, ..., x_n]

Where P_k, P_v are learned prefix embeddings (m = prefix length)
```


```bash 
# architecture

Layer L Attention:
┌─────────────────────────────────────────────────────────┐
│                                                         │
│  PREFIX TOKENS (trainable)    INPUT TOKENS (frozen)     │
│  [P₁] [P₂] ... [Pₘ]          [x₁] [x₂] ... [xₙ]         │
│    ↓    ↓        ↓             ↓    ↓        ↓          │
│  ┌──────────────────┐        ┌──────────────────┐       │
│  │ Prefix Keys (K)  │        │ Input Keys (K)   │       │
│  └──────────────────┘        └──────────────────┘       │
│           ↓                           ↓                 │
│  ┌────────────────────────────────────────────┐         │
│  │     Attention(Q, [K_prefix, K_input], V)   │         │
│  └────────────────────────────────────────────┘         │
│                                                         │
└─────────────────────────────────────────────────────────┘

Key Insight: Prefix only affects keys & values, not queries!
````

--
### Mathematical Formulation

#### Reparameterization Trick

**Naive approach** (unstable):

```python
# Directly optimize prefix embeddings
prefix_k = nn.Parameter(torch.randn(num_layers, prefix_length, d_model))
prefix_v = nn.Parameter(torch.randn(num_layers, prefix_length, d_model))
```

**Stable approach** (Li & Liang, 2021):

```python
# Use MLP to generate prefixes (smoother optimization)
class PrefixEncoder(nn.Module):
    def __init__(self, prefix_length, d_model, bottleneck_dim=512):
        super().__init__()
        self.embedding = nn.Embedding(prefix_length, bottleneck_dim)
        self.mlp = nn.Sequential(
            nn.Linear(bottleneck_dim, bottleneck_dim),
            nn.Tanh(),
            nn.Linear(bottleneck_dim, num_layers * 2 * d_model)
        )
    
    def forward(self, prefix_indices):
        # prefix_indices: [0, 1, 2, ..., prefix_length-1]
        prefix_emb = self.embedding(prefix_indices)  # (prefix_length, bottleneck)
        prefix_kv = self.mlp(prefix_emb)             # (prefix_length, num_layers*2*d_model)
        
        # Reshape to (num_layers, 2, prefix_length, d_model)
        return prefix_kv.view(prefix_length, num_layers, 2, -1)
```

--

### Configuration Schema

#### Prefix Length Selection

| **Prefix Length** | **% Params** | **Use Case**              | **Performance**   |
| ----------------- | ------------ | ------------------------- | ----------------- |
| 5-10 tokens       | <0.1%        | Extreme efficiency        | 70-80% of full FT |
| 20-50 tokens      | 0.1-0.5%     | Standard setting          | 85-92% of full FT |
| 100-200 tokens    | 0.5-2%       | High capacity             | 90-95% of full FT |
| 500+ tokens       | >2%          | Approaching prompt tuning | 95%+ of full FT   |

**IBM Recommendation:** Start with **20 tokens** for BERT, **50 tokens** for GPT models.

#### Parameter Count Analysis

```python
# For GPT-2 Small (12 layers, d_model=768)
prefix_length = 20

# Naive parameterization:
params_naive = num_layers * 2 * prefix_length * d_model
            = 12 * 2 * 20 * 768
            = 368,640 parameters

# With MLP reparameterization (bottleneck=512):
params_mlp = prefix_length * bottleneck + bottleneck * bottleneck + bottleneck * (num_layers * 2 * d_model)
           = 20 * 512 + 512² + 512 * (12 * 2 * 768)
           = 10,240 + 262,144 + 9,437,184
           = 9,709,568 parameters (2.6% of GPT-2)

Trade-off: MLP adds params but MASSIVELY improves training stability
```

--
### Implementation Blueprint

```python
class PrefixTuningGPT(nn.Module):
    """Prefix Tuning for GPT-style models"""
    
    def __init__(self, base_model, prefix_config):
        super().__init__()
        self.base_model = base_model
        self.prefix_length = prefix_config.prefix_length
        
        # Freeze base model
        for param in self.base_model.parameters():
            param.requires_grad = False
        
        # Trainable prefix encoder
        self.prefix_encoder = PrefixEncoder(
            prefix_length=self.prefix_length,
            num_layers=base_model.config.num_hidden_layers,
            d_model=base_model.config.hidden_size,
            bottleneck_dim=512
        )
        
        # Prefix token indices
        self.prefix_indices = torch.arange(self.prefix_length)
    
    def get_prompt_kv(self, batch_size):
        """Generate prefix key-value pairs for all layers"""
        # (prefix_length, num_layers, 2, d_model)
        prefix_kv = self.prefix_encoder(self.prefix_indices)
        
        # Expand for batch
        # (batch, num_layers, 2, prefix_length, d_model)
        prefix_kv = prefix_kv.unsqueeze(0).expand(batch_size, -1, -1, -1, -1)
        
        return prefix_kv
    
    def forward(self, input_ids, attention_mask=None):
        batch_size = input_ids.size(0)
        prefix_kv = self.get_prompt_kv(batch_size)
        
        # Inject into transformer layers
        past_key_values = []
        for layer_idx in range(self.base_model.config.num_hidden_layers):
            key = prefix_kv[:, layer_idx, 0, :, :]    # (batch, prefix_length, d_model)
            value = prefix_kv[:, layer_idx, 1, :, :]  # (batch, prefix_length, d_model)
            past_key_values.append((key, value))
        
        # Forward pass with prefix
        outputs = self.base_model(
            input_ids=input_ids,
            attention_mask=attention_mask,
            past_key_values=tuple(past_key_values)
        )
        
        return outputs
```

--
### Memory & Inference Characteristics

#### Memory Footprint

```bash
Prefix Tuning Memory (GPT-2 117M):
┌─────────────────────────────────────────────────┐
│ Component              │ Memory  │ % of Total   │
├────────────────────────┼─────────┼──────── ─────┤
│ Base Model (frozen)    │ 460 MB  │ 95.8%        │
│ Prefix Encoder         │ 19 MB   │ 4.0%         │
│ Optimizer States       │ 38 MB   │ 0.2%         │
├────────────────────────┼─────────┼──────────── ─┤
│ TOTAL                  │ 517 MB  │ 100%         │
└─────────────────────────────────────────────────┘

vs. Full Fine-Tuning: ~950 MB (45% reduction)
```

#### Inference Speed

```bash
Latency Analysis (512 token generation):
┌──────────────────────────────────────────────────┐
│ Method          │ Tokens/sec │ Overhead          │
├─────────────────┼────────────┼───────────────  ─ ┤
│ Base Model      │ 47.3       │ 0% (baseline)     │
│ Prefix (len=20) │ 46.1       │ +2.5%             │
│ Prefix (len=50) │ 44.8       │ +5.3%             │
│ Adapters        │ 42.1       │ +11.0%            │
│ LoRA (unmerged) │ 45.2       │ +4.4%             │
└──────────────────────────────────────────────────┘

# Prefix tuning overhead scales with prefix length, not model size!
````

--
### Training Protocol

#### Optimization Strategy

```python
# High learning rate (prefix is small, needs strong signal)
optimizer = AdamW(
    prefix_model.prefix_encoder.parameters(),
    lr=5e-4,  # Higher than adapters (3e-4) or LoRA (1e-4)
    weight_decay=0.01,
    betas=(0.9, 0.999)
)

# Aggressive warmup + cosine decay
scheduler = get_cosine_schedule_with_warmup(
    optimizer,
    num_warmup_steps=0.15 * total_steps,  # 15% warmup (more than others)
    num_training_steps=total_steps
)
```
#### Critical Training Tips

```python
# 1. Initialization: Start near zero to avoid disruption
def init_prefix_encoder(model):
    for module in model.prefix_encoder.modules():
        if isinstance(module, nn.Linear):
            nn.init.xavier_uniform_(module.weight, gain=0.01)
            nn.init.zeros_(module.bias)

# 2. Gradient clipping (prefix gradients can be noisy)
torch.nn.utils.clip_grad_norm_(model.parameters(), max_norm=1.0)

# 3. Longer training (prefix needs more epochs to converge)
num_epochs = 5  # vs. 3 for LoRA
```

--
### Prefix Tuning Variants

#### P-Tuning v2 (Liu et al., 2022)

**Key difference:** Apply prefix to ALL layers, not just K/V.

```bash
Standard Prefix Tuning:
- Only adds to Key & Value projections
- Query remains unchanged

P-Tuning v2:
- Adds trainable embeddings to input of EACH layer
- More expressive but more parameters
````

```python
class PTuningV2(nn.Module):
    def __init__(self, base_model, prefix_length):
        super().__init__()
        self.num_layers = base_model.config.num_hidden_layers
        
        # Separate prefix for each layer
        self.prefix_embeddings = nn.ParameterList([
            nn.Parameter(torch.randn(prefix_length, base_model.config.hidden_size))
            for _ in range(self.num_layers)
        ])
    
    def forward(self, input_ids):
        hidden_states = self.base_model.embeddings(input_ids)
        
        for layer_idx, layer in enumerate(self.base_model.encoder.layer):
            # Prepend prefix to layer input
            prefix = self.prefix_embeddings[layer_idx].unsqueeze(0).expand(
                hidden_states.size(0), -1, -1
            )
            hidden_states_with_prefix = torch.cat([prefix, hidden_states], dim=1)
            
            # Forward through layer
            hidden_states = layer(hidden_states_with_prefix)
            
            # Remove prefix from output
            hidden_states = hidden_states[:, self.prefix_length:, :]
        
        return hidden_states
```

#### Prefix Length Ablation Study

```
Performance vs. Prefix Length (GLUE Avg):
┌──────────────────────────────────────────────────┐
│ Length │ Params  │ Train Time │ Accuracy        │
├────────┼─────────┼────────────┼─────────────────┤
│ 5      │ 0.05%   │ 1.2 hr     │ 78.3%           │
│ 10     │ 0.1%    │ 1.4 hr     │ 82.7%           │
│ 20     │ 0.2%    │ 1.8 hr     │ 86.4% ✓ (sweet spot)
│ 50     │ 0.5%    │ 2.3 hr     │ 88.1%           │
│ 100    │ 1.0%    │ 3.1 hr     │ 88.9%           │
│ 200    │ 2.0%    │ 4.2 hr     │ 89.2% (diminishing returns)
└──────────────────────────────────────────────────┘
```

--
### When to Use Prefix Tuning

| **Scenario**                         | **Use Prefix?** | **Alternative**              |
| ------------------------------------ | --------------- | ---------------------------- |
| Generation tasks (summarization, MT) | ✅ Yes           | Particularly strong here     |
| Very large models (>10B params)      | ✅ Yes           | Minimal parameter overhead   |
| Need fast inference                  | ✅ Yes           | Only 2-5% overhead           |
| Classification tasks                 | ⚠️ Maybe        | Adapters often better        |
| Very small datasets (<500)           | ❌ No            | Too few params, use adapters |
| Multi-task learning                  | ✅ Yes           | Easy to swap prefixes        |

---
## 3. (IA)³ - Infused Adapter by Inhibiting and Amplifying Inner Activations

**What is (IA)³?**  The simplest possible adapter: just multiply the model's internal activations by learned scaling vectors. Instead of adding layers or tokens, you're turning "volume knobs" up or down for different features.
**What Does It Do?**  Adds **<0.01%** trainable parameters—the most parameter-efficient method. A 7B model might need only 10-20 MB of adapter weights.
**Why Use It?**  When you have extreme memory constraints or need hundreds of task-specific adapters loaded simultaneously. Also surprisingly effective for T0-style models (instruction-tuned variants).

### The Mechanism

#### Activation Scaling

```bash
Standard Attention:
Q = W_q × x
K = W_k × x
V = W_v × x

Output = Attention(Q, K, V)

With (IA)³:
Q = W_q × x (unchanged)
K = l_k ⊙ (W_k × x)  ← element-wise scaling
V = l_v ⊙ (W_v × x)  ← element-wise scaling

Where l_k, l_v are learned vectors (not matrices!)
⊙ denotes element-wise multiplication (Hadamard product)
```

#### Visualization

```bash
Transformer Layer with (IA)³:
┌─────────────────────────────────────────────────────┐
│                                                     │
│  Input (x) ───────┬───────────┬───────────┐         │
│                   │           │           │         │
│                   ▼           ▼           ▼         │
│                 W_q         W_k         W_v         │
│                   │           │           │         │
│                   │           ▼           ▼         │
│                   │      [l_k] ⊙     [l_v] ⊙        │
│                   │    (scaling)    (scaling)       │
│                   │           │           │         │
│                   └───────────┴───────────┘         │
│                              │                      │
│                     Attention(Q, K, V)              │
│                              │                      │
│                              ▼                      │
│                        Feed-Forward                 │
│                              │                      │
│                              ▼                      │
│                     [l_ff] ⊙ (FFN output)           │
│                         (scaling)                   │
│                              │                      │
│                              ▼                      │
│                           Output                    │
│                                                     │
└─────────────────────────────────────────────────────┘

Key: Only 3 vectors per layer (l_k, l_v, l_ff)
```

--
### Mathematical Formulation

#### Parameter Count

For a transformer with **L** layers, hidden dimension **d**:

```bash
(IA)³ parameters = L × (2d + d_ffn)

For GPT-2 (L=12, d=768, d_ffn=3072):
Params = 12 × (2×768 + 3072) = 55,296

vs. LoRA (r=8): ~2.1M parameters
Reduction: 38x fewer parameters!
````

#### Scaling Vector Interpretation

```python
# Learned scaling vectors
l_k: (d_model,)  # Amplify/suppress key dimensions
l_v: (d_model,)  # Amplify/suppress value dimensions  
l_ff: (d_ffn,)   # Amplify/suppress FFN neurons

# Example learned values (after training):
l_k = [1.02, 0.98, 1.15, 0.87, ...]
      ↑     ↑     ↑     ↑
    slight slight strong suppress
    amplify suppress amplify this feature

# Initialization: All ones (no disruption initially)
l_k = torch.ones(d_model)
l_v = torch.ones(d_model)
l_ff = torch.ones(d_ffn)
```

--

### Implementation Blueprint

```python
class IA3Layer(nn.Module):
    """(IA)³ for a single transformer layer"""
    
    def __init__(self, d_model, d_ffn):
        super().__init__()
        
        # Learned scaling vectors (initialized to 1)
        self.l_k = nn.Parameter(torch.ones(d_model))
        self.l_v = nn.Parameter(torch.ones(d_model))
        self.l_ff = nn.Parameter(torch.ones(d_ffn))
    
    def forward(self, query, key, value, ffn_output):
        """
        Apply (IA)³ scaling to attention and FFN
        
        Args:
            query: Query activations (batch, seq_len, d_model)
            key: Key activations (batch, seq_len, d_model)
            value: Value activations (batch, seq_len, d_model)
            ffn_output: Feed-forward output (batch, seq_len, d_ffn)
        """
        # Scale keys and values (query unchanged)
        scaled_key = key * self.l_k.view(1, 1, -1)
        scaled_value = value * self.l_v.view(1, 1, -1)
        
        # Scale FFN output
        scaled_ffn = ffn_output * self.l_ff.view(1, 1, -1)
        
        return query, scaled_key, scaled_value, scaled_ffn


class IA3Model(nn.Module):
    """Inject (IA)³ into transformer"""
    
    def __init__(self, base_model):
        super().__init__()
        self.base_model = base_model
        
        # Freeze base model
        for param in base_model.parameters():
            param.requires_grad = False
        
        # Add (IA)³ layers
        self.ia3_layers = nn.ModuleList([
            IA3Layer(
                d_model=base_model.config.hidden_size,
                d_ffn=base_model.config.intermediate_size
            )
            for _ in range(base_model.config.num_hidden_layers)
        ])
    
    def forward(self, input_ids, attention_mask=None):
        hidden_states = self.base_model.embeddings(input_ids)
        
        for layer_idx, (base_layer, ia3_layer) in enumerate(
            zip(self.base_model.encoder.layer, self.ia3_layers)
        ):
            # Get Q, K, V from base model
            query = base_layer.attention.self.query(hidden_states)
            key = base_layer.attention.self.key(hidden_states)
            value = base_layer.attention.self.value(hidden_states)
            
            # Apply (IA)³ scaling
            _, key, value, _ = ia3_layer(query, key, value, None)
            
            # Continue with scaled K, V
            attention_output = base_layer.attention.self.forward_with_kv(
                query, key, value
            )
            
            # FFN pass
            ffn_output = base_layer.intermediate(attention_output)
            
            # Scale FFN output
            _, _, _, ffn_output = ia3_layer(None, None, None, ffn_output)
            
            hidden_states = base_layer.output(ffn_output)
        
        return hidden_states
```

--

### Training Protocol

#### Learning Rate Strategy

```python
# (IA)³ uses VERY high learning rates (vectors are tiny)
optimizer = AdamW(
    ia3_model.ia3_layers.parameters(),
    lr=3e-3,  # 10x higher than LoRA!
    weight_decay=0.0,  # No weight decay on scaling vectors
    betas=(0.9, 0.999)
)

# Linear warmup + constant (no decay)
scheduler = get_constant_schedule_with_warmup(
    optimizer,
    num_warmup_steps=0.05 * total_steps  # 5% warmup
)
```

#### Critical Hyperparameters

| **Hyperparameter** | **Recommended Value** | **Rationale**                            |
| ------------------ | --------------------- | ---------------------------------------- |
| Learning rate      | 3e-3 to 1e-2          | Tiny parameter count needs strong signal |
| Weight decay       | 0.0                   | Scaling vectors should grow freely       |
| Initialization     | All ones (1.0)        | Start with identity transformation       |
| Gradient clipping  | 5.0                   | Prevent runaway scaling                  |
| Epochs             | 5-10                  | More epochs than LoRA                    |
|                    |                       |                                          |

--
### Performance Characteristics

#### Benchmark Results (T0-3B on GLUE)

```bash
Method Comparison:
┌──────────────────────────────────────────────────────────┐
│ Method        │ Params │ Memory │ Train Time │ Accuracy  │
├───────────────┼────────┼────────┼────────────┼────── ────┤
│ Full FT       │ 100%   │ 24 GB  │ 8 hrs      │ 87.3%     │
│ LoRA (r=8)    │ 0.2%   │ 10 GB  │ 3 hrs      │ 86.1%     │
│ Adapters      │ 2.1%   │ 12 GB  │ 3.5 hrs    │ 86.8%     │
│ Prefix (l=50) │ 0.8%   │ 11 GB  │ 4 hrs      │ 85.2%     │
│ (IA)³         │ 0.01%  │ 9 GB   │ 2.5 hrs    │ 85.7%     │
└──────────────────────────────────────────────────────────┘

(IA)³ Sweet Spot: Best params/performance ratio
```

### Where (IA)³ Excels

```
Task Performance (relative to LoRA):
┌─────────────────────────────────────────┐
│ Task Type        │ (IA)³ vs LoRA       │
├──────────────────┼─────────────────────┤
│ Classification   │ -2% to -5%          │
│ Generation       │ -3% to -8%          │
│ Instruction Following │ -1% to +1% ✓   │
│ Multi-task (T0)  │ +0% to +2% ✓        │
└─────────────────────────────────────────┘

Key Insight: (IA)³ particularly effective for T0/FLAN-style 
instruction-tuned models where base knowledge is already strong
````

--

### Advanced: Task Vector Arithmetic

**(IA)³ enables linear combinations of task adaptations:**

```python
# Train separate (IA)³ for different tasks
ia3_sentiment = train_ia3(base_model, sentiment_data)
ia3_toxicity = train_ia3(base_model, toxicity_data)

# Combine scaling vectors (element-wise average)
ia3_combined = IA3Layer(d_model, d_ffn)
ia3_combined.l_k = (ia3_sentiment.l_k + ia3_toxicity.l_k) / 2
ia3_combined.l_v = (ia3_sentiment.l_v + ia3_toxicity.l_v) / 2
ia3_combined.l_ff = (ia3_sentiment.l_ff + ia3_toxicity.l_ff) / 2

# Model now handles both tasks reasonably well!
```

**Why this works:** Scaling vectors are additive in effect space (unlike weight matrices).

### When to Use (IA)³

| **Scenario**                    | **Use (IA)³?** | **Alternative**                |
| ------------------------------- | -------------- | ------------------------------ |
| Extreme memory constraints      | ✅ Yes          | Smallest footprint             |
| 100+ task-specific adapters     | ✅ Yes          | Can load many in parallel      |
| T0/FLAN instruction models      | ✅ Yes          | Particularly effective         |
| Small datasets (<1000 examples) | ⚠️ Maybe       | Might underfit, try adapters   |
| Complex reasoning tasks         | ❌ No           | Lacks capacity, use LoRA r=16+ |
| Generation quality critical     | ❌ No           | Use LoRA or full FT            |

---
## 4. Prompt Tuning (Soft Prompts)

**What is Prompt Tuning?**  Instead of engineering text prompts ("You are a helpful assistant..."), you optimize continuous embeddings that serve as "virtual instructions." The model learns the perfect prompt automatically.
**What Does It Do?**  Adds only **input-layer** parameters (0.01-0.1%). No changes to attention or FFN layers—just optimized token embeddings prepended to every input.
**Why Use It?**  Dead simple to implement, zero inference overhead after training, and scales remarkably well with model size (works better on 10B+ models than on 1B models).

--

### The Architecture

#### Soft Prompt Mechanism

```bash
Standard Input Processing:
[CLS] The movie was great [SEP]
  ↓
Embedding Layer
  ↓
Token Embeddings: [e_CLS, e_The, e_movie, e_was, e_great, e_SEP]
  ↓
Transformer Layers

With Prompt Tuning:
[P₁] [P₂] ... [Pₘ] [CLS] The movie was great [SEP]
  ↓
Embedding Layer
  ↓
[trainable prompts] + [frozen token embeddings]
  ↓
Transformer Layers (ALL FROZEN)
````

### Mathematical Formulation

```python
# Frozen embedding matrix
E = model.embeddings.word_embeddings.weight  # (vocab_size, d_model)

# Trainable soft prompt
P = nn.Parameter(torch.randn(prompt_length, d_model))

# Concatenate for each input
def forward(input_ids):
    # Get frozen embeddings
    token_embeds = E[input_ids]  # (batch, seq_len, d_model)
    
    # Prepend soft prompt
    prompt_embeds = P.unsqueeze(0).expand(batch_size, -1, -1)
    full_embeds = torch.cat([prompt_embeds, token_embeds], dim=1)
    
    # Forward through frozen transformer
    return transformer(full_embeds)
```

--
### Configuration Schema

#### Prompt Length vs. Model Size

**Critical Discovery (Lester et al., 2021):** Prompt tuning effectiveness scales with model size.

```bash
Optimal Prompt Length by Model Size:
┌───────────────────────────────────────────────────────┐
│ Model Size │ Prompt Length │ Params    │ Performance  │
├────────────┼───────────────┼───────────┼──────────── ─┤
│ 60M        │ 150-200       │ 0.2%      │ 65-70% FT    │
│ 220M       │ 100-150       │ 0.1%      │ 75-80% FT    │
│ 770M       │ 50-100        │ 0.05%     │ 85-90% FT    │
│ 3B         │ 20-50         │ 0.02%     │ 90-95% FT    │
│ 11B+       │ 10-20         │ 0.01%     │ 95-99% FT ✓  │
└───────────────────────────────────────────────────────┘

Trend: Larger models need shorter prompts!
````

#### Initialization Strategies

|**Method**|**Description**|**Performance**|**When to Use**|
|---|---|---|---|
|**Random**|`torch.randn()`|60-70%|Debugging only|
|**Vocab sampling**|Sample from embedding layer|75-85%|Good baseline|
|**Class label init**|Use task label embeddings|85-90%|Classification tasks|
|**Text init**|Encode real prompt like "Classify sentiment:"|90-95%|Best practice ✓|

--

### Implementation Blueprint

#### Text-Initialized Prompt Tuning

```python
class PromptTuning(nn.Module):
    """Soft prompt tuning with text initialization"""
    
    def __init__(self, base_model, prompt_text, tokenizer):
        super().__init__()
        self.base_model = base_model
        
        # Freeze all base model parameters
        for param in base_model.parameters():
            param.requires_grad = False
        
        # Tokenize initialization text
        init_ids = tokenizer(
            prompt_text,
            return_tensors="pt",
            add_special_tokens=False
        ).input_ids
        
        # Get embeddings from frozen embedding layer
        with torch.no_grad():
            init_embeds = base_model.get_input_embeddings()(init_ids)
        
        # Make trainable soft prompt
        self.soft_prompt = nn.Parameter(init_embeds.squeeze(0).clone())
        self.prompt_length = self.soft_prompt.size(0)
    
    def forward(self, input_ids, attention_mask=None):
        batch_size = input_ids.size(0)
        
        # Get token embeddings
        inputs_embeds = self.base_model.get_input_embeddings()(input_ids)
        
        # Prepend soft prompt
        prompt_embeds = self.soft_prompt.unsqueeze(0).expand(batch_size, -1, -1)
        inputs_embeds = torch.cat([prompt_embeds, inputs_embeds], dim=1)
        
        # Extend attention mask
        if attention_mask is not None:
            prompt_mask = torch.ones(
                batch_size, self.prompt_length,
                dtype=attention_mask.dtype,
                device=attention_mask.device
            )
            attention_mask = torch.cat([prompt_mask, attention_mask], dim=1)
        
        # Forward through frozen transformer
        return self.base_model(
            inputs_embeds=inputs_embeds,
            attention_mask=attention_mask
        )


# Usage example
tokenizer = AutoTokenizer.from_pretrained("t5-large")
base_model = AutoModelForSeq2SeqLM.from_pretrained("t5-large")

# Initialize with task description
prompt_text = "Classify the sentiment of this movie review as positive or negative:"
model = PromptTuning(base_model, prompt_text, tokenizer)

# Only ~10K trainable parameters for 20-token prompt!
```

--
### Training Protocol

#### Learning Rate Schedule

```python
# Prompt tuning needs VERY high learning rates initially
optimizer = AdamW(
    [model.soft_prompt],
    lr=5e-2,  # 50x higher than LoRA!
    weight_decay=0.0,
    betas=(0.9, 0.999)
)

# Long warmup + polynomial decay
scheduler = get_polynomial_decay_schedule_with_warmup(
    optimizer,
    num_warmup_steps=0.2 * total_steps,  # 20% warmup
    num_training_steps=total_steps,
    power=2.0  # Faster decay than linear
)
```

#### Training Dynamics Visualization

```bash
Learning Rate Schedule:
       LR
        │
  0.05 ─┤╭───╮
        │╱     ╲
        │       ╲___
  0.01 ─┤           ╲___
        │               ╲___
     0 ─┼───┴───┴───┴───┴───┴─── Steps
        0   20% 40% 60% 80% 100%
        Warmup  Training    Decay

Validation Performance:
   Acc
        │          ╭────────
   90% ─┤        ╱
        │       │
   70% ─┤     ╱
        │   ╱
   50% ─┤ ╱
        │
        └─────────────────────── Steps
        
Note: Steep initial climb, then plateau
````

--
### Advanced Techniques

#### Multi-Task Prompt Tuning (Asai et al., 2022)

```python
class MultiTaskPromptTuning(nn.Module):
    """Separate prompts per task + shared backbone"""
    
    def __init__(self, base_model, num_tasks, prompt_length=20):
        super().__init__()
        self.base_model = base_model
        
        # Freeze base
        for param in base_model.parameters():
            param.requires_grad = False
        
        # Task-specific prompts
        self.task_prompts = nn.ParameterDict({
            f"task_{i}": nn.Parameter(
                torch.randn(prompt_length, base_model.config.hidden_size)
            )
            for i in range(num_tasks)
        })
    
    def forward(self, input_ids, task_id):
        # Select task-specific prompt
        prompt = self.task_prompts[f"task_{task_id}"]
        
        # Rest same as single-task...
        pass

# Memory efficiency:
# Base model: 3B params (6 GB)
# 10 tasks × 20-token prompts: 10 × 10K params = 100K total
# Total overhead: <1 MB for 10 tasks!
```

#### Prompt Tuning with Adapters (PT+Adapter)

```python
class HybridPTAdapter(nn.Module):
    """Combine prompt tuning (input) + adapters (layers)"""
    
    # Benefits:
    # 1. Prompt provides task context
    # 2. Adapters provide layer-wise adaptation
    # 3. Total params: 0.5-1% (best of both)
    
    # Use when: Need stronger performance than PT alone
    # but want more efficiency than full adapters
```

--
### Performance Analysis

#### Scaling Laws (SuperGLUE Benchmark)

```bash
Performance vs. Model Size (20-token prompt):
┌────────────     ───────────────────────────────────── ┐
│ Model           │ Prompt Tuning │ Full FT │ Gap       │
├──────        ───┼───────────────┼─────────┼────────── ┤
│ T5-Base (220M)  │ 72.1%         │ 82.4%   │ -10.3 pts │
│ T5-Large (770M) │ 79.8%         │ 86.2%   │ -6.4 pts  │
│ T5-XL (3B)      │ 85.1%         │ 89.3%   │ -4.2 pts  │
│ T5-XXL (11B)    │ 88.7%         │ 90.2%   │ -1.5 pts ✓│
└───────────────────────────    ─────────────────────── ┘

Conclusion: At 11B+ scale, prompt tuning nearly matches full FT
```

#### Memory Footprint

```bash
Prompt Tuning Memory (T5-3B):
┌────────────────────────────────────────────────┐
│ Component            │ Memory │ % of Total    │
├──────────────────────┼────────┼───────────────┤
│ Base Model (frozen)  │ 11.5 GB│ 99.8%         │
│ Soft Prompt (50 tok) │ 20 MB  │ 0.2%          │
│ Optimizer States     │ 40 MB  │ <0.1%         │
├──────────────────────┼────────┼───────────────┤
│ TOTAL                │ 11.6 GB│ 100%          │
└────────────────────────────────────────────────┘

vs. LoRA: ~12.5 GB (prompt tuning is MORE efficient)
vs. Full FT: ~24 GB (2x reduction)
````

--

### When to Use Prompt Tuning

| **Scenario**             | **Use Prompt Tuning?** | **Alternative**             |
| ------------------------ | ---------------------- | --------------------------- |
| Very large models (>10B) | ✅ Yes                  | Competitive with full FT    |
| Classification tasks     | ✅ Yes                  | Works very well             |
| Generation tasks         | ⚠️ Maybe               | Adapters/LoRA often better  |
| Small models (<1B)       | ❌ No                   | Significant performance gap |
| Need low latency         | ✅ Yes                  | Zero inference overhead     |
| Multi-task deployment    | ✅ Yes                  | Tiny per-task memory        |

---
## 5. BitFit - Bias-term Fine-tuning


**What is BitFit?**  
Train ONLY the bias parameters (the "+b" in y = Wx + b) while freezing all weight matrices. Surprisingly effective despite being the simplest possible adaptation.

**What Does It Do?**  
Adds 0.08-0.1% trainable parameters (just bias vectors). For BERT-base, that's only ~100K parameters vs. 110M total.

**Why Use It?**  
Academic curiosity mostly—shows that bias terms encode significant task-specific information. Practical use is limited (LoRA/adapters are better), but worth understanding for completeness.

---

## Technical Jargon: The Mechanism

### What Gets Trained

python

````python
# In a standard transformer layer:
class TransformerLayer(nn.Module):
    def __init__(self, d_model):
        self.query = nn.Linear(d_model, d_model, bias=True)
        self.key = nn.Linear(d_model, d_model, bias=True)
        self.value = nn.Linear(d_model, d_model, bias=True)
        self.output = nn.Linear(d_model, d_model, bias=True)
        
        self.ffn_1 = nn.Linear(d_model, 4*d_model, bias=True)
        self.ffn_2 = nn.Linear(4*d_model, d_model, bias=True)
        
        self.layer_norm_1 = nn.LayerNorm(d_model)  # Has bias!
        self.layer_norm_2 = nn.LayerNorm(d_model)  # Has bias!

# BitFit trains:
# - query.bias, key.bias, value.bias, output.bias
# - ffn_1.bias, ffn_2.bias
# - layer_norm_1.bias, layer_norm_2.bias
# TOTAL: 6 linear biases + 2 LayerNorm biases = 8 bias vectors per layer
```

### Parameter Count Analysis
```
BERT-Base (L=12, d=768):
┌────────────────────────────────────────────────┐
│ Component      │ Weights  │ Biases │ BitFit? │
├────────────────┼──────────┼────────┼─────────┤
│ Q, K, V, O     │ 2.36M    │ 3,072  │ ✓       │
│ FFN            │ 4.72M    │ 3,840  │ ✓       │
│ LayerNorm      │ 0        │ 1,536  │ ✓       │
├────────────────┼──────────┼────────┼─────────┤
│ Per Layer      │ 7.08M    │ 8,448  │         │
│ All 12 Layers  │ 84.96M   │ 101K   │ ✓       │
│ Embeddings     │ 23.8M    │ 768    │ ✓       │
├────────────────┼──────────┼────────┼─────────┤
│ TOTAL          │ 108.76M  │ 102K   │         │
└────────────────────────────────────────────────┘

BitFit Trainable: 102,168 params (0.094% of model)
````

---

## Implementation Blueprint

python

```python
def apply_bitfit(model):
    """Freeze all weights, only train biases"""
    
    for name, param in model.named_parameters():
        if 'bias' in name:
            param.requires_grad = True  # Train biases
        else:
            param.requires_grad = False  # Freeze weights
    
    # Count trainable parameters
    trainable = sum(p.numel() for p in model.parameters() if p.requires_grad)
    total = sum(p.numel() for p in model.parameters())
    
    print(f"Trainable: {trainable:,} / {total:,} ({100*trainable/total:.3f}%)")
    
    return model


# Usage
from transformers import AutoModelForSequenceClassification

model = AutoModelForSequenceClassification.from_pretrained(
    "bert-base-uncased",
    num_labels=2
)

model = apply_bitfit(model)

# Output: Trainable: 102,168 / 109,483,778 (0.093%)
```

---

## Training Protocol

### Optimization Strategy

python

````python
# BitFit needs moderate learning rates
optimizer = AdamW(
    [p for p in model.parameters() if p.requires_grad],
    lr=1e-3,  # Between LoRA and prompt tuning
    weight_decay=0.01,
    betas=(0.9, 0.999)
)

# Standard warmup + linear decay
scheduler = get_linear_schedule_with_warmup(
    optimizer,
    num_warmup_steps=0.1 * total_steps,
    num_training_steps=total_steps
)

# Note: More epochs needed (biases have limited capacity)
num_epochs = 10  # vs. 3-5 for LoRA
```

---

## Performance Characteristics

### GLUE Benchmark Results
```
BitFit vs. Other Methods (BERT-Base):
┌──────────────────────────────────────────────────────┐
│ Task  │ Full FT │ BitFit │ LoRA │ Adapters │ Prompt │
├───────┼─────────┼────────┼──────┼──────────┼────────┤
│ CoLA  │ 59.5    │ 53.2   │ 57.1 │ 58.3     │ 48.9   │
│ SST-2 │ 93.2    │ 91.7   │ 92.9 │ 93.0     │ 89.4   │
│ MRPC  │ 88.9    │ 84.2   │ 87.6 │ 88.1     │ 82.3   │
│ QQP   │ 91.3    │ 89.1   │ 90.8 │ 90.9     │ 87.8   │
│ MNLI  │ 84.5    │ 82.3   │ 83.9 │ 84.2     │ 80.1   │
├───────┼─────────┼────────┼──────┼──────────┼────────┤
│ Avg   │ 83.5    │ 80.1   │ 82.5 │ 82.9     │ 77.7   │
└──────────────────────────────────────────────────────┘

BitFit achieves 96% of full FT performance with 0.09% params
```

### Where BitFit Struggles
```
Performance Drop by Task Type:
┌────────────────────────────────────────────────┐
│ Task Characteristic   │ BitFit Performance   │
├───────────────────────┼──────────────────────┤
│ Simple classification │ 95-98% of full FT ✓  │
│ Sequence labeling     │ 85-90% of full FT    │
│ Question answering    │ 75-85% of full FT    │
│ Generation tasks      │ 60-70% of full FT ✗  │
└────────────────────────────────────────────────┘

Hypothesis: Biases sufficient for decision boundaries,
insufficient for complex feature transformations
```

---

## Theoretical Insights

### Why Do Biases Work?
```
Linear transformation with bias:
y = Wx + b

Task adaptation perspective:
- W: General feature extraction (learned during pre-training)
- b: Task-specific offset/threshold adjustment

Example (sentiment classification):
Pre-trained: W encodes "positive/negative sentiment features"
BitFit: b shifts decision boundary for domain-specific bias
  (e.g., movie reviews vs. product reviews have different baselines)
````

### Bias Gradient Analysis

python

```python
def analyze_bias_gradients(model, dataloader):
    """See which biases change most during fine-tuning"""
    
    bias_grad_norms = {}
    
    for name, param in model.named_parameters():
        if 'bias' in name and param.grad is not None:
            bias_grad_norms[name] = param.grad.norm().item()
    
    # Sort by gradient magnitude
    sorted_biases = sorted(
        bias_grad_norms.items(),
        key=lambda x: x[1],
        reverse=True
    )
    
    return sorted_biases

# Typical finding:
# 1. Output layer biases (large gradients) ← Task head
# 2. LayerNorm biases (medium gradients)
# 3. Attention biases (small gradients)
# 4. FFN biases (small gradients)
```

---

## Variants & Extensions

### Diff-Pruning (Guo et al., 2021)

python

```python
# Combination of BitFit + sparse weight updates
class DiffPruning(nn.Module):
    """
    1. Start with BitFit (train biases only)
    2. Identify weights with largest gradient magnitudes
    3. Unlock top-k% weights for training
    4. Achieves better performance with still <1% params
    """
    pass
```

### BitFit + LoRA (Hybrid)

python

````python
# Why combine?
# - BitFit: Cheap, handles simple adaptations
# - LoRA: Adds capacity for complex tasks
# - Total: 0.1% (BitFit) + 0.2% (LoRA) = 0.3% params

# Use when: Want safety net (BitFit) + performance (LoRA)
```

---

## When to Use BitFit

| **Scenario** | **Use BitFit?** | **Alternative** |
|--------------|-----------------|-----------------|
| Need absolute minimum params | ✅ Yes | <0.1% of model |
| Simple classification | ✅ Yes | Surprisingly effective |
| Baseline/ablation study | ✅ Yes | Good comparison point |
| Complex NLU tasks | ❌ No | Use LoRA |
| Generation tasks | ❌ No | Use adapters/LoRA |
| Production deployment | ❌ No | Other methods more reliable |

---

# 6. QLoRA - Quantized Low-Rank Adaptation

## The Layman Explanation

**What is QLoRA?**  
LoRA, but the frozen base model is stored in 4-bit integers instead of 16-bit floats. This halves memory usage again, fitting 65B models on a single consumer GPU (RTX 4090).

**What Does It Do?**  
Enables fine-tuning of massive models (33B, 65B, 70B parameters) on consumer hardware while maintaining 95-98% of full 16-bit quality.

**Why Use It?**  
**The democratization breakthrough:** Train 70B models on $2000 hardware that previously required $50,000 server clusters.

---

## Technical Jargon: The Architecture

### 4-bit NormalFloat (NF4) Quantization

**Standard Quantization (INT4):**
```
Float range: [-1.0, 1.0]
INT4 values: [-8, -7, ..., 6, 7] (16 levels)

Problem: Uniform quantization → poor for normal distributions
````

**NF4 (Dettmers et al., 2023):**

python

````python
# Optimized for normal distribution (typical weight distribution)
NF4_LEVELS = [
    -1.0, -0.6961928009986877, -0.5250730514526367,
    -0.39491748809814453, -0.28444138169288635,
    -0.18477343022823334, -0.09105003625154495,
    0.0, 0.07958029955625534, 0.16093020141124725,
    0.24611230194568634, 0.33791524171829224,
    0.44070982933044434, 0.5626170039176941,
    0.7229568362236023, 1.0
]

# Non-uniform spacing → more precision near zero
```

### Double Quantization
```
Standard QLoRA:
Base Model: FP16 → NF4 (4 bits per weight)
Quantization Constants: FP32 (per 64 weights)

Double Quantization:
Base Model: FP16 → NF4 (4 bits)
Quantization Constants: FP32 → FP8 (8 bits)

Memory Savings:
Standard: 4 + (32/64) = 4.5 bits per weight
Double: 4 + (8/64) = 4.125 bits per weight
→ Additional 9% memory reduction
```

---

## Architecture Diagram
```
QLoRA Memory Layout:
┌───────────────────────────────────────────────────────┐
│ GPU Memory (24 GB RTX 4090)                            │
├───────────────────────────────────────────────────────┤
│                                                         │
│ ┌─────────────────────────────────────────┐           │
│ │ Base Model (65B params)                  │           │
│ │ Storage: NF4 (4-bit)                    │  8.5 GB   │
│ │ Quantization: Block-wise (64 elements)  │           │
│ └─────────────────────────────────────────┘           │
│                                                         │
│ ┌─────────────────────────────────────────┐           │
│ │ LoRA Adapters (r=64, all layers)        │           │
│ │ Storage: BF16 (16-bit)                  │  1.2 GB   │
│ │ Trainable Parameters: ~800M              │           │
│ └─────────────────────────────────────────┘           │
│                                                         │
│ ┌─────────────────────────────────────────┐           │
│ │ Activation Memory (batch_size=1)        │           │
│ │ Storage: BF16                            │  6.8 GB   │
│ │ Gradient Checkpointing: Enabled          │           │
│ └─────────────────────────────────────────┘           │
│                                                         │
│ ┌─────────────────────────────────────────┐           │
│ │ Optimizer States (AdamW)                 │           │
│ │ LoRA parameters only                     │  4.8 GB   │
│ └─────────────────────────────────────────┘           │
│                                                         │
│ ┌─────────────────────────────────────────┐           │
│ │ Paged Optimizer (Spillover to CPU RAM)  │  2.7 GB   │
│ └─────────────────────────────────────────┘           │
│                                                         │
├───────────────────────────────────────────────────────┤
│ TOTAL:                                       24.0 GB   │
└───────────────────────────────────────────────────────┘

vs. Regular LoRA (FP16): Would need ~65 GB for same model
````

---

## Implementation Blueprint

python

```python
import os
os.environ["OMP_NUM_THREADS"] = "8"

import torch
from transformers import (
    AutoModelForCausalLM,
    AutoTokenizer,
    BitsAndBytesConfig,
    TrainingArguments
)
from peft import LoraConfig, get_peft_model, prepare_model_for_kbit_training

# QLoRA Configuration
bnb_config = BitsAndBytesConfig(
    load_in_4bit=True,                      # Enable 4-bit loading
    bnb_4bit_quant_type="nf4",              # Use NormalFloat4
    bnb_4bit_use_double_quant=True,         # Double quantization
    bnb_4bit_compute_dtype=torch.bfloat16,  # Compute in BF16
)

# Load base model in 4-bit
model = AutoModelForCausalLM.from_pretrained(
    "meta-llama/Llama-2-70b-hf",
    quantization_config=bnb_config,
    device_map="auto",  # Automatic device placement
    torch_dtype=torch.bfloat16,
)

# Prepare for k-bit training
model = prepare_model_for_kbit_training(model)

# LoRA Configuration (same as standard LoRA)
lora_config = LoraConfig(
    r=64,                                    # Higher rank for 70B models
    lora_alpha=16,
    target_modules=[
        "q_proj", "k_proj", "v_proj", "o_proj",
        "gate_proj", "up_proj", "down_proj"
    ],
    lora_dropout=0.05,
    bias="none",
    task_type="CAUSAL_LM"
)

# Attach LoRA adapters
model = get_peft_model(model, lora_config)

print(f"Trainable params: {model.print_trainable_parameters()}")
# Output: trainable params: 838,860,800 / 70,015,700,928 || trainable%: 1.20
```

---

## Paged Optimizers

**Problem:** AdamW needs 2× optimizer states (first + second moments) → 3× memory of LoRA params

**Solution:** Unified memory management (Dettmers et al., 2023)

python

```python
from bitsandbytes.optim import AdamW8bit, PagedAdamW

# Standard 8-bit AdamW (saves 75% memory)
optimizer = AdamW8bit(
    model.parameters(),
    lr=2e-4,
    betas=(0.9, 0.999),
    eps=1e-8
)

# Paged optimizer (automatic CPU offloading)
optimizer = PagedAdamW(
    model.parameters(),
    lr=2e-4,
    betas=(0.9, 0.999),
)

# When GPU memory full:
# 1. Move least-recently-used optimizer states to CPU RAM
# 2. Transfer back when needed
# 3. Transparent to user (handled automatically)
```

---

## Training Configuration

### Optimal Hyperparameters for QLoRA

python

````python
training_args = TrainingArguments(
    output_dir="./qlora-llama2-70b",
    
    # Batch settings (critical for memory)
    per_device_train_batch_size=1,         # Must be 1 for 70B
    gradient_accumulation_steps=16,        # Effective batch = 16
    
    # Learning rate (slightly lower than FP16 LoRA)
    learning_rate=2e-4,                    # vs. 5e-4 for FP16
    max_grad_norm=0.3,                     # Aggressive clipping
    
    # Training length
    num_train_epochs=3,
    max_steps=-1,
    
    # Memory optimizations
    gradient_checkpointing=True,           # CRITICAL
    optim="paged_adamw_8bit",             # Use paged optimizer
    
    # Mixed precision
    bf16=True,                             # BF16 for computation
    fp16=False,                            # Don't use FP16
    
    # Logging
    logging_steps=10,
    save_strategy="steps",
    save_steps=500,
    
    # Efficiency
    dataloader_num_workers=4,
    group_by_length=True,                  # Pack similar lengths
)
```

---

## Performance Analysis

### Memory Comparison (70B Model)
```
Fine-Tuning Method Comparison:
┌────────────────────────────────────────────────────────┐
│ Method         │ GPU Memory │ Hardware     │ Cost     │
├────────────────┼────────────┼──────────────┼──────────┤
│ Full FT (FP16) │ 560 GB     │ 8× A100 80GB │ $50,000  │
│ LoRA (FP16)    │ 160 GB     │ 2× A100 80GB │ $12,000  │
│ QLoRA (NF4)    │ 24 GB      │ 1× RTX 4090  │ $2,000 ✓ │
└────────────────────────────────────────────────────────┘

Democratization Factor: 25x cost reduction
```

### Quality Degradation Analysis
```
Model Performance (vs. FP16 Full Fine-Tuning):
┌──────────────────────────────────────────────────────┐
│ Method          │ MMLU │ BBH  │ HumanEval │ TruthQA │
├─────────────────┼──────┼──────┼───────────┼─────────┤
│ Full FT (FP16)  │ 69.8 │ 52.3 │ 41.5      │ 48.7    │
│ LoRA (FP16)     │ 68.9 │ 51.2 │ 40.1      │ 47.9    │
│ QLoRA (NF4)     │ 68.2 │ 50.8 │ 39.8      │ 47.1    │
├─────────────────┼──────┼──────┼───────────┼─────────┤
│ QLoRA Drop      │ -1.6 │ -1.5 │ -1.7      │ -1.6    │
│ (vs Full FT)    │ pts  │ pts  │ pts       │ pts     │
└──────────────────────────────────────────────────────┘

Conclusion: ~2-3% performance drop for 25x cost savings
````

---

## Advanced Techniques

### Gradient Checkpointing (Essential)

python

```python
# Memory flow WITHOUT gradient checkpointing:
forward_pass:
  Layer 1 → activations₁ (saved)
  Layer 2 → activations₂ (saved)
  ...
  Layer 80 → activations₈₀ (saved)
  
backward_pass:
  Uses all saved activations → HIGH MEMORY

# Memory flow WITH gradient checkpointing:
forward_pass:
  Layer 1 → activations₁ (discarded)
  Layer 2 → activations₂ (discarded)
  ...
  Layer 80 → activations₈₀ (saved)
  
backward_pass:
  Recompute activations on-the-fly → LOW MEMORY
  
Trade-off: 30% slower training, 60% memory savings
```

### Multi-GPU QLoRA

python

```python
# Model parallelism for models > 70B
model = AutoModelForCausalLM.from_pretrained(
    "meta-llama/Llama-2-70b-hf",
    quantization_config=bnb_config,
    device_map="auto",  # Automatic layer distribution
    max_memory={
        0: "24GB",  # GPU 0
        1: "24GB",  # GPU 1
        "cpu": "100GB"  # CPU offload buffer
    }
)

# Device map example:
# GPU 0: Layers 0-39, Embeddings
# GPU 1: Layers 40-79, LM head
# CPU: Optimizer states overflow
```

---

## Practical Tips & Gotchas

### Common Issues

|**Problem**|**Cause**|**Solution**|
|---|---|---|
|OOM during forward pass|Batch size > 1|Set `per_device_batch_size=1`|
|OOM during backward pass|No gradient checkpointing|Enable `gradient_checkpointing=True`|
|Slow training|CPU offloading overhead|Use faster CPU, more RAM|
|Quality degradation >5%|Wrong compute dtype|Use BF16, not FP16|
|NaN gradients|Aggressive quantization|Lower learning rate to 1e-4|

### BitsAndBytes Installation

bash

````bash
# Must install from source for latest features
pip install bitsandbytes==0.41.3

# For multi-backend support (CUDA, ROCm, CPU)
pip install bitsandbytes-cuda118  # For CUDA 11.8

# Verify installation
python -c "import bitsandbytes as bnb; print(bnb.__version__)"
```

---

## When to Use QLoRA

| **Scenario** | **Use QLoRA?** | **Alternative** |
|--------------|----------------|-----------------|
| Large models (>30B params) | ✅ Yes | Only viable option on consumer GPUs |
| Limited GPU memory (<80GB) | ✅ Yes | Enables otherwise impossible fine-tuning |
| Budget constraints | ✅ Yes | 10-25x cost reduction |
| Need maximum quality | ⚠️ Maybe | FP16 LoRA if you can afford it |
| Production inference | ❌ No | Dequantize and merge for deployment |
| Small models (<7B) | ❌ No | Regular LoRA is fine |

---

# Summary Comparison Table

## The Complete PEFT Landscape
```
┌────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ Method        │ Params   │ Memory    │ Inference │ Quality  │ Best For                           │
├───────────────┼──────────┼───────────┼───────────┼──────────┼────────────────────────────────────┤
│ Full FT       │ 100%     │ Baseline  │ 0%        │ 100%     │ Maximum performance, unlimited $   │
│ LoRA          │ 0.1-2%   │ -45%      │ +0-5%     │ 95-98%   │ General-purpose PEFT (best default)│
│ Adapters      │ 2-4%     │ -35%      │ +8-12%    │ 93-97%   │ Small datasets, stable training   │
│ Prefix Tuning │ 0.1-1%   │ -50%      │ +2-5%     │ 85-95%   │ Generation, large models (>10B)    │
│ (IA)³         │ <0.01%   │ -55%      │ +1-3%     │ 85-92%   │ Extreme efficiency, T0/FLAN models │
│ Prompt Tuning │ 0.01-0.5%│ -55%      │ +0%       │ 70-95%   │ Very large models (>10B), multi-task│
│ BitFit        │ 0.08-0.1%│ -50%      │ +0%       │ 80-96%   │ Simple classification, baselines   │
│ QLoRA         │ 0.1-2%   │ -70%      │ +0-5%     │ 92-97%   │ Large models on consumer hardware  │
└────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

## Decision Tree
```
Need to fine-tune LLM?
│
├─ Model < 1B params?
│  └─ Use Full Fine-Tuning (cheap enough)
│
├─ Model 1-10B params?
│  ├─ Have 80GB GPU?
│  │  └─ Use LoRA (r=8-16)
│  └─ Have 24GB GPU?
│     └─ Use QLoRA (r=8-16)
│
├─ Model 10-70B params?
│  ├─ Have multi-GPU cluster?
│  │  └─ Use LoRA (r=16-32)
│  └─ Have single consumer GPU?
│     └─ Use QLoRA (r=32-64)
│
├─ Model >70B params?
│  └─ Use QLoRA with multiple GPUs
│
├─ Special constraints?
│  ├─ Need 100+ task adapters?
│  │  └─ Use (IA)³ or Prompt Tuning
│  ├─ Very small dataset (<500)?
│  │  └─ Use Adapters (strong regularization)
│  ├─ Generation task on large model?
│  │  └─ Use Prefix Tuning
│  └─ Minimal inference latency?
│     └─ Use LoRA (merge after training)
````

---

## Recommended Starting Configurations

### For Your "Principal 11" Mastery

yaml

```yaml
# Scenario 1: Production MLOps Pipeline
model_size: 7B
method: LoRA
config:
  r: 8
  lora_alpha: 16
  target_modules: ["q_proj", "v_proj"]
  quantization: none  # FP16 for quality
reasoning: |
  Balance of quality, speed, and debuggability.
  Merge adapters post-training for zero-latency deployment.

# Scenario 2: Research / Experimentation
model_size: 70B
method: QLoRA
config:
  r: 64
  lora_alpha: 128
  target_modules: ["all_linear"]
  quantization: nf4_double
reasoning: |
  Maximum model capacity on accessible hardware.
  Higher rank for research-grade performance.

# Scenario 3: Multi-Task Platform
model_size: 3B
method: Prefix Tuning + (IA)³ Hybrid
config:
  prefix_length: 20
  ia3_enabled: true
reasoning: |
  Minimal per-task memory (~5MB/task).
  Can serve 100+ tasks from single base model.

# Scenario 4: Edge Deployment
model_size: 1.5B
method: QLoRA → Merge → Quantize to INT8
config:
  r: 4
  lora_alpha: 8
  post_training: "quantize to INT8"
reasoning: |
  Train with QLoRA, deploy on mobile/edge.
  Total model size: ~400MB.
```