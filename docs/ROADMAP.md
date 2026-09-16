# Implementation roadmap

All implementation checkpoints are **Not started**. Documentation completion is separate from implementation completion. No delivery-date estimate is asserted before the repository, available devices, assets and team capacity are known.

## Work and gates

| Checkpoint | Deliverable | Dependency | Status |
|---|---|---|---|
| [CP00](../checkpoints/CP00_FOUNDATION.md) | Foundation and configuration | None | Not started |
| [CP01](../checkpoints/CP01_IDLE_CORE.md) | Deterministic idle income | CP00 | Not started |
| [CP02](../checkpoints/CP02_OFFLINE.md) | Offline settlement and recovery | CP01 | Not started |
| [CP03](../checkpoints/CP03_SKILLS.md) | Skills and training | CP02 | Not started |
| [CP04](../checkpoints/CP04_CAREER.md) | Career and promotion | CP03 | Not started |
| [CP05](../checkpoints/CP05_COMPANIES.md) | Employers and job offers | CP04 | Not started |
| [CP06](../checkpoints/CP06_EQUIPMENT.md) | Equipment and visual progression | CP05 | Not started |
| [CP07](../checkpoints/CP07_EVENTS_SLICE.md) | Events and vertical-slice gate | CP06 | Not started |
| [CP08](../checkpoints/CP08_LIFE_ALPHA.md) | Life, stress and alpha content | CP07 | Not started |
| [CP09](../checkpoints/CP09_INVESTMENTS.md) | Fictional investments | CP08 | Not started |
| [CP10](../checkpoints/CP10_BUSINESS.md) | Founder simulation | CP09 | Not started |
| [CP11](../checkpoints/CP11_COMEBACK.md) | Failure and comeback identity | CP10 | Not started |
| [CP12](../checkpoints/CP12_PRESTIGE.md) | Retirement and another life | CP11 | Not started |
| [CP13](../checkpoints/CP13_ACHIEVEMENTS.md) | Achievements, missions and journal | CP12 | Not started |
| [CP14](../checkpoints/CP14_BALANCE_GATE.md) | Balance and local-loop proof | CP13 | Not started |
| [CP15](../checkpoints/CP15_OPTIONAL_BACKEND.md) | Optional account, backup and telemetry | CP14 | Not started |
| [CP16](../checkpoints/CP16_OPTIONAL_MONETIZATION.md) | Optional rewarded ads and cosmetics | CP15 | Not started |
| [CP17](../checkpoints/CP17_CONTENT_POLISH.md) | Launch content, assets and accessibility | CP14 | Not started |
| [CP18](../checkpoints/CP18_RELEASE.md) | Platform readiness and release candidate | CP17 | Not started |
| [CP19](../checkpoints/CP19_OPERATIONS.md) | Content updates and incident readiness | CP18 | Not started |

## Milestone review

**v0.1 / CP07:** a complete 30–60min employment slice with observed comprehension. Rework core affordances before adding complexity if this gate fails.

**v0.2 / CP09:** six skills, full rank ladder, life and investments, several-day progression. No backend dependency.

**v0.3 / CP14:** two consecutive lives, deterministic founder success/failure, tested prestige, balance reports and playable nonpaying paths. All local mechanics complete.

**Services / CP15–CP16:** optional cloud/telemetry then optional rewarded ad/cosmetics. Requires CP14. If providers or credentials are unavailable, continue independent CP17 polish and keep services disabled.

**v1.0 / CP17–CP18:** full planned content and assets, accessibility, platform builds, migrations and release operations. Public release is separate from preparing a candidate.

**Operations / CP19:** rehearsed update/recovery workflows and one content batch. No recurring automation is created by these instructions.

## Planning rhythm

Break a large checkpoint into internal commits: contract/test, domain, UI/content, verification. Keep checkpoint-level acceptance intact. Content/art can be produced alongside engineering by an actual team when available; this plan does not itself delegate work. Record effort estimates after CP00 and revise using completed checkpoints rather than assuming every checkpoint costs the same.

## Risk register

| Risk | Early signal | Response |
|---|---|---|
| Core feels like chores | Testers cannot name next goal | Rework CP01/CP07 before expansion |
| Economy compounds too quickly | Rank/wealth targets skip bands | CP14 seed sweeps, change one factor family |
| Save/reward duplication | Repeated callbacks change wallet | Atomic receipts, block release |
| Art volume overwhelms scope | Unapproved manifests accumulate | Approve reference sheet, reuse declared assets, explicit re-scope |
| Life/business feels punitive | Players stop after stress/closure | Verify automatic recovery and guaranteed wages |
| Mobile performance degrades | Idle frame/replay budget fails | Profile scene/rebuilds, optimize pure replay before adding engine |
| Services delay core | Accounts required to launch | Keep adapters optional and local-first |
| Incomplete platform testing | Only one simulator build | Track device/macOS dependency before candidate gate |

## Progress record

For each completed checkpoint add date, commit, config/schema versions, test summary, device evidence and issue links. For changed scope add a decision ID. Do not backfill fabricated historical measurements.
