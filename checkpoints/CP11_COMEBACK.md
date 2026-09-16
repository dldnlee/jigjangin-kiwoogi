# CP11 — Failure and comeback identity

Status: **Not started** · Milestone: **v0.3**

## Dependencies

[CP10](CP10_BUSINESS.md)

CP15–CP16 are optional service work. CP17 can follow CP14 directly. CP18 additionally requires CP15/CP16 evidence for any service included in the build. None of these checkpoints is completed by the documentation pack itself.

## Required reading

[CODEX_RULES](../docs/CODEX_RULES.md), [PRODUCT_SPEC](../docs/PRODUCT_SPEC.md), [ARCHITECTURE](../docs/ARCHITECTURE.md), [DATA_SCHEMA](../docs/DATA_SCHEMA.md), [BUSINESS_AND_COMEBACK](../docs/BUSINESS_AND_COMEBACK.md), [SAVE_AND_RECOVERY](../docs/SAVE_AND_RECOVERY.md), [UI_SPEC](../docs/UI_SPEC.md)

## Objective

Turn closure into a readable, recoverable career chapter.

## Requirements

- Add unique closure archives, founder experience and bounded skill/reputation rewards.
- Implement first qualifying closure bonus and deterministic comeback offer.
- Differentiate voluntary/insolvent closure; clear incompatible pending business choices.
- Add recap of retained assets and next career goal.
- Ensure first failed founder path is reachable in test fixtures without damaging other wallets.

## Implementation steps

1. Inspect predecessor evidence and current code; map expected paths to actual repository structure.
2. Add or migrate the data contracts below and write failing tests for this checkpoint's listed edge cases.
3. Implement the domain/application behavior in the requirements using canonical system rules.
4. Wire UI to committed state, include empty/error/loading behavior, and add the necessary content/assets.
5. Run targeted tests, content validation and applicable regression checks. Fix failures before expanding scope.
6. Demonstrate the acceptance journey, record real evidence below, and update roadmap only when complete.

## Data structures and game rules

Closure archive, durable closure claim, comebackGranted and temporary salary modifier.

Canonical formulas, units, costs, bounds, and reset behavior live in the required system references. Do not replace their numbers with convenient constants in widgets. Persist new fields via explicit migration, and settle time before commands that change derived rates.

## UI requirements

Explain lost committed capital and retained skills; immediate office/fallback salary visible.

Controls need accessible labels, Korean copy keys, pending-command handling and truthful disabled/error states. Keep the current build usable while future features remain hidden.

## Edge cases

- Zero-month close has no reward; repeat close cannot farm bonus.
- Closure at exact offline cap; queued recap does not delay transition.
- Best eligible employer already current; reject offer without softlock.

## Tests

- Duplicate closure command grants once; reload during recap retains result.
- Bonus expiry3600s splits earning correctly.
- Found/close loop cannot increase reward without completed months.

Run formatting, `flutter analyze`, applicable `flutter test`, and the content validator once available. Run device/integration checks required above and note target/environment. Unavailable credentials, hardware or signing are recorded as pending evidence; never mark them passed.

## Acceptance criteria

- [ ] Both voluntary and insolvent paths are tested.
- [ ] Closure→new salary occurs at same boundary.
- [ ] Personal gear/holdings/life assets retained exactly.
- [ ] Required domain/data tests and applicable regression checks pass.
- [ ] Save/config compatibility and user-visible error paths reviewed.
- [ ] Evidence below includes actual output/artifact references and remaining limitations.

## Expected files changed

- `lib/domain/business/`
- `lib/domain/career/`
- `lib/features/business/`
- `test/domain/comeback_test.dart`
- This checkpoint's evidence section and `docs/ROADMAP.md` after criteria pass.

Paths are anticipated implementation paths, not files included in this documentation-only pack. Narrow changes to the active scope and preserve unrelated work.

## Out of scope

- Personal debt
- Paid rescue
- Automatic forced founding

## Evidence and handoff

Implementation commit: not yet available. App/config/schema versions: not yet available. Tests run/results: not run. Device runs: not run. Screenshots/report links: none. Migration review: pending where applicable. Known issues: none assessed. Next step: implement this checkpoint when dependencies pass.

Leave status **Not started** until work begins; use **In progress**, **Blocked (with concrete reason)**, or **Complete**. Completion requires every acceptance criterion, not merely generated code.
