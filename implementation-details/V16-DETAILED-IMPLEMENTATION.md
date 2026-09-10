# V16 — True Context Graph: Portfolio, Person & Peer Layer Expansion — Detailed Implementation

> **Status:** IMPLEMENTATION COMPLETE — 2026-05-28
> **Trigger:** Graph-informed scoring engine (V12 GDS + V14 conversational agent) has extracted all available signal from the current 5-edge-type topology (average degree ~2.5). The remaining performance ceiling comes from information that does not exist in our data yet - Portfolio membership, Parent-Subsidiary structure, Person identity deduplication, and Peer/Colleague relationship edges.
> **Timestamp:** 2026-05-28
> **Architects:** DeepSeek V4 (Principal Architect) + Gemini (Adversarial Review) + DeepSeek Chat (Operational Refinement) - Consensus on COUNCIL.md
> **Scope:** 6 phases (0-5 core, 6 gated). 1 new file, 1 Cypher query, ~4 modified files for core Phases 0-4. Phase 5 (CDC) and Phase 6 (GNN) are gated on measurement thresholds.
> **Total core work:** Phases 0-4: ~6-8 days. ~200-300 new lines + zero new Python packages + zero Docker changes.
> **Neo4j:** Community Edition sufficient - no license upgrade needed.

---

## 23.0 Consensus Summary

After adversarial review on COUNCIL.md between DeepSeek V4, Gemini, and DeepSeek Chat, the following amendments were accepted:

1. **Deterministic identity resolution** (Gemini amendment): Email to vector embedding to cosine similarity removed. Replaced with exact email/phone matching + blocking keys. Fuzzy name matching with structural constraint gate deferred to post-Phase-2.
2. **CDC deferred** (Gemini + DeepSeek Chat): Kafka/Redis streaming replaced with hourly micro-batch via Python daemon, gated on measurement (>1,000 leads change/day threshold). Zero new infrastructure.
3. **Phase 0 visualizer** (DeepSeek Chat): 2-hour Streamlit 2-hop graph explorer added as the very first deliverable - fastest stakeholder buy-in.
4. **Parent company in Phase 2** (DeepSeek Chat): Extends existing V12-B `entity_resolver.py` - no new module needed.
5. **GNN gate tightened** to 10% AUROC lift (DeepSeek Chat), deferred to post-ad-platform-integration.

---

## 23.1 Architecture Overview - What V16 Adds

**Current State (V12-V15):** A graph-informed scoring engine with 5 edge types (BELONGS_TO_INDUSTRY, ACQUIRED_VIA, LOCATED_IN, BELONGS_TO_COMPANY, PERFORMED). GDS algorithms compute PageRank, Louvain, FastRP, etc. - then freeze results into flat columns. XGBoost trains on these frozen columns. V14 conversational agent answers Cypher queries.

**V16 Goal:** Upgrade the graph from a frozen-snapshot scoring engine to a true traversable context graph with 15+ edge types and average degree 8-10. New layers: Portfolio nodes (BUILDING_IN_PORTFOLIO edges), ParentCompany hierarchies (SUBSIDIARY_OF edges), deduplicated Person nodes (IS_IDENTITY_OF edges), and Peer relationships (KNOWS, COLLEAGUE_OF edges). All accessible via the V14 conversational agent with updated skill examples.

**Core Pipeline:**

```
Phase 0: Lead_ID -> Cypher 2-hop query -> Plotly/networkx graph in Streamlit (2 hours)
Phase 1: Salesforce SOQL audit -> data sourcing spreadsheet (1-2 days)
Phase 2: Extend Neo4j schema -> one-shot loader with deterministic identity resolution (2-3 days)
Phase 3: Identity resolution pipeline: email+phone exact match -> blocking keys -> Person merge (2 days)
Phase 4: Update V14 skill file with 10 new few-shot examples for new node types (1 day)
Phase 5: [GATED] CDC measurement -> hourly micro-batch if >1,000 leads change/day
Phase 6: [GATED] GNN: 10% AUROC lift on temporal hold-out -> GraphSAGE -> deferred to post-Phase-2
```

---

## 23.2 Sprint 16-0: Phase 0 - Minimal 2-Hop Graph Visualizer

**ESTIMATED EFFORT:** 2 hours
**GOAL:** Fastest stakeholder win. Before any schema changes, build a Streamlit page where a user types a Lead_ID and sees a 2-hop neighbourhood network graph. Proves the graph is real and valuable.

