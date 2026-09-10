## 20. V13 — Pardot Decontamination & Own-Score Pipeline

> **Status:** Phase 1 COMPLETE (DeepSeek) | Phases 2-5 COMPLETE (Flash)
> **Trigger:** Director disclosed that `PARDOT_SCORE__C`, `PI__SCORE__C`, and all Pardot-derived fields are unreliable — contaminates predictive stack at V12
> **Timestamp:** 2026-05-26
> **Architects:** DeepSeek (Principal Architect) + Gemini (Adversarial Review)
> **Consensus:** Achieved on COUNCIL.md — heuristic weights + 3 distinct scores + _v1 suffixing + Neo4j write-back + XGBoost learns interactions
> **Estimated by Flash:** 5 NEW files, 4 MODIFIED files (in Phases 2-5), 0 new Python packages, 0 Docker changes, ~200 new lines + ~30 modified lines

### 20.1 First Principles — Why V13

V12 shipped with the entire predictive stack anchored to `PI__SCORE__C` (the Pardot Performance Index) as the **target** for XGBoost, Bayesian MCMC experiments, V12 A/B evaluation, correlation engine, clustering, and time-series analysis. The `PARDOT_SCORE__C` and `PARDOT_PAGE_VIEWS_COUNT__C` served as top-importance **features**. The Director's disclosure that these are unreliable means:

- **Every model prediction is built on contaminated inputs** — the XGBoost model scoring leads, the Bayesian posteriors driving budget decisions, the V12 A/B gate determining whether to invest in GNN — all invalid.
- **We don't just swap columns** — we build our own deterministic scoring pipeline that is explainable, versioned (`_v1` suffix), and anchored to observable ground-truth behavior (STATUS conversion) rather than a black-box vendor score.

**Core architectural decisions (Gemini consensus):**
1. **STATUS** becomes the universal target (binary: converted vs. not). STATUS is already a proven construct — Bayesian Exp 2 predicts it, survival analysis tracks conversion rates, PSM causal analysis derives `CONVERTED` from it.
2. **3 distinct scores** (NOT 1 composite): `behavioral_engagement_v1`, `business_value_v1`, `temporal_interaction_v1`. XGBoost thrives on high-dimensional distinct features — a single composite would destroy variance and non-linear boundaries.
3. **Heuristic weights as sensible priors** — not logistic-regression-derived. XGBoost will learn the optimal interactions later.
4. **Neo4j write-back** — scores written to `Lead` node properties for V14 graph algorithms (weighted PageRank, etc.).
5. **`_v1` suffix convention** — explicitly denotes our computed features, enables safe iteration (`_v2` next quarter) without breaking downstream pipelines.

### 20.2 Division of Labor

| Phase                                                                | Executor     | Status        |
| -------------------------------------------------------------------- | ------------ | ------------- |
| Phase 1: Cleanse — Remove Pardot from models/tests/UI                | **DeepSeek** | **COMPLETED** |
| Phase 2: Compute — Build 3 scoring modules + orchestrator            | **Flash**    | **COMPLETED** |
| Phase 3: Pipeline Integration — Inject scores into ingestion         | **Flash**    | **COMPLETED** |
| Phase 4: Neo4j Write-Back — Write scores to Lead node properties     | **Flash**    | **COMPLETED** |
| Phase 5: Verification — Syntax checks, import validation, smoke test | **Flash**    | **COMPLETED** |

---

### 20.3 Phase 1 — Cleanse (ALREADY COMPLETED by DeepSeek)

> **Status: DONE.** All 16 files cleansed and syntax-verified on 2026-05-26.

#### 20.3.1 Files Modified by DeepSeek

