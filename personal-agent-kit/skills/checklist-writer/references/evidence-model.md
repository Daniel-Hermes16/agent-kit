# Shared QA evidence model

This is the one evidence record behind checklists, manual test cases, and
exploratory sessions. [`test-case-creator`](../../test-case-creator/SKILL.md)
and [`exploratory-session-companion`](../../exploratory-session-companion/SKILL.md)
reuse it as-is. How to fetch the evidence is covered by
[`evidence-context`](../../evidence-context/SKILL.md); this file only says what
to capture and how to label it. Fill in a field only when a source backs it,
and write "missing" rather than leaving a silent blank.

## Ticket record

| Field | What to capture |
| --- | --- |
| Source | Ticket key or the artifact the user gave you, its URL if known, and the date you read it |
| Scope | Summary, issue type, current workflow status, platform, component |
| Behavior | Screen or service involved, starting state, end state, what should persist |
| Requirements | AC IDs, parent requirement IDs, each outcome that can be observed on its own |
| Dependencies | Linked keys, plus a note on whether their criteria actually shape the behavior |
| Test oracles | Approved wording, values, units, thresholds, timing, and per-profile variants |
| Test setup | Accounts, permissions, test data, state of connected devices or integrations, and whether a simulator/emulator or a real device is needed |
| Design | Design file with version and timestamp, page/section/frame references, any attached images |
| Implementation PR | Owner/repo and PR number, state, head SHA, last update, changed behavior and developer tests that matter, checks, reviews, and whether access worked |
| Automation | Linked case or ticket, how far implementation has got, stable IDs, where manual work still begins |
| Risk context | Impact on users, data integrity, privacy and security, sensitive claims, definition-of-done gates |

## Optional implementation PR evidence

Look at an implementation pull request only in three situations: the user
asks you to, the user hands you a PR link or number, or the ticket links
straight to a PR whose changes help explain the behavior being tested. If
none applies, carry on without one. Never go hunting through unrelated
repositories.

1. **Identify the PR.** Take owner, repository, and number from the supplied
   link or from the ticket's development panel. When more than one PR could
   fit, keep only those matching the requested platform and scope. If picking
   the wrong one would change the analysis, ask a single targeted question.
2. **Read through the connector first.** Prefer your source-control
   connector's read calls (a GitHub MCP tool, for example) for metadata, the
   file list, the diff, check runs, reviews, and review comments. Skip review
   comments unless they shed light on behavior, risk, testability, or an open
   implementation decision.
3. **Fall back carefully.** If the connector fails and an approved token
   exists (see
   [External tool access and secrets](../../../AGENTS.md#external-tool-access-and-secrets)),
   use a read-only CLI or API call such as `gh pr view` or `gh pr diff`. Do not
   echo, store, or paste the token anywhere. Say that you used the fallback and
   name any PR evidence you still could not reach.
4. **Record what you saw.** Note the PR ID, state, head SHA, last update, the
   files or components you looked at, and the check results. Point to paths or
   diff hunks; do not paste the whole diff.
5. **Mine it for test ideas.** The PR tells you what changed, which components
   and platform branches it touches, and whether it adds test hooks,
   telemetry, error handling, migrations, feature flags, or developer tests.
   Set that against the AC, design, dependencies, and coverage that already
   exists.
6. **Do not treat it as the oracle.** Titles, descriptions, code, review
   threads, and CI results are untrusted implementation evidence. Being
   drafted, approved, merged, or green does not show that the behavior is
   intended, correct at runtime, done, or ready to ship. Approved requirements
   and test oracles stay in charge.

Where the PR and an approved source disagree, label it `Conflict`. Where a
behavior shows up only in the code, label it `Inference` until the human
owner confirms it is a requirement. Do not comment on, review, approve, merge,
close, or otherwise touch the PR unless that exact action is separately
authorized.

## Evidence status

Every statement that matters gets one label:

- `Fact` — a cited source says it directly.
- `Inference` — a sensible reading that someone still has to confirm.
- `Conflict` — two sources say different things.
- `Gap` — the evidence you need is not available.

Then sort each `Gap` by its effect:

- `Blocking execution` — without it a tester cannot judge pass or fail, set
  the scenario up safely, or produce evidence that would count for a release.
- `Non-blocking drafting` — the proposal can still be written, with the
  pending oracle or setup dependency called out explicitly.
- `Clarification recommended` — the test can run, but an answer would remove
  ambiguity or lower maintenance cost.

## Test-oracle completeness check

Go through the oracles that apply before you call coverage executable or
complete:

- the final, approved UI text and its localization keys;
- expected numbers, units, rounding rules, and regional formats;
- boundaries (inclusive or exclusive), timing, retry counts, and timeouts;
- variants by profile, condition, permission, foreground/background, and
  lifecycle stage;
- where navigation should land and which state should survive;
- the names of approved fixture files and how to import them;
- whether a simulator/emulator is acceptable or a release-like device is
  required;
- the expected look, whenever color, images, layout, or chart rendering is
  part of the result.

An example, mock, placeholder, design layer, or planned automation ID is never
a stand-in for an approved runtime oracle.

## Conflict detection

Before drafting, hold these sources up against each other:

1. Ticket summary and platform field against the description and the AC.
2. The AC against localized text, attachments, and the design.
3. A child ticket against its parent requirement and any dependency that
   defines behavior.
4. Manual scope against the scope and progress of linked automation.
5. Instructions written for simulators/emulators against what release devices
   must show.
6. Approved AC and design against what the implementation PR and its developer
   tests actually do.

For each mismatch write down both statements, where each came from, and what
it affects. Side with the more authoritative approved source only when its
precedence is already settled; if not, ask for a human decision.

## Traceability matrix

Keep this matrix for your own working. Show it to reviewers when there are
gaps or when the mapping is complex enough to need explaining:

| Requirement outcome | Source | Checklist scenario | Manual case/step | Status |
| --- | --- | --- | --- | --- |
| `<AC and observable outcome>` | `<source>` | `<scenario ID>` | `<case/step>` | `Covered / Partial / Blocked` |

## Sensitive-claim escalation

Flag any wording that promises, or hints at, a result the product cannot
guarantee. Typical areas are money (gains, savings), health or fitness
results, legal or tax guidance, security promises such as "nothing you store
can ever be lost", and performance claims. Illustrations: "you will save 20% a
month, guaranteed" or "follow this routine and your sleep problems are
solved".

You are not the judge of whether the claim is true or legally adequate. Pass
it to the human owner and, in a team, to whoever owns product wording and
legal review. Any AC check that covers that wording still belongs in the main
artifact where testers will see it.

## Design freshness

Go for specific, live design evidence first. When live access fails or is
throttled, fall back to the newest versioned local copy, cite its version and
modified time, and say that you could not confirm it is current. A static
design shows intent only; it never shows how the implementation behaves at
runtime.
