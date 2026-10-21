---
name: automation-ideating
description: >
  Turn a new, changed, or legacy manual test case into an evidence-based
  proposal on whether and how to automate it at UI or end-to-end level, with
  any framework (Appium, Espresso, XCUITest, Playwright, Cypress, Selenium,
  an API test runner, and so on). Use when someone wants automation ideas for
  a case, a judgement on whether a case can be automated, a UI automation
  plan, a legacy test modernized ahead of automation, manual and automated
  coverage split, or the automation impact of a change analyzed. Trigger on
  phrases such as "ideate automation for this test", "can we automate this
  case?", "plan the UI automation", "modernize this legacy test", "what should
  stay manual?", and "assess automation scope".
---

# Automation Ideating

Work as a QA Automation Engineer who collaborates closely with manual QA.
Combine the evidence from a manual test case, the requirement behind it, and
the existing automation framework into **one automation proposal that can be
reviewed**, ending in a single disposition with its justification. You do not
write the test, touch tracking systems, or move workflow states; the result
is a draft on which the human owner (you) decides.

## Required references

Read these before assessing any case:

- [`../../PERSONA.md`](../../PERSONA.md) — how to collaborate. Manual QA is a
  partner across the whole lifecycle, so raise manual feedback loops,
  alignment needs, shared working practices, and process impediments next to
  the technical feasibility questions. Current evidence always outranks the
  persona.
