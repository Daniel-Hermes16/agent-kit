---
name: regression-impact-selector
description: >
  Work out what needs re-testing after a change: follow an implementation
  pull request, a commit range, or a ticket to every product area it can
  reach, then propose a re-test set with reasons plus an explicit list of
  what will not be re-tested and the residual risk of skipping it. Use when
  someone asks which regression testing a change needs, what it might break,
  which existing cases a release candidate should get, or how to fit
  regression into limited time. Typical triggers: "blast radius", "what should
  I re-test", "impact analysis", "what does this change affect", "we only have
  a day of regression", "scope the regression", or "which test cases for
  this RC".
---

# Regression Impact Selector

You support a QA specialist or QA lead. Your output is a **draft** re-test
proposal that a human reviews. What you are really delivering is a selection
decision someone can defend: which areas get re-tested, which are skipped, and
what risk the skipped ones carry.

Treat the not-re-tested list with the same weight as the re-test list. If the
residual risk is never written down, nothing was decided — something was just
left out.

The starting point here is **what changed**: the diff and the code that
consumes it. For deciding *how much* depth an area deserves based on product
and user risk, use
[`risk-based-test-prioritizer`](../risk-based-test-prioritizer/SKILL.md). The
two fit together: this skill identifies the affected areas, and the
prioritizer decides how hard to test each one.

## Required references

Read these first:

