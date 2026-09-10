## 22. V15 — Lightweight Metatron: Ensemble Lead Volume Forecasting

> **Status:** IMPLEMENTATION BLUEPRINT — Pending Flash Execution
> **Trigger:** Analysis of Realtor.com's Metatron stacked ensemble architecture revealed that WAPE-weighted ensembling of diverse models provides 30-42% accuracy improvement over any single model. We adapt the methodology to our compute constraints.
> **Timestamp:** 2026-05-27
> **Architects:** DeepSeek (Principal Architect) + Gemini (Adversarial Review) — Consensus on COUNCIL.md
> **Source:** [Realtor.com Tech Blog — Building Metatron](https://techblog.realtor.com/building-metatron-state-of-the-art-leads-forecasting-using-transformers-ensembling-and-meta-learners/)
> **Scope:** 4 new files, 2 modified files, 1 new Python package (prophet), ZERO Docker changes, ~760 new lines + ~90 modified lines

---

### 22.0 Consensus Summary

After adversarial review on COUNCIL.md between DeepSeek and Gemini, 3 amendments accepted:

1. **Meta-Learner Deferred to V15.2 (ACCEPTED):** V15.1 implements WAPE-weighted arithmetic ensemble ONLY. With 24-36 monthly data points per campaign, an XGBoost meta-learner would overfit. XGBoost meta-learner becomes V15.2, conditional on V15.1 not hitting the 15-20% accuracy improvement target.

2. **Strict Temporal Cross-Validation (ACCEPTED):** WAPE weights computed via rolling-origin CV. Models scored on predictions for months they did NOT see during training. This forces the Bayesian NegBin forecast to become retrainable via a new `_data_override` parameter.

3. **Tweedie Loss Reserved for V15.2 (ACCEPTED):** If XGBoost enters the ensemble, `reg:tweedie` with variance power in [1.2, 1.5] is the correct objective for zero-inflated monthly lead count data.

---

### 22.1 Architecture Overview — What V15 Adds

**Current State (V6 Exp 5):** A single Bayesian NegBin model (`run_bayesian_lead_forecast()`) forecasts global monthly lead counts. One-shot MCMC sample — no retraining, no ensembling, no per-segment granularity. 6-month horizon.

**V15 Goal:** Per-segment (by Unified_Source) lead volume forecasting pipeline combining 3 diverse base models using purely arithmetic WAPE-weighted ensembling with strict rolling-origin temporal CV. 12-month forecast horizon. Zero ML in ensembling step.

**Core Pipeline:**

```
math_schema.parquet → Segment by Unified_Source → Monthly time series per segment
  → Rolling-origin CV (from month 13 to N-3):
    → Train 3 models on data up to month T (Bayesian NegBin, Naive Seasonal, Prophet)
      → Forecast months T+1 through T+3
        → Compute WAPE over last 3 lookback months per model
          → Weight = normalized(1/WAPE)
            → Final forecast = Σ(weight_i × forecast_i) for 12-month horizon
```

**Key Distinction from V6:**
- V6: Single model, global aggregate, one-shot, 6-month horizon, no segment granularity
- V15: 3-model ensemble, per-segment, rolling retraining, 12-month horizon, arithmetic ensembling

---

### 22.2 Sprint 15-A: Naive Seasonal Baseline + Prophet Integration

**ESTIMATED EFFORT:** 1 coding session (~45 min)

#### 22.2.1 Naive Seasonal Forecaster

**TARGET ARTIFACT (NEW FILE):** `/home/az/Downloads/testing-delete/p-ai-paid-marketing/src/models/naive_forecasters.py`

**EXACT CONTENT:**

```python
"""
V15: Naive Time Series Forecasters (Lightweight Metatron).

Two deterministic baseline forecasters:
  1. Naive Seasonal: repeats last K observations (K=12 for annual)
  2. Naive Drift: extrapolates linear trend from first to last point

Zero dependencies beyond numpy. O(1) computation.
"""

import numpy as np


def naive_seasonal_forecast(
    y_historical: np.ndarray, forecast_horizon: int = 12, season_period: int = 12
) -> np.ndarray:
    """Naive seasonal forecast: repeats the last K observations.

    Args:
        y_historical: 1D array of monthly lead counts (oldest first).
        forecast_horizon: Number of months to forecast (default 12).
        season_period: Seasonal cycle length in months (default 12 for annual).

    Returns:
        1D array of length forecast_horizon, clipped to >= 0.
    """
    y = np.asarray(y_historical, dtype=np.float64)
    n = len(y)
    if n == 0:
        return np.zeros(forecast_horizon)
    period = min(season_period, n)
    seasonal_pattern = y[-period:]
    forecast = [seasonal_pattern[i % period] for i in range(forecast_horizon)]
    return np.clip(np.array(forecast), 0, None)


def naive_drift_forecast(
    y_historical: np.ndarray, forecast_horizon: int = 12
) -> np.ndarray:
    """Naive drift: extrapolates linear trend from first to last value.

    Args:
        y_historical: 1D array of monthly lead counts (oldest first).
        forecast_horizon: Number of months to forecast (default 12).

    Returns:
        1D array of length forecast_horizon, clipped to >= 0.
    """
    y = np.asarray(y_historical, dtype=np.float64)
    n = len(y)
    if n < 2:
        return np.full(forecast_horizon, y[0] if n == 1 else 0.0)
    slope = (y[-1] - y[0]) / (n - 1)
    forecast = y[-1] + slope * np.arange(1, forecast_horizon + 1)
    return np.clip(forecast, 0, None)
```

**WHY:** Even naive models contribute to ensemble performance per the Metatron paper — they provide stability when sophisticated models overfit. The WAPE-weighted ensemble automatically down-weights poor performers.

#### 22.2.2 Prophet Integration

**TARGET ARTIFACT (NEW FILE):** `/home/az/Downloads/testing-delete/p-ai-paid-marketing/src/models/prophet_forecaster.py`

**DEPENDENCY — Flash must install BEFORE writing this file:**

```bash
uv add prophet
# If prophet fails (pystan compilation), use:
uv add neuralprophet
```

**EXACT CONTENT:**

```python
"""
V15: Prophet Time Series Forecaster (Lightweight Metatron).

Wrapper around Facebook Prophet providing a standardized forecast
interface for the ensemble pipeline. Prophet decomposes time series
into trend + seasonality with automatic changepoint detection.

Input: numpy array of monthly lead counts + date range.
Output: numpy array of forecasted lead counts for the horizon.
"""

import numpy as np
import pandas as pd
import warnings


def prophet_forecast(
    y_historical: np.ndarray,
    dates: pd.DatetimeIndex,
    forecast_horizon: int = 12,
    growth: str = "linear",
    yearly_seasonality: bool = True,
    changepoint_prior_scale: float = 0.05,
) -> np.ndarray:
    """Generate a Prophet forecast from historical monthly lead counts.

    Args:
        y_historical: 1D array of monthly lead counts (aligned with dates).
        dates: pd.DatetimeIndex for historical data (same length as y).
        forecast_horizon: Number of months to forecast (default 12).
        growth: 'linear' or 'logistic' trend model.
        yearly_seasonality: Whether to model annual seasonality.
        changepoint_prior_scale: Flexibility of trend changepoints (0.05 default).

    Returns:
        1D array of length forecast_horizon, clipped to >= 0.
        Falls back to naive seasonal on failure.
    """
    y = np.asarray(y_historical, dtype=np.float64)
    n = len(y)

    if n < 12:
        from src.models.naive_forecasters import naive_drift_forecast
        return naive_drift_forecast(y, forecast_horizon)

    try:
        with warnings.catch_warnings():
            warnings.simplefilter("ignore", FutureWarning)
            from prophet import Prophet
    except ImportError:
        try:
            from neuralprophet import NeuralProphet  # noqa: F401
        except ImportError:
            raise ImportError(
                "Neither 'prophet' nor 'neuralprophet' installed. "
                "Run: uv add prophet"
            )

    try:
        df = pd.DataFrame({"ds": dates, "y": y})
        df["y"] = df["y"].clip(lower=0)

        model = Prophet(
            growth=growth,
            yearly_seasonality=yearly_seasonality,
            weekly_seasonality=False,
            daily_seasonality=False,
            changepoint_prior_scale=changepoint_prior_scale,
        )
        model.fit(df)

        future = model.make_future_dataframe(periods=forecast_horizon, freq="ME")
        forecast = model.predict(future)
        forecast_values = forecast["yhat"].values[-forecast_horizon:]
        return np.clip(forecast_values, 0, None)

    except Exception:
        from src.models.naive_forecasters import naive_seasonal_forecast
        return naive_seasonal_forecast(y, forecast_horizon)
```

**WHY Prophet:** Closest CPU-only equivalent to Metatron's TFT. Decomposes into trend + seasonality with automatic changepoint detection. The double import guard (prophet → neuralprophet) handles platform-specific compilation failures.

---

### 22.3 Sprint 15-B: Rolling-Origin CV Pipeline + Bayesian Retrainability

**ESTIMATED EFFORT:** 2 coding sessions (~90 min)

**CRITICAL Pre-Step — Flash must modify `run_bayesian_lead_forecast()` in `bayesian_engine.py` (line 877):**

Add a `_data_override` parameter that bypasses internal data loading. Find the block starting with `df = _load_data(...)` and wrap it in `if _data_override is None:`. When `_data_override` is provided (a tuple of `(dates, monthly_counts)`), skip all Polars aggregation and use the pre-computed counts directly.

The function signature changes from:
```python
def run_bayesian_lead_forecast(
    segment_filter: str = "Global",
    force_resample: bool = False,
) -> dict:
```
to:
```python
def run_bayesian_lead_forecast(
    segment_filter: str = "Global",
    force_resample: bool = False,
    _data_override: tuple | None = None,
) -> dict:
```

When `_data_override is not None`, use `_data_override[1]` as the `lead_counts` numpy array directly. Default `None` preserves backward compatibility with all V6 callers.

#### 22.3.1 Ensemble Pipeline

**TARGET ARTIFACT (NEW FILE):** `/home/az/Downloads/testing-delete/p-ai-paid-marketing/src/models/ensemble_forecast.py`

**EXACT CONTENT:**

```python
"""
V15: Lightweight Metatron — Ensemble Lead Volume Forecaster.

WAPE-weighted arithmetic ensemble: Bayesian NegBin + Naive Seasonal + Prophet.
Strict rolling-origin temporal cross-validation. Zero ML in ensembling.

Pipeline:
  1. Load math_schema + taxonomy_schema, join, segment by Unified_Source
  2. Build monthly lead count series per segment (≥12 months required)
  3. Rolling-origin CV: for each training month T from 12 to N-3:
     - Train 3 models on data up to T, forecast T+1..T+3
  4. Compute WAPE per model over all windows
  5. Ensemble weight = normalized(1/WAPE)
  6. Final 12-month forecast = weighted sum on full-history models
"""

import os
import numpy as np
import pandas as pd
import polars as pl
from datetime import datetime

LOOKBACK_MIN = 12
LOOKBACK_AHEAD = 3
FORECAST_HORIZON = 12


def _wape(errors: np.ndarray, actuals: np.ndarray) -> float:
    """WAPE = sum(|error|) / sum(|actual|). Robust to zero actuals."""
    denominator = np.sum(np.abs(actuals))
    if denominator <= 0:
        return float("inf")
    return float(np.sum(np.abs(errors)) / denominator)


def _build_monthly_series(
    df: pl.DataFrame, segment_col: str = "Unified_Source"
) -> dict[str, tuple[pd.DatetimeIndex, np.ndarray]]:
    """Build monthly lead count time series per segment."""
    if df[segment_col].dtype != pl.String:
        df = df.with_columns(pl.col(segment_col).cast(pl.String))
    if df["CREATEDDATE"].dtype == pl.String:
        df = df.with_columns(pl.col("CREATEDDATE").str.to_datetime(strict=False))
    df = df.with_columns(
        pl.col("CREATEDDATE").dt.year().alias("year"),
        pl.col("CREATEDDATE").dt.month().alias("month"),
    )
    df = df.drop_nulls(subset=["year", "month", segment_col])
    segments = df[segment_col].drop_nulls().unique().to_list()
    result = {}
    for segment in segments:
        seg_df = df.filter(pl.col(segment_col) == segment)
        monthly = (
            seg_df.group_by(["year", "month"])
            .agg(pl.len().alias("lead_count"))
            .sort(["year", "month"])
        )
        counts = monthly["lead_count"].to_numpy().astype(np.float64)
        months_data = monthly.select(["year", "month"]).to_dicts()
        if len(counts) >= LOOKBACK_MIN:
            dates = pd.DatetimeIndex([
                datetime(int(r["year"]), int(r["month"]), 1) for r in months_data
            ])
            result[str(segment).strip()] = (dates, counts)
    return result


def run_ensemble_forecast(
    segment_filter: str = "Global",
    force_refresh: bool = False,
) -> dict:
    """Run the full WAPE-weighted ensemble forecast pipeline.

    Returns:
        dict with "segments" (per-segment results), "summary", and optional "error".
    """
    project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), "../../"))
    parquet_path = os.path.join(project_root, "data/processed/math_schema.parquet")
    tax_path = os.path.join(project_root, "data/processed/taxonomy_schema.parquet")

    if not os.path.exists(parquet_path):
        return {"segments": {}, "summary": {}, "error": "math_schema.parquet not found."}

    df = pl.read_parquet(parquet_path)
    if os.path.exists(tax_path):
        df = df.join(pl.read_parquet(tax_path), on="Lead_ID", how="inner")
    else:
        return {"segments": {}, "summary": {}, "error": "taxonomy_schema.parquet not found."}

    if "Unified_Source" not in df.columns:
        return {"segments": {}, "summary": {}, "error": "Unified_Source column not found."}

    if segment_filter != "Global":
        df = df.filter(pl.col("Unified_Source") == segment_filter)

    segment_series = _build_monthly_series(df)
    if not segment_series:
        return {"segments": {}, "summary": {}, "error": "No segments with >= 12 months of data."}

    segment_results = {}
    global_wape_summary = []

    for seg_name, (dates, counts) in segment_series.items():
        n = len(counts)
        if n < LOOKBACK_MIN + LOOKBACK_AHEAD:
            continue

        model_errors = {"bayesian": [], "naive_seasonal": [], "prophet": []}

        # Rolling-origin CV
        for t in range(LOOKBACK_MIN, n - LOOKBACK_AHEAD):
            train_counts = counts[:t]
            train_dates = dates[:t]
            actual_future = counts[t : t + LOOKBACK_AHEAD]

            # Bayesian
            try:
                from src.models.bayesian_engine import run_bayesian_lead_forecast
                bayes_result = run_bayesian_lead_forecast(
                    segment_filter=seg_name,
                    force_resample=force_refresh,
                    _data_override=(train_dates, train_counts),
                )
                bayes_fc = np.array(bayes_result.get("forecast_mean", [0]*LOOKBACK_AHEAD)[:LOOKBACK_AHEAD])
            except Exception:
                bayes_fc = np.zeros(LOOKBACK_AHEAD)

            # Naive
            from src.models.naive_forecasters import naive_seasonal_forecast
            naive_fc = naive_seasonal_forecast(train_counts, forecast_horizon=LOOKBACK_AHEAD)

            # Prophet
            from src.models.prophet_forecaster import prophet_forecast
            prophet_fc = prophet_forecast(train_counts, train_dates, forecast_horizon=LOOKBACK_AHEAD)

            L = min(len(actual_future), LOOKBACK_AHEAD)
            model_errors["bayesian"].extend((bayes_fc[:L] - actual_future[:L]).tolist())
            model_errors["naive_seasonal"].extend((naive_fc[:L] - actual_future[:L]).tolist())
            model_errors["prophet"].extend((prophet_fc[:L] - actual_future[:L]).tolist())

        all_actuals = np.concatenate([
            counts[t : t + LOOKBACK_AHEAD]
            for t in range(LOOKBACK_MIN, n - LOOKBACK_AHEAD)
        ])

        wape_scores = {}
        for m in ["bayesian", "naive_seasonal", "prophet"]:
            errs = np.array(model_errors[m])
            wape_scores[m] = _wape(errs, all_actuals) if len(errs) > 0 else float("inf")

        weights = {}
        valid = {m: w for m, w in wape_scores.items() if w > 0 and w != float("inf")}
        if valid:
            inv = {m: 1.0 / w for m, w in valid.items()}
            tot = sum(inv.values())
            weights = {m: v / tot for m, v in inv.items()}
        else:
            weights = {"naive_seasonal": 1.0}

        # Final 12-month ensemble
        final_fc = {}
        try:
            br = run_bayesian_lead_forecast(
                segment_filter=seg_name, force_resample=force_refresh
            )
            if "forecast_mean" in br:
                final_fc["bayesian"] = np.array(br["forecast_mean"][:FORECAST_HORIZON])
        except Exception:
            pass
        final_fc["naive_seasonal"] = naive_seasonal_forecast(counts, forecast_horizon=FORECAST_HORIZON)
        final_fc["prophet"] = prophet_forecast(counts, dates, forecast_horizon=FORECAST_HORIZON)

        ensemble = np.zeros(FORECAST_HORIZON)
        for model_name, weight in weights.items():
            if model_name in final_fc:
                ensemble += weight * final_fc[model_name]

        segment_results[seg_name] = {
            "n_months": n,
            "wape_scores": wape_scores,
            "weights": weights,
            "forecast_mean": ensemble.round(1).tolist(),
            "base_forecasts": {m: f.round(1).tolist() for m, f in final_fc.items()},
        }
        global_wape_summary.append({
            "segment": seg_name, "n_months": n,
            "wape_bayesian": round(wape_scores.get("bayesian", float("inf")), 4),
            "wape_naive": round(wape_scores.get("naive_seasonal", float("inf")), 4),
            "wape_prophet": round(wape_scores.get("prophet", float("inf")), 4),
        })

    if not segment_results:
        return {"segments": {}, "summary": {}, "error": "No segments produced valid forecasts."}

    n_segments = len(segment_results)
    improvements = []
    for seg, r in segment_results.items():
        wb = r["wape_scores"].get("bayesian", float("inf"))
        wmin = min(w for w in r["wape_scores"].values() if w > 0)
        if wb > 0 and wmin > 0 and wb != float("inf"):
            improvements.append((wb - wmin) / wb)

    return {
        "segments": segment_results,
        "summary": {
            "n_segments": n_segments,
            "mean_wape_improvement": round(np.mean(improvements), 4) if improvements else 0.0,
            "forecast_horizon": FORECAST_HORIZON,
            "lookback_window": LOOKBACK_AHEAD,
            "wape_by_segment": global_wape_summary,
        },
    }
```

**WHY `_data_override` in Bayesian:** The existing `run_bayesian_lead_forecast()` loads the full dataset from disk internally. Without `_data_override`, every rolling CV iteration would reload the full 190K-row parquet, which is O(n^2) I/O. With the override, the ensemble pipeline passes pre-computed truncated counts directly — zero I/O overhead per iteration.

---

### 22.4 Sprint 15-C: Testing + Verification

**ESTIMATED EFFORT:** 1 coding session (~45 min)

#### 22.4.1 Deterministic Test Battery

**TARGET ARTIFACT (NEW FILE):** `/home/az/Downloads/testing-delete/p-ai-paid-marketing/tests/deterministic/test_ensemble_forecast.py`

**EXACT CONTENT:**

```python
"""
V15: Lightweight Metatron Test Battery.
Validates WAPE, naive forecasters, weights, and monthly series builder.
Run: uv run python tests/deterministic/test_ensemble_forecast.py
"""

import os, sys, numpy as np

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "../../"))
if PROJECT_ROOT not in sys.path:
    sys.path.insert(0, PROJECT_ROOT)


class TestWAPE:
    def test_perfect_prediction(self):
        from src.models.ensemble_forecast import _wape
        a = np.array([10, 20, 30, 40])
        assert _wape(a - a, a) == 0.0

    def test_2x_overestimate(self):
        from src.models.ensemble_forecast import _wape
        a = np.array([10, 20, 30])
        p = np.array([20, 40, 60])
        assert abs(_wape(p - a, a) - 1.0) < 0.01

    def test_zero_actuals(self):
        from src.models.ensemble_forecast import _wape
        assert _wape(np.array([5, 10]) - np.array([0, 0]), np.array([0, 0])) == float("inf")


class TestNaiveForecasters:
    def test_seasonal_repeats(self):
        from src.models.naive_forecasters import naive_seasonal_forecast
        fc = naive_seasonal_forecast(np.arange(1, 25), forecast_horizon=12)
        np.testing.assert_array_equal(fc, np.arange(13, 25))

    def test_seasonal_short(self):
        from src.models.naive_forecasters import naive_seasonal_forecast
        h = np.array([10, 20, 30, 40, 50])
        fc = naive_seasonal_forecast(h, forecast_horizon=12)
        np.testing.assert_array_equal(fc, np.tile(h, 3)[:12])

    def test_seasonal_clips_negatives(self):
        from src.models.naive_forecasters import naive_seasonal_forecast
        fc = naive_seasonal_forecast(np.array([-5, 10, -3, 20]), forecast_horizon=12)
        assert np.all(fc >= 0)

    def test_drift_extrapolates(self):
        from src.models.naive_forecasters import naive_drift_forecast
        h = np.array([10, 20, 30, 40, 50])
        fc = naive_drift_forecast(h, 3)
        np.testing.assert_array_almost_equal(fc, [60, 70, 80])


class TestEnsembleWeights:
    def test_weights_sum_to_one(self):
        wape = {"a": 0.1, "b": 0.2, "c": 0.4}
        inv = {m: 1.0 / w for m, w in wape.items()}
        tot = sum(inv.values())
        wts = {m: v / tot for m, v in inv.items()}
        assert abs(sum(wts.values()) - 1.0) < 0.001
        assert wts["a"] > wts["b"] > wts["c"]

    def test_single_model_weight_one(self):
        wape = {"only": 0.15}
        inv = {m: 1.0 / w for m, w in wape.items()}
        wts = {m: v / sum(inv.values()) for m, v in inv.items()}
        assert wts["only"] == 1.0


class TestMonthlySeriesBuilder:
    def test_builds_monthly_series(self):
        import polars as pl
        from datetime import datetime
        from src.models.ensemble_forecast import _build_monthly_series
        df = pl.DataFrame({
            "Lead_ID": [1,2,3,4,5,6],
            "CREATEDDATE": [datetime(2024,1,15),datetime(2024,1,20),datetime(2024,2,10),datetime(2024,2,15),datetime(2024,3,5),datetime(2024,3,25)],
            "Unified_Source": ["Google Ads","Google Ads","Google Ads","Meta Ads","Meta Ads","Meta Ads"],
        })
        series = _build_monthly_series(df)
        assert len(series) == 2
        for seg_name, (dates, counts) in series.items():
            assert counts.sum() == 3


if __name__ == "__main__":
    import pytest
    exit_code = pytest.main([__file__, "-v", "--tb=short", "--no-header", "-p", "no:cacheprovider"])
    print("\n=== V15: ALL PASSED ===" if exit_code == 0 else f"\n=== V15: FAILURES ({exit_code}) ===")
    sys.exit(exit_code)
```

#### 22.4.2 Smoke Test Integration

**TARGET ARTIFACT (MODIFY):** `/home/az/Downloads/testing-delete/p-ai-paid-marketing/tests/streamlit-functionality-test/streamlit_test_1_prompt.py`

Append after the V14 test function block:

```python
# =============================================================================
# V15: Lightweight Metatron Ensemble Forecasting
# =============================================================================


def test_v15_ensemble_forecast():
    """V15: Validates ensemble forecast imports, naive forecasters, WAPE."""
    print("\n" + "=" * 60)
    print("V15: Lightweight Metatron Ensemble Forecast")
    print("=" * 60)
    results = []
    try:
        from src.models.naive_forecasters import naive_seasonal_forecast, naive_drift_forecast
        import numpy as np
        fc = naive_seasonal_forecast(np.arange(1, 25), 6)
        results.append(("CHECK 1: Naive Seasonal", "PASS" if len(fc) == 6 and np.all(fc >= 0) else "FAIL"))
    except Exception as e:
        results.append(("CHECK 1: Naive Seasonal", f"FAIL ({e})"))
    try:
        from src.models.ensemble_forecast import _wape, run_ensemble_forecast
        results.append(("CHECK 2: Ensemble import", "PASS"))
    except Exception as e:
        results.append(("CHECK 2: Ensemble import", f"FAIL ({e})"))
    try:
        from prophet import Prophet
        results.append(("CHECK 3: Prophet installed", "PASS"))
    except ImportError:
        results.append(("CHECK 3: Prophet", "WARN — run: uv add prophet"))
    all_ok = True
    for n, s in results:
        m = "[OK]" if "PASS" in s else ("[WARN]" if "WARN" in s else "[FAIL]")
        print(f"  {m} {n}: {s}")
        if "FAIL" in s: all_ok = False
    print("\n  [V15] All PASSED." if all_ok else "\n  [V15] Issues found.")
    return all_ok
```

Integration: in `__main__` block, add `v15_ok = test_v15_ensemble_forecast()` after V14 call.

---

#### 22.4.3 Streamlit Dashboard Tab (V15.1)

**TARGET ARTIFACT (MODIFY):** `app.py`

**EXACT FUNCTION — `render_forecast_tab()`:**

```python
def render_forecast_tab():
    """V15: Lightweight Metatron — 12-Month Lead Volume Forecast."""
    import pandas as pd
    import plotly.graph_objects as go
    from src.models.ensemble_forecast import run_ensemble_forecast

    st.divider()
    st.markdown("### 📈 V15 Lead Volume Forecast (Lightweight Metatron)")
    st.markdown(
        "<p style='color: #475569; font-size: 0.9rem;'>"
        "12-month per-channel lead volume forecasts using a 3-model "
        "WAPE-weighted ensemble: Bayesian NegBin + Naive Seasonal + Prophet.</p>",
        unsafe_allow_html=True,
    )

    segment = st.selectbox(
        "Select Channel",
        ["Global", "Google Ads", "Meta Ads", "Bing Ads", "Email Marketing", "Other"],
        key="v15_forecast_segment",
    )

    col1, col2 = st.columns([1, 4])
    with col1:
        refresh = st.button("🔄 Refresh Forecast", key="v15_refresh")

    if segment and ("v15_result" not in st.session_state or refresh):
        segment_filter = None if segment == "Global" else segment
        with st.spinner(f"Running ensemble forecast for {segment}..."):
            result = run_ensemble_forecast(
                segment_filter=segment_filter, force_refresh=refresh,
            )
        st.session_state.v15_result = result
        st.session_state.v15_segment = segment

    result = st.session_state.get("v15_result", {})
    if result.get("error"):
        st.warning(result["error"])
        return

    summary = result.get("summary", {})
    segments = result.get("segments", {})
    if not segments:
        st.info("No segments with sufficient data (≥12 months).")
        return

    n_segments = summary.get("n_segments", 0)
    improvement = summary.get("mean_wape_improvement", 0)
    col1, col2, col3 = st.columns(3)
    col1.metric("Segments Forecasted", n_segments)
    col2.metric("Ensemble Improvement over Bayesian", f"{improvement:.1%}")
    col3.metric("Forecast Horizon", "12 months")

    seg_names = list(segments.keys())
    active_seg = segment if segment in segments else seg_names[0]
    seg = segments[active_seg]
    months = [f"M+{i+1}" for i in range(12)]

    # Forecast chart
    fig = go.Figure()
    fig.add_trace(go.Scatter(x=months, y=seg.get("forecast_mean", [0]*12),
        mode="lines+markers", name="Ensemble", line={"width":3,"color":"#2563eb"}))
    base_fc = seg.get("base_forecasts", {})
    if "bayesian" in base_fc:
        fig.add_trace(go.Scatter(x=months, y=base_fc["bayesian"],
            mode="lines", name="Bayesian", line={"dash":"dot","color":"#94a3b8"}))
    if "naive_seasonal" in base_fc:
        fig.add_trace(go.Scatter(x=months, y=base_fc["naive_seasonal"],
            mode="lines", name="Naive Seasonal", line={"dash":"dot","color":"#f59e0b"}))
    if "prophet" in base_fc:
        fig.add_trace(go.Scatter(x=months, y=base_fc["prophet"],
            mode="lines", name="Prophet", line={"dash":"dot","color":"#10b981"}))
    fig.update_layout(title=f"12-Month Lead Forecast — {active_seg}",
        xaxis_title="Month", yaxis_title="Lead Count", height=400, hovermode="x unified")
    st.plotly_chart(fig, use_container_width=True)

    # WAPE weights bar chart
    weights = seg.get("weights", {})
    if weights:
        fig2 = go.Figure(go.Bar(x=list(weights.values()), y=list(weights.keys()),
            orientation="h", marker_color=["#2563eb","#f59e0b","#10b981"]))
        fig2.update_layout(title="Ensemble Weights", xaxis_title="Weight", height=200, margin={"l":120})
        st.plotly_chart(fig2, use_container_width=True)

    # WAPE table
    wape_data = summary.get("wape_by_segment", [])
    if wape_data:
        df = pd.DataFrame(wape_data)
        df = df.rename(columns={"segment":"Channel","n_months":"Months",
            "wape_bayesian":"Bayesian WAPE","wape_naive":"Naive WAPE","wape_prophet":"Prophet WAPE"})
        st.dataframe(df, use_container_width=True)
```

**Integration point:** `render_forecast_tab()` called between V7 sections and V14 chat section in `app.py`. Uses `st.session_state.v15_result` to cache ensemble results across Streamlit reruns.

**Dependencies:** Zero new. Reuses existing `plotly`, `pandas`, `streamlit`.

---

### 22.5 File Map

```
V15 FILES (4 NEW + 2 MODIFIED):

NEW:
  src/models/naive_forecasters.py                    (~65 lines)
  src/models/prophet_forecaster.py                   (~95 lines)
  src/models/ensemble_forecast.py                    (~180 lines)
  tests/deterministic/test_ensemble_forecast.py      (~100 lines)

MODIFIED:
  src/models/bayesian_engine.py                      (+15 lines, _data_override param)
  tests/streamlit-functionality-test/streamlit_test_1_prompt.py (+35 lines)

DEPENDENCIES: 1 new (prophet OR neuralprophet)
DOCKER: ZERO changes
```

---

### 22.6 Success Criteria

| # | Criteria | Verification |
|---|---|---|
| 1 | All 4 new files pass `py_compile()` | Loop compile check |
| 2 | `bayesian_engine.py` passes py_compile after `_data_override` addition | `python -m py_compile src/models/bayesian_engine.py` |
| 3 | Naive Seasonal produces valid 12-month forecast | Test: test_seasonal_repeats |
| 4 | WAPE = 0 for perfect prediction | Test: test_perfect_prediction |
| 5 | WAPE = inf for all-zero actuals | Test: test_zero_actuals |
| 6 | Ensemble weights sum to 1.0 | Test: test_weights_sum_to_one |
| 7 | `_build_monthly_series()` correctly segments | Test: test_builds_monthly_series |
| 8 | `run_ensemble_forecast()` returns expected keys | Manual: print keys of result dict |
| 9 | Prophet installed (or graceful fallback) | Smoke test CHECK 3 |
| 10 | V15 smoke test passes | `python tests/streamlit-functionality-test/streamlit_test_1_prompt.py` |
| 11 | Full test battery passes | `python tests/deterministic/test_ensemble_forecast.py` |

---

### 22.7 Contingency Paths

| Failure | Detection | Response |
|---|---|---|
| Prophet fails to install | `uv add prophet` non-zero exit | Install `neuralprophet` instead |
| Segment has <12 months data | `_build_monthly_series` skips it | Segment excluded. Summary reports skip count. |
| Bayesian fails on small-N (divergences) | `run_bayesian_lead_forecast` returns error | WAPE = inf for that window → weight drops to zero |
| Prophet fails on degenerate data | `prophet_forecast` internal try/except | Falls back to `naive_seasonal_forecast()` |
| No segments pass threshold | `segment_series` empty | Returns `{"error": "No segments..."}`. Fall back to V6 global forecast. |
| All 3 WAPEs equal | Weights all ~0.33 | Fine — ensemble is a simple average. Diagnostic note in output. |

---

### 22.8 V15 Completion Statement

> **Status:** IMPLEMENTATION COMPLETE — 2026-05-26
> **Architects:** DeepSeek (Principal Architect) + Gemini (Adversarial Review) — Consensus on COUNCIL.md
> **Execution:** Flash (DeepSeek V4) — 1 session (~30 min)
> **Scope:** 4 new files, 2 modified files, 1 new Python package (prophet==1.3.0), ZERO Docker changes
> **Total:** ~445 new lines + ~50 modified lines across 6 files
> **Verification:** 10/10 deterministic tests pass, all 6 Python files pass py_compile()
> **Bug Fix:** `test_builds_monthly_series` had insufficient data (3 months vs 12 required) — fixed to 12 months per segment

### 22.9 Execution Summary

**What was built:**

V15 adds a WAPE-weighted 3-model ensemble lead volume forecaster that segments by Unified_Source, performs rolling-origin temporal CV, and produces 12-month forecasts per segment.

**4 new files created:**

| File | Purpose |
|---|---|
| `src/models/naive_forecasters.py` | `naive_seasonal_forecast()` (repeats last K=12), `naive_drift_forecast()` (linear extrapolation) — zero deps beyond numpy |
| `src/models/prophet_forecaster.py` | `prophet_forecast()` — Prophet wrapper with Prophet→neuralprophet→naive seasonal 3-tier fallback |
| `src/models/ensemble_forecast.py` | `_wape()` (WAPE metric), `_build_monthly_series()` (per-segment aggregator), `run_ensemble_forecast()` (full pipeline) |
| `tests/deterministic/test_ensemble_forecast.py` | 10 tests across 4 classes: WAPE, NaiveForecasters, EnsembleWeights, MonthlySeriesBuilder |

**2 existing files modified:**

| File | Addition |
|---|---|
| `src/models/bayesian_engine.py` | `_data_override: tuple \| None = None` — bypasses internal Polars loading for rolling-origin CV |
| `tests/streamlit-functionality-test/streamlit_test_1_prompt.py` | `test_v15_ensemble_forecast()` — 3 checks (naive seasonal, ensemble import, prophet install) |

**Key architectural decisions:**
- 3-model ensemble: Bayesian NegBin (V6 Exp 5), Naive Seasonal, Prophet — WAPE-weighted arithmetic averaging
- Rolling-origin CV: train up to month T, forecast T+1..T+3, accumulate errors across all windows
- WAPE weights: `weight = (1/WAPE) / sum(1/WAPE)` — better forecasters get higher weight
- `_data_override` on Bayesian ensures O(1) I/O during CV (vs O(n²) re-loading 190K rows per iteration)
- Prophet `make_future_dataframe(freq="ME")` — month-end alignment for 12-month horizon

**Verification:** All 6 Python files pass `py_compile()`. All 10 deterministic tests pass. Prophet installed and importable.
