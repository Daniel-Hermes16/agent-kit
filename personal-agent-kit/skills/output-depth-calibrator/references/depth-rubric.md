# Depth rubric

A self-contained benchmark for calibrating any agent output. It replaces
"compare with our best past artifacts" with explicit **dimensions**, **gates**,
and **generic exemplars**, so it works on any project — QA or not.

## Contents

- [What "deep enough" means](#what-deep-enough-means)
- [Depth-fit rule](#depth-fit-rule)
- [The seven dimensions](#the-seven-dimensions)
- [Gates](#gates)
- [Cross-check matrix](#cross-check-matrix)
- [Option-improvement pattern](#option-improvement-pattern)
- [Minimum bar by output type](#minimum-bar-by-output-type)
- [Generic exemplars](#generic-exemplars)
- [Downgrade signals](#downgrade-signals)
- [Over-inflation signals](#over-inflation-signals)

## What "deep enough" means

A high-quality output:

1. **Puts evidence first.** It names the sources used, their status, version
   or retrieval date, and what could not be verified.
2. **Decomposes behavior.** It breaks a feature, problem, or decision into
   observable flows, states, platforms, data, dependencies, and outcomes.
3. **Is risk-aware.** It surfaces plausible user, product, data-integrity,
   privacy, security, lifecycle, release, and operational risks — only where
   relevant.
4. **Is traceable.** Claims, checks, and recommendations link back to tickets,
   test cases, designs, repo paths at a commit, or user-supplied input.
5. **Is decision-useful.** It says what can proceed, what is blocked, who
   decides, and what would close each gap.
6. **Is scoped.** It performs no unauthorized external changes and does not
   expand beyond the request.
7. **Is readable.** Tables for comparison, short prose for judgement, no
   process lecture.

## Depth-fit rule

Pick the target before writing:

| Target | Signals | Expected shape |
| --- | --- | --- |
| **Narrow** | One fact, one fix, a yes/no, a definition, a quick command. | A direct answer in a few lines, plus a caveat only if it changes the answer. |
| **Standard** | One artifact from one or two sources; limited options. | The owner skill's format with evidence, main content, and gaps. |
| **Complex** | Several sources, conflicting evidence, multiple options, a decision someone must own, or reusable artifacts (test suites, plans, proposals). | Full evidence map, decomposition, cross-checks, option table, decisions. |

Over-deepening a narrow request is a defect, just like under-deepening a
complex one.

## The seven dimensions

Score each 0–2. Total out of 14. For a **complex** target, aim for ≥ 12 with
no zero; for **standard**, ≥ 9 with no zero on Evidence or Scope; for
**narrow**, only Evidence, Scope, and Readability must score 2.

| # | Dimension | 0 — missing | 1 — partial | 2 — strong |
| --- | --- | --- | --- | --- |
| 1 | **Evidence grounding** | Claims with no source; predictions shown as results. | Sources named but not every material claim is traceable, or gaps are not disclosed. | Every material claim labelled `Fact` / `Inference` / `Assumption` / `Conflict` / `Gap`; every supplied source or recorded observation is accounted for. |
| 2 | **Decomposition** | Treated as one blob ("test the feature"). | Main flow split out; states, platforms, or data variations missing. | Flows, states, platforms/configurations, data, boundaries, interruptions, and recovery broken out where relevant. |
| 3 | **Risk awareness** | Happy path only. | Some negative cases; high-impact failure modes missing. | Relevant high-impact failure modes visible (data loss, privacy, security, time/time zone, connectivity, localization, accessibility, platform differences, lifecycle). |
| 4 | **Traceability** | Nothing links back. | Some links; recommendations or checks float free. | Requirements, cases, designs, tickets, code, and proposed actions linked both ways clearly enough for peer review. |
| 5 | **Decision usefulness** | No recommendation, or a recommendation with no reasoning. | Recommendation without owner, verification, or blocking conditions. | States what proceeds, what is blocked, who decides, and how to verify each option. |
| 6 | **Scope control** | Unrequested changes made or scope silently expanded. | Scope mostly respected; assumptions or out-of-scope items not stated. | Exactly the requested scope; out-of-scope and non-goals named; external systems untouched. |
| 7 | **Readability & concision** | Wall of text or empty boilerplate. | Structured but padded, or terse to the point of ambiguity. | Every section earns its place; tables for comparison; plain language suited to the audience. |

## Gates

Hard checks. Any failure must be fixed or disclosed before delivery.

- **Evidence gate** — Can another reviewer verify each material claim from a
  cited source, repo path at a commit, or disclosed user input?
- **Observation gate** — Are recorded observations kept as recorded, and are
  expectations, predictions, and code-implied behavior labelled as such?
- **Completeness gate** — Is every supplied input (each recorded result, each
  acceptance criterion, each option the user proposed) placed somewhere: used,
  aligned, open question, or not tested/not covered?
- **Scope gate** — No unauthorized changes to trackers, wikis, test
  management, designs, repositories, releases, or other external data.
- **Risk gate** — Are relevant high-impact failure modes visible?
- **Option gate** — Does every option have a fit condition, tradeoff,
  verification, and owner?
- **Conciseness gate** — Can any section be removed without losing evidence,
  risk coverage, traceability, or decision usefulness? If yes, remove it.

## Cross-check matrix

Use only relevant rows. Mark unused rows as omitted by design.

| Perspective | Strong output checks | Where to look |
| --- | --- | --- |
| Product behavior | User goal, observable state, platform parity, system boundary, data source, error and recovery path | [`../../evidence-context/SKILL.md`](../../evidence-context/SKILL.md), [`../../../PROJECT-CONTEXT.md`](../../../PROJECT-CONTEXT.md) |
| Requirements and design | Acceptance-criteria completeness, copy/value oracle, current design version, conflicts, out-of-scope behavior | [`../../story-readiness-reviewer/SKILL.md`](../../story-readiness-reviewer/SKILL.md), [`../../story-edge-case-and-test-designer/SKILL.md`](../../story-edge-case-and-test-designer/SKILL.md) |
| Manual testing | Preconditions, setup, steps, observable expected results, negative/boundary cases, evidence capture | [`../../checklist-writer/SKILL.md`](../../checklist-writer/SKILL.md), [`../../test-case-creator/SKILL.md`](../../test-case-creator/SKILL.md), [`../../exploratory-session-companion/SKILL.md`](../../exploratory-session-companion/SKILL.md) |
| Risk and priority | Impact × likelihood, depth per area, residual risk stated | [`../../risk-based-test-prioritizer/SKILL.md`](../../risk-based-test-prioritizer/SKILL.md), [`../../regression-impact-selector/SKILL.md`](../../regression-impact-selector/SKILL.md) |
| Automation | Automatable vs. manual, stable IDs, test seams, hardware limits, CI evidence, drift | [`../../automation-ideating/SKILL.md`](../../automation-ideating/SKILL.md) |
| Defects | Reproducibility, isolation, impact, evidence, related themes | [`../../defect-report-writer/SKILL.md`](../../defect-report-writer/SKILL.md), [`../../defect-theme-investigator/SKILL.md`](../../defect-theme-investigator/SKILL.md) |
| API / data | Environment, authentication, request purpose, data setup, expected response, cleanup | Project docs or [`../../../PROJECT-CONTEXT.md`](../../../PROJECT-CONTEXT.md) |
| Team execution | Ownership, dependencies, sequence, effort, contingency, handoff, follow-up | [`../../qa-helper/SKILL.md`](../../qa-helper/SKILL.md) |
| Learning goal | For personal learning tasks: is the *why* explained, is there a next step to practise, is the reasoning transferable? | The user's stated goal |

## Option-improvement pattern

When asked whether proposed options can be improved, rewrite each option with
these fields:

| Field | What to add |
| --- | --- |
| Problem fit | The exact evidence gap, risk, or need this option addresses. |
| Benefit | What improves for users, QA, automation, release, or team flow. |
| Cost / constraint | Time, dependency, access, hardware, environment, review, or maintenance cost. |
| Verification | How you would know the option worked. |
| Decision owner | The role that decides (often: you). |
| Verdict | Keep, merge, split, downgrade, or reject — with a one-line reason. |

## Minimum bar by output type

| Output type | Minimum content expected |
| --- | --- |
| Ticket / readiness analysis | Evidence snapshot, acceptance-criteria and flow map, inconsistencies, prioritized questions, readiness status when asked. |
| Manual QA checklist | Scope, assumptions, risk-based scenarios, positive/negative/boundary coverage, evidence capture, non-goals. |
| Manual test case | Preconditions, test data, executable steps, observable expected results, traceability, automation classification. |
| Automation proposal | Manual baseline, coverage matrix, single disposition, implementation outline, limits, review/CI gates. |
| Investigation / comparison tracker | Draft status, source-of-truth note, scope, session metadata, platform model, grouped behavior matrix with per-platform observed results, cross-platform concerns, open questions, routing, source list. |
| Defect report | Title with symptom and context, environment, steps, expected vs. observed, frequency, impact, evidence, workaround. |
| Release / status summary | Criteria, evidence status, blockers, residual risk, draft verdict, who signs off. |
| Code or PR review | Scope reviewed (commit), findings by severity with file/line, why each matters, suggested fix, what was not reviewed. |
| Plan / design doc | Goal, constraints, options with tradeoffs, chosen approach and why, risks, milestones, open decisions. |
| Research summary | Question, sources with dates, findings labelled by confidence, disagreements between sources, what remains unknown. |
| Process / ways-of-working proposal | Current pain point, impact, options, tradeoffs, rollout path, measure of success, owner, review cadence. |
| Learning explanation | Concept in plain words, a worked example, common mistakes, how to check understanding, next step. |

## Generic exemplars

Fictional, short contrasts. Use them to recognise the gap, not as templates.

**Test checklist — recipe app "save favourite"**

- *Weak:* "Verify user can save a recipe. Verify it appears in favourites."
- *Strong:* scope and non-goals; save/unsave from list and detail; offline
  save then reconnect (sync, duplicates); signed-out user; favourites limit
  boundary if one exists (or `Gap: limit not specified`); deleted recipe still
  in favourites; two devices on one account; evidence to capture per check.

**Recommendation — "should we automate the budget-app export test?"**

- *Weak:* "Yes, automation will save time."
- *Strong:* `SPLIT` — automate file generation and row count via API
  (`Fact`: endpoint exists at `<repo>@<sha>`); keep visual check of the opened
  spreadsheet manual (presence-only otherwise); verification: three green CI
  runs; owner: you; blocked until test account data is seeded deterministically.

**Investigation summary — habit tracker streak bug**

- *Weak:* "Streaks reset incorrectly on iOS; code shows the time-zone check
  is wrong, so Android is affected too."
- *Strong:* iOS: observed reset after travelling across time zones (session 2,
  row 14). Android: `Not tested`. Code at `<sha>` suggests a local-midnight
  calculation (`Inference`, explains iOS observation). `Gap`: Android
  behavior. Next: run the same steps on Android before claiming parity.

**Code review — small PR**

- *Weak:* "Looks good, maybe add tests."
- *Strong:* reviewed `<base>..<head>`; one high finding (null user on first
  launch, `file.ts:42`, crash path) with a suggested guard; one low naming
  note; not reviewed: generated files; verdict: request changes on the high
  finding only.

**Narrow question — "what does HTTP 409 mean?"**

- *Strong:* one or two sentences ("Conflict: the request clashes with the
  current state of the resource, for example a version mismatch on update").
  No evidence table, no options. Depth fit is part of quality.

## Downgrade signals

Revise the output when you see any of these:

- a recommendation without evidence, verification, or owner;
- a checklist that follows only happy paths;
- a test case with vague expected results such as "works correctly";
- automation confidence based only on element presence or prior intent;
- a readiness or status verdict that hides unresolved blocking assumptions;
- several options that differ in wording but not in decision logic;
- a result for a platform or state that nobody recorded;
- no mention of what could not be checked.

## Over-inflation signals

Trim the output when you see any of these:

- a narrow question answered with headings, tables, and a decisions section;
- generic theory repeated from the owner skill instead of applied to the case;
- empty or "N/A" sections kept for symmetry;
- the same caveat repeated in several sections;
- more options than real decision branches.
