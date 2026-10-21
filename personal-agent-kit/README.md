# Personal agent kit

A persona, a working contract, and a set of reusable skills for working with
AI coding/chat agents with a QA specialist's rigor — on personal projects,
side apps, or while learning to get more out of agents.

Everything here is generic. Add your own project facts through
`PROJECT-CONTEXT.md` instead of editing the skills.

## Contents

| Path | Purpose |
| --- | --- |
| [`PERSONA.md`](PERSONA.md) | Who the agent works with and how: mentality, rigor standards, agent-collaboration habits |
| [`AGENTS.md`](AGENTS.md) | Working contract: tool access, safety boundaries, evidence rules, skill index, definition of done |
| [`PROJECT-CONTEXT.template.md`](PROJECT-CONTEXT.template.md) | Template for per-project facts the skills read as a baseline |
| [`skills/`](skills/) | 14 skills, each a `SKILL.md` plus optional `references/` and `scripts/` |

## Skills

| Skill | Use it to |
| --- | --- |
| `evidence-context` | Gather read-only evidence first; pin code claims to a commit |
| `qa-helper` | Brainstorm and decide on quality strategy and approaches |
| `story-readiness-reviewer` | Judge whether a story is ready to build and test |
| `story-edge-case-and-test-designer` | Find AC gaps, edge cases, countermeasures, and unit/UI tests |
| `checklist-writer` | Produce a manual QA checklist |
| `test-case-creator` | Produce concise manual test cases |
| `exploratory-session-companion` | Run a chartered exploratory session end to end |
| `regression-impact-selector` | Decide what to re-test after a change |
| `risk-based-test-prioritizer` | Decide how deeply to test each area |
| `defect-report-writer` | Write a clear, reproducible bug report |
| `defect-theme-investigator` | Investigate a cross-cutting quality theme |
| `automation-ideating` | Assess automation feasibility and approach |
| `output-depth-calibrator` | Check an agent answer for depth and rigor |
| `skill-review` | Author and review skills like these |

## Getting started

1. Put this folder where your agent can read it — for example as its own git
   repository, or inside a project as a subfolder.
2. Point your agent at it:
   - **GitHub Copilot CLI / app:** keep `AGENTS.md` at the repository root;
     skills under `skills/` (or copy them to your user-level skills folder).
   - **Other agents:** most read `AGENTS.md`; otherwise paste `PERSONA.md` and
     the relevant `SKILL.md` into the system or project instructions.
3. Copy `PROJECT-CONTEXT.template.md` to `PROJECT-CONTEXT.md` and fill in what
   you know about the project you are working on.
4. Ask naturally ("review this story for readiness", "what should I re-test
   after this PR?") or name a skill explicitly (`$checklist-writer`).

## Practice ideas for learning agent work

- Run the same request with and without `evidence-context` and compare.
- Ask for an answer, then run `output-depth-calibrator` on it.
- Write a new skill for a recurring task with `skill-review`, then have a
  second agent review it.
- Use `exploratory-session-companion` on an open-source app and file a report
  with `defect-report-writer`.

## Ground rules

- External systems are read-only unless you authorize an exact change.
- No secrets in prompts, files, or history.
- Outputs are drafts; you make the decisions.
