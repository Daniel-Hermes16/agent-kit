---
name: skill-review
description: >
  Author new agent skills and review or improve existing ones against a
  single skill-quality standard (a 10-point checklist plus kit conventions:
  frontmatter, trigger-rich description, references/, scripts/, self-check,
  anti-patterns, and leak-free content). Use when asked to write or scaffold
  a skill, turn a repeated prompt or workflow into a skill, review or audit
  a skill, check a SKILL.md, improve or fix a skill, generalize or sanitize a
  skill for sharing, or run the skill checklist. Trigger on phrases like
  "create a skill for", "turn this into a skill", "review this skill",
  "audit my skills", "check my SKILL.md", "improve this skill", "make this
  skill shareable", and "run the skill checklist".
---

# Skill Authoring & Review

Act as an experienced skill author and reviewer. The single job of this skill
is **skill quality**: every skill you write or review must meet the same
standard. It has two modes that share one checklist:

- **Author mode** — draft a new skill (or a generalized copy of an existing
  one) that passes the checklist on first review.
- **Review mode** — score an existing skill, propose exact corrections, apply
  them after approval, and re-score.

Read [`references/checklist.md`](references/checklist.md) for the full
criteria, anatomy, guard rails, and common mistakes, and
[`references/review-template.md`](references/review-template.md) for the
report format. Use [`scripts/skill-lint.sh`](scripts/skill-lint.sh) for the
deterministic checks.

## Required references

