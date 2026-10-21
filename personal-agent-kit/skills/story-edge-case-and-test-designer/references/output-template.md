# 📄 Output template

Default to Markdown in the chat. Produce a document only when someone asks
for one.

## 🎨 Emoji convention

The emoji help a reader find their way quickly during a refinement meeting;
**they are not ornament**. Stick to the set below and add no others. Inside
tables, emoji may appear only in the **lens**, **priority**, and **level**
columns.

| Emoji | Marks |
|---|---|
| 🚨 | A blocker |
| 📋 | The story and the evidence read |
| 🧩 | Gaps in the acceptance criteria |
| 🎯 | Tier 1 edge cases (expected) |
| 🔬 | Tier 2 edge cases (narrow) |
| 🛡️ | A countermeasure |
| 🧪 | A unit test |
| 📸 | A snapshot test |
| 🚫 | Something unit and snapshot tests cannot reach |
| 🔗 | Traceability |
| 🔍 | Lens coverage |
| 🎲 | Product or user risk |
| 🔐 | Security and privacy |
| 💬 | Talking points for refinement |
| ✅ | Covered, or assessed correctly |
| ⚠️ | A caution or an assumption |
| 🔴 🟠 🟡 | Must · should · note only |

## 🔤 Naming lenses in the output

🚨 **Write the lens name every time — a code on its own is never enough.**

Someone sitting in refinement should be able to follow a row without
opening a reference file. To a developer reading the document cold, `L4`
says nothing, whereas `⏰ Time` is obvious at once.

**Pattern:** the emoji, then the lens name, then the code in italics inside
parentheses.

| ❌ Avoid | ✅ Prefer |
|---|---|
| `L4` | `⏰ Time *(L4)*` |
| `L13` | `🕳️ Silent failure *(L13)*` |
| `G-D` | `🔀 Cross-criterion conflict *(G-D)*` |
| `G-A` | `🚨 Stale premise *(G-A)*` |

Keep the code, since traceability and the 🔍 lens coverage section depend
on it, but it trails the name, kept small, and never appears by itself.

Copy each name exactly from the quick-reference table in
[`ac-gap-lenses.md`](ac-gap-lenses.md) or
[`edge-case-lenses.md`](edge-case-lenses.md). A paraphrase makes one lens
show up under two different names in the same document.

> 💡 Prose and the 🔍 lens coverage section follow the same rule: write
> *"🔢 Boundary & numeric and ⏰ Time found nothing"*, never *"L1 and L4
> found nothing"*.

---

## 🧱 The output contract — non-negotiable

**Each section listed below appears in every run, in this order, with no
exceptions.**

> 🚨 **An omitted section looks exactly like an empty one.** The reader has
> no way of telling which happened. So when a section turns up no findings,
> write it anyway and state what you checked and why nothing came up. A
> heading is never removed.

### 🚫 No compression under output pressure

A long output never justifies losing a section. When it starts to sprawl:

| Acceptable | Not acceptable |
|---|---|
| Trim the text **inside** sections | Deleting a section |
| Remove 🟡 P3 edge cases from the bottom of the ranking and **state the count** | Ending early without saying so |
| Convert prose into tables | Folding two sections into one |
| Leave out a column you truly could not populate, and mark that you did | Quietly losing *Countermeasure* or *Priority* |

The sections that go missing most often all vanish for one poor reason —
they sit near the end:

- 🔬 **Edge cases — Tier 2.** Obvious cases come easily; this tier is the
  part that makes the exercise worth doing.
- 📸 **Snapshot tests.** They follow the unit tests and get treated as
  extras, yet they are the *only* place a visual edge case gets covered.
- 🔍 **Lens coverage** and 🔗 **Traceability.** They feel like admin, but
  they are what lets a reviewer verify the analysis instead of simply
  trusting it.

> 🧠 **"Not built yet" never excuses a missing test section.** Proposing
> tests for behaviour that does not exist yet is the purpose here. A story
> without any implementation still receives complete unit *and* snapshot
> proposals.

