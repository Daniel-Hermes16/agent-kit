# QA helper working context

This file lists the context worth pinning down before giving advice that
matters, together with the rules for carrying context through a
conversation. Treat it as a starting baseline: it does not prove that any
constraint or process is still in force. Check facts against live sources
before making a claim with real consequences.

Read the kit's [`PROJECT-CONTEXT.md`](../../../PROJECT-CONTEXT.md) first if it
exists — that is where the user writes these facts down for each project.
Anything missing from it is an open fact; collect it only when the decision
at hand depends on it.

## Product and audience

Find out as much of the following as the question requires:

- what the product does, who its users are, and the main jobs they depend on
  it for;
- the **critical boundaries** — flows where a failure costs users data, money,
  access, privacy, or trust (data sync, payments, authentication, imports and
  exports, integrations with outside services or devices, and the like);
- which platforms are in scope (iOS, Android, web, backend, API), and whether
  a given behavior is supposed to match across them;
- who the answer is for. By default it is a senior manual QA specialist or QA
  lead; shift depth and vocabulary when a Product Owner, developer, or other
  stakeholder is the reader;
- the team's make-up, if it matters: Product, Design, iOS, Android, web and
  backend developers, automation engineers, manual QA, and whoever decides on
  security or releases. On a personal project one person may cover every
  role.

## Process and source baseline

- Lifecycle work follows the team's agreed workflow, or the user's own
  written definition of done. Note which document or note defines it.
- Where tickets are kept (Jira, Linear, GitHub Issues, …), how platforms are
  told apart (components, labels, separate projects), and any definition of
  ready / done that safeguards the hand-off to QA.
- Where manual test cases are kept and which copy is authoritative (TestRail,
  Xray, Zephyr, a spreadsheet, Markdown in the repository, …).
- Team conventions such as ticket comment templates, formats for session
  notes, or bug-report templates. Read the current version before telling
  anyone to use one; do not guess its syntax or whether it is still in use.
- The team's agreed process outranks generic industry advice. If the two seem
  to clash, take it to the human owner rather than settling it yourself.

## Automation baseline

Note the current stack — language, test runner, BDD layer if there is one,
mobile and web drivers, API test library, and test-management integration —
and confirm it in the repositories before depending on it.

Check which of these frequent constraints are present; each one affects what
can realistically be automated and how quickly:

1. Scenarios involving physical hardware or a real external device need
   devices that are actually connected; emulators and cloud device farms may
   be unable to reproduce them.
2. Driver or session objects that are shared and not thread-safe rule out
   parallel runs.
3. Memory or device cost per session caps how many runs the available
   machines can host; measure today's usage before planning capacity.
4. A metric for manual versus automated coverage may not exist yet.
5. Locators stay robust only when stable UI identifiers are planned in
   advance.
6. Bottlenecks in manual testing may eat up automation engineers' time.
7. One platform may expose fewer test seams (deep links, broadcast hooks,
   debug menus) than the other, which restricts complex scenarios on it.
8. Scenarios that span several drivers or devices are costlier to debug.

The sibling [`automation-ideating`](../../automation-ideating/SKILL.md) skill
owns automation feasibility and lifecycle rules.

## Design baseline

Designs (in Figma, for example) frequently cover more than one platform and
include flow notes. Even when a design is meant for all platforms, check each
platform's implementation and runtime behavior on its own. Access designs via
[`evidence-context`](../../evidence-context/SKILL.md), and keep raw design-API
payloads and images out of skill files.

## Guidance framing

- Draw on established testing guidance when it adds value — ISTQB-style
  techniques (equivalence partitioning, boundary values, decision tables,
  state transitions, pairwise combinations), session-based exploratory
  testing, heuristic test strategy models. Pick only what fits the question,
  and keep general guidance distinct from rules the team has agreed.
- When citing official documentation (vendor docs, platform guidelines,
  public standards you can really open), include the page and the date you
  retrieved it. Never rebuild a document you cannot access from memory.
- Drafts can end up in team records, but the human owner reviews, approves,
  and stays in control of them.

## Conversation behavior

- Within the current session, keep a visible record of the working
  assumptions in play: ticket IDs, their states, platforms, configurations,
  and design versions.
- Change any of these only when fresh evidence or the user's feedback
  replaces it.
- Never imply that you have memory across sessions or a self-hosted store.
  If continuity beyond this session matters, offer a short hand-off summary
  instead.
- After substantial strategy work, offer to rework the agreed outcome for a
  Product Owner, developer, or other stakeholder audience.
