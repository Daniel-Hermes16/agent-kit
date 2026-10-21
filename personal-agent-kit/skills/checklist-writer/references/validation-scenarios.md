# Skill validation scenarios

Forward-test the skill with these prompts after any material revision. Give
the test agent the raw ticket material only; keep the expected invariants to
yourself so they cannot steer the answer. Every app below is made up.

## 1. Profile-dependent UI copy

Prompt: For an Android info screen in a habit-tracking app, write a checklist
and one manual test case. The screen has three user-profile variants and
localized text, and the table of numeric ranges it should show is missing.

Expected invariants: the missing oracle is spotted; each profile gets its own
mapping; semantic, visual, and automation checks are kept apart; the combined
output appears once, not twice.

## 2. Status-message priority

Prompt: Write a checklist for the sync banner in a recipe app. The banner goes
from "Syncing" to a short-lived error and then to "Subscription expired",
while the user switches notification permission on and off and loses
connectivity.

Expected invariants: the priority order is taken from a source, or else
reported as a gap; both displacement and recovery are checked; critical checks
stay in the visible body; emulator evidence is kept separate from real-device
evidence.

## 3. Local notification replacement

Prompt: Suggest test cases for a background notification in a budgeting app.
The new notification should replace an earlier spending-limit notification,
and tapping it should open the app.

Expected invariants: permissions and app state are set up first; replacement
and removal-on-tap are both covered; no claim is made about how the OS renders
the notification unless evidence supports it.

## 4. Calculation boundary

Prompt: Suggest cases for a weekly average that is only shown once there are
enough entries spread over a long enough period, viewed in Day, Week, and
Month modes.

Expected invariants: the threshold and the value just under it are both
tested; fixture names are kept exactly; each window is handled on its own; the
average is re-checked after a profile or unit change.

## 5. Conflicting platform evidence

Prompt: Write a checklist for a ticket whose component and summary say
Android, whose description talks about iOS, and whose linked automation ticket
claims both.

Expected invariants: the conflict is reported; parity between platforms is not
assumed; the answer says whether drafting, execution, or neither is blocked;
only the one human decision actually needed is requested.

## 6. Linked implementation PR diverges from AC

Prompt: From a ticket and the PR linked to it, produce a checklist, an
exploratory charter, and a manual test case. The AC says the user can retry
after a recoverable backend error, but the PR deletes the retry path and
introduces a timeout nobody documented.

Expected invariants: the PR ID and revision are cited; only the relevant
diffs, tests, checks, and review threads are read; the missing retry is
reported as a conflict; the new timeout is an inference awaiting
confirmation; error, timeout, and recovery each get targeted coverage; the
implementation is never used as the approved oracle and the PR is left
untouched.

## 7. Risk-signal pass on a "technical-only" ticket

Prompt: Write a checklist for a story called "Move auth token to secure
storage" whose security fields in the tracker are recorded as "All answered
No".

Expected invariants: both passes run; the security pass raises a
scope-disagreement alert that quotes the ticket's own wording; the field is
not edited; the outcome of the product-risk pass is stated explicitly.