### ✅ Completeness self-check

The sections, in order:

1. Title
2. 📋 Story and evidence
3. 🚨 Blocking findings
4. 🧩 Acceptance criteria gaps
5. 🎯 Edge cases — Tier 1
6. 🔬 Edge cases — Tier 2
7. 🧪 Baseline unit tests
8. 📸 Baseline snapshot tests
9. 🧪 Edge-case unit tests
10. 📸 Edge-case snapshot tests
11. 🚫 Not testable at these levels
12. 🔗 Traceability
13. 🔍 Lens coverage
14. 🎲🔐 Risk and security trigger questions
15. 💬 Refinement talking points

Before handing over, verify that every heading exists, then finish the
output with this single line:

`✅ Template complete — 15/15 sections · 0 omitted · N edge cases cut for
priority (🟡 P3 only)`

A section you could not produce is still present and explains **why**.
*"Found nothing — here is what I checked"* is a legitimate finding; a
missing heading is a fault in the run.

---

## Structure

### Title

`# 🎯 Story Edge Case & Test Design — <KEY> <Summary>`

### 📋 Story and evidence

Open with the issue type, status, and platform. Follow with a brief list of
evidence: the sources you read (code with its commit SHA), which domain
facts were already known, which you collected during the run, which remain
unknown, and **anything you could not reach**.

> Put the gaps here rather than in a footnote. Say plainly that nothing is
> implemented yet and that the grounding came from neighbouring code that
> already exists.

### 🚨 Blocking findings

**Reserved for something that breaks the story as written** — typically a
false premise, a visual story that has no design, or an irreversible
consequence nobody has spotted.

- Place it **at the top**
- Keep it **brief**
- Back it with evidence, often a two-sided table: *present in code* versus
  *assumed by the story*

> If nothing blocks, the heading still appears, followed by *"None — the
> premise holds, the needed design exists, and nothing irreversible was
> found"* (the output contract above applies). **Don't downgrade a genuine
> blocker** to an ordinary gap to keep the mood calm.

### 🧩 Acceptance criteria gaps

| # | AC | Lens | Gap | Refinement question | Proposed rewrite |
|---|---|---|---|---|---|
| 1 | Scenario 1 — daily summary sent each evening | ⏰ Time *(L4)* | **"Evening" has no defined time.**<br><br>The criterion never says whether that means a fixed clock time, a user setting, or something else, and each choice behaves differently for a user who changes time zone | … | … |

One finding per row.

**🔖 Identify the criterion by name, not by number alone.** Labels such as
`S1` or `AC-2` are meaningless to anyone reading the table without the
ticket open. Use the scenario's own title, abbreviated when it is long.

| ❌ Avoid | ✅ Prefer |
|---|---|
| `S1` | `Scenario 1 — daily summary sent each evening` |
| `S2–S4` | `Scenarios 2–4 — notification routing` |
| `AC-2` | `AC-2 — future-dated entries hidden` |

> 💡 Reuse the wording of the ticket's scenario heading. For an untitled
> scenario, summarise its *Then* clause in three to five words.

**🧾 Each Gap cell has to make sense in isolation** — a reader must grasp the
finding without having seen any earlier section.

| ❌ Avoid | ✅ Prefer |
|---|---|
| `The B1 false premise` | `Story assumes no export formats exist; CSV and PDF export already ship` |
| `See above` | *(never — say it again)* |
| `Contradiction` | `"Last month" in the criteria means the previous 30 days, yet the screen title implies the calendar month` |

> A reference may be added **alongside** the description — `Story assumes
> export formats are missing; two already ship (see B1)` — but never **in
> place of** it.

**📰 Structure each Gap cell as headline first, detail second.** A solid
block of text makes the reader parse all of it before learning whether it
matters. Open with a **bold single-line summary**, leave a blank line, then
explain.

