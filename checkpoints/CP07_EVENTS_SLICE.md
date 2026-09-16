# CP07 — Events and vertical-slice gate

Status: **Not started** · Milestone: **v0.1**

## Dependencies

[CP06](CP06_EQUIPMENT.md)

CP15–CP16 are optional service work. CP17 can follow CP14 directly. CP18 additionally requires CP15/CP16 evidence for any service included in the build. None of these checkpoints is completed by the documentation pack itself.

## Required reading

[CODEX_RULES](../docs/CODEX_RULES.md), [PRODUCT_SPEC](../docs/PRODUCT_SPEC.md), [ARCHITECTURE](../docs/ARCHITECTURE.md), [DATA_SCHEMA](../docs/DATA_SCHEMA.md), [EVENTS_AND_CONTENT](../docs/EVENTS_AND_CONTENT.md), [GAME_DESIGN](../docs/GAME_DESIGN.md), [TESTING](../docs/TESTING.md), [ASSET_PRODUCTION](../docs/ASSET_PRODUCTION.md)

## Objective

Give the first hour personality and prove the small core before expanding.

## Requirements

- Implement allowlisted predicates/effects, weights, cooldowns and one pending event.
- Author20 slice event briefs into reviewed Korean JSON/ARB choices, including talk-gated option.
- Guarantee a free valid choice; preserve instance snapshots across saves.
- Integrate idle/typing/celebration assets and guided first-goal hints.
- Run30–60min slice study and record issues; verify Android and iOS build paths.

## Implementation steps

1. Inspect predecessor evidence and current code; map expected paths to actual repository structure.
2. Add or migrate the data contracts below and write failing tests for this checkpoint's listed edge cases.
3. Implement the domain/application behavior in the requirements using canonical system rules.
4. Wire UI to committed state, include empty/error/loading behavior, and add the necessary content/assets.
5. Run targeted tests, content validation and applicable regression checks. Fix failures before expanding scope.
6. Demonstrate the acceptance journey, record real evidence below, and update roadmap only when complete.

## Data structures and game rules

EventDefinition, EventInstance, choice receipt, event RNG stream and cooldowns.

Canonical formulas, units, costs, bounds, and reset behavior live in the required system references. Do not replace their numbers with convenient constants in widgets. Persist new fields via explicit migration, and settle time before commands that change derived rates.

## UI requirements

Dismissible pending-event sheet, visible choices/effects, event badge and journal.

Controls need accessible labels, Korean copy keys, pending-command handling and truthful disabled/error states. Keep the current build usable while future features remain hidden.

## Edge cases

- Empty candidate set; pending event on resume; stale choice affordability.
- Close sheet without choosing; resolve twice.
- Disabled stress remains mechanically inactive in slice.

## Tests

- All branches validate; no-cost reputation path stays reachable.
- Outcome commit/PRNG restoration exactly once.
- End-to-end first upgrade→train→promotion→offer→equip→event→restart.

Run formatting, `flutter analyze`, applicable `flutter test`, and the content validator once available. Run device/integration checks required above and note target/environment. Unavailable credentials, hardware or signing are recorded as pending evidence; never mark them passed.

## Acceptance criteria

- [ ] 20 authored office events,15 gear,3 employers,5 ranks and3 skills present.
- [ ] 4/5 observed testers understand next goal and buy upgrade without guidance, or gate remains open with fixes.
- [ ] 30–60min runnable slice and platform/test evidence attached.
- [ ] Required domain/data tests and applicable regression checks pass.
- [ ] Save/config compatibility and user-visible error paths reviewed.
- [ ] Evidence below includes actual output/artifact references and remaining limitations.

## Expected files changed

- `lib/domain/events/`
- `lib/features/events/`
- `assets/data/events.json`
- `lib/l10n/`
- `integration_test/`
- `docs/reports/`
- This checkpoint's evidence section and `docs/ROADMAP.md` after criteria pass.

Paths are anticipated implementation paths, not files included in this documentation-only pack. Narrow changes to the active scope and preserve unrelated work.

## Out of scope

- Life/investment/business systems
- Backend/ads
- Expanding content to hide core usability failures

## Evidence and handoff

Implementation commit: not yet available. App/config/schema versions: not yet available. Tests run/results: not run. Device runs: not run. Screenshots/report links: none. Migration review: pending where applicable. Known issues: none assessed. Next step: implement this checkpoint when dependencies pass.

Leave status **Not started** until work begins; use **In progress**, **Blocked (with concrete reason)**, or **Complete**. Completion requires every acceptance criterion, not merely generated code.
