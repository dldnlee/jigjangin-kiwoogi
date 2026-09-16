# CP03 — Skills and training

Status: **Not started** · Milestone: **v0.1**

## Dependencies

[CP02](CP02_OFFLINE.md)

CP15–CP16 are optional service work. CP17 can follow CP14 directly. CP18 additionally requires CP15/CP16 evidence for any service included in the build. None of these checkpoints is completed by the documentation pack itself.

## Required reading

[CODEX_RULES](../docs/CODEX_RULES.md), [PRODUCT_SPEC](../docs/PRODUCT_SPEC.md), [ARCHITECTURE](../docs/ARCHITECTURE.md), [DATA_SCHEMA](../docs/DATA_SCHEMA.md), [SKILLS_AND_EQUIPMENT](../docs/SKILLS_AND_EQUIPMENT.md), [ECONOMY](../docs/ECONOMY.md)

## Objective

Provide the three slice skills needed for career requirements.

## Requirements

- Implement work/expertise/talk, training costs, level caps and derived effective skill API.
- Expose locked-to-unlocked training after first core upgrade.
- Recalculate rates after settled training; never increment cached multipliers.
- Define alpha skill fields at zero while disabled; validate disabled-feature prerequisites.
- Show both intended consequences of each skill; career/offer consequences activate in following checkpoints.

## Implementation steps

1. Inspect predecessor evidence and current code; map expected paths to actual repository structure.
2. Add or migrate the data contracts below and write failing tests for this checkpoint's listed edge cases.
3. Implement the domain/application behavior in the requirements using canonical system rules.
4. Wire UI to committed state, include empty/error/loading behavior, and add the necessary content/assets.
5. Run targeted tests, content validation and applicable regression checks. Fix failures before expanding scope.
6. Demonstrate the acceptance journey, record real evidence below, and update roadmap only when complete.

## Data structures and game rules

SkillDefinitions, trained levels, TrainSkillCommand, derived effective stats.

Canonical formulas, units, costs, bounds, and reset behavior live in the required system references. Do not replace their numbers with convenient constants in widgets. Persist new fields via explicit migration, and settle time before commands that change derived rates.

## UI requirements

Three cards with level, price and effect preview; disabled alpha skills hidden.

Controls need accessible labels, Korean copy keys, pending-command handling and truthful disabled/error states. Keep the current build usable while future features remain hidden.

## Edge cases

- Train at100; unaffordable request; unknown skill ID.
- Save from CP02 needs explicit fields/default migration if absent.
- No equipment bonus affects cost or trained-level counters.

## Tests

- Cost growth rounded up; work changes salary, expertise changes XP.
- Cap and invalid ID rejection leaves cash unchanged.
- Persist trained levels and identical derived rates after restart.

Run formatting, `flutter analyze`, applicable `flutter test`, and the content validator once available. Run device/integration checks required above and note target/environment. Unavailable credentials, hardware or signing are recorded as pending evidence; never mark them passed.

## Acceptance criteria

- [ ] All three slice skills can be purchased and restored.
- [ ] Domain tests prove effects without widget dependencies.
- [ ] No hidden future skill contributes to salary or requirements.
- [ ] Required domain/data tests and applicable regression checks pass.
- [ ] Save/config compatibility and user-visible error paths reviewed.
- [ ] Evidence below includes actual output/artifact references and remaining limitations.

## Expected files changed

- `lib/domain/skills/`
- `lib/features/skills/`
- `assets/data/skills.json`
- `test/domain/skills_test.dart`
- This checkpoint's evidence section and `docs/ROADMAP.md` after criteria pass.

Paths are anticipated implementation paths, not files included in this documentation-only pack. Narrow changes to the active scope and preserve unrelated work.

## Out of scope

- Alpha mental/leadership/luck activation
- Training timers
- Premium training

## Evidence and handoff

Implementation commit: not yet available. App/config/schema versions: not yet available. Tests run/results: not run. Device runs: not run. Screenshots/report links: none. Migration review: pending where applicable. Known issues: none assessed. Next step: implement this checkpoint when dependencies pass.

Leave status **Not started** until work begins; use **In progress**, **Blocked (with concrete reason)**, or **Complete**. Completion requires every acceptance criterion, not merely generated code.
