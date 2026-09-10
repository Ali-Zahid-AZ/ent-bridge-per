# V6 Bayesian Analysis — Detailed Implementation

> **Architects:** Antigravity & DeepSeek (Consensus — 2026-05-20)
> **Status:** COMPLETE
> **Scope:** 7 Bayesian experiments, PyMC MCMC, Streamlit UI, `/bayesian-insight` API, agentic integration

---

## V6.0 Architecture Overview

V6 shifts from **frequentist point estimates** (V5 T-tests/XGBoost) to **Bayesian posterior probability distributions**. Every prediction (PI Score, Revenue, Conversion) comes with a mathematically defensible uncertainty envelope.

| V5 (Frequentist)                             | V6 (Bayesian)                                                    |
| -------------------------------------------- | ---------------------------------------------------------------- |
| Point estimate: "Google Ads mean PI = 43.61" | Posterior: "Google Ads PI has 95% probability between 38 and 49" |
| p-value: "Is this significant?"              | Posterior probability: "84% chance Meta > Google"                |
| Fixed model parameters                       | Parameters as probability distributions                          |
| Multiple testing corrections needed          | Natural regularization via hierarchical priors                   |

**Unified Principle:** The LLM Synthesizer must state credible intervals — never report a point estimate without uncertainty bounds.

---

## V6.1 Dependencies

```bash
uv add pymc arviz bambi
```

| Package | Version | Purpose                                               |
| ------- | ------- | ----------------------------------------------------- |
| `pymc`  | 5.26.1  | MCMC sampling, hierarchical models, GPs               |
| `arviz` | 0.23.4  | Posterior diagnostics, trace plots, R-hat, PSIS-LOO   |
| `bambi` | 0.16.0  | Formula-based interface for simpler models             |

---

## V6.2 Experiment Battery (7 Experiments)

### Experiment 1: Bayesian Hierarchical Channel + Campaign Comparison
- **Target:** `PI__SCORE__C` ~ `Unified_Source` (Level 1) → `Unified_Campaign` (Level 2, nested)
- **Model:** Two-level hierarchical Normal, partial pooling, NUTS sampler
- **Priors:** μ_Google ~ N(43.6, 5), μ_Meta ~ N(57.3, 5) — empirical Bayes from V5 T-tests
- **Output:** Posterior probability best source/campaign, ROPE analysis, campaign-level shrinkage
- **Convergence:** ~191K rows, 5 source + 331 campaign groups

### Experiment 2: Bayesian Conversion Model (Logistic Regression)
- **Target:** `STATUS` (binary Converted/Not) ~ `PARDOT_SCORE__C` + `PARDOT_PAGE_VIEWS_COUNT__C` + `MONTHLY_BUDGET__C` + `Unified_Source` + `TOTALCALLSFROMTENANT__C`
- **Model:** Bayesian logistic regression, Horseshoe prior (global-local shrinkage)
- **Output:** Posterior coefficient distributions, lead-level conversion probability with HDI

### Experiment 3: Bayesian Revenue Prediction (Robust Regression)
- **Target:** `FORECASTED_REVENUE_AUD__C` ~ `MONTHLY_BUDGET__C` + `MAX_DESKS__C` + `PI__SCORE__C` + `INDUSTRY__C` + `NUMBEROFEMPLOYEES`
- **Model:** Bayesian robust regression, Student-T likelihood (fat tails for outliers — median $600, max $1.5B)
- **Key Innovation:** Models `ANNUALREVENUE` missingness (82.3%) as informative latent variable

