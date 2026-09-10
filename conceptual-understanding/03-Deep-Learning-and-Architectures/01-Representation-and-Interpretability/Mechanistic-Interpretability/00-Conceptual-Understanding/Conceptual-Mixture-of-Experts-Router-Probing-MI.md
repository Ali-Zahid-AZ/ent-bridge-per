---
tags:
  - llms-mixture-of-experts-moe
  - mechanistic-interpretability-moe
  - mechanistic-interpretability
  - mechanistic-interpretability-moe-router-probing
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

- [[Conceptual-BluePrint-Models-Enterprise-LLMOps-Platforms]]
- [[Conceptual-Basics-Anatomy-of-Compute-Feature-Manifolds-Circuit-Topologies]]
---
Router probing is currently one of the most practical and revealing techniques for peeking inside the "black box" of Mixture-of-Experts (MoE) models like DeepSeek-V3. Since we cannot easily trace circuits through dynamic expert pathways, the router itself becomes the most accessible window into the model's internal decision-making.


Router probing is a family of interpretability techniques that analyze the **router's (gate's) decisions**—which experts are selected for which tokens, with what confidence, and how these patterns vary across inputs, layers, and contexts 
[Mixture-of-Experts (MoE) in LLMs: Architecture, Routing, and Gemini](https://skywork.ai/blog/mixture-of-experts-moe-llms-architecture-routing-gemini/)

In MoE architectures, each transformer layer's feed-forward network is replaced with multiple "expert" networks and a router that decides which experts to activate per token [](https://skywork.ai/blog/mixture-of-experts-moe-llms-architecture-routing-gemini/). The router computes affinity scores (logits) for each expert, applies softmax to get probabilities, and selects the top-k experts
[Mixture-of-Experts Architecture \| huggingface/transformers \| DeepWiki](https://deepwiki.com/huggingface/transformers/5.4-transformer-architecture-patterns)

By extracting and analyzing these router decisions, we can infer:

- Which experts specialize in which types of knowledge
    
- How routing patterns correlate with input semantics
    
- Whether experts are monosemantic (one concept) or polysemantic (multiple concepts)
    
- How routing evolves across layers and through training
    

### Router Probing: Technical Methodology

#### Step 1: Extracting Router Logits

The first step is accessing the router's outputs. In Hugging Face's transformers library, most MoE models support returning router logits via configuration flags 
[Mixture-of-Experts Architecture \| huggingface/transformers \| DeepWiki](https://deepwiki.com/huggingface/transformers/5.4-transformer-architecture-patterns)


```python
# Enable router logit output
model.config.output_router_logits = True

# Forward pass returns router_logits alongside hidden states
outputs = model(input_ids)
router_logits = outputs.router_logits  # Tuple of router outputs per MoE layer
```

For models like Mixtral and Qwen2MoE, the router implementation follows this pattern
[Mixture-of-Experts Architecture \| huggingface/transformers \| DeepWiki](https://deepwiki.com/huggingface/transformers/5.4-transformer-architecture-patterns)
[GitHub ➝ ecker](https://git.ecker.tech/ecker/vall-e/src/commit/7366f36f8189cfe5b7eab76f9c10f39c2871a961/vall_e/models/arch/mixtral.py)

```python
# Simplified router forward pass

router_logits = self.gate(hidden_states)  # Linear projection to expert logits
routing_weights = F.softmax(router_logits, dim=1)
routing_weights, selected_experts = torch.topk(routing_weights, self.top_k, dim=-1)
```

#### Step 2: Designing Probing Experiments

Recent research has developed controlled experimental frameworks to test specific hypotheses about routing behavior [](https://openreview.net/forum?id=tilQA3Ums6).

**Semantic Probing Experiment** [](https://openreview.net/forum?id=tilQA3Ums6):  
Researchers designed paired inputs to test whether routing responds to meaning:

1. **Lexically identical, semantically different**: Compare sentences where the same word has different meanings (e.g., "river bank" vs "financial bank")
    
2. **Semantically equivalent, lexically different**: Substitute words with synonyms while keeping meaning constant
    

The key metric is **expert overlap rate**—the Jaccard similarity between sets of activated experts for paired inputs. The 2025 ACL study found statistically significant evidence of **semantic routing**: inputs with the same meaning have greater expert overlap than inputs with differing meaning, even when lexical form differs [](https://openreview.net/forum?id=tilQA3Ums6).

#### Step 3: Cross-Layer Attribution Analysis

A more sophisticated methodology from ICLR 2026 decomposes router decisions into contributions from different model components [](https://iclr.cc/virtual/2026/poster/10010907):

```python
# Conceptual approach: decompose router input into component contributions

def decompose_routing_decision(layer_idx, token_position):
    # Get router input at layer L
    router_input = model.get_router_input(layer_idx, token_position)
    
    # Trace back through computational graph
    
    attention_contribution = trace_attention_components(router_input)
    mlp_contribution = trace_mlp_components(router_input)
    previous_router_contribution = trace_previous_routers(router_input)
    
    return {
        'attention': attention_contribution,
        'mlp': mlp_contribution,
        'previous_router': previous_router_contribution
    }
```

This methodology revealed three important patterns [](https://iclr.cc/virtual/2026/poster/10010907):

1. **MoE entanglement**: Expert firing in earlier layers correlates strongly with expert firing in later layers
    
2. **Persistent influence**: Some components influence routing across many subsequent layers
    
3. **Long-range effects**: Components can have inhibiting or promoting effects on routing far downstream
    

## 📊 What Router Probing Reveals: Key Findings

### Expert Specialization Patterns

Research on models like Mixtral 8x7B shows that experts develop distinct specializations, but with varying degrees of purity [](https://zenodo.org/records/18121047?trk=public_post_comment-text)[](https://www.cerebras.ai/blog/moe-guide-router):

|Model|Experts|Top-k|Specialization Pattern|
|---|---|---|---|
|Mixtral 8x7B|8|2|Clean separation in middle layers [](https://www.cerebras.ai/blog/moe-guide-router)|
|Qwen2MoE|Varies|Varies|Shared expert + specialized routed experts [](https://deepwiki.com/huggingface/transformers/5.4-transformer-architecture-patterns)|
|DeepSeek-V3|256|8|Shared expert + routing experts with bias-based balancing [](https://cloud.tencent.cn/developer/article/2506037?policyId=1004)|

### Routing Collapse and Imbalance

Router probing has identified a critical failure mode: **router collapse**, where only 1-2 experts receive most tokens [](https://www.cerebras.ai/blog/moe-guide-router). This is visualized in Figure 3b from the Cerebras guide [](https://www.cerebras.ai/blog/moe-guide-router), showing how learned routing maintains good balance in middle layers but collapses in early and late layers.

### Knowledge Mapping via Gradient Tracking

The "Granular Knowledge Mapping" approach [](https://zenodo.org/records/18121047?trk=public_post_comment-text) tracks gradients across router, attention, and expert layers during fine-tuning, creating 3D "Ribcage" visualizations that separate:

- **Attention Spine**: General reasoning capabilities
    
- **Expert Wings**: Specialized knowledge domains
    

## 🛠️ Practical Router Probing for DeepSeek-V3

Given your interest in DeepSeek-V3 specifically, here's how to approach router probing for this model:

### DeepSeek-V3 Router Architecture [](https://cloud.tencent.cn/developer/article/2506037?policyId=1004)

- **Experts**: 1 shared expert (always activated) + 256 routing experts
    
- **Top-k**: 8 experts activated per token
    
- **Node limit**: Tokens routed to at most 4 nodes (M=4) for distributed efficiency
    
- **Balancing**: Bias-based load balancing (no auxiliary loss in later training stages)
    
- **Routing formula**:
    
    - Affinity scores: si,tsi,t​ for expert i, token t
        
    - Bias term bibi​ added to scores for load balancing
        
    - Top-k selection based on (score + bias)
        

### Probing Implementation Strategy

python

```python
# Conceptual probing code for DeepSeek-V3

from transformers import AutoModelForCausalLM
model = AutoModelForCausalLM.from_pretrained("deepseek-ai/DeepSeek-V3", 
                                             output_router_logits=True)
def probe_routing(model, text_prompts):
    inputs = tokenizer(text_prompts, return_tensors="pt", padding=True)
    outputs = model(**inputs)
    
    # Extract router decisions per layer
    for layer_idx, router_logits in enumerate(outputs.router_logits):
    
        # router_logits shape: [batch*seq_len, num_experts]
        probs = torch.softmax(router_logits, dim=-1)
        top_probs, top_experts = torch.topk(probs, k=8, dim=-1)
        
        # Analyze patterns
        expert_usage = torch.bincount(top_experts.flatten(), minlength=256)
        routing_entropy = -torch.sum(probs * torch.log(probs + 1e-10), dim=-1)
        
        # Store results
        results[layer_idx] = {
            'expert_usage': expert_usage,
            'routing_entropy': routing_entropy,
            'top_experts': top_experts,
            'top_probs': top_probs
        }
    
    return results
```

### Key Questions to Probe

1. **Semantic specialization**: Does expert activation correlate with topic or domain?
    
2. **Cross-lingual patterns**: How do routing patterns differ across languages?
    
3. **Reasoning vs. knowledge**: Do different experts handle factual recall vs. logical reasoning?
    
4. **Layer-wise progression**: How does routing evolve from early layers (feature extraction) to late layers (output generation)?
    

## 📚 Current Research Frontiers

### The ICLR 2026 Methodology [](https://iclr.cc/virtual/2026/poster/10010907)

This work provides a rigorous framework for cross-layer mechanistic interpretability of routing, quantifying how different components contribute to routing decisions recursively.

### Semantic Routing Evidence [](https://openreview.net/forum?id=tilQA3Ums6)

The ACL 2025 study provides the first controlled, statistically rigorous evidence that routing responds to semantics, not just surface form.

### Granular Knowledge Mapping [](https://zenodo.org/records/18121047?trk=public_post_comment-text)

This approach creates visualizable maps of knowledge distribution across experts, distinguishing general reasoning from specialized knowledge.

### Router Design Innovations [](https://www.cerebras.ai/blog/moe-guide-router)

Recent work explores alternatives like Sinkhorn routing, which maintains perfect load balancing across all layers but may limit specialization compared to learned routing with auxiliary losses.

## 🎓 Summary: What Router Probing Can and Cannot Tell Us

**What router probing CAN reveal:**

- Which experts activate for which inputs
    
- How routing correlates with semantics
    
- Expert specialization patterns
    
- Layer-wise routing dynamics
    
- Router collapse or imbalance
    

**What router probing CANNOT (yet) reveal:**

- What computations experts perform internally
    
- How expert outputs combine to produce final predictions
    
- Full circuit-level mechanisms
    

Router probing is thus a **powerful but partial** interpretability technique—it illuminates the "who" and "when" of expert activation, but the "how" of expert computation remains largely opaque. The field is actively developing new methods to bridge this gap, with architectures like Monet (Mixture of Monosemantic Experts) aiming to make experts inherently interpretable by design.