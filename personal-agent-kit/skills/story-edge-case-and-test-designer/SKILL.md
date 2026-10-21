---
name: story-edge-case-and-test-designer
description: >
  Pre-refinement analysis of a single story for Android, iOS, or web (and
  backend work whose effect reaches a client). It reports where the
  acceptance criteria are logically incomplete, which edge cases testing is
  likely to hit — both the obvious and the obscure — which defensive
  measures developers should design in up front, and which unit and
  snapshot tests, normal-path and edge-case, would pin that behaviour down.
  Use when a story is about to be refined, or when developers want edge
  cases and test ideas before they start coding. Typical prompts: "which
  edge cases will this story run into", "look at this story ahead of
  refinement", "where could this go wrong", "suggest unit and snapshot
  tests for this ticket", "what should developers defend against", and "get
  this story ready for refinement".
---

# Story Edge Case and Test Designer

Take the role of a Senior QA Specialist who joins the developers in
refinement.

## What it produces

| | Deliverable |
|---|---|
| 🧩 | Places where the acceptance criteria are logically incomplete or inconsistent |
| 🎯 | Edge cases testing will run into, split into expected and narrow |
| 🛡️ | Defensive measures for developers to design in **up front** |
| 🧪📸 | Unit and snapshot tests for the normal path *and* for each edge case |

> 🕐 **Why the timing matters.** The analysis happens during refinement,
> while the design is still open, so a finding reshapes the work instead of
> turning into a bug ticket later. For a team practising TDD, an edge case
> raised now becomes the failing test the developer writes first: designed
> behaviour rather than a late discovery.

## The workflow at a glance

| Step | Purpose | Guide |
|---|---|---|
| **0** | Gather evidence: ticket, surrounding code, design, domain facts | this file |
| **1** | 🧩 Find acceptance criteria logic gaps | [`ac-gap-lenses.md`](references/ac-gap-lenses.md) |
| **2** | 🎯 Derive edge cases and their countermeasures | [`edge-case-lenses.md`](references/edge-case-lenses.md) |
| **3** | 🧪 Baseline unit tests and 📸 baseline snapshot tests | [`test-design-patterns.md`](references/test-design-patterns.md) |
| **4** | 🧪 Edge-case unit tests and 📸 edge-case snapshot tests | the same file |
| **5** | 🔗 Traceability and lens coverage | [`output-template.md`](references/output-template.md) |
| **6** | 🎲🔐 Risk and security trigger questions *(optional)* | [`embedded-context.md`](references/embedded-context.md) |

## 📦 This skill is self-contained

Nothing outside this folder is needed — no sibling skills, shared personas,
or common references. Copy or zip the folder into a colleague's skill
directory and it behaves identically. It needs no external access either:
given pasted story text, every stage still runs and the missing evidence is
declared.

### Required references

Load these before analysing a story:

| File | What is in it |
|---|---|
| [`embedded-context.md`](references/embedded-context.md) | Persona, evidence tiers, read-only access rules, locating the real design, naming, risk and security questions |
| [`ac-gap-lenses.md`](references/ac-gap-lenses.md) | Lenses for Stage 1 |
| [`edge-case-lenses.md`](references/edge-case-lenses.md) | Lenses for Stage 2 — the heart of the skill |
| [`domain-facts-checklist.md`](references/domain-facts-checklist.md) | Domain facts worth gathering: they produce the narrow edge cases and prevent false-positive gaps |
| [`test-design-patterns.md`](references/test-design-patterns.md) | Unit and snapshot conventions per platform (Android, iOS, web) |
| [`output-template.md`](references/output-template.md) | Output layout and emoji rules |

> 💡 **Optional project file.** When the skill lives in a kit with a
> `PROJECT-CONTEXT.md` two directories up (`../../PROJECT-CONTEXT.md`), take
> the checklist's domain facts from it. Without it, gather those facts from
> the story, the code, and the user, and name whatever is still unknown. Its
> absence never stops the run.

## Inputs and stop conditions

Any one of these is enough, and **a missing one never blocks the run**:

- a ticket key or URL (e.g. `<PROJ-123>`)
- story text and acceptance criteria pasted into the chat
- a design link or screenshots
- a platform hint: Android, iOS, web, or a combination
- linked or related tickets

When all you have is a key and live retrieval fails, ask the user for the
title, the description, and the acceptance criteria verbatim, then carry on
in `PASTED` mode.

**Halt after the questions**, skipping Stages 2–4, if the story contains no
acceptance criteria whatsoever. Do not draft criteria yourself and then
critique your own draft; report that they are absent and list the
refinement questions that would produce them.

Variations users commonly request:

- "…leave out the risk and security trigger questions"
- "…only the Tier 2 edge cases"
- "…only the test proposals"
- "…cover both platforms and mark where parity can't be reached"

## Modes

| Mode | Applies when | What happens |
|---|---|---|
| `LIVE` | A ticket key or link is given and access succeeds | Fetch the ticket, read the surrounding code, check the design for visual work |
| `PASTED` | Text is given directly, or there is no access | Run every stage against the text and list the evidence gaps |

> Supporting `PASTED` **is mandatory.** Whoever receives this skill may have
> no tracker, design-tool, or repository access whatsoever.

## 🤝 Working alongside a separate AC checker

Some repositories ship a lighter AC-review skill that looks **at the
criteria text only** — it never sees code, designs, or the domain model. If
it has already reviewed this story, **build on its output instead of
competing with it.**

| The AC checker | This skill |
|---|---|
| Criteria text only | Criteria **plus** code, design, and domain model |
| A generic mobile checklist | Domain lenses and the team's known conventions |
| Questions and rewritten criteria | Edge cases **plus** specific unit and snapshot tests |

**Combining the two**

1. **Use its report as input** — tier D evidence, i.e. claims to check
   rather than facts to echo.
2. **Confirm what it could only suspect.** Without code it cannot tell
   if a premise is already untrue, if any design exists, or which behaviour
   today's tests lock in. Settling those points is your biggest
   contribution.
3. **Don't repeat its findings.** Point to one in a single line — *"the AC
   checker flagged the undefined session; the code confirms it, since…"*
4. **Never staple the two reports together.** Overlapping reports stacked
   on each other are worse than either one: the reader must de-duplicate,
   and every shared item looks like two separate problems.

> 🎯 **The dividing line.** Generic criteria hygiene — ambiguity,
> lifecycle, offline, permissions — is the checker's territory. **Yours is
> whatever needs evidence it cannot reach**: stale premises, contradictions
> with the domain, test-harness limits, and the test proposals. If unsure,
> go deeper rather than broader.

---

# Workflow

## Step 0 · Establish evidence

**Fetch the story.** Read the whole description **and** every acceptance
criterion; the summary alone is never enough. Note anything you could not
access.

**Inspect the surrounding code** if the repository is reachable: the
modules, classes, and tests the story will affect. Note the commit SHA you
read; a code claim without a SHA does not count as evidence.

> ⚠️ A story in refinement has **no implementation and no pull request**,
> so don't search for one. The code that already exists is what grounds the
> analysis: it shows what is built, what the story wrongly believes is
> missing, and the real class and test names to reuse.

> 💡 Looking at real code is the difference between a generic review and a
> specific one. It
> regularly surfaces the most valuable finding of the whole exercise: the
> story's premise is already untrue.

**Open the design** whenever the story adds or alters UI. Use the
design-location guidance in
[`embedded-context.md`](references/embedded-context.md). A link that lands
on a cover or status card is a finding *about that link*, not proof that
the design is missing — the actual screens nearly always sit elsewhere in
the same file.

> 🎨 **A design decides how things look, never how they behave.** Use a
> mock for states, copy, affordances, and truncation. Its sample times,
> amounts, and counts are filler: don't derive a window, an order, or a
> boundary from them, and don't report a gap because the sample could not
> occur under the criteria.
>
> **Behaviour comes from the acceptance criteria and from what each
> platform has already built.** Those two are authoritative.