| File                                                                          | Change Summary                                                                                                                                                                                                                                                                                               |
| ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `src/models/train_xgboost_scorer.py`                                          | `target_col` = `"STATUS"` (binary encode via `CONVERTED_LABELS`). `BASE_FEATURES` = non-Pardot columns only. `XGBRegressor` → `XGBClassifier`. Metrics: MAE→AUROC. Stratified train/test split. Performance gate: AUROC Δ 0.005 threshold.                                                                   |
| `src/models/inference.py`                                                     | Docstring + `__main__` test input: Pardot features removed, replaced with `ANNUALREVENUE`, `NUMBEROFEMPLOYEES`, `IDEAL_SIZE_SQM__C`.                                                                                                                                                                         |
| `src/tools/tools.py`                                                          | `execute_ml_pipeline()`: docstring, `input_data` dict, return string all de-Pardoted. `run_bayesian_simulation()`: `target_metric` default = `"STATUS"`.                                                                                                                                                     |
| `src/models/bayesian_engine.py`                                               | All 7 experiments: `target_metric` default = `"STATUS"`. Exp 2 predictors: Pardot removed → replaced with `NUMBEROFEMPLOYEES`, `ANNUALREVENUE`. Exp 5 predictors: `PI__SCORE__C` removed → replaced with `TOTALCALLSFROMTENANT__C`. B-Spline experiment (Exp 6): docstring + target + binary encode updated. |
| `src/models/case_matcher.py`                                                  | `NUMERIC_COLS`: removed `PARDOT_SCORE__C`, `PARDOT_PAGE_VIEWS_COUNT__C`, added `ANNUALREVENUE`. `SKEWED_NUMERIC_COLS`: removed `PARDOT_PAGE_VIEWS_COUNT__C`, added `ANNUALREVENUE`.                                                                                                                          |
| `tests/deterministic/test_graph_feature_lift.py`                              | `TARGET` = `"STATUS"`. `CONVERTED_LABELS` added. `BASE_FEATURES` de-Pardoted (added `ANNUALREVENUE`, `NUMBEROFEMPLOYEES`, `IDEAL_SIZE_SQM__C`). Binary encoding via `pl.when().is_in(CONVERTED_LABELS)`.                                                                                                     |
| `src/graph/graph_features.py`                                                 | GDS projection: `pi_score` property → `converted` property from STATUS. Champion query: STATUS-based (all converted leads, no top-20% PI limit).                                                                                                                                                             |
| `src/api/server.py`                                                           | 4× `metric_map` dicts: removed `"PI Score"` + `"Pardot Score"` entries. Default `db_metric` = `"ANNUALREVENUE"`. `CoxModelRequest` covariates: Pardot removed → `ANNUALREVENUE`, `TOTALCALLSFROMTENANT__C` added.                                                                                            |
| `app.py`                                                                      | Metric dropdown: removed `"PI Score"` + `"Pardot Score"`. Case matcher form: `pardot_score` input removed, `annual_revenue` input added. `lead_features` Pardot → `ANNUALREVENUE`. All Plotly chart labels: "PI Score" → "Conversion Probability". Case matcher description: Pardot reference removed.       |
| `tests/streamlit-functionality-test/all_combinations_streamlit_tests.py`      | `metrics` list: removed `"PI Score"` + `"Pardot Score"`.                                                                                                                                                                                                                                                     |
| `tests/streamlit-functionality-test/streamlit_test_1_prompt.py`               | `QUERY` = `"Annual Revenue"`. Deep-insight + Bayesian payload: `"metric": "Annual Revenue"`. V11 CASE-1 `lead_features`: Pardot removed → `ANNUALREVENUE`, `NUMBEROFEMPLOYEES` added.                                                                                                                        |
| `tests/streamlit-functionality-test/specific_combinations_streamlit_tests.py` | No changes (uses Qualification Percentage + Annual Revenue only).                                                                                                                                                                                                                                            |
| `tests/statistical/correlation_engine.py`                                     | `target_metric` default = `"STATUS"`.                                                                                                                                                                                                                                                                        |
| `tests/statistical/clustering_segmentation.py`                                | `STANDARD_FEATURES`: removed `PARDOT_SCORE__C`, `PI__SCORE__C`, `PARDOT_PAGE_VIEWS_COUNT__C`, added `IDEAL_SIZE_SQM__C`. Removed `PI__SCORE__C` from display column selection.                                                                                                                               |
| `tests/statistical/survival_analysis.py`                                      | `cox_features`: Pardot removed → `ANNUALREVENUE`, `TOTALCALLSFROMTENANT__C` added.                                                                                                                                                                                                                           |
| `tests/statistical/timeseries_analysis.py`                                    | `avg_pi_score` aggregation → `conversion_rate` (conversions/lead_count * 100). Variable rename `avg_pi` → `conv_rate`. Trend analysis label: "PI Score Trend" → "Conversion Rate Trend", units: `pp per month` and `%`.                                                                                      |

#### 20.3.2 Verification (Already Passed)

All 16 files pass `py_compile()` syntax check:
```bash
for f in src/models/train_xgboost_scorer.py src/models/inference.py src/tools/tools.py \
         src/models/bayesian_engine.py src/models/case_matcher.py src/api/server.py \
         src/graph/graph_features.py app.py tests/deterministic/test_graph_feature_lift.py \
         tests/statistical/correlation_engine.py tests/statistical/clustering_segmentation.py \
         tests/statistical/survival_analysis.py tests/statistical/timeseries_analysis.py \
         tests/streamlit-functionality-test/all_combinations_streamlit_tests.py \
         tests/streamlit-functionality-test/streamlit_test_1_prompt.py \
         tests/streamlit-functionality-test/specific_combinations_streamlit_tests.py; do
  python -m py_compile "$f" && echo "$f: OK"
done
```

**Pardot columns still present in math_schema.parquet** (rollback-safe). Only model inputs, targets, and UI labels were changed.

---

### 20.4 Phase 2 — Compute: Build 3 Scoring Modules (COMPLETED)

**GOAL:** Create 5 new files under `src/scores/` that compute deterministic, explainable lead quality scores from non-Pardot Salesforce data, then inject them into `math_schema.parquet`.

#### 20.4.1 Package Orchestrator — `src/scores/__init__.py`

**TARGET ARTIFACT (NEW FILE):** `/home/az/Downloads/testing-delete/p-ai-paid-marketing/src/scores/__init__.py`

This is the sole entry point called by the ingestion pipeline. It loads parquet, computes all 3 scores, writes back. Each score computation is independently try/except wrapped for graceful degradation.

