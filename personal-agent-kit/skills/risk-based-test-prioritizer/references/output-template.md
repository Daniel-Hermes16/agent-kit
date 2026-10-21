# Output template for risk-based prioritization

```markdown
# Risk-based test depth — <PROJ-123 / feature>

**Scope:** <what the change touches>
**Areas affected:** <e.g. Monthly summary, Transaction sync, Export>
**Risk scale used:** <the default impact × likelihood model, or the team scale named in PROJECT-CONTEXT.md>
**Effort constraint:** <available person-days, or "not constrained">
**Generated:** <YYYY-MM-DD> (draft — a human reviews it before use)

## Risk evidence

| Area | Evidence | Source | Label |
| --- | --- | --- | --- |
| <area> | <e.g. 3 rounding bugs over the past 12 months> | <link or path> | <Fact / Inference / Conflict / Gap> |

<If an area turns up nothing, say so: "No risk evidence found for <area>
in <sources searched>." Treat that line as a finding; it does not show the
area is low risk.>

## Failure pathway and ratings

| Area | Failure pathway (what the user experiences) | Impact category | I (1–5) | L (1–5) | Score |
| --- | --- | --- | ---: | ---: | ---: |
| <area> | <the concrete behavior and what it leads to> | <data loss / wrong info / blocked flow / security-privacy / degraded / cosmetic> | <n> | <n> | <I×L> |

## Proposed test depth

| Area | Base tier | Modifiers applied | Floor | Proposed tier | Rationale | Existing coverage |
| --- | --- | --- | --- | --- | --- | --- |
| <area> | <tier> | <complexity ↑ / exposure ↓ / none, each with its reason> | <floor, or "—"> | <Smoke / Standard / Deep / Exhaustive> | <grounded in the pathway and the evidence> | <case IDs, or "none found"> |

## Unverifiable criteria

| Criterion | Reason no check is possible | Who can resolve it |
| --- | --- | --- |
| <AC ID> | <no oracle, no spec, behavior left unspecified> | <role or "you"> |

## Residual risk statement

<Required in every output. For each area that gets less than its proposed
tier, or that has conditions known to be untested: what stays uncovered, what
the user would suffer if a defect were hiding there, and how such a defect
would come to light.>

## Risk and security flag review

<Include only if the retrieved tickets have such fields. Per ticket, one line
for each domain: consistent / conflict (with the quoted evidence) / not
assessed.>

## Evidence gaps

- **<Blocking / Non-blocking / Clarification recommended>:** <the missing item>
```

## Rendering rules

- List each affected area once — no more, no less — in both the ratings table
  and the depth table.
- Justify depth with the failure pathway and the evidence. Feature size and
  development effort are never a reason.
- All ratings are proposals. Quote any rating the team has recorded word for
  word, and label a disagreement with it `Conflict`.
- When an area has no risk evidence, state that outright.
- Always include the residual-risk statement.
- Frame the whole output as material for a human to decide on; it is not a
  risk sign-off.