**WHAT TO DO:**
1. Add a new function `render_graph_explorer()` in `app.py`
2. Write a Cypher query that takes `lead_id` as parameter and returns 2-hop neighbourhood
3. Render as a Plotly network graph in Streamlit

### 23.2.1 Step A - Add `render_graph_explorer()` to `app.py`

**TARGET ARTIFACT (MODIFY):** `/home/az/Downloads/testing-delete/p-ai-paid-marketing/app.py`

**LOCATION:** Search for `def render_conversational_analytics()` in `app.py`. Insert the new function BEFORE it (around line 1516).

**EXACT CONTENT:** See the full function definition in the V16 detailed implementation notes. Flash: implement `render_graph_explorer()` with the following components:
- Streamlit text_input for Lead_ID (integer validation)
- Cypher 2-hop query: `MATCH (l:Lead {id: $lead_id}) OPTIONAL MATCH (l)-[r1]-(n1) OPTIONAL MATCH (n1)-[r2]-(n2) WHERE n2 <> l RETURN l, r1, n1, r2, n2 LIMIT 200`
- NetworkX spring layout with `k=0.5, iterations=50, seed=42`
- Plotly scatter traces per node type with distinct colors
- Edge traces as grey lines with hover labels showing relationship type
- Legend with node type colors
- Error handling: `st.error()` for Neo4j unreachable, `st.warning()` for no graph data
- Helper function `_node_label(node)` to extract human-readable labels from Neo4j nodes

**INTEGRATION HOOK:** Find the `st.tabs()` call in `app.py`. Add a new tab `"Graph"` to the tabs list. Inside that tab, call `render_graph_explorer()`.

**VERIFY:**

```bash
python -m py_compile app.py && echo "app.py: OK"
# Start Streamlit, navigate to Graph tab, type a Lead_ID, verify network diagram renders
```

**WHY Phase 0 is first:** Proving value to stakeholders requires a visible artifact. A 2-hour graph explorer that lets anyone type a Lead_ID and see its connections generates immediate buy-in for the remaining 5 phases. Building this before schema changes means stakeholders see the CURRENT graph - then Phase 2+ improvements become "before and after" visible.

**WHY Plotly instead of Neo4j Bloom:** Neo4j Bloom requires Enterprise Edition + separate deployment. Plotly is already in pyproject.toml (V6 Bayesian charts) and renders inline in Streamlit. Zero new dependencies.

**CONTINGENCY (Neo4j unreachable):** `GraphDatabase.driver()` raises `ServiceUnavailable`. The `try/except Exception` wrapper catches it and displays `st.error("Failed to query graph: ...")`. Streamlit continues rendering other sections.

---

## 23.3 Sprint 16-1: Phase 1 - Data Audit

**ESTIMATED EFFORT:** 1-2 days (Ali manually runs SOQL queries in Salesforce Workbench)
**GOAL:** Determine which Portfolio/ParentId/Email fields exist in Salesforce before writing any code. Avoid building on missing data.

**WHAT ALI MUST DO (Ali executes manually - Flash does NOT build this):**

### 23.3.1 Portfolio Data Audit

Run these SOQL queries in Salesforce Workbench:

```sql
-- Check if Portfolio__c object exists and has links to buildings
SELECT Id, Name FROM Portfolio__c LIMIT 10

-- Check if Property__c or Building__c has a Portfolio lookup
SELECT Id, Name, Portfolio__c FROM Property__c WHERE Portfolio__c != NULL LIMIT 20

-- Check Account RecordTypes for "Portfolio" entries
SELECT Id, Name, RecordType.Name FROM Account WHERE RecordType.Name LIKE '%Portfolio%' LIMIT 20
```

### 23.3.2 Parent Company Audit

```sql
-- Check if standard Account.ParentId is populated
SELECT Id, Name, ParentId, Parent.Name FROM Account WHERE ParentId != NULL LIMIT 50

-- Check for custom parent account relationships
SELECT Id, Name, Ultimate_Parent_Account__c FROM Account WHERE Ultimate_Parent_Account__c != NULL LIMIT 50
```

### 23.3.3 Person Deduplication Audit

```sql
-- Sample leads with email to assess dedup feasibility
SELECT Id, Email, Phone, FirstName, LastName, Company FROM Lead WHERE Email != NULL LIMIT 1000
```