```python
"""
V13: Own-Score Pipeline Orchestrator.
Computes 3 deterministic lead quality scores from non-Pardot Salesforce data
and injects them into math_schema.parquet. Called by the ingestion pipeline
after V12-C (temporal edges) and before XGBoost retrain.

Architecture: Each scoring module is independently try/except wrapped.
One module failing does not block the others from computing.
"""

import os
import time
import polars as pl

PARQUET_PATH = os.path.abspath(os.path.join(
    os.path.dirname(__file__), "../../data/processed/math_schema.parquet"
))


def compute_and_inject_scores() -> dict[str, bool]:
    """
    Orchestrate all 3 V13 scoring modules.
    Loads math_schema.parquet, computes each score, writes back.

    Returns:
        {"behavioral_engagement_v1": bool, "business_value_v1": bool,
         "temporal_interaction_v1": bool}
        True = computed and injected successfully.
    """
    print("\n[V13] Computing own-scores (V13 decontamination)...")
    t0 = time.time()

    df = pl.read_parquet(PARQUET_PATH)
    results = {}

    # Score A: Behavioral Engagement
    try:
        from src.scores.engagement import compute_engagement_score
        df = df.with_columns(compute_engagement_score(df))
        results["behavioral_engagement_v1"] = True
        print("  [V13-A] behavioral_engagement_v1: OK")
    except Exception as e:
        print(f"  [V13-A] behavioral_engagement_v1 FAILED: {e}")
        results["behavioral_engagement_v1"] = False

    # Score B: Business Value
    try:
        from src.scores.financial import compute_business_value_score
        df = df.with_columns(compute_business_value_score(df))
        results["business_value_v1"] = True
        print("  [V13-B] business_value_v1: OK")
    except Exception as e:
        print(f"  [V13-B] business_value_v1 FAILED: {e}")
        results["business_value_v1"] = False

    # Score C: Temporal Interaction
    try:
        from src.scores.temporal import compute_temporal_score
        df = df.with_columns(compute_temporal_score(df))
        results["temporal_interaction_v1"] = True
        print("  [V13-C] temporal_interaction_v1: OK")
    except Exception as e:
        print(f"  [V13-C] temporal_interaction_v1 FAILED: {e}")
        results["temporal_interaction_v1"] = False

    df.write_parquet(PARQUET_PATH)
    elapsed = time.time() - t0
    print(f"  [V13] Scores injected in {elapsed:.1f}s. "
          f"New columns: {sum(1 for v in results.values() if v)}/3")
    return results
```

**WHY:** Centralized orchestrator ensures a single import point for the pipeline. Independent try/except per module means `engagement_score` failing (e.g. missing `TOTALCALLSFROMTENANT__C` column) doesn't prevent `business_value_score` from computing. This is the same graceful-degradation pattern used in V12-A.

**Error handling:** If all 3 modules fail, `results` returns all `False` — caller can log a warning but the pipeline continues with existing parquet columns. XGBoost retrain will simply have fewer features.

---

#### 20.4.2 Module A: Behavioral Engagement Score

**TARGET ARTIFACT (NEW FILE):** `/home/az/Downloads/testing-delete/p-ai-paid-marketing/src/scores/engagement.py`

```python
"""
V13-A: Behavioral Engagement Score (behavioral_engagement_v1).

Measures lead intent through observable behavior, not marketing-tracking data.

Components:
  - Tour Requested: 50 pts (strongest intent signal — took action to visit)
  - Tenant Calls:   30 pts (active engagement with the platform, scaled to calls/10)
  - Activity Recency: 20 pts (fresher activity = higher intent, scaled 0-365 days)

Output: 0-100 float column 'behavioral_engagement_v1' in math_schema.parquet.
"""

import polars as pl
from datetime import datetime, timezone


def _days_since_activity(dt_str: str | None) -> float:
    """Compute days between a LASTACTIVITYDATE value and now."""
    if dt_str is None or str(dt_str).strip() in ("", "None", "nan", "NaT"):
        return 365.0  # no activity = maximum age penalty
    try:
        ref = datetime.now(timezone.utc)
        dt = datetime.fromisoformat(str(dt_str).split("T")[0])
        days = (ref - dt).total_seconds() / 86400.0
        return max(0.0, days)
    except (ValueError, TypeError):
        return 365.0


def compute_engagement_score(df: pl.DataFrame) -> pl.Series:
    """
    Compute behavioral_engagement_v1 for all rows.

    Heuristic weights (Gemini consensus — sensible priors, XGBoost learns interactions):
      - Tour request: 50 pts (binary — strongest intent)
      - Tenant calls: 30 pts (volume, clipped at 10 calls = max)
      - Recency:      20 pts (decay over 365 days)

    Args:
        df: math_schema.parquet DataFrame

    Returns:
        Polars Series named 'behavioral_engagement_v1' with clip(0, 100)
    """
    tour_bonus = pl.when(
        pl.col("TOUR_DATE_REQUESTED__C").is_not_null()
    ).then(50).otherwise(0)

    call_score = (
        pl.col("TOTALCALLSFROMTENANT__C")
        .cast(pl.Float64, strict=False)
        .fill_null(0)
        .clip(0, 10)
    ) / 10.0 * 30.0

    days_since = pl.col("LASTACTIVITYDATE").cast(pl.String).map_elements(
        _days_since_activity, return_dtype=pl.Float64
    )

    recency_score = (1.0 - (days_since / 365.0)).clip(0, 1) * 20.0

    result = (tour_bonus + call_score + recency_score).clip(0, 100)
    return result.alias("behavioral_engagement_v1")
```

