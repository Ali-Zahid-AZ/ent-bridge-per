# Reproducibility & Resource Envelope

## Determinism & Ground Truth
1. Set and RECORD seeds (`torch`, `numpy`, Python `random`) for every experiment; prefer deterministic algorithms (`torch.use_deterministic_algorithms(True)` where feasible) and document any non-determinism that cannot be removed.
2. The <GROUND-TRUTH-BASELINE> is the mechanism GROUND TRUTH; experimental runs are compared against it, never the reverse.

## Resource Envelope (<HARDWARE-ENVELOPE>)
1. Every model-loading step MUST declare its residency strategy (full-GPU / int8 / int4 / CPU-offload / activation-streaming) BEFORE running.
2. Record peak VRAM, peak RAM, peak disk, and wall-clock for every reproduction into the optimization ledger.
3. Treat the project's envelope as a HARD constraint: if a step would exceed, switch strategy and log the trade-off.

## Fidelity Protocol
1. <FILL-IN — define per-project fidelity levels and pass/fail criteria per level>
2. Pin exact checkpoints, configs, and seeds for every probe.
