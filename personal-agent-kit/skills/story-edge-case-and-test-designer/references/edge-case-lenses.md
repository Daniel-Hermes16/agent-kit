# 🎯 Edge case lenses — Stage 2

**This stage is the heart of the skill.** Apply all thirteen lenses, and list
any that came up empty rather than dropping them.

> 🔤 Output refers to a lens by its **name** plus the code, e.g. `⏰ Time *(L4)*`,
> and never by the code alone. Spell each name exactly as in the table.

## Quick reference

| # | Lens | What it probes |
|---|---|---|
| **L1** | 🔢 Boundary & numeric | Where are the limits of each number? |
| **L2** | 📦 Empty, one, many, max | Zero items, a single item, or more than allowed? |
| **L3** | 🔄 State & mid-flow | What if the state shifts *during* a user action? |
| **L4** | ⏰ Time | Zones, daylight saving, midnight, past-dated entries? |
| **L5** | 📶 Connectivity | What if the network or a dependency drops? |
| **L6** | 🔐 Permissions & platform | What if access is refused or withdrawn? |
| **L7** | ♻️ Lifecycle & upgrade | How does an update affect current users? |
| **L8** | ⚡ Concurrency | Duplicated or reordered events? |
| **L9** | 🌍 Locale & units | Decimal separators, translation, changing units? |
| **L10** | ♿ Accessibility & display | Biggest text, dark theme, compact screen? |
| **L11** | 🔒 Data & security | Who can read it, and where is it kept? |
| **L12** | 🧭 Regression neighbourhood | What existing code shares this path? |
| **L13** | 🕳️ Silent failure | Would the failure go unnoticed? |

## Output per edge case

| Field | Content |
|---|---|
| **ID** | Sequential: `EC-01`, `EC-02`, … |
| **Lens** | Full lens name with code — `⏰ Time *(L4)*`, not just `L4` |
| **Scenario** | A concrete situation, not a category label |
| **Why it bites** | What goes wrong for the user |
| **Countermeasure** | What developers should build in **up front** |
| **Priority** | 🔴 P1 must · 🟠 P2 should · 🟡 P3 note |

## Three rules

1. **Concrete over vague.** *"The session times out halfway through a long
   expense form"* gives the team something to act on; *"session errors"* does
   not.
2. **No countermeasure, no edge case.** If there is nothing development
   should do, record it as a test note instead.
3. **Keep to roughly 15 and report how many were cut.** Refinement time is
   limited, and a long unranked list gets skimmed past.

Group the results as **Tier 1 — expected** (cases an experienced tester would
find anyway) and **Tier 2 — narrow** (cases that take domain knowledge,
platform depth, or an adversarial mindset). *The skill earns its keep in
Tier 2.*

---

## L1 · 🔢 Boundary and numeric

- Minimum and one below it, maximum and one above it, zero, negatives
- A value sitting **precisely at** the threshold
- Overflow, huge inputs, loss of precision
- Non-numeric sentinels such as infinity, "unknown", or `null`, which must
  never be naively formatted, averaged, charted, or compared

> ⚠️ Check whether the comparison is **inclusive or exclusive**. "Above
> budget" says nothing about a value *equal to* the budget.

Keep **display rounding** and **logic rounding** apart as well.

## L2 · 📦 Empty, one, many, maximum

Every collection needs: **none · exactly one · normal · maximum · beyond
maximum**.

> 💡 Bugs cluster around **a single item**: plurals, separators, averages,
> and chart axes often break there. **Empty** is nearly as bad, since empty
> states tend to be designed late or skipped.

## L3 · 🔄 State machine and mid-flow transitions

List every state first. Then consider a state change that lands **in the
middle of** a user action — neither before it nor after it.

- The thing being worked on expires, disconnects, or is removed partway through
- The context changes underneath a partly completed form
- States that should be impossible or unreachable — and the result if one
  happens regardless

> 💡 For mobile work, this lens yields the richest narrow cases. Check against
> the **complete** state list in the domain facts, not just the few states the
> criteria mention.

## L4 · ⏰ Time

**Mobile testing neglects time more than any other dimension, and criteria
rarely mention it.**

