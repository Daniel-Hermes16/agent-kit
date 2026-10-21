# UI automation lifecycle playbook (generic)

Use this reference to ground automation ideation. It is a framework-agnostic
summary of practices that hold across mobile, web, and API automation. When
your project has its own written playbook, record its location and version in
[`../../../PROJECT-CONTEXT.md`](../../../PROJECT-CONTEXT.md) and treat it as
authoritative where it differs from this file.

Framework names below (Appium, Espresso, XCUITest, Playwright, Cypress,
Selenium, REST-style API runners, Cucumber/Gherkin, Screenplay, page objects)
are **examples only**. Map each idea onto whatever stack you actually use.

## Contents

- [Scope boundaries](#scope-boundaries)
- [Framework architecture](#framework-architecture)
- [Locator strategy](#locator-strategy)
- [Runtime test seams](#runtime-test-seams)
- [Multi-device and multi-driver topology](#multi-device-and-multi-driver-topology)
- [Accessibility checks](#accessibility-checks)
- [Intake decisions](#intake-decisions)
- [Framework limitation inventory](#framework-limitation-inventory)
- [Disposition rules](#disposition-rules)
- [Lifecycle stages](#lifecycle-stages)
- [Failure routing](#failure-routing)
- [Flakiness, test data, and environment](#flakiness-test-data-and-environment)
- [Traceability minimum](#traceability-minimum)

## Scope boundaries

### What to automate

- **Critical user journeys**, phrased as outcomes. Instead of "test the
  'Forgot password' button", think "a registered user who forgot their
  password can reset it and sign in".
- Smoke and regression checks that run often and change rarely.
- Data-driven validations (for example form fields with many valid/invalid
  inputs).
- Navigation flows between screens and state transitions with clear oracles.
- API contracts and business rules that sit below the UI — prefer the lowest
  layer that can prove the behavior.

### What not to automate (or not at UI level)

- Look-and-feel: pixel layout, colors, font sizes, exact positions. Check
  presence and interactability instead; leave visual comparison to dedicated
  screenshot/snapshot tests if the team has them.
- Features whose layout or design still changes frequently.
- Animation-heavy or complex-gesture flows unless they are essential.
- Checks that need human judgement (is this copy clear? does this feel
  right?) — keep them manual and say so.

### Preventing over- and under-testing

- One scenario proves one specific outcome; avoid scenarios that verify many
  unrelated things at once.
- Regularly retire unused, duplicated, or chronically flaky scenarios.
- Ensure at least the core cases per feature are automated.
- Tag every automated test with its story and case reference (for example
  `@PROJ-123`, `@case-456`), its execution group (`@smoke`, `@regression`),
  priority (`@core`), and platform (`@ios`, `@android`, `@web`), so scoped runs
  are a one-line command and coverage is searchable.

## Framework architecture

Most UI automation stacks have the same layers, whatever the tools:

1. **Scenario / spec** — business-level description (Gherkin feature, or a
   plain test function with a descriptive name).
2. **Glue / step definitions** — map scenario language to code.
3. **Reusable actions** — Screenplay tasks/interactions/questions, page
   objects, or helper functions. This is where reuse and maintenance live.
4. **Locators / targets** — per-platform element selectors.
5. **Driver / runner** — the engine that talks to the device, browser, or API
   (for example an Appium server, a native instrumentation runner, a browser
   driver), configured per environment.

Healthy-suite signals to check in current code (do not assume them from old
notes): scenarios stay at business-outcome level; repeated flows use
parameterised scenarios; assertions are reusable; waits are explicit, never
fixed sleeps; test data is centralised; platform branching is contained in the
locator/action layer; no no-op steps; consistent actor/session setup.

Separate automation repository vs. tests inside the app repository is a
tradeoff — separate repos give an independent stack, unified cross-platform
coverage, and artifact-based testing; co-located tests give better developer
visibility and fewer synchronisation gaps. Note which one applies; it affects
how drift is detected.

## Locator strategy

- Prefer **unique, stable, native identifiers** that exist for testing and do
  not change with copy or layout. Examples: Android Compose `testTag` exposed
  as resource IDs, Android view `resource-id`, iOS `accessibilityIdentifier`,
  web `data-testid`.
- Fallbacks (XPath, class chains, predicate strings, CSS paths, visible text)
  are higher-maintenance risk; text-based selectors also break on
  localization. Say so when a proposal depends on them.
- Dynamic or list elements need deterministic, state-aware identifiers (for
  example `habit-row-<id>` rather than an index).
- Validate every new identifier with the actual driver before relying on it.
- When identifiers are missing, propose separate linked improvement work per
  platform for the app developers, and keep the test `BLOCKED` or `SPLIT`
  until they exist.
- Be careful when reusing accessibility labels as locators: changing them for
  screen-reader users must not silently break tests, and tests must not
  pressure teams into worse labels.

## Runtime test seams

Seams let tests reach a state quickly and deterministically instead of
clicking through long setup:

- **Deep links / URL routes** — direct, typed navigation to a screen. Simple,
  narrow surface, well suited to UI checks.
- **Debug-only hooks** (for example broadcast receivers, launch arguments,
  test-only menus or endpoints) — broader control over state and test data,
  but a larger security and maintenance surface.
- **API / database seeding** — create data through the backend before the UI
  test starts.

Rules:

- Automation entry points must be **absent or non-operational in production**.
  Prefer build-variant isolation (debug-only modules or manifests, with a no-op
  module in release builds) over runtime flags alone; runtime checks are
  weaker protection.
- Wrap seams in explicit reusable actions; do not leak command construction
  into scenario steps.
- Do not assume parity across platforms — a seam that exists on one platform
  is follow-up work on the other until proven.

## Multi-device and multi-driver topology

Some scenarios need two actors at once (for example the app plus a companion
device, a second user, a peripheral simulator, or a web admin console).

- Name each actor/session explicitly and document which configuration supplies
  each driver.
- Keep machine-specific values (device IDs, local paths, ports) in ignored
  local config or injected properties, never in source control.
- Check whether the shared driver/session code is thread-safe. If it caches
  drivers or mutates global state, plan **sequential** execution unless current
  code proves otherwise.
- Physical-device needs (pairing, radios such as Bluetooth/NFC, cameras,
  specific OS hosts) are not met by ordinary container or cloud runners. State
  the real hardware and host requirement.

## Accessibility checks

- Automated accessibility audits (for example the platform's built-in audit
  APIs or axe-style scanners) inspect only the **current view hierarchy** at
  the moment they run. They are not a full conformance audit.
- Tool support differs per platform and driver; check what the current stack
  can actually run before proposing it.
- Invoke scans at deliberate screen checkpoints and pair them with manual
  screen-reader, text-size, contrast, and focus-order checks for what tools
  cannot establish.

## Intake decisions

- **Platform split:** if manual cases are split per platform, compare them
  against the latest main-branch builds on each. Fuse them only after
  confirming the flows are aligned.
- **Outdated baseline:** if steps or expected results no longer match the
  current app, stop. Manual QA updates the baseline and explicitly confirms
  before automation continues.
- **Execution context:** decide whether the test is for in-sprint feedback,
  release regression, or both. Coverage that relies on simulated hardware,
  fake data, or mocked services can be valuable in-sprint while not counting
  as release evidence under your definition of done. Record that distinction
  in the case's automation status, not only in someone's head.
- **Real-hardware dependence:** tests that need raw feedback from physical
  hardware are `MANUAL-ONLY` or hardware-lab candidates unless the stack can
  drive that hardware.
- **Ambiguous labels or rules:** when team wording is unclear, ask; do not
  convert it into an automatic rule.
- **One-platform cases:** when a case exists for one platform only, decide
  whether to extend it once the other platform ships or to duplicate it per
  platform; record the choice.

## Framework limitation inventory

Challenge every proposed assertion against these categories. Confirm current
limits against the actual stack; the boundaries below are typical, not
universal.

| Category | Typical boundary |
| --- | --- |
| Visual styling | Colors, gradients, typography, exact position, spacing, dark mode are not reliably verified by element queries. |
| Charts / graphs | Rendered lines, unlabelled ticks, individual data points, range indicators, and scrub/selection are limited or brittle. |
| Animation | Animated content, progress state, and transition timing are not verifiable beyond container presence. |
| Text | Presence is supported; correct dynamic or localized content, truncation, overflow, and reflow are not systematically covered. |
| Images / icons | Element presence does not prove the correct asset, crop, or resolution. |
| Audio / haptics | Sound choice, volume, duration, and vibration patterns are usually unsupported. |
| Accessibility | Reading order, contrast, dynamic type, and full audits often need tools the stack lacks. |
| Gestures | Pinch, multi-touch, long press, and scroll-triggered loading are brittle or need special handling. |
| OS UI | Notifications, system dialogs, widgets, and lock-screen surfaces are not reliably validated. |
| Real-time state | Streaming cadence, countdowns, and progress over time are timing-dependent and flaky. |

An addressable element or visible container proves **presence only**. Never
infer visual, semantic, timing, or accessibility correctness from it.

## Disposition rules

### Fuse aligned platform cases

Choose one permanent cross-platform master with manual QA during coverage
review. Retire the duplicate with a clear prefix, remove its automation
linkage, add a note linking to the master, and move it to the retired area of
your test management.

### Split partial coverage

Create an automated variant for the feasible scope and adapt the original
manual case to keep history and the non-automatable steps. Cross-link both,
set accurate automation status on each, agree priority during coverage
review, and keep the manual companion in its regression location.

### Maintain drifted automation

When a new story changes an automated case: manual QA updates the baseline,
marks it as needing automation update, links the story, and keeps a pre-change
snapshot. The automation engineer opens a linked maintenance ticket, updates
scenarios and shared actions, and follows the normal review, CI, and
independent-completion gates.

### Reuse or extend a base case

Use bidirectional references between base and expanded cases, explicit base
vs. expanded scope, dependency tags, and reusable actions. Re-run every
dependent after a shared change. Treat new custom fields, automated result
publishing, and dependency mechanisms as proposals until the team agrees.

## Lifecycle stages

A typical lifecycle for one automation ticket — adapt the names to your
board:

1. **Backlog** — link the originating story and manual case; attach a snapshot
   of the untouched manual baseline.
2. **Ready** — priority, scope, estimate, and iteration agreed.
3. **In progress** — map coverage to scenarios, implement, open a PR, and
   record the exact test-management impacts on the ticket.
4. **Coverage review** — automation engineer and manual QA review coverage
   together; manual QA confirms before it moves on.
5. **Code review** — a peer reviews architecture, reuse, stability, and
   selectors, then approves.
6. **Merge and stabilise** — merge and run CI repeatedly (default bar: three
   consecutive green runs); attach pipeline reports to the ticket.
7. **Done** — update the automation status in test management. Someone other
   than the person who approved the merge performs the final completion step
   (four-eyes).

Fast-lane closure is for duplicate or obsolete work only, with a written
rationale.

## Failure routing

| Root cause | Follow-up | Current ticket |
| --- | --- | --- |
| New app defect | Raise a separate bug and a linked automation task. | Finish the current automation ticket. |
| Locator or flow drift | Raise an isolated maintenance task linked to the story that introduced the change. | Finish the current automation ticket. |
| CI infrastructure / environment | Stabilise the runner, device, or network; rerun cleanly. | Finish after a clean run. |
| Test data or app state | Fix data setup or test code inline. | Return to in progress. |

## Flakiness, test data, and environment

- **Flakiness:** replace fixed sleeps with explicit waits on observable state;
  isolate tests; quarantine and track flaky tests instead of silently
  retrying; record flake history as a return-to-manual signal.
- **Test data:** deterministic, isolated, and resettable per run; created via
  seams or API rather than shared accounts; no real personal data; clean up
  after the run.
- **Environment:** name the environment and build under test, OS versions,
  device models, network conditions, feature flags, and locale/time zone.
  Note what differs between local and CI runs.

## Traceability minimum

- Preserve the original and updated manual baselines.
- Link manual case, story/requirement, automation ticket, code, and CI
  evidence both ways.
- Distinguish full, partial, presence-only, manual-only, and non-automatable
  coverage honestly.
- Identify shared actions/locators and re-run dependents after changing them.
- Keep source links, timestamps, commit SHAs, and human approvals reviewable.