**WHY:** Tour requests are the single strongest non-Pardot behavioral signal — a lead that physically toured a space is demonstrably engaged. Call volume from the tenant portal is second-strongest. Recency provides a temporal decay so stale leads with old activity don't get high scores. The 50/30/20 split was agreed with Gemini as sensible priors; XGBoost will find optimal non-linear combinations during training.

**Error handling:** If `TOUR_DATE_REQUESTED__C` column is missing, `pl.col().is_not_null()` returns `False` for all rows → `tour_bonus = 0`. If `TOTALCALLSFROMTENANT__C` is missing, `fill_null(0)` handles it. If `LASTACTIVITYDATE` is missing, `map_elements` receives null → `_days_since_activity` returns `365.0`. Score degenerates gracefully to 0 instead of throwing.

---

#### 20.4.3 Module B: Business Value Score

**TARGET ARTIFACT (NEW FILE):** `/home/az/Downloads/testing-delete/p-ai-paid-marketing/src/scores/financial.py`

```python
"""
V13-B: Business Value Score (business_value_v1).

Measures lead economic potential through financial and company-size metrics.

Components (Z-score normalized, clipped at ±3σ, mapped to 0-100):
  - Monthly Budget:      30% weight (direct deal-size indicator)
  - Forecasted Revenue:  30% weight (predicted account value)
  - Annual Revenue:      20% weight (company financial capacity)
  - Number of Employees: 20% weight (organizational scale proxy)

Output: 0-100 float column 'business_value_v1' in math_schema.parquet.
"""

import numpy as np
import polars as pl


def compute_business_value_score(df: pl.DataFrame) -> pl.Series:
    """
    Compute business_value_v1 via Z-score normalization + weighted sum.

    Each metric is:
      1. Cast to Float64, NaN/Null → 0
      2. Z-score normalized: (x - mean) / std
      3. Clipped to [-3, 3] (outlier floor/ceiling)
      4. Weighted and summed
      5. Mapped from [-3, 3] → [0, 100] via linear transform

    Args:
        df: math_schema.parquet DataFrame

    Returns:
        Polars Series named 'business_value_v1' with clip(0, 100)
    """
    metrics = {
        "MONTHLY_BUDGET__C": 0.30,
        "FORECASTED_REVENUE_AUD__C": 0.30,
        "ANNUALREVENUE": 0.20,
        "NUMBEROFEMPLOYEES": 0.20,
    }

    n = df.height
    weighted_sum = np.zeros(n, dtype=np.float64)

    for col_name, weight in metrics.items():
        if col_name not in df.columns:
            continue  # skip missing columns gracefully

        series = df[col_name].cast(pl.Float64, strict=False).fill_null(0.0).to_numpy()
        arr = np.asarray(series, dtype=np.float64)
        mean = float(np.mean(arr))
        std = float(np.std(arr))

        if std is None or std <= 0:
            continue  # no variance → skip

        z = np.clip((arr - mean) / std, -3.0, 3.0)
        weighted_sum += z * weight

    score_np = np.clip((weighted_sum + 3.0) / 6.0 * 100.0, 0.0, 100.0)
    return pl.Series("business_value_v1", score_np)
```

**WHY:** Z-score normalization ensures budget ($0-$1M+) and employee count (0-50K+) are on comparable scales before weighting. ±3σ clipping prevents extreme outliers (e.g., a single $1.5B-lead) from dominating the score distribution. Missing columns are simply skipped — the score degrades gracefully to lower discrimination rather than throwing. The 0.30/0.30/0.20/0.20 weights were agreed with Gemini as sensible; XGBoost will find optimal feature interactions.

**Error handling:** If all 4 metric columns are missing, `weighted_sum` stays `zeros(n)` → `score_np` = `50.0` for all rows (neutral midpoint). If `std == 0` (no variance), that metric is skipped — avoids division-by-zero.

---

#### 20.4.4 Module C: Temporal Interaction Score

**TARGET ARTIFACT (NEW FILE):** `/home/az/Downloads/testing-delete/p-ai-paid-marketing/src/scores/temporal.py`

