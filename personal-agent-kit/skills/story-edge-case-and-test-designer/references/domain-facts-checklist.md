# 🧭 Domain facts checklist

The narrow (Tier 2) edge cases come from knowing the product's domain, and the
worst false positives come from *not* knowing what the team already treats as
settled. This file lists the domain facts worth collecting before Stage 1.

**Where the facts come from, in order:**

1. `../../PROJECT-CONTEXT.md`, if the skill sits in a kit that has one;
2. the code neighbourhood (enums, constants, configuration, bundled assets);
3. the story, its parent, and linked tickets;
4. the user — ask only for facts that change a finding.

> ⚠️ **A snapshot, not a specification.** Whatever you collect, verify
> consequential details against current code. Where recorded facts and the
> code disagree, **the code wins** — and the disagreement is itself worth
> reporting.

In the 📋 Story and evidence section, say which facts were known, which came
from code, and which stayed unknown.

---

## How to use each fact

| A fact is… | Then… |
|---|---|
| 🧠 **Settled team knowledge** (recorded and agreed) | A story may rely on it silently. **Never report it as an AC gap.** Report only a story that *contradicts* it |
| 🚧 **A known open point** (already raised by the team) | Reference it if the story touches it, as a risk — **never as a fresh discovery** |
| ❓ **Unknown** | State the assumption you made, and turn it into a refinement question only if it changes a finding |

---

## 1 · What the product is

- [ ] One sentence: what it does and for whom
- [ ] The **critical boundaries** — where failure costs users data, money,
      access, privacy, or trust
- [ ] Who the users are and how trained they are. *Untrained users make use
      error a primary risk, not an edge case*
- [ ] Which parts the team treats as higher-criticality (for example anything
      that calculates, formats, or alerts on a value users act on — including
      the string catalogues used for that formatting)

## 2 · Structure

- [ ] Top-level navigation (tabs, sidebar, main routes)
- [ ] Settings hierarchy, and which settings change behaviour elsewhere
- [ ] Feature areas / modules, so a story can be placed in its neighbourhood

## 3 · State machines — the richest source of narrow edge cases

For every long-lived entity the app renders differently by state (an account,
a subscription, a sync job, a paired device, an order, a timer):

- [ ] The **full** state list, including warning and error variants
- [ ] Which transitions are high-yield — a state ending (trial expiring,
      warm-up or onboarding completing), a short failure becoming a long one,
      an error arriving **while a screen is open or a form is being filled**
- [ ] Which screens render differently per state

> 💡 Test any story touching that entity against the **whole taxonomy**, not
> the two or three states the acceptance criteria happen to name.

## 4 · The core value model

For the main values users act on (balance, score, progress, quantity,
reading, price):

- [ ] **Units / currencies / formats** — which exist, which is the internal
      calculation unit, precision per unit, and whether users can switch
- [ ] **Writing convention** — the unit or format criteria are written in by
      team agreement. *Never report the missing alternative as a gap; still
      test the alternative's behaviour as a 🌍 Locale & units (L9) edge case*
- [ ] **Presentation states** — the bands a value can fall into, and which
      boundaries are **fixed** versus **personalised** by the user
- [ ] **Deliberate disagreements between surfaces** — for example a chart
      drawing three bands while a summary card distinguishes five. *Ask which
      surface a criterion describes before calling it a contradiction*
- [ ] **Sentinel values** — readings or results with no number at all
      (unknown, infinity, "over limit") and how they survive conversion,
      averaging, sorting, and display
- [ ] **Boundary inclusivity** — is a value exactly on a limit inside or
      outside? When does a threshold count as "crossed"?
- [ ] **Known drift** — conversion or rounding that makes a threshold fire at
      a value the user sees as still inside the limit

## 5 · Profiles, defaults, and adjustable bounds

