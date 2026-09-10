---
tags:
  - package-managers
  - linux
  - conda-package-manager
  - mamba-package-manager
  - computing-envs
  - uv-package-manager
---

---

```table-of-contents
```

---
### References 

> [!info] .
>
>**[Obsidian Links]** 
> `$= dv.list(dv.current().file.outlinks.filter(l => l.path.endsWith(".md")))`
>
>---
>
>**[External Links]**
> `$= const content = await dv.io.load(dv.current().file.path); const regex = /\[(.*?)\]\((https?:\/\/[^\s)]+)\)/g; const links = []; let m; while (m = regex.exec(content)) { links.push("[" + m[1] + "](" + m[2] + ")"); } dv.list([...new Set(links)])`
>
>---
>
>**[Directory Links]**
> `$= const content = await dv.io.load(dv.current().file.path); const regex = /\[(.*?)\]\(<(file:\/\/\/.*?)>\)/g; const links = []; let m; while (m = regex.exec(content)) { links.push("[" + m[1] + "](<" + m[2] + ">)"); } dv.list([...new Set(links)])`
>
>---
>
>**[Back Links]**
> `$= dv.list(dv.current().file.inlinks)`
> 


---
### Primitives 

- [[Factory Pattern-Dependency-Management-Hydra]]
- [[Dependency-Management]]

---

>**Context** 
>- Complete transition from Conda to UV 
>- Documentation for the architectural decisions + installation procedures + edge-case handling for ML/AI workloads

---
### 1. System Prerequisites

#### I. Build Infrastructure ➝ CPU Compilation

> Before installing any Python packages ➝ ensure the system has the necessary compilers for building native extensions
> Critical for ➝ `llama-cpp-python` + PyTorch Geometric +  other C++-dependent libraries

```bash
# Core build tools + development headers
sudo apt update && sudo apt install -y build-essential cmake git

# Workflow utilities and documentation tools
sudo apt update && sudo apt install -y git gh tree htop ripgrep bat pandoc texlive
```

##### What this installs

> - `build-essential` ➝ GCC/G++ compilers, Make, and libc headers
> - `cmake` ➝  Cross-platform build system (required by many ML libraries)
> - `git`/`gh` ➝  Version control and GitHub CLI
> - `tree`, `htop` ➝  Directory visualization and system monitoring
> - `ripgrep` `rg`, `bat` ➝  Modern replacements for `grep` and `cat`
> - `pandoc` + `texlive` ➝  Document conversion (Markdown → PDF, Jupyter → LaTeX)

---
### 2. UV Installation & Verification

#### Step 1: Install UV

```bash
# Download and execute the official installation script
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**What happens:**
- UV binary installs to `~/.local/bin/uv`
- Shell configuration updated (`.bashrc` or `.zshrc`)
- No admin privileges required (user-space install)

#### Step 2: Activate UV for Current Session

```bash
# Immediately make UV available in this terminal
source $HOME/.local/bin/env
```

**Note:** After the first install, UV will be available automatically in new terminal sessions.

#### Step 3: Verify Installation

```bash
# Should output version (e.g., uv 0.5.x)
uv --version
```

---

### Core Concepts: Why UV?

**The Problem:**  
Installing PyTorch with `pip` or Conda defaults to downloading the "everything included" version—huge NVIDIA CUDA drivers optimized for data center GPUs. Since Phoenix and Yoga use **CPU-only** or **integrated graphics**, downloading 3GB+ of GPU drivers is wasteful.

**The UV Solution:**  
UV allows strict control: "I only want the CPU version." It:

- Downloads _only_ what you need
- Caches packages globally (5 projects using PyTorch = 1 copy on disk)
- Provides deterministic, cross-platform lockfiles (`uv.lock`)

**The MLOps Bonus:**  
In production MLOps pipelines, code moves from laptop (development) → server (production). UV ensures that if you lock `torch==2.3.1` on your laptop, the server gets _exactly_ that version, bit-for-bit.

--
#### 1. PEP 508 & Platform Compliance

UV strictly adheres to environment markers, resolving dependencies based on hardware:

```python
sys_platform == 'linux' and platform_machine == 'x86_64'
```
#### 2. Alternative Index Support

PyTorch requires specific index URLs (e.g., `https://download.pytorch.org/whl/cpu`) for CPU-optimized binaries. UV supports **multiple package sources natively** in `pyproject.toml`:

