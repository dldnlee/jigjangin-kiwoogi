# CP06 — Equipment and visual progression

Status: **Not started** · Milestone: **v0.1**

## Dependencies

[CP05](CP05_COMPANIES.md)

CP15–CP16 are optional service work. CP17 can follow CP14 directly. CP18 additionally requires CP15/CP16 evidence for any service included in the build. None of these checkpoints is completed by the documentation pack itself.

## Required reading

[CODEX_RULES](../docs/CODEX_RULES.md), [PRODUCT_SPEC](../docs/PRODUCT_SPEC.md), [ARCHITECTURE](../docs/ARCHITECTURE.md), [DATA_SCHEMA](../docs/DATA_SCHEMA.md), [SKILLS_AND_EQUIPMENT](../docs/SKILLS_AND_EQUIPMENT.md), [ASSET_MANIFEST](../docs/ASSET_MANIFEST.md), [ASSET_PRODUCTION](../docs/ASSET_PRODUCTION.md)

## Objective

Add a useful gear shop and reliable equip/unequip behavior.

## Requirements

- Author15 exact slice items, slots and stat modifiers.
- Implement unique ownership, buy/equip compound command and single-slot replacement.
- Derive stats from base every time, respecting caps.
- Integrate placeholder or approved laptop/outfit/prop swaps via manifest IDs.
- Expose inventory, shop, equipped state and prices.

## Implementation steps

1. Inspect predecessor evidence and current code; map expected paths to actual repository structure.
2. Add or migrate the data contracts below and write failing tests for this checkpoint's listed edge cases.
3. Implement the domain/application behavior in the requirements using canonical system rules.
4. Wire UI to committed state, include empty/error/loading behavior, and add the necessary content/assets.
5. Run targeted tests, content validation and applicable regression checks. Fix failures before expanding scope.
6. Demonstrate the acceptance journey, record real evidence below, and update roadmap only when complete.

## Data structures and game rules

EquipmentDefinition, owned IDs, equipped slot map and visual manifest.

Canonical formulas, units, costs, bounds, and reset behavior live in the required system references. Do not replace their numbers with convenient constants in widgets. Persist new fields via explicit migration, and settle time before commands that change derived rates.

## UI requirements

Before/after comparison, owned/locked state and identifiable slot feedback.

Controls need accessible labels, Korean copy keys, pending-command handling and truthful disabled/error states. Keep the current build usable while future features remain hidden.

## Edge cases

- Buy owned item; equip unowned item; wrong slot; unequip empty slot.
- Rapid replacement must not stack bonuses.
- Missing art resolves placeholder without losing item.

## Tests

- Equip then unequip returns original rate/stats.
- All15 items validate and fit expected slots.
- Persist equipment; cash spend once on compound command.

Run formatting, `flutter analyze`, applicable `flutter test`, and the content validator once available. Run device/integration checks required above and note target/environment. Unavailable credentials, hardware or signing are recorded as pending evidence; never mark them passed.

## Acceptance criteria

- [ ] Inventory and seven slots work with no duplicate effects.
- [ ] At least laptop changes visibly in office.
- [ ] Every item has localization and icon reference.
- [ ] Required domain/data tests and applicable regression checks pass.
- [ ] Save/config compatibility and user-visible error paths reviewed.
- [ ] Evidence below includes actual output/artifact references and remaining limitations.

## Expected files changed

- `lib/domain/equipment/`
- `lib/features/equipment/`
- `assets/data/equipment.json`
- `assets/art/`
- `test/domain/equipment_test.dart`
- This checkpoint's evidence section and `docs/ROADMAP.md` after criteria pass.

Paths are anticipated implementation paths, not files included in this documentation-only pack. Narrow changes to the active scope and preserve unrelated work.

## Out of scope

- Gacha
- Durability or resale
- 100-item launch catalogue

## Evidence and handoff

Implementation commit: not yet available. App/config/schema versions: not yet available. Tests run/results: not run. Device runs: not run. Screenshots/report links: none. Migration review: pending where applicable. Known issues: none assessed. Next step: implement this checkpoint when dependencies pass.

Leave status **Not started** until work begins; use **In progress**, **Blocked (with concrete reason)**, or **Complete**. Completion requires every acceptance criterion, not merely generated code.
