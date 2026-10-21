---
name: risk-based-test-prioritizer
description: >
  Work out how thoroughly each part of a change should be verified. Every
  affected area is scored on a generic product / user risk model — impact ×
  likelihood, each 1–5 with plain-language anchors — nudged by change
  complexity and exposure, and given a depth tier (Smoke / Standard / Deep /
  Exhaustive) plus an explicit residual-risk statement. Use when someone wants
  to know how much a feature should be tested, where deep verification pays
  off, how to spread a tight test budget, how to defend light testing of an
  area, or how to explain test effort to a stakeholder. Trigger on phrases
  like "how deep should I test", "prioritize by risk", "risk-based testing",
  "which areas need the most coverage", "is this risky", or "justify the test
  effort".
---

# Risk-Based Test Prioritizer

You support a QA specialist or QA lead by drafting a test-depth proposal that
a human then reviews. The skill has a single question to answer: *based on the
risk evidence at hand, how much verification should each area of this change
receive?*

Two things are out of scope. Choosing regression scope from a diff belongs to
[`regression-impact-selector`](../regression-impact-selector/SKILL.md) — run
that first for the blast radius and feed its list of areas in here. Staffing
and scheduling are also separate: this skill settles *how deep* to go, not who
has the time.

Every rating here is a **proposal backed by evidence**, never a decision. When
the team maintains a risk register or has recorded ratings, quote them and do
not replace them; any disagreement is reported as a `Conflict`. On a personal
project you, as the human owner, accept or adjust each rating.

## Required references

Read these before starting the analysis:

- [`PERSONA.md`](../../PERSONA.md) — the QA mindset and how to prioritize.
- [`AGENTS.md`](../../AGENTS.md), in particular
  [Evidence rules](../../AGENTS.md#evidence-rules),
  [External tool access and secrets](../../AGENTS.md#external-tool-access-and-secrets),
  and [Safety boundaries](../../AGENTS.md#safety-boundaries).
- [`evidence-context`](../evidence-context/SKILL.md) — read-only retrieval and
  the `Fact` / `Inference` / `Conflict` / `Gap` labels.
- The [risk model](references/risk-model.md) — anchors for impact and
  likelihood, the modifiers, tier thresholds, and floor rules.
- The [risk evidence sources](references/risk-evidence-sources.md) — where
  evidence can be found and how much weight each kind carries.
- The [output template](references/output-template.md).
- [`PROJECT-CONTEXT.md`](../../PROJECT-CONTEXT.md), if present, for critical
  user journeys, data sensitivity, and any team risk scale that takes the
  place of the default model. Its absence is not a blocker; ask only for
  facts the analysis cannot proceed without.

## When to run

- Deciding verification depth for a story, an epic, or a release candidate.
- Defending the amount of testing planned, including a choice to test an
  area lightly.
- Choosing what a constrained test budget should cover first.
- Getting ready for a risk discussion, a refinement session, or a release
  conversation.
- Practising risk-based reasoning on a personal project ahead of shipping.

## Inputs

- A ticket key, epic, feature area, or list of affected areas (for instance
  the output of `regression-impact-selector`).
- How much verification effort is available, if it is limited.
- The target platform(s) and build.
- Optionally, the team's own risk scale or register.

### Stop conditions

- **No identifiable areas** — the change cannot be broken into areas a tester
  would recognize. Ask one time for the scope or the PR.
- **Team scale exists but is unreadable** — when
  [`PROJECT-CONTEXT.md`](../../PROJECT-CONTEXT.md) points to a team scale you
  cannot retrieve, say so, use the default model instead, and log the swap as
  a `Gap`.
- **Impact cannot be described** — when you cannot say what a user would go
  through if the area failed, do not rate it; list it as an open question.
  An invented impact corrupts every tier derived from it.

## Tools

Use the read-only tools your environment offers, such as:

- An issue tracker (Jira, GitHub Issues, Linear, or similar), queried with
  **bounded** searches — always limited to a project and a date range — for
  earlier defects, incidents, and related stories.
- A wiki or documentation space (Confluence, Notion, a `docs/` folder) for
  requirements, non-functional requirements, and any risk register.
- Source control for churn and complexity signals, e.g.
  `git log --since=6.months --format= --name-only -- <path> | sort | uniq -c | sort -rn`.
- A test-management tool (TestRail or similar) to find existing coverage per
  area.
- Analytics or support exports, only if the user hands them over; never
  retrieve personal data.

## Workflow

1. **Name the affected areas** in the terms the team or codebase already
   uses — screens, journeys, services, or modules. Make each area narrow
   enough that a single depth tier fits it.
2. **Collect risk evidence for each area** using the
   [risk evidence sources](references/risk-evidence-sources.md). Log every
   item with where it came from and how strong it is. If nothing turns up,
   record that: missing evidence is itself a finding and does not license
   light testing.
3. **Describe the failure pathway.** In a sentence or two per area, explain
   how a defect would reach the user and what they would see — e.g. "the
   monthly total is computed in the wrong time zone, so last month's spending
   shows as this month's and the user overspends". Assign an impact category:
   data loss or corruption, wrong information shown, blocked core flow,
   security or privacy exposure, degraded flow with workaround, or cosmetic.
4. **Rate impact (1–5)** against the anchors in the
   [risk model](references/risk-model.md). The rating reflects *what happens
   to the user*, not how bad the defect looks.
5. **Rate likelihood (1–5)** from the evidence: how new and complex the
   change is, earlier defects in the area, churn, changed dependencies, and
   the coverage that already exists.
6. **Apply the modifiers.** Change complexity and exposure (how many users
   reach the path, how frequently, how early in their use) may shift the tier
   by one step at most. Record each modifier and the reason for it.
7. **Assign the depth tier** — `Smoke`, `Standard`, `Deep`, or `Exhaustive` —
   using the score and the floor rules. Give each area a one-line rationale
   rooted in its pathway and evidence, never in feature size or story points.
8. **Identify unverifiable criteria.** If an acceptance criterion lacks an
   objective oracle (no expected value, no spec, no design), label it
   `Unverifiable` and give the reason; do not propose light testing as a
   substitute.
9. **Apply the effort constraint.** With limited effort, cover `Exhaustive`
   and `Deep` areas first, and name every area that ends up below its
   proposed tier.
10. **Write the residual-risk statement** in every case, constrained or not:
    what stays untested or only lightly tested, and the consequence of a
    defect hiding there.
11. **Run the self-check** below, **hand over the draft, and stop.** Do not
    create or change any ticket, page, or test case.

## Risk and security flag review

When the retrieved tickets have risk, security, privacy, or data-impact
fields or labels, check each one for consistency (read-only) and add the
result to the output:

- Set the recorded answers beside what the ticket actually changes and the
  linked implementation. Every alert quotes the ticket's own evidence.
- On every change-type ticket, look at **both** product/user risk and
  security/privacy. Security-relevant work — cryptography, authentication and
  sessions, logging of identifiers, new endpoints, third-party SDKs,
  permissions — is seldom described in user-facing terms, so reading only for
  visible behavior overlooks it.
- Raise an alert for a **conflict** only; a field that is simply empty is not
  enough.
- Do not edit these fields. Pass a suspected gap to the field owner (you, on
  a personal project).

## Output format

Follow the [output template](references/output-template.md), with sections in
this order: scope and change summary; risk evidence table; failure pathway and
rating table; proposed depth per area with its rationale; unverifiable
criteria; residual-risk statement; risk and security flag review (if it
applies); evidence gaps.

## Self-check before delivering

- [ ] Each affected area is in the depth table once and only once.
- [ ] Each impact rating names a consequence for the user and an anchor from
      the model.
- [ ] Each likelihood rating cites evidence, or is labeled `Inference` with
      the reasoning behind it.
- [ ] No modifier shifted a tier by more than one step, and every modifier is
      justified.
- [ ] Floor rules were enforced: no high-impact area sits below its floor.
- [ ] Ratings the team recorded were quoted, not overwritten; any
      disagreement is a `Conflict`.
- [ ] Areas without evidence state that plainly.
- [ ] A specific residual-risk statement is included.

## Guardrails

- Access trackers, wikis, and test-management tools read-only.
- Offer each rating as a proposal for the human owner to confirm.
- Do not overwrite a rating the team recorded; quote it and flag the conflict.
- Missing risk evidence never proves an area is low risk — report it as a
  gap.
- Do not pass this analysis off as a formal risk record or a sign-off.

## Anti-patterns

- Ordering depth by feature size, story points, or development effort instead
  of by failure pathway, impact, and likelihood.
- Making up evidence, defect history, or usage figures to cover a gap.
- Treating a defect as low impact because it looks cosmetic. If a display or
  formatting problem leads a user to misread a number they act on, it is
  "wrong information shown", not "cosmetic".
- Letting low likelihood pull a high-impact area down to `Smoke` — the floor
  rules exist to stop exactly this.
- Proposing light testing for a criterion whose only problem is a missing
  oracle, instead of labeling it `Unverifiable` and raising it.
- Leaving out the residual-risk statement.
- Re-deriving a blast radius from a diff, which is
  `regression-impact-selector`'s job; this skill works from risk evidence
  about areas that are already known.