```toml
[tool.uv]
index = [
    { name = "pytorch-cpu", url = "https://download.pytorch.org/whl/cpu", explicit = true },
]

[tool.uv.sources]
torch = { index = "pytorch-cpu" }
torchvision = { index = "pytorch-cpu" }
torchaudio = { index = "pytorch-cpu" }
```

This prioritizes CPU wheels over massive CUDA wheels.
#### 3. Dependency Resolution Speed

MLOps libraries have deep dependency trees (e.g., `transformers` → `tokenizers` → `huggingface-hub`). UV uses the **PubGrub algorithm** (Rust-based) to resolve graphs in milliseconds, while `pip` often backtracks for minutes.

#### 4. Adoption Metrics (2025/2026)

- **Traffic:** UV processes 500M+ requests/day (~10% of all PyPI traffic)
- **Growth:** Unprecedented for a tool <2 years old
- **Industry Shift:** Leading tech blogs (DataCamp, DigitalOcean, JetBrains) published "Migration from Poetry/Conda to UV" guides

#### Cost/Time Analysis for MLOps Pipelines

| **Metric**            | **Conda/Pip**                 | **UV (Current Standard)**       |
| --------------------- | ----------------------------- | ------------------------------- |
| **CI/CD Build Time**  | 12-15 Minutes                 | **2-3 Minutes**                 |
| **Docker Image Size** | ~3.0 GB                       | **~0.8 GB**                     |
| **Dependency Lock**   | Unstable (Platform dependent) | **Strict (Universal Lockfile)** |
| **GPU/CPU Split**     | Complex (Manual URL handling) | **Native (Index Priority)**     |

--
#### Why UV for Phoenix & Yoga Specifically?

##### Space Efficiency (Critical for Yoga's 8GB RAM)
- **Conda:** Creates duplicate environments, each storing full copies of libraries
- **UV:** Uses **hard links** (magic links)—10 environments = 1 physical copy of each library on disk
##### CPU-Only Optimization
- **Conda:** Accidentally pulls GPU libraries unless meticulously configured
- **UV:** Explicit CPU-only declarations prevent bloat
##### Novice-Friendly
- **Learning Curve:** UV is one tool replacing three (`pip`, `venv`, `pyenv`)
- **Standard Compliance:** Uses PEP 621 (`pyproject.toml`), not proprietary Conda YAML
##### Alignment with Principal MLOps Architect Goals
- **Standardization:** Open standard (`pyproject.toml`) vs. proprietary format
- **CI/CD Velocity:** Parallel installs via Tokio async runtime (Rust)
- **Deterministic Builds:** `uv.lock` guarantees identical behavior across Ubuntu 20.04 → 24.04

--

#### TOML vs. YAML: The File Format Decision

##### What is TOML?

**TOML** = **Tom's Obvious, Minimal Language**. Designed to replace YAML's fragility.

**`Comparison`**

**YAML (Conda) - Indentation Hell:**

```yaml
dependencies:
  - numpy  # One extra space = crash
```

**TOML (UV) - Robust:**

```toml
dependencies = [
    "numpy",  # Clear, explicit, safe
]
```

**Key Difference:** TOML uses = signs and [] brackets. It's indentation-insensitive (like INI files), making it harder for humans to break.

--
### Environment Architecture

#### Repository Structure

Since UV generates two files (`pyproject.toml` + `uv.lock`) per environment, we organize them into subdirectories:

```bash
Computing-Envs/
├── agentopsenv/          # Folder replaces .yaml
│   ├── pyproject.toml    # The Blueprint
│   ├── uv.lock           # The "Frozen" versions (Git-tracked)
│   └── .venv/            # (Local only, .gitignore'd)
├── mlenv/
│   ├── pyproject.toml
│   ├── uv.lock
│   ├── install_kernels.sh  # Custom script for PyTorch Geometric
│   └── .venv/
├── base/
│   ├── pyproject.toml
│   └── uv.lock
└── README.md
```

#### Centralized Repository Pattern

Your `Computing-Envs` repo acts as a **Configuration Management Database (CMDB)** for development environments.

> **Directory-Based Separation:**  Unlike Conda's flat `.yaml` files, UV requires project root context. Each environment gets its own folder with encapsulated `pyproject.toml` and `uv.lock`

--
##### Activation Pathing

Instead of:

```bash
conda activate mlenv  # Looks up global registry
```

Use:

```bash
source ~/Computing-Envs/mlenv/.venv/bin/activate  # Direct path
```