- [`PERSONA.md`](../../PERSONA.md) — QA mindset and how to prioritize.
- [`AGENTS.md`](../../AGENTS.md), in particular
  [Evidence rules](../../AGENTS.md#evidence-rules),
  [External tool access and secrets](../../AGENTS.md#external-tool-access-and-secrets),
  and [Safety boundaries](../../AGENTS.md#safety-boundaries).
- [`evidence-context`](../evidence-context/SKILL.md) — read-only retrieval,
  pinning code claims to a commit SHA, and the `Fact` / `Inference` /
  `Conflict` / `Gap` labels.
- [`references/output-template.md`](references/output-template.md).
- [`PROJECT-CONTEXT.md`](../../PROJECT-CONTEXT.md) if present, for
  architecture, module names, platforms, and test locations. If it is missing,
  carry on and ask only for facts the analysis cannot proceed without.

## When to run

- A release candidate needs a regression pass with a defined scope.
- An implementation PR for a ticket has merged and nobody is sure how far its
  effects reach.
- Regression time is short and the choice of what to run has to be justified.
- Something shared changed: a common component, a navigation container, or a
  shared resource.
- Before merging a change in a personal project, you want to know which flows
  to click through before trusting it.

## Inputs

- A ticket key, an implementation PR, a commit range, or any mix of these.
- The time available for regression (hours or person-days), if limited.
- Which platform(s) and build are in scope.
- Known constraints, such as limited devices, blocked areas, missing test
  data, or people being away.

### Stop conditions

- **No change set can be resolved** (no PR, no commit range, and no ticket
  pointing to one): ask for it once. A ticket summary on its own is not a
  basis for a blast radius.
- **The repository cannot be read**: say so and list what you attempted. You
  may offer a *preliminary* analysis from the ticket only, clearly marked as
  unverified.
- **Platform or build is unknown** and it matters (say, the change lives only
  in the iOS module): ask once. If no answer comes, proceed on a stated
  assumption and log it as a `Gap`.

## Tools

Use what the environment offers, always read-only. For example:

- Source control (shown with GitHub; GitLab and Bitbucket CLIs work the same
  way):
  - `gh pr view <n> --repo <owner/repo> --json files,additions,deletions,title,mergeCommit`
  - `gh pr diff <n> --repo <owner/repo>` to see the changed hunks
  - `gh search prs --repo <owner/repo> "<PROJ-123>"` to locate a PR from a
    ticket key
  - `git diff --stat <base>..<head>` and `git log --oneline <base>..<head>`
    for a local range
- Code search in a local clone checked out at a known commit (see
  [`evidence-context`](../evidence-context/SKILL.md)): `grep -rl`, `rg`, or
  the IDE's "find usages".
- A test-management tool — TestRail, Xray, Zephyr, a spreadsheet, or a folder
  of Markdown cases — to link areas to existing cases. Many test-management
  APIs require a project or suite filter on list calls, and some return an
  object wrapping the results instead of a plain list. Inspect the response
  shape before you decide there are "no cases".
- An issue tracker (Jira, GitHub Issues, Linear, and so on), queried with
  bounded searches for related tickets and recent fixes.

## Workflow

1. **Pin down the change set.** If only a ticket key was given, find its PR.
   Write down the PR number or commit range, the merge commit SHA, and how
   many files changed, so anyone can reproduce the analysis.
2. **Put each changed path in exactly one class:**
   - `Feature-local` — confined to the new feature's own module.
   - `Shared component` — also used by other features.
   - `Navigation or container` — changes how other screens or routes are
     shown.
   - `Shared resource` — strings, localization, images, themes, styles, build
     or lint settings, dependency versions, feature flags.
   - `Data or contract` — database schema, migrations, persisted models, API
     request or response shapes, serialization.
   - `Test-only` — tests and snapshots, with no effect on production.
3. **Work out the blast radius.** For every path that is not feature-local,
   find which other features use it. Search the code instead of guessing, for
   example
   `grep -rl "<SharedComponentName>" --include=*.kt --include=*.swift --include=*.ts`,
   and note the commit you searched. A dependency upgrade or a migration
   touches everything that uses that library or table.
4. **Rank every affected area** as `High`, `Medium`, or `Low`, weighing how
   likely it is to break against how much users would feel it. Each rank must
   cite the **specific change** behind it; generic reasons do not count. If a
   three-level rank is too coarse to set test depth, pass the area list to
   [`risk-based-test-prioritizer`](../risk-based-test-prioritizer/SKILL.md).
5. **Link areas to existing cases** by ID or file path. If an affected area has
   no case, log it as a coverage gap and suggest a brief exploratory charter;
   do not make up a case ID.
6. **Fit the time budget.** If there is a budget, fill it starting from the
   highest rank, and say clearly where you drew the line and why.
7. **List what is not re-tested.** Name each area you chose to exclude, with a
   one-line residual risk. No affected area may quietly disappear.
8. **Check the automation offset.** Find out whether automated tests already
   cover any area and confirm they really run. A ticket asking for automation
   is not coverage. A skipped or quarantined test is not coverage. Verify CI
   status instead of assuming it: pipelines can be red or switched off for
   infrastructure reasons unrelated to the code.
9. **Do the self-check** below, then **hand over the draft and stop.** The
   human owner (you) makes the selection decision.

## Risk and security flag review

When retrieved tickets have risk, security, privacy, or data-impact fields or
labels, check them for consistency (read-only) and add the outcome to the
output:

- Hold the recorded answers up against the ticket's real scope and its linked
  implementation. Every alert must quote the ticket's own evidence.
- For every ticket that changes something, assess **both** product/user risk
  and security/privacy, and report the result of each. Security-relevant work
  — cryptography, device pairing, authentication and sessions, logging of
  identifiers, new endpoints, third-party SDKs, permissions — is seldom
  described in user-facing terms, so looking only at visible behavior will
  miss it.
- Raise an alert for a **conflict**, not merely for a missing value. Most
  tickets have no assessment at all, and flagging every blank field is just
  noise.
- Do not change these fields. Send a suspected gap to the flag's owner (in a
  personal project, that is you).

## Output format

Follow [`references/output-template.md`](references/output-template.md), in
this order: change set summary; changed-path classification table;
blast-radius table with ranks and reasons; proposed re-test set mapped to
cases; explicitly not re-tested, with residual risk; coverage gaps; automation
offset; the time-budget line; risk and security flag review (if relevant);
evidence gaps.

## Self-check before delivering

- [ ] Each changed path has a class, and the commit SHA is written down.
- [ ] Each affected area sits in exactly one of the two tables, re-test or
      not-re-tested, checked in both directions.
- [ ] Each `High` rank cites the concrete change behind it.
- [ ] Each case ID or path quoted was really retrieved; missing ones read
      `no case — exploratory`.
- [ ] Automation counts only where a recent run has been confirmed.
- [ ] If a budget was supplied, the budget line is stated.
- [ ] Anything derived from code is labeled `Inference`, not presented as
      observed behavior.

## Guardrails

- Access to source control, test management, and the tracker stays read-only.
- Do not say a test case exists unless you cite its ID or path.
- A CI badge, green or red, is not coverage until you have confirmed the
  pipeline ran the relevant tests.
- The selection is input for a person to decide on; never present it as
  approval to ship.
- A diff does not tell you how the software behaves at runtime. A changed file
  signals risk, not a bug.

## Anti-patterns

- Answering "run the full regression suite" — that dodges the very selection
  this skill is meant to make.
- Leaving out the not-re-tested list, or leaving its residual risk blank.
- Marking an area `High` without pointing at the change that warrants it.
- Treating an automation ticket, a skipped test, a snapshot of some unrelated
  state, or a failing pipeline as coverage that works.
- Waving off `Shared resource` changes (strings, themes, a dependency upgrade)
  as "only cosmetic" — localization, theme, and library changes can reach
  every screen.
- Waving off `Data or contract` changes because the UI is unchanged — existing
  data, older app versions, and other clients must still be able to read it.
- Filling a coverage gap with an invented case ID instead of recording the gap.
