# CP19 — Content updates and incident readiness

Status: **Not started** · Milestone: **operations**

## Dependencies

[CP18](CP18_RELEASE.md)

CP15–CP16 are optional service work. CP17 can follow CP14 directly. CP18 additionally requires CP15/CP16 evidence for any service included in the build. None of these checkpoints is completed by the documentation pack itself.

## Required reading

[CODEX_RULES](../docs/CODEX_RULES.md), [PRODUCT_SPEC](../docs/PRODUCT_SPEC.md), [ARCHITECTURE](../docs/ARCHITECTURE.md), [DATA_SCHEMA](../docs/DATA_SCHEMA.md), [RELEASE_AND_OPERATIONS](../docs/RELEASE_AND_OPERATIONS.md), [BALANCING](../docs/BALANCING.md), [SAVE_AND_RECOVERY](../docs/SAVE_AND_RECOVERY.md)

## Objective

Make future updates reproducible and recoverable.

## Requirements

- Practice config staging/rollback against real release compatibility manifest.
- Deliver one reviewed ten-event content batch through existing validators.
- Run incident drill for corrupt save and duplicate reward report.
- Review consenting cohorts with eligible windows/sample sizes and operational costs.
- Document support triage and next-content hypothesis without creating an automatic schedule.

## Implementation steps

1. Inspect predecessor evidence and current code; map expected paths to actual repository structure.
2. Add or migrate the data contracts below and write failing tests for this checkpoint's listed edge cases.
3. Implement the domain/application behavior in the requirements using canonical system rules.
4. Wire UI to committed state, include empty/error/loading behavior, and add the necessary content/assets.
5. Run targeted tests, content validation and applicable regression checks. Fix failures before expanding scope.
6. Demonstrate the acceptance journey, record real evidence below, and update roadmap only when complete.

## Data structures and game rules

Rollout record, incident record and versioned content batch.

Canonical formulas, units, costs, bounds, and reset behavior live in the required system references. Do not replace their numbers with convenient constants in widgets. Persist new fields via explicit migration, and settle time before commands that change derived rates.

## UI requirements

Ensure updated content preserves pending events and existing player understanding.

Controls need accessible labels, Korean copy keys, pending-command handling and truthful disabled/error states. Keep the current build usable while future features remain hidden.

## Edge cases

- Rollback references deleted IDs; old client receives new config.
- Noisy telemetry or outage; incomplete retention cohorts.
- Duplicate reward report caused by delayed display versus actual ledger duplication.

## Tests

- Old/new save and config compatibility fixtures.
- Reproducible batch balance comparison.
- Incident drill recovers without blanket reset.

Run formatting, `flutter analyze`, applicable `flutter test`, and the content validator once available. Run device/integration checks required above and note target/environment. Unavailable credentials, hardware or signing are recorded as pending evidence; never mark them passed.

## Acceptance criteria

- [ ] Update and rollback paths proven in staging.
- [ ] Support runbook identifies actual owners/channels when available.
- [ ] Metrics report includes uncertainty and opt-in bias.
- [ ] Required domain/data tests and applicable regression checks pass.
- [ ] Save/config compatibility and user-visible error paths reviewed.
- [ ] Evidence below includes actual output/artifact references and remaining limitations.

## Expected files changed

- `assets/data/`
- `docs/reports/`
- `docs/RELEASE_AND_OPERATIONS.md`
- `test/fixtures/`
- This checkpoint's evidence section and `docs/ROADMAP.md` after criteria pass.

Paths are anticipated implementation paths, not files included in this documentation-only pack. Narrow changes to the active scope and preserve unrelated work.

## Out of scope

- Unrequested automations
- Unvalidated live tuning
- Scope expansion without design records

## Evidence and handoff

Implementation commit: not yet available. App/config/schema versions: not yet available. Tests run/results: not run. Device runs: not run. Screenshots/report links: none. Migration review: pending where applicable. Known issues: none assessed. Next step: implement this checkpoint when dependencies pass.

Leave status **Not started** until work begins; use **In progress**, **Blocked (with concrete reason)**, or **Complete**. Completion requires every acceptance criterion, not merely generated code.
