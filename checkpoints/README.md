# Development checkpoints

Implement one checkpoint at a time. All start **Not started**. Use [Codex rules](../docs/CODEX_RULES.md) and [roadmap](../docs/ROADMAP.md) as the entry point. This directory defines work; it does not claim a game has been built or tested.

## Execution order

- [CP00 — Foundation and configuration](CP00_FOUNDATION.md) — v0.1
- [CP01 — Deterministic idle income](CP01_IDLE_CORE.md) — v0.1
- [CP02 — Offline settlement and recovery](CP02_OFFLINE.md) — v0.1
- [CP03 — Skills and training](CP03_SKILLS.md) — v0.1
- [CP04 — Career and promotion](CP04_CAREER.md) — v0.1
- [CP05 — Employers and job offers](CP05_COMPANIES.md) — v0.1
- [CP06 — Equipment and visual progression](CP06_EQUIPMENT.md) — v0.1
- [CP07 — Events and vertical-slice gate](CP07_EVENTS_SLICE.md) — v0.1
- [CP08 — Life, stress and alpha content](CP08_LIFE_ALPHA.md) — v0.2
- [CP09 — Fictional investments](CP09_INVESTMENTS.md) — v0.2
- [CP10 — Founder simulation](CP10_BUSINESS.md) — v0.3
- [CP11 — Failure and comeback identity](CP11_COMEBACK.md) — v0.3
- [CP12 — Retirement and another life](CP12_PRESTIGE.md) — v0.3
- [CP13 — Achievements, missions and journal](CP13_ACHIEVEMENTS.md) — v0.3
- [CP14 — Balance and local-loop proof](CP14_BALANCE_GATE.md) — v0.3
- [CP15 — Optional account, backup and telemetry](CP15_OPTIONAL_BACKEND.md) — services
- [CP16 — Optional rewarded ads and cosmetics](CP16_OPTIONAL_MONETIZATION.md) — services
- [CP17 — Launch content, assets and accessibility](CP17_CONTENT_POLISH.md) — v1.0
- [CP18 — Platform readiness and release candidate](CP18_RELEASE.md) — v1.0
- [CP19 — Content updates and incident readiness](CP19_OPERATIONS.md) — operations

## Dependency branches

CP00 → CP01 → CP02 → CP03 → CP04 → CP05 → CP06 → CP07 is the vertical slice.

CP08 → CP09 → CP10 → CP11 → CP12 → CP13 → CP14 completes and proves the local game.

After CP14, CP17 → CP18 can deliver an offline-only release. Optional CP15 → CP16 adds services; CP18 must verify whichever services are enabled. CP19 follows release readiness. Optional services can be **Not shipped** in a release manifest; do not mark unimplemented checkpoints complete.

## Standard checkpoint contract

Every file contains objectives, dependencies, required reading, requirements, steps, data/game rules, UI, edge cases, tests, acceptance criteria, expected paths, out-of-scope work, and evidence. Change a checkpoint's requirements only with a linked design decision; do not remove failing criteria to manufacture completion.
