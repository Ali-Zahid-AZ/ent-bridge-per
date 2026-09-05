# Project Context: <PROJECT-CONTEXT>
<!-- Reusable Codex/OpenCode project-rules template for new projects. This variant
     adds a specification-driven workflow through the registered SDD skill. -->
- **Mission:** <ONE-LINE MISSION — what this project builds and why>
- **North Star:** <NORTH-STAR STATEMENT — the measurable outcome that defines project success>
- **Deliverables:** <LIST OF ARTIFACTS this project produces>

# Project role and session source
Project role assignments, permissions, model/provider assignments, transports, reasoning, concurrency, review requirements, and session-routing rules are defined only in this project's `agent_roles.md`. Do not duplicate those rules here. If `agent_roles.md` is missing, stale, or contradictory, stop role-sensitive work and report the gap.

- Before every external feedback, consultation, or audit dispatch, apply `$codex-external-agent-availability-preflight` and re-read the current project's root `external-agent-availability.md` plus `agent_roles.md`. 
- Require an unexpired `available` row matching the requested seat, provider, and transport. 
- The manifest is status evidence, never role authority or a handle registry. 
- Ali supplies or confirms any external session handle through the approved transient runtime channel or through a document he explicitly provides or identifies in the current instruction for the exact dispatch. 
- Verify that the document is current and scoped to the project, seat, provider, and transport; it is provenance evidence only, never a roster or authority override. 
- Keep the handle transient and never discover it from an unprovided file, memory, log, old handoff, or historical registry.

Use these skills for the applicable workflows:
- `$codex-subagent-orchestration` for delegated implementation and review.
- `$codex-opencode-session-ping` for OpenCode session contact.
- `$codex-claudecode-session-ping` for Claude Code session contact.
- `$codex-spec-driven-development` for applicable non-trivial or ambiguous specification-driven work; its companion routes are listed below.

This file retains only project-domain, safety, evidence, documentation, and workflow constraints. Ali's explicit authorization remains required for any project action reserved to Ali.

# Source-of-Truth and Precedence Rules
When instructions overlap, apply this precedence unless Ali explicitly states otherwise:
1. Ali's current instruction, limited to its stated scope.
2. This project's `AGENTS.md`, `agent_roles.md`, and canonical project rules.
3. Project plans, specifications, ledgers, canvases, and other named state carriers, according to their own headers and authority.
4. Applicable Codex skills as workflow aids.
5. Dated handoffs, memories, archived documents, and conversational context as orientation only.

If a lower-level instruction conflicts with a higher-level source, preserve the higher-level source and report the conflict. Never let a skill, memory, archive, or sub-agent report create authority that is not present in the live rules.

# File System and Context Management
Apply the base project context rules: read only task-relevant files, use focused ranges or streaming for very large files, respect project manifests and ignore files, and point to authoritative files rather than duplicating large snippets. Use `$getting-acquainted-with-project` at project start when the project rules require its onboarding procedure.

# Specification-Driven Development Workflow
For applicable non-trivial, ambiguous, architectural, multi-capability, or feasibility work, use `$codex-spec-driven-development`. The skill is one registered entry point with progressive references; the companion skills below are separate lifecycle routes, not additional authority.

- `$codex-spec-driven-development`: classify scope, map capabilities when needed, surface assumptions, write or review specifications, preserve requirement identity, detect drift, and produce conformance evidence.
- `$author-implementation-plan`: author or freeze the technical plan only after the applicable specification has received the required approval.
- `$codex-engineering-standards`: own engineering quality, Python discipline, verification, and Radon procedures during implementation.
- `$documentation-rules` and `$phase-closeout-documentation`: own local phase documentation and closeout artifacts.
- `$canvas-write-protocol`: own safe append mechanics for project canvases.
- `$codex-subagent-orchestration`: use only when the live role file and Ali's current instruction authorize delegation or independent review.
- `$codex-project-memory-protocol`: use only for project-memory operations.
- `$record-council-convergence`: use only after genuine council convergence or an explicit Ali ruling.