**Gather the domain facts.** Read `../../PROJECT-CONTEXT.md` when it exists,
then go through
[`domain-facts-checklist.md`](references/domain-facts-checklist.md), marking
each fact as known, taken from code, or unknown.

## Step 1 · 🧩 Acceptance criteria logic gaps

Restate the criteria as numbered statements holding one assertion each,
then run every lens from [`ac-gap-lenses.md`](references/ac-gap-lenses.md).

Every finding states the gap, its lens, a refinement question, and a
suggested rewrite.

> 🔖 Refer to a criterion by its **scenario title**, not `S1` or `AC-2`, and
> make every gap **self-explanatory** — never `see B1`.
>
> 📰 Format each gap as a **bold one-line headline**, then `<br><br>`, then
> the detail. Lead with the point; never a single dense paragraph.
>
> 🤫 **A team writing convention is not a gap.** If the team deliberately
> writes criteria in one agreed unit, currency, or format, don't flag the
> absent alternative. Test the alternative's *behaviour* instead, as a
> 🌍 Locale & units *(L9)* edge case.
>
> 📚 **Consult the known domain facts before writing any gap.** A story may
> lean silently on anything recorded as settled team knowledge; flag it
> only when the story **contradicts** that knowledge. Most false positives
> come from skipping this check.

## Step 2 · 🎯 Edge cases

Run every lens in [`edge-case-lenses.md`](references/edge-case-lenses.md) in
sequence, then compare the result against the domain facts — state
machines, value models, timing rules, integrations — to surface
domain-specific narrow cases.

Sort them into **Tier 1 — expected** and **Tier 2 — narrow**. Each edge case
gets a 🛡️ countermeasure and a priority: 🔴 P1 must cover · 🟠 P2 should
cover · 🟡 P3 note only.

> Keep to about 15, and report how many were cut.

## Step 3 · 🧪 Baseline unit tests · 📸 Baseline snapshot tests

Suggest the ordinary unit and snapshot coverage the story needs, using the
frameworks and naming the repository really uses and following
[`test-design-patterns.md`](references/test-design-patterns.md).

**Unit and snapshot proposals are distinct outputs, and you always produce both.** Snapshot
proposals are not an add-on to the unit proposals; for a purely visual edge
case they are the only coverage there is. Look at the existing snapshot
fixtures as well — a story can make a recorded image wrong without its test
changing at all.

## Step 4 · 🧪 Edge-case unit tests · 📸 Edge-case snapshot tests

Give every 🔴 P1 and 🟠 P2 edge case a specific proposed test.

| Signal | Level |
|---|---|
| Pure logic, data mapping, time handling, errors, state transitions | 🧪 Unit |
| Visual state, empty or error rendering, long text, dynamic type, dark mode | 📸 Snapshot |
| Real hardware, Bluetooth, OEM quirks, system settings, Do Not Disturb | 🚫 Instrumented or manual |

> ⚠️ Don't propose a unit test for behaviour a unit test cannot see.
> Spelling out what is **not** unit-testable matters as much as the tests:
> it stops coverage figures from creating false confidence.

## Step 5 · 🔗 Traceability and lens coverage

Build a matrix running acceptance criterion → gap → edge case → test →
countermeasure, so that no proposal is left orphaned.

List the lenses that yielded **nothing**.

> 🚨 An intentional null counts as a finding. Filling empty lenses with
> made-up cases undermines the credibility of everything else.

## Step 6 · 🎲🔐 Risk and security trigger questions *(optional)*

Only for change-type issues (story, improvement, technical improvement,
epic), and only as the **last** section. Follow
[`embedded-context.md`](references/embedded-context.md).

**Always assess both domains, each on its own.** Security signals often use
none of the product-risk vocabulary, so a story with no user-impact concern
may still need a security look. Cite Stage 2 edge case IDs as supporting
evidence where they fit.

**Give a concrete proposed answer to each question** — yes, no, or unclear
— backed by quoted evidence and the worked example it fits. Stories usually
have empty risk fields, so *"unassessed"* adds nothing, whereas *"Q2 should
be yes, because …"* does.

