# Context Usage Tracking

Tracks what context was loaded vs. what was actually referenced during work. Used by the retrospective skill to tune context compiler profiles.

## How to Update

During work, when you notice:
- A loaded component was useful → mark as `used`
- A loaded component was never referenced → mark as `unused`
- A component NOT loaded would have been helpful → mark as `missing`

## Usage Log

| Date | Work Type | Component Loaded | Used? | Notes |
|------|-----------|-----------------|-------|-------|
|      |           |                 |       |       |

## Profile Tuning Suggestions

When patterns emerge from the log:
- Component consistently `unused` in a profile → move from Required to Recommended, or remove
- Component consistently `missing` for a work type → add to that profile
- Component always `used` when loaded as Recommended → promote to Required

## Applied Tunings

No tunings applied yet.

<!-- Entry format:
### [date] -- [tuning description]
- **Profile**: [work type]
- **Change**: [what was changed]
- **Reason**: [evidence from usage log]
- **Approved by**: user | retrospective
-->
