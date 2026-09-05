# Template — Run-Completion Entry for `AGENT_CHANGES.md`

> **Purpose.** The canonical format for logging a COMPLETED experiment/run (a probe, a
> reproduction, a sweep) into `AGENT_CHANGES.md`. Establishes a uniform, reviewer-grade
> shape: a one-line status header, then `---`-delimited `##` probe sections built from
> **tables first, in-depth numbered analysis second**, closing with throughput / verification
> gate / telemetry / output / pending.
>
> **Reference exemplars** (in `AGENT_CHANGES.md`):
> - `[2026-06-24 21:31:57 PKT] | DeepSeek (Pro V4) | TASK 4 / G1 GPT-2-Small geometry COMPLETE`
> - `[2026-06-25 21:04:14 PKT] | Codex Terra | TASK 4 / G4 GPT-J-6B prefix-invariance COMPLETE`
>
> **Rules that still bind** (do not let the template override them):
> - Append newest-at-top, **below** the prohibited line in `AGENT_CHANGES.md`; never delete/reorder
>   existing entries; run the concurrent-write inversion check; fresh PKT time via the time tool.
> - Tables over prose (Ali preference). Every claim traceable to a number or a file.
> - Report honestly: failed gates stated as failures with the numbers; marginal verdicts disclosed.
> - Fill ONLY the rows/sections that apply; delete the rest. Do not invent rows to fill the shape.

---

## Copy-paste skeleton

```markdown
### [YYYY-MM-DD HH:MM:SS PKT] | Agent: <Name> (<Model>) | TASK <n> / <PROBE-ID> <SHORT TITLE> COMPLETE — <one-line headline verdict + key numbers>

---

## <PROBE-ID> — <full descriptive title (model · mechanism site · what is measured)>

**Script:** `<path/to/script.py>` (<one-line provenance: adapted-from / rewrite / new>).
**Mechanism site:** <layer(s), role, band>; <fit/metric method + exact config flags>. Metric = <metric> (<min/mean/median, gate>).
**Ground truth:** <fp16-CPU / reference artifact + path>; <residency strategy if a model was loaded>.

### Pipeline-integrity gates (sanity checks that make the science trustworthy):

| Gate | Metric | Result | Verdict |
| ---- | ------ | ------ | ------- |
| <e.g. per-block fp32 equivalence> | <max_abs_diff (atol)> | <value> | PASS/FAIL |
| <e.g. batched-vs-sequential / preflight> | <metric> | <value> | PASS/FAIL |

### <Primary result> (the actual probe):

| <axis / seed / precision / comparison> | <metric col 1> | <metric col 2> | Gate | Verdict |
| -------------------------------------- | -------------- | -------------- | ---- | ------- |
| <row> | <val> | <val> | <gate> | PRESERVED/DEGRADED/MIXED/MARGINAL |

### <Secondary table — sweep / cross-model / per-seed / control> (include only if run):

| <param> | <metric min> | <metric mean/median> |
| ------- | ------------ | -------------------- |
| <val>   | <val>        | <val>                |

### Analysis:

**1. <Headline finding>.** <First-principles interpretation tied to the numbers above.>
**2. <Per-condition / per-role / per-precision breakdown>.** <What varies and why.>
**3. <Verdict statement + gate framing>.** <State the literal-gate verdict AND the honest interpretation; disclose marginal/borderline cases.>
**4. <Confound / artifact ruled in or out>.** <Evidence, e.g. a control or sweep.>
**5. <Cross-result / cross-model comparison>.** <Where this sits relative to sibling probes.>
**6. <Rigor caveat (self-flagged)>.** <Single-seed? first-N rows? what would make it bulletproof.>

**Throughput:** <speedup vs baseline, checkpoint/resume behavior> (omit if N/A).
**Verification gate:** py_compile <PASS/FAIL> · ruff F821/F811 <PASS/FAIL> · radon <CC/MI notes> (for code changes).
**Telemetry:** peak RAM <…> GiB · peak VRAM <…> MiB · wall <…> s · model load <…> s.
**Output:** `<path/to/output.json>`.
**Pending Ali/council:** <what is NOT yet written to paper/audit/ledger and why>.

---
```

## Field notes (how to fill it well)

1. **Header line = a self-contained completion signal.** Topic + `COMPLETE` + the verdict and the
   one or two numbers a reader needs. Someone scanning the changelog should grasp the result without
   opening the section.
2. **Tables before analysis, always.** Put every number in a table; the analysis *interprets* the
   tables, it does not re-list them. Keep ≤ ~6 columns per table.
3. **Integrity gates are mandatory for any run that could be doubted.** fp16/fp32 equivalence,
   batched-vs-sequential, preflight vs a reference — these earn the right to report the science.
4. **Verdict framing is explicit and honest.** Give the literal-gate label AND the defensible
   interpretation; never bury a marginal/failed gate. If a framing call changes a paper claim, mark
   it `Pending Ali/council` rather than asserting it.
5. **Always end with the four closers** (Verification gate · Telemetry · Output · Pending) so every
   completed run is reproducible and its downstream state is unambiguous.
6. **Scope honestly.** If only one run is "complete," log one section — do not pad with sibling runs
   that are still pending or belong to another agent.
