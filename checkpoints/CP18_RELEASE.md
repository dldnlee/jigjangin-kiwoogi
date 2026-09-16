# CP18 — Platform readiness and release candidate

Status: **Not started** · Milestone: **v1.0**

## Dependencies

[CP17](CP17_CONTENT_POLISH.md)

CP15–CP16 are optional service work. CP17 can follow CP14 directly. CP18 additionally requires CP15/CP16 evidence for any service included in the build. None of these checkpoints is completed by the documentation pack itself.

## Required reading

[CODEX_RULES](../docs/CODEX_RULES.md), [PRODUCT_SPEC](../docs/PRODUCT_SPEC.md), [ARCHITECTURE](../docs/ARCHITECTURE.md), [DATA_SCHEMA](../docs/DATA_SCHEMA.md), [RELEASE_AND_OPERATIONS](../docs/RELEASE_AND_OPERATIONS.md), [TESTING](../docs/TESTING.md), [BACKEND_AND_MONETIZATION](../docs/BACKEND_AND_MONETIZATION.md)

## Objective

Produce a verifiable release candidate and operational handoff.

## Requirements

- Verify CP15/CP16 if enabled; otherwise keep disabled with explicit not-shipped status.
- Build signed internal Android/iOS candidates with version/config/schema manifest.
- Run migration, offline, purchase-if-enabled and two-life smoke journeys on devices.
- Prepare actual store screenshots, support/privacy copy, ratings and current platform checklist.
- Record known issues, rollout/rollback procedure and deployment authorization status.

## Implementation steps

1. Inspect predecessor evidence and current code; map expected paths to actual repository structure.
2. Add or migrate the data contracts below and write failing tests for this checkpoint's listed edge cases.
3. Implement the domain/application behavior in the requirements using canonical system rules.
4. Wire UI to committed state, include empty/error/loading behavior, and add the necessary content/assets.
5. Run targeted tests, content validation and applicable regression checks. Fix failures before expanding scope.
6. Demonstrate the acceptance journey, record real evidence below, and update roadmap only when complete.

## Data structures and game rules

Release manifest, signed artifact identifiers and compatibility matrix.

Canonical formulas, units, costs, bounds, and reset behavior live in the required system references. Do not replace their numbers with convenient constants in widgets. Persist new fields via explicit migration, and settle time before commands that change derived rates.

## UI requirements

Fresh install and returning-player journeys; clear support/recovery paths.

Controls need accessible labels, Korean copy keys, pending-command handling and truthful disabled/error states. Keep the current build usable while future features remain hidden.

## Edge cases

- Oldest supported device/OS; old save; network outage during boot.
- Production debug controls absent; unavailable optional services.
- Config rollback incompatible with new save schema.

## Tests

- All release-blocker regression tests and physical-device matrix.
- Fresh+upgrade installs for both platforms.
- Store receipt sandbox/restore if monetization enabled.

Run formatting, `flutter analyze`, applicable `flutter test`, and the content validator once available. Run device/integration checks required above and note target/environment. Unavailable credentials, hardware or signing are recorded as pending evidence; never mark them passed.

## Acceptance criteria

- [ ] Candidate artifacts and evidence ready for review; unrun platform checks clearly pending.
- [ ] Zero unresolved release-blocking defects.
- [ ] Public deployment occurs only under actual owner authorization.
- [ ] Required domain/data tests and applicable regression checks pass.
- [ ] Save/config compatibility and user-visible error paths reviewed.
- [ ] Evidence below includes actual output/artifact references and remaining limitations.

## Expected files changed

- `android/`
- `ios/`
- `.github/workflows/`
- `docs/reports/`
- `docs/RELEASE_AND_OPERATIONS.md`
- `assets/store/`
- This checkpoint's evidence section and `docs/ROADMAP.md` after criteria pass.

Paths are anticipated implementation paths, not files included in this documentation-only pack. Narrow changes to the active scope and preserve unrelated work.

## Out of scope

- Unapproved public publishing
- Invented signing credentials
- Unspecified new features

## Evidence and handoff

Implementation commit: not yet available. App/config/schema versions: not yet available. Tests run/results: not run. Device runs: not run. Screenshots/report links: none. Migration review: pending where applicable. Known issues: none assessed. Next step: implement this checkpoint when dependencies pass.

Leave status **Not started** until work begins; use **In progress**, **Blocked (with concrete reason)**, or **Complete**. Completion requires every acceptance criterion, not merely generated code.