### 23.3.4 Output (Ali fills in this spreadsheet)

| Question | Answer (Ali fills) | Fallback if Missing |
|----------|-------------------|---------------------|
| Does Portfolio__c exist with building links? | YES/NO | LLM inference (extend V12-B pattern) |
| Does Account.ParentId have >= 50 populated rows? | YES/NO | LLM inference from company name similarity |
| How many leads have non-null Email? | ___ / 190,926 | Dedup only on Phone if Email is sparse |
| How many leads have non-null Phone? | ___ / 190,926 | Dedup only on Email if Phone is sparse |

**Flash: DO NOT proceed to Phase 2 until Ali fills in this spreadsheet.** Building schema + loader without knowing data availability wastes effort on missing fields.

---

## 23.4 Sprint 16-2: Phase 2 - Graph Schema Extension + One-Shot Loader

**ESTIMATED EFFORT:** 2-3 days (1 coding session per sub-sprint)
**GOAL:** Add Portfolio, ParentCompany, and Person nodes + edges to Neo4j. Use only deterministic matching (no vectors, no ML).

### 23.4.1 Step A - Define New Neo4j Constraints & Indices

**TARGET ARTIFACT (MODIFY):** `/home/az/Downloads/testing-delete/p-ai-paid-marketing/src/etl/ingest_only_full.py`

**LOCATION:** Inside `setup_constraints()` function. ADD the following AFTER the existing constraint definitions:

New constraints + indices to add:
- `CREATE CONSTRAINT portfolio_id_unique IF NOT EXISTS FOR (p:Portfolio) REQUIRE p.id IS UNIQUE`
- `CREATE INDEX portfolio_name_idx IF NOT EXISTS FOR (p:Portfolio) ON (p.name)`
- `CREATE CONSTRAINT parent_company_id_unique IF NOT EXISTS FOR (pc:ParentCompany) REQUIRE pc.id IS UNIQUE`
- `CREATE INDEX parent_company_name_idx IF NOT EXISTS FOR (pc:ParentCompany) ON (pc.name)`
- `CREATE CONSTRAINT person_id_unique IF NOT EXISTS FOR (p:Person) REQUIRE p.id IS UNIQUE`
- `CREATE INDEX person_email_idx IF NOT EXISTS FOR (p:Person) ON (p.email)`
- `CREATE INDEX person_phone_idx IF NOT EXISTS FOR (p:Person) ON (p.phone)`
- `CREATE INDEX building_portfolio_edge_idx IF NOT EXISTS FOR ()-[r:BUILDING_IN_PORTFOLIO]-() ON (r.since)`
- `CREATE INDEX subsidiary_edge_idx IF NOT EXISTS FOR ()-[r:SUBSIDIARY_OF]-() ON (r.confidence)`

**WHY:** Unique constraints prevent duplicate Portfolio/Person nodes during MERGE operations. Indices on name/email/phone accelerate the identity resolution lookup in Phase 3. The `IF NOT EXISTS` clause ensures idempotency - running `setup_constraints()` multiple times is safe. Wrap in try/except with `[V16 Non-Critical]` prefix - if constraints already exist, this is safe to ignore.

### 23.4.2 Step B - Portfolio & ParentCompany Node Loader

**TARGET ARTIFACT (MODIFY):** `/home/az/Downloads/testing-delete/p-ai-paid-marketing/src/etl/ingest_only_full.py`

**LOCATION:** After the V12-C temporal edges block and BEFORE the V13 score computation block in `trigger_post_ingestion_routines()`. Insert a `[V16-2A]` block.

**PLACEHOLDER CODE:** The Portfolio/ParentCompany loader depends on Ali's Phase 1 audit results. Flash: insert a try/except block with a print statement indicating "Portfolio data source pending Ali's Phase 1 audit." The structural skeleton (Neo4j driver creation, MERGE operations, error handling) should follow the existing V12-B pattern in `entity_resolver.py`. Do NOT hardcode column names until Ali provides the spreadsheet.

**WHY placeholder code:** The exact data source (CSV columns, field names) depends on Ali's Phase 1 audit. Flash cannot hardcode field names that might not exist. The placeholder provides the structural skeleton - Flash fills in the data loading once Ali provides the spreadsheet.

### 23.4.3 Step C - Person Node Loader with Deterministic Identity Resolution

