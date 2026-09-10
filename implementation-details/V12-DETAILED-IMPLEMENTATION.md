# V12 Graph-Powered Lead Scoring — Detailed Implementation

> **Implementation of Section 19 of IMPLEMENTATION-PLAN.md**

## Architecture Overview

V12 adds 4 new source files and modifies 2 existing files. The data flow is:

```
Existing Neo4j (190K Lead + 5 edge types)
  |
  |-- Sprint 12-A: src/graph/graph_features.py
  |     PageRank, Louvain, FastRP, Degree, Jaccard
  |     --> 11 new columns in math_schema.parquet
  |
  |-- Sprint 12-B: src/graph/entity_resolver.py
  |     Ollama LLM (qwen2.5-coder)
  |     --> Company nodes + BELONGS_TO_COMPANY edges
  |
  |-- Sprint 12-C: src/graph/temporal_edges.py
  |     Temporal parquet columns
  |     --> Interaction nodes + PERFORMED edges
  |
  |-- Sprint 12-D: tests/deterministic/test_graph_feature_lift.py
        XGBoost flat vs graph AUROC comparison
        --> Decision: PROCEED to GNN or ITERATE
```

## New Files

### `src/graph/graph_features.py` (~350 lines)
- `_connect_gds()` — Initialize GDS client, graceful failure
- `_build_or_get_graph()` — Project Neo4j topology into GDS in-memory graph
- `compute_pagerank()` — PageRank centrality (20 iterations, 0.85 damping)
- `compute_louvain()` — Community detection (maxLevels=10)
- `compute_degree_centrality()` — Raw edge count per lead
- `compute_fastrp_embeddings()` — 8-dim node embeddings
- `compute_jaccard_champion_similarity()` — Max similarity to top-20% converted leads
- `extract_all_graph_features()` — Orchestrates all 5, returns dict of DataFrames

### `src/graph/entity_resolver.py` (~250 lines)
- `_ollama_chat()` — Call Ollama API with prompt
- `_extract_json_from_llm()` — Parse JSON from LLM output (handles code fences)
- `infer_company_names()` — Batch leads (BATCH_SIZE=50) through LLM
- `write_to_neo4j()` — Create Company nodes + BELONGS_TO_COMPANY edges
- `run_entity_resolution()` — Full pipeline with limit control

### `src/graph/temporal_edges.py` (~200 lines)
- `_days_since()` — Compute days between date string and reference
- `build_interaction_edges()` — Derive edges from parquet temporal columns
- `run_interaction_graph_construction()` — Build + write to Neo4j

### `tests/deterministic/test_graph_feature_lift.py` (~150 lines)
- `_load_and_prepare()` — Load parquet, prepare for evaluation
- `_temporal_split()` — 80/20 temporal split by CREATEDDATE
- `_train_xgboost()` — Train binary classifier, return AUROC
- `run_ab_evaluation()` — Full A/B evaluation with gate decision

## Modified Files

### `src/etl/ingest_only_full.py`
- Added V12-A block: GDS graph feature extraction (before XGBoost retrain)
- Added V12-B block: LLM entity resolution (limit=500)
- Added V12-C block: Temporal interaction graph construction
- Renumbered existing steps

### `src/etl/ingest_and_tests_for_UI_cache_building.py`
- Same 3 V12 blocks added in the same order
- Renumbered existing steps

## New Columns in math_schema.parquet

| Column | Type | Source Algorithm |
|--------|------|-----------------|
| lead_graph_centrality | Float64 | PageRank |
| lead_community_id | Int64 | Louvain |
| lead_degree_centrality | Int64 | Degree Centrality |
| lead_fastrp_emb_0..7 | Float64 | FastRP (8 dims) |
| lead_champion_jaccard | Float64 | Jaccard Similarity |

## New Neo4j Entities

**Company nodes** (V12-B):
- Label: `Company`
- Properties: name, role_category, confidence
- Edge: `(Lead)-[:BELONGS_TO_COMPANY]->(Company)`

**Interaction nodes** (V12-C):
- Label: `Interaction`
- Properties: type, weight, timestamp
- Edge types: ENTERED_FUNNEL, REQUESTED_TOUR, LAST_ACTIVE_AT, CALLED_SUPPORT
- Edge: `(Lead)-[:PERFORMED]->(Interaction)`

## Dependencies

- `graphdatascience>=1.12` — Neo4j GDS Python client
- numpy relaxed from >=2.4.4 to >=2.3.0 (compatibility with GDS)

Zero Docker changes.

## Verification Steps

```bash
# 1. Import check
uv run python -c "import graphdatascience; print('GDS', graphdatascience.__version__)"

# 2. Syntax check all files
uv run python -m py_compile src/graph/graph_features.py
uv run python -m py_compile src/graph/entity_resolver.py
uv run python -m py_compile src/graph/temporal_edges.py
uv run python -m py_compile tests/deterministic/test_graph_feature_lift.py
uv run python -m py_compile src/etl/ingest_only_full.py
uv run python -m py_compile src/etl/ingest_and_tests_for_UI_cache_building.py

# 3. Standalone graph feature extraction
uv run python -c "
from src.graph.graph_features import extract_all_graph_features
features = extract_all_graph_features()
print('Features:', list(features.keys()) if features else 'None')
"

# 4. A/B evaluation
uv run python tests/deterministic/test_graph_feature_lift.py
```