- [ ] User profiles or plans and their defaults
- [ ] The bounds within which users may personalise each setting
- [ ] Defaults that make a band **empty** until the user changes a setting
      (high-yield, and not a gap in a story that doesn't mention it)
- [ ] Overlapping bounds that would allow an inverted or zero-width range
      unless actively prevented
- [ ] Where these live (bundled asset, remote config, backend) and whether
      platforms share one source

## 6 · How testers reach each state

- [ ] Test tools, simulators, seed scripts, debug menus, or fixture accounts
- [ ] The input range those tools can produce versus the app's own model.
      *Test-input bounds are not product boundaries — never flag a criterion
      for disagreeing with a tool's range*
- [ ] States a tool **cannot** produce (for example a valueless sentinel that
      looks identical on screen to an extreme numeric value — injecting the
      extreme has not tested the sentinel)

## 7 · Main entities and user-entered data

- [ ] Entry types, categories, tags, and their enumerations
- [ ] Whether entries can be **backdated** or future-dated — if so, every
      ⏰ Time (L4) case is live: ordering, day grouping, midnight, timezones
- [ ] Edit and delete semantics, and what derived values recompute

## 8 · Notifications and alerts

- [ ] Channels or categories per platform, and their importance levels
- [ ] **Irreversible platform state** — for example Android channel settings
      that survive deletion and cannot be raised back by the app
- [ ] Do Not Disturb / Focus behaviour per platform
- [ ] Lock-screen visibility — *a privacy decision, not a styling one*
- [ ] Background or foreground-service notifications that must stay silent

## 9 · Connectivity and integrations

- [ ] Each independent data path (backend, sync service, paired device,
      third-party API) — and the fact that one can be up while another is
      down. *Criteria frequently conflate them*
- [ ] Catch-up behaviour after reconnection: backfill, duplicates, ordering
- [ ] Pairing, linking, or authentication flows — both user-impact- and
      security-relevant

## 10 · Settled timing and behaviour conventions

- [ ] Recurring intervals, windows, and timeouts the team has agreed (sync
      interval, staleness limit, reminder lead times, auto-hide windows,
      reporting periods — and whether a "month" is calendar or rolling)
- [ ] Which durations come from an external source rather than app
      constants — never assume a fixed value for those
- [ ] **QA timing overrides** — compressed timers in debug builds. *Ask for
      the override before proposing a long-running manual test; a test that
      passes only under compressed timings has not exercised production*
- [ ] Shared vocabulary — rule identifiers, state names, or codes the team
      uses. *Use them; a proposal that names the rule it affects is easier to
      review*

## 11 · Platform baselines and deliberate differences

- [ ] Minimum OS / SDK / browser versions and UI framework per platform
- [ ] Runtime permissions that apply at those versions
- [ ] **Deliberate platform differences** — different keys, libraries, or OS
      capabilities (for example one platform can break through Do Not
      Disturb and the other cannot). *Recorded differences are not parity
      gaps; an unrecorded one in a story promising identical behaviour is a
      real finding*

## 12 · Risk and security assessment practice

- [ ] Whether the team records a product-risk or security assessment on
      tickets, and in which fields
- [ ] Whether traceability from requirement through test to evidence is
      expected — if so, the 🔗 Traceability section carries extra weight

---

### Example — a personal budget app (fictional)

| Fact | Example value | Kind |
|---|---|---|
| Writing convention | Criteria state amounts in the account's base currency | 🧠 Settled |
| Presentation states | Under budget · near limit (≥ 90%) · at limit · over budget | 🧠 Settled |
| Boundary inclusivity | Exactly 100% counts as *at limit*, not over | 🧠 Settled |
| Sentinel | "Pending" transactions have no final amount | 🧠 Settled |
| Known drift | Currency conversion rounding flips *near limit* early for some currencies | 🚧 Known open point |
| Timing | Bank sync every 6 h; a reporting "month" is the calendar month | 🧠 Settled |
| Deliberate difference | Widgets exist on iOS only | 🧠 Settled |