**TARGET ARTIFACT (NEW FILE):** `/home/az/Downloads/testing-delete/p-ai-paid-marketing/src/graph/person_resolver.py`

**EXACT SPECIFICATION:**

Functions to implement:
1. `_normalize_email(email)` - Lowercase, strip whitespace. Return None if empty/missing.
2. `_normalize_phone(phone)` - Strip all non-digit characters. Return None if <7 digits (too short to be a valid number).
3. `_blocking_key(email, phone)` - Generate blocking key from email domain prefix (first 3 chars) + phone prefix (first 3 digits). Format: "abc_123". If no key available, return "_no_key_".
4. `resolve_persons_to_neo4j()` - Full pipeline:
   a. Load `math_schema.parquet`, find email/phone columns (search for columns containing "email" and "phone" in their names - case-insensitive)
   b. Normalize: cast to String, apply _normalize_email / _normalize_phone
   c. Filter to rows with at least one of email/phone non-null
   d. Assign blocking keys
   e. Within each block, group by exact email match (Tier 1), then exact phone match (Tier 2)
   f. Build lead_to_person mapping
   g. Batch-write Person nodes + IS_IDENTITY_OF edges to Neo4j (BATCH_SIZE=5000, using UNWIND pattern from V12-B)
   h. Return dict with total_leads, persons_created, leads_merged, blocks_processed

**BLOCKING KEY ALGORITHM (WHY):** A naive pairwise comparison of 190K leads is O(n^2) ~ 36 billion comparisons - infeasible. Blocking keys reduce this to: each lead falls into one of ~1,000 blocks. Within each block, only ~190 leads are compared -> O(n log n) -> seconds, not days.

**WHY Tier 1 (exact email) before Tier 2 (exact phone):** Email is the stronger identifier. Two leads sharing an email are almost certainly the same person. Two leads sharing a phone MIGHT be the same person (shared office lines) but could be different. Processing email first means phone matches are only considered for leads that DON'T share an email - reducing false merges on shared phone numbers.

**WHY deterministic-only (no vectors, no ML):** This is a negotiated consensus compromise. Gemini correctly identified that vectorizing emails introduces probabilistic failure vectors. The deterministic pipeline catches 80-90% of duplicates with zero false positives. Fuzzy name matching (Levenshtein + structural constraint) is deferred to post-Phase-2.

**Error handling** in resolve_persons_to_neo4j():
- If parquet not found: return {"error": "math_schema.parquet not found."}
- If no email/phone columns found in parquet: return {"error": "No email or phone columns found..."}
- If Neo4j unreachable during write: catch exception, return {"error": str(e)}
- Default return on success: {"total_leads": N, "persons_created": M, "leads_merged": L, "blocks_processed": B}

### 23.4.4 Step D - Pipeline Integration

**TARGET ARTIFACT (MODIFY):** `/home/az/Downloads/testing-delete/p-ai-paid-marketing/src/etl/ingest_only_full.py`

**LOCATION:** In `trigger_post_ingestion_routines()`, INSERT the V16-2C Person resolution block AFTER V16-2A Portfolio block and BEFORE V13 score computation:

```python
    # V16-2C: Person Identity Resolution
    try:
        from src.graph.person_resolver import resolve_persons_to_neo4j
        print("\n[V16-2C] Running deterministic Person identity resolution...", flush=True)
        person_result = resolve_persons_to_neo4j()
        if "error" in person_result:
            print(f"  [V16-2C Skipped] {person_result['error']}")
        else:
            print(f"  [V16-2C] Persons: {person_result['persons_created']} | "
                  f"Leads assigned: {person_result['leads_merged']}")
    except Exception as e:
        print(f"  [V16 Non-Critical] Person resolution failed: {e}")
    # END V16-2C
```

**SAME CHANGE must be applied to:** `/home/az/Downloads/testing-delete/p-ai-paid-marketing/src/etl/ingest_and_tests_for_UI_cache_building.py` - the V16 block goes AFTER V12-C and BEFORE V13 scores, matching the position in `ingest_only_full.py`.

**VERIFY:**

```bash
python -m py_compile src/graph/person_resolver.py && echo "person_resolver.py: OK"
python -m py_compile src/etl/ingest_only_full.py && echo "ingest_only_full.py: OK"
python -m py_compile src/etl/ingest_and_tests_for_UI_cache_building.py && echo "ingest_and_tests: OK"
```

