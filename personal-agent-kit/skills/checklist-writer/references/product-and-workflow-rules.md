# Product and workflow rules

This is the baseline from which the relevant verification checks are drawn.
Product-specific facts belong in the optional, user-maintained
[`../../../PROJECT-CONTEXT.md`](../../../PROJECT-CONTEXT.md). Before relying on
a claim that matters, check it against the current ticket, the approved
requirements, the design, and what the application actually does. When
sources disagree or cannot be reached, log that as a gap.

## Product context

If `PROJECT-CONTEXT.md` exists, take these from it:

- what the product is, who its users are, and the outcomes they care about
  most;
- the supported platforms and the lowest OS / browser versions supported;
- the main screens or areas, and which of them are still in progress (never
  assume finished behavior for an in-progress area);
- the connected devices, integrations, or backends the app relies on;
- the units, currencies, locales, and formats the app handles;
- any project-specific items added on top of the 20-item generic baseline.

Without the file, work from the ticket and ask only for facts a scenario
cannot be written without (for example "which OS versions are in scope?").

## Priority-ordered messages (cards, banners, notifications)

Plenty of apps display no more than one status message from a group at once
— think "offline", "sync failed", "subscription expired", "permission
revoked". If the ticket or `PROJECT-CONTEXT.md` defines a group like this:

- Note the priority order, with its source, before you start drafting.
- Check transitions both ways: a higher-priority message replaces a lower
  one, and once the higher one clears, the replaced message comes back (or
  stays hidden) exactly as the source specifies.
- Make sure a replaced message is never shown alongside the one that
  replaced it.
- Check that sticky high-priority states (an expired account, say) keep
  precedence when lower-priority changes happen later, such as losing
  connectivity or toggling a permission.
- Check periodic re-checks only if the source gives the interval.

Never make up timing, dismissal behavior, copy, persistence, or order. If the
order is not defined, record a `Gap`.

## Ticket workflow tailoring

| Issue type | Required emphasis |
| --- | --- |
| Story / Improvement | Design/UX review, a four-eye peer review, and sign-off by the product owner, all before a release candidate is chosen |
| Technical improvement | Safety of existing behavior, impact across the system, and changes to third-party libraries or other dependencies; design review only if the UI is affected |
| Task / Sub-task | The non-code deliverables and the AC; leave out branch and code-review steps |
| UI automation | BDD scenarios (Gherkin, for instance), stable accessibility/test IDs, and a run of consecutive green CI builds sized to the team's tolerance for flakiness |

Tailor this table to your team's real workflow in `PROJECT-CONTEXT.md`.

## Evidence boundaries

- When the target is a combination of platforms, validate each one on its
  own.
- If release evidence calls for it, test on real devices representative of
  the release.
- Keep demo mode, mocked backends, emulators, and simulators — handy for quick
  checks during the sprint — separate from evidence that is valid for a
  release.
- Product context supplied by the user is background only; it does not stand
  in for the current approved requirements.