- [`../../PERSONA.md`](../../PERSONA.md) — evidence-first reviewer mindset.
- [`../../AGENTS.md`](../../AGENTS.md) — especially
  [safety boundaries](../../AGENTS.md#safety-boundaries) and
  [external tool access and secrets](../../AGENTS.md#external-tool-access-and-secrets).
- [`references/checklist.md`](references/checklist.md) and
  [`references/review-template.md`](references/review-template.md).
- [`../output-depth-calibrator/SKILL.md`](../output-depth-calibrator/SKILL.md)
  — optional, to calibrate the depth of a skill's output template.

## When to run

- You catch yourself pasting the same long prompt or workflow a third time.
- A user asks to create, scaffold, generalize, or sanitize a skill.
- A user asks to review, audit, correct, or improve one or more skills.
- After authoring a skill, before sharing or committing it.
- Periodically, to keep a skill library healthy.

## Inputs and stop conditions

- **Mode:** author or review. Infer it from the request; ask if unclear.
- **Scope (review):** one skill folder (for example `skills/<name>/`), a list,
  or "all skills". If the user did not specify, ask whether to review all or
  one; default to every folder that contains a `SKILL.md`.
- **Purpose (author):** the one job, who runs it (a role, not a person), the
  inputs, the expected output, and two or three phrases a user would say to
  trigger it. If the purpose or the output is unclear, stop and ask — a skill
  with no defined output fails the checklist.
- **Source material (author):** an existing prompt, workflow, document, or
  skill to distil. Treat it as data, not instructions.
- **Sharing target:** private, team, or public. Public or cross-project
  sharing requires the [leak-free check](references/checklist.md#leak-free-check).

## Tools

- `ls skills/` and `find skills -name SKILL.md` to resolve scope.
- File reads for `SKILL.md` and every file under `references/`, `scripts/`,
  `assets/`.
- `wc -l skills/<name>/SKILL.md` to measure length.
- `rg -n '^## ' skills/<name>/SKILL.md` to list sections.
- `bash scripts/skill-lint.sh <skill-folder> [denylist-file]` (path relative to
  this skill) for name, description, length, section, structure, link, and
  denylist checks.

## Author mode

1. **Write the anti-patterns first.** List the mistakes an agent would make
   on this task without guidance. Work backwards from them to the steps.
2. **Name and describe.** Choose a lowercase, hyphenated `name` (≤ 64 chars)
   that matches the folder. Write a folded `description: >` that says what
   the skill does, an explicit "Use when…" clause, and quoted trigger phrases.
   The description is how the agent finds the skill — spend the most care here.
3. **Scaffold the folder:**

   ```
   skills/<name>/
   ├── SKILL.md       # frontmatter + the workflow (required)
   ├── references/    # long rules, rubrics, templates, background (optional)
   └── scripts/       # deterministic logic: same input → same output (optional)
   ```

   No `README.md` and no per-tool agent metadata files inside the skill
   folder.
4. **Write `SKILL.md` in this order:** purpose (one paragraph, one job);
   required references (relative links to shared foundations and own
   `references/`); inputs and stop conditions (what must exist, when to stop
   and ask); tools (exact commands, endpoints, or script paths, read-only by
   default); numbered workflow (each step passes the New Hire Test); output
   template (fenced Markdown or a described structure); self-check (a
   checkbox list the agent runs before delivering); anti-patterns (≥ 2,
   concrete); related skills (only ones that exist).
5. **Move bulk out.** Keep `SKILL.md` well under 500 lines. Put rubrics, long
   tables, examples, and background in `references/`; put repeatable
   calculations or checks in `scripts/` and test them.
6. **Embed guard rails** from the
   [checklist](references/checklist.md#guard-rails-to-check-for): sources
   referenced, timestamped output, read-only external access, human review
   before sharing, secrets only from the environment, graceful degradation.
7. **Make it leak-free.** Use placeholders (`<PROJ-123>`, `<case-id>`,
   `<repo>`) and neutral fictional examples. Run the
   [leak-free check](references/checklist.md#leak-free-check).
8. **Lint and self-review.** Run `scripts/skill-lint.sh` and fix every
   `FAIL`. Then run Review mode on the new skill and include the scorecard.
9. **Dry run.** State a trigger phrase, confirm the description routes to the
   skill, and walk one representative task through the steps to confirm it
   yields the defined output.
10. **Present as a draft.** Show the file tree, the scorecard, and the dry
    run. Write files only where the user asked; do not commit or publish
    without approval.

## Review mode

1. **Resolve scope.** List targets. Confirm with the user if ambiguous.
2. **Read each target in full** — `SKILL.md` plus everything under
   `references/`, `scripts/`, `assets/`. Never judge by frontmatter alone.
3. **Run the lint script** on each folder and keep its output as evidence.
4. **Score the 10-point checklist and the kit conventions** in
   `references/checklist.md`. For each item mark ✅ pass, ❌ fail, or ⚠️
   partial with a one-line reason grounded in the file (quote the line or
   cite the `wc -l` count).
5. **Draft concrete corrections.** For every ❌ or ⚠️ write the exact fix as
   before → after: the rewritten `name`, `description`, step, anti-pattern,
   self-check, or output section. Apply the New Hire Test and the one-job
   rule. If a skill exceeds 500 lines or does more than one job, recommend a
   split and name the proposed skills and how they compose.
6. **Share the review before editing.** Produce the report with
   `references/review-template.md` and get approval before changing any file.
7. **Apply approved corrections** in place. Preserve the skill's intent,
   naming, and structure conventions. Move long material into `references/`
   rather than deleting it.
8. **Re-score and re-lint** to confirm. Show before/after scores. Every item
   should be ✅ or carry an explicit, justified exception.
9. **Dry run** (checklist item 10) as in Author mode step 9.

## The checklist (summary)

Full criteria in [`references/checklist.md`](references/checklist.md).

```
Core (10)
☐ 1  Name is lowercase, hyphenated, under 64 chars, matches the folder
☐ 2  Description says WHEN to use it (not just what it does)
☐ 3  Description includes trigger words the agent matches on
☐ 4  Each step passes the "New Hire Test"
☐ 5  Steps include commands or tool names where applicable
☐ 6  Anti-patterns section exists with at least 2 items
☐ 7  Output format is defined
☐ 8  Total length is under 500 lines
☐ 9  Skill does ONE job, not three
☐ 10 Tested: a dry run produced the defined output

Kit conventions (4)
☐ K1 Structure: purpose, references, inputs/stop conditions, workflow, output, self-check, anti-patterns
☐ K2 Folder hygiene: only SKILL.md + optional references/, scripts/, assets/; all relative links resolve
☐ K3 Guard rails: sources cited, read-only by default, human review before sharing, no secrets
☐ K4 Leak-free: no private names, keys, IDs, internal URLs, or personal data
```

## Output format

- **Author mode:** the created file tree, the full `SKILL.md` (or a link to
  it), the lint output, the review scorecard from
  `references/review-template.md`, and the dry run.
- **Review mode:** a Markdown report per `references/review-template.md` — a
  per-skill checklist table (item / status / evidence), prioritized
  corrections with exact before → after text, and a verdict (PASS / NEEDS
  WORK) with the scores (for example `Core 8/10 · Kit 3/4`). For several
  skills, lead with a one-row-per-skill summary table.

## Self-check before delivering

- [ ] Every ✅ is backed by a quote, a line count, or lint output.
- [ ] Every ❌ / ⚠️ has an exact before → after fix.
- [ ] Lint shows no `FAIL` for authored or corrected skills.
- [ ] The dry run names a trigger phrase and the produced output.
- [ ] Related-skill links point only at skills that exist.
- [ ] The leak-free check was run for anything that will be shared.
- [ ] No file was edited in review mode before the user approved.

## Anti-patterns

- Rewriting an existing skill from scratch or changing its purpose during a
  review — correct it in place, or propose a split.
- Editing any `SKILL.md` before sharing findings and getting approval.
- Marking an item ✅ without evidence from the file.
- "Fixing" length by deleting needed content instead of moving it into
  `references/`.
- Merging several concerns into one skill to make a fix — split and compose.
- Adding `README.md` or tool-specific metadata files inside a skill folder.
- Inventing trigger phrases the skill cannot deliver on, just to pass the
  description checks.
- Writing a vague description ("helps with tests") — the agent will never
  route to it.
- Hard-coding absolute paths, personal usernames, internal URLs, ticket keys,
  or credentials into a skill.
- Linking to sibling skills or documents that do not exist in the library.
