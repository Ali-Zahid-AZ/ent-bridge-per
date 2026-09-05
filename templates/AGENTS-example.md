# Project Context: <PROJECT-CONTEXT>
<!-- Codex/OpenCode project rules template. Copy to the project's canonical AGENTS.md. -->
- **Mission:** <ONE-LINE MISSION — what this project builds and why>
- **North Star:** <NORTH-STAR STATEMENT — the measurable outcome that defines project success>
- **Deliverables:** <LIST OF ARTIFACTS this project produces>

# Project role and session source
Project role assignments, permissions, model/provider assignments, transports,
reasoning, concurrency, review requirements, and session-routing rules are
defined only in this project's `agent_roles.md`. Do not duplicate those rules
here. If `agent_roles.md` is missing, stale, or contradictory, stop
role-sensitive work and report the gap.

Before every external feedback, consultation, or audit dispatch, apply
`$codex-external-agent-availability-preflight` and re-read the current
project's root `external-agent-availability.md` plus `agent_roles.md`. Require
an unexpired `available` row matching the requested seat, provider, and
transport. The manifest is status evidence, never role authority or a handle
registry. Ali supplies or confirms any external session handle through the
approved transient runtime channel or through a document he explicitly
provides or identifies in the current instruction for the exact dispatch.
Verify that the document is current and scoped to the project, seat, provider,
and transport; it is provenance evidence only, never a roster or authority
override. Keep the handle transient and never discover it from an unprovided
file, memory, log, old handoff, or historical registry.

Use these skills for the applicable workflows:
- `$codex-subagent-orchestration` for delegated implementation and review.
- `$codex-opencode-session-ping` for OpenCode session contact.
- `$codex-claudecode-session-ping` for Claude Code session contact.

This file retains only project-domain, safety, evidence, documentation, and
workflow constraints. Ali's explicit authorization remains required for any
project action reserved to Ali.

# File System & Context Management
## Context Discovery
- Respect `pyproject.toml`.
## File Reading
- Read files only when relevant to the current task. For very large files, prefer focused ranges or streaming when practical; read complete contents when the task requires them.
## Pointers over Snippets
- Point to authoritative files for context rather than generating standalone code snippets.

# Operational Guardrails: Strict Constraints
## Deterministic Preference
- Deterministic methods always have preference over probabilistic methods.
## Plan First
- All Agents MUST present a step-by-step execution plan before execution.
## Explicit Consent
- Do NOT modify code, edit files, or execute terminal commands without explicit approval.
## Logic Transparency (WHY)
- Every proposed modification must be accompanied by a "First Principles" explanation.
## Holistic Logic Validation Required
1. All Agents are strictly **FORBIDDEN** from executing localized code modifications in systemic isolation.
2. Before proposing or writing any change—no matter how trivial: the Agent **must thoroughly audit** the overall system architecture, upstream callers, downstream dependencies, and state lifecycles.
3. The Agent's first-principles explanation must prove that the Agent has analyzed the broader codebase topology and that the proposed change preserves macro-architectural integrity rather than merely patching a micro-surface symptom.
4. Apply `$codex-engineering-standards` for Python changes; it contains the Radon thresholds.
## Non-Destructive Testing Mandate
1. Health-check / CI test scripts MUST be read-only assertions on EXISTING artifacts — cached data, logs, ledgers, downloaded assets, and result tables. They must NEVER re-run production pipelines, re-download data, or recompute caches "to verify."
2. Assert on cheap, deterministic properties: file presence + content hashes, schema + row counts, shapes/dtypes, pass/fail records, unitarity, and seed-determinism — never regenerate the underlying data to check it.
3. Expensive regeneration (re-running a pipeline, rebuilding a cache, re-downloading assets) is a developer-facing MANUAL script, NOT part of any automated health-check suite.
4. Anything that allocates significant compute resources is, by definition, not a fast read-only check — gate it behind an explicit manual invocation.
5. Apply `$codex-engineering-standards` for Python changes; it contains the verification procedure.

## Pre-Commit Verification Gate
All code changes MUST pass this three-step gate before being declared "verified":
1. **Syntax (fast pre-check):** `uv run python -c "import py_compile; py_compile.compile('<file>', doraise=True)"`
2. **Import smoke:** `uv run python -c "import <module>"` — catches import-time `NameError`/`ImportError` and module-level execution failures.
3. **Undefined names + redefinitions:** `uv run ruff check --select F821,F811 <files>` — F821 catches runtime `NameError` inside function/`except` bodies; F811 catches shadowing/redefinition bugs.
- Keep the gate FAST and HARDWARE-FREE.
- Do NOT add `pytest` or `mypy` to this gate; consult `$codex-engineering-standards` for the rationale.

