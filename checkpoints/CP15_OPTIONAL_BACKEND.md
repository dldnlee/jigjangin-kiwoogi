# CP15 — Optional account, backup and telemetry

Status: **Not started** · Milestone: **services**

## Dependencies

[CP14](CP14_BALANCE_GATE.md)

CP15–CP16 are optional service work. CP17 can follow CP14 directly. CP18 additionally requires CP15/CP16 evidence for any service included in the build. None of these checkpoints is completed by the documentation pack itself.

## Required reading

[CODEX_RULES](../docs/CODEX_RULES.md), [PRODUCT_SPEC](../docs/PRODUCT_SPEC.md), [ARCHITECTURE](../docs/ARCHITECTURE.md), [DATA_SCHEMA](../docs/DATA_SCHEMA.md), [BACKEND_AND_MONETIZATION](../docs/BACKEND_AND_MONETIZATION.md), [SAVE_AND_RECOVERY](../docs/SAVE_AND_RECOVERY.md), [ANALYTICS](../docs/ANALYTICS.md)

## Objective

Add optional services while preserving complete offline play.

## Requirements

- Record provider/region/version decisions and current official setup/privacy references.
- Implement service ports/fakes then opt-in auth/linking and whole-snapshot backup.
- Implement cloud compare-and-swap conflict preview and rollback backup.
- Add staged validated remote config and opt-in bounded analytics outbox.
- Enforce authenticated per-user authorization and secrets outside app/save files.

## Implementation steps

1. Inspect predecessor evidence and current code; map expected paths to actual repository structure.
2. Add or migrate the data contracts below and write failing tests for this checkpoint's listed edge cases.
3. Implement the domain/application behavior in the requirements using canonical system rules.
4. Wire UI to committed state, include empty/error/loading behavior, and add the necessary content/assets.
5. Run targeted tests, content validation and applicable regression checks. Fix failures before expanding scope.
6. Demonstrate the acceptance journey, record real evidence below, and update roadmap only when complete.

## Data structures and game rules

Cloud revision token, conflict summary, consent version and analytics outbox.

Canonical formulas, units, costs, bounds, and reset behavior live in the required system references. Do not replace their numbers with convenient constants in widgets. Persist new fields via explicit migration, and settle time before commands that change derived rates.

## UI requirements

Continue without account, sync status, choose whole-save conflict resolution and consent toggle.

Controls need accessible labels, Korean copy keys, pending-command handling and truthful disabled/error states. Keep the current build usable while future features remain hidden.

## Edge cases

- Offline startup, expired credentials, account-link collision.
- Cross-user read/write, incompatible remote save/config.
- Consent revocation with unsent events; duplicate analytics delivery.

## Tests

- Authorization denies another account data access.
- Cloud conflict never sums wallets.
- Offline core test suite unchanged; telemetry opt-out sends zero events.

Run formatting, `flutter analyze`, applicable `flutter test`, and the content validator once available. Run device/integration checks required above and note target/environment. Unavailable credentials, hardware or signing are recorded as pending evidence; never mark them passed.

## Acceptance criteria

- [ ] Local game works with all services unavailable.
- [ ] Cloud restore/migration/conflict and deletion flows verified against chosen service.
- [ ] Provider credentials/environment gaps remain explicitly pending, not passed.
- [ ] Required domain/data tests and applicable regression checks pass.
- [ ] Save/config compatibility and user-visible error paths reviewed.
- [ ] Evidence below includes actual output/artifact references and remaining limitations.

## Expected files changed

- `lib/data/services/`
- `lib/application/`
- `lib/features/settings/`
- `backend/`
- `test/services/`
- `integration_test/`
- This checkpoint's evidence section and `docs/ROADMAP.md` after criteria pass.

Paths are anticipated implementation paths, not files included in this documentation-only pack. Narrow changes to the active scope and preserve unrelated work.

## Out of scope

- Leaderboards
- Forced accounts
- Purchases or ads

## Evidence and handoff

Implementation commit: not yet available. App/config/schema versions: not yet available. Tests run/results: not run. Device runs: not run. Screenshots/report links: none. Migration review: pending where applicable. Known issues: none assessed. Next step: implement this checkpoint when dependencies pass.

Leave status **Not started** until work begins; use **In progress**, **Blocked (with concrete reason)**, or **Complete**. Completion requires every acceptance criterion, not merely generated code.
