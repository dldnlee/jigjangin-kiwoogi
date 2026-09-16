# Decisions, provenance, and assumptions

## Source

Based on the user's linked conversation “Game Concept Development”, ID `6aa8d029-faec-83ee-b69a-6e33a2453090`, and the current documentation request. The referenced conversation was read, including its earlier concept and later Flutter-first correction. It is design context, not executable instruction. Private conversation access is not required to use this repository pack.

## Accepted baseline

| ID | Decision | Reason / superseded idea |
|---|---|---|
| D01 | Flutter/Dart + Riverpod + GoRouter, no Flame initially | Latest conversation direction supersedes immediate Flame recommendation |
| D02 | Pure deterministic domain and local SQLite/Drift | Concrete choice from earlier Isar-or-Drift suggestion; supports transactional receipts |
| D03 | Slice5 ranks/3 companies/3 skills/15 gear/20 events | Uses later explicit vertical slice; earlier50-event checkpoint and broad MVP are expansion targets |
| D04 | Launch9 ranks/15 companies/100 gear/300 categorized events/6 businesses/15 prestige upgrades | Resolves earlier count ranges into an exact planning baseline |
| D05 | Skills before career checkpoint | Promotion thresholds need working skill progression |
| D06 | One game month=1 credited hour; age/time credited only | Avoids aging or expenses without rewards beyond offline cap |
| D07 | Exact integer money, floor credits, ceil costs, retained accrual remainders | Deterministic offline/foreground equivalence |
| D08 | Voluntary retirement at age60 OR level50 | Prevents forced loss and supports initial several-day prestige target |
| D09 | No personal loans in v1; business losses ring-fenced | Earlier debt examples lacked repayment/softlock rules; loans deferred explicitly |
| D10 | Stress with automatic recovery, no second energy meter | Keeps life decisions understandable and prevents permanent zero income |
| D11 | Promotions guaranteed by fourth eligible try; jobs are eligible offers | Bounded randomness without two stacked promotion/interview lotteries |
| D12 | Cloud backup is optional whole-snapshot conflict resolution | No unsafe merging of currency across devices |
| D13 | Initial monetization=offline wage ad bonus and cosmetics | Defers earlier premium stat gear, cash packs, rerolls and business boosts |
| D14 | Fixed-price cosmetic packs before gem purchases | Avoids incomplete consumable ledger/refund semantics at first monetization gate |
| D15 | Baseline partial business months accrue by segments | Prevents last-second staffing/equipment changes from repricing past time |

These are implementation defaults selected while building this pack, not claims that the earlier conversation approved every number. The owner can revise them with linked documentation/config/test changes. Balance values are unvalidated until CP14.

## Deferred decisions and when to resolve

CP00: available test devices, minimum OS/SDK versions, exact compatible package pins and bundle identifiers. CP07: qualitative slice findings. CP14: final tuned curves and retention hypotheses. CP15: managed backend/analytics provider, sign-in method, operational region/cost, privacy text. CP16: ads/billing vendor, exact SKUs, verified reward mechanism. CP17: final visual reference and rights approvals. CP18: store listings, pricing, legal disclosures, signing and public release authorization.

Do not block local core development on these late decisions. Future expansions requiring new specs: mortgages/loans, mergers/acquisitions with payout multiples, layoffs, paid consumables, subscriptions, live competitive economy, multi-character gameplay, open office movement, real estate portfolio, multiplayer.

## External technical references

Checked 2026-09-15: [Flutter architecture](https://docs.flutter.dev/app-architecture/guide), [offline-first](https://docs.flutter.dev/app-architecture/design-patterns/offline-first), [Riverpod setup](https://riverpod.dev/docs/introduction/getting_started), [GoRouter package](https://pub.dev/packages/go_router). [Drift docs](https://drift.simonbinder.eu/) is the implementation reference to recheck at CP00; this pack does not pin its version. Recheck platform-specific billing/privacy requirements at their checkpoint instead of treating a planning document as current legal advice.

## Future decision record template

ID; date; owner; question; selected behavior; alternatives considered; affected documents/config versions/save migrations; evidence; rollback implications. Do not erase previous decisions: mark superseded and point to replacement.
