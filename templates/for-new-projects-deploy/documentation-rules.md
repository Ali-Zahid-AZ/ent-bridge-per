# DOCUMENTATION RULES — Per-Phase Documentation Protocol

**Status:** Canonical. Owned by Ali. Agents read-and-obey; only Ali edits the protocol itself.
**Purpose:** Define exactly *what must be documented* and *which canvases must be updated* on every phase completion, so the project's documentation never drifts behind its code and experiments.

> **When this fires:** at the close of **every phase** (Phase 0, 1, 2, …) and at any milestone the user declares "phase-complete". It is a release gate: a phase is NOT "done" until this protocol is satisfied.

---

## 1. The Per-Phase Documentation Set (CREATE for each phase)

For phase *N*, the following artifacts MUST exist before the phase is declared complete. Each lives in its category folder with parallel `markdown/` and `html/` (+ rendered `.png`) subtrees.

| # | Artifact | Location | Purpose |
|---|----------|----------|---------|
| 1 | **Detailed Implementation Plan** — `phase-N-implementation-plan.md` | `docs/documentation/implementation-plans/markdown/` | The full step-by-step plan at V*-DETAILED depth (constraints, tracks, exit checklist). The live working copy starts in root `IMPLEMENTATION_PLAN.md` and is **archived here** on phase close, the root file replaced by a summary + completion statement. |
| 2 | **Playbook** — `phase-N-playbook.md` | `docs/documentation/playbooks/markdown/` | The operational runbook: exact commands, manual GPU experiments, expected artifacts, recovery steps. The reproducible "how to re-run this phase" companion to the plan's "what/why". |
| 3 | **Detailed Explanation** — `phase-N-detailed-explanation.md` | `docs/documentation/detailed-explanations/markdown/` | First-principles narrative of what the phase established and why, modeled on `DETAILED-EXPLANATION-BLUEPRINT.md`. **Note:** `docs/primitives/` is reserved for project-wide overview docs (BLUEPRINT, the project-level detailed explanation) — NOT individual phases. Per-phase explanations always live here. |

> **[Ali, 2026-06-18] Detailed-Explanation content mandate (stage = phase, interchangeable):** for EACH stage/phase the detailed-explanation document MUST contain all four, in full: (1) **full theoretical background** (the first-principles theory underpinning the stage), (2) **experimental details** (exact setup, configs, seeds, hardware envelope, procedure), (3) **results** (the measured numbers/artifacts the stage produced), and (4) **analysis of the results** (interpretation, what the numbers mean, fidelity verdicts, threats to validity). A detailed explanation missing any of these four for any stage is incomplete.
| 4 | **Architectural Schematic(s)** — `phase-N-<topic>.html` → `.png` | `docs/architectural-diagrams/html/` (HTML source) + `docs/architectural-diagrams/` (rendered `.png`) | Hand-authored HTML → deterministic PNG via the `generate-architecture-diagram` skill. At minimum: the phase's pipeline/flow or governance/envelope diagram. Re-render whenever the diagram's facts change. |
| 5 | **Completion Report** — `phase-N-completion-report.md` | `reports/` | All findings, verdicts, measured numbers (peak VRAM/RAM/disk, wall-clock), and exit-checklist pass/fail for the phase. |

**Architectural-diagram rule:** every schematic is produced via the `generate-architecture-diagram` skill (hand-authored HTML → `render_diagram.py` → PNG). Never hand-edit a PNG; edit the HTML and re-render. Keep HTML and PNG in sync — a stale PNG is a documentation defect.

### 1.1 Plan Migration / Archival (when Ali asks to "migrate" a phase plan)

On phase close, the live `IMPLEMENTATION_PLAN.md` body for that phase is **archived verbatim** and replaced by a summary. When asked to migrate, follow this exactly:

1. **Copy verbatim** the phase's plan body — from its `# IMPLEMENTATION PLAN — PHASE N …` heading up to (but **not** including) its `## N. Phase N — Completion Statement` section — into `docs/documentation/implementation-plans/markdown/phase-N-implementation-plan.md`. Byte-for-byte; no edits, no re-wording, no re-numbering.
2. **Never migrate or summarize the Completion Statement.** That section stays in `IMPLEMENTATION_PLAN.md` as-is (per this file's §3 and the plan's own instruction header).
3. **Never touch the instructions header** of `IMPLEMENTATION_PLAN.md` (everything at/above the `STRICTLY PROHIBITED` line).
4. **Replace** the archived body in `IMPLEMENTATION_PLAN.md` with a concise summary that: states the phase status, **links to the verbatim archive**, and preserves objective · owners · tracks · key frozen decisions · outcome — enough to navigate without the full detail. The Completion Statement then follows directly below the summary.
5. **Mechanics:** use the sanctioned Python exact-match split (assert each marker count == 1; slice on the markers; atomic write-back) — never `sed`/`awk`. Verify after: archive head/tail correct, root contains the summary + Completion Statement and **no** leaked body sections.
6. **Log** the migration in `AGENT_CHANGES.md` (real PKT, head re-read). Only Ali commits.

