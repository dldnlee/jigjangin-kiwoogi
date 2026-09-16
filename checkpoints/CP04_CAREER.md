# CP04 — Career and promotion

Status: **Not started** · Milestone: **v0.1**

## Dependencies

[CP03](CP03_SKILLS.md)

CP15–CP16 are optional service work. CP17 can follow CP14 directly. CP18 additionally requires CP15/CP16 evidence for any service included in the build. None of these checkpoints is completed by the documentation pack itself.

## Required reading

[CODEX_RULES](../docs/CODEX_RULES.md), [PRODUCT_SPEC](../docs/PRODUCT_SPEC.md), [ARCHITECTURE](../docs/ARCHITECTURE.md), [DATA_SCHEMA](../docs/DATA_SCHEMA.md), [CAREER_AND_COMPANIES](../docs/CAREER_AND_COMPANIES.md), [TIME_AND_OFFLINE](../docs/TIME_AND_OFFLINE.md), [UI_SPEC](../docs/UI_SPEC.md)

## Objective

Deliver visible rank progression with bounded promotion randomness.

## Requirements

- Implement five-rank slice ladder with thresholds from profile config.
- Accrue performance at minute boundaries and apply reputation rewards.
- Implement seeded promotion draw,120s cooldown and fourth-attempt guarantee.
- Store pity per run+target ID; reset performance on promotion.
- Add career view, requirement links, result journal and office rank mapping.

## Implementation steps

1. Inspect predecessor evidence and current code; map expected paths to actual repository structure.
2. Add or migrate the data contracts below and write failing tests for this checkpoint's listed edge cases.
3. Implement the domain/application behavior in the requirements using canonical system rules.
4. Wire UI to committed state, include empty/error/loading behavior, and add the necessary content/assets.
5. Run targeted tests, content validation and applicable regression checks. Fix failures before expanding scope.
6. Demonstrate the acceptance journey, record real evidence below, and update roadmap only when complete.

## Data structures and game rules

CareerDefinition, PromotionState, promotion RNG stream and command receipt.

Canonical formulas, units, costs, bounds, and reset behavior live in the required system references. Do not replace their numbers with convenient constants in widgets. Persist new fields via explicit migration, and settle time before commands that change derived rates.

## UI requirements

Show requirements, exact chance and pity; celebrate only after persisted success.

Controls need accessible labels, Korean copy keys, pending-command handling and truthful disabled/error states. Keep the current build usable while future features remain hidden.

## Edge cases

- Top rank; one missing requirement; exactly at cooldown boundary.
- Restart after failed roll cannot erase pity.
- Stale/double attempt and crash after commit return stored outcome.

## Tests

- Seeded fail/success vectors and fourth eligible attempt always passes.
- Performance reset/reputation+5 exactly once.
- Career path reachable with CP03 skills and seed profile; debug fixtures for later ranks.

Run formatting, `flutter analyze`, applicable `flutter test`, and the content validator once available. Run device/integration checks required above and note target/environment. Unavailable credentials, hardware or signing are recorded as pending evidence; never mark them passed.

## Acceptance criteria

- [ ] First promotion can be earned through normal play with no debug grants.
- [ ] All five rank transitions and terminal view pass fixtures.
- [ ] No ad or currency fee gates evaluation.
- [ ] Required domain/data tests and applicable regression checks pass.
- [ ] Save/config compatibility and user-visible error paths reviewed.
- [ ] Evidence below includes actual output/artifact references and remaining limitations.

## Expected files changed

- `lib/domain/career/`
- `lib/features/career/`
- `assets/data/careers.json`
- `test/domain/career_test.dart`
- This checkpoint's evidence section and `docs/ROADMAP.md` after criteria pass.

Paths are anticipated implementation paths, not files included in this documentation-only pack. Narrow changes to the active scope and preserve unrelated work.

## Out of scope

- Job market
- Nine-rank alpha ladder
- Real-money rerolls

## Evidence and handoff

Implementation commit: not yet available. App/config/schema versions: not yet available. Tests run/results: not run. Device runs: not run. Screenshots/report links: none. Migration review: pending where applicable. Known issues: none assessed. Next step: implement this checkpoint when dependencies pass.

Leave status **Not started** until work begins; use **In progress**, **Blocked (with concrete reason)**, or **Complete**. Completion requires every acceptance criterion, not merely generated code.
