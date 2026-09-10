---
tags:
  - programming-best-principles
  - programming-paradigms
  - hydra
status: In Progress
priority: Medium
---

------------------
#### References

[[UV-Migration-Conda-Modern-Python-Dependency-Management]]


---

>[!critical] MANTRA
>- **The Adapter** is the **protection** (it shields the code from external changes).
>- **The Factory** is the **flexibility** (it allows to swap tools easily).
>- **Hydra** is the **governance** (it ensures the whole system is organized and traceable).

| **Component**      | **Responsibility**                        | **Analog**         |
| ------------------ | ----------------------------------------- | ------------------ |
| **Config (Hydra)** | Managing settings without touching code.  | The Blueprint      |
| **Factory**        | Deciding which specific tool to create.   | The Contractor     |
| **Adapter**        | Making external libraries "fit" the code. | The Universal Plug |
| **Business Logic** | The actual RAG/AI tasks.                  | The Appliance      |

---

In a production environment, the code should be **Closed for Modification but Open for Extension**.

If the boss comes tomorrow and says, _"Ollama is too slow; we're moving to OpenAI,"_ a junior dev rewrites the script. A Principal Architect just changes a `.env` file because they implemented the **Factory Pattern**.

### The Factory + Adapter Duo

- **The Adapter** is the "Universal Plug" (as we discussed). It makes different brands of tools look and act the same to the code. 
- **The Factory** is the "Warehouse Manager."  don't go into the warehouse to find a tool;  just shout, _"Hey Manager, give me an Embedding tool!"_ The Manager looks at a settings note and hands  either the Ollama version or the OpenAI version.
- **The Benefit:** the "Main Code" never even knows which brand it's using. It just knows it has a tool that works.
    
--
### Technical Implementation

How to restructure the LangChain code to be "Future-Proof."

#### 1. The Common Interface (The Contract)
We define exactly what an Embedding tool must do.

```python
from abc import ABC, abstractmethod

class BaseEmbeddingAdapter(ABC):
    @abstractmethod
    def get_provider(self):
        pass
```

#### 2. The Specific Adapters
We create one for Ollama and one for OpenAI. They both follow the same "Contract."

```python
from langchain_ollama import OllamaEmbeddings
from langchain_openai import OpenAIEmbeddings

class OllamaAdapter(BaseEmbeddingAdapter):
    def __init__(self, model_name):
        self._provider = OllamaEmbeddings(model=model_name)
    def get_provider(self):
        return self._provider

class OpenAIAdapter(BaseEmbeddingAdapter):
    def __init__(self, model_name):
        self._provider = OpenAIEmbeddings(model=model_name)
    def get_provider(self):
        return self._provider
```

#### 3. The Factory (The "Warehouse Manager")
This logic decides which class to instantiate based on a configuration.

```python
class EmbeddingFactory:
    @staticmethod
    def get_embeddings(provider_type, model_name):
        if provider_type == "ollama":
            return OllamaAdapter(model_name)
        elif provider_type == "openai":
            return OpenAIAdapter(model_name)
        else:
            raise ValueError(f"Unknown provider: {provider_type}")
```

### How it looks in the Main Logic

RAG chain becomes cleaner ➝  we can swap the entire backend by changing the `config` dictionary.

```python
# This config usually comes from a YAML file or Environment Variables
config = {
    "embedding_provider": "ollama", # Change this to "openai" and everything still works!
    "model_name": "nomic-embed-text"
}

# 1. The Factory gives  the right tool
adapter = EmbeddingFactory.get_embeddings(
    config["embedding_provider"], 
    config["model_name"]
)

# 2. The rest of the code remains 100% the same
vector_manager = MyVectorStoreAdapter(
    ["harrison worked at kensho", "bears like to eat honey"],
    embedding_provider=adapter
)
retriever = vector_manager.get_retriever()
```


1. **Zero Downtime Refactoring:**  can test a new embedding model just by changing a config string.  don't have to touch a single line of logic code.
2. **Testability:** In MLOps,  want to "Mock" the AI during unit tests so  don't spend money on API calls. With a Factory,  can just swap in a `MockAdapter` that returns dummy data.
3. **Vendor Lock-in Shield:**  are no longer "The LangChain Guy" or "The OpenAI Guy."  are the Architect who owns the interface, and the vendors are just interchangeable plugins.

