# CP09 — Fictional investments

Status: **Not started** · Milestone: **v0.2**

## Dependencies

[CP08](CP08_LIFE_ALPHA.md)

CP15–CP16 are optional service work. CP17 can follow CP14 directly. CP18 additionally requires CP15/CP16 evidence for any service included in the build. None of these checkpoints is completed by the documentation pack itself.

## Required reading

[CODEX_RULES](../docs/CODEX_RULES.md), [PRODUCT_SPEC](../docs/PRODUCT_SPEC.md), [ARCHITECTURE](../docs/ARCHITECTURE.md), [DATA_SCHEMA](../docs/DATA_SCHEMA.md), [LIFE_AND_INVESTMENTS](../docs/LIFE_AND_INVESTMENTS.md), [ECONOMY](../docs/ECONOMY.md)

## Objective

Create an optional wealth path with transparent risk and accounting.

## Requirements

- Implement deposit, fund, equity and one rental property as specified.
- Add monthly market draws and transaction fees with precise cost-basis handling.
- Settle before trades; revision-bound quote preview.
- Show current value versus spendable cash and possible game-month outcomes.
- Preserve exact holdings, prices and settlement IDs across resumes.

## Implementation steps

1. Inspect predecessor evidence and current code; map expected paths to actual repository structure.
2. Add or migrate the data contracts below and write failing tests for this checkpoint's listed edge cases.
3. Implement the domain/application behavior in the requirements using canonical system rules.
4. Wire UI to committed state, include empty/error/loading behavior, and add the necessary content/assets.
5. Run targeted tests, content validation and applicable regression checks. Fix failures before expanding scope.
6. Demonstrate the acceptance journey, record real evidence below, and update roadmap only when complete.

## Data structures and game rules

InvestmentHolding, instrument definition, market stream and trade command.

Canonical formulas, units, costs, bounds, and reset behavior live in the required system references. Do not replace their numbers with convenient constants in widgets. Persist new fields via explicit migration, and settle time before commands that change derived rates.

## UI requirements

Buy/sell integer unit entry, fee preview, property lock and risk explanation.

Controls need accessible labels, Korean copy keys, pending-command handling and truthful disabled/error states. Keep the current build usable while future features remain hidden.

## Edge cases

- Zero/negative/excess units; insufficient funds including fee.
- Partial/full sale basis rounding; price floor1.
- Trade exactly at settlement; locked property sale.

## Tests

- Deposit10000 pays50/month; duplicate settlement pays0 extra.
- Buy/sell round trip loses declared fees, never creates income from principal.
- Price paths and portfolio net worth match seeded fixture.

Run formatting, `flutter analyze`, applicable `flutter test`, and the content validator once available. Run device/integration checks required above and note target/environment. Unavailable credentials, hardware or signing are recorded as pending evidence; never mark them passed.

## Acceptance criteria

- [ ] All four models operate offline.
- [ ] No leverage, negative units or real-world ticker appears.
- [ ] Income ledger distinguishes realized profit from returned principal.
- [ ] Required domain/data tests and applicable regression checks pass.
- [ ] Save/config compatibility and user-visible error paths reviewed.
- [ ] Evidence below includes actual output/artifact references and remaining limitations.

## Expected files changed

- `lib/domain/investments/`
- `lib/features/investments/`
- `assets/data/investments.json`
- `test/domain/investments_test.dart`
- This checkpoint's evidence section and `docs/ROADMAP.md` after criteria pass.

Paths are anticipated implementation paths, not files included in this documentation-only pack. Narrow changes to the active scope and preserve unrelated work.

## Out of scope

- Live market feeds
- Orders or leverage
- Real-money investment products

## Evidence and handoff

Implementation commit: not yet available. App/config/schema versions: not yet available. Tests run/results: not run. Device runs: not run. Screenshots/report links: none. Migration review: pending where applicable. Known issues: none assessed. Next step: implement this checkpoint when dependencies pass.

Leave status **Not started** until work begins; use **In progress**, **Blocked (with concrete reason)**, or **Complete**. Completion requires every acceptance criterion, not merely generated code.
