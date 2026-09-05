# Statistical Output Boundaries — <PROJECT-NAME>

> **Status: LOCKED (Ali).** This file governs what data leaves the analysis pipeline and in what form. Every agent MUST read this before producing any client-facing output. Only Ali edits.

## The Three Artifact Tiers

| Tier | Name | Contains | Audience | PII Allowed? |
|------|------|----------|----------|--------------|
| 1 | **Log** | Streaming/pipeline output, raw data traces | Operators only | May contain raw PII — NEVER shared externally |
| 2 | **Report** | Aggregate statistics, summaries, charts | Management, stakeholders | NO raw PII — aggregates only (min group size enforced) |
| 3 | **Data** | Structured records for downstream tools | Internal systems, API consumers | Schema-governed, PII stripped or tokenized |

## Schema Governance

1. **LLMs get zero direct raw-data access.** Analysis flows through deterministic pipelines. Agents read pipeline OUTPUT, not raw input.
2. **Never rely on implicit type inference in joins.** Cast explicitly. A silent type coercion in a join is a data defect.
3. **Verify exact column names against the raw source schema before adding dimensions.** Schema drift is the #1 source of silent data corruption.

## Deterministic-Script Audit Convention

Each audit script wraps a project pipeline script and follows this contract:
- **Location:** `audits/<type>/markdown/` with agent-name suffix (`<script>_<agent>.md`)
- **Thresholds:** `pass` / `warn` / `fail` declared in a table at the top
- **Graceful degradation:** runs offline, degrades to `warn:` if a data source is unavailable
- **Timestamped reports:** every run writes to `audits/<type>/markdown/<YYYY-MM-DD_HHMMSS>_<script>_<agent>.md`
