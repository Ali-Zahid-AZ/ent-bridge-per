## 27. V14-B — External Concierge + Lead Assessment Concierge (Phase 2)

> **Status:** ✅ PHASE 1 MVP IMPLEMENTED — 2026-05-30 07:20 PKT
> **Phase 2:** ✅ LEAD ASSESSMENT CONCIERGE IMPLEMENTED — stateless parquet-based lead analysis with V11 case matcher
> **Architects:** DeepSeek V4 (Principal Architect) + Gemini (Adversarial Review) + Ali (Design Lock)
> **Scope:** Phase 1 built the External Concierge chat pipeline. Phase 2 added a separate `/assess` endpoint that loads leads from `math_schema.parquet`, runs V11 case-matcher for similar historical leads, and returns structured assessments via llama3.1 synthesis.
> **Architecture:** Dual-mode — Phase 1 handles external property consultation (anonymous chat, widget, 3-tier pipeline). Phase 2 handles internal lead analysis (stateless, parquet-based, case-matcher-driven). Both share the same FastAPI app and response generator templates.

---

### 27.0 Architecture Overview

V14-B operates in two modes:

```
PHASE 1 — External Concierge (/message):
  Anonymous Prospect → Widget → FastAPI → 3-Tier Pipeline → Staging File → (eventual Salesforce)

PHASE 2 — Lead Assessment Concierge (/assess):
  Sales Rep → API Call → lead_assessor.py (parquet load + case matcher) → llama3.1 → Assessment Report
```

**Phase 1 architecture (unchanged from original MVP):**

| Tier | Agent | LLM Calls/Turn | Purpose |
|------|-------|---------------|---------|
| **Tier 1** | Intent Router | 0 (deterministic) | Classify query type → select minimal agent composition |
| **Tier 2** | Lead State Agent | 1 | Extract constraints → detect conflicts → maintain session state |
| **Tier 2** | Hybrid Retriever | 0 | Qdrant vector search + Neo4j Cypher filter (adaptive) |
| **Tier 2** | Response Generator | 1 | Task-specific prompt → evidence-cited response |
| **Tier 3** | Validation Agent | 0 | Deterministic checks → failure classification → remediation |

**Phase 2 architecture (new — stateless, no session):**

| Component | Purpose |
|-----------|---------|
| `lead_assessor.py` | Loads lead from `math_schema.parquet`, builds case-matcher input, calls V11 `find_similar_leads()`, structures output |
| `generate_assessment()` | New function in `response_generator.py` — formats assessment prompt for llama3.1 using `lead_assessment` or `lead_outlook` template |
| `/api/concierge/assess` | FastAPI endpoint — accepts `lead_id` + optional `question`, returns structured assessment |

**Phase 2 is stateless by design:** each call loads fresh parquet data, runs the case matcher, synthesizes an assessment, and returns. No session, no in-memory state, no progressive profiling.

---

### 27.1 Phase 2 — Lead Assessment Agent

**TARGET ARTIFACT:** `src/concierge/core/lead_assessor.py`

#### 27.1.1 Module

```python
"""
V14-B Phase 2: Lead Assessment Concierge — Stateless Lead Analysis Engine.

Loads a lead from math_schema.parquet, runs V11 case matcher for similar
historical leads, and returns structured assessment data for llama3.1 synthesis.

Stateless: each call loads fresh data. No session, no in-memory state.
"""

from dataclasses import dataclass
from typing import Any

import polars as pl

from src.telemetry.logging import get_logger
from src.models.case_matcher import find_similar_leads
```

#### 27.1.2 Data Flow

```
lead_id → _load_lead(parquet) → _build_lead_summary → _build_case_matcher_input
                                                          ↓
                                           V11 find_similar_leads()
                                                          ↓
                                          _format_similar_leads(top_k=5)
                                                          ↓
                                          AssessmentResult(lead_summary,
                                                           similar_leads,
                                                           closure_rate,
                                                           total_neighbors,
                                                           caveat,
                                                           error)
```

#### 27.1.3 Key Design Decisions

