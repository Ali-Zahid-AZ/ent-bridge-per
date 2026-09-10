# V7 Advanced Statistical Analysis — Detailed Implementation

> **Architects:** DeepSeek & Gemini (Consensus — 2026-05-21)
> **Status:** COMPLETE
> **Scope:** 17 statistical tests across 6 sprints, 5 API endpoints, 6 Streamlit dashboard sections, 1 new dependency (`lifelines`)
> **Consensus:** Hybrid delivery — standalone scripts first, then API/UI for high-impact tests.

---

## V7.0 Architecture Overview

V7 transitions the platform from V6 correlation and simple testing to rigorous causal inference, omnibus testing, and time-to-event tracking (Survival Analysis). It shifts from individual lead scoring to segment-based archetypes and handles right-censored CRM data appropriately.

**Output format:** `[Executive Summary] + [statistical-test] + [guru_analysis]`

---

## V7.1 Dependencies

```bash
uv add lifelines
```

| Package     | Version | Purpose                             |
| ----------- | ------- | ----------------------------------- |
| `lifelines` | 0.30.3  | Survival analysis (Kaplan-Meier, Cox PH) |

Zero-bloat strategy: avoided heavy packages (`statsmodels`, `pysal`, `geopandas`, `ruptures`) by implementing CUSUM, PSM, SMD, and VIF manually using `numpy`, `scipy`, and `sklearn`.

---

## V7.2 Complete Test Inventory (17 Tests)

### Sprint 7.1 — Survival Analysis (4 tests)
| Test | Name                         | Purpose                                                                     |
| ---- | ---------------------------- | --------------------------------------------------------------------------- |
| 1a   | Kaplan-Meier Curves          | Non-parametric survival curves per Unified_Source — lead conversion timing  |
| 1b   | Pairwise Log-Rank Tests      | Statistical comparison of survival distributions between marketing channels |
| 1c   | Cox Proportional Hazards     | Semi-parametric regression — which features accelerate/decelerate conversion |
| 1d   | Lead Decay Analysis          | Conversion rate by lead age bucket — "when to stop following up"            |

### Sprint 7.2 — Categorical Association (3 tests)
| Test | Name                         | Purpose                                                                     |
| ---- | ---------------------------- | --------------------------------------------------------------------------- |
| 2a   | Chi-Square Independence      | Source × Industry independence test with Cramér's V effect size             |
| 2b   | Kruskal-Wallis H-Test        | Omnibus PI Score comparison across channels (non-parametric)                |
| 2c   | One-Way ANOVA + Eta-Squared  | Parametric complement to KW — effect size quantification                    |

### Sprint 7.3 — Clustering & Segmentation (5 tests)
| Test | Name                         | Purpose                                                                     |
| ---- | ---------------------------- | --------------------------------------------------------------------------- |
| 3a   | PCA Dimensionality Reduction | Latent structure of lead features — how many independent dimensions?        |
| 3b   | K-Means Segmentation         | Customer archetypes with auto-K silhouette optimization                     |
| 3c   | DBSCAN Geographic Clustering | Spatial hotspots from LATITUDE/LONGITUDE — natural sales territories       |
| 3d   | RFM Segmentation             | Recency-Frequency-Monetary — Champions, At-Risk, Lost lead classification   |
| 3e   | Rent Elasticity (OLS)        | Per-desk rent cost estimation with per-cluster analysis                     |

### Sprint 7.4 — Causal Inference & Regression (4 tests)
| Test | Name                         | Purpose                                                                     |
| ---- | ---------------------------- | --------------------------------------------------------------------------- |
| 4a   | Propensity Score Matching    | Causal effect of tours on conversion — SMD balance diagnostics              |
| 4b   | ATT (Tour Conversion)        | Average Treatment Effect on the Treated — +X% conversion lift from tours    |
| 5a   | Ridge, Lasso, ElasticNet     | Regularized regression comparison — robust feature importance               |
| 5b   | Interaction Effects          | Polynomial interaction ranking — super-additive feature combinations        |
| 5c   | VIF Multicollinearity        | Variance Inflation Factor — identify redundant features                     |

