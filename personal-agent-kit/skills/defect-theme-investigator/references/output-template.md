# Theme investigation output template

```markdown
# <Product> — <Theme>: Issue Inventory and Coverage

**Scope:** <what this covers and what it leaves out>
**Sources searched:** <tracker projects / repositories, docs spaces, test suites, date window>
**Generated:** <YYYY-MM-DD> — draft, awaiting human review

## Direct answer to the question

<Answer the original question plainly in two to five sentences. The
conclusion comes first; the evidence for it follows in later sections.>

## How the product behaves — scenarios

### Scenario A — <distinct sub-behavior>

<What was observed or what is specified, with sources; say which is which.>

### Scenario B — <distinct sub-behavior>

<Held apart from Scenario A because its behavior differs.>

## Search passes

| # | Query | Window | Hits |
| ---: | --- | --- | ---: |
| 1 | <query exactly as executed> | <dates> | <n> |

## 1. Direct — this theme in this product

| Key | Type | Status | Scenario | Relevance |
| --- | --- | --- | --- | --- |
| <KEY> | <Bug / Story / Task> | <status> | <A / B> | <one-line reason> |

## 2. Adjacent — shared components or related behavior

| Key | Type | Status | Relevance |
| --- | --- | --- | --- |

## 3. Precedent — other products, older versions, or legacy apps

| Key | Type | Status | What it tells us |
| --- | --- | --- | --- |

## Excluded hits

| Key | Why excluded |
| --- | --- |

## Specification coverage

Add a separate table for each product area affected.

### Table 1 — <area, e.g. Daily reminders>

| Behavior | Scenario | Governing story / requirement | Specification status | Coverage gap |
| --- | --- | --- | --- | --- |
| <behavior> | <A / B> | <KEY, requirement ID, or "none found"> | <Specified / Partially specified / Unspecified / Contradictory> | <gap description> |

## Existing test coverage

| Scenario | Test case(s) | Status |
| --- | --- | --- |
| <scenario> | <case ID, path, or "no coverage found"> | <Covered / Partial / None> |

## Key takeaways for the risk discussion

**Established:**

- <A fact, with its source.>

**Open — requires a decision:**

- <Open point> — decides: <role, or "you">

## Risk and security flag review

<Include only if the retrieved tickets have such fields.>

## Evidence gaps

- **<Blocking / Non-blocking / Clarification recommended>:** <the missing item and what it affects>
```

## Rendering rules

- Open with the conclusion so the reader never has to work it out.
- Each table row cites its source, or says outright that none was found.
- Scenarios stay apart from start to finish; do not merge them to save space.
- Each retrieved hit goes into one inventory group or into `Excluded hits`.
- Source titles are quoted exactly; your own prose uses the product's current
  name.
- Every classification rests on evidence; say so when a status could not be
  confirmed.
- Show keys as clickable Markdown links whenever a URL is known.