<PROJECT-SPECIFIC SECTIONS — uncomment and fill in as needed:

# <Project Class> Protocol
## Reproducibility
1. Set and RECORD seeds for every experiment; document any non-determinism that cannot be removed.
2. Declare the GROUND TRUTH baseline: <what-is-the-ground-truth-baseline>.
## Resource Envelope
1. Every resource-heavy step MUST declare its strategy BEFORE running.
2. Record peak resource usage and wall-clock for every run.
3. Treat the project's envelope as a HARD constraint: if a step would exceed, switch strategy and log the trade-off — never silently fall back.
>

# Strategic Architectural Philosophy
## Production over Prototype
- Every line of code must be resilient and enterprise-grade.
## Ops-First Mentality
- Prioritize platform stability over model intelligence.
## Observability
1. Transparency is non-negotiable.
2. Maintain high-fidelity telemetry.
## Implementation Notes
1. All projects have implementation notes in markdown.
2. Agents are **NOT** supposed to read these notes, unless the user asks explicitly.

# Per-Phase Documentation Protocol: documentation-rules.md
1. A `documentation-rules.md` exists at the project root: the canonical protocol for what must be documented on every phase completion.
2. On EVERY phase close, agents MUST produce the per-phase documentation set — detailed implementation plan (archived to `docs/documentation/implementation-plans/markdown/`), playbook (`docs/documentation/playbooks/markdown/`), detailed explanation, and architectural schematic(s) (HTML→PNG via the `generate-architecture-diagram` skill), plus a completion report in `reports/`.
3. On EVERY phase close, agents MUST update the three must-update canvases: `DYNAMIC_LEDGER.md`, `FUNCTION_MAP.md`, `AGENT_CHANGES.md` (per each file's own ordering/append rules).
4. A phase is NOT complete until the `documentation-rules.md` phase-completion checklist is satisfied. Only Ali edits the protocol or declares a phase complete.

## Project Function Map: FUNCTION_MAP.md
1. Every project will have this file.
2. This file holds all the functions that are operational, in different code files, for the project.
3. This needs to be read for every session and stored in working memory.
4. Any new function that is created or any old function whose functionality has been changed, should be documented in **FUNCTION_MAP**.
5. You cannot delete anything from FUNCTION_MAP.md, without the user's explicit approval.
6. You can only read, write, edit, add and append the functions in their respective places, dictated by which file name they are in the code.

## Changes in the Project Code Files
### Code Changes Logging: AGENT_CHANGES.md
1. For every code change, however trivial, it is imperative to read the AGENT_CHANGES.md (present in the root directory of the project), before implementing the change.
2. For every code change, however trivial, it is imperative to update the AGENT_CHANGES.md.
3. All code changes should be appended, with the new entries, in **reverse chronological order** (newest at the top) in the AGENT_CHANGES.md.
4. It is strictly prohibited to delete any text from AGENT_CHANGES.md, without the user's explicit approval.
5. Agents can only write and append to AGENT_CHANGES.md.
### Concurrent-Write Safety: AGENT_CHANGES.md
1. Review contributors and append serialization responsibilities are defined in `agent_roles.md`; follow the project's `$codex-canvas-write-protocol` for the canonical append.
2. **Before** appending, the active Agent MUST read the **top 5 entries**.
3. After acquiring the current PKT time, the Agent MUST check that its new timestamp is **greater than or equal to** the newest existing timestamp.
4. On detecting a chronological inversion, **HOLD**: re-read, re-acquire time, retry.
5. Writes MUST be append-at-top of a *freshly re-read* file body — never against a stale in-memory copy.
6. `sed -i` and stale-temp-copy editors are FORBIDDEN for this file.

## Task Summary and Logging
1. After completing a task, provide a comprehensive summary of what was done.
2. Append the summary, with a timestamp, to AGENT_CHANGES.md in reverse chronological order.

## Temporal Awareness (Timestamp Accuracy)
1. Before every AGENT_CHANGES.md write, call `time_get_current_time` with `timezone="Asia/Karachi"` to acquire the current PKT time.
2. All AGENT_CHANGES.md timestamps MUST use the exact clock time, formatted as `YYYY-MM-DD HH:MM:SS PKT`.
3. NEVER guess, hardcode, or reuse a stale timestamp.

# Shared Dialectic Canvas: COUNCIL.md
A `COUNCIL.md` at the workspace root is the shared cross-agent deliberation canvas (newest-at-top, append-only, only Ali purges). Its full protocol lives in the file's own header (and the global rules' COUNCIL.md section). Project-specific COUNCIL context (if any) stays below this line.
