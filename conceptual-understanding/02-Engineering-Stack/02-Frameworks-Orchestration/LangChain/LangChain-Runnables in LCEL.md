---
tags:
  - library-LangChain
  - agentic-ai-methodologies
  - agentops
status: In Progress
priority: High
topic: AgentOps:Frameworks
---

---
#### Resources
- [[Interface-Based Programming]]
- [Medium: Runnables in LangChain](https://medium.com/@shiwammaddheshiya?source=post_page---byline--9ca9ed4bfef3---------------------------------------)
- [Medium: How to Actually Use LangChain: A Practical Mental Model](https://medium.com/activated-thinker/how-to-actually-use-langchain-a-practical-mental-model-8884ac24d0e9)
- [[DLAI-Functions, Tools and Agents with LangChain]]
---
#### Considerations 

> [!critical] Consider Runnables ➝ as a Wrapper with shared properties 
> If anything is a Runnable ➝  it will inherit common properties ➝  this is Interface-Based Programming
> Since it inherits common properties ➝  it means it can integrate with other Runnables
> In LangChain: Runnables are chained together 

>[!Example ]  How to think in LangChain Paradigm 
>Input → Load → Split → Reason → LLM → Output

---
### Runnables in LCEL

Runnable is a core abstraction in LangChain
- that defines a **standardized execution interface**
	- for components such as models, tools, chains, and custom logic
	- that implement it ➝  enabling them to be **invoked**, **composed**, and **chained** together consistently
	- using a common set of **execution methods** (invoke, batch, stream, ainvoke, etc.)

This abstraction is particularly useful for building complex workflows, as it allows developers to **break tasks into smaller, composable units**

---
## Concepts

- **Standardized API:** Every Runnable exposes a common set of methods for execution:
	- `.invoke(input)`: For a single synchronous input and output.
	- `.batch(inputs)`: For processing multiple inputs in parallel.
	- `.stream(input)`: For streaming back chunks of the response incrementally.
	- Asynchronous versions (`.ainvoke()`, `.abatch()`, `.astream()`): For high-throughput, non-blocking operations.

- **Composability:** Runnables can be linked together using the pipe (`|`) operator or explicit classes like `RunnableSequence` to create complex data flows, where the output of one component becomes the input of the next.

- **Modularity and Reusability:** Because each Runnable has a single, clearly defined purpose and a uniform interface, components can be easily swapped, tested independently, and reused across different applications, making the code cleaner and more maintainable.

- **LangChain Expression Language (LCEL):** The system for composing Runnables is called LCEL. It allows developers to build declarative chains with built-in support for features like fallbacks, retries, concurrency, and LangSmith tracing without code changes.

**In Simple Terms (LCEL)**
- A Runnable sequence is used almost everywhere in code.  
    Rather than using `RunnableSequence`, you can use **pipe notation** ➝ ` r1 | r2 | r3 … ` ➝  to create sequential chains
	- In LangChain, this is called **LangChain Expression Language (LCEL)**

- LCEL is a **declarative way** to define Runnable sequences in LangChain Currently, it is designed only for sequential chains In the future, there may be a declarative way to define **parallel chains** as well

--
### Common things that are Runnables

In LangChain, these are all Runnables:
- `Prompt templates`
- `LLMs / Chat models`
- `Output Parsers`
- `Chains`
- `Custom Python functions`

--
## Types of Runnables in LangChain

**Task-Specific Runnables**: These are core LangChain components that implement the Runnable interface, allowing them to be composed into pipelines.

Examples:

- ChatOpenAI, ChatOllama
- PromptTemplate
- Retrivers
- Output Parsers

**Runnable Primitives**: Used to run multiple Runnables at the same time. This is perfect for “Map-Reduce” tasks or fetching data from three different sources simultaneously.

Runnable Primitives are commonly used for:

- Runnable Sequence
- Runnable Parallel
- Runnable Map
- Runnable Branch
- Runnable Lambda
- Runnable Passthrough
- Applying a runnable over a list of inputs

## Common Runnable Primitives

1. **Runnable Sequence**

- Runnable Sequence is one of the most important Runnable primitives in LangChain.
- It allows you to connect two or more Runnables in sequence.
- A Runnable Sequence executes each step one after another, passing the output of one step as the input to the next step.
- It is useful when you need to compose multiple Runnables into a structured, linear workflow.
**2. Runnable Parallel**

- Runnable Parallel is a Runnable primitive that allows multiple Runnables to execute in parallel.
- Each Runnable receives the same input and executes independently.
- The final output is a dictionary, where each key corresponds to the output of a specific Runnable.

**3. Runnable Passthrough**

- Runnable Passthrough is a special Runnable primitive that returns the input exactly as it is, without modifying it.
- It is often used as a placeholder or buffer in workflows, especially in parallel or branching pipelines where the original input needs to be preserved.
**4. Runnable Lambda**

- RunnableLambda is a Runnable primitive that allows you to apply a custom Python function within an AI pipeline.
- It acts as middleware between different AI components, enabling preprocessing, data transformation, API calls, filtering, and post-processing in a LangChain workflow.
- In simple terms:
- With this, we can convert any Python function into a **Runnable**.
- Once a function becomes a Runnable, it can be part of any chain.
- When you want to add **custom logic** in the middle of a workflow, **Runnable Lambda** is used.

**5. Runnable Branch**

- RunnableBranch is a control-flow component in LangChain that allows you to conditionally route input data to different Runnables or chains based on custom logic.
- It works like an if/elif/else block for chains: you define a set of condition functions, each associated with a Runnable (e.g., LLM call, prompt chain, or tool).
- The first condition that evaluates to True will execute its corresponding Runnable.
- If no condition matches, a default Runnable can be executed (if provided).
- Use case: Whenever you need conditional execution in a workflow, Runnable Branch acts as LangChain’s equivalent of if/else logic.

---

## Why Runnables?


When LangChain was first introduced, it did one very important thing: it provided all the components needed to build **LLM applications**.

For example:

- Prompt Templates
- LLM Components
- Output Parsers
- Retriever Components
- And more

The idea was that AI engineers could **plug and play** these components to build different types of LLM applications easily.

## The Problem with These Components

The main issue was **lack of standardization**.

- All components did **not follow the same rules**.
- The way to interact with each component was **different**.
- Each component had a different **method name** and behavior.

For example:

- Prompt Templates — format()
- LLM Components — predict()
- Output Parsers — parse()
- Retriever Components — get_relevant_documents()
- And more

**Issues caused by this:**

- Connecting components together was difficult
- Building flexible workflows was hard
- Chaining components became error-prone

## LangChain Team Observation

The LangChain team noticed this problem and decided to **standardize all components**.

**Standardization decision:**

- All components should follow the **same set of rules**
- There should be a **single common function** to interact with every component
- invoke()

**Result**

- The invoke() function is now available in **every component**
- Whether it is a Prompt, LLM, Parser, or Retriever

**Benefits of invoke():**

- Components can be easily connected
- Output of one component automatically becomes the input of the next component.
- Clean chaining and pipelines become possible

## How Standardization Was Achieved

To enforce this, LangChain introduced the concept of a **Runnable**.

**Runnable Concept:**

- `Runnable`is an **abstract base class**
- All LangChain components **inherit from Runnable**

**Role of Runnable:**

- Defines a **common interface**
- Makes the invoke() method **mandatory**
- Each component must implement the required methods

**Final Outcome**

- All components became **standardized**
- Components became **easily composable**
- Building **highly flexible LLM applications** became possible


---
#### The Technical Jargon (Principal-level Specs)

- **Interface-Based Programming**

The **Runnable Protocol** is a functional abstraction of the **Pipe and Filter** architectural pattern. It defines a consistent interface for any object that can be part of a **Directed Acyclic Graph (DAG)**.

- **The Interface:** A Runnable is any class that implements the `Runnable` base class, which mandates three primary synchronous methods (`invoke`, `batch`, `stream`) and their asynchronous counterparts (`ainvoke`, `abatch`, `astream`).
    
- **Input/Output Schemas:** Every Runnable is strictly typed. It exposes `.input_schema` and `.output_schema` (typically powered by Pydantic). This allows for static type checking and automatic validation between nodes in a chain.
    
- **Composition Logic:** Runnables utilize the `__or__` (bitwise OR) dunder method to implement functional composition. When you write `RunnableA | RunnableB`, you are creating a new `RunnableSequence` where the `Output` of A is validated against the `Input` of B at runtime.
    
- **Atomic vs. Composite:** An "Atomic Runnable" is a single unit (like a `ChatModel`), while a "Composite Runnable" (a chain) is itself a Runnable. This recursion allows for deeply nested, observable architectures.

--
#### Simple Code & Visualization

In LangChain, the `|` operator is the "pipe" that turns these objects into a sequence.

```python
# A simple LCEL (LangChain Expression Language) chain
# Every component here (prompt, model, parser) is a 'Runnable'

chain = prompt | model | output_parser

# Because 'chain' is also a Runnable, you use the standard interface:
result = chain.invoke({"input": "Hello"})
```

```bash
      [ Input: Dict ] 
             |
             v
    +-------------------+
    |     Runnable 1    |  <-- (e.g., PromptTemplate)
    |  .invoke(input)   |
    +-------------------+
             |
      [ Output: Message ]
             |
             v
    +-------------------+
    |     Runnable 2    |  <-- (e.g., ChatModel)
    |  .invoke(msg)     |
    +-------------------+
             |
      [ Output: AIMessage ]
             |
             v
    +-------------------+
    |     Runnable 3    |  <-- (e.g., OutputParser)
    |  .invoke(aimsg)   |
    +-------------------+
             |
      [ Final Output: Str ]
```

**Insight:** The beauty of a Runnable is that it handles **State** and **Context** automatically. When you call `.invoke()`, LangChain creates a "Run Object" behind the scenes that tracks the input/output for logging and debugging, which is the foundation of production-grade observability.

---
### Runnable: The Logic of Common Properties

Because they are `all wrapped` in the **Runnable** interface, they all inherit these three "Superpowers":
##### 1. Input/Output Schemas (The "Ports")
Every Runnable has an `.input_schema` and an `.output_schema`. This ensures that when you pipe `A | B`, LangChain checks if the "output port" of A fits into the "input port" of B.

> **Note:** This is why you get such good error messages in LCEL—the "wrapper" knows the data types before the code even runs.
##### 2. Configuration (The "Labels")
You can attach configuration to any Runnable using `.with_config()`
- **Example:** You can set a `recursion_limit` or a `run_name` on the wrapper, and it applies to whatever is inside.
##### 3. Resilience (The "Safety Valves")
Since it's a wrapper, you can add **Fallbacks** or **Retries** to it.
- If the LLM inside the wrapper fails, the wrapper itself can say, _"Wait, I have a backup model in my pocket,"_ and run that instead. The rest of your pipeline never even knows there was a crash.
