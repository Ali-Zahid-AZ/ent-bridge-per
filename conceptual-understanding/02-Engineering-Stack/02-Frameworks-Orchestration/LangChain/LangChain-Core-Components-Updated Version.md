---
tags:
  - library-LangChain
  - code-explanations
  - conceptual-explanations
  - ibm_agenticai_rag
priority: High
---

---
#### Resources
[[LangChain-LangGraph-AI-Stack-Updated]]
[[Lecture-Notes-Module-2]]

---

> [!beware] Strictly stick to this "Clean Stack" and ignore the rest
> 1. **`langchain-core`**: Learn the **Runnables** (LCEL) and **Messages**. This is the stable foundation.
> 2. **`langgraph`**: This is the _only_ way to build Agents now. Ignore the old `AgentExecutor` (it is deprecated/legacy).
> 3. **`langchain-community`**: Treat this as a "junk drawer." Only import specific tools (like `WikipediaRetriever`) when you absolutely need them.
> 

---
## Core Modules of LangChain

To ensure we are on the same page for future coding, here is the architectural breakdown of the framework:

- **Model I/O:** Managing prompts (**PromptTemplates**), interacting with LLMs (ChatModels), and parsing outputs (**Output Parsers**).
- **Retrieval (RAG):** The interface with your data. This includes 
	- Document Loaders
	- Text Splitters
	- Embeddings
	- Vector Stores
- **Composition (LCEL):** **LangChain Expression Language** is the declarative way to chain components together. It provides built-in support for streaming, async, and parallel execution.
- **Memory:** Persisting state between turns of a conversation.
- **Agents:** Systems where the LLM decides which **Tools** to call to solve a given task.

---
## LCEL (LangChain Expression Language) Syntax

As an architect, you'll likely prefer LCEL for its transparency and performance. A basic pattern looks like this:


```python
from langchain_core.prompts import ChatPromptTemplate
from langchain_openai import ChatOpenAI
from langchain_core.output_parsers import StrOutputParser

prompt = ChatPromptTemplate.from_template("Explain {topic} like I am 5.")
model = ChatOpenAI(model="gpt-4")
output_parser = StrOutputParser()

# The Chain
chain = prompt | model | output_parser

# Execution
response = chain.invoke({"topic": "Quantum Computing"})
```

---
## Main Components of LangChain 

### 1. Model I/O (The Interface)

This is how you talk to the brain. LangChain standardizes this so you can switch providers (e.g., OpenAI to WatsonX or Llama) with minimal code changes.
- **LLMs:** Take a string in, output a string (older style)
- **Chat Models:** Take a list of messages (System, User, AI) in, output a message (modern style, e.g., GPT-4)
- **Output Parsers:** LLMs output raw text; Parsers convert that text into structured data (like JSON, a Python list, or a specific object) so your code can actually use it

### 2. Prompt Templates

- Hard-coding strings is unscalable
- Templates allow you to create dynamic prompts with variables.
	- _Example:_ Instead of writing "Tell me a joke about cats," you write a template: `"Tell me a {adjective} joke about {topic}."`
	- This is crucial for **Prompt Engineering**—you optimize the template once and reuse it everywhere
    
### 3. Retrieval (The "Knowledge" or RAG)

LLMs only know what they were trained on. To give them _your_ data (PDFs, SQL databases, emails), you use Retrieval.
- **Document Loaders:** Scripts to load data from sources (CSV, PDF, Slack, etc.)
- **Text Splitters:** Chunks long documents into smaller pieces (LLMs have context limits)
- **Embeddings:** Converts text chunks into vector numbers (lists of floats)
- **Vector Stores:** Databases (like Chroma, Pinecone, Milvus) that store these vectors for fast searching
    
### 4. Memory

By default, LLMs are stateless—they don't remember the previous question you asked.

- **Memory** components store the history of the conversation (User inputs + AI outputs) and inject it back into the prompt of the next turn so the AI has context.
    
### 5. Chains (LCEL)

This is the "glue." You rarely use a model in isolation. You usually want to:

> [!The DataFlow in LCEL]
> 1. Receive User Input $\rightarrow$ 2. Format Prompt $\rightarrow$ 3. Call Model $\rightarrow$ 4. Parse Output.

- **LCEL (LangChain Expression Language):** The modern, declarative way to link these steps using the pipe `|` operator. It handles streaming and async logic for you automatically.
    
### 6. Agents & Tools (The "Agentic" Part)

- **Chains** are hard-coded sequences (Step A $\rightarrow$ Step B).
- **Agents** use an LLM as a reasoning engine to _decide_ what to do and in what order.
- **Tools:** Functions you give the Agent (e.g., "Google Search", "Calculator", "Run Python Code"). The Agent figures out when to call them to solve the user's problem.


```
+-----------------------+
|  ChatPromptTemplate   | <-- Creates a LIST of messages (System, User)
+-----------------------+
           |
           v
+-----------------------+
|      ChatModel        | <-- REPLACES "LLM". It detects if a tool is needed.
| (The Reasoning Engine)|     Input: Messages | Output: Tool Call Signal 
+-----------------------+
           |
           v
+-----------------------+
|       AIMessage       | <-- Contains the "Tool Call" (e.g., {"tool": "weather"})
|   (with Tool Call)    |     instead of just plain text [cite: 293, 295]
+-----------------------+
           |
           v
+-----------------------+
|      ToolNode         | <-- Executed ONLY if the ChatModel requests it.
|   (The Action)        |     (The "Arms/Hands") [cite: 250] loops back to the chatmodel
+-----------------------+
```
---

