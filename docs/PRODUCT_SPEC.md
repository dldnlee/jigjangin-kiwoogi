# Product specification — 직장인 키우기

Specification version: 1.0 · 2026-09-15 · Status: implementation baseline, unvalidated balance.

## Promise

A Korean office worker builds a career and a life through small, satisfying decisions. Earn automatically, improve abilities and possessions, get promoted or change employers, invest, become a founder, recover from failure, and retire into a stronger next career.

Portrait iOS/Android, single player, Korean first, 30-second to five-minute visits. Intended audience: adults familiar with Korean office life. The visual center is one animated worker at a desk. No movement controls, combat, physics, or explorable office are required.

## Design pillars

1. Every visit offers a readable next goal and a meaningful affordable action.
2. Status changes are visible in the worker, desk, office, title, and career history.
3. Employment, investing, and founding are alternative paths with tradeoffs.
4. Failure produces a recoverable story. Neither debt nor bad luck can permanently block play.
5. Time away is respected. No mandatory ads, attendance penalties, or forced retirement.
6. All progression runs offline; the optional network layer must not become a launch dependency for basic play.

## Scope and milestones

| Milestone | Content and behavior | Gate |
|---|---|---|
| v0.1 vertical slice | 1 worker, 3 employers, 5 ordered ranks, 3 skills, 3 upgrades, 15 equipment items, 20 events, promotion, job switching, offline save | CP00–CP07; 30–60 minute session study |
| v0.2 alpha | 9 ranks, 10 employers, 6 skills, 50 equipment, 100 office events, life and fictional investments | CP08–CP09; several days of simulation |
| v0.3 complete local loop | 3 business types, employees, failure/comeback, retirement/prestige, achievements/missions | CP10–CP14; repeatable complete life |
| Service preview | Optional account/cloud save and opt-in telemetry | CP15 |
| Monetization preview | Rewarded ad bonus and cosmetics only initially | CP16; core gate remains mandatory |
| v1.0 release candidate | 15 employers, 9 ranks, 100 equipment, 200 office + 50 life + 50 business events, 6 business types, 50 achievements, 15 prestige upgrades | CP17–CP18 |
| Operations | Safe content updates and incident response | CP19 |

Counts are exact baseline targets, not already authored content. The pack specifies implementation and production work; it contains neither a finished game nor all 300 event scripts. Launch can be re-scoped by an explicit decision record; do not silently call the slice a complete launch.

## Player and content defaults

Start at age 22, level 1, ₩0, rank `new_hire`, employer `paper_sprout`, no owned gear, all skills/upgrades level 0. Default character label 김사원; optional local name, 1–12 grapheme clusters, never telemetry. Starting office props are scenery, not owned equipment. First income is ₩100 per credited real second.

Korean copy uses warm workplace satire. Joke about unclear meetings and last-minute requests; avoid real corporate marks, humiliation of protected groups, or suggesting abusive work is necessary for success. Relationships and parenting are optional life stories with equally viable single/no-child choices. No real financial instruments or real-money trading.

## Product boundaries

No multiplayer, leaderboard, gambling/gacha, player trading, subscriptions, push notifications, or paid progression at baseline. Gems are reserved for later cosmetics; not visible in the slice. Optional Flame is a rendering decision only. The game must boot and recover a local save without accounts, internet, ads, or remote configuration.

## Success hypotheses

These are internal hypotheses, not industry benchmarks: at least 4 of 5 observed slice testers independently identify their next goal within 30 seconds; 4 of 5 purchase an upgrade without instruction; no observed unrecoverable progression or save loss. Recruit 10–20 people for a second qualitative round before adding paid services. Retention decisions use the cohort definitions in [ANALYTICS.md](ANALYTICS.md), with uncertainty and sample size reported.