| Decision | Rationale |
|----------|-----------|
| **Parquet not Salesforce** | `math_schema.parquet` contains the full historical lead dataset with V11 case-matcher features. Salesforce would require API calls for every lead load. Parquet is local and fast. |
| **Stateless** | Lead assessment is a one-shot analysis — no multi-turn conversation. Stateless simplifies deployment and avoids session management entirely. |
| **Case-matcher fields are fixed** | `_CASE_MATCHER_FIELDS` is a hardcoded list of 8 fields from the V11 case-matcher schema (COUNTRY, MONTHLY_BUDGET__C, MAX_DESKS__C, etc.). Adding new fields requires updating this list. |
| **top_k=5 similar leads** | The V11 case matcher returns all neighbors; `_format_similar_leads` limits to top 5 for prompt context. The total count is recorded in `total_neighbors` for confidence calibration. |
| **Closure rate from case matcher** | The case matcher's `output.closure_rate` is the historical conversion rate for similar leads. If `< 10 neighbors`, the `caveat` field warns about limited data. |
| **llama3.1 for synthesis** | The raw assessment data (lead summary + similar leads + closure rate) is structured but not human-readable. llama3.1 synthesizes it into a natural-language assessment report. |

#### 27.1.4 Case-Matcher Field Mapping

| Field in Parquet | Case-Matcher Key | Source |
|---|---|---|
| `COUNTRY` | COUNTRY | Lead country |
| `MONTHLY_BUDGET__C` | MONTHLY_BUDGET__C | Monthly rental budget |
| `MAX_DESKS__C` | MAX_DESKS__C | Maximum desks required |
| `MIN_DESKS__C` | MIN_DESKS__C | Minimum desks required |
| `IDEAL_SIZE_SQM__C` | IDEAL_SIZE_SQM__C | Preferred area in sqm |
| `NUMBEROFEMPLOYEES` | NUMBEROFEMPLOYEES | Company size |
| `TOTALCALLSFROMTENANT__C` | TOTALCALLSFROMTENANT__C | Engagement level |
| `ANNUALREVENUE` | ANNUALREVENUE | Annual revenue |

#### 27.1.5 Error Handling

| Failure Mode | Behaviour | User Sees |
|---|---|---|
| Parquet file missing | `_load_lead()` returns `None` | `AssessmentResult(error="Lead not found in parquet.")` |
| lead_id not in parquet | `pl.scan_parquet().filter()` returns empty | `AssessmentResult(error="Lead not found in parquet.")` |
| Case matcher raises exception | `find_similar_leads()` wrapped in try/except | `AssessmentResult(error="Case matcher failed: ...")` |
| Case matcher returns error status | `result.get("status") == "error"` | `AssessmentResult(error=result.get("message"))` |
| llama3.1 fails during synthesis | `generate_assessment()` catches httpx exception | Returns error dict with `"error": str(e)` |

---

### 27.2 Phase 2 — `/assess` Endpoint

**TARGET ARTIFACT:** `src/concierge/api/concierge.py`

The `/assess` endpoint is an addition to the existing FastAPI router. The Phase 1 `/message` endpoint is unchanged.

```python
class AssessRequest(BaseModel):
    lead_id: int
    question: str | None = None
    task_type: str = "lead_assessment"


class AssessResponse(BaseModel):
    lead_summary: dict[str, Any] | None = None
    similar_leads: list[dict[str, Any]] | None = None
    assessment: str | None = None
    closure_rate: float | None = None
    error: str | None = None


@router.post("/assess", response_model=AssessResponse)
async def handle_assessment(request: AssessRequest):
    from src.concierge.core.lead_assessor import assess_lead
    from src.concierge.core.response_generator import generate_assessment

    result = assess_lead(request.lead_id, request.question)
    if result.error:
        return AssessResponse(error=result.error)

    generated = generate_assessment(
        assessment_result=result,
        question=request.question,
        task_type=request.task_type,
    )

    return AssessResponse(
        lead_summary=result.lead_summary,
        similar_leads=result.similar_leads,
        assessment=generated.get("response"),
        closure_rate=result.closure_rate,
        error=generated.get("error"),
    )
```

**Request/Response Schema:**

| Field | Type | Required | Description |
|---|---|---|---|
| `lead_id` | int | Yes | Salesforce lead ID (must exist in parquet) |
| `question` | str | No | Optional specific question to focus the assessment |
| `task_type` | str | No | `"lead_assessment"` (default) or `"lead_outlook"` |

