# Revision and follow-up context rules

Apply this file whenever an existing case has to absorb reviewer comments or
anything that turns up afterwards: another recording, a fact that was wrong, a
new constraint or edge case, or a "remember this" note.

## Input state

- The baseline is whichever comes first: a case the user pastes in, or the
  latest relevant case produced earlier in this conversation.
- Do not hold back a requested proposal because feedback might come later.
  Draft now; revise when the user's own or a colleague's comments arrive.
- When the original and the new material show up in the same message, list the
  inputs and do the revision straight away.
- Only pause when the user says outright that feedback is coming. In every
  other case, answer the request as asked and do not insert a feedback-intake
  step.
- New material with no recognisable baseline in this conversation means you
  ask the user to paste the case they want revised.
- The baseline lives in this conversation only. Do not suggest it has been
  saved anywhere, and do not push it to the tracker, test-management tool,
  wiki, or repository unless the user asks for that explicitly.

## Reconstructing loosely formatted cases

1. Anything stated before the first executable action is setup and belongs in
   Preconditions — for example install, sign-in, a paired device, granted
   permissions, test data, simulator or emulator settings, and records that
   already exist.
2. A bare integer followed by text usually opens a new step. Step 1 is often
   unnumbered; infer it from the jump to Step 2 only if the sequence of actions
   and results leaves no doubt.
3. Imperative verbs (`Navigate`, `Tap`, `Select`, `Trigger`, `Revoke`, `Wait`,
   `Kill`, `Re-open`, and similar) go into the Step Description.
4. Phrases that describe a visible state (`is displayed`, `opens`, `remains`,
   `is enabled`, `is removed`, `transitions`, and similar) go into the Step
   Result.
5. Several closely linked actions may share one description if together they
   lead to a single observable outcome. Use separate rows when an in-between
   result needs checking before the tester moves on.
6. If you cannot tell action from result without making up the order of
   events or the expected behavior, ask.

## Applying additions

- Split multi-part comments and new evidence into points that can each be
  checked on their own.
- Tag every point as `Evidence`, `Constraint`, `Preference`, or `Feedback`.
  Evidence may change what the case is grounded on; a preference only changes
  presentation or emphasis and never overrides an approved oracle.
- Tie each point to the exact place(s) it touches: title, source or platform,
  a precondition, a step description, a step result, the order of steps, or a
  dropdown.
- Leave untouched wording alone, including the author's shorthand and domain
  vocabulary.
- Fix clear typos, encoding glitches, and formatting slips only where the
  meaning stays the same; reproduce intentional UI copy character for
  character.
- Carry every change — added, removed, or reordered actions, changed expected
  results, narrowed or widened scope — through the whole case, and strip out
  wording the feedback has made stale or contradictory.
- After adding, removing, merging, or splitting rows, renumber them.
- Keep the Test Case ID and every step number that did not need to move. If the
  sequence changed, state how old step numbers map to new ones in the
  acknowledgement.
- The revised case stays compact. It must not grow into a checklist or pick up
  regression ideas that neither the baseline nor the additions back up.
- For a recording that arrives later, follow `video-evidence.md`, cite the
  timestamps that matter, and check it against the sources the baseline
  already relied on.

## Revision acknowledgement

- Put `**QA feedback integrated:**` above the revised case when every point
  is reviewer feedback; switch to `**Additional context integrated:**` when
  the additions go beyond that. Write one short bullet per point.
- Say what changed; do not reproduce long stretches of the reviewer's words.
- Only list a point as integrated if the revised case actually shows it.
- Name any point that conflicts or is on hold, rather than quietly letting it
  displace evidence with more authority.
- When a point cannot be worked in safely, ask about it before you produce the
  revision; do not hand over a partial result dressed up as final.

### Example acknowledgement

```markdown
**QA feedback integrated:**

- Precondition wording on today's status → TC-DRAFT-01 Preconditions now
  state the habit has not been marked done today.
- Combine the old Steps 2 and 3 → merged into Step 2; former Step 4 renumbered
  to Step 3.
- Verify the streak resets at midnight → on hold: no source gives a reset
  time; logged under Evidence gaps as `Clarification recommended`.
```

## Final verification

- Each addition shows up exactly once in the acknowledgement.
- Each acknowledged point has a matching change in the case.
- Each numbered row has a Step Description and a Step Result.
- Bold is used sparingly on key elements, and any pipe character that is part
  of literal UI text is escaped inside Markdown tables.
- The two dropdowns are still the last thing in the output.
- Each addition names the stable case ID or the step it affects, and no new
  open oracle has slipped in unannounced.
