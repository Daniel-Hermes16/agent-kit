# Test-case output template

Open with the proposed cases themselves. Give the consolidated case first; add
a second one only if the one-case-first rule calls for it.

```markdown
## Test Case Title: <behavior under test, plus the state it runs in>

**Test Case ID:** TC-<ticket number>-01
**Source:** <ticket key or link, AC supplied by the user, or recording name/link>
**Implementation evidence:** <owner/repository#PR, head SHA or update time, paths/checks that matter; only if a PR was inspected>
**Observed application evidence:** <recording name/link and the timestamps used; only if a recording was supplied>
**Platform:** <Android / iOS / Web / a combination / Unknown — confirmation required>
**Traceability:** <AC or requirement IDs and/or recording time ranges; note when there is no approved requirement>

### Evidence gaps

- **<Blocking execution / Non-blocking drafting / Clarification recommended>:** <what oracle is missing or conflicting, and what that means for the case>

### Preconditions

- <Setup that must be true before Step 1, nothing else>

### Test data

| Variant | Input/configuration | Expected oracle |
| --- | --- | --- |
| <variant name: profile, unit, state, or platform> | <setup taken from a source> | <expected value from a source, or a clearly marked pending item> |

| # | Step Description | Step Result |
| ---: | --- | --- |
| 1 | <Imperative action, or a short run of linked actions> | <What the tester can see> |
| 2 | <Imperative action> | <What the tester can see> |
```

Drop the Evidence gaps, Preconditions, or Test data block when the case does
not need it.

If every revision input is QA feedback, put this above the full revised case:

```markdown
**QA feedback integrated:**

- <Point raised, which case/step it touches, and the change made>
```

If the later input mixes in evidence, constraints, preferences, or other
context, use `**Additional context integrated:**` instead, with the same
bullet layout.

Close the output with these two dropdowns, exactly as written, after the last
case:

```markdown
<details><summary>Constraints and human decisions</summary>

<Only the context that applies: privacy, security, legal or licensing,
sensitive claims, environment evidence (simulator vs. real device),
definition of done, and decisions a human must make.>

</details>

<details><summary>Automation references</summary>

| Assertion | Classification | Evidence or dependency |
| --- | --- | --- |
| <behavior> | <Automatable now / Automatable after adding an ID or test seam / Manual visual verification / Manual semantic or content review / Unknown — evidence required> | <ticket, locator, whether it is implemented yet, or the open gap> |

</details>
```

An empty first dropdown gets the fixed sentence `No additional constraints or
human decisions identified from the available evidence`. An empty second
dropdown gets `No additional automation references identified from the
available evidence`.

## Worked example (fictional habit-tracker app)

```markdown
## Test Case Title: Habit marked done offline from the home list stays done after reconnecting

**Test Case ID:** TC-DRAFT-01
**Source:** AC supplied in chat; no ticket
**Platform:** Android
**Traceability:** AC-1, AC-2

### Preconditions

- The app is installed and signed in; a habit called **Read 10 pages** exists and has not been marked done today.

| # | Step Description | Step Result |
| ---: | --- | --- |
| 1 | Turn on **Airplane mode** and launch the app. | The home list shows **Read 10 pages** with an unticked checkbox, and an **Offline** banner is visible. |
| 2 | Tick the checkbox next to **Read 10 pages**. | The checkbox becomes ticked and the streak count goes up by 1. |
| 3 | Turn off **Airplane mode** and pull down to refresh. | The **Offline** banner goes away and the habit is still ticked. |

<details><summary>Constraints and human decisions</summary>

No additional constraints or human decisions identified from the available evidence

</details>

<details><summary>Automation references</summary>

| Assertion | Classification | Evidence or dependency |
| --- | --- | --- |
| Ticked state after marking done offline | Automatable after adding an ID or test seam | The checkbox exposes no stable test ID |

</details>
```

## Rendering rules

- Give each case a stable Test Case ID and keep it.
- Preconditions sit above the step table, never inside it.
- Reserve the Test data table for variants that share exactly the same steps.
- `Pending`, `TBC`, or a sample value is never an executable oracle; record it
  under Evidence gaps instead.
- Number rows without gaps and keep each result on the same row as its action.
- In a revision, leave unaffected content as it was and acknowledge every
  feedback point you applied.
- Leave out `Observed application evidence` if there was no recording. If it is
  there, cite only the timestamps that matter and keep personal data out.
- Leave out `Implementation evidence` if no PR was inspected. If it is there,
  cite the PR revision and the relevant paths, not the whole diff.
- For a case drafted from a recording alone, say that no approved requirement
  was supplied and move any unsupported expected behavior into Evidence gaps.
- Bold only the key controls, states, values, and UI elements in steps.
- Use `<br>` only where a few short lines make a table cell easier to read.
- The two dropdowns follow the cases, in the order shown above.
- Check a saved draft with
  `perl ../checklist-writer/scripts/validate-output.pl --mode test-case <file>`.
