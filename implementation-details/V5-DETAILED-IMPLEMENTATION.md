# V5 Core Agent Architecture — Detailed Implementation

> **Architects:** DeepSeek & Gemini
> **Status:** COMPLETE (May 11-16, 2026)
> **Scope:** Polyglot Agent, Data Pipeline, Streamlit UI, XGBoost, Guardrails, LangFuse Observability

---

## V5.0 Architecture Overview

V5 represents the foundational release of the OfficeHub AI Paid Marketing platform. It establishes the core 10-layer agent architecture spanning from Salesforce data ingestion through to LLM-powered analysis and Streamlit presentation.

### High-Level Architecture (10 Layers)

| Layer                        | Component                                 | Description                                                                                                          |
| ---------------------------- | ----------------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| **0. Data Foundation**       | `src/etl/ingest.py`                       | 5-step automated pipeline: Cache Invalidation → ETL → XGBoost Retrain → Taxonomy Governance → Warm-up Tests          |
| **0b. Skills Compiler**      | `src/vectorize/vectorize.py`              | Offline compilation of skill `.md` files into Qdrant vector embeddings                                               |
| **1. Gateway & Memory**      | FastAPI + Celery + Qdrant                 | Async queuing (Redis broker), Episodic Memory (semantic cache with >0.95 cosine threshold)                           |
| **2. Intent Classification** | `qwen2.5-coder` (Router)                  | Zero-shot Pydantic-constrained tool selection (math / graph / combined)                                              |
| **3. Code Generation**       | `qwen2.5-coder` (Planner)                 | Generates SQL or Cypher within bounded skill context; guardrails strip hallucinated constraints                      |
| **4. Polyglot Execution**    | Polars/Parquet + Neo4j                    | Math Engine (columnar), Graph Engine (topological), Combined Bridge (cross-boundary joins)                           |
| **5. Context Compression**   | Stratified Semantic Sampler               | 30-row semantic anchors (top/mid/bottom 10) + statistical metadata envelope                                          |
| **6. Synthesis**             | `llama3.1` (Synthesizer)                  | 3-sentence executive summary; Pydantic-validated `AnalystResponse`                                                   |
| **7. Evaluation**            | `deepseek-r1:7b` (Judge) + DeepEval       | Asynchronous Relevance + Groundedness scoring pushed to LangFuse                                                     |
| **8. Presentation**          | Streamlit + HTML Generator                | 7 metrics × 11 dimensions × 4 timeframes; Chart.js + expandable data dumps                                           |
| **9. Statistical & ML**      | SciPy + XGBoost + SHAP                    | Welch's T-Tests, Spearman Correlation, XGBoost Lead Scorer, SHAP                                                     |

### Docker Infrastructure

| Container               | Purpose                             | Config File                            |
| ----------------------- | ----------------------------------- | -------------------------------------- |
| Neo4j                   | Graph Database                      | `docker-compose-neo4j.yml`             |
| Qdrant                  | Vector DB (Skills + Semantic Cache) | `docker-compose-qdrant.yml`            |
| Redis                   | Celery Message Broker               | `docker-compose-redis.yml`             |
| LangFuse (4 containers) | Observability & Tracing             | `langfuse/docker-compose-langfuse.yml` |

**Boot:** `./infra_up.sh` | **Teardown:** `./infra_down.sh`

---

## V5.1 Data Pipeline & Schema Governance

### Ingestion Pipeline (`src/etl/ingest.py`)

5-step automated sequence when run via `__main__`:

1. **Cache Invalidation** — Wipe Qdrant `query_cache`
2. **ETL** — Load CSV (strict string mode) → Sanitize (financial `.abs()`, winsorize at 99th percentile, ghost column purge at >85% nulls) → Write `math_schema.parquet` → Bulk-ingest Neo4j (batched `UNWIND` at 5000, with `TransientError` retry loop)
3. **XGBoost Sync** — Auto-retrain `xgboost_pi_model.json` on fresh data
4. **Taxonomy Governance** — Extract unique categorical values → CSV archives + Markdown health report
5. **Cache Warm-up** — Run `all_combinations_streamlit_tests.py` to prime the semantic cache

### Data Schema

**`math_schema.parquet`** (19 columns + Lead_ID):
`Lead_ID`, `STATUS`, `PARDOT_SCORE__C`, `PI__SCORE__C`, `MONTHLY_BUDGET__C`, `FORECASTED_REVENUE_AUD__C`, `MIN_DESKS__C`, `MAX_DESKS__C`, `PARDOT_FIRST_ACTIVITY_DATE__C`, `CONVERTEDDATE`, `CITY`, `IDEAL_SIZE_SQM__C`, `LASTACTIVITYDATE`, `TOTALCALLSFROMTENANT__C`, `TOUR_DATE_REQUESTED__C`, `PARDOT_PAGE_VIEWS_COUNT__C`, `NUMBEROFEMPLOYEES`, `ANNUALREVENUE`, `CREATEDDATE`