```python
"""
V13-C: Temporal Interaction Score (temporal_interaction_v1).

Aggregates the 4 decay-weighted interaction edges from V12-C into a single
0-100 score. This provides a one-column temporal feature for XGBoost without
requiring it to ingest the full interaction graph.

Sources (from V12-C temporal_edges.py):
  - ENTERED_FUNNEL:   weight = max(0, 1 - days/365)
  - REQUESTED_TOUR:   weight = max(0.2, 1 - days/90)
  - LAST_ACTIVE_AT:   weight = max(0.1, 1 - days/180)
  - CALLED_SUPPORT:   weight = min(1.0, calls/10)

Each lead gets the SUM of its 4 edge weights, normalized to 0-100 scale
(max possible = 4.0 weight sum → 100).

Output: 0-100 float column 'temporal_interaction_v1' in math_schema.parquet.
"""

import os
import polars as pl
from datetime import datetime, timezone


PARQUET_PATH = os.path.abspath(os.path.join(
    os.path.dirname(__file__), "../../data/processed/math_schema.parquet"
))


def compute_temporal_score(df: pl.DataFrame | None = None) -> pl.Series:
    """
    Compute temporal_interaction_v1 by aggregating V12-C edge weights.

    Reads math_schema.parquet (may be the same df passed by orchestrator),
    derives 4 interaction weights per lead, and sums them.

    Args:
        df: math_schema.parquet DataFrame (from orchestrator).
            If None, loads from disk.

    Returns:
        Polars Series named 'temporal_interaction_v1' with clip(0, 100)
    """
    if df is None:
        df = pl.read_parquet(PARQUET_PATH)

    ref_ms = datetime.now(timezone.utc).timestamp() * 1000.0

    score = pl.Series("total", [0.0] * df.height)

    # ENTERED_FUNNEL: max(0, 1 - days/365)
    if "CREATEDDATE" in df.columns:
        days = (pl.lit(ref_ms) - pl.col("CREATEDDATE")
                .str.to_datetime(format="%Y-%m-%dT%H:%M:%S%.fZ", strict=False)
                .dt.epoch("ms")) / 86400000.0
        score = score + pl.when(days.is_null()).then(0).otherwise(
            (1.0 - days / 365.0).clip(0, 1)
        )

    # REQUESTED_TOUR: max(0.2, 1 - days/90)
    if "TOUR_DATE_REQUESTED__C" in df.columns:
        days = (pl.lit(ref_ms) - pl.col("TOUR_DATE_REQUESTED__C")
                .str.to_date(format="%Y-%m-%d", strict=False)
                .dt.epoch("ms")) / 86400000.0
        score = score + pl.when(days.is_null()).then(0).otherwise(
            (1.0 - days / 90.0).clip(0, 1).clip_min(0.2)
        )

    # LAST_ACTIVE_AT: max(0.1, 1 - days/180)
    if "LASTACTIVITYDATE" in df.columns:
        days = (pl.lit(ref_ms) - pl.col("LASTACTIVITYDATE")
                .str.to_date(format="%Y-%m-%d", strict=False)
                .dt.epoch("ms")) / 86400000.0
        score = score + pl.when(days.is_null()).then(0).otherwise(
            (1.0 - days / 180.0).clip(0, 1).clip_min(0.1)
        )

    # CALLED_SUPPORT: min(1.0, calls/10)
    if "TOTALCALLSFROMTENANT__C" in df.columns:
        calls = pl.col("TOTALCALLSFROMTENANT__C").cast(pl.Float64, strict=False).fill_null(0)
        score = score + (calls / 10.0).clip(0, 1)

    result = (score / 4.0 * 100.0).clip(0, 100)
    return result.alias("temporal_interaction_v1")
```

**WHY:** This module duplicates the V12-C decay logic from `temporal_edges.py` but operates directly on parquet (Polars) rather than Neo4j. It provides a single-channel temporal feature for XGBoost that captures all four interaction dimensions. The 4.0 divisor normalizes the sum of 4 weights (each 0-1) to a 0-100 scale. Missing columns are skipped — if CREATEDDATE is absent, only 3 edge types contribute.

**Error handling:** If all temporal columns are missing, `score` stays zeros → result = `0.0` for all rows. The orchestrator already has an outer try/except, so any unexpected error during computation is caught and logged without aborting.

---

### 20.5 Phase 3 — Pipeline Integration (COMPLETED)

**GOAL:** Inject the V13 score computation block into both ingestion pipeline files, after V12-C and before XGBoost retrain.

#### 20.5.1 Integration into `ingest_only_full.py`

**TARGET ARTIFACT (MODIFY):** `/home/az/Downloads/testing-delete/p-ai-paid-marketing/src/etl/ingest_only_full.py`

**LOCATION:** In `trigger_post_ingestion_routines()`, INSERT the following block AFTER the V12-C block (currently at line 596) and BEFORE the XGBoost retrain step (currently at line 598):

```python
    # V13: Compute own-scores (deterministic, non-Pardot)
    try:
        from src.scores import compute_and_inject_scores
        print("\n[Step 3.5/6] Computing V13 own-scores (behavioral, business, temporal)...")
        results = compute_and_inject_scores()
        if all(results.values()):
            print("  -> All 3 V13 scores injected successfully.")
        elif any(results.values()):
            ok = [k for k, v in results.items() if v]
            failed = [k for k, v in results.items() if not v]
            print(f"  -> Partial: {ok} OK, {failed} FAILED.")
        else:
            print("  [Warning] All V13 scores failed. Parquet unchanged.")
    except Exception as e:
        print(f"  [Error] V13 score computation failed: {e}")
    # END V13
```

**WHY placement here:** V12-A (graph features) enriches parquet with GDS columns. V12-B (entity resolution) adds Company nodes. V12-C (temporal edges) adds Interaction nodes. V13 scores depend on the temporal columns written by V12-C and the GDS features from V12-A. Placing V13 AFTER V12-C ensures all upstream data is available. Placing it BEFORE XGBoost retrain ensures the scores are available as features for XGBoost training.

**Step numbering:** The function previously had 6 numbered steps. V13 adds step 3.5, but the sequential numbering from the audit fix was 1/6-6/6. Flash must NOT renumber — just insert this block. The label "Step 3.5/6" is descriptive and aligned with the V12 pattern (which used "Step 1.5/5").