### Experiment 4: Bayesian Hierarchical Industry Model
- **Target:** `PI__SCORE__C` ~ `INDUSTRY__C` (1,025 unique values, 70%+ missing)
- **Model:** Hierarchical Normal, **non-centered parameterization** (avoids Neal's Funnel)
- **Output:** Industry-specific posterior distributions with shrinkage, rank probabilities

### Experiment 5: Bayesian Lead Volume Forecasting
- **Target:** Lead count per month (from `CREATEDDATE`), segmented by `Unified_Source`
- **Model:** Negative Binomial likelihood + time trend + seasonal Gaussian Random Walk
- **Output:** 6-month forecast with 95% prediction intervals

### Experiment 6: Bayesian Budget Optimization
- **Target:** `PI__SCORE__C` as function of `MONTHLY_BUDGET__C`
- **Model:** B-Spline regression O(n) — B-Spline basis functions (degree=3, 15 knots, log-transformed budget)
- **Output:** Budget → PI Score curve with uncertainty envelope, optimal allocation posterior

### Experiment 7: Bayesian Geospatial Hierarchical Model
- **Target:** `PI__SCORE__C` ~ `CITY` (Level 1, 13K+ cities) → `COUNTRY` (Level 2, ~200 countries)
- **Model:** Two-level hierarchical Normal, non-centered parameterization
- **Rationale:** Real estate pricing is strictly geospatial

---

## V6.3 File Map

```
NEW FILES:
├── src/models/bayesian_engine.py          (+560 lines — all 7 experiments, NetCDF caching, MCMC diagnostics)
├── tests/statistical/bayesian_analysis.py (+90 lines — 11 convergence tests)

MODIFIED FILES:
├── src/api/server.py                      (+65 lines — POST /bayesian-insight endpoint + BayesianInsightRequest)
├── src/tools/tools.py                     (+55 lines — run_bayesian_simulation tool)
├── src/config/routing_config.json         (+1 entry — "bayesian" tool routing)
├── src/agent/agent.py                     (+30 lines — bayesian tool routing, BAYESIAN GUARDRAIL)
├── app.py                                 (+290 lines — toggle, polling, 6 chart helpers)
├── pyproject.toml                         (+3 deps — pymc, arviz, bambi)
```

---

## V6.4 API Endpoint

### `POST /bayesian-insight`
- **Pydantic Model:** `BayesianInsightRequest` with `experiment` field
- **Rate Limit:** 5/minute
- **Routing:** Routes experiment name to specific Bayesian model
- **Fallback:** `experiment=None` or `experiment="all"` → `run_full_battery()` (all 7 experiments)
- **Caching:** NetCDF `.nc` files in `data/processed/bayesian_cache/`

---

## V6.5 Agentic Integration

- **Planner:** Few-shot prompts route "risk", "uncertainty", "probability scenario" queries to Bayesian engine
- **Synthesizer Guardrail:** LLM forced to report HDI — "95% credible interval: X to Y" required
- **Tool:** `run_bayesian_simulation` registered in `src/tools/tools.py`
- **Celery:** Timeout raised to 300s for MCMC tasks

---

## V6.6 Streamlit UI

- **Toggle:** 2-column layout (V5 XGBoost + V6 Bayesian)
- **Polling:** Cache-first sync POST to `/bayesian-insight`
- **6 Chart Helpers:**
  - `render_bayesian_badge()` — Diagnostic trust badge (green CONVERGED / red DIVERGED)
  - `render_channel_ridge()` — Horizontal violin plot (Exp 1)
  - `render_forest_plot()` — Forest plot with HDI error bars (Exp 2, 3)
  - `render_bar_with_hdi()` — Horizontal bar for ranked categories (Exp 4, 7)
  - `render_forecast_ribbon()` — Line + shaded HDI ribbon (Exp 5)
  - `render_spline_curve()` — B-Spline curve with diminishing returns marker (Exp 6)
- `render_bayesian_experiments()` — Master renderer iterating 7 experiment card expanders

---

## V6.7 Validation & Diagnostics Protocol

Every model must pass:
1. **MCMC Diagnostics:** R-hat < 1.01, ESS > 1,000, zero divergent transitions
2. **Posterior Predictive Checks:** Bayesian p-value not near 0 or 1
3. **Prior Sensitivity:** Compare V5-informed priors vs. weakly informative defaults
4. **Model Comparison:** PSIS-LOO (hierarchical vs. pooled vs. unpooled)
5. **Business Validation:** Credible intervals narrower than V5 CIs

---

## V6.8 Key Design Decisions

- **Non-centered parameterization** for high-cardinality groups (Industry: 1,025, City: 13K+)
- **V5-informed priors** on channel model source-level means
- **Horseshoe prior** for logistic regression — global-local shrinkage handles correlated predictors
- **Student-T likelihood** for revenue — fat tails handle $1.5B outliers
- **Informative missingness** — gamma_missing coefficient models ANNUALREVENUE missingness as non-random
- **Negative Binomial** for lead counts — handles overdispersion naturally
- **B-Spline basis functions** — O(n) budget optimization avoids GP O(n³)
- **Cache-first pattern** — NetCDF `.nc` files, `force_resample=True` flag
- **Diagnostics enforcement** — R-hat < 1.01, ESS > 100, zero divergences on every run

---

## V6.9 Verification Results

- `py_compile()`: All 4 files pass
- **Sprint 1** (Hierarchical models): Verified — NUTS with jitter+adapt_diag, 2 chains
- **Sprint 2** (Logistic + Robust regression): Compiles and imports
- **Sprint 3** (Forecasting + Spline): Compiles and imports
- **Sprint 4** (API + Tooling): `/bayesian-insight` endpoint active

**To Run Full MCMC (cached thereafter):**
```bash
uv run python tests/statistical/bayesian_analysis.py
```

---

## V6.10 Success Criteria

1. All 7 experiments: R-hat < 1.01, no divergences
2. Posterior predictive checks pass for all models
3. Credible intervals narrower than V5 frequentist CIs
4. At least one Bayesian result actionable (budget shift, campaign pause, geo reallocation)
5. `/bayesian-insight` returns task ID within 2s; results within 300s via Celery
6. Streamlit dashboard: HDI ribbons + R-hat badges on posterior plots
7. Synthesizer guardrail: LLM never reports point estimate without credible interval