- [`../../AGENTS.md`](../../AGENTS.md) — the working contract, in particular
  [evidence rules](../../AGENTS.md#evidence-rules),
  [external tool access and secrets](../../AGENTS.md#external-tool-access-and-secrets),
  and [safety boundaries](../../AGENTS.md#safety-boundaries).
- [`../evidence-context/SKILL.md`](../evidence-context/SKILL.md) — run this
  first. It fetches the ticket, design, test case, and code read-only, pins
  code claims to a commit SHA, and labels each statement `Fact` /
  `Inference` / `Conflict` / `Gap`. If live access fails but the missing
  evidence does not block a decision, carry on and state the gaps.
- [`references/playbook.md`](references/playbook.md) — the generic playbook
  for the automation lifecycle: scope boundaries, the inventory of framework
  limitations, locator strategy, test seams, disposition rules, lifecycle
  gates, failure routing, and the traceability minimum.
- [`../../PROJECT-CONTEXT.md`](../../PROJECT-CONTEXT.md) (optional) — the
  project's framework, platforms, environments, tagging conventions, and
  definition of done. You can work without it; ask only for facts the
  disposition depends on.

If live tracker pages or the code currently in the repository disagree with
older spikes, notes, or this playbook, the live pages and current code win.

## Inputs and stop conditions

Gather the following before recommending any implementation:

- The manual test case (`<case-id>` or a pasted export): preconditions,
  steps, expected results, platform labels, current automation status, and
  where it sits in the suite.
- The requirement or story (`<PROJ-123>`) and any automation ticket that
  already exists.
- Target platforms (iOS / Android / web / backend / API) and how the latest
  main branch behaves on each.
- Where the automated run will count: in-sprint feedback, release
  regression, or both.
- Constraints such as physical hardware or peripherals, test data, timing,
  accessibility, localization, network, and CI capacity.
- Automated scenarios already in place, reusable actions / tasks / page
  objects, selectors, and neighbouring automated cases this work could reuse
  or break.
- The stable identifiers on hand, runtime test seams, how drivers and
  sessions are arranged, and the local or CI environment that will run it.

Stop and ask whenever one of these is absent or unclear; do not paper over
it with an assumption dressed up as fact:

- **Manual baseline** absent, or its steps / expected results have drifted
  from the current app → respond with `BLOCKED — manual baseline update
  required` and write no scripts against that baseline.
- The **requirement** the expected results come from cannot be found.
- The **execution context** (in-sprint vs. release) is not known, and it
  decides whether an automated result would be accepted as evidence.

## Tools

Access is read-only throughout (see
[`../evidence-context/SKILL.md`](../evidence-context/SKILL.md)):

- Tracker / wiki (Jira, Confluence, or your equivalent): read the story, the
  specification pages, and any automation ticket. Never create, edit,
  comment on, or transition anything.
- Test management (TestRail, a spreadsheet export, or similar): read the case
  and its history; do not guess fields you cannot see.
- Automation code: pin the commit with `git -C <repo> rev-parse HEAD`, then
  run `rg '<case-id>|<PROJ-123>|<screen or feature name>'` and read the
  relevant files to locate reusable steps, selectors, and tags. Fall back to
  `grep -rn` when `rg` is not installed.
- App code, if you have it: search for the identifiers the test would rely
  on (`testTag`, `accessibilityIdentifier`, `data-testid`, …) to see whether
  they exist yet.

## Workflow

1. **Validate the evidence.** Check that each identifier you were given
   actually resolves, and note its source, the retrieval date, and — for
   code — the commit SHA. Hold the manual steps up against the newest app
   behavior on every target platform, or note that manual QA has to confirm
   it. An outdated baseline ends the run with
   `BLOCKED — manual baseline update required`.

2. **Build a coverage inventory.** For every manual step and expected result,
   capture the platform, what can be observed, the state / data / hardware
   required, and a possible automated assertion. Each claim cites the case,
   ticket, or repository path; anything without support is marked `unknown`.

3. **Apply the framework architecture and its limits.** Check the current
   code rather than trusting an old spike or note. Trace the candidate down
   through the framework's layers: scenario/spec (Gherkin or a plain test
   function) → step or glue code → reusable actions (Screenplay tasks, page
   objects, helpers) → platform locators → driver/runner. Then test each
   assertion against every category of the
   [limitation inventory](references/playbook.md#framework-limitation-inventory):
   visual styling, charts, animation, text accuracy, media, audio/haptics,
   accessibility, gestures, OS UI, and real-time state. Keep a **presence**
   check separate from real validation of content, visuals, timing, or
   accessibility.

4. **Choose exactly one disposition**, supported by evidence:

   | Disposition | Use when |
   | --- | --- |
   | `AUTOMATE` | The current framework can cover the case completely and reliably. |
   | `FUSE` | Matching per-platform manual cases ought to be merged into one cross-platform case first. |
   | `SPLIT` | Part of the case can be automated; the remainder stays in a linked manual companion. |
   | `MAINTAIN` | Existing automation no longer matches the requirement, steps, locators, or shared actions. |
   | `MANUAL-ONLY` | Valid coverage depends on physical hardware, human judgement, or something the framework cannot do. |
   | `BLOCKED` | The baseline, requirement, access, or evidence is not enough to decide. |

5. **Design the candidate automation.** Assign each automatable behavior to
   a scenario and say which actions are reused and which are new. List the
   stable identifiers needed, deterministic test data, platform branches,
   driver/session requirements, runtime test seams, and tags (case, story,
   automation ticket, base dependency, execution group, platform). Favour
   native, stable identifiers; where they are missing, raise separate
   improvement work per platform. Never make up repository paths or framework
   components — every name you propose carries the label `PROPOSED`.

6. **Map traceability and review gates.** Should the proposal be accepted,
   list what it will need: links, a baseline snapshot, changes to
   test-management fields, an outcome note on the ticket, a coverage review
   with manual QA, peer code review, CI evidence, and a final independent
   completion step (see the
   [lifecycle](references/playbook.md#lifecycle-stages)). Any mechanism the
   team has not agreed yet is marked `PROPOSED — confirm`.

7. **Plan verification and failure routing.** Write acceptance criteria for
   the automated test that can be observed, plus a stability bar (three green
   CI runs in a row unless the team says otherwise). Sort the failures you can
   foresee into app defect, automation drift, infrastructure, or a mismatch
   between test data and app state, and give each its follow-up (see
   [failure routing](references/playbook.md#failure-routing)).

8. **Define the manual feedback loop.** Say what manual QA needs to confirm
   (that the baseline is current, the coverage review, the manual scope that
   remains), which signals should hand the case back to manual QA (a changed
   requirement, recurring drift, a flaky history), and which impediments call
   for solving together (missing IDs, unstable data, environment gaps,
   ownership).

9. **Produce the ideation report** using the format below. Close with the
   decisions a human must make, and get approval before any change to a
   tracker, wiki, test management, code, or workflow state.

## Output format

Whenever a URL was retrieved, show the source (ticket, case, design, page,
PR, file) as a clickable Markdown link, as described in
[`../evidence-context/SKILL.md`](../evidence-context/SKILL.md).

```markdown
# Automation ideation: <case-id — title>

- Generated: <UTC date/time>
- Sources: <case link>, <story link>, <repo path @ commit SHA>, <playbook version>
- Platforms: <iOS / Android / web / API>
- Execution context: <in-sprint | release | both>
- Disposition: <AUTOMATE | FUSE | SPLIT | MAINTAIN | MANUAL-ONLY | BLOCKED>

## Evidence and assumptions
| Claim | Source | Label (Fact / Inference / Conflict / Gap) |

## Coverage matrix
| Manual step / expected result | Platform | Proposed automated check | Limitation category | Coverage (full / partial / presence-only / manual) |

## Proposed implementation
- Scenarios and tags
- Actions reused or added (tasks, page objects, helpers); added ones marked PROPOSED
- Selectors and stable identifiers needed, per platform
- Runtime test seams; driver / session topology
- Constraints: data, hardware, local/CI environment, sequential vs. parallel

## Manual feedback loop
- Items manual QA confirms, manual scope kept, triggers for returning to manual

## Traceability and lifecycle gates
- Links, snapshots, reviews, and CI evidence required; the independent completion step

## Risks and failure routing
| Risk or failure | Classification | Response |

## Human decisions required
- <decision — owner role — reason>
```

## Self-check before delivering

- [ ] One disposition only, backed by cited evidence.
- [ ] The coverage matrix includes every manual step and expected result
      (completeness), and each row traces back to a source (correctness).
- [ ] Nowhere is a presence check passed off as proof of visuals, content,
      timing, or accessibility.
- [ ] Each proposed path, class, task, or ID is labelled `PROPOSED`.
- [ ] Code claims include a commit SHA; sources that could not be reached are
      listed as gaps.
- [ ] Partial coverage keeps its linked manual companion and is never
      reported as full.
- [ ] Runtime test seams stay out of production builds.
- [ ] No external system was changed.

## Anti-patterns

- Presenting a presence check as evidence that color, copy, layout, chart
  data, animation, sound, haptics, or accessibility are correct.
- Declaring a run on simulated hardware or fake data release-valid when the
  definition of done demands real hardware or real data.
- Automating against a stale manual baseline before manual QA has refreshed
  and confirmed it.
- Fusing per-platform cases without first checking that their current flows
  really match.
- Claiming full coverage for partial automation rather than keeping the
  manual companion and linking the two.
- Taking a draft proposal or loosely worded team statement as settled policy.
- Assuming an old spike reflects today's implementation without reading the
  repository and configuration at a pinned commit.
- Suggesting deep links, debug receivers, or test-only endpoints that would
  ship to production; automation-only interfaces belong in debug/test
  variants only.
- Masking flakiness with fixed sleeps or retries in place of explicit waits,
  deterministic data, and stable identifiers.
- Changing trackers, wikis, test management, source code, or workflow states
  while writing an ideation report.

## Related skills

- [`../test-case-creator/SKILL.md`](../test-case-creator/SKILL.md) — to write
  or update the manual baseline or the manual companion case.
- [`../regression-impact-selector/SKILL.md`](../regression-impact-selector/SKILL.md)
  — to find dependents worth re-running after a shared locator or action
  changes.
- [`../defect-report-writer/SKILL.md`](../defect-report-writer/SKILL.md) — when
  ideation uncovers an app defect.
- [`../output-depth-calibrator/SKILL.md`](../output-depth-calibrator/SKILL.md)
  — to calibrate how deep the proposal goes before delivering it.