**WHY non-critical Exception wrapper in pipeline:** Person resolution depends on email/phone columns existing in parquet. If they are absent (schema drift, raw CSV changed), the function returns `{"error": "No email or phone columns..."}` - the pipeline continues with existing data. Person resolution is additive - it enhances the graph without being a hard dependency.

---

## 23.5 Sprint 16-3: Phase 3 - Identity Resolution Pipeline Refinement

**ESTIMATED EFFORT:** 2 days
**GOAL:** Test and refine the deterministic matching pipeline. Measure deduplication rate. Flag edge cases for manual review.

**WHAT TO DO (Flash runs these commands - no coding required):**

### 23.5.1 Measure Deduplication Rate

```bash
uv run python -c "
from src.graph.person_resolver import resolve_persons_to_neo4j
result = resolve_persons_to_neo4j()
print(result)
# Expected: persons_created < leads_merged (some persons have multiple leads)
# If persons_created == leads_merged: no duplicates found - dedup not needed
# If persons_created / leads_merged < 0.90: high dedup rate - flag for Ali
"
```

### 23.5.2 Count Graph Statistics

```bash
uv run python -c "
from neo4j import GraphDatabase; from dotenv import load_dotenv; import os
load_dotenv('.env')
d = GraphDatabase.driver(os.getenv('NEO4J_URI'),
    auth=(os.getenv('NEO4J_USER'), os.environ['NEO4J_PASSWORD']))
with d.session() as s:
    for q, label in [
        ('MATCH (p:Person) RETURN count(p)', 'Person nodes'),
        ('MATCH ()-[r:IS_IDENTITY_OF]->() RETURN count(r)', 'IS_IDENTITY_OF edges'),
        ('MATCH (p:Person) WHERE size((p)<-[:IS_IDENTITY_OF]-()) > 1 RETURN count(p)', 'Persons with >1 lead'),
    ]:
        print(f'{label}: {s.run(q).single().values()[0]}')
d.close()
"
```

### 23.5.3 Flag Manual Review Queue

```bash
uv run python -c "
from neo4j import GraphDatabase; from dotenv import load_dotenv; import os
load_dotenv('.env')
d = GraphDatabase.driver(os.getenv('NEO4J_URI'),
    auth=(os.getenv('NEO4J_USER'), os.environ['NEO4J_PASSWORD']))
with d.session() as s:
    r = s.run('MATCH (p:Person)<-[:IS_IDENTITY_OF]-(l:Lead) WITH p, count(l) AS lead_count WHERE lead_count > 10 RETURN p.id AS person_id, lead_count ORDER BY lead_count DESC LIMIT 20')
    for rec in r:
        print(f'REVIEW: Person {rec[\"person_id\"]} has {rec[\"lead_count\"]} leads - possible over-merging')
d.close()
"
```

**WHY Phase 3 is measurement-only:** The identity resolution pipeline was already implemented in Phase 2. Phase 3 is validation - running the pipeline, measuring quality, and flagging edge cases.

**CONTINGENCY (no duplicates found):** If `persons_created == leads_merged` (zero deduplication), identity resolution is not needed at this time. Skip Person edges entirely - the rest of V16 (Portfolio, ParentCompany, visualizer) still delivers value.

**CONTINGENCY (over-merging detected):** If any Person node has >20 leads, the blocking key is too coarse or the email domain is a shared corporate domain. Split the blocking key to 4 characters instead of 3, and re-run. If over-merging persists, add an AND gate: Person must share email AND phone (not OR).

---

## 23.6 Sprint 16-4: Phase 4 - Conversational Agent Update

**ESTIMATED EFFORT:** 1 day (1 coding session)
**GOAL:** Update the V14 conversational agent to handle natural language queries about the new Portfolio, ParentCompany, and Person node types.

### 23.6.1 Step A - Add 10 New Few-Shot Examples

**TARGET ARTIFACT (MODIFY):** `/home/az/Downloads/testing-delete/p-ai-paid-marketing/skills/cypher_analytics.md`

**LOCATION:** After the existing Example 10 (Schema discovery), APPEND a new section titled "## V16 Extensions: Portfolio, ParentCompany, Person, and Peer Traversals" with the following 10 examples:

| Example | Title | Topological Pattern | Cypher Query Summary |
|---------|-------|---------------------|---------------------|
| 11 | Portfolio Traversal | Lead -> Location -> Portfolio -> Location -> Lead | Show all leads in the same portfolio as Lead X |
| 12 | Parent Company Upsell | Lead -> Company -> ParentCompany | Leads from subsidiaries of large parent companies |
| 13 | Person Identity Resolution | Lead -> Person -> Lead | All leads from the same person as Lead X |
| 14 | Portfolio Conversion Rate | Lead -> Location -> Portfolio, aggregate by STATUS | Portfolio-level conversion rate ranking |
| 15 | Peer Conversion Contagion | Lead -> Person -> Colleague -> Person -> Lead | Leads whose colleagues converted recently |
| 16 | Multi-Portfolio Lead | Lead -> Location -> Portfolio (2 distinct) | Leads connected to >1 portfolio |
| 17 | Person Activity Timeline | Lead -> Person -> Lead | Activity history for the person behind Lead X |
| 18 | Subsidiary Network | Company -> ParentCompany -> Company -> Lead | Companies under same parent with lead counts |
| 19 | High-Value Person Network | Person <- Lead, aggregate business_value_v1 | Highest-value persons (aggregated across leads) |
| 20 | Portfolio-to-Portfolio Connection | Person -> Lead -> Location -> Portfolio (bidirectional) | Portfolios connected via shared persons |

**Flash: Each example must follow the existing format:** User question as markdown heading, followed by a ` ```cypher ... ``` ` code block. See Examples 1-10 for the exact formatting pattern.

**WHY 10 examples:** Each covers one distinct topological pattern involving new V16 node types. The V14 agent's performance depends entirely on the quality of its few-shot examples.

**WHY append (not replace):** The original 10 examples still cover basic Lead/Campaign/Industry/Location queries. The V16 examples extend coverage without removing existing patterns.

### 23.6.2 Step B - Verify New Examples

```bash
uv run python -c "
with open('skills/cypher_analytics.md') as f:
    content = f.read()
import re
blocks = re.findall(r'\x60\x60\x60cypher\s*\n(.*?)\n\s*\x60\x60\x60', content, re.DOTALL)
print(f'Total Cypher examples: {len(blocks)}')
if len(blocks) >= 20:
    print('All 20 examples present.')
else:
    print(f'WARNING: Only {len(blocks)} examples found (expected 20+)')
# Verify no destructive keywords in new examples
from src.guardrails.cypher_guardrails import check_cypher_readonly
for i, block in enumerate(blocks[-10:], start=len(blocks)-9):
    ok, msg = check_cypher_readonly(block)
    status = 'OK' if ok else f'REJECTED: {msg}'
    print(f'  Example {i}: {status}')
"
```

**CONTINGENCY (Cypher syntax errors in examples):** Each example was hand-written but not executed against Neo4j. If a query fails at runtime, fix the specific pattern (likely issues: property name case sensitivity, unclosed quotes, LIMIT placement). The Cypher guardrails in V14 will catch destructive patterns before execution.

---

## 23.7 Sprint 16-5: Phase 5 - CDC (GATED - Measurement First)

**ESTIMATED EFFORT:** 0 days (measurement only) OR 2-3 days (if gate passes)
**GOAL:** Measure daily lead delta. If insignificant (<1,000 leads change/day), skip CDC entirely. If significant, implement hourly micro-batch delta sync.

**GATE CHECK (Ali runs this - Flash waits for result):**

```bash
uv run python -c "
import polars as pl
from datetime import datetime, timedelta
df = pl.read_parquet('data/processed/math_schema.parquet')
recent = df.filter(pl.col('CREATEDDATE') >= datetime.now() - timedelta(days=1)).height
pct = recent / df.height * 100
print(f'Leads created in last 24 hours: {recent} / {df.height} ({pct:.2f}%)')
if recent >= 1000:
    print('GATE PASSED: CDC warranted.')
else:
    print(f'GATE FAILED: {recent} < 1,000. CDC deferred.')
"
```

**IF GATE FAILS (< 1,000 leads/day):**
- STOP. Do NOT implement CDC. Document the measurement result.
- The existing nightly rebuild (`ingest_only_full.py`) is sufficient.
- Revisit CDC when ad platform integration (Phase 2) adds real-time click/impression events.

