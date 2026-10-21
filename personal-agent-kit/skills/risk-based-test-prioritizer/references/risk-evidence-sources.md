# Where risk evidence comes from

Risk ratings are only as good as the evidence behind them. Gather from these
sources, record each item with its source link or path and retrieval date, and
state the strength. All access is read-only.

## Source catalogue

| Source | What it tells you | Feeds | Typical strength |
| --- | --- | --- | --- |
| **Requirements and acceptance criteria** | What the area must do, which outcomes the user relies on, explicit non-functional needs (performance, offline, privacy) | Impact, oracle availability | Strong when approved and specific; weak when vague |
| **Designs and user flows** | Which paths are default, first-run, or prominent; what the user sees and acts on | Impact, exposure | Medium — shows intent, not behavior |
| **Past defects in the area** | Where things broke before, how often, how they escaped, how severe they were | Likelihood, impact | Strong — the best single predictor of future defects |
| **Incidents and production issues** | Real user consequence and detection delay | Impact, likelihood | Strong |
| **Code churn and complexity** | How often and how much the area changes; size and nesting of the logic | Likelihood, complexity modifier | Medium — signals risk, not defects |
| **The current diff** | What exactly changed and what consumes it (see `regression-impact-selector`) | Likelihood, complexity | Strong for *what changed*; silent on behavior |
| **Existing test coverage** | Which areas already have cases or automation that actually runs | Likelihood | Medium — only counts when a recent run is confirmed |
| **Usage analytics** | How many users reach the path and how often | Exposure modifier | Strong when supplied; never pull personal data yourself |
| **User feedback and support tickets** | Confusion, workarounds, misunderstandings, recurring complaints | Impact, likelihood | Medium — anecdotal but real |
| **Dependencies and integrations** | Third-party SDK or API changes, platform OS updates, library bumps, backend contract changes | Likelihood, complexity modifier | Medium to strong |
| **Team risk register or recorded ratings** | Prior, agreed ratings for the area | All | Authoritative where it exists — cite, never override |

## Useful read-only queries (examples)

Always bound tracker queries by project and date window.

```text
# Jira-style: past defects touching an area
project = <PROJ> AND issuetype = Bug AND text ~ "<area keyword>" AND created >= -365d ORDER BY created DESC

# GitHub Issues: same idea
gh issue list --repo <owner/repo> --label bug --search "<area keyword> created:>=<YYYY-MM-DD>" --state all

# Churn for a path over six months
git log --since=6.months --format= --name-only -- <path> | sort | uniq -c | sort -rn | head

# Who changed it recently and why
git log --since=3.months --oneline -- <path>
```

## Strength and labeling

- **Fact** — retrieved and cited (a ticket, a commit, a supplied analytics
  export).
- **Inference** — reasoned from facts (for example "high churn suggests
  instability"); state the basis.
- **Conflict** — two sources disagree (for example a recorded team rating is
  lower than the defect history suggests); report both, decide neither.
- **Gap** — the source was not available or returned nothing; state what was
  tried.

## Handling missing evidence

- **No past defects found** is not "low likelihood". It may mean the area is
  new, rarely used, or simply untested. Say which, or say you cannot tell.
- **No requirements** means no oracle; mark affected criteria `Unverifiable`
  instead of lowering depth.
- **No analytics** means exposure is an `Inference` from the design (default
  path or not); say so.
- **Inaccessible tool** — follow
  [External tool access and secrets](../../../AGENTS.md#external-tool-access-and-secrets)
  and make a real attempt before reporting it unavailable.

## Privacy

Never copy personal data, user identifiers, or raw support conversations into
the analysis. Summarize themes and counts instead.
