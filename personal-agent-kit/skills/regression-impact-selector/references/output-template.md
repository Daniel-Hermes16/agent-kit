# Regression selection output template

```markdown
# Regression impact — <PROJ-123> / <owner/repo>#<PR>

**Change set:** <owner/repo>#<PR> or <base>..<head>; merged as `<sha>`; <N> files touched
**Platform / build:** <Android / iOS / web / backend>, <build>
**Time budget:** <hours or person-days; "not constrained" if none>
**Generated:** <YYYY-MM-DD> — draft, pending human review

## Changed-path classification

| Path or module | Classification | Note |
| --- | --- | --- |
| <file or module> | <Feature-local / Shared component / Navigation or container / Shared resource / Data or contract / Test-only> | <summary of the edit> |

## Blast radius

| Affected area | Why it is affected | Rank | Impact if broken |
| --- | --- | --- | --- |
| <area name> | <the concrete edit that reaches it, plus the consumer located at `<sha>`> | <High/Medium/Low> | <what the user would notice> |

## Proposed re-test set

| # | Area | Test case(s) | Rank | Est. |
| ---: | --- | --- | --- | --- |
| 1 | <area> | <case ID or path, or "no case — exploratory"> | <rank> | <estimate> |

**Budget line drawn after item <N>.** <Say what fits inside the budget and what falls outside it.>

## Explicitly NOT re-tested

| Area | Why excluded | Residual risk |
| --- | --- | --- |
| <area> | <why it was left out> | <one line: what happens if this area is in fact broken> |

## Coverage gaps

- <Affected area lacking any existing case, plus a suggested exploratory charter.>

## Automation offset

| Area | Automated? | Evidence |
| --- | --- | --- |
| <area name> | <Yes / No / Ticket only / Skipped> | <suite or test path and last confirmed run, or ticket key and status> |

> Do not count automation as coverage until you have confirmed the pipeline really executes.

## Risk and security flag review

<Include only if the retrieved tickets have such fields. Per ticket, one line
per domain: consistent / conflict (quote the evidence) / not assessed.>

## Evidence gaps

- **<Blocking / Non-blocking / Clarification recommended>:** <the missing item>
```

## Rendering rules

- Place each affected area in one table only: re-test or not-re-tested. If an
  area shows up in neither, the analysis is wrong.
- Rank rationale points at a concrete edit; generic wording is not enough.
- Cite real case IDs or paths. When none exists, write
  `no case — exploratory` instead of making one up.
- If a budget was given, say plainly where the line falls.
- Link tickets, PRs, and cases in Markdown whenever a URL is known.
- Frame the output as material for a person to decide on, not as permission to
  ship.
