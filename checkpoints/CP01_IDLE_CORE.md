# CP01 — Deterministic idle income

Status: **Not started** · Milestone: **v0.1**

## Dependencies

[CP00](CP00_FOUNDATION.md)

CP15–CP16 are optional service work. CP17 can follow CP14 directly. CP18 additionally requires CP15/CP16 evidence for any service included in the build. None of these checkpoints is completed by the documentation pack itself.

## Required reading

[CODEX_RULES](../docs/CODEX_RULES.md), [PRODUCT_SPEC](../docs/PRODUCT_SPEC.md), [ARCHITECTURE](../docs/ARCHITECTURE.md), [DATA_SCHEMA](../docs/DATA_SCHEMA.md), [ECONOMY](../docs/ECONOMY.md), [TIME_AND_OFFLINE](../docs/TIME_AND_OFFLINE.md), [GAME_DESIGN](../docs/GAME_DESIGN.md)

## Objective

Make work, cash, XP and three upgrades playable with exact arithmetic.

## Requirements

- Implement Money, ledger sources, ordered rate derivation, XP thresholds and level caps.
- Implement pure advance and command queue with injected elapsed time.
- Implement speed/efficiency/focus single-level purchases and affordability feedback.
- Autosave every five seconds and immediately on commands; publish only committed state.
- Create content validator CLI and deterministic base fixtures.

## Implementation steps

1. Inspect predecessor evidence and current code; map expected paths to actual repository structure.
2. Add or migrate the data contracts below and write failing tests for this checkpoint's listed edge cases.
3. Implement the domain/application behavior in the requirements using canonical system rules.
4. Wire UI to committed state, include empty/error/loading behavior, and add the necessary content/assets.
5. Run targeted tests, content validation and applicable regression checks. Fix failures before expanding scope.
6. Demonstrate the acceptance journey, record real evidence below, and update roadmap only when complete.

## Data structures and game rules

Money, SimulationResult, UpgradeCommand, ledger and accrual remainders.

Canonical formulas, units, costs, bounds, and reset behavior live in the required system references. Do not replace their numbers with convenient constants in widgets. Persist new fields via explicit migration, and settle time before commands that change derived rates.

## UI requirements

Office shows cash, rate, XP, upgrade cost and before/after benefit; tapping worker is cosmetic.

Controls need accessible labels, Korean copy keys, pending-command handling and truthful disabled/error states. Keep the current build usable while future features remain hidden.

## Edge cases

- Exact cash purchase versus one won short; cap200 upgrades and level100 XP.
- Rapid taps use revision checks and cannot spend twice.
- Fractional elapsed frame times do not lose money or XP.

## Tests

- 60 seconds at base =6000 won and60XP; first speed upgrade changes rate to105.
- Upgrade cost ceil at levels0,1,2 and200 boundary.
- Random time partitions preserve totals; run20min without commands and with scripted purchases.

Run formatting, `flutter analyze`, applicable `flutter test`, and the content validator once available. Run device/integration checks required above and note target/environment. Unavailable credentials, hardware or signing are recorded as pending evidence; never mark them passed.

## Acceptance criteria

- [ ] Runnable office sustains20min of progress without errors.
- [ ] All purchases use atomic repository commits.
- [ ] First upgrade available within60 credited seconds under seed config.
- [ ] Required domain/data tests and applicable regression checks pass.
- [ ] Save/config compatibility and user-visible error paths reviewed.
- [ ] Evidence below includes actual output/artifact references and remaining limitations.

## Expected files changed

- `lib/domain/economy/`
- `lib/domain/simulation/`
- `lib/application/`
- `lib/features/office/`
- `tool/validate_content.dart`
- `test/domain/`
- This checkpoint's evidence section and `docs/ROADMAP.md` after criteria pass.

Paths are anticipated implementation paths, not files included in this documentation-only pack. Narrow changes to the active scope and preserve unrelated work.

## Out of scope

- Offline summary
- Promotions
- Skills or gear UI

## Evidence and handoff

Implementation commit: not yet available. App/config/schema versions: not yet available. Tests run/results: not run. Device runs: not run. Screenshots/report links: none. Migration review: pending where applicable. Known issues: none assessed. Next step: implement this checkpoint when dependencies pass.

Leave status **Not started** until work begins; use **In progress**, **Blocked (with concrete reason)**, or **Complete**. Completion requires every acceptance criterion, not merely generated code.
