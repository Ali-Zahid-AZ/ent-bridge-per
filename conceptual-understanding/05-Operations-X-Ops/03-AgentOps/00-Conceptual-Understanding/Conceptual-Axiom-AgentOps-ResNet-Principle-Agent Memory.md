---
tags:
  - axiom
  - research-ideas
  - research-directions
  - agentops
  - agentic-architecture
---

---
```table-of-contents
```
---
### References

- [[DeepSeek-mHC-Manifold-Constrained-Hyper-Connections]]

---
### 1. Axioms

> [!critical] **Axiomatic: Standard vs ResNet Architectures**
>- **Standard Networks** ➝ **State Restoration** ➝ actively maintaining state through transformation
>- **Residual Networks** ➝ **State Correction** ➝ state maintained by architecture, learn only deltas

> [!example] **Axiomatic**: ResNet of AgentOps
>- **Persistent Graph structures**  ➝ are the **physical implementation**  ➝ of **Residual Connections for Agents**
>- **AgentOps** should move from **Context Stuffing** (re-processing) ➝ to **State Maintenance** (residual updates)
>--- 
>**The Need for Persistent Graphs** 
>- Because without them ➝  **the agent is trapped in a vanishing gradient loop of re-reading its own history**
>- **Trading $O(N)$ context re-reading ➝ for $O(1)$ graph updates**
>-  $Graph_{new} = Graph_{old} + \Delta_{query}$

|              | **Standard Network**                   | **Residual Network**                          |
| ------------ | -------------------------------------- | --------------------------------------------- |
| **Axiom**    | **State Restoration**                  | **State Correction**                          |
| **Equation** | $y = H(x)$                             | $y = x + F(x)$                                |
| **Burden**   | Must preserve AND transform            | Only transform; preservation is architectural |
| **Risk**     | Information loss (vanishing gradients) | Information guaranteed to flow                |
| **Analogy**  | Rewriting the whole book each chapter  | Editing a master copy                         |

---
### 2. State Correction in Agentic Systems: Applying the ResNet Principle to Agent Memory

#### I. Connecting State Restoration → State Correction to Agentic Systems 

##### Current Agentic Systems: State Restoration

- Agent receives context
- Agent must "reconstruct" the entire understanding from scratch each turn
- Memory/context is managed externally (RAG, vector stores, conversation history)
- Each agent call is essentially y=H(x)y = H(x) y=H(x) - rewrite the entire state

- **Current agent frameworks (LangGraph, AutoGen, etc.) ➝  all state restoration**
    - Store conversation history
    - Load context into prompt
    - LLM reconstructs understanding from scratch
    - Generate response
    - Repeat

##### What if: State Correction

- What if agents worked like ResNets?
- Instead of reconstructing state from context each time...
- ...what if there was a PERSISTENT state that flows through (the skip connection)
- And each agent turn only computes the DELTA ➝ the correction $F(x)$

- **State correction would mean:**
    - Persistent state vector ➝ like $x$ in ResNet
    - Agent only computes ➝ what **changed** ➝ $F(x)$
    - **Update** ➝ **state_new = state_old + delta**
    - Much more efficient
    - Less prone to **forgetting** ➝ like vanishing gradients

-  **This maps to:**
    - **State restoration** ➝  Current RAG + context window management
    - **State correction** ➝  Persistent embedding space + delta updates


> [!example] **Relates to** 
> - Continual learning (catastrophic forgetting problem)
> - Memory-augmented neural networks
> - Persistent embeddings
> - State space models (like Mamba)


> **Agentic Systems** currently suffer from the exact same **vanishing signal** problem that pre-ResNet networks did ➝ for the exact same mathematical reason

#### 2. The Current State: Agents as Stateless Restorers ➝ y = H(x)

> Currently ➝ every time an Agent is invoked or called (e.g in LangChain or AutoGen) ➝ we are forcing it to perform **State Restoration**

- **The Mechanism** 
	- We dump the entire conversation **history** + **RAG context** into the prompt
- **The Task** 
	- Read all of this + reconstructe ➝ the current state of the world
- **The Flaw** 
	- This is $y = H(x)$
	- The model has to relearn **what is true** at every **single step**
	- If the context is too long (vanishing gradient equivalent) ➝ it starts forgetting early instructions or hallucinating
	- It is computationally wasteful + mathematically unstable over long horizons

#### 3. The Insight: Agents as State Correctors ➝ y = x + F(x)

> Treat the Agent's memory as a **Residual Stream**

- **The Mechanism** 
	- The **State** (Context) ➝ exists outside the LLM call
	- It persists
    
- **The Task** 
	- The Agent only receives the _current_ state and the _new_ input. 
	- Its job is not to answer ➝ but to output a **Delta**  ➝ $F(x)$
    
- **The Equation** 
	- $\text{State}_{t+1} = \text{State}_t + \text{Update}$
    
- **The Benefit** 
	- The Agent doesn't need to **remember** the whole history ➝ it just needs to know **what changed**
	- This is infinitely more stable ➝ because the **Identity** (the previous state) ➝ is preserved by default

### 3. The Implementation: Persistent Graphs

- If you treat a **Knowledge Graph** as the variable $x$:
	- **Standard Agent**
	- Re-reads the whole graph every time ➝ slow + expensive
	- **Residual Agent** 
		- The Graph persists in memory
		- The Agent outputs a Cypher query (the delta) to add one node or delete one edge
		- $Graph_{new} = Graph_{old} + \Delta_{query}$
        

- If we use a **Persistent Graph**  ➝ like Neo4j ➝  as the Residual Stream ($x$)
	- **Standard approach** 
		- Dump the whole graph into the context window ➝ Impossible for large graphs, expensive, unstable
	- **Refined approach** 
		- The Graph _is_ the memory
		- The Agent is just a function $F(x)$ that generates **Cypher Queries** (the deltas)
		- The Agent ➝ doesn't need to know the whole graph
		- It just needs to know _where_ to look and _how_ to change it
        - **Efficiency** 
	        - **Trading $O(N)$ context re-reading ➝ for $O(1)$ graph updates**
        


