# CP08 — Life, stress and alpha content

Status: **Not started** · Milestone: **v0.2**

## Dependencies

[CP07](CP07_EVENTS_SLICE.md)

CP15–CP16 are optional service work. CP17 can follow CP14 directly. CP18 additionally requires CP15/CP16 evidence for any service included in the build. None of these checkpoints is completed by the documentation pack itself.

## Required reading

[CODEX_RULES](../docs/CODEX_RULES.md), [PRODUCT_SPEC](../docs/PRODUCT_SPEC.md), [ARCHITECTURE](../docs/ARCHITECTURE.md), [DATA_SCHEMA](../docs/DATA_SCHEMA.md), [LIFE_AND_INVESTMENTS](../docs/LIFE_AND_INVESTMENTS.md), [CAREER_AND_COMPANIES](../docs/CAREER_AND_COMPANIES.md), [SKILLS_AND_EQUIPMENT](../docs/SKILLS_AND_EQUIPMENT.md)

## Objective

Add recoverable life choices and expand the employment game.

## Requirements

- Activate six skills, nine ranks and10 employers with stable-ID migration.
- Add50 gear and100 office events; thresholds/effects validate for alpha.
- Implement age display, stress/recovery/free break and recurring lifestyle upkeep.
- Author six life assets plus moving/leisure milestones with free alternatives.
- Integrate life route and automatic downgrade explanations.

## Implementation steps

1. Inspect predecessor evidence and current code; map expected paths to actual repository structure.
2. Add or migrate the data contracts below and write failing tests for this checkpoint's listed edge cases.
3. Implement the domain/application behavior in the requirements using canonical system rules.
4. Wire UI to committed state, include empty/error/loading behavior, and add the necessary content/assets.
5. Run targeted tests, content validation and applicable regression checks. Fix failures before expanding scope.
6. Demonstrate the acceptance journey, record real evidence below, and update roadmap only when complete.

## Data structures and game rules

LifeState, recovery flag, lastBreakAt, calendar boundaries and alpha config.

Canonical formulas, units, costs, bounds, and reset behavior live in the required system references. Do not replace their numbers with convenient constants in widgets. Persist new fields via explicit migration, and settle time before commands that change derived rates.

## UI requirements

Age and stress explain effects; purchase previews upkeep/resale; no compulsory family choices.

Controls need accessible labels, Korean copy keys, pending-command handling and truthful disabled/error states. Keep the current build usable while future features remain hidden.

## Edge cases

- Stress70/90 thresholds; recovery ends40; unaffordable upkeep.
- Month boundary during eight-hour offline period.
- Slice rank/pity migration when junior/deputy/executive ranks are inserted.

## Tests

- Eight-hour segmented equivalence with recovery and upkeep.
- Downgrade returns resale, no debt or negative cash.
- Full career requirements reachable with alpha profile.

Run formatting, `flutter analyze`, applicable `flutter test`, and the content validator once available. Run device/integration checks required above and note target/environment. Unavailable credentials, hardware or signing are recorded as pending evidence; never mark them passed.

## Acceptance criteria

- [ ] No stress state causes permanent income stoppage.
- [ ] Alpha content counts and references pass validation.
- [ ] Existing slice save survives with same rank ID and owned items.
- [ ] Required domain/data tests and applicable regression checks pass.
- [ ] Save/config compatibility and user-visible error paths reviewed.
- [ ] Evidence below includes actual output/artifact references and remaining limitations.

## Expected files changed

- `lib/domain/life/`
- `lib/features/life/`
- `assets/data/`
- `lib/data/persistence/migrations/`
- `test/domain/life_test.dart`
- This checkpoint's evidence section and `docs/ROADMAP.md` after criteria pass.

Paths are anticipated implementation paths, not files included in this documentation-only pack. Narrow changes to the active scope and preserve unrelated work.

## Out of scope

- Loans/mortgages
- Investments
- Full relationship simulator

## Evidence and handoff

Implementation commit: not yet available. App/config/schema versions: not yet available. Tests run/results: not run. Device runs: not run. Screenshots/report links: none. Migration review: pending where applicable. Known issues: none assessed. Next step: implement this checkpoint when dependencies pass.

Leave status **Not started** until work begins; use **In progress**, **Blocked (with concrete reason)**, or **Complete**. Completion requires every acceptance criterion, not merely generated code.