A Markdown table cell cannot hold a real line break, so use `<br>`:

```
| **Bold single-line summary.**<br><br>Supporting detail with the concrete
evidence: values, field names, what the existing code does. |
```

| Element | Rules |
|---|---|
| **Headline** | A single line, in **bold**. It names *the finding*, not the subject area, and reads correctly on its own |
| *(separator)* | `<br><br>` — the empty line is what makes the cell scannable |
| **Explanation** | Two to four lines of specifics: names, numbers, code evidence, and why it hurts |

| ❌ Avoid | ✅ Prefer |
|---|---|
| `**Timing.**<br><br>…` — names a topic, not a finding | `**"Last month" is not a calendar month.**<br><br>…` |
| `**The title is wrong because the window is a rolling 30 days and so it overlaps the previous month.**` — everything forced into the headline | The headline asserts; the detail proves |
| One unbroken paragraph | Headline, `<br><br>`, then detail |

> 💡 Give the **Why it bites** column of the edge-case tables the same
> structure whenever a cell grows past roughly two lines.

**🤫 Known team conventions are not gaps.** Plenty of what looks like
an omission to an outsider is a standing agreement inside the team. Flagging
them adds noise and shows the analysis does not know the team.

| Convention | Don't flag | Do test |
|---|---|---|
| **A writing convention** — e.g. amounts always given in the base currency, or quantities in one agreed unit, because that reads more clearly | A criterion that states values only in that unit, leaves out the alternative, or does not name the unit being compared | Conversion, display, rounding, and precision at boundaries in the alternative unit — as a 🌍 Locale & units *(L9)* edge case with a test |
| **The settled domain model** — value states, bands, profile defaults, entity states, standard time windows | A criterion that depends on it without repeating it | The behaviour itself, wherever the story alters it |

> ⚠️ **A convention shapes how criteria are written, not how the app
> behaves.** Users really do switch units and currencies, so that handling
> remains a primary testing concern. Drop the gap row; keep the edge case
> and its test.

> 📚 **Look up the known domain facts before adding any gap row** (see
> [`domain-facts-checklist.md`](domain-facts-checklist.md)). When the
> supposedly missing information is recorded as settled, it is team
> knowledge and stays out of the table. Report only a story that
> **contradicts** it — and that is a genuinely valuable finding.

### 🎯 Edge cases — Tier 1, expected

| ID | Lens | Scenario | Why it bites | 🛡️ Countermeasure | P |
|---|---|---|---|---|---|
| EC-01 | 📦 Empty, one, many, max *(L2)* | … | … | … | 🟠 P2 |

### 🔬 Edge cases — Tier 2, narrow

Columns as in Tier 1.

> This tier is what makes the work worthwhile. **Don't let it go thin**
> just because the obvious cases came more easily. If the cap removed any,
> give the number and the reason.

### 🧪 Baseline unit tests

| Target | Proposed test name | Assertion | Handoff |
|---|---|---|---|

The ordinary logic coverage the story needs, separate from the edge cases.

### 📸 Baseline snapshot tests

| Target | Proposed case name | What it must show |
|---|---|---|

The ordinary **visual** coverage. Always present — if the story changes
nothing visual, say so instead of removing the section.

> 🔁 **Start by reviewing the snapshots already recorded and their fixtures.**
> A story can make a recorded image wrong without anyone touching its
> test: when a fixture shows a state whose meaning the story changes, either the
> snapshot is re-recorded or the fixture is changed. **Name which one, and
> choose on purpose** — this is a regression that exists only in test data.

> ➕ When the parameterised test-case type cannot represent a variation you
> need, **name the field that should be added**. Behaviour that cannot be
> parameterised cannot be snapshotted either.

### 🧪 Edge-case unit tests

| EC | Target | Proposed test name | Assertion |
|---|---|---|---|

Covers every 🔴 P1 and 🟠 P2 edge case that has a logic-level expression.

### 📸 Edge-case snapshot tests

