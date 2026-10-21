# Combined checklist and manual-test output contract

Apply this contract whenever a single request wants a checklist **and**
formal manual test-case proposals in the same answer.

## Ownership

- This skill, `checklist-writer`, writes the exploratory block and
  Sections 1–4.
- [`test-case-creator`](../../test-case-creator/SKILL.md) writes the
  test-case tables that fill Section 5.
- Both work from one evidence record and one traceability matrix, defined in
  [`evidence-model.md`](evidence-model.md).
- The answer has a single shape: no second intro, no second wrap-up, and no
  repeated output from a supporting skill.

## Final order

The draft must contain these markers, top to bottom, exactly as written:

| # | Literal marker | Written by |
| ---: | --- | --- |
| 1 | `--- Exploratory testing` | checklist-writer |
| 2 | `## 1. Generic checklist checks` | checklist-writer |
| 3 | `--- RC-TESTING` | checklist-writer |
| 4 | `## 2. Acceptance Criteria Coverage Test Cases` | checklist-writer |
| 5 | `## 3. Expected Edge Case Test Cases` | checklist-writer |
| 6 | `## 4. Optional Edge Case Test Cases` | checklist-writer |
| 7 | `## 5. Proposed Manual Test Cases for Verification Evidence` | test-case-creator |
| 8 | `<details><summary>Constraints and human decisions</summary>` | shared, once |
| 9 | `<details><summary>Automation references</summary>` | shared, once |

Nothing comes after the two dropdowns. The constraints dropdown collects
context on privacy, security, legal or licensing questions, sensitive claims,
environment evidence, definition of done, and any decision the human owner
has to make. If a tester needs to act on something, it must also appear in
the visible body — never only inside a dropdown.

## Stable identifiers

- Number formal cases `TC-<ticket number>-NN`. Without a ticket key, use
  `TC-DRAFT-NN`.
- Checklist scenarios trace to the AC or requirement ID you preserved during
  normalization.
- When revising after feedback, keep step numbers unchanged where you can;
  renumber only if the order of steps really changed.

## Automation classification

Tag each relevant assertion with one of these labels:

- `Automatable now`
- `Automatable after adding an ID or test seam`
- `Manual visual verification`
- `Manual semantic or content review`
- `Unknown — evidence required`

A linked automation ticket shows intent, not delivery; do not read it as
proof that the automation exists.

## Validation

From inside the `checklist-writer` folder, run the validator on the saved
draft (repeat `--require-trace` once per normalized AC ID):

```bash
perl scripts/validate-output.pl --mode combined --require-trace AC-1 <draft.md>
```