**Response includes:**
- `lead_summary`: Structured lead profile (status, city, industry, budget, desks, scores)
- `similar_leads`: Top 5 similar historical leads with similarity scores and outcomes
- `assessment`: Natural-language assessment generated by llama3.1
- `closure_rate`: Historical conversion rate from case matcher
- `error`: Error message if something failed

#### 27.2.1 Orchestration

```
Step 1: Load lead from parquet (_load_lead)
Step 2: Build case-matcher input (_build_case_matcher_input)
Step 3: Run V11 case matcher (find_similar_leads)
Step 4: Format similar leads (_format_similar_leads, top_k=5)
Step 5: Generate assessment via llama3.1 (generate_assessment)
Step 6: Return structured response
```

All 6 steps run synchronously in the handler. No streaming, no WebSocket, no session.

---

### 27.3 Phase 2 — Response Generator Templates

**TARGET ARTIFACT:** `src/concierge/core/response_generator.py`

Two new templates added alongside the existing 5 Phase 1 templates:

| Template | Task Type | Purpose |
|---|---|---|
| `lead_assessment` | Default | Full lead profile analysis: summary, comparison to similar leads, predicted conversion likelihood, recommended sales approach |
| `lead_outlook` | `task_type="lead_outlook"` | 30/60/90-day outlook: trajectory forecast, key triggers, red flags, next actions |

Both templates receive:
- `{constraints}` — Lead summary as JSON
- `{properties}` — Similar leads as JSON
- `{closure_rate}` — Historical closure rate
- `{total_neighbors}` — Number of similar leads found
- `{caveat}` — Warning about limited data if applicable
- `{history}` — The user's optional question

---

### 27.4 Phase 1 Unchanged Components

The following Phase 1 components are **unchanged** — no code modifications were needed for Phase 2:

| Component | File | Status |
|---|---|---|
| Intent Router | `intent_router.py` | Unchanged (LEAD_ASSESSMENT type added for classification only) |
| Lead State Agent | `lead_state.py` | Unchanged |
| Hybrid Retriever | `hybrid_retriever.py` | Unchanged |
| Validation Agent | `validation_agent.py` | Unchanged |
| Session Store | `session_store.py` | Unchanged |
| Widget | `embed.html` | Unchanged |
| API (`/message`) | `concierge.py` | Unchanged (new `/assess` endpoint added alongside) |
| Streamlit integration | `app.py` | Unchanged |

The `intent_router.py` gained a `LEAD_ASSESSMENT` enum value but this is for classification completeness — the `/assess` endpoint routes directly to `lead_assessor.py` without going through the Intent Router.

---

### 27.5 Intent Router — Updated Query Types

The `IntentRouter` now has 6 query types:

| Query Type | Used By | Purpose |
|---|---|---|
| CONSTRAINT_UPDATE | Phase 1 `/message` | User is changing preferences |
| SIMPLE_SEARCH | Phase 1 `/message` | Simple property search |
| COMPLEX_SEARCH | Phase 1 `/message` | Multi-constraint comparison search |
| GENERAL_QUESTION | Phase 1 `/message` | Market/process questions |
| OUT_OF_SCOPE | Phase 1 `/message` | Chitchat/off-topic decline |
| LEAD_ASSESSMENT | (Classification only) | Lead analysis — routed directly by `/assess` endpoint |

The `LEAD_ASSESSMENT` type exists in the enum for potential future use where intent routing determines whether to send to `/message` or `/assess`. Currently, the two endpoints are separated at the API level.

---

### 27.6 Files Added/Changed

| File | Action | Purpose |
|---|---|---|
| `src/concierge/core/lead_assessor.py` | **NEW** | Phase 2 lead analysis engine — parquet load + case matcher |
| `src/concierge/core/response_generator.py` | **UPDATE** | Added `generate_assessment()` + `lead_assessment` and `lead_outlook` templates |
| `src/concierge/core/intent_router.py` | **UPDATE** | Added `LEAD_ASSESSMENT` enum value |
| `src/concierge/api/concierge.py` | **UPDATE** | Added `/assess` endpoint + `AssessRequest`/`AssessResponse` schemas |
| All Phase 1 files | **UNCHANGED** | No modifications needed |

