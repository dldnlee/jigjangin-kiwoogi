# Testing and quality strategy

## Layers

Domain tests run in pure Dart with fixed clock, config and seeds. Test formulas and invariants, not private method shape. Parser/repository tests use fixture config and temporary DBs. Widget tests verify player-visible states with fake controllers. Integration tests exercise launch→play→background→restart→continue and durable one-time actions. Device profiling and Korean editorial review are separate from automated tests.

## Required regression matrix

| Area | Cases and oracle |
|---|---|
| Money | Zero/exact affordability/1 won short/cap; no float drift or overflow; ledger conservation |
| Time | 0,1,59,60,3599,3600,28799,28800,28801 seconds; timezone/rollback/forward jumps |
| Chunk equivalence | Same duration in random partitions gives identical state and PRNG streams |
| Offline receipt | Kill before/after commit, double resume, double dismiss; reward exactly once |
| Promotion | Below requirement, cooldown boundary, seeded fail, fourth attempt guarantee, top rank |
| Gear/skills | Purchase at cap, invalid slot, equip same item twice, equip/unequip returns baseline |
| Offers/events | Expiration boundary, invalidated choice, empty eligible pool, restore unresolved event |
| Life | Stress70/90 thresholds, automatic recovery to40, unaffordable upkeep safe downgrade |
| Investments | Fees/partial basis/price floor/property lock; no duplicate monthly payout |
| Business | Partial month, staff change, cash exactly due, 1 won short, voluntary close, withdrawal reserve |
| Comeback | Repeated closure no bonus farming; guaranteed salary; investments intact |
| Prestige | Integer sqrt boundaries, preview stale, double confirm, full reset/retain matrix |
| Save | Every migration, corrupt current/previous, disk full, interrupted commit, future schema |
| Services | Offline launch, denied consent, cloud conflict, duplicate purchase callback, restore/refund |

For deterministic RNG test seed1→270369 and rejection boundaries. Golden balance fixtures include base60s=6000 won/60XP and capped8h=2880000 won. Golden UI snapshots may aid review but do not replace accessibility/device checks. Use property-based randomized states for nonnegative wallets, valid equipment, one-time receipt invariants and replay equivalence; retain seed on failure.

## Tooling and CI

CP00 establishes `dart format --output=none --set-exit-if-changed .`, `flutter analyze`, and `flutter test`. CP01 adds `dart run tool/validate_content.dart`; CP14 adds `dart run tool/simulate_balance.dart --profile slice --seed 1 --report work/balance.json`. Tools do not exist in this documentation pack; their checkpoints create them. CI runs applicable commands, checks generated files are current, and builds Android debug artifact. Add macOS iOS no-codesign build before CP07 and signed internal builds at release gate. Never report skipped device/signing tests as passed.

Minimum coverage expectations are risk-based: all listed economic transitions have branch/boundary assertions; every migration has before/after fixtures; every checkpoint adds targeted tests for its new domain logic. Do not add hundreds of tests duplicating declarative content values. Content validator enforces structural completeness; simulation checks reachability and balance separately.

## Device and usability matrix

Agree actual device models in CP00: one lower-end supported Android phone, one mainstream Android, and oldest supported iPhone available plus a current iPhone. Pin minimum OS versions from chosen plugins and platform support at implementation time. Test 320px-wide layout, 200% text, TalkBack/VoiceOver, offline airplane mode, process kill, lock/resume, audio interruptions, large save, and a 30-minute thermal session. Record OS, app/config hash, measured frame and replay times.

## Release blockers

Any reproducible currency duplication, save loss, permanent progress block, unauthorized purchase grant, inaccessible mandatory control, unresolved migration failure, or crash in the first-session flow blocks release. Balance/content polish issues may be triaged with documented severity. CP18 evidence records test commands, device runs and known limits; a green unit suite alone is not launch approval.