### Sprint 7.5 — Time Series (2 tests)
| Test | Name                         | Purpose                                                                     |
| ---- | ---------------------------- | --------------------------------------------------------------------------- |
| 6a   | Seasonal Decomposition       | Additive decomposition of monthly lead volume — trend, seasonality, residual |
| 6b   | CUSUM Changepoint Detection  | Iterative structural break detection in lead generation time series          |

### Sprint 7.6 — PH Qualification (1 test)
| Test | Name                         | Purpose                                                                     |
| ---- | ---------------------------- | --------------------------------------------------------------------------- |
| 7a   | PH Feature Importance        | XGBoost + SHAP on PropTech `PH_*` qualification columns — which fields matter |

---

## V7.3 File Map

```
NEW FILES:
├── tests/statistical/survival_analysis.py             (~400 lines — tests 1a-d)
├── tests/statistical/categorical_analysis.py          (~300 lines — tests 2a-c)
├── tests/statistical/clustering_segmentation.py       (~500 lines — tests 3a-e)
├── tests/statistical/causal_regression.py             (~500 lines — tests 4a-d, 5a-c)
├── tests/statistical/timeseries_analysis.py           (~250 lines — tests 6a-b)
├── tests/statistical/ph_feature_importance.py         (~200 lines — test 7a)
├── data/processed/v7_cache/                           (directory — JSON cache files)

MODIFIED FILES:
├── src/api/server.py                                  (+200 lines — 5 new endpoints + 5 Pydantic models)
├── app.py                                             (+600 lines — 6 new sections + 18 render functions)
├── pyproject.toml                                     (+1 dep — lifelines)
└── IMPLEMENTATION-PLAN.md                             (Section 14)
```

---

## V7.4 API Endpoints (5 new)

| Method | Endpoint             | Purpose                                                  | Rate Limit |
| ------ | -------------------- | -------------------------------------------------------- | ---------- |
| `POST` | `/survival-curves`    | Kaplan-Meier survival curves per channel                 | 10/min     |
| `POST` | `/cox-model`          | Cox Proportional Hazards model results                   | 10/min     |
| `POST` | `/chi-square`         | Chi-Square independence + Cramér's V                     | 30/min     |
| `POST` | `/kmeans-segments`    | PCA, K-Means, DBSCAN, RFM, Rent Elasticity               | 10/min     |
| `POST` | `/psm-analysis`       | PSM, Ridge/Lasso/ElasticNet, VIF                         | 5/min      |

All endpoints feature Pydantic validation, tiered `slowapi` rate limiting, cache-first JSON retrieval, and LangFuse `@observe` tracing.

---

## V7.5 Streamlit UI (6 new sections)

| Section | V7 Test Battery                       | Toggle Control | Content                                                                     |
| ------- | ------------------------------------- | -------------- | --------------------------------------------------------------------------- |
| 8       | Survival Analysis                     | Toggle         | KM curves, Log-Rank p-values, Cox PH hazard ratios, Lead Decay table        |
| 9       | Categorical Analysis                  | Toggle         | Chi-Square + Cramér's V, KW p-values, ANOVA eta-squared                     |
| 10      | Customer Segmentation                 | Toggle         | PCA scree plot, K-Means silhouette, DBSCAN clusters, RFM segments           |
| 11      | Causal Inference + Regression         | Toggle         | PSM ATT, SMD diagnostics, ElasticNet coefficients, VIF table                |
| 12      | Time Series                           | Toggle         | Seasonal decomposition chart, CUSUM changepoint markers                     |
| 13      | PH Qualification                      | Toggle         | SHAP feature importance for PH_* fields, null-rate report                   |