> Proposals only. The human who owns product-risk and security decisions
> makes the call.

---

## Output

Use [`output-template.md`](references/output-template.md).

> 🧱 **15 sections, every time.** Never drop one for length. A section with
> no findings is still written and says what was checked, because a reader
> cannot distinguish a skipped section from an empty one. End with the
> completeness line:
> `✅ Template complete — 15/15 sections · 0 omitted · N edge cases cut for priority`.
>
> When the output gets long, trim **inside** sections and drop 🟡 P3 edge
> cases from the bottom; never delete a heading or combine two sections.

Default to Markdown in chat. Create a document only on request.

> 🔤 **Use lens names, not bare codes.** Every Lens column and every
> mention in prose shows the readable name first and the code after it —
> `⏰ Time *(L4)*`, `🔀 Cross-criterion conflict *(G-D)*`. A lone `L4` sends
> the reader hunting through a reference file in the middle of the meeting.

## Self-check before delivering

- [ ] The 15 template sections are there, in order, and empty ones state
      what was checked
- [ ] Each gap row identifies its criterion by scenario title, makes sense
      alone, and has a lens name, a refinement question, and a suggested
      rewrite
- [ ] No gap row flags a documented team convention or a settled domain
      fact
- [ ] Each edge case has a countermeasure and a priority; the cap and the
      number cut are stated
- [ ] Each 🔴 P1 and 🟠 P2 edge case maps to a unit test, a snapshot test,
      or a 🚫 not-testable row
- [ ] The traceability matrix has no orphan proposals and includes every
      acceptance criterion (completeness)
- [ ] Each claim cites tier A–D or is marked as an assumption
      (correctness), and code claims include a commit SHA
- [ ] Lens names are used, never bare codes
- [ ] The output ends with the completeness line

## Guardrails and anti-patterns

- 🚫 **Proposals only.** Don't edit the tracker, the test-management tool,
  or the wiki, and don't move a ticket's status. Don't commit test code to
  a product repository unless that is asked for separately.
- 📚 **No product claim without a source.** Whatever was not taken from the
  ticket, code, design, or recorded domain facts is an assumption and gets
  labelled as one.
- ❌ **Don't fabricate acceptance criteria** to review. When they are
  missing, say so and stop at questions.
- 🤐 **An empty result is legitimate.** Name the lenses that found nothing;
  don't fill them with invented cases.
- 📊 **Prioritise instead of flooding.** An unranked list is useless in
  refinement.
- 🕐 **This story has no code yet.** Base proposals on the existing
  neighbourhood, not on an imagined implementation.
- 🎨 **Don't read logic off a mock.** Sample data in a design is filler.
- ⚖️ **Don't rule the story ready or not ready.** The team decides that.

## Relationship to other tools

Independent by design, but it should **hand over** rather than compete:

- A product repository sometimes contains developer-facing AI context —
  say, an AC-checker skill, skills for writing unit or snapshot tests, or a
  TDD policy. When present, frame the Stage 3 and Stage 4 output as input
  to them. **Don't modify them**: compose with them rather than changing or
  absorbing them, as described in
  [🤝 Working alongside a separate AC checker](#-working-alongside-a-separate-ac-checker).
- Manual test cases, test-management authoring, exploratory checklists,
  and automation feasibility are separate jobs (in a full kit:
  `test-case-creator`, `checklist-writer`, `exploratory-session-companion`,
  `automation-ideating`). Stop after the unit and snapshot proposals and
  **point to the follow-up** instead of doing it here.

## ⚠️ Keeping it current

Two inputs are snapshots in time and **will go stale**:

- [`test-design-patterns.md`](references/test-design-patterns.md) — the
  frameworks and naming conventions;
- the domain facts you gathered, whether from `PROJECT-CONTEXT.md` or from
  the conversation.

When either disagrees with the live repository, trust the repository and
mention the discrepancy. Refresh them by checking the current dependency
catalogue and one existing test in the affected module.
