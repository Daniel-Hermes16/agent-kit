# Video evidence intake

Follow this file whenever an app video or screen capture feeds into a new case
or a revision.

## Inspect safely

1. Note the file name or link, the date you retrieved it, its length and
   resolution, and whatever is actually confirmed about platform, build,
   device, locale, account, connected hardware, network, and permissions. Mark
   anything unconfirmed as unknown — do not guess it from how the UI looks.
2. Watch the whole recording in whatever viewer is available. If you cannot
   play it directly, read the metadata with `ffprobe` and pull specific frames
   with `ffmpeg` into a scratch folder inside the workspace that version
   control ignores. Choose frames around taps, navigation, transitions,
   messages, state changes, and pauses instead of sampling only at fixed
   intervals, and delete the frames once you are done.
3. Never send the recording to a service that has not been approved. Keep
   personal details out of view and out of the output — names, email
   addresses, notifications, identifiers, financial, health, or location data,
   and the like. Describe only what the case needs, and never commit the video
   or any extracted frame.
4. Listen to audio only if it matters to the workflow and an approved local
   tool exists. Speech you cannot make out is a gap; do not fabricate a
   transcript.

## Build a timestamped observation log

Log only the events that matter:

| Time | Visible user action | Observed application state | Confidence / gap |
| --- | --- | --- | --- |
| `00:00–00:05` | `<what the user does, or "not visible">` | `<screen, text, value, transition, or response shown>` | `<direct / inferred / obscured>` |

- Keep a tap you can see apart from an action you only infer across a cut.
- A delay is an observation, not a requirement, unless an approved source sets
  the timing oracle.
- Write down cuts, speed-ups or slow-downs, setup that is never shown, hidden
  gestures, text you cannot read, cropped system UI, and states that happen
  off-screen.
- Timestamps serve as citations in Preconditions, steps, or evidence gaps. One
  range that covers the whole flow is enough; do not stamp every row.

## Convert observations into a test case

1. Rebuild the setup visible before the first executable action. Anything that
   must have been in place but is never shown gets marked `Inference` or
   `Gap`.
2. Turn what the user visibly does into imperative Step Descriptions, and what
   the app visibly does in reply into Step Results.
3. Check every expected result against the current ticket, linked pages,
   requirements, and design. A recording only shows how one build behaved
   under one configuration.
4. If the video and an approved oracle disagree, keep both, point to the
   timestamp and the step affected, and ask the human owner to decide. Never
   bend the expected result to fit the footage.
5. Add negative, boundary, recovery, or platform variants only when another
   source calls for them or the user asks for risk-based expansion. Never say
   the video covers a state it does not show.

## Incomplete or unusable recordings

- If the gaps do not block drafting, keep going and list the missing setup,
  action, state, text, or result under Evidence gaps.
- If something hidden or skipped makes it unsafe to rebuild the order of
  actions and results, ask one targeted question.
- Ask for a new file or a shorter clip only when the recording cannot be
  opened, cannot be accessed, is corrupt, or is too unclear for the flow in
  question.
