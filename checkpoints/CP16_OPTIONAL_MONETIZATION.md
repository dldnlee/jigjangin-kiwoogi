# CP16 — Optional rewarded ads and cosmetics

Status: **Not started** · Milestone: **services**

## Dependencies

[CP15](CP15_OPTIONAL_BACKEND.md)

CP15–CP16 are optional service work. CP17 can follow CP14 directly. CP18 additionally requires CP15/CP16 evidence for any service included in the build. None of these checkpoints is completed by the documentation pack itself.

## Required reading

[CODEX_RULES](../docs/CODEX_RULES.md), [PRODUCT_SPEC](../docs/PRODUCT_SPEC.md), [ARCHITECTURE](../docs/ARCHITECTURE.md), [DATA_SCHEMA](../docs/DATA_SCHEMA.md), [BACKEND_AND_MONETIZATION](../docs/BACKEND_AND_MONETIZATION.md), [ECONOMY](../docs/ECONOMY.md), [ANALYTICS](../docs/ANALYTICS.md)

## Objective

Deliver optional monetization with reliable grants and unchanged free progression.

## Requirements

- Select providers and verify current platform policies; implement fakes before live SDKs.
- Implement single offline salary bonus placement with cap/expiry and verified deduplication.
- Implement fixed cosmetic pack products, receipt verification, restore/refund states.
- Separate entitlement cache from game save and preserve paid cosmetics across prestige.
- Add service kill switches, unavailable states and stage-level analytics under consent.

## Implementation steps

1. Inspect predecessor evidence and current code; map expected paths to actual repository structure.
2. Add or migrate the data contracts below and write failing tests for this checkpoint's listed edge cases.
3. Implement the domain/application behavior in the requirements using canonical system rules.
4. Wire UI to committed state, include empty/error/loading behavior, and add the necessary content/assets.
5. Run targeted tests, content validation and applicable regression checks. Fix failures before expanding scope.
6. Demonstrate the acceptance journey, record real evidence below, and update roadmap only when complete.

## Data structures and game rules

RewardGrant, entitlement ledger, verified purchase receipt reference and product catalogue.

Canonical formulas, units, costs, bounds, and reset behavior live in the required system references. Do not replace their numbers with convenient constants in widgets. Persist new fields via explicit migration, and settle time before commands that change derived rates.

## UI requirements

Primary continue action always available; accurate localized price; reward-pending and restore states.

Controls need accessible labels, Korean copy keys, pending-command handling and truthful disabled/error states. Keep the current build usable while future features remain hidden.

## Edge cases

- No fill, cancellation, duplicate callback, delayed verification after retirement.
- Pending purchase, refund, restore on second device, offline spending attempt.
- Receipt replay and configuration disable during in-flight action.

## Tests

- Bonus excludes all nonsalary and earned-income counters.
- Same transaction cannot grant twice after restart or restore.
- Sandbox purchase/refund and verified ad lifecycle end-to-end.

Run formatting, `flutter analyze`, applicable `flutter test`, and the content validator once available. Run device/integration checks required above and note target/environment. Unavailable credentials, hardware or signing are recorded as pending evidence; never mark them passed.

## Acceptance criteria

- [ ] Nonpaying gameplay regression suite remains identical.
- [ ] All grants verified and durable; provider integration evidence attached.
- [ ] No undefined consumable gem SKU ships.
- [ ] Required domain/data tests and applicable regression checks pass.
- [ ] Save/config compatibility and user-visible error paths reviewed.
- [ ] Evidence below includes actual output/artifact references and remaining limitations.

## Expected files changed

- `lib/data/services/`
- `lib/features/shop/`
- `backend/`
- `test/services/`
- `integration_test/`
- This checkpoint's evidence section and `docs/ROADMAP.md` after criteria pass.

Paths are anticipated implementation paths, not files included in this documentation-only pack. Narrow changes to the active scope and preserve unrelated work.

## Out of scope

- Cash/stat packs
- Subscriptions
- Gacha, paid rerolls or business rescue

## Evidence and handoff

Implementation commit: not yet available. App/config/schema versions: not yet available. Tests run/results: not run. Device runs: not run. Screenshots/report links: none. Migration review: pending where applicable. Known issues: none assessed. Next step: implement this checkpoint when dependencies pass.

Leave status **Not started** until work begins; use **In progress**, **Blocked (with concrete reason)**, or **Complete**. Completion requires every acceptance criterion, not merely generated code.
