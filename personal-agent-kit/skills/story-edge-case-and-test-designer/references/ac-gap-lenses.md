# 🧩 Acceptance criteria gap lenses — Stage 1

Run all of these lenses against the normalised criteria. A lens that turns up
nothing still gets reported, so the reader knows it was applied.

> 🔤 Output always uses the lens **name** with its code in italics, e.g.
> `🔀 Cross-criterion conflict *(G-D)*`. A bare code is not enough. Copy the
> names exactly as the table below spells them.

## Quick reference

| # | Lens | What it probes |
|---|---|---|
| **G-A** | 🚨 Stale premise | Is the "new" thing actually there already? *(best hit rate — run first)* |
| **G-B** | 🌫️ Unfalsifiable | Could two testers disagree on pass/fail? |
| **G-C** | ⚔️ Unresolved trigger | Does a single criterion permit two outcomes? |
| **G-D** | 🔀 Cross-criterion conflict | Can two criteria fail to hold together? |
| **G-E** | ❌ Missing failure path | Is the unhappy path defined? |
| **G-F** | 🚪 Undefined precondition | Which entry states are possible? |
| **G-G** | 📋 Incomplete enumeration | Does the list cover every value? |
| **G-H** | 🎛️ Under-specified attributes | Is only one of many properties pinned down? |
| **G-I** | ❓ Referent ambiguity | Could a pronoun point at more than one thing? |
| **G-J** | 📏 Missing units or format | Are unit, precision, zone, and length stated? |
| **G-K** | 💾 Pre-existing data | How is older data treated? |
| **G-L** | ⬆️ Upgrade silence | What changes for someone who updates? |
| **G-M** | 👻 No observable outcome | Is there any way to confirm it happened? |
| **G-N** | 🗯️ Open question inside | Does the ticket still contain a "TBD"? |
| **G-O** | 🔗 Unstated dependency | Is something else required to ship first? |
| **G-P** | 📱 Platform parity | Are cross-platform differences intended? |
| **G-Q** | 🎨 Design mismatch | Does the mock-up promise more than the text? |

## First, normalise

Rewrite the criteria as a numbered list where each item makes **a single
assertion**. From that list, pull out the actors, the preconditions, the
triggers, the main path, any alternate paths, and how the flow ends.

> 💡 Many gaps surface while you do this. If an item refuses to break down
> into single assertions, it usually contains more than one requirement.

## Output per finding

Every finding carries the same four parts:

1. What the **gap** is
2. Which **lens** found it, by name — `🚨 Stale premise *(G-A)*`
3. A **refinement question** phrased so the team can ask it as-is
4. A **proposed rewrite** of the affected criterion

> ⚠️ Pointing at a gap without offering replacement wording is just a remark;
> the rewrite is what makes it useful.

---

## G-A · 🚨 Stale premise

**The story says something is missing — does the code say otherwise?**

Look up the real identifiers the story wants to introduce: classes, enums,
config keys, and similar.

> 🚨 **Run this lens before the rest; nothing in the catalogue finds more.**
> Authors frequently work from an out-of-date picture of the system. A false
> premise invalidates the estimate and the scope, and frequently the chosen
> approach too, so it outranks every other finding.

Raise a false premise as a **blocking finding** and place it ahead of every
other section.

## G-B · 🌫️ Unfalsifiable wording

**Would a tester know, without debate, whether this passed?**

Watch for: *works correctly · user-friendly · performs well · as expected ·
appropriately · seamlessly · gracefully · properly · if needed*.

Flag as well any criterion promising a result **outside the app's control** —
one the OS, the platform, or the user can override. Rewrite it as what the app
intends to do, and add a note naming what really decides the visible result.

## G-C · ⚔️ Contradictory or unresolved trigger

Look for *or*, *and/or*, an alternative in brackets, or a footnote-style
asterisk that leaves the behaviour open between two options.

> A criterion with two possible triggers describes two different features.
> Settle which one during refinement — code review is too late.

## G-D · 🔀 Cross-criterion conflict

Can any reachable state make two criteria impossible to satisfy at once, or do
they clash outright?

Walk through the criteria in pairs and look for such a state. **Typical
pattern:** an early criterion makes a behaviour depend on a condition, and a
later one relies on that behaviour as if the condition were always met.

## G-E · ❌ Missing negative and failure path

Each success path needs a matching failure definition. Cover the operation
failing, a dependency being down, input being rejected, and the user saying no.

