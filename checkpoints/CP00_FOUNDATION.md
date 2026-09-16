# CP00 — Foundation and configuration

Status: **Not started** · Milestone: **v0.1**

## Dependencies

None; documentation is the starting point.

CP15–CP16 are optional service work. CP17 can follow CP14 directly. CP18 additionally requires CP15/CP16 evidence for any service included in the build. None of these checkpoints is completed by the documentation pack itself.

## Required reading

[CODEX_RULES](../docs/CODEX_RULES.md), [PRODUCT_SPEC](../docs/PRODUCT_SPEC.md), [ARCHITECTURE](../docs/ARCHITECTURE.md), [DATA_SCHEMA](../docs/DATA_SCHEMA.md), [SAVE_AND_RECOVERY](../docs/SAVE_AND_RECOVERY.md)

## Objective

Create a bootable offline Flutter app with validated configuration and a recoverable local profile.

## Requirements

- Create Flutter Android/iOS targets, Riverpod composition, GoRouter shell and Korean localization.
- Choose compatible stable package versions, commit lockfile and document supported devices/OS.
- Implement Drift save repository, current/previous slots, revision transactions and bootstrap loading/error/ready states.
- Create slice config manifest and semantic/JSON schemas; disabled future collections are empty.
- Add non-production debug clock/reset and release exclusion; set format/analyze/test CI.

## Implementation steps

1. Inspect predecessor evidence and current code; map expected paths to actual repository structure.
2. Add or migrate the data contracts below and write failing tests for this checkpoint's listed edge cases.
3. Implement the domain/application behavior in the requirements using canonical system rules.
4. Wire UI to committed state, include empty/error/loading behavior, and add the necessary content/assets.
5. Run targeted tests, content validation and applicable regression checks. Fix failures before expanding scope.
6. Demonstrate the acceptance journey, record real evidence below, and update roadmap only when complete.

## Data structures and game rules

SaveEnvelope, starter RunState/MetaState, config manifest, SaveRepository and injected clock.

Canonical formulas, units, costs, bounds, and reset behavior live in the required system references. Do not replace their numbers with convenient constants in widgets. Persist new fields via explicit migration, and settle time before commands that change derived rates.

## UI requirements

Launch directly into placeholder office; settings and recoverable boot errors work without network.

Controls need accessible labels, Korean copy keys, pending-command handling and truthful disabled/error states. Keep the current build usable while future features remain hidden.

## Edge cases

- Missing config file or invalid reference must fail safely before writes.
- Corrupt current save restores previous; corrupt both offers export/reset, never silent reset.
- Unsupported future schema stays read-only; database full does not report successful save.

## Tests

- Round-trip all starter fields and BigInt money.
- Corrupt snapshot and failed transaction fixtures.
- Cold start offline, kill/relaunch, and release debug-control absence.

Run formatting, `flutter analyze`, applicable `flutter test`, and the content validator once available. Run device/integration checks required above and note target/environment. Unavailable credentials, hardware or signing are recorded as pending evidence; never mark them passed.

## Acceptance criteria

- [ ] App launches on available Android target and restores exactly after restart.
- [ ] Config validation and CI checks pass; iOS environment availability is honestly recorded.
- [ ] No backend, analytics or ad SDK initializes.
- [ ] Required domain/data tests and applicable regression checks pass.
- [ ] Save/config compatibility and user-visible error paths reviewed.
- [ ] Evidence below includes actual output/artifact references and remaining limitations.

## Expected files changed

- `pubspec.yaml`
- `pubspec.lock`
- `lib/app/`
- `lib/data/config/`
- `lib/data/persistence/`
- `lib/l10n/`
- `assets/data/`
- `test/data/`
- `.github/workflows/ci.yml`
- This checkpoint's evidence section and `docs/ROADMAP.md` after criteria pass.

Paths are anticipated implementation paths, not files included in this documentation-only pack. Narrow changes to the active scope and preserve unrelated work.

## Out of scope

- Income progression
- Real artwork
- Network services

## Evidence and handoff

Implementation commit: not yet available. App/config/schema versions: not yet available. Tests run/results: not run. Device runs: not run. Screenshots/report links: none. Migration review: pending where applicable. Known issues: none assessed. Next step: implement this checkpoint when dependencies pass.

Leave status **Not started** until work begins; use **In progress**, **Blocked (with concrete reason)**, or **Complete**. Completion requires every acceptance criterion, not merely generated code.