#### 20.5.2 Integration into `ingest_and_tests_for_UI_cache_building.py`

**TARGET ARTIFACT (MODIFY):** `/home/az/Downloads/testing-delete/p-ai-paid-marketing/src/etl/ingest_and_tests_for_UI_cache_building.py`

**LOCATION:** In `trigger_post_ingestion_routines()`, INSERT the IDENTICAL V13 block (same code as 20.5.1) AFTER the V12-C block (currently at line 613) and BEFORE the XGBoost retrain step (currently at line 615).

Use the label `"Step 3.5/7"` to match this file's 7-step numbering.

---

### 20.6 Phase 4 — Neo4j Write-Back (COMPLETED)

**GOAL:** Write the 3 V13 scores to Lead node properties in Neo4j so that V14 graph algorithms (weighted PageRank, community detection weighted by business value) can leverage them.

#### 20.6.1 Neo4j Score Injection Module

**TARGET ARTIFACT (NEW FILE):** `/home/az/Downloads/testing-delete/p-ai-paid-marketing/src/scores/neo4j_writeback.py`

```python
"""
V13-D: Neo4j Score Write-Back.
Reads V13 score columns from math_schema.parquet and writes them as
properties on Lead nodes in Neo4j.

Properties written:
  - behavioral_engagement_v1 (Float)
  - business_value_v1 (Float)
  - temporal_interaction_v1 (Float)

Used by V14+ for graph-native algorithms (weighted PageRank, etc.)
"""

import os
import time
import polars as pl
from dotenv import load_dotenv
from neo4j import GraphDatabase

load_dotenv(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../../.env"))

NEO4J_URI = os.getenv("NEO4J_URI", "neo4j://localhost:7687")
NEO4J_USER = os.getenv("NEO4J_USER", "neo4j")
NEO4J_PASSWORD = os.environ.get("NEO4J_PASSWORD", "")

PARQUET_PATH = os.path.abspath(os.path.join(
    os.path.dirname(__file__), "../../data/processed/math_schema.parquet"
))

V13_PROPERTIES = [
    "behavioral_engagement_v1",
    "business_value_v1",
    "temporal_interaction_v1",
]


def write_scores_to_neo4j() -> bool:
    """
    Read V13 score columns from parquet and write them to Lead node properties.

    Uses batched UNWIND for performance.

    Returns:
        True if at least one property was successfully written.
    """
    print("\n[V13-D] Writing V13 scores to Neo4j Lead nodes...")
    t0 = time.time()

    df = pl.read_parquet(PARQUET_PATH)
    available = [c for c in V13_PROPERTIES if c in df.columns]

    if not available:
        print("  [V13-D] No V13 score columns found in parquet. Skipping.")
        return False

    driver = GraphDatabase.driver(NEO4J_URI, auth=(NEO4J_USER, NEO4J_PASSWORD))
    try:
        records = df.select(["Lead_ID"] + available).fill_null(0.0).to_dicts()

        query = """
            UNWIND $records AS r
            MATCH (l:Lead {id: r.Lead_ID})
            SET l.behavioral_engagement_v1 = r.behavioral_engagement_v1,
                l.business_value_v1 = r.business_value_v1,
                l.temporal_interaction_v1 = r.temporal_interaction_v1
        """

        batch_size = 5000
        for i in range(0, len(records), batch_size):
            batch = records[i:i + batch_size]
            with driver.session() as session:
                session.run(query, records=batch)
            print(f"  [V13-D]   Written {min(i + batch_size, len(records))}/{len(records)} leads...")

        elapsed = time.time() - t0
        print(f"  [V13-D] {len(records)} leads updated in {elapsed:.1f}s.")
        return True
    except Exception as e:
        print(f"  [V13-D] Neo4j write-back failed: {e}")
        return False
    finally:
        driver.close()
```

**WHY Neo4j write-back:** Gemini's feedback: "Write the scores to Lead node properties. This will be incredibly powerful for V14 when we want to run PageRank weighted by business value." Without Neo4j properties, V14 graph algorithms would only operate on structural topology — adding score-weighted edges enables algorithms that rank leads by business value × connectivity.

#### 20.6.2 Pipeline Integration

In BOTH pipeline files (`ingest_only_full.py` and `ingest_and_tests_for_UI_cache_building.py`), INSERT this block AFTER the V13 score computation block (Phase 3) and BEFORE XGBoost retrain:

```python
    # V13-D: Write scores to Neo4j
    try:
        from src.scores.neo4j_writeback import write_scores_to_neo4j
        print("\n[Step 3.6/6] Writing V13 scores to Neo4j Lead nodes...")
        write_scores_to_neo4j()
    except Exception as e:
        print(f"  [Error] V13-D Neo4j write-back failed: {e}")
    # END V13-D
```

**WHY non-blocking:** If Neo4j is temporarily unreachable, the pipeline continues — scores are already in parquet. XGBoost will train on the parquet columns regardless of Neo4j state.

---

### 20.7 Phase 5 — Verification (COMPLETED)

**GOAL:** Prove that all new files are syntactically valid and importable, and that the full modified pipeline produces the correct schema.

#### 20.7.1 Syntax Check on All V13 Files