---
### Using Hydra 

Take  **`Factory Pattern`** and make it truly "Industry Standard" using a tool called **`Hydra`**.

In professional MLOps, we never "hard-code" configurations (like model names or provider types) inside the Python script. We keep them in separate files so that DevOps engineers or automated pipelines can change them without ever touching the code.

- **`What`:** Think of the code as a high-tech kitchen. The **Adapter** is the universal power outlet. The **Factory** is the appliance manager. **Hydra** is the **Instruction Manual** sitting on the counter.
- **`Does`:** Instead of  telling the Factory, "Give me an Ollama tool" inside the code, the code says, "Hey Hydra, read the manual and tell the Factory what to do."
- **`Why`:** If  want to switch from a cheap "blender" (Ollama) to a "professional grade processor" (OpenAI),  don't rewire the kitchen.  just rewrite one line in the manual (the YAML file). This is essential for scaling a product.
    
- **`Hierarchical Configuration:`** Hydra allows  to compose configs from multiple files (e.g., one for `hardware`, one for `model`, one for `environment`). 
- **`Dynamic Object Instantiation:`** Using `_target_` in YAML, Hydra can automatically "new up" (instantiate) a class without  writing a long `if/else` factory chain.
- **`Interpolation:`** Using values from one part of the config inside another (e.g., `${model.name}`).
    

-- `

We will have two files: a **Configuration File** (`config.yaml`) and the **Python Script**.
##### 1. The Configuration File

**`config.yaml`**: This is the "Manual."

```yaml
# config.yaml
model_setup:
  provider: "ollama"
  name: "nomic-embed-text"
  api_key: "optional_for_ollama"

vector_store:
  type: "in_memory"
```

##### 2. The Python Script (The Kitchen)

Use the `@hydra.main` decorator. This turns the function into a configuration-aware "Engine."

```python
import hydra
from omegaconf import DictConfig
from abc import ABC, abstractmethod

# 1. The Contract (Same as before)
class BaseEmbeddingAdapter(ABC):
    @abstractmethod
    def get_provider(self): pass

# 2. The Implementations (The actual tools)
class OllamaAdapter(BaseEmbeddingAdapter):
    def __init__(self, name): self._p = "Ollama Instance of " + name
    def get_provider(self): return self._p

class OpenAIAdapter(BaseEmbeddingAdapter):
    def __init__(self, name): self._p = "OpenAI Instance of " + name
    def get_provider(self): return self._p

# 3. The Principal-Level Factory
class EmbeddingFactory:
    @staticmethod
    def create(cfg: DictConfig):
        if cfg.provider == "ollama":
            return OllamaAdapter(cfg.name)
        elif cfg.provider == "openai":
            return OpenAIAdapter(cfg.name)

# 4. The Main Entry Point (Hydra-Enabled)
@hydra.main(version_base=None, config_path=".", config_name="config")
def my_app(cfg: DictConfig):
    # The code asks the Factory to build the tool based on the YAML
    adapter = EmbeddingFactory.create(cfg.model_setup)
    
    print(f"Current System is running: {adapter.get_provider()}")

if __name__ == "__main__":
    my_app()
```


```yaml
[ config.yaml ]  <--- (DevOps/Architect changes this file)
      |
      V
[ Hydra Engine ] <--- (Reads the manual and parses it)
      |
      V
[ EmbeddingFactory ] <--- (Asks: "What tool does the manual want?")
      |
      V
[ OllamaAdapter ] <--- (Factory instantiates the specific tool)
      |
      V
[ the RAG Chain ] <--- (Uses the tool without knowing its brand)
```

1. **Command Line Power:**  can override the YAML from the terminal without opening the code: `python script.py model_setup.provider=openai`.
2. **Versioning:**  can keep different YAML files for "Production," "Staging," and "Development."
3. **Audit Trail:** In MLOps, we need to know _exactly_ which model version was used for a specific run. Hydra automatically saves a copy of the config used for every single execution.