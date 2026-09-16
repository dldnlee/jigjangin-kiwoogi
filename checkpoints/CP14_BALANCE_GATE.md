# CP14 — Balance and local-loop proof

Status: **Not started** · Milestone: **v0.3**

## Dependencies

[CP13](CP13_ACHIEVEMENTS.md)

CP15–CP16 are optional service work. CP17 can follow CP14 directly. CP18 additionally requires CP15/CP16 evidence for any service included in the build. None of these checkpoints is completed by the documentation pack itself.

## Required reading

[CODEX_RULES](../docs/CODEX_RULES.md), [PRODUCT_SPEC](../docs/PRODUCT_SPEC.md), [ARCHITECTURE](../docs/ARCHITECTURE.md), [DATA_SCHEMA](../docs/DATA_SCHEMA.md), [BALANCING](../docs/BALANCING.md), [TESTING](../docs/TESTING.md), [ANALYTICS](../docs/ANALYTICS.md)

## Objective

Prove reachability, stability and player comprehension before services.

## Requirements

- Build production-domain balance CLI and deterministic policies.
- Run1000 seeds plus stress/edge fixtures; report percentile milestones and ledgers.
- Profile8h replay, idle rendering and30min thermal session.
- Conduct second qualitative play round; fix identified core friction.
- Version tuned config and record save compatibility impact.

## Implementation steps

1. Inspect predecessor evidence and current code; map expected paths to actual repository structure.
2. Add or migrate the data contracts below and write failing tests for this checkpoint's listed edge cases.
3. Implement the domain/application behavior in the requirements using canonical system rules.
4. Wire UI to committed state, include empty/error/loading behavior, and add the necessary content/assets.
5. Run targeted tests, content validation and applicable regression checks. Fix failures before expanding scope.
6. Demonstrate the acceptance journey, record real evidence below, and update roadmap only when complete.

## Data structures and game rules

BalanceScenario, reproducible seed/policy report and device measurements.

Canonical formulas, units, costs, bounds, and reset behavior live in the required system references. Do not replace their numbers with convenient constants in widgets. Persist new fields via explicit migration, and settle time before commands that change derived rates.

## UI requirements

Review office next-goal clarity, employer comparisons and failure/retirement previews.

Controls need accessible labels, Korean copy keys, pending-command handling and truthful disabled/error states. Keep the current build usable while future features remain hidden.

## Edge cases

- Idle-only,72h absence, max-level state, repeated clock edits.
- Founder starvation, locked investments, repeated prestige.
- High-value money beyond native integer precision.

## Tests

- All invariants in TESTING plus policy reachability.
- Pure simulation report reproducible on two runs.
- No nonpaying policy requires ad or purchase; all closures recover.

Run formatting, `flutter analyze`, applicable `flutter test`, and the content validator once available. Run device/integration checks required above and note target/environment. Unavailable credentials, hardware or signing are recorded as pending evidence; never mark them passed.

## Acceptance criteria

- [ ] Reports include actual results and unresolved target misses.
- [ ] No save loss, duplication or unreachable core gate remains.
- [ ] Qualitative core gate passes before CP15/CP16 service activation.
- [ ] Required domain/data tests and applicable regression checks pass.
- [ ] Save/config compatibility and user-visible error paths reviewed.
- [ ] Evidence below includes actual output/artifact references and remaining limitations.

## Expected files changed

- `tool/simulate_balance.dart`
- `test/domain/`
- `assets/data/`
- `docs/reports/`
- `docs/BALANCING.md`
- This checkpoint's evidence section and `docs/ROADMAP.md` after criteria pass.

Paths are anticipated implementation paths, not files included in this documentation-only pack. Narrow changes to the active scope and preserve unrelated work.

## Out of scope

- Inventing successful retention measurements
- Adding backend to fix weak gameplay
- Production release

## Evidence and handoff

Implementation commit: not yet available. App/config/schema versions: not yet available. Tests run/results: not run. Device runs: not run. Screenshots/report links: none. Migration review: pending where applicable. Known issues: none assessed. Next step: implement this checkpoint when dependencies pass.

Leave status **Not started** until work begins; use **In progress**, **Blocked (with concrete reason)**, or **Complete**. Completion requires every acceptance criterion, not merely generated code.
