# Generic bug-report schema

A tracker-neutral schema that maps onto Jira, GitHub Issues, Linear, Azure
Boards, or a plain Markdown file. If
[`PROJECT-CONTEXT.md`](../../../PROJECT-CONTEXT.md) lists your tracker's real
field names and allowed values, read them (read-only) before proposing values,
and prefer them over the defaults below. Trackers change options without
notice, so re-check before relying on a remembered value.

## Fields

| Field | Required | What goes in it | Maps to (examples) |
| --- | --- | --- | --- |
| **Title** | Yes | `[Platform] <observable symptom> when <trigger condition>` | Jira Summary; GitHub/Linear title |
| **Environment** | Yes | Platform (Android / iOS / web / backend / API), OS and version, device or browser, locale, time zone, network, backend environment (dev / staging / prod) | Jira Environment or custom fields; issue body table |
| **Build** | Yes | App version and build number, or commit SHA / deployment ID | Affects Version; body |
| **Preconditions** | Yes | Account state, data present, settings, feature flags, connectivity, permissions granted | Body |
| **Steps to reproduce** | Yes | Numbered, one action per step, minimal set | Body |
| **Expected result** | Yes | Expected behavior **and its source** (AC, test case, design, requirement, documented prior behavior) — or `Oracle gap` | Body |
| **Actual result** | Yes | What was observed, nothing else | Body |
| **Frequency** | Yes | `n/m` attempts, plus `Always`, `Intermittent`, or `Once` | Custom field or body |
| **Severity** | Yes | Proposed, from the scale below, with the anchor matched | Severity field or label |
| **Priority** | Yes | Proposed, from the scale below, with rationale | Priority field or label |
| **Security / privacy flag** | When relevant | `No` / `Potential` / `Under investigation` (propose; owner decides) | Label or custom field |
| **Users affected** | Optional | Estimate with its basis (all users / one platform / one locale / one account state) | Custom field or body |
| **Evidence** | Yes | Screenshots, recordings, logs, crash IDs — listed as attachments to add if not yet provided | Attachments |
| **Workaround** | Yes | The workaround observed, `None found`, or `Not tried` | Body |
| **Notes** | Optional | Suspected cause (as `Inference`), related tickets, odd observations, things ruled out | Body |
| **Links** | When available | Originating test case, story, requirement, PR | Issue links |

## Severity — consequence for the user

| Level | Anchor |
| --- | --- |
| **S1 Critical** | Data loss or corruption; security or privacy exposure; user acts on wrong information with a costly result; crash or block on a core flow for all users with no workaround |
| **S2 Major** | Wrong information the user is likely to rely on; core flow blocked for a subset, or for all with only an awkward workaround |
| **S3 Moderate** | Core flow degraded with a reasonable workaround; secondary function broken or wrong |
| **S4 Minor** | Cosmetic or wording issue with no effect on understanding or action |

**Severity is not appearance.** A one-character formatting error in an amount
the user acts on is S2 or worse; a dramatic-looking crash on a hidden debug
screen may be S3. Judge by what the user would experience and do.

## Priority — order of fixing

| Level | Meaning | Requires |
| --- | --- | --- |
| **P1 / Blocker** | Must be fixed before the next release or merge | A named blocker criterion (below) |
| **P2 / High** | Fix in the current cycle | Rationale: impact × frequency × exposure |
| **P3 / Normal** | Schedule normally | Rationale |
| **P4 / Low** | Fix when convenient | Rationale |

If your tracker has only two values (for example `Blocker` / `Regular`), map
P1 to the top value and the rest to the other, and keep the rationale.

### Blocker criteria (name the one that applies)

- B1 — Data loss, corruption, or security / privacy exposure.
- B2 — A core user journey is blocked with no reasonable workaround.
- B3 — Wrong information shown on a path most users take.
- B4 — Crash or hang on launch or on a default path for a supported
  configuration.
- B5 — Regression of previously working behavior that a release depends on.
- B6 — A legal, licensing, or store-policy requirement is violated.

Urgency alone ("the demo is tomorrow") is not a blocker criterion; record it as
context for the human owner.

## Triage rules

- **Default to investigation, not to a verdict.** When evidence does not support
  a determination, propose `Under investigation` and name who decides (you, on
  a personal project).
- **Severity is not priority.** Propose both, separately.
- **Security-adjacent findings** — exposed data, authentication or session
  behavior, permissions, logging of identifiers — set the flag to `Potential`
  and raise it, even when the visible symptom looks minor.
- **Time, date, money, and counts are high-attention areas.** A defect that
  shows a wrong number or a wrong day is at least a candidate for S2; say so
  and let the owner decide.

## Reproduction quality bar

A defect record is only reproducible if it states all of:

1. Precondition — account state, data present, settings, connectivity.
2. Build or version and platform, for example `Android, 1.4.2 (512)`.
3. Device or browser and OS version, for example `Pixel 8 / Android 15` or
   `Firefox 131 / macOS 15`.
4. Numbered steps, one action each, minimal set.
5. Frequency, for example `3/3`.
6. Actual result, observed only.
7. Expected result **with its source**.

When item 7 has no source, record
`Oracle gap — expected result not confirmed` rather than inventing an
expectation.
