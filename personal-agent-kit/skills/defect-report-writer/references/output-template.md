# Defect report output template

Keep the sections in exactly this order and swap each bracketed instruction
for real content. The result is a draft; the issue itself is not created.

```markdown
## [<Platform>] <observable symptom> when <trigger condition>

**Draft for review — not created in the tracker.**

| Field | Value |
| --- | --- |
| Platform | <Android / iOS / web / backend / API> |
| Build | <such as 1.4.2 (512), or commit `<sha>`> |
| Device / OS / browser | <such as Pixel 8 / Android 15> |
| Locale / time zone / network | <fill in only if it matters> |
| Backend environment | <dev / staging / prod, if it matters> |
| Frequency | <such as 3/3, or 1/1 (seen once)> |
| Source | <test case, checklist scenario, exploratory session, or ticket key> |

### Preconditions

- <Account state, existing data, settings, feature flags, connectivity>

### Steps to reproduce

1. <One action>
2. <One action>

### Actual result

<Only what was observed — no interpretation.>

### Expected result

<What should happen> (Source: <AC ID, test case, design, requirement, or documented earlier behavior>)
<or: Oracle gap — expected result not confirmed>

### Suspected cause — inference, not fact

<Include only with a concrete basis; otherwise drop this whole section.>

### Triage — proposed, requires human confirmation

| Field | Proposed value | Reasoning |
| --- | --- | --- |
| Severity | <S1–S4> | <matched anchor and consequence for the user> |
| Priority | <P1–P4 or tracker value> | <impact × frequency × exposure; for P1, the blocker criterion> |
| Security / privacy flag | <No / Potential / Under investigation> | <why> |
| Users affected | <estimate> | <what the estimate rests on> |

**Decides:** <you / triage owner / product owner>

### Workaround

<The workaround observed, "None found", or "Not tried">

### Evidence to attach

- [ ] <The specific screenshot, recording, or log the reporter has to add>

### Possible duplicates

- <KEY — title> — <why it might, or might not, be the same defect>
- <or: none found in <tracker, query, date window>>

### Links

- <Source test case / checklist / story / requirement / PR, as Markdown links>

### Notes

- <What was ruled out, unusual observations, related tickets>

### Evidence gaps

- **<Blocking / Non-blocking / Clarification recommended>:** <the missing item and what it affects>
```

## Rendering rules

- Always give the frequency. `Reproduced once` is a valid entry and more
  honest than hinting the bug always happens.
- `Actual result` holds no interpretation and nothing predicted.
- A proposed triage value is never shown as a settled decision.
- If there is nothing concrete to say, leave out `Suspected cause` altogether
  instead of guessing.
- If a duplicate search could not be run, state that plainly rather than
  writing "none found".
- For trackers whose issue forms have no tables, paste the same content as
  headed sections in the same order.