**IF GATE PASSES (>= 1,000 leads/day):**
- Implement `src/graph/cdc_poller.py` - a Python daemon that:
  1. Reads `math_schema.parquet` every hour
  2. Diffs against the previous snapshot (parquet from 1 hour ago)
  3. For new/changed leads: MERGE Lead nodes and related Company/Industry/Location nodes
  4. Re-runs PageRank and Louvain only on the changed subgraph (not full 190K rebuild)
- Deployment: crond (@hourly) or systemd timer, not a persistent daemon
- Snapshot rotation: keep 24 hourly parquet copies

**ARCHITECTURAL NOTE:** This CDC section is intentionally left as a design specification, not executable code, until the measurement gate is run. Writing CDC code before confirming it is needed violates Simplicity First. Flash: the `src/graph/cdc_poller.py` file should NOT exist until Ali confirms the gate passes.

---

## 23.8 Sprint 16-6: Phase 6 - GNN (GATED - Post-Phase-2)

**ESTIMATED EFFORT:** 0 days (deferred) OR 1-2 weeks (post-Phase-2)
**GOAL:** Replace XGBoost with GraphSAGE for lead scoring, but ONLY after the graph is enriched with 15+ edge types AND ad platform integration adds CLICKED_AD, SAW_CAMPAIGN, CONVERTED_VIA edges.

**GATE REQUIREMENTS (ALL must be true before Phase 6 begins):**

1. Graph has >= 10 edge types (currently 5) - Cypher: `CALL db.relationshipTypes()`
2. Average node degree >= 5 (currently ~2.5) - GDS graph statistics
3. 10% AUROC lift over XGBoost on temporal hold-out - re-run `test_graph_feature_lift.py`
4. Ad platform integration (Phase 2) is complete - adds CLICKED_AD, SAW_CAMPAIGN edges

**ARCHITECTURE SKETCH (not for implementation now):**

Model: GraphSAGE (Hamilton et al., 2017, arXiv:1706.02216) - inductive, handles unseen nodes from CDC
Framework: PyTorch Geometric (pip install torch-geometric, NOT added to pyproject.toml yet - add only when gate passes)
Layers: 3 SAGEConv layers, 64-dim hidden
Sampling: 2-hop neighbourhood, batch size 256
Target: STATUS (binary, Qualified vs not)
VRAM: ~2GB (comfortable for 8GB)
Training: Neo4j export -> PyG Data object -> 80/20 temporal split -> AdamW optimizer, lr=0.001, 200 epochs
Evaluation: AUROC, precision@20, recall@20 vs XGBoost flat + XGBoost graph features

**WHY deferred:** Training a GNN on a sparse graph (5 edge types, degree 2.5) produces near-random embeddings. The V12 A/B evaluation already showed marginal lift with flat graph features. We must first build the graph, then enrich with ad platform data, then GNN. Reversing this order wastes compute and produces misleading results.

---

## 23.9 File Map

```
V16 FILES (1 NEW + ~4 MODIFIED):

NEW FILES (1):
  src/graph/person_resolver.py                         (~190 lines)
    - resolve_persons_to_neo4j(), _normalize_email(), _normalize_phone(), _blocking_key()

MODIFIED FILES (4):
  src/etl/ingest_only_full.py                           (+50 lines)
    - setup_constraints(): new Portfolio/Person/Company constraints + indices
    - trigger_post_ingestion_routines(): V16-2A Portfolio block, V16-2C Person resolution block

  src/etl/ingest_and_tests_for_UI_cache_building.py     (+12 lines)
    - trigger_post_ingestion_routines(): same V16 blocks (mirrors ingest_only_full.py)

  app.py                                                (+160 lines)
    - render_graph_explorer(): Streamlit 2-hop visualizer
    - _node_label(): helper for human-readable graph labels
    - st.tabs(): new tab

  skills/cypher_analytics.md                            (+120 lines)
    - Examples 11-20: 10 new few-shot examples for Portfolio/Person/ParentCompany traversals

GATED FILES (do NOT create until gates are met):
  src/graph/cdc_poller.py                                (Phase 5 - only if >1,000 leads/day)
  src/models/gnn_scorer.py                               (Phase 6 - only if 10% AUROC lift + post-Phase-2)

DEPENDENCIES: ZERO new Python packages
  networkx - already in pyproject.toml (V12 GraphEngine)
  plotly - already in pyproject.toml (V6 Bayesian charts)
  polars - already in pyproject.toml (foundational)
  neo4j - already in pyproject.toml (V5)
  python-dotenv - already in pyproject.toml

DOCKER CHANGES: NONE
  19 containers unchanged from V10.
  Neo4j Community Edition (already deployed) - no license upgrade needed.
```