Then pin down the handling: is the failure **silent, retried, surfaced, or
logged**?

## G-F · 🚪 Undefined precondition or entry state

Which screen or flow leads here, and what state might the user be in on
arrival?

Consider each of: first launch, partway through a flow, returning from the
background, signed out, and having already finished.

## G-G · 📋 Incomplete enumeration

If the criteria list values, events, states, or types, does the list cover
all of them?

**Warning signs:** a dangling comma · *etc.* · *such as* · *e.g.* · *including*
· fewer entries than the enum the list corresponds to.

Check the list against the actual enum in the code, and ask what default or
fallback applies to values it leaves out.

## G-H · 🎛️ Under-specified attributes

Is just one property described for an object that carries many?

> If a config object has seven fields and the story mentions one, the other
> six get decided quietly by whoever implements it.

## G-I · ❓ Referent ambiguity

Can each *it*, *this*, *the screen*, *the value*, or *the user* be read in
only one way?

## G-J · 📏 Missing units, precision, timezone, or format

| Value type | Must state |
|---|---|
| Numeric | Its unit, valid range, precision, and how it rounds |
| Date or time | Which timezone applies and how day rollover works |
| Text | The longest allowed length and what happens past it |

> 📏 **Exception — agreed writing conventions.** When the team has settled on
> one unit, currency, or format for writing criteria (see the domain facts),
> do not log a gap just because the other unit is absent or a comparison does
> not repeat its unit. That is the house convention and both developers and
> testers depend on it.
>
> The *behaviour* of units and formats still needs testing. Capture it as a
> 🌍 Locale & units *(L9)* edge case with a proposed test in the alternative
> unit or format, and leave it out of the gap table.

## G-K · 💾 Silence on persistence and pre-existing data

How is data that existed **before** the change handled? Does the new rule
reach back to it? Is any of it migrated, given a default, or recalculated?

## G-L · ⬆️ Silence on upgrade

**What does someone already using the app see after installing this build?**

> ⚠️ Keep this separate from a fresh install. The code path and the risk both
> differ, and it is the scenario stories most often leave out.

## G-M · 👻 No observable outcome

Is the criterion about an internal change that nobody can see or check? If
so, say plainly how it will be verified: through a log, inspectable state,
telemetry, or only by a test.

## G-N · 🗯️ Open question left inside the ticket

Do the description or criteria still contain a question, a *TBD*, or a note
addressed to the team?

> Questions embedded in the criteria mean refinement is not finished. Pull
> each one out; answer it when the code or platform settles it, and otherwise
> list it as a blocking question.

## G-O · 🔗 Unstated dependency

Does the story rely on other work — another story, a backend change, a
design, a feature flag, or something a third party provides? Is that dependency **called out by name**, and do
we know where it stands?

## G-P · 📱 Platform parity

When the story spans platforms (Android, iOS, web), are the differences
intended? Does a sibling ticket exist, and is it consistent with this one?

If a platform limitation rules out identical behaviour, raise it on **all**
sibling tickets. Look at the *deliberate platform differences* recorded in the
domain facts first; anything listed there is not a gap.

## G-Q · 🎨 Design reference and design-versus-criteria mismatch

When the criteria imply new or altered UI, is there a design link or
screenshot? **A visual story with no design is a blocking gap.**

If a design exists, open it and check it against the criteria **both ways**:

- **Behaviour visible in the design but absent from the criteria.** Chevrons,
  drill-ins, buttons, swipe actions, and empty-state art all mean work to build
  and to test. *Navigation that nobody wrote down is the usual case, and the
  one most likely to turn into a scope dispute late on.*
- **A different number of states drawn than described.** One of the two is
  incomplete.

> ⚠️ If the link lands on a cover page, a flow annotation, or a "work in
> progress" card, report that as a finding, then locate the actual design
> before drawing conclusions.

When the chrome around the designed screen differs from the live app, the
design may just be ahead of the build. Raise that as a scope question rather
than a defect.

> 🎨 **Use this lens for how things look, not for how they behave.** Designs
> exist to show layout; the timestamps, values, counts, and date ranges in
> them are placeholders picked for readability. **Do not derive a time window,
> sort order, boundary, or data-retrieval rule from a mock, and do not log a
> gap because its sample data could not happen under the criteria.**
>
> Behaviour comes from the acceptance criteria and from what each platform
> already does. Apply this lens to what is *drawn* — states, copy,
> affordances, truncation — and to designs that are absent or placeholders.
