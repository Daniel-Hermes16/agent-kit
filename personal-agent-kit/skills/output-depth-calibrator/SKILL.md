---
name: output-depth-calibrator
description: >
  Calibrate any AI-agent output — QA artifacts, analyses, plans, reviews,
  research summaries, proposals, or explanations — against a self-contained
  depth and quality rubric before drafting or revising it. Use when asked to
  make an answer more thorough, match a previous answer's depth, cross-check
  an output against related skills or documents, improve proposed options,
  audit whether an output is too shallow or too padded, or apply a consistent
  senior-level quality bar. Trigger on phrases such as "same depth as
  before", "make this deeper", "is this thorough enough?", "cross-reference
  the skills", "improve the proposed options", "quality bar", "calibrate the
  output", and "review the depth".
---

# Output Depth Calibrator

Act as a senior reviewer calibrating an output before it is delivered. The
goal is **not** to make every answer longer. It is to make complex outputs
complete, evidence-grounded, cross-checked, and useful for a human decision —
and to keep simple outputs simple.

This skill is a **quality layer**. Use it on top of the skill that owns the
requested artifact (for example
[`../checklist-writer/SKILL.md`](../checklist-writer/SKILL.md),
[`../test-case-creator/SKILL.md`](../test-case-creator/SKILL.md),
[`../story-readiness-reviewer/SKILL.md`](../story-readiness-reviewer/SKILL.md),
[`../automation-ideating/SKILL.md`](../automation-ideating/SKILL.md), or
[`../skill-review/SKILL.md`](../skill-review/SKILL.md)). Never override that
skill's source, access, or output rules. When no owner skill exists — a
non-QA question, a learning explanation, a plan — this skill's rubric and
fallback format are enough on their own.

## Required references

- [`references/depth-rubric.md`](references/depth-rubric.md) — the seven
  dimensions, scoring levels, gates, depth-fit rule, option-improvement
  pattern, minimum bar per output type, generic exemplars, and downgrade
  signals.
- [`../../PERSONA.md`](../../PERSONA.md) — the reviewer's lens (curious,
  evidence-first, decision-oriented).
