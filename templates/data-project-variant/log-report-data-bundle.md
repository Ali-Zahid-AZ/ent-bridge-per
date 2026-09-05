# Log / Report / Data Infrastructure Bundle — <PROJECT-NAME>

## 1. Log Tier (Streaming / Pipeline Output)
- **What:** raw pipeline output, agent trace logs, ingestion/debug logs
- **Where:** `<PROJECT>/logs/` or structured logging endpoint
- **Retention:** <policy>
- **Access:** operators only; NEVER shared with clients or management

## 2. Report Tier (Aggregate Statistics)
- **What:** summary tables, charts, metrics that answer business questions
- **Where:** `reports/` or BI dashboard
- **Rules:** NO raw PII; minimum group size enforced; every number in a report traces to a pipeline run recorded in AGENT_CHANGES.md
- **Review gate:** every report reviewed by <agent/role> before delivery

## 3. Data Tier (Structured Records)
- **What:** resolved records for API serving, downstream ML, or export
- **Where:** `<PROJECT>/outputs/` or database
- **Schema:** governed by `<project>.schema.json` — every field typed; every join explicit
- **PII handling:** stripped or tokenized before this tier

## Pipeline Integrity Checklist
- [ ] Raw input validated (schema check, null audit, outlier scan)
- [ ] Pipeline determinism confirmed (same input → same output, seed recorded)
- [ ] Output schema validated against the declared data tier schema
- [ ] All joins explicit with type casts — no implicit coercion
- [ ] Every report number traceable to a specific pipeline run