**Neo4j Graph Nodes** (28 properties + 3 time dimensions):
`Lead`, `Location` (city, state, country), `Campaign` (campaign_name, source), `Industry` (name)
Relationships: `[:LOCATED_IN]`, `[:ACQUIRED_VIA]`, `[:BELONGS_TO_INDUSTRY]`
Indices: `UNIQUE CONSTRAINT Lead(id)`, `INDEX Location(city, state)`, `INDEX Campaign(campaign_name, source)`, `INDEX Industry(name)`

**`taxonomy_schema.parquet`** (sidecar for Math Engine):
`Lead_ID`, `Unified_Source`, `Unified_Campaign`, `INDUSTRY__C`, `LEADSOURCE`

### Unified Taxonomy (`reconstruct_taxonomy`)

| Column             | Logic                                                                                                                       |
| ------------------ | --------------------------------------------------------------------------------------------------------------------------- |
| `Unified_Source`   | Fuzzy match `PI__UTM_SOURCE__C` + `ENQUIRY_CAMPAIGN__C` → 5 buckets: Google Ads, Bing Ads, Meta Ads, Email Marketing, Other |
| `Unified_Campaign` | Regex strip suffixes → normalize delimiters (`-`/`_` → space) → uppercase → fallback "ORGANIC/DIRECT"                       |

### Data Validation Rules

- **Schema Governance:** Categorical data MUST be cast to `pl.String` before aggregation
- **Column Verification:** Run `tests/deterministic/column-check.py` before modifying `ingest.py` or adding new dimensions
- **Temporal Topology:** Time dimensions (month, week, hour) stored as direct Lead node properties, not spatial nodes

---

## V5.2 Core Agent Architecture

### LLM Model Registry

| Role            | Model                  | Temperature        | Purpose                         |
| --------------- | ---------------------- | ------------------ | ------------------------------- |
| **Router**      | `qwen2.5-coder:latest` | 0.0                | Zero-Shot Intent Classification |
| **Planner**     | `qwen2.5-coder:latest` | 0.1                | SQL/Cypher Code Generation      |
| **Synthesizer** | `llama3.1:latest`      | 0.1 (configurable) | Executive Summary Generation    |
| **Auditor**     | `llama3.1:latest`      | configurable       | Self-Correction Verification    |
| **Judge**       | `deepseek-r1:7b`       | 0.0                | LLM-as-a-Judge Evaluation       |

All models served locally via Ollama with `keep_alive=0` to prevent VRAM overflow.

### Skill Registry (`/skills/`)

| Skill File           | Purpose                                                    |
| -------------------- | ---------------------------------------------------------- |
| `math.md`            | Pure Polars SQL operations on `math_schema.parquet`        |
| `graph.md`           | Cypher traversal queries on Neo4j nodes/relationships      |
| `combined_bridge.md` | Cross-boundary joins (Neo4j topology + Polars aggregation) |

Skills stored as Markdown files with YAML frontmatter (semantic description). Compiled into Qdrant via `vectorize.py` — only the **description** is embedded (not the body), avoiding semantic dilution.

### Query Lifecycle (ReWOO Pattern)

```
User Query → FastAPI/Celery → Qdrant Semantic Cache check
  ├─ Hit (>0.95) → Return cached response (~30ms)
  └─ Miss → qwen2.5-coder (Router) → Intent Classification
         → Load matched skill.md → qwen2.5-coder (Planner) → Generate SQL/Cypher
         → Guardrails intercept (cross-engine syntax bleed prevention)
         → Polyglot Execution (Polars / Neo4j / Combined Bridge)
         → Stratified Semantic Sampling + Statistical Metadata
         → llama3.1 (Synthesizer) → Executive Summary
         → Cognitive Guardrails → Pydantic Validation
         → Streamlit UI / HTML Report → Qdrant Cache Write
         → DeepEval (async) → LangFuse Trace
```

### Guardrails (`src/guardrails/guardrails.py`)

- **Coordination Drift:** Prevents SQL going to Graph engine and Cypher going to Math engine
- **Cognitive Drift:** Strips conversational filler from Synthesis output
- **Cache Poisoning Prevention:** Skips caching on error/empty responses
- **LIMIT Stripping:** Removes rogue `LIMIT` clauses from Planner-generated SQL

---

## V5.3 Statistical & Predictive Engines

### Welch's T-Test

Compares Google Ads vs Meta Ads cohorts on `PI__SCORE__C` and `MONTHLY_BUDGET__C`. Uses `scipy.stats.ttest_ind(equal_var=False)` with Cohen's d effect size. Decision rule: shift budget only if `p < 0.05 AND d > 0.2`.

