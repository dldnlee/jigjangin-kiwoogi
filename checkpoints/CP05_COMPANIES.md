# CP05 — Employers and job offers

Status: **Not started** · Milestone: **v0.1**

## Dependencies

[CP04](CP04_CAREER.md)

CP15–CP16 are optional service work. CP17 can follow CP14 directly. CP18 additionally requires CP15/CP16 evidence for any service included in the build. None of these checkpoints is completed by the documentation pack itself.

## Required reading

[CODEX_RULES](../docs/CODEX_RULES.md), [PRODUCT_SPEC](../docs/PRODUCT_SPEC.md), [ARCHITECTURE](../docs/ARCHITECTURE.md), [DATA_SCHEMA](../docs/DATA_SCHEMA.md), [CAREER_AND_COMPANIES](../docs/CAREER_AND_COMPANIES.md), [SKILLS_AND_EQUIPMENT](../docs/SKILLS_AND_EQUIPMENT.md), [UI_SPEC](../docs/UI_SPEC.md)

## Objective

Make choosing an employer a clear salary-versus-future-workload decision.

## Requirements

- Author three slice employers and validated eligibility.
- Generate up to3 offers each600s after employee; store1800s expiry and terms snapshot.
- Implement deterministic talk negotiation and accept/decline.
- Settle income before employer swap; clear offers and reset performance, retain rank/pity.
- Show slice workload as a coming alpha mechanic only in explanatory copy, not active stress controls.

## Implementation steps

1. Inspect predecessor evidence and current code; map expected paths to actual repository structure.
2. Add or migrate the data contracts below and write failing tests for this checkpoint's listed edge cases.
3. Implement the domain/application behavior in the requirements using canonical system rules.
4. Wire UI to committed state, include empty/error/loading behavior, and add the necessary content/assets.
5. Run targeted tests, content validation and applicable regression checks. Fix failures before expanding scope.
6. Demonstrate the acceptance journey, record real evidence below, and update roadmap only when complete.

## Data structures and game rules

CompanyDefinition, JobOffer instance, negotiated salary and offers RNG stream.

Canonical formulas, units, costs, bounds, and reset behavior live in the required system references. Do not replace their numbers with convenient constants in widgets. Persist new fields via explicit migration, and settle time before commands that change derived rates.

## UI requirements

Current/offer comparison shows salary, difficulty and qualification; no false interview odds.

Controls need accessible labels, Korean copy keys, pending-command handling and truthful disabled/error states. Keep the current build usable while future features remain hidden.

## Edge cases

- No eligible different employer; empty offers; expired offer.
- Two accepts from same list; config changed after generation.
- Company swap at month/minute boundary cannot reprize prior income.

## Tests

- Expiry just before/at boundary; deterministic offer stream.
- Negotiation cap1000bp; salary before/after switch.
- Reload terms remain identical and pity persists.

Run formatting, `flutter analyze`, applicable `flutter test`, and the content validator once available. Run device/integration checks required above and note target/environment. Unavailable credentials, hardware or signing are recorded as pending evidence; never mark them passed.

## Acceptance criteria

- [ ] All three employers can be reached under their expertise gates.
- [ ] Offer accept is atomic and reflected in office.
- [ ] Empty and expired states provide next-generation timing.
- [ ] Required domain/data tests and applicable regression checks pass.
- [ ] Save/config compatibility and user-visible error paths reviewed.
- [ ] Evidence below includes actual output/artifact references and remaining limitations.

## Expected files changed

- `lib/domain/career/`
- `lib/features/career/`
- `assets/data/companies.json`
- `test/domain/offers_test.dart`
- This checkpoint's evidence section and `docs/ROADMAP.md` after criteria pass.

Paths are anticipated implementation paths, not files included in this documentation-only pack. Narrow changes to the active scope and preserve unrelated work.

## Out of scope

- Layoffs
- Interview lottery
- Offer rerolls

## Evidence and handoff

Implementation commit: not yet available. App/config/schema versions: not yet available. Tests run/results: not run. Device runs: not run. Screenshots/report links: none. Migration review: pending where applicable. Known issues: none assessed. Next step: implement this checkpoint when dependencies pass.

Leave status **Not started** until work begins; use **In progress**, **Blocked (with concrete reason)**, or **Complete**. Completion requires every acceptance criterion, not merely generated code.
