# Risk model — impact × likelihood with modifiers

A deliberately simple, explainable model. If
[`PROJECT-CONTEXT.md`](../../../PROJECT-CONTEXT.md) names a team scale, use
that instead and keep the rest of the method (pathway first, evidence-backed
ratings, floors, residual risk).

## Impact (1–5) — what the user experiences if the area fails

Rate the **worst credible** consequence, not the most likely symptom.

| Score | Anchor | Plain-language examples |
| ---: | --- | --- |
| 5 | **Severe** — irreversible data loss or corruption; security or privacy exposure; the user acts on wrong information with a costly or hard-to-undo result | Saved entries silently deleted on sync; another user's data visible; a payment or transfer amount shown wrong |
| 4 | **Major** — wrong information shown that the user is likely to rely on; core flow blocked with no workaround | Budget balance off by a month; cannot log in or save; crash on launch for a supported OS |
| 3 | **Moderate** — core flow degraded but a reasonable workaround exists; secondary information wrong | Sync needs a manual retry; a chart label wrong while the numbers are right; a filter ignores one option |
| 2 | **Minor** — secondary function broken or confusing; little consequence | Settings toggle needs two taps; an empty state shows the wrong illustration |
| 1 | **Cosmetic** — appearance only, no effect on understanding or action | Misaligned icon; inconsistent spacing |

Rules:

- **Rate by consequence, not appearance.** A one-character formatting error in
  an amount is not cosmetic.
- **Security and privacy exposure starts at 5** unless the data involved is
  provably non-personal and non-sensitive.
- **Recoverability matters.** Data the user can restore from a backup in one
  step may be a 4 instead of a 5; data they cannot restore stays at 5.

## Likelihood (1–5) — how likely a defect exists *and* is reached

| Score | Anchor | Typical evidence |
| ---: | --- | --- |
| 5 | **Almost certain** | New, complex logic on the default path; area has a recent history of defects; no existing tests |
| 4 | **Likely** | Significant change to an area with past defects or high churn; new third-party dependency or API contract |
| 3 | **Possible** | Moderate change; some existing coverage; occasional past defects |
| 2 | **Unlikely** | Small, well-understood change; good coverage; stable area |
| 1 | **Rare** | Trivial change (copy, config value) with strong existing coverage and no history |

Label every likelihood rating with the evidence used. If the rating rests on
reasoning rather than retrieved evidence, mark it `Inference`.

## Score and base tier

`Risk score = Impact × Likelihood` (1–25).

| Score | Base tier |
| ---: | --- |
| 1–4 | Smoke |
| 5–9 | Standard |
| 10–15 | Deep |
| 16–25 | Exhaustive |

## Modifiers — move the tier by at most one step

| Modifier | Raises one tier when… | Lowers one tier when… |
| --- | --- | --- |
| **Change complexity** | Concurrency, background work, offline/sync, date/time/time-zone logic, state machines, migrations, money/rounding, permissions, third-party integration, platform-specific code paths | Change is mechanical (rename, copy, constant) and fully covered by passing automated tests that you confirmed ran |
| **Exposure** | Default or first-run path; every user hits it; daily use; onboarding; anything run at upgrade time | Behind an off-by-default flag; reachable only from a rare settings path; internal-only tool |

Apply at most one net step up or down. State each modifier and its reason.

## Floor rules — never tier below these

| Condition | Minimum tier |
| --- | --- |
| Impact 5 | Deep |
| Impact 4 | Standard |
| Security / privacy exposure of any kind | Deep, plus a targeted security-minded charter |
| Data or contract change (schema, migration, persisted format, API shape) | Standard, including upgrade from the previous version with existing data |

## Depth tiers — what each tier means in practice

| Tier | Minimum activities |
| --- | --- |
| **Smoke** | Happy path once on the primary platform; confirm nothing obviously broken. |
| **Standard** | Happy path plus key negative cases and boundaries on every supported platform; check the main acceptance criteria against their oracle. |
| **Deep** | Standard plus state transitions, interruptions (background, kill, network loss), recovery, cross-feature effects, data integrity across restart and upgrade, and a timeboxed exploratory charter. |
| **Exhaustive** | Deep plus a configuration/combination matrix (OS versions, locales, time zones, account states), repeated runs for intermittent behavior, an independent second reviewer of the test design, and an explicit oracle for every check; consider whether automation should guard it afterwards. |

## Residual risk — how to state it

One or two sentences per area that receives less than its proposed tier, or
that has known untested conditions:

> **<Area>** — tested at <tier> instead of <proposed tier> because <reason>.
> If a defect exists in <untested condition>, the user would <consequence>.
> Detection would most likely come from <signal: support ticket, crash report,
> nobody>.

The "detection" clause matters: a silent failure (nobody would notice) is a
stronger argument for depth than a loud one.
