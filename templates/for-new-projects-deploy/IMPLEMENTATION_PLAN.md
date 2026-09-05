> ---
> # IMPLEMENTATION_PLAN: Instructions
> ---

> [!warning] Documentation Protocol 
> See `documentation-rules.md`: the per-phase documentation set: 
>  - plan 
>  - playbook 
>  - explanation 
>  - schematic 
>  - completion report 
>  - the **must-update canvases**
>     - `DYNAMIC_LEDGER` 
>     - `FUNCTION_MAP` 
>     - `AGENT_CHANGES` 
>  - required on every phase completion.

> [!danger] Do NOT delete anything from this file 

> [!warning] Always make the additions at the top of the file such that the current implementation is always at the top

> [!warning] Always provide a detailed, robust, comprehensive, detailed and extensively explained implementation in this file

> [!warning] Post Implementation Tasks
> - AFTER the implementation of each stage/phase 
>  - the detailed implementation plan, in verbatim, would be moved to `docs/documentation/implementation-plans/markdown/` 
>  - whilst a summary will be kept here for reference 
> - The **Completion Statement** for every phase will NOT be summarized and would be kept as it is, in this document.
> - **Terra** will make the summary, when asked by Ali.

> [!warning] MANDATORY: Completion Statement after every phase. 
> - After a phase is successfully implemented, a **Completion Statement** MUST be appended at the END of this file (newest phase's statement at the bottom; never delete a prior one). 
> - It MUST contain, at minimum:
>     - **Header block** — Design / Implementation / Auditor owners · Scope (one line: N files created/modified, key artifacts) · Date (real PKT) · Phase status verdict.
>     - **Implementation Summary** — what was built/decided per track/sub-step (prose, evidence-anchored).
>     - **Verification Results table** — each success criterion / exit-checklist item → ✅/⚠️/❌ Status → Evidence (the artifact or command that proves it). *(Tables preferred — they are easier to follow.)*
>     - **Files created/modified** — explicit list (NEW vs MODIFIED), with one-line purpose + line count where useful.
>     - **Additionally required for this project:** (a) **Auditor verdict** — reference the DeepSeek post-exit audit entry (PASS/FAIL + open findings); (b) **Artifact integrity** — `env_hash`, `git_commit`, and the key result numbers (e.g. headroom, parity) restated from the on-disk JSON, not memory; (c) **Outstanding / deferred items** — anything carried into the next phase (open doc gaps, flagged design items); (d) **Reproducibility pointer** — exact manual command(s) to regenerate the phase's artifacts; (e) **Next-phase hand-off** — the one-line trigger for the following phase.

> [!warning] MANDATORY: Observability via printout statements (ALL scripts). 
> - Every runnable script MUST emit **flushed** (`print(..., flush=True)` or run via `python -u`) printout statements at **every gateway / stage / phase / checkpoint**: e.g. dataset built, model loaded, each phase entered, each artifact written, gate passed/failed. 
> - Any **long loop** MUST emit **periodic progress**: e.g. every 50 of 1000 iterations: reporting `index/total` plus a rate and elapsed time, so progress is externally assessable at a glance.
> - **Why (first principles):** (a) stdout redirected to a file is **block-buffered**: without `flush`/`-u`, nothing appears until the buffer fills or the process exits, so a healthy long run looks dead; (b) a silent long loop is **indistinguishable from a hang** without attaching a debugger. Printout statements are first-class observability, not decoration: `printout statements are our friends`. (ALI, 2026-06-17).
> - **Discipline:** keep the added branch cheap (modulo check); if a progress `if` pushes a function over the Radon CC>10 gate, extract a helper (per the Radon self-correction loop) rather than dropping the print.

> [!danger] It is STRICTLY PROHIBITED to write above this line. Start text from under this line.