| **Component** | **Purpose**                      | **Analogy**             |
| ------------- | -------------------------------- | ----------------------- |
| **Model**     | The reasoning engine             | The CPU / Brain         |
| **Prompt**    | Instructions for the engine      | The Code / Instructions |
| **Memory**    | Short-term context retention     | RAM                     |
| **Retrieval** | Long-term knowledge access       | Hard Drive / Database   |
| **Tools**     | Capabilities (Search, Math, API) | Arms / Hands            |
| **Agent**     | The orchestrator                 | The Project Manager     |

---
### Model in LangChain Architecture 

- Model is the **Foundation Model** (Large Language Model).

This can be:
1. **Proprietary Models:** Accessed via API (e.g., OpenAI's GPT-4, Anthropic's Claude, Google's Gemini, IBM WatsonX).
   2. **Open Source Models:** Running locally or hosted (e.g., Llama 3, Mistral, Hugging Face models).
    
##### Key Distinction: LLM vs. Chat Model
LangChain makes a subtle but important technical distinction between two types of _interfaces_ for these Foundation Models. You will see this in the documentation:

- **`LLM`:** This refers to older-style "text completion" models.
    - **Input:** A single string (e.g., "The capital of France is").
    - **Output:** A string completion (e.g., " Paris.").
        
- **`ChatModel`:** This refers to modern models trained for conversation (like ChatGPT).
    - **Input:** A list of messages (System Message, User Message, AI Message).
    - **Output:** An AI Message.

---
### Chat Model
#### The Core Concept: It's a Script, Not a String

- In the early days (GPT-3) → we treated AI like a text predictor →  you gave it half a sentence → it finished it.
- The **ChatModel** → treats the interaction like a **script for a play**
	- **Instead of a single bloc**k of text → the input is a structured list of "**Messages**" 
		- where each message has a specific **Role**
- This structure is what allows the model to understand context, follow instructions, and maintain a persona over a long conversation.

---
#### The Three Key Roles

When you **send data to a ChatModel**, you aren't just sending "text" → You are **assigning roles**
LangChain standardizes these roles regardless of whether you are using OpenAI, Llama, or WatsonX
##### 1. SystemMessage (The "Director's Notes")
- **Who:** The System (You, the Architect).
- **Purpose:** This sets the behavior, constraints, and persona of the AI _before_ the user even says "Hello."
	- **Example:** "You are a helpful expert in Quantum Machine Learning. Speak in a formal academic tone. Do not use emojis."
- _Note:_ The end-user usually never sees this message, but it dictates everything the model does.
    
##### 2. UserMessage (The "Actor")
- **Who:** The human user.
- **Purpose:** The actual query or input.
	- **Example:** "Explain the difference between a qubit and a bit."
    
##### 3. AIMessage (The "Response")
- **Who:** The AI model.
- **Purpose:** The response generated by the model.
- **Why it's in the input:** In a conversation, you feed previous `AIMessages` back into the model so it remembers what it just said. This is how "Memory" works.

|**Role**|**Who / Actor**|**Purpose**|**Example Content**|
|---|---|---|---|
|**SystemMessage**|The Architect / Developer|**The Director's Notes.**<br><br>  <br><br>Sets the persona, rules, boundaries, and tone. This is usually hidden from the end-user.|_"You are a strict code reviewer. Only output valid Python code. Do not provide explanations."_|
|**UserMessage**|The Human User|**The Request.**<br><br>  <br><br>The actual input, question, or task provided by the person interacting with the application.|_"Write a function to calculate the Fibonacci sequence."_|
|**AIMessage**|The Model|**The Response.**<br><br>  <br><br>The content generated by the LLM. In a conversation loop, these are saved and fed back into the model so it "remembers" what it said previously.|_"def fib(n): return n if n <= 1 else fib(n-1) + fib(n-2)"_|

---

#### Why ChatModels are Critical for "Agentic" AI

Since you are studying Agentic AI, the ChatModel has a superpower that standard LLMs lack: **Tool Calling (Function Calling).**

Standard LLMs just want to write poetry or paragraphs. **ChatModels** (like GPT-4 or specific WatsonX models) have been fine-tuned to detect when they should _stop_ writing text and instead output a **structured command** (like JSON) to run a specific tool.

- **Scenario:** You ask, "What is the weather in Karachi?"
- **Standard LLM:** Might hallucinate "It is hot in Karachi."
- **ChatModel:** Recognizes it doesn't know the answer, and instead of text, generates a "Tool Call" signal: `{"tool": "get_weather", "city": "Karachi"}`.
    
This ability to "break character" and ask to run code is what makes an Agent possible.


The ChatModel is a **standardized interface** that expects a **list of messages** (System, User, AI) rather than a raw string. This structure is what enables:
1. **Steerability** (via System instructions).
2. **Context** (via History).
3. **Action** (via Tool Calling).

---