- [`../../AGENTS.md`](../../AGENTS.md) — especially
  [evidence rules](../../AGENTS.md#evidence-rules) (observation vs.
  prediction; correctness and completeness checks) and
  [safety boundaries](../../AGENTS.md#safety-boundaries).
- The owner skill's `SKILL.md` and the references it requires, when one
  applies.
- [`../evidence-context/SKILL.md`](../evidence-context/SKILL.md) when the
  output depends on tickets, designs, test cases, or code.
- [`../../PROJECT-CONTEXT.md`](../../PROJECT-CONTEXT.md) (optional) for
  project facts; proceed without it and ask only for blocking facts.

## Inputs and stop conditions

Collect only what the requested output needs:

- the user's goal, audience, and requested output type;
- the owner skill (if any) and its required references;
- sources with identifiers, versions or commit SHAs, retrieval dates, and
  known gaps;
- the existing draft or proposed options, when the user asks for improvement;
- relevant context: platform, lifecycle stage, constraints, deadlines, who
  decides.

Stop and ask **one focused question** when:

- the target artifact or its audience is unclear and the answer would change
  the depth or format; or
- who owns the decision is unclear and the output must recommend one.

When source access is missing, follow
[external tool access and secrets](../../AGENTS.md#external-tool-access-and-secrets):
check configured connectors or environment variables without printing values,
attempt read-only access, and disclose what failed.

## Calibration workflow

1. **Select the owner skill.** Identify which skill owns the artifact. If none
   fits, say so and use the rubric plus the fallback format.
2. **Set the depth target.** Classify the request as *narrow* (one fact, one
   fix, one short answer), *standard*, or *complex* (multi-source, multi-option,
   or decision-bearing) using the
   [depth-fit rule](references/depth-rubric.md#depth-fit-rule). Narrow requests
   get a short answer; do not inflate them.
3. **Build an evidence map.** Sort every material statement into `Fact`,
   `Inference`, `Assumption`, `Conflict`, or `Gap`. Each claim in the final
   output must trace to one of these.
4. **Decompose the problem.** Split it into the dimensions that matter here —
   user outcome, affected behavior, platforms/configurations, lifecycle stage,
   verification target, risks, dependencies, and human decisions. Drop
   dimensions that do not apply and say they were omitted by design.
5. **Cross-check adjacent perspectives.** Use the
   [cross-check matrix](references/depth-rubric.md#cross-check-matrix) to pick
   the neighbouring perspectives that are relevant (requirements, design,
   manual testing, automation, API/data, release, team execution, learning
   goal) and check the draft against each.
6. **Raise shallow options.** For each option or recommendation, add the
   problem fit, benefit, cost/constraint, verification, decision owner, and a
   keep / merge / split / downgrade / reject verdict, per the
   [option-improvement pattern](references/depth-rubric.md#option-improvement-pattern).
   Remove options that cannot be supported by evidence or that change scope
   without authorization.
7. **Score and run the gates.** Score the draft on each
   [dimension](references/depth-rubric.md#the-seven-dimensions) (0–2) and run
   the [gates](references/depth-rubric.md#gates). Fix any gate failure. Compare
   with the [minimum bar for the output type](references/depth-rubric.md#minimum-bar-by-output-type)
   and the matching [exemplar](references/depth-rubric.md#generic-exemplars).
8. **Trim.** Apply the conciseness gate: remove any section that adds no
   evidence, risk, traceability, or decision value.
9. **Deliver.** Use the owner skill's format, or the fallback format below.
   Show the calibration scorecard only when the user asked for a depth review
   or audit; otherwise apply it silently.
10. **Disclose residual gaps** — unresolved evidence gaps, assumptions, or
    human decisions — only where they materially affect the result.

## Fallback output format

Use only when the owner skill defines no format. Render sources as clickable
Markdown links whenever a URL was retrieved.

```markdown
# <Artifact title>

## Evidence snapshot
<Sources checked, status, retrieval date / commit SHA, material gaps.>

## Calibrated answer
<The main answer, organized around the user's requested outcome.>

## Options or recommendations
| Option | When it fits | Benefits | Constraints / risks | Verification | Owner / decision | Verdict |
| --- | --- | --- | --- | --- | --- | --- |

## Cross-checks
| Dimension | Result | Evidence or gap |
| --- | --- | --- |

## Human decisions required
<Only decisions the human owner must make.>
```

When the user asked to **audit depth**, add:

```markdown
## Depth scorecard
| Dimension | Score (0–2) | Evidence | Fix applied / proposed |
| --- | --- | --- | --- |
Depth target: <narrow / standard / complex> — Total: <n>/14 — Gates failed: <list or none>
```

## Self-check before delivering

- [ ] Depth matches the request: narrow stayed short, complex is complete.
- [ ] Every material claim is labelled or traceable (correctness), and every
      supplied source or recorded observation is accounted for (completeness).
- [ ] Predictions, expectations, and code-implied behavior are not presented
      as observed results.
- [ ] Each option has a fit condition, tradeoff, verification, and owner.
- [ ] Unused dimensions are omitted on purpose, not left as empty headings.
- [ ] No external system was modified and no credentials or personal data are
      exposed.

## Anti-patterns

- Padding an answer with generic theory when one specific gap, risk, or
  decision would be more useful.
- Treating "longer" as "deeper" — or shrinking a complex answer until the
  evidence and caveats disappear.
- Collapsing facts, inferences, and assumptions into one confident claim.
- Letting an owner skill's template hide contradictions or missing evidence.
- Listing several options that differ in wording but not in decision logic.
- Inventing requirements, designs, results, links, owners, or approval states
  to fill a section.
- Creating or editing tickets, pages, test cases, PRs, or other external
  records while calibrating.
- Using this skill instead of the focused artifact skill; it is a layer on
  top, not a replacement.
