# 🧪📸 Test design patterns

Guidance for wording Stage 3 and Stage 4 proposals so developers can pick
them up without further translation.

> ⚠️ **Every team has its own conventions, and they change over time.** The
> frameworks named here are well-known public examples, not requirements.
> Before relying on a specific name, open the dependency catalogue and one
> existing test in the affected module, and mirror what you see. **If this
> file conflicts with the repository, follow the repository.**

> 📍 **With repository access, start from the team's own testing guidance** —
> a `CONTRIBUTING.md`, a testing guide in `docs/`, agent instruction files
> (`.github/instructions/`, `AGENTS.md`, or an AI-context folder), or
> developer-facing unit-test and snapshot-test skills. Those take precedence
> over this file. Without access, this file remains a sound general guide and
> `PASTED` mode works as normal.

---

## 1 · 🎯 Test level allocation

Pick the level **first**, then write the proposal.

| Signal | Level |
|---|---|
| Logic with no UI: mapping, converting, validating | 🧪 Unit |
| Moving between states; the view state that results | 🧪 Unit |
| Clock, zone, boundary, and rounding behaviour | 🧪 Unit |
| How errors and failures are handled | 🧪 Unit |
| Order of calls; repeat-safe operations | 🧪 Unit |
| How a known state is drawn | 📸 Snapshot |
| Loading, empty, and error screens | 📸 Snapshot |
| Long copy, maximum type size, dark theme | 📸 Snapshot |
| Physical device, Bluetooth, attached hardware | 🚫 Instrumented / manual |
| Vendor quirks, system settings, Do Not Disturb | 🚫 Manual exploratory |
| OS permission prompts and system dialogs | 🚫 Instrumented / manual |

> 🚨 **Do not suggest a unit test for behaviour a unit test has no way to
> see.** Naming what falls outside unit testing is worth as much as the tests
> you do propose, because it keeps the team from confusing coverage with
> assurance.

---

## 2 · 🔤 Naming — copy the team's convention verbatim

Proposals written in the team's naming style feel native; anything else
looks foreign and gets reworked. Take the pattern from a real test and
reproduce it exactly. Typical patterns:

| Shape | Example |
|---|---|
| Backticked sentence (Kotlin) | `` `SHOULD display limit warning WHEN total passes cap GIVEN cap configured` `` |
| `when…Then…` function name (Swift) | `func whenTotalPassesCapThenLimitWarningIsDisplayed()` |
| `given_when_then` | `givenCapConfigured_whenTotalPassesCap_thenWarningDisplayed` |
| `describe` / `it` (JS / TS) | `describe('LimitCard') › it('displays the limit warning once the total passes the cap')` |

> 💡 Some frameworks let the **function name itself serve as the
> specification** instead of a separate description string. If the team works
> that way, do the same, and confirm description strings are used at all
> before suggesting one.

---

## 3 · 🤖 Android (typical stack)

Usual ingredients: JUnit 4 or 5 · MockK or Mockito · Turbine for flows ·
`kotlinx-coroutines-test` · Robolectric · a DI module for tests · Paparazzi or
Roborazzi for snapshots · Compose `ui-test` · a runner for parameterised tests.

### Unit test shape

- Extend the shared base test class when there is one, and call the system
  under test whatever the team calls it (frequently `sut`)
- Mock collaborators · wrap coroutine code in `runTest` · collect emitted state
  with Turbine
- Mark `// GIVEN`, `// WHEN`, `// THEN` sections if that is local practice
- Read time from an **injected time provider** rather than the system clock

> 💡 With an injected clock, **all ⏰ Time (L4) edge cases become
> unit-testable** — say so to the team. Without one, proposing the injection is
> a countermeasure in its own right.

When an edge case differs only in its input, suggest one **parameterised**
test across the full enumeration instead of a handful of copies.

> 💡 Parameterising over an entire enum also acts as a **tripwire**: adding a
> new value without handling it makes the test fail. Suggest this on purpose
> wherever an exhaustive mapping is important.

### Snapshot test shape

Set up the snapshot rule, wrap the composable in the app theme, and record
each named state with its own call. Because the name typically turns into the
baseline file name, keep it brief and meaningful.

> Aim for one snapshot per **distinct visual state** rather than one per
> screen: normal, empty, error, and warning states mean four snapshots.

---

## 4 · 🍏 iOS (typical stack)

