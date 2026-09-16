# CP17 — Launch content, assets and accessibility

Status: **Not started** · Milestone: **v1.0**

## Dependencies

[CP14](CP14_BALANCE_GATE.md)

CP15–CP16 are optional service work. CP17 can follow CP14 directly. CP18 additionally requires CP15/CP16 evidence for any service included in the build. None of these checkpoints is completed by the documentation pack itself.

## Required reading

[CODEX_RULES](../docs/CODEX_RULES.md), [PRODUCT_SPEC](../docs/PRODUCT_SPEC.md), [ARCHITECTURE](../docs/ARCHITECTURE.md), [DATA_SCHEMA](../docs/DATA_SCHEMA.md), [ASSET_MANIFEST](../docs/ASSET_MANIFEST.md), [ASSET_PRODUCTION](../docs/ASSET_PRODUCTION.md), [EVENTS_AND_CONTENT](../docs/EVENTS_AND_CONTENT.md), [UI_SPEC](../docs/UI_SPEC.md)

## Objective

Complete the specified content work order and production presentation.

## Requirements

- Reach launch counts:15 companies,9 ranks,6 skills,100 gear,300 categorized events,6 businesses,50 achievements,15 prestige upgrades.
- Author remaining businesses and events under existing rules, no new hidden mechanics.
- Complete asset manifest, optimized exports, audio, Korean editorial review and rights records.
- Verify every route state at320px/200% text and screen-reader navigation.
- Remove placeholders/debug visuals and profile production scenes.

## Implementation steps

1. Inspect predecessor evidence and current code; map expected paths to actual repository structure.
2. Add or migrate the data contracts below and write failing tests for this checkpoint's listed edge cases.
3. Implement the domain/application behavior in the requirements using canonical system rules.
4. Wire UI to committed state, include empty/error/loading behavior, and add the necessary content/assets.
5. Run targeted tests, content validation and applicable regression checks. Fix failures before expanding scope.
6. Demonstrate the acceptance journey, record real evidence below, and update roadmap only when complete.

## Data structures and game rules

Complete content/asset manifests, localization catalogue and editorial evidence.

Canonical formulas, units, costs, bounds, and reset behavior live in the required system references. Do not replace their numbers with convenient constants in widgets. Persist new fields via explicit migration, and settle time before commands that change derived rates.

## UI requirements

Consistent office transformations, founder/retirement scenes, reduced-motion equivalents.

Controls need accessible labels, Korean copy keys, pending-command handling and truthful disabled/error states. Keep the current build usable while future features remain hidden.

## Edge cases

- Missing asset fallback; huge Korean labels; absent optional SDK tab.
- All300 event choices validated and accessible.
- Late-game texture memory and outfit animation clipping.

## Tests

- Content reference/schema/branch validator and rank reachability.
- Physical-device layout, audio interruption and reduced-motion checks.
- Asset rights and count audit; no shipped placeholders.

Run formatting, `flutter analyze`, applicable `flutter test`, and the content validator once available. Run device/integration checks required above and note target/environment. Unavailable credentials, hardware or signing are recorded as pending evidence; never mark them passed.

## Acceptance criteria

- [ ] Exact content counts or explicit scope decision documented.
- [ ] All approved asset families delivered and integrated.
- [ ] No mandatory action inaccessible at target text size.
- [ ] Required domain/data tests and applicable regression checks pass.
- [ ] Save/config compatibility and user-visible error paths reviewed.
- [ ] Evidence below includes actual output/artifact references and remaining limitations.

## Expected files changed

- `assets/`
- `lib/l10n/`
- `lib/features/`
- `docs/reports/`
- `test/widgets/`
- This checkpoint's evidence section and `docs/ROADMAP.md` after criteria pass.

Paths are anticipated implementation paths, not files included in this documentation-only pack. Narrow changes to the active scope and preserve unrelated work.

## Out of scope

- New economy systems
- Automatic Flame rewrite
- Public submission

## Evidence and handoff

Implementation commit: not yet available. App/config/schema versions: not yet available. Tests run/results: not run. Device runs: not run. Screenshots/report links: none. Migration review: pending where applicable. Known issues: none assessed. Next step: implement this checkpoint when dependencies pass.

Leave status **Not started** until work begins; use **In progress**, **Blocked (with concrete reason)**, or **Complete**. Completion requires every acceptance criterion, not merely generated code.