---

## 2. The Must-Update Canvases (UPDATE on every phase completion)

These three root canvases MUST be updated whenever a phase completes (and continuously during it, per their own rules):

| Canvas | Update obligation | Ordering | Timestamp |
|--------|-------------------|----------|-----------|
| **`DYNAMIC_LEDGER.md`** | New/updated task entries for the just-completed phase + granular next steps. Re-tag state ([PENDING]/[IN_PROGRESS]/[BLOCKED]/[DONE]); never delete. Supersedes the deprecated `STATUS.md` + `TO-DO.md`. | Newest at **top**, below the prohibited line. | `### [YYYY-MM-DD HH:MM:SS PKT] \| [TAG] \| Topic` — real PKT via `time_get_current_time` (`Asia/Karachi`). |
| **`FUNCTION_MAP.md`** | Every new/changed operational function, filed under its code file. Never delete without Ali's approval. | By code-file grouping. | n/a |
| **`AGENT_CHANGES.md`** | One comprehensive entry per code change / phase milestone (context, file changes, results, next). Append-only. | Newest at **top**, below the prohibited line. Re-read top-5 + re-acquire PKT before each write (no chronological inversion). | `## [YYYY-MM-DD HH:MM:SS PKT] \| Agent \| summary` |

**Append-only discipline (all three + COUNCIL):** never delete, truncate, reorder, or overwrite existing content. Only Ali purges. For `AGENT_CHANGES.md` / `DYNAMIC_LEDGER.md` / `COUNCIL.md`, always write against a *freshly re-read* head; `sed -i`-style tools that snapshot a stale body are forbidden.

---

## 3. Phase-Completion Checklist (the gate)

A phase is **complete** only when ALL of the following are true:

- [ ] Detailed Implementation Plan archived to `docs/documentation/implementation-plans/markdown/phase-N-implementation-plan.md`; root `IMPLEMENTATION_PLAN.md` replaced by a summary + **completion statement** (+ a "Files modified/created:" list).
- [ ] Playbook written/updated in `docs/documentation/playbooks/markdown/`.
- [ ] Detailed Explanation written/updated.
- [ ] Architectural schematic(s) authored as HTML and rendered to PNG (kept in sync).
- [ ] Completion Report written to `reports/phase-N-completion-report.md`.
- [ ] `DYNAMIC_LEDGER.md`, `FUNCTION_MAP.md`, `AGENT_CHANGES.md` all updated per §2.
- [ ] All code changes passed the project verification gate (`py_compile` → import-smoke → `ruff F821,F811`).

---

## 4. Authority & Scope

- Only **Ali** edits this protocol, declares phases complete, marks `[CLOSED]`, or purges any canvas.
- Agents operate within their `agent_roles.md` designation; documentation duties bind whichever agent closes the phase.
- This file is referenced at the top of `COUNCIL.md`, `IMPLEMENTATION_PLAN.md`, `DYNAMIC_LEDGER.md`, `FUNCTION_MAP.md`, and in the project `AGENTS.md` rules.

## 5. Documentation Discipline (Anti-Drift Rules)

These rules were proven across multiple projects and are enforceable by any agent:

1. **Per-phase docs are produced ONLY at Ali-declared phase close, never continuously.** Mid-phase documentation drifts — partial results, stale assertions, and "to-be-updated" placeholders contaminate the record. Continuous logging belongs in `AGENT_CHANGES.md` and `DYNAMIC_LEDGER.md`, not in the polished per-phase deliverables. Produce the phase's documentation set in a single concentrated pass at phase close, when all inputs are final.
2. **Hold off writing results into the polished deliverable until ALL inputs are final.** Working numbers stay in ledger/audit canvases until the phase is complete. Leave a breadcrumb comment with headline numbers at the write-in point, then write the full section once. A partially-written detailed explanation with stale numbers is worse than no explanation — it actively misleads.
3. **In any human-review mirror, tag every agent edit inline with an `[AGENT]` provenance marker.** Never silently clean-remirror. The human reviewer must be able to distinguish agent-authored content from Ali-authored content without diffing against git history.

## 6. Testing Convention

Run-specific test artifacts live in `testing/` as tagged files:

```
testing/stage-<N>-section-<TAG>.md
```

**Lab-notebook structure (per test file):**
1. **Header table:** test ID, date/time PKT, agent, stage, section, environment
2. **Setup:** exact configuration, seeds, params
3. **Per-test trace:** input → expected → observed → verdict
4. **Findings:** pass/fail, edge cases, open questions

**Rule:** Testing artifacts NEVER overwrite canonical root deliverables. Test outputs are explorative; deliverables are authoritative. If a test finding changes a deliverable, update the deliverable directly — do not make the test file the canonical source.
