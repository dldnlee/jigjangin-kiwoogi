# CP10 — Founder simulation

Status: **Not started** · Milestone: **v0.3**

## Dependencies

[CP09](CP09_INVESTMENTS.md)

CP15–CP16 are optional service work. CP17 can follow CP14 directly. CP18 additionally requires CP15/CP16 evidence for any service included in the build. None of these checkpoints is completed by the documentation pack itself.

## Required reading

[CODEX_RULES](../docs/CODEX_RULES.md), [PRODUCT_SPEC](../docs/PRODUCT_SPEC.md), [ARCHITECTURE](../docs/ARCHITECTURE.md), [DATA_SCHEMA](../docs/DATA_SCHEMA.md), [BUSINESS_AND_COMEBACK](../docs/BUSINESS_AND_COMEBACK.md), [ECONOMY](../docs/ECONOMY.md), [TIME_AND_OFFLINE](../docs/TIME_AND_OFFLINE.md)

## Objective

Implement a bounded business economy including its safe insolvency transition.

## Requirements

- Add three beta business types, founding gates and separate cash/capital accounting.
- Implement five staff roles, capacity, upgrades and withdrawal reserve.
- Accrue segmented monthly revenue/expenses using stored shock and remainders.
- Switch off salary while founder; restore fallback employment on unaffordable expense immediately.
- Provide forecasts, cash-only liquidation and confirmation previews.

## Implementation steps

1. Inspect predecessor evidence and current code; map expected paths to actual repository structure.
2. Add or migrate the data contracts below and write failing tests for this checkpoint's listed edge cases.
3. Implement the domain/application behavior in the requirements using canonical system rules.
4. Wire UI to committed state, include empty/error/loading behavior, and add the necessary content/assets.
5. Run targeted tests, content validation and applicable regression checks. Fix failures before expanding scope.
6. Demonstrate the acceptance journey, record real evidence below, and update roadmap only when complete.

## Data structures and game rules

BusinessState, accrued amounts/remainders, staff, unreturnedCapital and business stream.

Canonical formulas, units, costs, bounds, and reset behavior live in the required system references. Do not replace their numbers with convenient constants in widgets. Persist new fields via explicit migration, and settle time before commands that change derived rates.

## UI requirements

Capital risk, runway, projected profit, staff controls and closed-business summary.

Controls need accessible labels, Korean copy keys, pending-command handling and truthful disabled/error states. Keep the current build usable while future features remain hidden.

## Edge cases

- Partial month founding; midmonth hire/upgrade; exact cash=expense remains active.
- Expense one won too high closes; withdrawal cannot escape accrued liabilities.
- Multiple business actions same revision; close during offline settlement.

## Tests

- No salary/business double earning across mode boundary.
- Revenue/cost segment equivalence and rounded reserve arithmetic.
- Failure restores wages and preserves personal assets even before CP11 polish.

Run formatting, `flutter analyze`, applicable `flutter test`, and the content validator once available. Run device/integration checks required above and note target/environment. Unavailable credentials, hardware or signing are recorded as pending evidence; never mark them passed.

## Acceptance criteria

- [ ] One complete founding→operating→surplus or closure path works.
- [ ] Player can never become stuck in insolvent founder mode.
- [ ] Business transfers never count as new earned income.
- [ ] Required domain/data tests and applicable regression checks pass.
- [ ] Save/config compatibility and user-visible error paths reviewed.
- [ ] Evidence below includes actual output/artifact references and remaining limitations.

## Expected files changed

- `lib/domain/business/`
- `lib/features/business/`
- `assets/data/businesses.json`
- `test/domain/business_test.dart`
- This checkpoint's evidence section and `docs/ROADMAP.md` after criteria pass.

Paths are anticipated implementation paths, not files included in this documentation-only pack. Narrow changes to the active scope and preserve unrelated work.

## Out of scope

- Comeback bonuses and detailed archive polish
- Acquisition payouts
- Unlimited employee simulation

## Evidence and handoff

Implementation commit: not yet available. App/config/schema versions: not yet available. Tests run/results: not run. Device runs: not run. Screenshots/report links: none. Migration review: pending where applicable. Known issues: none assessed. Next step: implement this checkpoint when dependencies pass.

Leave status **Not started** until work begins; use **In progress**, **Blocked (with concrete reason)**, or **Complete**. Completion requires every acceptance criterion, not merely generated code.