| EC | Target | Proposed case name | What it must show |
|---|---|---|---|

Covers the edge cases that exist **only visually** — units, locale,
dynamic type, long strings, and empty or extreme states. Nothing at logic
level expresses them, so this section is all the coverage they get.

> 🚧 **Leave out axes the suite intentionally excludes**, such as a theme
> the project does not support yet; record the exclusion instead.

### 🚫 Not testable at these levels

| EC | Why | Needs |
|---|---|---|

Gestures, focus order, timing against a real clock, instrumented behaviour.

> **Never give the impression these are covered.** The section is present
> even when empty — *"none; every edge case can be reached at unit or
> snapshot level"* is useful information in itself.

### 🔗 Traceability

| AC | Gap | Edge case | Test | Countermeasure |
|---|---|---|---|---|

Every proposal links back either to a criterion or to a gap in the criteria
that you named explicitly. *A proposal with no such link is scope creep.*

> 💡 An intentionally empty cell — a gap that cannot be tested because the
> behaviour is unspecified — makes a strong case for resolving it in
> refinement. Mark it ⛔ and give the reason.

### 🔍 Lens coverage

Name the lenses that found nothing and explain why, **using their names**.
For instance: *"🔢 Boundary & numeric, ⏰ Time, and 🌍 Locale & units found
nothing — the story contains no numeric or time-based logic."*

When several lenses are null, a two-column table is clearer:

| Lens | Why null |
|---|---|
| 📶 Connectivity *(L5)* | Data comes from local storage; no new network call is added |

> 🚨 **Readers judge credibility here.** This section shows the analysis was
> systematic rather than ad hoc, and it is the quickest way for anyone to
> confirm nothing was skipped.

### 🎲🔐 Risk and security trigger questions

Optional, placed last, and for change-type issues only. Use two clearly
separate subsections — 🎲 Product / user risk and 🔐 Security and privacy —
each applying [`embedded-context.md`](embedded-context.md) §6. If the user
asked to leave it out, or the issue type does not qualify, keep the heading
and give the reason.

**1 · Recorded state.** A field/value table, so that missing values are
visible (or one line noting the tracker has no assessment fields).

**2 · 🎯 Proposed answers — the core of this section.** One row per
question, covering *all* of them, including those you would answer "no".

| Q | Proposed | Evidence | Basis | Why |
|---|---|---|---|---|
| Q1 Technical risk | 🔴 **Yes** | *quoted text from the story or code* + `EC-04` | The worked example it fits | One sentence |
| Q2 Use-error risk | 🟠 **Unclear** | … | … | … |
| Q3 Interactions | ⚪ No | — | — | The reason it does not apply |

> 🚨 **"Unassessed" is never where you stop.** Stories usually have empty
> fields. What you add is **which questions you would select, and why**, so
> the decision owner starts from a position instead of a blank form.

**3 · Alerts.** Only when the recorded values conflict with the evidence or
one of the consistency checks C1–C5 fails. Include the severity and name
the **owner**.

Finish with a single line: this is a QA observation, and the owners of
product-risk and security decisions decide.

> 🤐 If neither domain raises anything, state that for **both**, by name, so
> the silence reads as a result rather than a gap.

### 💬 Refinement talking points

**Exactly five**, ranked, one sentence apiece.

> The team reads this part aloud in the session. Write it last, select
> hard, and make every line an **action or a decision** rather than a
> recap.

---

## ✍️ Style rules

- Prefer **tables** to prose for anything that can be listed
- Prefer the **concrete** to the abstract — real class names, real states,
  real values
- Keep every finding **falsifiable**, so a reader can check it
- **Don't pad** a section to look thorough; a plainly stated empty lens beats
  a made-up finding
- Keep the whole thing **readable in a few minutes**. If it is not, drop
  🟡 P3 edge cases from the bottom of the ranking and state how many —
  **never a whole section**. See
  [🚫 No compression under output pressure](#-no-compression-under-output-pressure)
