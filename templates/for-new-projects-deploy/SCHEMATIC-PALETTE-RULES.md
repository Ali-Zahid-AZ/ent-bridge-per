# Schematic Palette Overrides — `<PROJECT-NAME>`

> **Status: [LOCKED / PROPOSED] ([date], [who]).** This file declares THIS project's palette overrides relative to the house style in the `generate-architecture-diagram` skill.
> If this file is empty or absent, the house style applies unmodified.
> This file wins where it conflicts with the house style. Only Ali edits or unlocks this standard.

## How to use this file

1. Declare CSS custom property overrides below that deviate from the house palette.
2. Add colour-discipline rules: which colours are used for what, and ONLY for what.
3. Add structural rules specific to this project's figures.
4. Add build/render instructions if they differ from the skill defaults.
5. Every figure in the project follows this file from now on.

## Palette overrides

(Example — replace with project-specific tokens, or delete this block if the house palette applies:)

```css
/* --accent: #2f6f6b;     *//* project accent (badges, ground truth) */
/* --break: #b5482e;      *//* reserved for the ONE mechanism break */
```

## Colour discipline — legitimate uses

(Example — declare per-colour semantics, or delete if house palette suffices:)

| Colour         | Used for, and ONLY for                                                    |
| -------------- | ------------------------------------------------------------------------- |
| `--accent`       | number badges; ground-truth anchor card                                   |
| `--break`        | exactly ONE thing per figure — the mechanism that breaks. Never decorative |
| Neutral palette | everything else — paper, ink, hairlines, card borders                     |

Never reintroduce a colour without adding it to this table first.

## Structural rules

(Example — project-specific structural rules, or delete if house palette suffices:)

1. **Background:** plain `--paper`. No grid lines, no filled banner bars.
2. **Font:** sans-only (`"Segoe UI", Inter, Arial, sans-serif`).
3. **Header:** uppercase letter-spaced kicker → bold title → muted sub → breadcrumb sequence → hairline rule.
4. **Cards:** warm-white fill, `1.5px` `--rule` border, `border-radius:11px`.
5. **Connectors:** warm-dark `--conn`, rounded line caps/joins, filled triangle arrowheads.
6. **Legend (mandatory):** every figure ends with a dot legend.
7. **Thesis tagline:** the figure closes with the italic thesis line.

## Build & render

The default render pipeline is documented in the `generate-architecture-diagram` skill. Override below only if this project needs custom rendering:

```bash
# Default (from the skill):
uv run --with playwright python \
  /path/to/generate-architecture-diagram/assets/render_diagram.py \
  docs/architectural-diagrams/html/<name>.html \
  docs/architectural-diagrams/<name>.png
```

Save BOTH `.html` and `.png`. Page width `1400px`, `2×` scale unless overridden above.

## Migration note

(Record completed palette migrations here as the project evolves.)

