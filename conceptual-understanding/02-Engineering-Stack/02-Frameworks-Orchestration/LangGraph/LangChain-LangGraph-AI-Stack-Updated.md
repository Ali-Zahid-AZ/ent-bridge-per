---
tags:
  - library-LangChain
  - library-LangGraph
  - agentic-ai-methodologies
  - agentic-backbone
topic: AgentOps:Architectures
priority: High
---

---
> [!TIP] LAST UPDATED: JAN-2026

---
#### References
[[LangChain-Core-Components-Updated Version]]

---

> [!NOTE]
> ### Updated Flow :
> 
> - **Input:** Chat Model (Llama 3.1)
> - **Enforcement:** `PydanticOutputParser` or `.bind_tools()`
> - **Output:** Pure JSON / Pydantic Object
> - **Post-Processing:** Convert to CSV/Pandas in your Python code (not in the LLM).

## 1. The Core Philosophy

- **LangChain is for "Bricks":** Use it to define atomic operations (Models, Prompts, Tools, Indexing).
- **LangGraph is for "Blueprints":** Use it to define flow, logic, loops, and state.
    
---
## 2. LangChain: The Primitives (Stateless)

> [!NOTE]
> _These are the tools you build with. They do not manage the conversation loop._

### A. The Brain: Chat Models

Legacy "LLMs" (text-in/text-out) are deprecated for agents. You strictly use **Chat Models**.

- **Interface:** Expects a list of **Messages**, not a string.
- **The Roles:**
    - **`SystemMessage`:** The Director's Notes. Sets persona, constraints, and tone (hidden from user).
    - **`HumanMessage`:** The User's input.
    - **`AIMessage`:** The Model's response.
    - **`ToolMessage`:** The result of a function call (critical for agents).
        
- **Why it matters:** This structured input allows the model to "break character" and issue **Tool Calls** (JSON) instead of just text.
    
### B. The Glue: LCEL (LangChain Expression Language)

Do not use `LLMChain` or `SequentialChain`. Use **LCEL** for linear pipelines.

- **Syntax:** `chain = prompt | model | output_parser`
- **Use Case:** Simple, stateless tasks (e.g., "Take this text, format it, classify it"). If it needs a loop, move to LangGraph.
    
### C. Data Engineering (RAG Indexing)

The "Indexing" phase remains pure LangChain.
- **Loaders:** `TextLoader`, `PyPDFLoader` (Ingest raw data).
- **Splitters:** `RecursiveCharacterTextSplitter` (Chunking for context windows).
- **Embeddings:** `nomic-embed-text` (Locally convert text to vectors).
- **Vector Store:** `Chroma` / `Pinecone` (The database for retrieval).
    
---
## 3. LangGraph: The Orchestration (Stateful)

_This replaces `AgentExecutor`. It is the runtime for your application._

### A. The State (`TypedDict`)

This is the "Whiteboard" of your agent. Unlike legacy memory, **you define the schema**.


```python
class AgentState(TypedDict):
    # 'add_messages' ensures history is appended, not overwritten
    messages: Annotated[list, add_messages] 
    # Add your own keys for custom logic
    documents: list[str] 
```

### B. The Graph Structure

- **Nodes:** Standard Python functions. They accept `State` and return an **update** to the state.
    
    - _Chatbot Node:_ Calls the LLM.
    - _Tool Node:_ Executes Python functions (Math, RAG Search).
        
- **Edges:** The Control Flow.
    
    - _Conditional Edge:_ Logic gates (e.g., `if tool_called: go_to_tools` else `go_to_end`).
    - _Cyclic Edge:_ The Loop (e.g., `after_tools: go_back_to_chatbot`).
        
### C. Persistence (Memory)

**Legacy Way:** `ConversationBufferMemory` (In-memory, vanishes on restart)
**Modern Way:** **Checkpointers** (SQLite/Postgres).

- Saves the `State` at every step.
- Enables **"Time Travel"**: You can resume a conversation from yesterday or rewind to fix a mistake.
    
---
## 4. What Was Removed (The "Irrelevant" List)

_Based on your strict instruction to filter for the new way:_

- ❌ **`AgentExecutor`**: Deprecated. It was a "Black Box" loop. Replaced by `StateGraph`.
    
- ❌ **`SequentialChain` / `LLMChain`**: Deprecated. Replaced by LCEL (`|`) and Graph Nodes.
    
- ❌ **`RetrievalQA` Chain**: Deprecated. Replaced by building a **RAG Tool** inside a Graph.
    
- ❌ **`ConversationBufferMemory`**: Deprecated for Agents. Replaced by `AgentState` and Persistence Checkpointers.