Usual ingredients: Swift Testing (`@Test`, `@Suite`) or XCTest · a
given/when/then helper layer where the team has built one · a test store that
fits the architecture (TCA's `TestStore`, for instance) ·
`swift-snapshot-testing` · Swift package modules each with their own test
targets and test plans.

### 🧱 Say which target

Unit and snapshot tests frequently sit in **different targets** — say
`{Package}Tests` and `{Package}SnapshotTests`, with reference images under
`__Snapshots__`. State the target in every proposal; "add it to the limit
tests" leaves the reader guessing.

### 🗂️ Test layers worth distinguishing

| Layer | Tests | Shape |
|---|---|---|
| **Use case** (domain) | Business rules on their own | repository stubbed to return X → use case executes → result is Y |
| **Reducer / view model** (presentation) | State changes and side effects | action sent → state becomes Z and effect E fires |
| **Integration** | End-to-end feature flows | Several collaborators chained together |

### 📸 Snapshot approach — state-injected versus lifecycle-driven

| Approach | Use when | Cost |
|---|---|---|
| ✅ **State-injected** *(usually the default)* | Drawing a supplied state; many variations; features whose effects run long (observers, timers) | Quick and repeatable; no effects run |
| ⚠️ **Lifecycle-driven** (view hierarchy / window) | Checking real `onAppear` timing, lifecycle-bound animation, or effects actually executing | Slower; requires a window and awaiting every effect |

> 🚨 Injecting state **skips effects completely**. The snapshot shows the view
> *draws* correctly, not that loading takes place — a reducer or view-model
> test is still needed for that. Prepare the state beforehand; do not replace
> the store once the view exists.

> ⚠️ When dependencies are overridden inside a scoped block (such as
> `withDependencies`), build the view **within** that block. A view built
> outside it picks up system defaults, and the snapshot quietly records the
> wrong output.

### 🔒 Isolate persisted shared state

Suites that use process-wide persisted storage (`UserDefaults`, files,
keychain wrappers) need isolation per test. Without it, tests running in
parallel interfere with one another and produce intermittent failures that
masquerade as product bugs. Reach for an isolation trait or in-test storage
before serialising a whole suite, and serialise only what is truly
order-dependent.

> 💡 **This doubles as an edge-case hint.** When a story touches shared
> persisted state, call out the need for isolation in the proposal.

### ⚠️ Unwrapping and errors (Swift Testing)

| Rule | ✅ Do | ❌ Don't |
|---|---|---|
| Unwrap an optional | `try #require(optional, "message")` | `guard let` + `Issue.record` |
| Handle a thrown error | Declare the test `throws` and let the error escape | `do/catch` that flips a boolean |
| Assert an expected throw | `#expect(throws:)` or `try #require(throws:)` | Hand-rolled `do/catch` tracking |

> 🚨 `Issue.record` logs a failure **without halting the test**, so the
> assertions after it run on bad state and produce confusing failures.

### 🎛️ Determinism

Fix UUID generation, the current date, the calendar, timezone, locale, and
any clocks via the team's dependency mechanism. Prefer test clocks to real
sleeps.

---

## 5 · 🌐 Web (typical stack)

Usual ingredients: Jest or Vitest · Testing Library · MSW or an equivalent
for mocking the network · fake timers · Storybook plus visual regression
(Chromatic, Loki) or Playwright screenshot assertions.

- Locate elements by **role and accessible name** first, and use
  `data-testid` only where the team already relies on it
- Fix timezone and locale in the test setup; drive anything time-dependent
  with fake timers
- Treat each component story (one per visual state) as the snapshot unit,
  just as on mobile

---

## 6 · ▶️ Running tests

Run the module with the command the repository documents — a Gradle task, an
`xcodebuild` scheme and destination, or a package script, for example.

> 🚨 **Do not suggest altering platform or build settings merely so another
> test runner will work** (adding a desktop target to a mobile-only package,
> say). Point to the documented command instead.

Run the **entire module or package** that the change touches rather than one
file in isolation.

---

## 7 · 🔀 Parity

If sibling tickets exist for other platforms, propose **matching logical
tests on each**, and note any place where a platform truly cannot match.

> ⚠️ Platform behaviour drifts apart when sibling tickets quietly end up with
> different test proposals.

---

## 8 · ⚠️ Read the existing test harness first

Test suites commonly fix locale, timezone, date, and light/dark appearance so
results are repeatable. **Look up those fixed values before you propose
anything** — they determine what the suite is blind to.

| Trap | Consequence |
|---|---|
| **A pinned environment hides whole classes of edge case** | A suite locked to UTC cannot catch a timezone or DST bug however many tests it gains |
| **Proposing variants the product doesn't support** | When all baselines are light mode and dark mode is a future story, dark-mode snapshots add work for a feature not yet built |
| **Small, tidy fixtures** | Overflow, truncation, and long lists never show up |
| **A state-injected snapshot bypasses effects** | It confirms *drawing* only, not that data loads; a logic-level test must cover that |

**Therefore:** if an edge case hinges on a pinned dimension, point that out
and propose a test that **overrides** the pinned value, rather than one that
inherits it and passes for the wrong reason. If an edge case calls for a
maximal fixture, include that in the proposal.

---

## 9 · 📏 Coverage expectations

Where the team follows TDD or has coverage thresholds (typically higher for
use cases and view models than for views), explain how the proposals line up
with them. Under TDD, edge cases raised in refinement feed straight into the
developer's red step — the best argument for running this skill early.

Simple UI tweaks, documentation, and configuration are usually exempt.
**Keep proposals for that kind of work light.**

---

## 10 · ✍️ How to write the proposal

Write each proposed test as a single row:

| Field | Content |
|---|---|
| **Edge case ID** | The `EC-` ID, or "baseline" |
| **Level** | 🧪 unit · 📸 snapshot · 🚫 neither |
| **Target** | Class, view model, use case, component, or composable under test — plus the **test target or folder** when unit and snapshot tests live apart |
| **Proposed name** | Written exactly in the team's naming style |
| **Assertion** | The precise condition that must be true |
| **Handoff** | The developer-side skill or existing test file to build on |

> 💡 **Extending an existing test file beats starting a new one.** When you
> locate a suitable file, name it; that makes the proposal cheaper to act on
> and keeps the suite tidy.

> 🚫 **Leave full test bodies out** unless someone requests them. The proposal
> specifies what to test; the developer writes the implementation. An exact
> name and an exact assertion are sufficient.