Features: toggle controls, progressive disclosure (`st.expander`), diagnostic badges (PASS/FAIL), metric cards, and visual plots (Plotly for complex/interactive, Altair for simple/fast).

---

## V7.6 Build Methodology

1. **Standalone Scripts:** Data load, statistical computation, cache writing, text logging, LangFuse tracing, and terminal output.
2. **API Endpoints:** Request validation, rate-limiting, cache-checks, and script execution.
3. **UI Rendering:** Progressive disclosure expanders, badges, charts, and key metrics tables.

---

## V7.7 Key Test Implementations

### Kaplan-Meier
- `lifelines.KaplanMeierFitter` per Unified_Source group
- Duration = days from `CREATEDDATE` to `CONVERTEDDATE` (or max observed date for censored)
- Event_observed = 1 if `CONVERTEDDATE` is non-null
- Reports median survival time per channel

### PSM (Propensity Score Matching)
- `sklearn.linear_model.LogisticRegression` for propensity scores from 5 balance covariates
- `sklearn.neighbors.NearestNeighbors` for 1:1 matching
- SMD computed from scratch using pooled standard deviation
- Before/after max |SMD| and per-covariate SMD reported

### PCA
- `sklearn.preprocessing.StandardScaler` on 10 core numeric features
- `sklearn.decomposition.PCA` on standardized data
- Top-3 loadings per PC reported with cumulative variance

### K-Means
- `sklearn.cluster.KMeans` on StandardScaler-transformed features
- Silhouette score for k=2..8, best k by maximum silhouette
- Cluster centers inverse-transformed for interpretation

### DBSCAN
- LAT/LON from raw CSV via `pl.scan_csv().columns`
- Sampled to 30K for performance, standardized before clustering
- `sklearn.cluster.DBSCAN`, epsilon ≈ 0.5 km (radians), min_samples=10

### CUSUM Changepoints
- Iterative algorithm: compute CUSUM, find max absolute, threshold = 0.8 * sigma * sqrt(n)
- Remove detected break, repeat up to 5 iterations
- Before/after means reported per changepoint

### Seasonal Decomposition
- Manual additive decomposition: centered moving average for trend, within-period averaging for seasonal
- Period auto-set to min(12, n_months/2)
- Seasonality variance ratio = var(seasonal) / var(original)

---

## V7.8 Validation Protocol

- Null handling: PH_* columns filtered at >85% nulls; remaining filled with 0
- Minimum sample size: >30 observations per group for statistical tests
- Cache integrity: JSON serialization/deserialization verified
- Diagnostic thresholds: K-Means silhouette > 0.3 (good), VIF < 10 (acceptable)
- End-to-end: endpoint → cache → UI rendering verified for all 5 APIs

---

## V7.9 Risk Mitigation

- **PH_* sparsity:** >85% null filtration; excluded columns don't enter model
- **DBSCAN memory:** Nearest-neighbor sampling to 30K rows prevents O(n²) crash on 191K rows
- **CUSUM dependency:** Manual implementation avoids `ruptures` package dependency
- **K-Means fallback:** If no natural clusters (silhouette < 0), reports "homogeneous data" instead of forcing segments

---

## V7.10 Verification

- `py_compile()`: All 6 test scripts pass syntax check
- **Cache:** JSON files written to `data/processed/v7_cache/`
- **Logs:** Timestamped logs in `logs/statistical_tests/`
- **Observability:** `@observe` LangFuse tracing on all 6 main entry functions
- **Gemini Review:** Architecture approved, zero-bloat dependency management praised

---

## V7.11 Success Criteria

1. All 17 tests execute successfully on 191K-row dataset
2. Zero new C-extension dependencies beyond `lifelines`
3. Clear actionable business insights per test
4. Cached API responses under 2 seconds
5. All traces appear in LangFuse
6. 5 API endpoints return valid JSON with Pydantic validation
7. 6 Streamlit sections render with toggle controls and expanders
8. Diagnostic badges (PASS/FAIL) reflect actual diagnostic outcomes