### Spearman Correlation

Polars-driven rank correlation matrix targeting `PI__SCORE__C` and `MONTHLY_BUDGET__C`. Outputs Markdown table + `[guru_analysis]` block. Integrated into Streamlit as Feature Correlation widget.

### XGBoost Lead Scorer (`src/models/train_xgboost_scorer.py`)

- **Target:** `PI__SCORE__C` (capped at 99th percentile)
- **Features:** 7 key numeric columns
- **Hardware:** CUDA-accelerated (`tree_method='hist'`, `device='cuda'`)
- **Artifact:** `models/xgboost_pi_model.json`
- **Metrics:** MAE ~13.47, RMSE ~21.77
- **Top Features:** PARDOT_SCORE__C (60.6%), MAX_DESKS__C (22.5%), PARDOT_PAGE_VIEWS_COUNT__C (6.3%)
- **Explainability:** SHAP TreeExplainer for local feature importance

### Graph Feature Injection

Neo4j query extracts neighbor-level aggregates (e.g., `Avg_Neighbor_Score`, `Neighbor_Count`) → injected into XGBoost feature matrix. Captures buying committees and Halo Effects.

### Campaign Synergy (Bipartite Projection)

NetworkX + Plotly visualization of campaign-to-campaign sharing patterns via lead-intersection. Reveals multi-touch attribution and prevents fatal budget cuts on "assist" channels.

---

## V5.4 Observability & Evaluation

### LangFuse Tracing

`@observe` decorators on all major functions (`run_agent`, `route_query`, `execute_math_query`, `execute_graph_query`, `execute_combined_join`, `calculate_distribution_metadata`, `clean_llm_json`, both LLM calls). Hosted at `localhost:3000`.

### SQLite Telemetry (`src/telemetry/telemetry.py`)

Local `telemetry.db` logs: timestamp, prompt, tool, generated code, latency, status. `get_telemetry_summary()` prints per-engine query counts.

### DeepEval LLM-as-a-Judge

Asynchronous Celery task evaluates Relevance + Groundedness using `deepseek-r1:7b`. Scores pushed to LangFuse. Self-correction (Draft → Audit → Finalize) pipeline for quality improvement.

### Drift Monitoring (Rolling Baseline)

- **Data Drift:** Compare metrics against 30-day historical mean ± 2 std dev (stored in SQLite)
- **Agentic Drift:** Track "Guardrail Trip Rate" — frequency Pydantic rejects output or guardrails strip clauses

---

## V5.5 Streamlit UI (`app.py`)

- **Query Space:** 7 Metrics × 11 Dimensions × 4 Timeframes = 308 possible combinations → 222 unique queries
- **3-Column Cascading Dropdowns:** Metric → Dimension → Timeframe
- **Custom Query Override:** Free-text input field
- **Widgets:** Strategic Variance (T-Test), Campaign Synergy Viz, Feature Correlation, Deep Insight (unified battery)
- **Output:** Color-coded bar charts (Altair), executive callout blocks, expandable data tables
- **Backend:** Async polling to FastAPI + Celery for GPU-protected sequential execution

---

## V5.6 API Endpoints

| Method | Endpoint                | Handler                    | Purpose                                 |
| ------ | ----------------------- | -------------------------- | --------------------------------------- |
| `POST` | `/query`                | `submit_query`             | Async query via Celery queue            |
| `GET`  | `/task/{id}`            | `get_task_status`          | Poll task completion                    |
| `POST` | `/ask`                  | `ask_sync`                 | Sync query + HTML report (main UI path) |
| `POST` | `/deep-insight`         | `get_deep_insight`         | T-Test + Correlation + SHAP battery     |
| `POST` | `/variance-analysis`    | `get_variance_analysis`    | Standalone Welch's T-Test               |
| `POST` | `/correlation-analysis` | `get_correlation_analysis` | Standalone Spearman Correlation         |
| `GET`  | `/campaign-synergy`     | `get_campaign_synergy`     | Campaign bipartite graph edges          |

---

## V5.7 File Map