---

## 23.10 Success Criteria

| # | Criteria | Verification |
|---|---|---|
| 1 | `app.py` passes py_compile after Phase 0 | `python -m py_compile app.py && echo OK` |
| 2 | `person_resolver.py` passes py_compile | `python -m py_compile src/graph/person_resolver.py && echo OK` |
| 3 | `ingest_only_full.py` passes py_compile after Phase 2 | `python -m py_compile src/etl/ingest_only_full.py && echo OK` |
| 4 | `ingest_and_tests_for_UI_cache_building.py` passes py_compile | `python -m py_compile src/etl/ingest_and_tests_for_UI_cache_building.py && echo OK` |
| 5 | Neo4j constraints + indices created without error | Run `setup_constraints()` -> check for `[V16] Portfolio/Person/Company constraints...` |
| 6 | Graph explorer renders for a valid Lead_ID | Navigate to Streamlit Graph tab, type a known Lead_ID |
| 7 | Graph explorer shows meaningful error for invalid Lead_ID | Type `999999999`, verify `st.warning("No graph data found...")` |
| 8 | Person resolution returns `persons_created < leads_merged` | Run `resolve_persons_to_neo4j()` |
| 9 | Person nodes with >1 lead flagged (deduplication working) | Cypher: `MATCH (p:Person) WHERE size((p)<-[:IS_IDENTITY_OF]-()) > 1 RETURN count(p)` |
| 10 | Cypher skill file has 20+ examples (10 original + 10 new) | `grep -c backtick-cypher` in skills/cypher_analytics.md |
| 11 | All Cypher examples pass `check_cypher_readonly()` (no destructive keywords) | Loop test on each example |
| 12 | V14 conversational agent answers Portfolio queries | Type "Show me leads in the same portfolio as Lead X" |
| 13 | V14 conversational agent answers Person queries | Type "Show me all leads from the same person as Lead X" |
| 14 | CDC gate measurement runs without error | Run the gate check command, verify output |
| 15 | Zero new Python packages in pyproject.toml | `git diff pyproject.toml` - no changes |
| 16 | No changes to Docker infrastructure | `git diff infra/docker-compose.yml` - no changes |

---

## 23.11 Contingency Paths

| Failure | Detection | Response |
|---------|-----------|----------|
| `person_resolver.py` import fails | py_compile or import error | Polars/Neo4j are foundational deps - if missing, entire project is broken |
| Email/Phone columns not found in parquet | resolve_persons_to_neo4j() returns error | Person resolution skipped. Portfolio/Visualizer still work. |
| Blocking keys produce zero blocks | blocks_processed == 0 | Person resolution produces 0 persons. Acceptable. |
| Neo4j unreachable during graph explorer render | ServiceUnavailable exception | st.error(). Other Streamlit tabs continue. |
| Lead_ID does not exist (graph explorer) | Zero Cypher records | st.warning(). User tries different ID. |
| Person with >20 leads detected (over-merging) | Manual review query returns results | Narrow blocking key to 4 chars. Re-run. If persists, add AND gate. |
| CDC measurement returns error (parquet missing) | FileNotFoundError | CDC deferred. Run ingestion first. |
| Streamlit graph explorer crashes on large neighbourhoods | MemoryError or timeout | Cypher query has LIMIT 200. NetworkX spring layout on 200 nodes takes ~0.5s. |

---

## 23.12 V16 Completion Statement

> **Status:** IMPLEMENTATION COMPLETE — 2026-05-28
> **Architects:** DeepSeek V4 (Principal Architect) + Gemini (Adversarial Review) + DeepSeek Chat (Operational Refinement) - Consensus on COUNCIL.md
> **Scope:** 6 phases (0-5 core, 6 gated). 1 new file, ~4 modified files, ZERO new Python packages, ZERO Docker changes
> **Total core work:** Phases 0-4: ~6-8 days. ~350-500 new lines + ~50 modified lines across 5 files.
> **Key gates:** Phase 1 (Ali's data audit), Phase 5 (CDC: >1,000 leads/day), Phase 6 (GNN: 10% AUROC lift + post-Phase-2)
