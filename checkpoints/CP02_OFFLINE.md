# CP02 — Offline settlement and recovery

Status: **Not started** · Milestone: **v0.1**

## Dependencies

[CP01](CP01_IDLE_CORE.md)

CP15–CP16 are optional service work. CP17 can follow CP14 directly. CP18 additionally requires CP15/CP16 evidence for any service included in the build. None of these checkpoints is completed by the documentation pack itself.

## Required reading

[CODEX_RULES](../docs/CODEX_RULES.md), [PRODUCT_SPEC](../docs/PRODUCT_SPEC.md), [ARCHITECTURE](../docs/ARCHITECTURE.md), [DATA_SCHEMA](../docs/DATA_SCHEMA.md), [TIME_AND_OFFLINE](../docs/TIME_AND_OFFLINE.md), [SAVE_AND_RECOVERY](../docs/SAVE_AND_RECOVERY.md), [ECONOMY](../docs/ECONOMY.md)

## Objective

Credit bounded away progress exactly once through the same simulator.

## Requirements

- Settle background and resume transitions with high-water UTC timestamps.
- Implement eight-hour cap, subsecond adapter remainder and atomic OfflineReceipt.
- Show already-credited gross/net breakdown and dismissal-only action.
- Handle kill-before/after-commit and pending summary merges.
- Add debug elapsed-time controls in non-production builds.

## Implementation steps

1. Inspect predecessor evidence and current code; map expected paths to actual repository structure.
2. Add or migrate the data contracts below and write failing tests for this checkpoint's listed edge cases.
3. Implement the domain/application behavior in the requirements using canonical system rules.
4. Wire UI to committed state, include empty/error/loading behavior, and add the necessary content/assets.
5. Run targeted tests, content validation and applicable regression checks. Fix failures before expanding scope.
6. Demonstrate the acceptance journey, record real evidence below, and update roadmap only when complete.

## Data structures and game rules

OfflineReceipt, timestamp high-water state and lifecycle adapter.

Canonical formulas, units, costs, bounds, and reset behavior live in the required system references. Do not replace their numbers with convenient constants in widgets. Persist new fields via explicit migration, and settle time before commands that change derived rates.

## UI requirements

Under60s toast; otherwise summary sheet; show capped duration without an ad control.

Controls need accessible labels, Korean copy keys, pending-command handling and truthful disabled/error states. Keep the current build usable while future features remain hidden.

## Edge cases

- Repeated resume/dismiss; process death during save.
- Clock rollback, timezone change and huge forward jump.
- 10h absence credits8h and discards excess permanently.

## Tests

- Base100 won/s×28800=2880000 won.
- Eight1h advances equals one8h advance.
- Resume same timestamp grants zero and leaves PRNG unchanged.

Run formatting, `flutter analyze`, applicable `flutter test`, and the content validator once available. Run device/integration checks required above and note target/environment. Unavailable credentials, hardware or signing are recorded as pending evidence; never mark them passed.

## Acceptance criteria

- [ ] Reopening never grants the same interval twice.
- [ ] Kill/relaunch restores meaningful committed progress.
- [ ] Base game remains playable in airplane mode.
- [ ] Required domain/data tests and applicable regression checks pass.
- [ ] Save/config compatibility and user-visible error paths reviewed.
- [ ] Evidence below includes actual output/artifact references and remaining limitations.

## Expected files changed

- `lib/application/`
- `lib/domain/simulation/`
- `lib/features/office/`
- `test/domain/`
- `integration_test/offline_test.dart`
- This checkpoint's evidence section and `docs/ROADMAP.md` after criteria pass.

Paths are anticipated implementation paths, not files included in this documentation-only pack. Narrow changes to the active scope and preserve unrelated work.

## Out of scope

- Ads
- Business and investment settlement
- Cloud clock authority

## Evidence and handoff

Implementation commit: not yet available. App/config/schema versions: not yet available. Tests run/results: not run. Device runs: not run. Screenshots/report links: none. Migration review: pending where applicable. Known issues: none assessed. Next step: implement this checkpoint when dependencies pass.

Leave status **Not started** until work begins; use **In progress**, **Blocked (with concrete reason)**, or **Complete**. Completion requires every acceptance criterion, not merely generated code.