```
ai-paid-marketing/
├── data/
│   ├── raw/leads-data-191K.csv
│   └── processed/
│       ├── math_schema.parquet
│       ├── taxonomy_schema.parquet
│       └── telemetry.db
├── docs/implementation-notes/markdowns/
│   ├── DataOp-Relevant-Columns-for-Ingestion-SalesForce.md
│   ├── V0-Project-AI-Paid-Marketing.md  →  V5-Project-AI-Paid-Marketing.md
├── models/xgboost_pi_model.json
├── reports/agent_report.html
├── skills/
│   ├── math.md
│   ├── graph.md
│   └── combined_bridge.md
├── src/
│   ├── agent/
│   │   ├── agent.py           # Release version (ReWOO Planner/Worker)
│   │   ├── agent-V{3,4}.py    # Versioned backups
│   │   ├── guardrails.py
│   │   ├── html_generator.py
│   │   └── __init__.py
│   ├── api/
│   │   ├── server.py          # FastAPI gateway
│   │   └── celery_worker.py   # Celery task queue
│   ├── etl/ingest.py          # 5-step pipeline
│   ├── telemetry/
│   │   ├── telemetry.py       # SQLite + LangFuse
│   │   └── evals.py           # DeepEval
│   ├── tools/tools.py         # Deterministic execution engines
│   ├── models/train_xgboost_scorer.py
│   └── vectorize/vectorize.py # Skills → Qdrant compiler
├── tests/
│   ├── deterministic/
│   │   ├── column-check.py
│   │   └── statistical/
│   │       ├── t-test_campaigns.py
│   │       └── correlation_engine.py
│   └── logs/diagnostics/
├── app.py                     # Streamlit dashboard
├── main.py
├── infra_up.sh / infra_down.sh
├── docker-compose-{neo4j,qdrant,redis}.yml
├── langfuse/docker-compose.yml
├── pyproject.toml
├── AGENTS.md                  # Project rules & guardrails
├── AGENT-CHANGES.md           # Modification log (append-only)
├── README.md
└── IMPLEMENTATION-PLAN.md     # This file
```

---

## V5.8 Implementation Chronology (from AGENT-CHANGES.md)

### Day 1 — May 11, 2026: Data Foundation
- Environment setup (Neo4j, FastAPI, Streamlit)
- ETL planning and data sanitization (financial clamping, Winsorization, ghost column purging)
- Polars Float64/schema fixes
- Onboarding and project context mapping

### Day 2 — May 12, 2026: Statistical & ML Engines
- Welch's T-Test engine (Google vs Meta, dynamic permutations)
- Spearman Rank Correlation engine (Polars-driven)
- XGBoost pipeline (GPU-accelerated, SHAP explainability)
- Correlation engine UI integration
- LangFuse API fix (`.create_score()` syntax)
- Streamlit Dashboard with premium styling

### Day 3 — May 13, 2026: Full Pipeline Integration
- 5-step automated ETL (Wipe → ETL → XGBoost → Taxonomy → Cache Warmup)
- Neo4j ingestion tuned to ~2 minutes (5K UNWIND batches)
- Taxonomy reports and categorical extraction
- Campaign Synergy (bipartite projection)
- LLM Judge telemetry pushed to UI
- Ingestion sanitization (empty column purge, `.abs()` flooring)

### Day 4 — May 14, 2026: Agent Architecture & UI
- V5 architecture diagram and query lifecycle diagram
- 68 automated test failures resolved (taxonomy mismatch, Singapore routing)
- Prompt masking to prevent LLM timeframe/Cypher date hallucinations
- Deterministic temporal routing in Polars execution
- LangFuse `@observe` migration from deprecated `.decorators`
- README documentation with full V5 API/LLM registry
- Cascading predictive analytics UI

### Day 5-6 — May 15-16, 2026: Bug Fixes & Remediation
- 8 critical bugs fixed (T-Test dimensions, circular imports, Uvicorn reload)
- 15 logical fallacies remediated (Router-Planner authority, GROUP BY sanitization, etc.)
- 29 security vulnerabilities audited and all resolved

---

## V5.9 Known Issues (from V5 era)

- **Dense Embedding Ceiling:** Cosine similarity routing has semantic collisions on overlapping nouns — mitigated by LLM-based Intent Classification in V4.2+
- **Data Sparsity:** UTM fields 80-90% missing; `ANNUALREVENUE` 82% null
- **Temporal Parsing:** `CREATEDDATE` ISO string parsing may force timestamps to default hour
- **Cold Leads:** Average lead age 695 days (~1.9 years), max 5 years
- **Multi-Touch Attribution:** Not yet reliable — requires cleaner journey data before Markov Chain implementation

---

## V5.10 Success Criteria

1. All 7 Docker containers start successfully via `./infra_up.sh`
2. 5-step ingestion pipeline completes with zero errors on 191K rows
3. Qdrant semantic cache returns hits at >0.95 cosine threshold
4. ReWOO Planner/Worker pattern routes queries correctly to math/graph/combined engines
5. LangFuse traces all LLM calls with `@observe` decorators
6. Streamlit dashboard serves 222 unique query combinations
7. Welch's T-Test and Spearman Correlation produce statistically valid outputs
8. XGBoost lead scorer achieves MAE ~13.47 on PI Score prediction
9. DeepEval judge evaluates Relevance + Groundedness on every query
10. Guardrails prevent coordination drift between engine assignments
