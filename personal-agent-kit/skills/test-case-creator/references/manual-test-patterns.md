# Manual test case patterns

Use only the patterns that fit the acceptance criteria in front of you. They
are style and coverage heuristics drawn from cases that reviewed well — they
are not requirements and they prove nothing about how the product behaves.

## Structure and wording

- Everything that has to be in place first — install, sign-in, permissions,
  data, a paired device, account state, simulator or emulator settings — goes
  above the numbered steps.
- One cluster of actions per row, with its result on the same row.
- Open every action with an imperative verb. Phrase results as visible
  changes, such as `App displays`, `User sees`, `Toggle is enabled`, or
  similarly exact wording.
- Copy file names, values, units, thresholds, time windows, ticket IDs, and
  links to companion cases exactly as the source gives them.
- Default to a single end-to-end case. Split only if a reset, a second device,
  platform-specific behavior, or a separate manual-versus-automation owner
  would make one sequence misleading.
- Give the case a stable `TC-<ticket number>-NN` ID and keep it through every
  later revision.
- When profile, unit, state, or platform variants run through identical steps,
  list them in a Test data table.
- If approved copy, values, units, boundaries, or timing are missing, record an
  oracle gap. Examples and placeholders never become expected results.

## Copy and semantic content

- Check exact approved copy and unresolved localization keys as one concern,
  and whether the guidance the copy gives is meaningful and appropriate as a
  separate one.
- Copy that promises an outcome — savings, fitness results, security
  guarantees, legal or tax advice — goes to the human owner under the shared
  sensitive-claim rule.
- Static mock text and design copy count as design evidence only. They do not
  show what localization ships or whether the copy is valid.

## Data and calculation

- Name the fixtures being imported and how they get onto the device: a seeded
  account, an import file, an API call, or a test backend.
- Confirm on the relevant screens that the import worked before trusting any
  calculated output.
- Where the AC sets a minimum count, span, or number of calendar days, test
  exactly at the threshold and one step below it.
- Keep Day, Week, and Month windows (or their equivalents) apart, along with
  whether the selected window persists. What holds for one window is not
  automatically true for another.
- If profile, target, unit, or currency settings feed the result, recalculate
  after changing them.

## Device pairing and onboarding

- Where relevant, cover getting into pairing, discovery, code entry, progress,
  confirmation, close, back, cancel, retry, and where the user lands
  afterwards.
- Treat first-time setup messages separately from the case where a device is
  already connected or an account already exists.
- Clear leftover OS-level pairings or saved sessions when the case needs a
  clean starting point.
- Force a predictable connection failure by cutting connectivity only if the
  source sanctions that setup.

## Charts, values, and entries

- For a current value on screen, check only what is specified among: the value
  or its placeholder, unit, range label, color, background, marker type,
  marker position, and highlight state.
- Cover inclusive range edges and any special out-of-range display (capped
  labels such as "above max" or "below min") when the AC asks for them.
- For entries tied to a date — a habit log, an expense list — check the
  default date, that a date picked in the calendar carries through, the
  current-time default, save and cancel, and that list and summary views
  agree.
- When two entries land on the same or almost the same timestamp, check axis
  grouping, how markers stack, and ordering, but only against explicit
  requirements.
- For editing, check the values the fields start with, that Save starts
  disabled, that it enables after a change, that closing or going back throws
  changes away, that saving keeps them, and how the chart reacts.

## Notifications and message priority

- Before firing a notification, settle the notification permission, whether
  the app is in the foreground or background, which screen is open, and that
  no competing message is showing.
- Check title, description, the configured threshold, whether older
  notifications are replaced, what tapping does, and when it is removed — each
  only if specified.
- For a change in priority, check that the lower-priority message goes away,
  that the higher-priority one is shown on its own, and, if required, that the
  earlier valid message comes back once the higher-priority state clears.
- Tell apart states that look alike (for example "trial ending soon" versus
  "trial ended"), and check that foreground notifications are suppressed only
  where the source says so.

## Lifecycle states and errors (connected device, subscription, session)

- A summary (such as a row in Settings) and its detail screen must report the
  same state.
- Split time-remaining tests at boundaries a source gives you — for example
  more than three days, one to three days, under 24 hours, a few seconds, and
  expired. At each, check text, progress position, color, imagery, the
  last-sync text being replaced, and which actions are offered.
- For a lost connection, a temporary error, a revoked permission, or an early
  end, test both getting into the state and getting out of it, and make sure
  old error elements disappear once recovered.
- Keep the data ranges configured in test tools, plus any warm-up or retry
  timing, as given; never fill in missing values yourself.
- A higher-priority terminal state must stay in charge even after connectivity
  or permissions change later.

## Environment boundaries

- Emulators, simulators, demo modes, or mocked backends are fine for
  integration work and in-sprint speed, but only where the source allows them.
- When the source demands release-representative real devices for release
  testing, use them.
- Record known tool flakiness as an execution note. Retry only if the source
  explicitly allows it, and never let retries hide a defect that reproduces.
