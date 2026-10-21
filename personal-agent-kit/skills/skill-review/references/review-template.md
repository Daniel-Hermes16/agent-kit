# Review report template

Use this layout for a skill review, including the self-review that follows
authoring a new skill. Back every finding with something concrete: a quoted
line, a `wc -l` count, or pasted lint output. Write one report per skill. If
several skills are under review, put the summary table first.

## Multi-skill summary (only when reviewing more than one)

| Skill | Core | Kit | Verdict | Top issue |
|-------|------|-----|---------|-----------|
| `<name>` | 7/10 | 3/4 | NEEDS WORK | Output format missing |
| `<name>` | 10/10 | 4/4 | PASS | — |

---

## Review: `<skill-name>`

**Mode:** Review / Author self-review
**File:** `skills/<skill-name>/SKILL.md` (`<N>` lines)
**Reviewed:** `<YYYY-MM-DD>`
**Verdict:** PASS / NEEDS WORK — **Core X/10 · Kit Y/4**

### Lint output

```
<output of: bash scripts/skill-lint.sh skills/<skill-name> [denylist]>
```

### Core checklist

| # | Item | Status | Evidence |
|---|------|--------|----------|
| 1 | Name: lowercase, hyphens, under 64 chars, same as folder | ✅/❌/⚠️ | `<name>` (N chars) |
| 2 | Description states WHEN to use the skill | ✅/❌/⚠️ | quote of the "Use when …" clause |
| 3 | Description carries trigger words | ✅/❌/⚠️ | quoted phrases |
| 4 | Every step survives the New Hire Test | ✅/❌/⚠️ | quote any vague step |
| 5 | Steps name commands or tools | ✅/❌/⚠️ | step number |
| 6 | Anti-patterns: two or more | ✅/❌/⚠️ | how many |
| 7 | Output format is specified | ✅/❌/⚠️ | quoted section |
| 8 | Fewer than 500 lines | ✅/❌/⚠️ | `wc -l` = N |
| 9 | Single job only | ✅/❌/⚠️ | list of jobs found |
| 10 | Dry run done | ✅/❌/⚠️ | trigger used + outcome |

### Kit conventions

| # | Item | Status | Evidence |
|---|------|--------|----------|
| K1 | Section structure; folded description | ✅/❌/⚠️ | sections present |
| K2 | Folder hygiene; relative links work | ✅/❌/⚠️ | lint result |
| K3 | Guard rails | ✅/❌/⚠️ | guard rails quoted, or the ones absent |
| K4 | Leak-free | ✅/❌/⚠️ | scan outcome |

### Proposed corrections (prioritized)

Every ❌ or ⚠️ above needs a precise edit, written as before → after.

1. **[item #] <short title>**
   - **Why:** <single line>
   - **Before:**
     ```
     <text as it is now>
     ```
   - **After:**
     ```
     <text as it should read>
     ```

2. …

### Split recommendation (only if it fails #8 or #9)

- Suggested skills: `<name-a>` (…), `<name-b>` (…)
- Composition: `<name-a>` → `<name-b>` (sequential / delegating / conditional / layered)

### Dry run (checklist item 10)

- **Trigger phrase tested:** "<something a user might actually type>"
- **Routes to this skill?** yes/no — and which description words matched
- **Walkthrough:** <a typical task traced through the steps>
- **Produced the defined output?** yes/no

### Before / after score

`Core <before>/10 · Kit <before>/4` → `Core <after>/10 · Kit <after>/4` once
the approved corrections are in.