**Total Phase 2 additions: ~250 lines (lead_assessor.py) + ~80 lines (response_generator templates) + ~40 lines (concierge.py endpoint) = ~370 lines.**

---

### 27.7 Architecture Diagram — Updated

```
┌──────────────────────────────────────────────────────────────────────────────────────┐
│                              FASTAPI (src/api/server.py)                              │
│                                                                                       │
│  ┌──────────────────────────────────┐    ┌─────────────────────────────────────────┐  │
│  │  POST /api/concierge/message      │    │  POST /api/concierge/assess             │  │
│  │  (Phase 1 — External Concierge)   │    │  (Phase 2 — Lead Assessment)            │  │
│  │                                   │    │                                         │  │
│  │  Step 1: Load/create session      │    │  Step 1: Load lead from parquet         │  │
│  │  Step 2: Intent Router classifies │    │  Step 2: Build case-matcher input       │  │
│  │  Step 3: Lead State extracts      │    │  Step 3: Run V11 case matcher           │  │
│  │  Step 4: Hybrid Retriever searches│    │  Step 4: Format similar leads (top 5)   │  │
│  │  Step 5: Response Generator       │    │  Step 5: llama3.1 synthesizes report    │  │
│  │  Step 6: Validation Agent verifies│    │  Step 6: Return structured response     │  │
│  │  Step 7: Gated commit to staging  │    │                                         │  │
│  │  Step 8: Return to widget         │    │  (Stateless — no session, no memory)    │  │
│  └──────────────────────────────────┘    └─────────────────────────────────────────┘  │
│                       │                                    │                          │
│                       ▼                                    ▼                          │
│  ┌──────────────────────────────────────────────────────────────────────────────┐    │
│  │                          DATA LAYER                                          │    │
│  │                                                                              │    │
│  │  Phase 1: Qdrant + Neo4j       Phase 2: math_schema.parquet + Case Matcher   │    │
│  └──────────────────────────────────────────────────────────────────────────────┘    │
└──────────────────────────────────────────────────────────────────────────────────────┘
```

---

### 27.8 Phase 2 Assessment Prompt Template

The `lead_assessment` template instructs llama3.1 to produce a structured report:

```
LEAD PROFILE:
{lead_summary as JSON}

SIMILAR HISTORICAL LEADS (from V11 case-based reasoning):
{similar_leads as JSON}

HISTORICAL CLOSURE RATE: {closure_rate}
TOTAL SIMILAR LEADS FOUND: {total_neighbors}

INSTRUCTIONS:
1. Analyze the target lead in the context of similar historical leads.
2. Provide: lead profile summary, comparison to similar leads,
   predicted conversion likelihood, recommended sales approach,
   specific channels/campaigns that worked for similar leads.
3. Cite specific evidence from similar leads data.
4. If closure rate based on < 10 neighbors, note the uncertainty.
5. End with a clear actionable recommendation.
```

---

### 27.9 Pre-Flight Checks (Phase 2)

```bash
# Verify parquet file exists
test -f data/processed/math_schema.parquet && echo "Parquet OK" || echo "MISSING"

# Test lead assessment
uv run python -c "
from src.concierge.core.lead_assessor import assess_lead
result = assess_lead(1)
print(f'Lead found: {result.lead_summary.get(\"lead_id\") is not None}')
print(f'Similar leads: {len(result.similar_leads)}')
print(f'Closure rate: {result.closure_rate}')
"

# Test /assess endpoint
curl -X POST http://localhost:8000/api/concierge/assess \
  -H "Content-Type: application/json" \
  -d '{"lead_id": 1}'
```

---

### 27.10 What Ali Must Do (Phase 2)

1. **Review this document** — understand Phase 2 architecture (stateless, parquet-based, case-matcher-driven)
2. **Verify parquet file** — `math_schema.parquet` must exist at the configured path
3. **Verify case matcher** — `src/models/case_matcher.find_similar_leads()` must be importable
4. **Test lead assessment standalone** — run `assess_lead(1)` and inspect the output
5. **Test `/assess` endpoint** — send a POST request with a valid `lead_id`
6. **Test with question** — `{"lead_id": 1, "question": "What is the best channel for this lead?"}`
7. **When V18 API access is confirmed:** implement Phase 1.5 bridge (attribution matching, Neo4j recommendation edges, Concierge ROI dashboard tab)