```bash
[ LEGACY / REMOVED ]               [ MODERN ARCHITECTURE ]

String Prompt -------------------> ChatPromptTemplate (Roles)
      |                                     |
      v                                     v
LLM (Text Completion) -----------> ChatModel (Messages & Tools)
      |                                     |
      v                                     v
AgentExecutor (Black Box) -------> LangGraph StateMachine (Cyclic)
      |                                     |
      v                                     v
Memory Class --------------------> Persistence Checkpointer (DB)
```

```bash
[ START ]
                                    |
                                    v
+-----------------------------------------------------------------------+
|  1. ChatPromptTemplate (The Setup)                                    |
|  - Compiles User Input + System Instructions                          |
|  - output: List[BaseMessage]                                          |
+-----------------------------------+-----------------------------------+
                                    |
                                    v
+-----------------------------------------------------------------------+
|  2. STATE (The Container)                                             |
|  - "Group Chat History"                                               |
|  - Stores: [SystemMsg, HumanMsg, AIMsg, ToolMsg...]                   |
+-----------------------------------+-----------------------------------+
                                    |
                                    v
+-----------------------------------------------------------------------+
|  3. ChatModel (The Brain)                                             | <-------+
|  - Reads STATE                                                        |         |
|  - Decides: "Do I speak?" OR "Do I call a tool?"                      |         |
|  - output: AIMessage (Content="..." OR tool_calls=[...])              |         |
+-----------------------------------+-----------------------------------+         |
                                    |                                            |
                                    v                                            |
                          [ 4. Conditional Edge ]                                |
                           (The "Traffic Cop")                                   |
                             /             \                                     |
                 [Has Tool Call?]        [No Tool Call?]                         |
                     /                           \                               |
                    v                             v                              |
+-----------------------------------+      +-------------+                        |
|  5. ToolNode (The Action)         |      |     END     |                        |
|  - Executes function (e.g., RAG)  |      | (Response)  |                        |
|  - output: ToolMessage (Result)   |      +-------------+                        |
+-----------------------------------+                                             |
                    |                                                             |
                    |                                                             |
                    +-------------------------------------------------------------+
                            (Loop back to Brain with new Data)
                            
                            

### **Key Architectural Components**

- **The Container (State):** Everything flows into this shared memory.  
- **The Brain (ChatModel):** The only component that "thinks." It sees the `ToolMessage` from the previous turn and uses it to generate the final answer.
- **The Loop:** The line going from **ToolNode** back to **ChatModel** is what makes this an "Agent" rather than a "Chain."
  
```



| **Your Mental Model** | **The Python Code You Write**                                |
| --------------------- | ------------------------------------------------------------ |
| **The Container**     | `class AgentState(TypedDict): messages: list`                |
| **The Brain**         | `model = ChatOpenAI(model="gpt-4o").bind_tools(tools)`       |
| **The Setup**         | `workflow = StateGraph(AgentState)`                          |
| **The Traffic Cop**   | `workflow.add_conditional_edges("chatbot", tools_condition)` |
| **The Action**        | `workflow.add_node("tools", ToolNode(tools))`                |
| **The Loop**          | `workflow.add_edge("tools", "chatbot")`                      |


```python
# SKELETION CODE FOR UNDERSTANDING 

# 1. DEFINE THE CONTAINER (State)
class AgentState(TypedDict):
    messages: Annotated[list, add_messages]

# 2. DEFINE THE BRAIN (Node)
def chatbot(state: AgentState):
    return {"messages": [llm.invoke(state["messages"])]}

# 3. BUILD THE GRAPH
workflow = StateGraph(AgentState)
workflow.add_node("chatbot", chatbot)
workflow.add_node("tools", ToolNode(tools))

# 4. DEFINE THE TRAFFIC COP & LOOP
workflow.add_conditional_edges("chatbot", tools_condition) # The Decision
workflow.add_edge("tools", "chatbot")                      # The Loop

# 5. COMPILE
app = workflow.compile()
```


```python
# PRODUCTION CODE (THIS IS HOW IT IS DONE)

# --- STEP 1: DEFINE LANGCHAIN PRIMITIVES (Ingredients) ---

# 1. Define the Prompt (The Template)
from langchain_core.prompts import ChatPromptTemplate

prompt = ChatPromptTemplate.from_messages([
    ("system", "You are a helpful assistant. Use tools when needed."),
    ("user", "{input}"), 
])

# 2. Define the Model (The Brain)
from langchain_openai import ChatOpenAI
llm = ChatOpenAI(model="gpt-4o")

# --- STEP 2: DEFINE LANGGRAPH STATE (The Container) ---
from typing import TypedDict, Annotated
from langgraph.graph.message import add_messages

class AgentState(TypedDict):
    messages: Annotated[list, add_messages]

# --- STEP 3: DEFINE NODES (The Workers) ---
def chatbot(state: AgentState):
    # HERE is where you use the prompt!
    # You format the state messages into the prompt template
    chain = prompt | llm.bind_tools(tools)
    return {"messages": [chain.invoke(state["messages"])]}
```


