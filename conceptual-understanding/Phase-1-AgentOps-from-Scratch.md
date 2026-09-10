---
tags:
  - agentops
  - agentic-ai-methodologies
  - agentops_from_scratch
  - gemini_insights
---

---
```table-of-contents
```
---
### References

- [[Conceptual-Axiom-AgentOps-Graphs]]
- [[Conceptual-Production-Grade-Methodology-Tools-AgentOps]]
- [[Conceptual-Agent-Architectures-Evolution-Latest-and-Mathematics]]
- [[Pydantic-for-AgentOps-LLMOps]]
- [[Neo4j-LangGraph-The-Comparison]]
- [📂 Open: AgentOps-from-Scratch](<file:///home/az/03-Curriculum-Continuum/05-Language-and-Agentic-Systems/AgentOps-from-Scratch>)
- [📂 Open: Phase-1](<file:///home/az/03-Curriculum-Continuum/05-Language-and-Agentic-Systems/AgentOps-from-Scratch/Phase-1>)
- [practice.ipynb](<file:///home/az/03-Curriculum-Continuum/05-Language-and-Agentic-Systems/AgentOps-from-Scratch/Phase-1/practice.ipynb>)
---
### 1. Phase 1: The Core

* **Layer 1: Foundation Model** ➝ Inference: Local/API
* **Layer 2: Prompt & Instruction** ➝ Schema Validators, Pydantic
* **Layer 7: Tool & Action** ➝ Typed Interfaces, Execution

| **Layer** | **Name**                       | **Purpose**                 | **Key Responsibilities**                              | **Typical Components / Examples**          | **Failure Modes if Missing**                    |
| --------- | ------------------------------ | --------------------------- | ----------------------------------------------------- | ------------------------------------------ | ----------------------------------------------- |
| **1**     | **Foundation Model Layer**     | Core intelligence substrate | Inference, reasoning, tool-call generation, embedding | GPT-4.x, Claude, LLaMA, Mixtral, vLLM, TGI | Hallucinations, poor reasoning, brittle outputs |
| **2**     | **Prompt & Instruction Layer** | Behavioral conditioning     | System prompts, role constraints, task framing        | Prompt templates, schemas, guardrails      | Inconsistent agent behavior                     |
| **7**     | **Tool & Action Layer**        | World interaction           | Safe execution of external actions                    | APIs, DBs, browsers, code exec             | Agents can’t act                                |

>[!example] **The Architectural Pattern** 
> - **Neo4j | LangGraph:** Acts as the Global Orchestrator (The Map) 
> - **Pydantic Agent:** Acts as the Local Intelligence (The Decision Maker) inside a specific node of that map

---
### 2. Blueprint for the Phase 1 

> **Just follow these steps**

```python
#-------------------------------------------------------------------------------------------------------------------# 
# 1. define the reality: this is the hand of the agent: THE REALITY (The Hand): The Action
#    This is the actual Python function that touches the world (Database/API/System).
#    The LLM never sees this code. It only sees the "Bridge": the JSON schema: the tool definition
#
# 2. define THE CONTRACT (The Guard): Pydantic
#    define the contract
#    this tells the LLMs: how it will receive the input data + how it should give the ouput data 
#    This tells the LLM strict rules: "If you want to use the Hand, you MUST provide these inputs."
#    It prevents the Brain from hallucinating invalid arguments.
#
# 3. THE BRIDGE (The Translation): JSON Schema
#    this is how the data from the tools is converted to a format that the LLM understands 
#    the structural output of the tool(s) is defined here: this is the bridge 
#    use the OpenAI function calling format here 
#    the LLM reads THIS, not the python function
#    This converts the Pydantic Contract into the "OpenAI Function Calling Format"
#    It is the only description of the tool the LLM actually read
#
# 4.  define the brain: the actual LLM: the thinking 
#    THE BRAIN (The Loop): The Manager
#    this part is the manager that manages the talking: the data exchange protocols 
#    we define the actual brain
#
#    This section orchestrates the flow:
#    A. SETUP:   Inject the Schema (Bridge) + System Prompt.
#    we define how the conversation should be structured: define the schema_snippet 
#
#    B. PAYLOAD: Define Model + Messages + Options (Temperature 0 for determinism)
#    we define the payload: model + messages (roles + content for the role describing the role) + format + options (temperature)
#
#    C. WIRE:    Use `requests` to hit localhost:11434 (The actual talk)
#    we also define how it should call the local host: so that the LLM + agent can communicate: communication bridge 
#
#    D. THOUGHT: Extract the JSON decision from the LLM's response
#    we extract the thoughts of the LLM: we get the response from : messages + content 
#
#    E. ACTION:  Pass the Validated Thoughts (from Pydantic) to The Reality (The Hand)
#    then we extract the results: from the hand we defined 
#-------------------------------------------------------------------------------------------------------------------#
```

---
### 3. The Basics

#### I. What exactly is an Agent? 

##### The Reality
- An Agent is just **a loop**
##### The Goal
- It tries to answer a question by _doing_ something, not just _knowing_ something.

##### The Components
###### The Brain (LLM)
- It has general knowledge but can't "do" anything. 
- It can't check the weather, query a database, or see your files. 
- It is locked in a box.        
###### The Hands (Tools)
- Simple Python functions 
- `get_weather()`
- `query_database()`
###### The Loop
- the process where the Brain decides to use the Hands (Tools)

#### II. The Talking: Who talks to whom?

##### I. The Reality 

- The **Talking** ➝ is not just a conversation
- It is a **Data Exchange Protocol**
- It happens in a loop between three entities:
	1. **The User (You)** ➝  You give the goal.
	2. **The System (Your Python Script)** ➝  You control the environment
	3. **The Model (The LLM)** ➝ The decision maker
    
##### II. The Dialogue: Step-by-Step

###### Step 1: The Setup: You ➝ Model
- **You say:** "Here is the user's question: 'What is the CPU usage on Phoenix?'"
- **AND (Crucial Step)** 
	- "Here is a list of tools you can use. Tool A is `get_system_metrics`. It takes a `server_name` (string) and a `metric_type` (string)"
- **Note**  ➝ You don't send the code ➝ You send the **definition (Schema)**

>- **Payload**: User Query + Tool Definitions (JSON Schemas)
>- We do not send the code ➝ We send the **blueprint** of the code
        
###### Step 2: The Decision:  Model ➝  System
- **The Model thinks** 
	- "I cannot answer this from my training data. But I see a tool called `get_system_metrics`. The user mentioned 'Phoenix' and 'CPU'"
- **The Model talks back** 
	- It does **NOT** speak English here. 
	    - It outputs a structured command (JSON)
	    - `{ "tool_call": "get_system_metrics", "arguments": { "server_name": "Phoenix", "metric_type": "cpu" } }`

>- **Action:** The Model "pauses" generation. 
>- **Payload:** A Structured Command (JSON) 
>- **Example:** `{"tool": "get_weather", "args": {"city": "Karachi"}}`

###### Step 3: The Execution: System ➝  Tools
- **Your Python Script** 
		    - Sees the JSON. 
		    - It pauses the LLM. 
		    - It runs your actual Python function `get_system_metrics("Phoenix", "cpu")`
- **The Tool** 
	- Returns `"12%"`

>- **Action:** The Runtime executes the Python function using the arguments from Step 2
>- **Payload:** The raw return value (e.g., `"22C"`).

- ###### Step 4: The Observation: System ➝ Model
	    - **You say** 
		    - "Okay, I ran that tool. The result was '12%'. Now, finish your answer"
        
	- ###### Step 5: The Final Answer (Model -> User)
	    - **The Model says** 
		    - "The CPU usage on Phoenix is 12%."

>**Action:** The Runtime feeds the result back to the Model 
>**Prompt**: "The tool returned '22C'. Now answer the user"

#### III. Pydantic: Why do we need it?

> **This is the bridge**

- ##### The Problem: 
	- The LLM is a text generator ➝  It is fuzzy
        - Ask for a number ➝ It might give five
        - Ask for a JSON object ➝  It might give a sentence _about_ JSON
        - Ask for a specific server name "phoenix" ➝  It might say "the phoenix server"

>  LLMs are probabilistic. They **guess** inputs. A guess of `{"age": "twenty"}` will crash a function expecting `int` (type mismatch: `int` vs `string`)
        
- ##### The Solution: Pydantic
    - **It defines the "Shape"** 
	 - It creates the strict blueprint (Schema) that we send in Step 1
	 - It translates Python logic into the JSON format the LLM understands
    - **It guards the "Input"**
	    - When the LLM sends back that JSON command in Step 2 ➝ Pydantic grabs it and checks it against the blueprint
	        - _Did the LLM send a string for CPU usage?_ **CRASH** ➝  Pydantic stops it
                - _Did the LLM send a valid server name?_ **PASS** ➝ Pydantic allows it

>- **Problem:** LLMs are probabilistic
>- They **guess** inputs
>- A guess of `{"age": "twenty"}` ➝ will crash a function expecting `int`
>

>- **Solution:** Pydantic acts as the **Strict Type Gateway**
>- **Role 1 (Translator)** 
>	- Converts Python Classes ➝  OpenAI JSON Schema (for the Setup)
> - **Role 2 (Bouncer)**
> 	- Validates LLM Output ➝  Python Objects (before Execution)
>- **If validation fails** 
>	- The Agent self-corrects or errors safely
>- **If validation passes** 
>	- The "Hand" (Function) is allowed to move

> [!example] **Agent + Tools + Pydantic** 
> - **The Agent** is the loop that allows the LLM to ask for help
> - **The Tools** are the help
> -  **Pydantic** is the translator that ensures the LLM asks for help correctly (so your code doesn't explode)

#### IV. Installations 

```bash
#------------------------------------------------#
# go inside the folder directory with the terminal
#------------------------------------------------#
uv init 
uv add pydantic requests python-dotenv

#-----------------------#
# check available models
#-----------------------#
ollama list

#---------------------------------------------------------#
# if missing a dedicated tool-calling model ➝ pull Mistral
#---------------------------------------------------------#
ollama pull mistral:7b-instruct 

```

```shell
az@phoenix:~$ ollama list
NAME                       ID              SIZE      MODIFIED    
deepseek-r1:latest         6995872bfe4c    5.2 GB    3 weeks ago    
deepseek-v2:latest         7c8c332f2df7    8.9 GB    3 weeks ago    
llama3.1:latest            46e0c10c039e    4.9 GB    3 weeks ago    
nomic-embed-text:latest    0a109f422b47    274 MB    3 weeks ago    
qwen2.5:latest             845dbda0ea48    4.7 GB    3 weeks ago   
```

##### Register the Environment: Using VSCode: Jupyter Kernel

```bash
uv run python -m ipykernel install --user --name="Ali-Zahid" --display-name "Python (uv-agentops-I)"
```

```bash
az@yoga:~/03-Curriculum-Continuum/05-Language-and-Agentic-Systems/AgentOps-from-Scratch/Phase-1$ uv run python -m ipykernel install --user --name="Ali-Zahid" --display-name "Python (uv-agentops-I)"

Installed kernelspec agentops-from-scratch-phase-1 in /home/az/.local/share/jupyter/kernels/agentops-from-scratch-phase-1

```

### 4. The Code: agent_zero.py

> See **Revised Code Section**

`agent_zero.py`

```python
import json
import os
import requests 
from pydantic import BaseModel, Field

# --- 1. The Reality (The actual Python function) ---
# This is the "hand" of the agent. It actually DOES something.

def get_system_metrics(server_name: str, metric_type: str = "cpu") -> dict:
    """
    Fetches real-time metrics for a specific server.
    """
    # Simulating a database lookup
    mock_db = {
        "phoenix": {"cpu": "12%", "memory": "8GB", "temp": "45C"},
        "yoga": {"cpu": "5%", "memory": "6.2GB", "temp": "50C"}
    }
    server_data = mock_db.get(server_name.lower())
    
    if not server_data:
        return {"error": f"Server '{server_name}' not found."}
    
    return {
        "server": server_name, 
        "metric": metric_type, 
        "value": server_data.get(metric_type, "N/A")
    }

# --- 2. The Contract (Pydantic) ---
# CRITICAL: This class is NOT for you. It is for the LLM. 
# It tells the LLM exactly what inputs are valid.

class SystemMetricsSchema(BaseModel):
    server_name: str = Field(..., description="The hostname of the server (e.g., 'phoenix', 'yoga').")
    metric_type: str = Field(
        "cpu", 
        description="The specific metric to query.", 
        pattern="^(cpu|memory|temp)$" # Regex constraint! The LLM MUST obey this.
    )

# --- 3. The Bridge (Tool Definition) ---
# We convert the Pydantic class into the JSON Schema the LLM understands.
tool_definition = {
    "type": "function",
    "function": {
        "name": "get_system_metrics",
        "description": "Get CPU, Memory, or Temp metrics for a specific server.",
        "parameters": SystemMetricsSchema.model_json_schema()
    }
}

# --- 4. The Brain (Simulation) ---
def run_local_agent(user_query: str):
    print(f"\nUser: {user_query}")
    print("--- AGENT THINKING (Local Llama 3) ---")

    # 1. The Payload (OpenAI Format - Ollama supports this!)
    payload = {
        "model": "llama3.1:latest",
        "messages": [{"role": "user", "content": user_query}],
        "format": "json",  # Force JSON mode
        "stream": False,
        # WE INJECT THE SCHEMA HERE as a System Prompt for local models
        "system": f"""
        You are a function calling agent. 
        You have access to the following tool:
        {json.dumps(tool_definition, indent=2)}
        
        If the user asks for metrics, output ONLY a JSON object matching the tool parameters.
        Do not write explanations.
        """
    }

    # 2. The Call (Hitting localhost:11434)
    try:
        response = requests.post("http://localhost:11434/api/chat", json=payload)
        response_json = response.json()
        
        # 3. Extracting the "Thought"
        llm_content = response_json['message']['content']
        print(f"Raw LLM Output: {llm_content}")

        # 4. The Guard (Pydantic Validation) - SAME AS BEFORE
        # This is where we catch Llama 3 if it messes up the JSON
        args = SystemMetricsSchema.model_validate_json(llm_content)
        
        # 5. The Execution - SAME AS BEFORE
        result = get_system_metrics(args.server_name, args.metric_type)
        print(f"Tool Output: {result}")

    except Exception as e:
        print(f"Local Agent Failed: {e}")

if __name__ == "__main__":
    # Ensure Ollama is running (`ollama serve` in another terminal)
    run_local_agent("Check the cpu load on Phoenix")
```

> 1. **The Format Mode**
> 	-  `"format": "json"`
> 	- Local models are wilder than GPT-4 ➝ this flag forces them to speak JSON. 
> 2. **The System Prompt** 
> 	- For local models, we often have to paste the `tool_definition` directly into the system prompt (as shown above) because their **native tool binding** APIs are sometimes unstable
   
> **Verdict** 
> The **Logic** (Pydantic ➝  Function) is 100% portable
> The **Wiring** (HTTP Request) just points to `localhost:11434` instead of `api.openai.com`

`import requests` ➝ acts as the **communication wire** between your Python script and the LLM.
- In the **Brain-Hand-Loop** model, the **Brain** (Ollama) is a separate process running on Phoenix. 
- The Python script is the **Manager**. 
- To send the user's question to the Brain and get a JSON decision back ➝ the Manager must send a message over the internal network
- The **`requests.post()`** command is the specific tool that:
	- **Packages** the prompt and tool definitions into a digital envelope
	- **Sends** it to the Ollama server at `http://localhost:11434`
	- **Waits** for the LLM to finish thinking and brings the response back into the script
- Without this library, the script has **no way to talk** to the local model. 
- It would be like having a telephone but no copper wires connecting it to the grid

---
### 5. Code Explanations: What exactly is happening 

>[!example] **Pydantic $\rightarrow$ JSON $\rightarrow$ Function**

#### Using Native Python: No framework abstraction

- ##### The Black Box Problem 
	- Frameworks like LangChain ➝ wrap this exact logic ➝ in layers of abstraction (classes like `AgentExecutor` or `bind_tools`)
	- When it breaks ➝ you **don't know** if it's the **Prompt**, the **Schema**, or the **Framework**
- ##### The Principal Reality 
	- By writing this in native Python (`requests`, `json`, `pydantic`) ➝  we are seeing the **raw wire protocol**
	- We are seeing exactly ➝ what gets **sent to the Model** ➝ and **exactly what comes back**
    
> **The Epiphany** 
- When we eventually use LangGraph (**Layer 8** in the [[Curriculum-The-Roadmap-AgentOps-from-Scratch]])
	- realization ➝ _"Oh, this isn't magic. It's just a loop that manages the Pydantic validation I wrote back in Module 0."_

#### Block 1: The Muscle: The Reality

```python
import json
import os
from pydantic import BaseModel, Field
# --- 1. The Reality (The actual Python function) ---
# This is the "hand" of the agent. It actually DOES something.

def get_system_metrics(server_name: str, metric_type: str = "cpu") -> dict:
    """
    Fetches real-time metrics for a specific server.
    """
    # Simulating a database lookup
    mock_db = {
        "phoenix": {"cpu": "12%", "memory": "8GB", "temp": "45C"},
        "yoga": {"cpu": "5%", "memory": "6.2GB", "temp": "50C"}
    }
    server_data = mock_db.get(server_name.lower())
    
    if not server_data:
        return {"error": f"Server '{server_name}' not found."}
    
    return {
        "server": server_name, 
        "metric": metric_type, 
        "value": server_data.get(metric_type, "N/A")
    }
```

> In the **Brain-Hand-Loop** mental model ➝ this is the **Hand**
> It is the only part of the system that touches **reality** (data)

##### 0. Explanations I used to build my model: During Coding 

```python
import requests
from pydantic import BaseModel
from pydantic import Field

# defining the hands, the actual action the agent will take
# the actual action is to get the system metrics ➝ define a function for it
# the function variables: server_name (type-hint) + metric_type (type-hint) and how what should be the type of the data output (type-hint)
# we are defining a mock database from where the agent will get the data
# remember ➝ everything must be provided as a string ➝ its a LLM ➝ it only understands text / strings
# dictionaries are perfect to provide data ➝ the key:value pair approach

def get_system_metrics(server_name: str, metric_type: str = 'cpu') -> dict:

# define a mock databse
mock_db = {
'phoenix': {'cpu': '12%', 'memory': '8gb', 'temp': '45C'},
"yoga": {"cpu": "5%", "memory": "6.2GB", "temp": "50C"}
}

# now the action itself
server_data = mock_db.get(server_name.lower())

# the code ends here: the logic is complete
# but we are dealing with a stupid child (agent): we have to provide it with context of what to do if it cannot find the server name
# so we have to provide the returns for both: its found the server + it has not find the server
if not server_data:
return {"error": f"Server '{server_name}' not found."}
return {"server": server_name, "metric": metric_type, "value": server_data.get(metric_type, "N/A")}
```

##### I. The Signature: The Interface

```python
def get_system_metrics(server_name: str, metric_type: str = "cpu") -> dict:
```

> - **The `str` types**
> 	- These match the `Pydantic` schema ➝ defined later
> - **The `-> dict` return** 
> 	- This is **critical**
> 	- Agents speak ➝ **JSON**
> 	- By returning a Python dictionary ➝ we make it trivial to convert the result back into text (JSON) ➝ so the LLM can **read** what happened

##### 2. The Simulation: The World

```python
    # Simulating a database lookup
    mock_db = {
        "phoenix": {"cpu": "12%", "memory": "8GB", "temp": "45C"},
        "yoga": {"cpu": "5%", "memory": "6.2GB", "temp": "50C"}
    }
```

> - **What is this?** ➝ this represents the **state of the world**
> - **In Production** ➝ would replace this dictionary with a **real library call** ➝ like `psutil.cpu_percent()` or a **SQL query** ➝ `SELECT * FROM metrics`
> - **Why Mock it?** ➝ for **AgentOps development** ➝ want **Determinism**
> 	- Want to know _exactly_ what the data is ➝ so it is possible to test if the Agent reads it correctly
> 	- If we used real live CPU data ➝ it would change every second, making debugging a nightmare     

##### 3. The Logic: The Work

```python
    server_data = mock_db.get(server_name.lower())
    
    if not server_data:
        return {"error": f"Server '{server_name}' not found."}
```

> - **Normalization** ➝ `.lower()` ➝ handles the messiness of users ➝ if you type "Phoenix" or "PHOENIX" ➝ this cleans it up
> - **Graceful Failure** ➝ this is a **Principal-Level Pattern**
>    - **Bad approach**: Raising an exception (`raise ValueError(...)`) which might crash your agent loop
>    - **Agentic approach**: Returning an `error` dictionary
>	- This allows the Agent (Brain) to **see the error as "data"** and say to the user: "**I checked, but I couldn't find a server named 'mars'"**

##### 4. The Return Payload: The Observation

```python
    return {
        "server": server_name, 
        "metric": metric_type, 
        "value": server_data.get(metric_type, "N/A")
    }
```

> - **Contextual Return** ➝ We don't just return `"12%"` ➝ We return _context_: `"server": "phoenix", "value": "12%"`
> - **Why?** ➝ LLMs have short attention spans
> 		- If you just give it "12%" ➝ it might forget _which_ server asked about
> 		- By **repeating the context** ("server": "phoenix") ➝  **you ground the Agent in reality**

    
> Insight ➝ **Treat the agent as Child!** Consider it requires consistent reminding of the tasks ➝  either directly (**type-hinting**) or covertly (by **context repetition**)


> **Summary** 
> - This function is a standard Python tool, but it is "**Agent-Ready** because:
> 	1. It accepts simple types (strings)
> 	2. It returns structured data (dicts)
> 	3. It handles errors by reporting them, not crashing

#### Block 2: The Pydantic Contract: The Critical Part of Agentic AI

```python
from pydantic import BaseModel, Field
# --- 2. The Contract (Pydantic) ---
# CRITICAL: This class is NOT for you. It is for the LLM. 
# It tells the LLM exactly what inputs are valid.

class SystemMetricsSchema(BaseModel):
    server_name: str = Field(..., description="The hostname of the server (e.g., 'phoenix', 'yoga').")
    metric_type: str = Field(
        "cpu", 
        description="The specific metric to query.", 
        pattern="^(cpu|memory|temp)$" # Regex constraint! The LLM MUST obey this.
    )
```

##### 1. The Pydantic BaseModel

- `pydantic.BaseModel`
- **Theory** 
	- Python is **dynamically typed** (loose)
	- If you pass a number to a function expecting a string ➝ Python often crashes _inside_ the function
   - **Agent Reality** 
	   - LLMs are **probabilistic text generators** 
	   - They don't know types ➝ They just guess
    -  **The Scalpel** 
	    - `BaseModel` ➝ forces the LLM's guess into a rigid structure
	    - If the LLM guesses wrong (e.g., sends `["cpu"]` list instead of `"cpu"` string) ➝ Pydantic catches it _before_ it hits your delicate function
    
##### 2.  The Pydantic Field

- `Field(..., description="...")`
- **The "..."**
	- This means **Required**
	- The LLM _must_ provide this 
	- If it doesn't, the agent throws an error asking for it
-  `description` ➝ this is **Prompt Engineering hidden in code**
    - The LLM actually _reads_ this string
    - If you write `description="The server"` ➝ the LLM might guess
    - If you write `description="The hostname (e.g., 'phoenix')"` ➝ you are **prompting** the LLM inside the type definition ➝ **This is how you control the Agent**
	    - in essence ➝ **context repetition** 

> [!quote] **The Pydantic Field**
>- `Field(...)` is a Pydantic function that lets you attach **metadata** (like descriptions) + **validation rules** (like regex patterns or number limits) to a variable
> - Think of it as a **"Mini-Prompt" embedded in your code**
> 	- the LLM reads the `description` inside `Field` to understand what to put there
> 	- Pydantic uses the validation rules to reject any hallucinations that don't match

##### 3. The Pattern

- `pattern="^(cpu|memory|temp)$"`
- **The Guardrail** 
	- This is a Regex (Regular Expression)
- **Why?** 
	- The LLM might hallucinate and say `metric_type="gpu_fan_speed"`
- **The Catch** 
	- Pydantic checks this regex
	- If the LLM's output doesn't match `cpu`, `memory`, or `temp`, Pydantic rejects it
	- **You just prevented a hallucination with one line of code**

##### 4. The Custom Class Defintion: SystemMetricsSchema

```python
class SystemMetricsSchema(BaseModel)
```

> Custom definition is necessary
- **The Blueprint**
	- The LLM does not see your Python code 
	- It only sees the **JSON Schema** generated by this class 
	- By defining it ourselves ➝ we decide exactly what information the LLM is allowed to request
- **The Guardrail** 
	- If we used a generic class ➝ the LLM might try to ask for **disk_space** or **fan_speed**
	- Because we strictly defined `metric_type` with a specific pattern ➝ we effectively **hardcoded the boundaries** of the Agent's world
- **Layer 2 & 7 Alignment** 
	- In [[Conceptual-Production-Grade-Methodology-Tools-AgentOps]]
	- this custom class ➝ fulfills **Layer 2** (Schema Validators) & **Layer 7** (Typed Tool Interfaces)
	- tt ensures that the **Action** is safe and predictable

##### 5. Descriptions Injection in the Field function: Interface Logic

- When we see `Field(..., description="...")` in that class ➝ we are looking at the **interface logic**
	1. **We** wrote the description for **a human/LLM to read**
	2. **Pydantic** package took that description and put it into a **JSON file**
	3.  **The LLM** ➝ **read that JSON** file ➝ to understand how to use our function
- By defining this ourselves ➝ we are acting as the **Architects** ➝ who **design how the system talks to itself**

#### Block 3: The Bridge: Tool Definition: JSON Schema

```python
# --- 3. The Bridge (Tool Definition) ---
# We convert the Pydantic class into the JSON Schema the LLM understands.
tool_definition = {
    "type": "function",
    "function": {
        "name": "get_system_metrics",
        "description": "Get CPU, Memory, or Temp metrics for a specific server.",
        "parameters": SystemMetricsSchema.model_json_schema()
    }
}
```

##### The OpenAI Function Calling Format 

- LLMs (OpenAI, Llama 3, Mistral) are trained ➝ to **read** a **specific JSON format** ➝ **OpenAI Function Calling format**
- `SystemMetricsSchema.model_json_schema()`
	- This command automatically translates your Python class ➝ into that exact JSON format the LLM expects

> **We don't write the JSON manually** ➝ We write Python, and Pydantic translates it for the **Alien Intelligence**

>[`BaseModel.model_json_schema`](https://docs.pydantic.dev/latest/api/base_model/#pydantic.BaseModel.model_json_schema) returns a jsonable dict of a model's schema

##### Pydantic: Website 

> [!note] **The Official Website:** [docs.pydantic.dev](https://docs.pydantic.dev/latest/)
> We only care about three specific sections right now
> 1. **Concepts ➝ Models** 
> 	-  This is the bread and butter
> 	- It explains `BaseModel` ➝ which is the parent class of every schema
> 	- [Models - Pydantic Validation](https://docs.pydantic.dev/latest/concepts/models/#model-methods-and-properties)
> 2. **Concepts ➝  Field:** 
> 	- This explains `Field(...)`
> 	- This is where we find the **validator constraints** (like `gt=0` for positive integers or `pattern="..."` for regex) ➝ that prevent the LLM from hallucinating
> 	- [Fields - Pydantic Validation](https://docs.pydantic.dev/latest/concepts/fields/)
> 3. **Concepts ➝ JSON Schema** 
> 	- This explains the `model_json_schema()`
> 	- It shows **how Pydantic translates Python** ➝ to the **Language of LLMs**
> 	- [JSON Schema - Pydantic Validation](https://docs.pydantic.dev/latest/concepts/json_schema/)
>     
> > **Pro Tip:** **We are strictly using V2** ➝ Pydantic **V2** is written in **Rust** ➝ is significantly faster + more strict ➝ which is critical for high-throughput AgentOps

>[!example] **The Architectural Pattern** 
> - **LangGraph:** Acts as the Global Orchestrator (The Map)
> - **Pydantic Agent:** Acts as the Local Intelligence (The Decision Maker) inside a specific node of that map.

#### Block 4: Coordination Manager: Connective Tissue

```python
# --- 4. The Brain (Simulation) ---
def run_local_agent(user_query: str):
    print(f"\nUser: {user_query}")
    print("--- AGENT THINKING (Local Llama 3) ---")

    # 1. The Payload (OpenAI Format - Ollama supports this!)
    payload = {
        "model": "llama3.1:latest",
        "messages": [{"role": "user", "content": user_query}],
        "format": "json",  # Force JSON mode
        "stream": False,
        # WE INJECT THE SCHEMA HERE as a System Prompt for local models
        "system": f"""
        You are a function calling agent. 
        You have access to the following tool:
        {json.dumps(tool_definition, indent=2)}
        
        If the user asks for metrics, output ONLY a JSON object matching the tool parameters.
        Do not write explanations.
        """
    }

	# 2. The Call (Hitting localhost:11434)
    try:
        response = requests.post("http://localhost:11434/api/chat", json=payload)
        response_json = response.json()
        
    # 3. Extracting the "Thought"
        llm_content = response_json['message']['content']
        print(f"Raw LLM Output: {llm_content}")

    # 4. The Guard (Pydantic Validation) - SAME AS BEFORE
        # This is where we catch Llama 3 if it messes up the JSON
        args = SystemMetricsSchema.model_validate_json(llm_content)
        
    # 5. The Execution - SAME AS BEFORE
        result = get_system_metrics(args.server_name, args.metric_type)
        print(f"Tool Output: {result}")

    except Exception as e:
        print(f"Local Agent Failed: {e}")

if __name__ == "__main__":
    # Ensure Ollama is running (`ollama serve` in another terminal)
    run_local_agent("Check the cpu load on Phoenix")
```

> This code is specifically designed to talk to a **Local LLM** (like Llama 3) via **Ollama**. 
> In the **Brain-Hand-Loop** model ➝ this script is the **Manager** that coordinates the exchange

##### 1. The Payload: The Setup

```python
    payload = {
        "model": "llama3.1:latest",
        "messages": [{"role": "user", "content": user_query}],
        "format": "json",
        "system": f"You are a function calling agent... {json.dumps(tool_definition)}"
    }
```

- `"format": "json"` 
	- This is a strict instruction to Ollama. 
	- It tells the model: "Don't talk to me in English; only generate valid JSON."
- **The System Prompt** 
	- This is the most critical part. 
	- Because local models don't always have a native "tool" button ➝ we **inject** the tool's blueprint (the JSON schema we made with Pydantic) directly into the model's instructions
- **The Blueprint**
	- We use `json.dumps(tool_definition)` to turn our Python object into a string so the LLM can "read" its constraints.
    
##### 2. The Call: The Talk

```python
response = requests.post("http://localhost:11434/api/chat", json=payload)
```

> - **What is this?**
> 	- This is a standard HTTP request to the **Ollama server** running on the Phoenix machine (usually port 11434)
> - **No Frameworks**
> 	- Notice we aren't using a special library
> 	- We are just sending data over the network ➝ exactly to debug a microservice
   
##### 3. Extracting the Thought

```python
llm_content = response_json['message']['content']
```

> - **The Result** 
> 	- The LLM responds with a JSON string
> 	- `{"server_name": "Phoenix", "metric_type": "cpu"}`
> - **The Raw Data** 
> 	- At this point, `llm_content` is just **text**
> 	- It has no power yet`
    
##### 4. The Guard (Validation)

```python
args = SystemMetricsSchema.model_validate_json(llm_content)
```

- **The Bouncer**
	- This is the **Layer 2** "Schema Validator" ➝ [[Curriculum-The-Roadmap-AgentOps-from-Scratch]] ➝ [[Conceptual-Production-Grade-Methodology-Tools-AgentOps]]    
- **What happens here?**
	- Pydantic takes that raw text from the LLM ➝ tries to fit it into our `SystemMetricsSchema`
	- If the LLM hallucinated (e.g., `{"server": "Mars"}`) ➝ Pydantic throws an error **immediately**
	- If it matches ➝ it creates a **Clean Python Object** ➝ called `args`
        
##### 5. The Execution (The Action)

```python
result = get_system_metrics(args.server_name, args.metric_type)
```

> - **The Hand Moves**
> 	- Now that we have **validated data** (`args`) ➝ we finally call our actual Python function (the Hand)
> - **Safety**
> 	- Because of the "**Guard**" step above ➝ we know `args.server_name` is a valid string ➝ and `args.metric_type` is one of our allowed values

>- This loop is **Stateless**
>- Every time you run it ➝ the LLM "**forgets**" the previous turn
>- In later modules (LangGraph) ➝ we will learn how to make this loop **Stateful** so it remembers what you said 5 minutes ago

---
### 6. The Model Run 

```bash
uv run agent_zero.py
```

#### I. Results: Model requires Tweaking

```bash
az@phoenix:~/03-Curriculum-Continuum/04-Ops-and-Infrastructure/AgentOps-from-Scratch/Phase-1$ uv run agent_zero.py

User: Check the cpu load on Phoenix
--- AGENT THINKING (Local Llama 3) ---
Raw LLM Output: {"status":"OK","data":{"version":"1.0"}}
Local Agent Failed: 1 validation error for SystemMetricsSchema
server_name
  Field required [type=missing, input_value={'status': 'OK', 'data': {'version': '1.0'}}, input_type=dict]
    For further information visit https://errors.pydantic.dev/2.12/v/missing
```

#### II. Interpretation of Results

> The error above is actually a **successful test of the Guard (Pydantic)**

- The llama3.1:latest model hallucinated
- Instead of following the instructions to provide a server name and metric ➝ it coughed up a generic "Status OK" JSON: `{"status":"OK","data":{"version":"1.0"}}`
- **Pydantic caught it** ➝ because that JSON didn't have `server_name` or `metric_type`
- This is exactly what we wanted ➝ **The Hand did not move because the Brain's instruction was garbage**

#### III. The Revised Code: agent_zero.py 

```python
import json
import requests
from pydantic import BaseModel, Field

# --- 1. The Hand (No changes) ---
def get_system_metrics(server_name: str, metric_type: str = "cpu") -> dict:
    mock_db = {
        "phoenix": {"cpu": "12%", "memory": "8GB", "temp": "45C"},
        "yoga": {"cpu": "5%", "memory": "6.2GB", "temp": "50C"}
    }
    server_data = mock_db.get(server_name.lower())
    if not server_data:
        return {"error": f"Server '{server_name}' not found."}
    return {"server": server_name, "metric": metric_type, "value": server_data.get(metric_type, "N/A")}

# --- 2. The Guard (No changes) ---
class SystemMetricsSchema(BaseModel):
    server_name: str = Field(..., description="The hostname (e.g., 'phoenix', 'yoga').")
    metric_type: str = Field("cpu", pattern="^(cpu|memory|temp)$")

# --- 3. The Brain (CALIBRATED) ---
def run_local_agent(user_query: str):
    print(f"\nUser: {user_query}")
    print("--- AGENT THINKING (Calibrated Llama 3.1) ---")

    # We simplify the schema injection to avoid the "Mirroring" error
    schema_snippet = SystemMetricsSchema.model_json_schema()

    payload = {
        "model": "llama3.1:latest",
        "messages": [
            {
                "role": "system", 
                "content": f"""You are a tool-calling assistant. 
                Use this schema: {json.dumps(schema_snippet)}
                Example Output: {{"server_name": "phoenix", "metric_type": "cpu"}}
                Output ONLY the raw JSON. No markdown, no explanations."""
            },
            {"role": "user", "content": user_query}
        ],
        "format": "json",
        "stream": False,
        "options": {
            "temperature": 0  # CRITICAL: Forcing deterministic output
        }
    }
    
	# 2. The Call (Hitting localhost:11434)
    try:
        response = requests.post("http://localhost:11434/api/chat", json=payload)
        response.raise_for_status()
        
    # 3. Extracting the "Thought"
        llm_content = response.json()['message']['content']
        print(f"Raw LLM Output: {llm_content}")

    # 4. The Guard catches hallucinations here
    # This is where we catch Llama 3 if it messes up the JSON
        args = SystemMetricsSchema.model_validate_json(llm_content)
        
    # The Action
        result = get_system_metrics(args.server_name, args.metric_type)
        print(f"Tool Output: {result}")

    except Exception as e:
        print(f"Local Agent Failed: {e}")

if __name__ == "__main__":
    run_local_agent("Check the cpu load on Phoenix")
```

#### IV. Code Revisions: The Exact Changes to the Code

##### I. The Deterministic Anchor: temperature: 0

Inside the `payload` ➝ added `"options": {"temperature": 0}`
- **The Change** 
	- This tells the LLM to stop being creative
- **The Why**
	- By default ➝ LLMs are probabilistic ➝ they like to try different word combinations
	- In AgentOps, we hate that
	- We want **determinism**
	- At temperature 0, the model will always choose the most logical, valid path, which significantly reduces hallucinations
    
##### II. Prompt Simplification: Removing the Wrapper

Changed how the `tool_definition` was presented in the `system` prompt
- **The Change** 
	- Instead of giving the LLM a complex **Function** object with nested keys like `{"type": "function", "function": {...}}`
	- Simplified it to just the raw parameters schema
- **The Why** 
	- Local models (even Llama 3.1) can get confused by metadata
	- When they see the word "**function**" in the prompt ➝  they sometimes try to explain the function rather than just using itself
	- By stripping it down to the raw schema ➝ we made the "**contract**" impossible to misunderstand

##### III. The Few-Shot Example

Added `Example Output: {"server_name": "phoenix", "metric_type": "cpu"}` directly into the system instructions

> - **The Change** 
> 	- Few-Shotting
> - **The Why** 
> 	- LLMs are pattern-matching engines. 
> 	- By showing it one single example of the perfect output ➝ gave it a visual target to hit
   
##### IV. Forcing JSON Only

Tightened the instruction to say: `"Output ONLY the raw JSON. No markdown, no explanations"`

> - **The Change**
> 	- This removes the conversational fluff
> - **The Why** 
> 	- If the LLM says "Sure! Here is the JSON: {...}", your Pydantic validator will crash because "Sure!" is not valid JSON
> 	- We need the output to be "pure" so the Python parser doesn't choke 

---
### 7. Results: Successful Execution

```bash
az@phoenix:~/03-Curriculum-Continuum/04-Ops-and-Infrastructure/AgentOps-from-Scratch/Phase-1$ uv run agent_zero.py

User: Check the cpu load on Phoenix
--- AGENT THINKING (Calibrated Llama 3.1) ---
Raw LLM Output: {"server_name": "phoenix", "metric_type": "cpu"}
Tool Output: {'server': 'phoenix', 'metric': 'cpu', 'value': '12%'}
```
    
| **Component**        | **Status**  | **Role**                                                     |
| -------------------- | ----------- | ------------------------------------------------------------ |
| **User Query**       | ✅ Captured  | "Check the cpu load on Phoenix"                              |
| **Brain (LLM)**      | ✅ Decided   | Generated `{"server_name": "phoenix", "metric_type": "cpu"}` |
| **Guard (Pydantic)** | ✅ Validated | Confirmed the JSON was safe and mapped correctly             |
| **Hand (Function)**  | ✅ Executed  | Returned `12%` from                                          |

---
### 8. End of Learning Phase 1: The First Incision: Complete

> - **The Brain (Llama 3.1)** 
> 	- Successfully calibrated to output strict JSON
> - **The Guard (Pydantic)** 
> 	- Proven to catch hallucinations and enforce a type-safe contract
> - **The Hand (Python)** 
> 	- Executing native code based on LLM decisions
> - **The Infrastructure (uv/Ollama)** 
> 	- A stabilized local environment on **Phoenix**

---