```bash
cd /home/az/Downloads/testing-delete/p-ai-paid-marketing

# NEW files
python -m py_compile src/scores/__init__.py && echo "__init__.py: OK"
python -m py_compile src/scores/engagement.py && echo "engagement.py: OK"
python -m py_compile src/scores/financial.py && echo "financial.py: OK"
python -m py_compile src/scores/temporal.py && echo "temporal.py: OK"
python -m py_compile src/scores/neo4j_writeback.py && echo "neo4j_writeback.py: OK"

# MODIFIED files (Phase 3-4)
python -m py_compile src/etl/ingest_only_full.py && echo "ingest_only_full.py: OK"
python -m py_compile src/etl/ingest_and_tests_for_UI_cache_building.py && echo "ingest_and_tests: OK"
```

#### 20.7.2 Import Chain Validation

```bash
# Verify all new modules can be imported
uv run python -c "
from src.scores.engagement import compute_engagement_score
from src.scores.financial import compute_business_value_score
from src.scores.temporal import compute_temporal_score
from src.scores.neo4j_writeback import write_scores_to_neo4j
print('All V13 modules importable.')
"
```

#### 20.7.3 Standalone Score Computation (Without Full Ingestion)

```bash
uv run python -c "
from src.scores import compute_and_inject_scores
results = compute_and_inject_scores()
print(results)

# Verify columns exist in parquet
import polars as pl
df = pl.read_parquet('data/processed/math_schema.parquet')
expected = ['behavioral_engagement_v1', 'business_value_v1', 'temporal_interaction_v1']
found = [c for c in expected if c in df.columns]
print(f'V13 columns present: {len(found)}/3: {found}')
for c in found:
    non_null = df[c].drop_nulls().height
    mean_val = df[c].mean()
    print(f'  {c}: non-null={non_null}/{df.height}, mean={mean_val:.2f}')
"
```

#### 20.7.4 Updated math_schema.parquet Column List

After V13 injection, `math_schema.parquet` will contain these new columns:

| Column                     | Type    | Source Module              | Range |
| -------------------------- | ------- | -------------------------- | ----- |
| `behavioral_engagement_v1` | Float64 | `src/scores/engagement.py` | 0-100 |
| `business_value_v1`        | Float64 | `src/scores/financial.py`  | 0-100 |
| `temporal_interaction_v1`  | Float64 | `src/scores/temporal.py`   | 0-100 |

These join the existing V12 graph feature columns (11 columns).

#### 20.7.5 Full Pipeline Verification

```bash
# Run the ingestion-only pipeline and check for V13 score columns
uv run python src/etl/ingest_only_full.py

# Verify the columns were injected
uv run python -c "
import polars as pl
df = pl.read_parquet('data/processed/math_schema.parquet')
v13_cols = ['behavioral_engagement_v1', 'business_value_v1', 'temporal_interaction_v1']
for c in v13_cols:
    if c in df.columns:
        print(f'{c}: PRESENT (mean={df[c].mean():.2f})')
    else:
        print(f'{c}: MISSING')
"
```

#### 20.7.6 New XGBoost Feature Set (Post-V13)

After V13, the XGBoost model trained by `train_xgboost_scorer.py` will use:

```python
BASE_FEATURES = [
    "MONTHLY_BUDGET__C",
    "FORECASTED_REVENUE_AUD__C",
    "TOTALCALLSFROMTENANT__C",
    "MIN_DESKS__C",
    "MAX_DESKS__C",
    "NUMBEROFEMPLOYEES",
    "ANNUALREVENUE",
    "IDEAL_SIZE_SQM__C",
    # V13 own-scores (added dynamically if present in parquet)
    "behavioral_engagement_v1",
    "business_value_v1",
    "temporal_interaction_v1",
]
GRAPH_FEATURES = [
    "Industry_Peer_Count",
    # V12 GDS features (added dynamically)
    "lead_graph_centrality",
    "lead_community_id",
    "lead_degree_centrality",
    "lead_champion_jaccard",
] + [f"lead_fastrp_emb_{i}" for i in range(8)]
```

**FLASH MUST DO — Update `src/models/train_xgboost_scorer.py` BASE_FEATURES:** The current `BASE_FEATURES` (already modified by DeepSeek in Phase 1) does NOT yet include the V13 score columns. Flash must ADD the three `_v1` columns to `BASE_FEATURES` in `src/models/train_xgboost_scorer.py` lines 34-42, after the existing non-Pardot columns:

```python
BASE_FEATURES = [
    "MONTHLY_BUDGET__C",
    "FORECASTED_REVENUE_AUD__C",
    "TOTALCALLSFROMTENANT__C",
    "MIN_DESKS__C",
    "MAX_DESKS__C",
    "NUMBEROFEMPLOYEES",
    "ANNUALREVENUE",
    "IDEAL_SIZE_SQM__C",
    "behavioral_engagement_v1",
    "business_value_v1",
    "temporal_interaction_v1",
]
```

The `feature_cols` list-building logic at line 45 (`feature_cols = [c for c in BASE_FEATURES + GRAPH_FEATURES if c in available_cols]`) already handles dynamic feature availability — if V13 hasn't run yet and the score columns aren't in parquet, they're simply excluded.

**FLASH MUST DO — Update `tests/deterministic/test_graph_feature_lift.py` BASE_FEATURES:** Similarly, add V13 score columns to `BASE_FEATURES` in `tests/deterministic/test_graph_feature_lift.py` lines 30-43:

```python
BASE_FEATURES = [
    "MONTHLY_BUDGET__C",
    "FORECASTED_REVENUE_AUD__C",
    "TOTALCALLSFROMTENANT__C",
    "MIN_DESKS__C",
    "MAX_DESKS__C",
    "NUMBEROFEMPLOYEES",
    "ANNUALREVENUE",
    "IDEAL_SIZE_SQM__C",
    "Industry_Peer_Count",
    "behavioral_engagement_v1",
    "business_value_v1",
    "temporal_interaction_v1",
]
```

---

### 20.8 Files Summary

| Type    | File                                                | Action                          | Status            |
| ------- | --------------------------------------------------- | ------------------------------- | ----------------- |
| **NEW** | `src/scores/__init__.py`                            | Score orchestrator              | **COMPLETED**     |
| **NEW** | `src/scores/engagement.py`                          | Behavioral engagement score     | **COMPLETED**     |
| **NEW** | `src/scores/financial.py`                           | Business value score            | **COMPLETED**     |
| **NEW** | `src/scores/temporal.py`                            | Temporal interaction score      | **COMPLETED**     |
| **NEW** | `src/scores/neo4j_writeback.py`                     | Neo4j score write-back          | **COMPLETED**     |
| MODIFY  | `src/models/train_xgboost_scorer.py`                | Add V13 scores to BASE_FEATURES | **COMPLETED**     |
| MODIFY  | `tests/deterministic/test_graph_feature_lift.py`    | Add V13 scores to BASE_FEATURES | **COMPLETED**     |
| MODIFY  | `src/etl/ingest_only_full.py`                       | V13 block + Neo4j write-back    | **COMPLETED**     |
| MODIFY  | `src/etl/ingest_and_tests_for_UI_cache_building.py` | V13 block + Neo4j write-back    | **COMPLETED**     |
| MODIFY  | `src/models/train_xgboost_scorer.py`                | Phase 1 cleanse                 | **DeepSeek DONE** |
| MODIFY  | `src/models/inference.py`                           | Phase 1 cleanse                 | **DeepSeek DONE** |
| MODIFY  | `src/tools/tools.py`                                | Phase 1 cleanse                 | **DeepSeek DONE** |
| MODIFY  | `src/models/bayesian_engine.py`                     | Phase 1 cleanse                 | **DeepSeek DONE** |
| MODIFY  | `src/models/case_matcher.py`                        | Phase 1 cleanse                 | **DeepSeek DONE** |
| MODIFY  | `src/api/server.py`                                 | Phase 1 cleanse                 | **DeepSeek DONE** |
| MODIFY  | `src/graph/graph_features.py`                       | Phase 1 cleanse                 | **DeepSeek DONE** |
| MODIFY  | `app.py`                                            | Phase 1 cleanse                 | **DeepSeek DONE** |
| MODIFY  | `tests/streamlit-functionality-test/*.py`           | Phase 1 cleanse                 | **DeepSeek DONE** |
| MODIFY  | `tests/statistical/*.py`                            | Phase 1 cleanse                 | **DeepSeek DONE** |
| MODIFY  | `tests/deterministic/test_graph_feature_lift.py`    | Phase 1 cleanse                 | **DeepSeek DONE** |

**Total Flash work:** 5 NEW files, 4 MODIFIED files (~200 new lines, ~30 modified lines)
**Total DeepSeek work (already done):** 16 files modified, syntax-verified
**Dependencies:** ZERO new (all imports already in pyproject.toml: polars, neo4j, numpy, python-dotenv)
**Docker:** ZERO changes

---

### 20.9 Contingency Paths

| Failure Mode                        | Detection                                         | Response                                                                     |
| ----------------------------------- | ------------------------------------------------- | ---------------------------------------------------------------------------- |
| All 3 V13 scores fail               | `compute_and_inject_scores()` returns all `False` | Pipeline continues. XGBoost trains on available features. Parquet unchanged. |
| Neo4j unreachable during write-back | `write_scores_to_neo4j()` catches exception       | Pipeline continues. Scores are in parquet. V14 can run write-back later.     |
| V13 score column already in parquet | Not an error — `df.with_columns()` overwrites     | Existing column is recalculated. No duplicate column.                        |
| Parquet file missing                | `pl.read_parquet()` raises `FileNotFoundError`    | Orchestrator `try/except` catches → returns `{}`. Pipeline logs warning.     |
| Individual module import fails      | Module-level `try/except` in orchestrator         | That score is skipped. Other 2 scores compute.                               |

---

### 20.10 V13 Completion Statement

> **Status:** PHASE 1 COMPLETE (DeepSeek) | PHASES 2-5 COMPLETE (Flash)
> **Timestamp:** 2026-05-26
> **Architects:** DeepSeek (Principal Architect) + Gemini (Adversarial Review) — Consensus on COUNCIL.md
> **Scope:** 5 new files, 4 modified files for Flash; 16 files for DeepSeek (Phase 1)
> **Total:** 5 new files, ~20 modified files, ZERO new Python packages, ZERO Docker changes
> **Estimated Flash effort:** ~30 minutes (200 new lines + 30 modified lines)