| Area | Cases |
|---|---|
| Zones | Zone changes with the app open; travelling between zones |
| DST | Spring-forward and fall-back, including the duplicated hour |
| Boundaries | Crossing midnight for anything bucketed by day |
| Clock | User moves the device clock ahead or back by hand |
| Entry | Entries dated in the past or in the future |
| Ordering | Events arriving out of sequence, or sharing a timestamp |
| Spans | Intervals that straddle a day, week, or session edge |
| Duration | Very long gaps; app left in the background for days |

> 💡 Where debug builds shorten timers for QA, a test that only passes with
> shortened timers has not covered the real production interval.

## L5 · 📶 Connectivity and dependency failure

- No connection **when the operation starts** versus losing it **partway
  through**
- Slow, intermittent, and captive-portal networks
- Server errors, timeouts, partial success, malformed payloads
- Independent data paths failing separately — e.g. the backend reachable while
  a paired device or local service is not, or vice versa

Establish what the user is shown, whether a retry happens, and whether an
interrupted operation leaves data consistent.

## L6 · 🔐 Permissions and platform

Walk each permission through: **not yet requested · granted · denied ·
permanently denied · revoked while running · revoked while backgrounded**.

Include the OS feature itself being off — Bluetooth, notifications, location,
battery optimisation — and the difference between app-wide and per-channel
settings.

> ⚠️ Distinguish **what the app decides** from **what only the user decides**.
> The app cannot guarantee behaviour the user is able to override.

## L7 · ♻️ Lifecycle, persistence, and upgrade

- Backgrounding and resuming mid-flow · process kill · rotation · force-quit
- Reinstalling · clearing app data
- **Upgrade** — the highest-risk case and the least documented one

> 🚨 Certain platform state **cannot be changed once it exists** — Android
> notification-channel settings, for instance, or a stored identifier that
> other systems rely on. Spot it early, because no later release can undo it.

## L8 · ⚡ Concurrency and interruption

- Rapid double-triggering of one action
- Two sources writing the same data
- A phone call, alarm, or system dialog arriving mid-flow
- Startup still running when the feature is first used; work finishing out of
  order
- Catch-up or backfill producing duplicated or reordered records

Wherever ordering is assumed, check that something actually guarantees it.

## L9 · 🌍 Locale, units, and formatting

- Changing unit or currency, and the effect on values already on screen or
  saved
- Conversion drift — the check runs in one unit and the display uses another,
  so a limit triggers while the user still sees a value inside it
- Comma versus dot for decimals; grouping separators
- Date and time formats; 12-hour and 24-hour clocks
- Translations much longer than the English text; right-to-left layouts where
  supported

> ⚠️ Text the platform resolves once and caches **does not** update when the
> user later switches language.

## L10 · ♿ Accessibility and display

- The largest dynamic type size combined with the smallest supported screen
- Dark mode · truncation of long text · landscape where supported
- Screen-reader order and labels wherever colour alone signals state

> 🚨 Showing a meaningful state (status, warning, error, over-limit) only
> through colour is an accessibility defect and a risk to users at the same
> time.

## L11 · 🔒 Data integrity, privacy, and security

**Where does the data travel, who has sight of it, and for how long is it
kept?**

- Exposure without signing in — lock screen, notification previews,
  app-switcher thumbnails, screenshots
- Logs, crash reports, analytics, exports, backups
- Whether deletion really removes everything
- Newly added dependencies or endpoints
- Keys, tokens, pairing, certificates, sessions

Anything found here goes straight into the 🔐 security section of the output.

## L12 · 🧭 Regression neighbourhood

**Which existing code already depends on what this story changes?**

Name the screens, features, and tests in the same module. For each one, ask
how a careless change could break it:

- A shared configuration changed for everyone at once
- A shared component given new styling
- A shared enum gaining a value that not every consumer handles

> This lens needs repository access; state it clearly when you do not have it.

## L13 · 🕳️ Silent failure

Go back over every failure mode identified so far and ask: **would anybody
find out?**

Failures that raise no error, write no log, and change nothing visible while
quietly disabling something are the most dangerous kind in a product people
depend on.

> 🚨 From the outside, an alert that is broken is indistinguishable from an
> alert with nothing to report. **Treat every silent-failure candidate as
> 🔴 P1 unless there is a reason not to.**
