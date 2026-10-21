# Checklist output template

A checklist always uses the top-level order below. Swap every bracketed
instruction for content specific to the ticket; none may survive into the
final draft.

```markdown
--- Exploratory testing
* <Three to five exploratory ideas aimed at this ticket's risks>

Implementation PR evidence: <owner/repository#PR, head SHA or last update, the paths/checks that matter, any conflicts; drop this line if no PR was read>

## 1. Generic checklist checks
* **Applicable —** Localized strings are complete in the translation tool and linked from the ticket
* **Needs evidence —** No confirmation yet that UX/design review is done
* **Not applicable —** <baseline item, plus the evidence that rules it out>

--- RC-TESTING
* Ask which merge conflicts were resolved for this change and re-test those areas on the release build
* Re-test the bugs that this ticket fixed
* If no integration run happens, test the merged result of this ticket directly

## 2. Acceptance Criteria Coverage Test Cases
* Verify that <observable behavior and its expected result>. (Traceability: <AC or requirement ID>; Platform: <Android/iOS/Web>)

## 3. Expected Edge Case Test Cases
* Verify that <interruption or recovery behavior that matters here>. (Traceability: <AC or requirement ID>; Platform: <Android/iOS/Web>)

## 4. Optional Edge Case Test Cases
* Verify that <extreme or unusual behavior that matters here>. (Traceability: <AC or requirement ID>; Platform: <Android/iOS/Web>)

## 5. Proposed Manual Test Cases for Verification Evidence
### Test Case ID: TC-<ticket number>-01
### <Test Case Title>
Traceability: <ticket key; AC or requirement IDs>
Preconditions: <only if the case needs any>
Steps:
- <One short action>
- <One short action>
Expected Result: <What the tester can observe on success>

<details><summary>Constraints and human decisions</summary>

<Privacy, security, legal or licensing points, sensitive claims, environment evidence (simulator vs. real device), definition of done, and decisions reserved for the human owner.>

</details>

<details><summary>Automation references</summary>

<How far automation has got, feasibility label, stable IDs still needed, CI evidence, where manual work remains, and gaps.>

</details>
```

For a checklist-only request, Section 5 can be a single pointer line such as
`* Not requested — see Sections 2–4.`

## Required generic baseline

All twenty items stay in every checklist, each tagged `Applicable`,
`Not applicable`, or `Needs evidence`:

1. Localized strings are complete in the translation tool and linked from the
   ticket.
2. UX/design review is done.
3. Side effects on other areas of the app have been assessed.
4. Behavior without a network connection is checked.
5. If the change touched unit or currency conversion (metric vs. imperial,
   currency rounding, and similar), the developer has been consulted.
6. Layout holds up with larger font sizes and bold text turned on.
7. Pasting special characters — emoji, right-to-left text, very long
   strings — into input fields.
8. Android UI under both gesture navigation and 3-button navigation.
9. Back gesture or swipe-back on each relevant platform (the browser back
   button on web).
10. State survives backgrounding and a restart of the app process.
11. Backend errors, slow connections, and timeouts.
12. OS permissions or system settings changed in the middle of a flow
    (notifications, location, camera, Bluetooth).
13. Inputs that are invalid, empty/null, on a boundary, or extreme.
14. Automatic timeouts and expired sessions.
15. Which in-app message, banner, or notification wins when several compete.
16. What persists across logout and login.
17. Formatting of decimals, dates, times, units, and regional settings.
18. Changing the device clock or time zone.
19. Large amounts of historical data.
20. Dark mode and light mode.

A project can extend this list in
[`../../../PROJECT-CONTEXT.md`](../../../PROJECT-CONTEXT.md). It can never
remove any of the twenty.

## Rendering rules

- Give three to five exploratory bullets.
- Keep all three RC baseline items; add gates for the issue type where they
  apply.
- Every scenario line in Sections 2–4 begins with a literal `*`.
- Section 2 gets one bullet for each AC outcome that can be observed on its
  own.
- Add only edge cases that matter for this ticket. When there are none, write
  `* None identified from the supplied evidence.` and be ready to justify it.
- Make evidence conflicts and oracle gaps (blocking or not) visible in the
  body.
- If a PR was read, cite its ID and revision, and tie every risk it revealed
  to a scenario, a conflict, or an evidence gap.
- When formal test-case tables are wanted, switch to the
  [combined-output contract](combined-output.md).
- The constraints dropdown and then the automation dropdown close the
  output. If either has no content, use its fallback sentence verbatim:
  `No additional constraints or human decisions identified from the available evidence`
  or `No additional automation references identified from the available evidence`.