> **Pro Tip:** Add aliases to `.bashrc` to mimic Conda's simplicity:

```bash
alias activate_agentops='source ~/Computing-Envs/agentopsenv/.venv/bin/activate'
alias activate_ml='source ~/Computing-Envs/mlenv/.venv/bin/activate'
alias activate_base='source ~/Computing-Envs/base/.venv/bin/activate'
```

**Usage:**

```bash
# Open terminal
activate_agentops

# Now you have access to all tools in that environment
python my_script.py
```

---
### Base Environment Setup

#### Purpose

The "base" environment replaces Conda's implicit base. It provides system-wide utilities and Jupyter infrastructure.

#### Installation Steps

##### 1. Navigate to Base Directory

```bash
cd ~/Computing-Envs/base
```

##### 2. Initialize & Pin Python Version

```bash
uv init
uv python pin 3.10
```

**What this does:**
- Creates minimal `pyproject.toml`
- Locks Python to 3.10.x (avoids 3.13's experimental status)

##### 3. Add Python Packages

```bash
uv add jupyterlab ipywidgets nbconvert matplotlib seaborn \
       numpy tqdm ruamel.yaml rich python-dotenv cookiecutter
```

**Package Rationale:**
- `jupyterlab` + `ipywidgets`: Modern notebook interface
- `nbconvert`: Notebook → PDF/HTML/Markdown conversion
- `matplotlib` + `seaborn`: Data visualization
- `tqdm`: Progress bars
- `ruamel.yaml`: YAML parsing (preserves comments)
- `rich`: Beautiful terminal output
- `cookiecutter`: Project templating

**Removed from Original Conda Base:**
- `mamba`, `conda`, `nb_conda_kernels`: UV replaces these entirely

> **Note on `pandoc`:**  Originally listed as `pandadoc` (e-signature API). Corrected to `pandoc` (document converter) and installed system-wide via APT (see [System Prerequisites](#system-prerequisites)).

---
### AgentOps Environment

#### Purpose

Agentic ML stack for LLM workflows, RAG pipelines, and vector database integration.

#### Architecture Analysis

Your `pyproject.toml` demonstrates **Principal-level stack composition**:

```toml
[project]
name = "agentopsenv"
version = "0.1.0"
requires-python = ">=3.10, <3.13"
dependencies = [
    "accelerate>=1.12.0",
    "black>=26.1.0",
    "chromadb>=1.4.1",
    "datasets>=4.5.0",
    "docarray>=0.41.0",
    "docling>=2.70.0",
    "duckdb>=1.4.4",
    "dvc-gdrive>=3.0.1",
    "fastapi>=0.128.0",
    "flask>=3.1.2",
    "flask-cors>=6.0.2",
    "flask-restful>=0.3.10",
    "gunicorn>=24.1.1",
    "huggingface-hub<1.0",
    "ipykernel>=7.1.0",
    "ipywidgets>=8.1.8",
    "jupyterlab>=4.5.3",
    "langchain>=1.2.7",
    "langchain-community>=0.4.1",
    "langchain-huggingface>=1.2.0",
    "langchain-ollama>=1.0.1",
    "langgraph>=1.0.7",
    "langsmith>=0.6.6",
    "llama-cpp-python>=0.3.16",
    "matplotlib>=3.10.8",
    "nbconvert>=7.16.6",
    "nbformat>=5.10.4",
    "numpy>=2.2.6",
    "ollama>=0.6.1",
    "openai>=2.16.0",
    "openpyxl>=3.1.5",
    "pandas>=2.3.3",
    "polars>=1.37.1",
    "pydantic>=2.12.5",
    "pydantic-ai>=1.48.0",
    "pytest>=9.0.2",
    "python-dotenv>=1.2.1",
    "ragas>=0.4.3",
    "ruff>=0.14.14",
    "scipy>=1.15.3",
    "seaborn>=0.13.2",
    "tokenizers>=0.22.2",
    "torch>=2.10.0",
    "torchaudio>=2.10.0",
    "torchvision>=0.25.0",
    "tqdm>=4.67.1",
    "transformers<5.0.0",
    "uvicorn>=0.40.0",
]

[tool.uv]
index = [
    { name = "pytorch-cpu", url = "https://download.pytorch.org/whl/cpu", explicit = true },
]

[tool.uv.sources]
torch = { index = "pytorch-cpu" }
torchvision = { index = "pytorch-cpu" }
torchaudio = { index = "pytorch-cpu" }
```
##### Stack Breakdown
**Core Agent Framework:**
- `langchain` + `langgraph` + `langsmith`: Orchestration + observability
- `pydantic-ai`: Structured agent workflows
- `ollama` + `llama-cpp-python`: Local LLM inference
**Data + Retrieval:**
- `chromadb` + `docarray`: Vector storage
- `duckdb` + `polars`: High-performance analytics (columnar storage)
- `docling`: Document processing
**MLOps Tooling:**
- `dvc-gdrive`: Data versioning (Git for datasets)
- `ruff` + `black`: Linting/formatting
- `ragas`: RAG evaluation framework
**Infrastructure:**
- `fastapi` + `flask`: Dual API frameworks (modern + legacy support)
- `gunicorn` + `uvicorn`: Production ASGI/WSGI servers
- `torch` (CPU-only): Deliberate choice for portability
**Smart Constraints:**
- `requires-python = ">=3.10, <3.13"`: Avoids 3.13's experimental features
- `huggingface-hub<1.0`: Version lock for API stability
- `transformers<5.0.0`: Same reasoning

#### Installation Steps

##### 1. Navigate & Pin Python

```bash
cd ~/Computing-Envs/agentopsenv
uv python pin 3.10
```

##### 2. Batch Installation (Organized by Layer)

**Batch A: Foundation (Data, Web, & Utils)**

```bash
uv add duckdb pandas polars numpy scipy matplotlib seaborn \
       jupyterlab ipykernel ipywidgets nbconvert nbformat \
       black ruff pytest tqdm openpyxl python-dotenv \
       flask flask-restful flask-cors gunicorn fastapi uvicorn
```

**Batch B: AI Core (Hugging Face & MLOps)**

```bash
uv add transformers datasets accelerate tokenizers dvc-gdrive
```

**Batch C: Agentic Stack (LangChain, Ollama, & Vector DBs)**  
_Note: `llama-cpp-python` will compile from source (5-10 minutes on CPU). This is expected behavior._

```bash
uv add langchain langchain-community langgraph langsmith \
       langchain-ollama langchain-huggingface \
       pydantic pydantic-ai openai ollama \
       docling chromadb ragas docarray \
       llama-cpp-python
```

---
### ML Environment (PyTorch + Geometric)

#### Purpose

Full ML stack with PyTorch, Graph Neural Networks (PyTorch Geometric), and custom kernel compilation.

#### Critical Context: Why a Custom Script?

PyTorch Geometric (`torch-scatter`, `torch-sparse`, `torch-geometric`) requires **C++ extensions** compiled against PyTorch's specific ABI (Application Binary Interface).
##### The Core Problems
**1. The "Flag" Problem (ABI Mismatch)**
- **Issue:** Your compiler needs `CXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0"` to use "Old C++" ABI
- **TOML Limitation:** No standard field exists to inject environment variables into C++ compilation
- **Result:** Default compilation uses Modern C++, causing mismatch with PyTorch's pre-built binaries
**2. The "Isolation" Problem (Ghost Torch)**
- **Issue:** UV/pip create "clean room" build environments, downloading fresh PyTorch during compilation
- **Conflict:** We need compilation against **your exact** `torch-2.3.1`, not a temporary download
- **TOML Limitation:** Cannot disable safety protocols (`--no-build-isolation`) in standard dependency lists
##### Why Not Just Use TOML?

|**Feature**|**pyproject.toml (The List)**|**install_kernels.sh (The Script)**|
|---|---|---|
|**Role**|Defines _WHAT_ to install|Defines _HOW_ to install it|
|**Dependencies**|"I need `torch` and `pandas`"|(Does not handle this)|
|**Compiler Flags**|❌ Cannot set `CXXFLAGS`|✅ Sets `CXXFLAGS="-D..."`|
|**Build Isolation**|❌ Enforces standard isolation|✅ Forces `--no-build-isolation`|
|**Source**|Standard PyPI / Git URLs|Git Clone + Local Compilation|

**Architectural Decision:**  
We separate concerns to create a **Stable Core** (TOML) + **Custom Edge** (script):
1. **Stable Core:** 98% of packages (Pandas, Scikit, Transformers) installed via `uv sync`
2. **Custom Edge:** 2% (Geometric Kernels) handled by script with bespoke compilation

> **This is not a hack; this is encapsulation.** You're isolating messy compilation logic from clean dependency management.

--
#### Installation Script

**`install_kernels.sh`**

```bash
#!/bin/bash
# install_kernels.sh
echo "🚀 Phase 1: Syncing Base Environment..."
uv sync

echo "🛠️ Phase 2: Injecting Pip..."
uv add pip

echo "🧬 Phase 3: Compiling Geometric Kernels (The Surgical Install)..."
echo "   NOTE: This will take 5-10 minutes. Please be patient."

# Activate the environment so we use the internal python/pip
source .venv/bin/activate

# The "Manual Override" Command
CXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0" python -m pip install \
    --no-build-isolation \
    --no-cache-dir \
    --force-reinstall \
    "git+https://github.com/rusty1s/pytorch_scatter.git" \
    "git+https://github.com/rusty1s/pytorch_sparse.git"

echo "✅ SUCCESS: Geometric Stack Fully Compiled."
```

##### Flag Breakdown

|Flag|Purpose|
|---|---|
|`CXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0"`|Forces old C++11 ABI (matches PyTorch binaries)|
|`--no-build-isolation`|Uses venv's PyTorch instead of temp build env|
|`--no-cache-dir`|Forces fresh compilation (avoids stale wheels)|
|`--force-reinstall`|Overwrites broken previous attempts|
|Git install|Builds from source against _exact_ PyTorch version|

---
### Standard Installation (Most Machines)

For fresh installs on Phoenix or other machines after the first Yoga setup:

```bash
cd ~/Computing-Envs/mlenv

# Standard sync
uv sync

# Run the kernel compilation script
bash install_kernels.sh
```

--
#### First-Time Installation (Yoga-Specific Fixes)

> ⚠️ This section documents troubleshooting done on Yoga during initial setup. For normal installations, use the Standard Installation above.

##### Verification: Check PyTorch ABI Compatibility

````bash
python -c "import torch; print(f'Compatible with Modern C++? {torch._C._GLIBCXX_USE_CXX11_ABI}')"
```

**Sample Output (Problem Detected):**
```
Compatible with Modern C++? False
````

**What This Means:**  
`False` indicates PyTorch wheel was built with Legacy C++ (ABI=0), but system compiler defaults to Modern C++ (ABI=1). They're incompatible (metric bolt vs. imperial nut).

##### The Fix: Force Legacy Compiler Flag

**Step 1: Deep Clean (Critical)**  
Wipe "Modern" binaries so UV doesn't restore them from cache:

```bash
# Clear UV's internal cache
uv cache clean

# Physically remove broken packages
rm -rf .venv/lib/python3.11/site-packages/torch_scatter*
rm -rf .venv/lib/python3.11/site-packages/torch_sparse*
```

**Step 2: Inject Pip**

```bash
uv add pip
```

**Step 3: The "Rosetta Stone" Compilation**  
Run this **exact** command (5-10 minutes expected):

```bash
CXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0" python -m pip install \
    --no-build-isolation \
    --no-cache-dir \
    --force-reinstall \
    --verbose \
    "git+https://github.com/rusty1s/pytorch_scatter.git" \
    "git+https://github.com/rusty1s/pytorch_sparse.git"
```

**Critical Notes:**
- **Must take 5-10 minutes:** If it finishes instantly, something is wrong
- **Verbose flag:** Shows compilation progress (useful for debugging)
- **Why pip here?** UV doesn't support custom `CXXFLAGS` in its native installer

##### What is the script doing

When this script runs, you're compiling:
1. **Scatter/Gather Operations:**  
    Highly optimized C++ routines for graph neural networks to aggregate messages from neighbors efficiently.
2. **Sparse Matrix Multiplication:**  
    The mathematical backbone of Graph Convolutional Networks (GCNs).
**Hardware Optimization:**  
Your `Yoga` (Intel) will run a bespoke version of the library tuned specifically for your laptop's silicon—mathematically identical to what runs on massive servers, but CPU-optimized.

---
### Jupyter Kernel Registration

After creating each environment, register it as a Jupyter kernel so it appears in JupyterLab's kernel selector.
#### General Pattern

```bash
# Activate the environment
source ~/Computing-Envs/<env_name>/.venv/bin/activate

# Ensure ipykernel is installed
uv pip install ipykernel

# Register the kernel
uv run python -m ipykernel install --user --name <env_name> --display-name "<Display Name>"
```

#### Specific Commands

##### AgentOps Environment

```bash
uv pip install ipykernel
uv run python -m ipykernel install --user --name agentopsenv --display-name "Phoenix: AgentOps (UV)"
```

##### ML Environment

```bash
uv pip install ipykernel
uv run python -m ipykernel install --user --name mlenv --display-name "Phoenix: ML (UV)"
```

##### Base Environment

```bash
uv pip install ipykernel
uv run python -m ipykernel install --user --name base --display-name "Phoenix: Base (UV)"
```

**Verification:**  
Open JupyterLab and check the kernel dropdown—you should see "Phoenix: AgentOps (UV)", "Phoenix: ML (UV)", and "Phoenix: Base (UV)".

---
### Troubleshooting & Edge Cases

#### Common Issues

##### 1. "Package not found" 
- during `uv sync`
- **Cause:** Typo in `pyproject.toml` or package name changed.  
- **Fix:** Check PyPI for correct package name:

```bash
uv pip search <package_name>
```
##### 2. Compilation Fails \
- for `llama-cpp-python`
- **Cause:** Missing `cmake` or `build-essential`.  
- **Fix:** Reinstall system prerequisites:

```bash
sudo apt install -y build-essential cmake
```

##### 3. PyTorch Geometric Still Fails After Script
- **Cause:** Cache corruption or wrong PyTorch version.  
- **Fix:** Nuclear option—delete entire environment and rebuild:

```bash
cd ~/Computing-Envs/mlenv
rm -rf .venv uv.lock
uv sync
bash install_kernels.sh
```

##### 4. Jupyter Kernel Not Appearing
- **Cause:** Kernel spec file not created.  
- **Fix:** Manually check kernel installation:

```bash
jupyter kernelspec list
```

> If missing, re-run registration command with `--verbose`:

```bash
uv run python -m ipykernel install --user --name mlenv --display-name "Phoenix: ML (UV)" --verbose
```

---
### Best Practices

#### 1. Always Pin Python Versions

```bash
uv python pin 3.10  # Lock to 3.10.x
```

#### 2. Commit `uv.lock` to Git

The lockfile ensures reproducibility. **Never** `.gitignore` it.

```bash
# .gitignore
.venv/
__pycache__/
*.pyc
# Do NOT ignore uv.lock
```

#### 3. Use Aliases for Quick Activation

Add to `~/.bashrc`:

```bash
alias activate_agentops='source ~/Computing-Envs/agentopsenv/.venv/bin/activate'
alias activate_ml='source ~/Computing-Envs/mlenv/.venv/bin/activate'
alias activate_base='source ~/Computing-Envs/base/.venv/bin/activate'
```

Reload:

```bash
source ~/.bashrc
```

#### 4. Document Custom Scripts

Every `install_kernels.sh`-style script should have a header explaining:
- **Why** it exists (ABI issues, build isolation, etc.)
- **What** it modifies (which packages)
- **How** to verify success (test imports)

---
### Performance Benchmarks

|**Operation**|**Conda**|**UV**|**Speedup**|
|---|---|---|---|
|**Environment Creation**|5-10 minutes|30-60 seconds|**10-20x**|
|**Dependency Resolution**|2-5 minutes|<5 seconds|**24-60x**|
|**Disk Usage (5 envs)**|~15 GB|~3 GB|**5x less**|
|**Lock File Generation**|N/A (unstable)|<1 second|**∞**|

---
### Final Checklist

- [ ]  System prerequisites installed (`build-essential`, `cmake`, `git`)
- [ ]  UV installed and verified (`uv --version`)
- [ ]  `Computing-Envs` repo structured with subdirectories
- [ ]  Base environment created and kernel registered
- [ ]  AgentOps environment created and kernel registered
- [ ]  ML environment created with custom script
- [ ]  PyTorch Geometric verified (`import torch_geometric`)
- [ ]  Jupyter kernels visible in JupyterLab
- [ ]  `.bashrc` aliases configured for quick activation
- [ ]  `uv.lock` files committed to Git

---
### Principal-Level Takeaways

1. **Separation of Concerns:** TOML handles declarative dependencies; scripts handle bespoke compilation.
2. **Encapsulation:** Isolate fragile edge cases (Geometric Kernels) from stable core (standard packages).
3. **Determinism:** `uv.lock` guarantees bit-for-bit reproducibility across machines.
4. **Portability:** CPU-only PyTorch + UV = lightweight, fast, Git-friendly environments.
5. **Future-Proofing:** This architecture scales to Phoenix, cloud servers, and CI/CD pipelines without modification.

