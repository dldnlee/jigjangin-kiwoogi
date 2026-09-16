# CP12 — Retirement and another life

Status: **Not started** · Milestone: **v0.3**

## Dependencies

[CP11](CP11_COMEBACK.md)

CP15–CP16 are optional service work. CP17 can follow CP14 directly. CP18 additionally requires CP15/CP16 evidence for any service included in the build. None of these checkpoints is completed by the documentation pack itself.

## Required reading

[CODEX_RULES](../docs/CODEX_RULES.md), [PRODUCT_SPEC](../docs/PRODUCT_SPEC.md), [ARCHITECTURE](../docs/ARCHITECTURE.md), [DATA_SCHEMA](../docs/DATA_SCHEMA.md), [PRESTIGE_AND_ACHIEVEMENTS](../docs/PRESTIGE_AND_ACHIEVEMENTS.md), [ECONOMY](../docs/ECONOMY.md)

## Objective

Complete the long-term loop with explicit reset and permanent progress.

## Requirements

- Implement voluntary eligibility, revision-bound preview and integer point formula.
- Archive/terminally liquidate once; retired mode stops simulation.
- Implement first five permanent upgrades and explicit new-life command.
- Apply full reset/retain matrix and generate fresh run/PRNG identities.
- Render career recap and accessible reset confirmation.

## Implementation steps

1. Inspect predecessor evidence and current code; map expected paths to actual repository structure.
2. Add or migrate the data contracts below and write failing tests for this checkpoint's listed edge cases.
3. Implement the domain/application behavior in the requirements using canonical system rules.
4. Wire UI to committed state, include empty/error/loading behavior, and add the necessary content/assets.
5. Run targeted tests, content validation and applicable regression checks. Fix failures before expanding scope.
6. Demonstrate the acceptance journey, record real evidence below, and update roadmap only when complete.

## Data structures and game rules

CareerArchive, careerPoints, permanentLevels, retired mode and durable retirement claim.

Canonical formulas, units, costs, bounds, and reset behavior live in the required system references. Do not replace their numbers with convenient constants in widgets. Persist new fields via explicit migration, and settle time before commands that change derived rates.

## UI requirements

Show losses/retained values/points before confirmation; stay-in-life action remains available.

Controls need accessible labels, Korean copy keys, pending-command handling and truthful disabled/error states. Keep the current build usable while future features remain hidden.

## Edge cases

- Double retirement/new-life submit; stale preview.
- Point sqrt boundary and1000 cap; eligible zero-earnings minimum1.
- Active business, locked property, pending event or away receipt on retirement.

## Tests

- Table-driven test of every reset/retain field.
- Transferred principal/liquidation cannot inflate points.
- Second complete run never reuses first-run earning in reward formula.

Run formatting, `flutter analyze`, applicable `flutter test`, and the content validator once available. Run device/integration checks required above and note target/environment. Unavailable credentials, hardware or signing are recorded as pending evidence; never mark them passed.

## Acceptance criteria

- [ ] Player can finish and restart two consecutive lives.
- [ ] Permanent effects apply once only on new-life initialization.
- [ ] Continue without retiring remains supported.
- [ ] Required domain/data tests and applicable regression checks pass.
- [ ] Save/config compatibility and user-visible error paths reviewed.
- [ ] Evidence below includes actual output/artifact references and remaining limitations.

## Expected files changed

- `lib/domain/prestige/`
- `lib/features/retirement/`
- `assets/data/prestige.json`
- `test/domain/prestige_test.dart`
- This checkpoint's evidence section and `docs/ROADMAP.md` after criteria pass.

Paths are anticipated implementation paths, not files included in this documentation-only pack. Narrow changes to the active scope and preserve unrelated work.

## Out of scope

- Forced age reset
- Paid Career Points
- All15 launch permanent upgrades

## Evidence and handoff

Implementation commit: not yet available. App/config/schema versions: not yet available. Tests run/results: not run. Device runs: not run. Screenshots/report links: none. Migration review: pending where applicable. Known issues: none assessed. Next step: implement this checkpoint when dependencies pass.

Leave status **Not started** until work begins; use **In progress**, **Blocked (with concrete reason)**, or **Complete**. Completion requires every acceptance criterion, not merely generated code.
