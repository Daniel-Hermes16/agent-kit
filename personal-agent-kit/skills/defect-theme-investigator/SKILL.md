---
name: defect-theme-investigator
description: >
  Look into a quality theme that cuts across many tickets: gather the related
  defects, stories, and requirements from the tracker, docs, and test cases
  into an evidence-backed inventory, then judge for every distinct scenario
  whether the behavior is specified, partially specified, unspecified, or
  contradictory. Use when a handful of tickets seem to stem from the same
  root, when a risk discussion or root-cause review needs prepared input, or
  when the question is how the product behaves across a whole problem area
  rather than inside a single ticket. Typical triggers: "are these bugs
  related", "investigate this theme", "what do we know about X across
  tickets", "build an issue inventory", "is this behavior specified
  anywhere", or "story and requirement coverage".
---

# Defect Theme Investigator

You support a QA specialist or QA lead and produce a **draft**
investigation that a human reviews. The skill exists to answer a single
question: *taken together, what do we know about this theme, and where is the
specification missing?*

Writing individual bug reports is out of scope — that is
[`defect-report-writer`](../defect-report-writer/SKILL.md) — and so is
deciding risk. The skill collects the evidence that a risk decision depends
on. When test depth has to be set from the findings, pass the takeaways to
[`risk-based-test-prioritizer`](../risk-based-test-prioritizer/SKILL.md).

## Required references

Read these before you start:

- [`PERSONA.md`](../../PERSONA.md) — the QA mindset: be curious about
  scenarios, prefer evidence to assumption, and reach conclusions people can
  act on.