For applicable work, the project principal must know which route is active and must preserve the precedence above. If the required SDD skill is unavailable, report `HOLD`; do not silently use an unregistered bare workflow.

## Local SDD approval boundaries
The project has three distinct human gates:
1. **Specification approval:** authorizes intended behavior and constraints only.
2. **Plan approval:** authorizes the technical approach only.
3. **Execution authorization:** permits the approved implementation actions.

Specification approval and plan approval do not authorize code changes or state-changing terminal commands. A material specification or plan change repeats the affected gate. Only Ali performs approval or completion actions reserved to Ali.

# Operational Guardrails
For non-trivial or ambiguous work, specification precedes plan and plan precedes execution. Planning must not silently change requirements, scope, acceptance criteria, success metrics, or security boundaries. Every proposed modification must explain why it satisfies the approved requirement, constraint, failure mode, or acceptance criterion.

Health-check and CI scripts must assert existing artifacts and must not re-run production pipelines, re-download assets, or recompute caches merely to verify them. Apply `$codex-engineering-standards` for the detailed engineering and verification procedure.

For Python changes, keep the canonical gate visible:
`py_compile` on modified files → import smoke-test (`python -c "import <module>"`) → `uv run ruff check --select F821,F811 <files>` from the project root. The combined engineering standard, Radon loop, detailed procedure, and exemptions live in `$codex-engineering-standards`.

# <Project Class> Protocol
<!-- Optional: replace this placeholder only when the project class requires it. -->
## Reproducibility
- Record seeds and material non-determinism for every experiment.
- Declare the ground-truth baseline: <what-is-the-ground-truth-baseline>.
- Link reproducibility requirements to the applicable `NFR-###` or acceptance criterion in run evidence.

## Resource Envelope
- Declare the strategy before every resource-heavy step.
- Record peak resource usage and wall-clock for every run.
- Treat the project's envelope as a hard constraint; never silently fall back to a different strategy when it materially changes risk or interpretation.
- Encode material resource assumptions in the relevant specification.

# Project-Local Documentation and State Carriers
- `documentation-rules.md` is the canonical project protocol for phase documentation. Use `$documentation-rules` and `$phase-closeout-documentation`; a phase is not complete until its local checklist passes, and only Ali declares phase completion.
- `FUNCTION_MAP.md` is the project inventory of operational functions. Read it as required by project rules; document new or materially changed functions in their source-file sections; do not delete entries without Ali's explicit approval.
- Read `AGENT_CHANGES.md` before code changes and record every applicable change there. Entries are append-only and may not be deleted without Ali's explicit approval. Use `$canvas-write-protocol` for timestamp, head-read, concurrency, and splice mechanics.
- `COUNCIL.md` is the project's append-only dialectic canvas and obeys its own header. Council advice is evidence, not an approved specification change; preserve the chain recommendation → Ali decision → specification delta → plan/task delta → implementation.
- Preserve the project's named ledgers and other state carriers according to their own headers. Do not invent replacement carriers.

# Phase/Task Completion Definition
A specified phase or task is not complete merely because code was written or a technical test passed. Completion requires, as applicable:
1. intended scope implemented;
2. required technical verification passed;
3. every applicable specification acceptance criterion has `PASS`, `FAIL`, or `NOT VERIFIED` evidence;
4. no material specification/code drift remains unresolved;
5. required operational and observability evidence exists;
6. `FUNCTION_MAP.md`, `AGENT_CHANGES.md`, and local documentation obligations are satisfied; and
7. unresolved risks or deviations are recorded and any Ali-only completion action has occurred.

Invoke the registered `$codex-spec-driven-development` skill when this reference applies; it owns the routed traceability, drift, and conformance reference without introducing a machine-specific path into the template.

This template is a source for future projects. Do not edit already-instantiated project rules merely because this template changes.