## **1. The AI Primitives: Building with LangChain**

In a modern architecture, LangChain is no longer used for the logic of the "loop," but it remains the essential library for the "bricks" of your system.

### **Core Data Engineering (The Indexing Pipeline)**

- **Document Loaders**: Use `TextLoader`, `PyPDFLoader`, or `WebBaseLoader` for the "Load" step of RAG.
    
- **Text Splitters**: Utilize `RecursiveCharacterTextSplitter` to break documents into semantically meaningful chunks (e.g., 1000 characters with 0 overlap).
    
- **Embeddings**: Local MLOps setups should prioritize local models like `nomic-embed-text` via Ollama to maintain data privacy.
    
- **Vector Stores**: Use `Chroma` or `Weaviate` to store and perform similarity searches on embedded data.
    

### **The Model Interface**

- **Prompt Templates**: Transition from static strings to `ChatPromptTemplate` for better instruction following.
    
- **Output Parsers**: Use `JsonOutputParser` or `StrOutputParser` to transform raw model text into structured data for your application.
    
- **Tool Binding**: The primitive for agents is `.bind_tools()`, which attaches function definitions (JSON Schema) directly to the model.
    

---

## **2. The Cognitive Architecture: Building with LangGraph**

LangGraph is the **orchestration engine** that allows for loops, persistence, and stateful memory that legacy LangChain (Gen 1) lacks.

### **The Fundamental Pillars**

- **State (`TypedDict`)**: The shared "Whiteboard." It is a globally accessible object that nodes read from and update. Use `Annotated[list, add_messages]` to ensure conversation history is appended rather than overwritten.
    
- **Nodes (Functions)**: The workers. Each node is a standard Python function that takes the `State` as input and returns a dictionary of updates.
    
- **Edges (Routing)**:
    
    - **Static Edges**: A direct path from Node A to Node B.
        
    - **Conditional Edges**: Logic-based routing (e.g., if a tool is called, go to the `ToolNode`; otherwise, go to `END`).
        

### **Advanced Agentic Features (MLOps/AgentOps)**

- **Persistence (Checkpointers)**: Unlike legacy memory, LangGraph can save the state to a database (e.g., `SqliteSaver`). This enables "Time Travel" debugging and multi-session persistence.
    
- **Human-in-the-Loop (HITL)**: Use `interrupt_before` to pause the graph execution, allowing for human approval of tool calls (e.g., approving a scientific solver execution).
    
- **Multi-Agent Systems**: Designing separate graphs for "Researchers" and "Writers" that communicate via shared state updates.

|**Legacy Pattern (LangChain Gen 1)**|**Modern Pattern (LangGraph)**|**Why It Matters**|
|---|---|---|
|`AgentExecutor`|`StateGraph.compile()`|Transparency: You own and can debug the loop logic.|
|`ConversationBufferMemory`|`AgentState` Reducers|DataOps: Memory is part of the global state, making it inspectable and persistent.|
|`RetrievalQA`|RAG Tool in a Graph|Control: The agent can decide _when_ and _how many times_ to query the RAG tool.|
|Linear `SequentialChain`|Cyclic Graphs|Flexibility: Real-world tasks (like protein-ligand binding analysis) require iterative refinement, not just a straight line55.|

## **4. Strategic Implementation Goal**

Your primary focus is to operationalize an **Enterprise GraphRAG & Agentic GenAI Platform**. This combines:

1. **LangChain** for layout-aware PDF parsing, OCR, and semantic chunking.
    
2. **LangGraph** for structured graph reasoning and multi-step agent orchestration.
    
3. **Ray AIR** or **KServe** for distributed execution and low-latency serving of these agentic microservices

---
### Chat Models

|**Feature**|**Legacy "LLM" (Deprecated for Agents)**|**Modern "Chat Model" (Mandatory)**|
|---|---|---|
|**Input**|A single string: `"User: Hi\nAI:"`|A list of Objects: `[SystemMessage(...), HumanMessage(...)]`|
|**Structure**|Unstructured Text. Hard to parse.|Structured Messages. Easy to parse roles (User vs. System).|
|**Tool Use**|**Impossible/Hackable.** You had to paste tools as text strings into the prompt.|**Native.** The model accepts a `tools=` parameter and outputs a `ToolCall` object, not just text.|
|**Role**|Just a text generator.|The "Brain" that reasons and issues commands.|

---