- [`AGENTS.md`](../../AGENTS.md), in particular
  [Evidence rules](../../AGENTS.md#evidence-rules) (what the product actually
  did comes from recorded observations, not from what code or specs predict,
  and each recorded observation must be accounted for),
  [External tool access and secrets](../../AGENTS.md#external-tool-access-and-secrets),
  and [Safety boundaries](../../AGENTS.md#safety-boundaries).
- [`evidence-context`](../evidence-context/SKILL.md) — read-only retrieval,
  pinning code claims to a commit SHA, the `Fact` / `Inference` / `Conflict` /
  `Gap` labels, and source links.
- [`references/output-template.md`](references/output-template.md).
- [`PROJECT-CONTEXT.md`](../../PROJECT-CONTEXT.md) if present, to learn which
  tracker projects are in scope, where requirements are kept, and what the
  product areas are called. Without it, continue and ask only for facts the
  search cannot proceed without.

## When to run

- A number of defects look like different symptoms of one behavior.
- A risk discussion, retrospective, or root-cause review needs the input
  pulled together in one place.
- Someone asks "how does the app behave when X" and no one ticket has the
  answer.
- The same kind of escape keeps coming back release after release.

## Inputs

- The theme, phrased as something observable — "manual device time change",
  "offline edits then sync", "app upgrade with existing data", or "account
  deletion", for example.
- Any seed tickets the user already has in mind (optional).
- Which tracker projects or repositories are in scope. If the user does not
  say and [`PROJECT-CONTEXT.md`](../../PROJECT-CONTEXT.md) does not either,
  ask once.
- A date window; use the past 12 months unless told otherwise.

### Stop conditions

- **The theme names a cause rather than a behavior** ("the date library is
  bad"): rephrase it as an observable behavior and get one confirmation before
  searching.
- **The theme can be read two ways** that would lead to different searches:
  ask once before searching.
- **Tracker access fails after a genuine attempt**: say what you tried and
  offer to build the inventory from seed tickets or exports the user pastes
  in.

## Tools

Use the tools available, read-only. For example:

- The issue tracker, queried with **bounded** searches — every query limited
  to a project or repository and a date window. Some trackers refuse unbounded
  queries; others return so many results that the analysis is swamped.
- Wiki or docs search (Confluence, Notion, a `docs/` folder) for
  specifications and recorded decisions.
- A design tool (Figma or similar) when the intended behavior is a design
  matter.
- A test-management tool (TestRail or similar) to see what coverage exists.
  List calls frequently require a project or suite scope.
- Source control, pinned to a commit, used only to explain behavior that was
  observed — never as a substitute for observing it.

## Workflow

1. **Phrase the theme as observable behavior.** One sentence the team would
   recognize.
2. **Split the theme into scenarios.** Most themes hide separate
   sub-behaviors that are easy to blur together — a calendar date change, a
   change of time zone only, and a daylight-saving switch, for instance. Give
   each scenario a name and keep it apart for the entire investigation.
   Blurring scenarios together is the most frequent way this analysis fails.
3. **Search the tracker in bounded passes**, one query per cluster of
   keywords and synonyms, for example:

   ```text
   project = <PROJ> AND text ~ "time zone" AND created >= -365d
   project = <PROJ> AND text ~ "time change" AND created >= -365d
   gh issue list --repo <owner/repo> --state all --search "timezone created:>=<YYYY-MM-DD>"
   ```

   Log each hit with its key, type, status, and a one-line note on why it is
   relevant. Keep closed, rejected, and won't-fix tickets — a rejection says
   something about intent.
4. **Classify every hit**: `Direct` (this theme, this product), `Adjacent`
   (related yet distinct behavior, or a shared component), or `Precedent`
   (another product, an earlier version, or a legacy app showing how the
   problem was dealt with before).
5. **Locate the specification.** For each scenario, look through
   requirements, stories, designs, and docs for defined behavior. Mark the
   scenario `Specified`, `Partially specified`, `Unspecified`, or
   `Contradictory`, with a source cited for each.
6. **Map the test coverage that exists.** Find test cases that touch the
   theme and note which scenarios are covered and which are not.
7. **Build the coverage tables**, one per affected product area (reminders,
   streaks, summaries, data integrity, and so on), with columns for the
   behavior, the story or requirement that governs it, its status, and the
   coverage gap.
8. **Put the conclusion first.** Open the artifact with a straight answer to
   the original question, then back it up. The reader should not have to piece
   the conclusion together.
9. **List the takeaways for the risk discussion.** Keep established facts
   apart from open points, and name who has to close each open point.
10. **Do the self-check** below, then **hand over the draft and stop.** No
    ticket, page, or test case is created or changed.

## Risk and security flag review

When retrieved tickets have risk, security, privacy, or data-impact fields or
labels, check each one for consistency (read-only) and add the outcome to the
output:

- Hold the recorded answers against what the ticket really covers, quoting
  the ticket's own evidence for every alert.
- Assess **both** product/user risk and security/privacy. Security-relevant
  work — authentication and sessions, logging of identifiers, new endpoints,
  third-party SDKs, permissions — is seldom written in user-facing terms, so
  reading only for visible behavior will overlook it.
- Raise an alert for a **conflict**, not merely because a value is missing.
- Never change these fields; send a suspected gap to whoever owns them.

## Output format

Follow [`references/output-template.md`](references/output-template.md).
Write a Markdown artifact wherever the user wants it (for example
`exports/`), and add a `.docx` only if a shareable document is requested.

Order of sections: title and scope; direct answer; scenario breakdown; ticket
inventory grouped by classification; specification coverage tables; existing
test coverage; key takeaways; risk and security flag review (if relevant);
evidence gaps.

## Self-check before delivering

- [ ] The direct answer comes first and is backed by cited rows beneath it.
- [ ] Scenarios are kept apart in every table; no row combines two.
- [ ] Each search pass is listed with its query and window, empty ones
      included.
- [ ] Each retrieved ticket is in exactly one inventory group, or is listed as
      excluded with a reason (completeness).
- [ ] Each specification status cites a source or reads `none found`.
- [ ] Observed behavior is quoted from tickets or test results; anything taken
      from code or specs carries the `Inference` label.
- [ ] Each open item says who decides.

## Guardrails

- External access is read-only throughout. Tickets, pages, and test cases are
  never created, edited, or transitioned.
- Two scenarios that behave differently are never merged because they share a
  keyword.
- A missing specification is never presented as the intended behavior;
  `Unspecified` is a finding, not a ruling that something is a defect.
- No final risk rating is assigned; gather the evidence and name the decider.
- Source titles are quoted exactly as written for traceability, even where
  they use an older feature name.

## Anti-patterns

- Running a tracker query with no bounds.
- Taking two tickets sharing a keyword as proof they share a cause — classify
  relevance explicitly and give the reason.
- Dropping closed, rejected, or won't-fix tickets, which hold the history of
  decisions.
- Folding separate scenarios into one story just to shorten the report.
- Drawing a conclusion the cited evidence cannot carry, or hiding the
  conclusion at the end.
- Overlapping with `defect-report-writer` by writing individual bug records
  inside the investigation; list new findings as candidates instead.
