# CP13 — Achievements, missions and journal

Status: **Not started** · Milestone: **v0.3**

## Dependencies

[CP12](CP12_PRESTIGE.md)

CP15–CP16 are optional service work. CP17 can follow CP14 directly. CP18 additionally requires CP15/CP16 evidence for any service included in the build. None of these checkpoints is completed by the documentation pack itself.

## Required reading

[CODEX_RULES](../docs/CODEX_RULES.md), [PRODUCT_SPEC](../docs/PRODUCT_SPEC.md), [ARCHITECTURE](../docs/ARCHITECTURE.md), [DATA_SCHEMA](../docs/DATA_SCHEMA.md), [PRESTIGE_AND_ACHIEVEMENTS](../docs/PRESTIGE_AND_ACHIEVEMENTS.md), [ANALYTICS](../docs/ANALYTICS.md)

## Objective

Reward milestones without duplicate claims or attendance pressure.

## Requirements

- Implement ten beta lifetime achievements and domain-event counters.
- Add three optional UTC daily missions with capped-player fallbacks.
- Implement durable claims, queued retired rewards and journal history.
- Retain mission claim keys across prestige and reject clock rollback reopening.
- Keep gems disabled until authoritative cosmetic service exists.

## Implementation steps

1. Inspect predecessor evidence and current code; map expected paths to actual repository structure.
2. Add or migrate the data contracts below and write failing tests for this checkpoint's listed edge cases.
3. Implement the domain/application behavior in the requirements using canonical system rules.
4. Wire UI to committed state, include empty/error/loading behavior, and add the necessary content/assets.
5. Run targeted tests, content validation and applicable regression checks. Fix failures before expanding scope.
6. Demonstrate the acceptance journey, record real evidence below, and update roadmap only when complete.

## Data structures and game rules

AchievementProgress, durable claims, mission high-water day and deferred rewards.

Canonical formulas, units, costs, bounds, and reset behavior live in the required system references. Do not replace their numbers with convenient constants in widgets. Persist new fields via explicit migration, and settle time before commands that change derived rates.

## UI requirements

Clear claim/claimed/queued states, UTC reset label and no streak warning.

Controls need accessible labels, Korean copy keys, pending-command handling and truthful disabled/error states. Keep the current build usable while future features remain hidden.

## Edge cases

- Repeat event delivery; claim during retired state.
- UTC midnight versus game-month boundary.
- All upgrades/skills capped, prestige same UTC day.

## Tests

- Each achievement and daily reward pays once.
- Mission fallback is completable at all caps.
- Deferred retirement achievement pays next run exactly once.

Run formatting, `flutter analyze`, applicable `flutter test`, and the content validator once available. Run device/integration checks required above and note target/environment. Unavailable credentials, hardware or signing are recorded as pending evidence; never mark them passed.

## Acceptance criteria

- [ ] All ten achievement definitions and three mission routes work.
- [ ] Reload/import validation preserves claim IDs.
- [ ] No required milestone depends on daily attendance.
- [ ] Required domain/data tests and applicable regression checks pass.
- [ ] Save/config compatibility and user-visible error paths reviewed.
- [ ] Evidence below includes actual output/artifact references and remaining limitations.

## Expected files changed

- `lib/domain/achievements/`
- `lib/features/achievements/`
- `assets/data/achievements.json`
- `assets/data/missions.json`
- `test/domain/achievements_test.dart`
- This checkpoint's evidence section and `docs/ROADMAP.md` after criteria pass.

Paths are anticipated implementation paths, not files included in this documentation-only pack. Narrow changes to the active scope and preserve unrelated work.

## Out of scope

- Streak penalties
- Premium currency claims
- 50-achievement launch catalogue

## Evidence and handoff

Implementation commit: not yet available. App/config/schema versions: not yet available. Tests run/results: not run. Device runs: not run. Screenshots/report links: none. Migration review: pending where applicable. Known issues: none assessed. Next step: implement this checkpoint when dependencies pass.

Leave status **Not started** until work begins; use **In progress**, **Blocked (with concrete reason)**, or **Complete**. Completion requires every acceptance criterion, not merely generated code.
