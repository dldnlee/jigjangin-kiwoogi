# 직장인 키우기 — repository documentation pack

Version1.0 · 2026-09-15 · Korean office-worker career/life idle RPG.

## Start here

Copy this pack's `docs/` and `checkpoints/` directories to the repository root. In an existing repository, review file conflicts rather than overwriting its policies. The pack contains design and development instructions, not application code or final asset binaries.

1. Read [Product specification](PRODUCT_SPEC.md) and [Decisions](DECISIONS.md).
2. Read [Architecture](ARCHITECTURE.md), [Economy](ECONOMY.md), [Data contracts](DATA_SCHEMA.md), and [Codex rules](CODEX_RULES.md).
3. Start [CP00 — Foundation](../checkpoints/CP00_FOUNDATION.md).
4. Follow [Checkpoint index](../checkpoints/README.md); record evidence in [Roadmap](ROADMAP.md).

## Complete index

### Game and content

- [Product scope](PRODUCT_SPEC.md)
- [Core/meta loops](GAME_DESIGN.md)
- [Economy and arithmetic](ECONOMY.md)
- [Time and offline simulation](TIME_AND_OFFLINE.md)
- [Career and companies](CAREER_AND_COMPANIES.md)
- [Skills and equipment](SKILLS_AND_EQUIPMENT.md)
- [Events and content briefs](EVENTS_AND_CONTENT.md)
- [Life and investments](LIFE_AND_INVESTMENTS.md)
- [Business and comeback](BUSINESS_AND_COMEBACK.md)
- [Prestige and achievements](PRESTIGE_AND_ACHIEVEMENTS.md)

### Engineering and production

- [Architecture](ARCHITECTURE.md)
- [Data schemas](DATA_SCHEMA.md)
- [Save and recovery](SAVE_AND_RECOVERY.md)
- [UI/UX](UI_SPEC.md)
- [Complete asset work order](ASSET_MANIFEST.md)
- [Asset production requirements](ASSET_PRODUCTION.md)
- [Testing](TESTING.md)
- [Analytics](ANALYTICS.md)
- [Balancing](BALANCING.md)
- [Optional backend and monetization](BACKEND_AND_MONETIZATION.md)
- [Release and operations](RELEASE_AND_OPERATIONS.md)

### Working agreement

- [Roadmap](ROADMAP.md)
- [Codex development rules and starter prompt](CODEX_RULES.md)
- [Decisions and source references](DECISIONS.md)
- [Documentation validation report](PACK_VALIDATION.md)

## What is fixed and what is provisional

The stack, offline-first boundary, integer arithmetic, idempotent rewards and staged scope are baseline requirements. Numerical balance values are explicit seed values pending simulation and playtests. Content counts are work targets: this pack provides seed catalogues and briefs plus production requirements, not all300 polished events or100 finished equipment icons. Exact package pins, final service vendors and store requirements are resolved in their checkpoint.

The conversation's broad idea is preserved, while ambiguous rules have concrete defaults documented in DECISIONS. Personal loans, layoffs and paid progression are deferred explicitly. Optional Flame stays confined to the office renderer if future profiling justifies it.

## Vocabulary

Run/life: one career before retirement. Credited time: elapsed time actually simulated after the offline cap. Profile/meta: progress retained across lives. Career Points: permanent-upgrade currency. Basis point:1/100 of a percent. Receipt: durable record proving an action or reward was already processed. Config profile: slice/alpha/beta/launch content bundle, not a player account.
