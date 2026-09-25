# Feature checklist

This is the living roadmap. Update it in every commit that adds or extends a feature. Work in order unless a dependency or a documented bug warrants changing priority. Split large features into independently playable increments; do not mark a whole feature complete for a partial implementation.

## Before the next feature

- [x] Establish a reproducible visual-test baseline. On 2026-09-25, Flutter 3.47.0 / Dart 3.13.0 passed analysis and 13 tests; two tests failed on golden comparisons. Resolved with individually reviewed macOS baselines on Flutter 3.47.0; original references retained. `python3 tools/verify.py` handles external-volume metadata safely.
- [x] Audit sprites in motion: worker typing/stress/celebration/report, boss walking both directions and gesturing, and all four room tiers. Reviewed source sheets, six scene previews, all room tiers, and the recorded simulator cycle. No new clipping or scale regressions found; existing subtle typing and edge halos remain cosmetic polish opportunities. Worker rendering now derives aspect ratio from its own atlas.

## Features, in delivery order

- [x] **F01 — Projects with tradeoffs:** ship a Friday presentation with solo, collaborative, and rushed approaches; show costs and rewards; persist active/completed state; prevent duplicate rewards. Delivered all three assignments with seven approaches, saved outcomes, offline progress, reward collection, and journal results. Entry points: 업무 업그레이드 → 프로젝트로 성과 쌓기, or 커리어. Completed projects are one-time assignments.
- [ ] **F02 — Coworker relationships:** introduce recurring named coworkers, persistent relationship values, remembered choices, dialogue, and modest perks. Connect them to projects.
  - [x] Increment 1: three named coworkers (박 선배, 김 대리, 이 인턴) with 0–100 friendship, two chat topics each (favourite topic +5, other +3), paid coffee (+8, ₩1,500), five-minute per-coworker cooldown, remembered last topic changes their greeting, tiers, journal entries. Friendship 30 grants a project perk (success +10%p / prep −15% / reward +10%) captured when a project starts. Collaborative (말빨) approaches raise every friendship on collection. Entry: 커리어 or 업무 업그레이드 → 동료와 가까워지기.
  - [ ] Next: coworker-specific dialogue events/requests that remember choices across multiple scenes, and a higher (70) tier perk.
- [x] **F03 — Office customization:** delivered 13 milestone-unlocked choices across room themes, desk finishes, plants, and cats. Temporary live preview (including locked items), explicit free apply, reversible selections, automatic room progression option, and save/backup persistence. Reuses reviewed art with fixed desk and character anchors. Entry: 장비 → 사무실 꾸미기 or 업무 업그레이드. Implemented next at user request to work on something else after coworker work.
- [ ] **F04 — Connected story events:** multi-stage workplace stories with saved decisions, prerequisites, delayed consequences, and journal history.
- [ ] **F05 — Stress and recovery:** clear overtime tradeoffs, coffee breaks and recovery; bounded effects; no punishment simply for being away; explain effects before choices.
- [ ] **F06 — Career specializations:** specialist, manager, and consultant paths with distinct skills, events, and progression. Explain path decisions and preserve existing saves.
- [ ] **F07 — Life outside work:** apartment and hobby goals funded by career progress; persistent unlocks and visible rewards; keep the first increment small.
- [ ] **F08 — Retirement and a new career:** a clear end-of-career milestone, explicit reset confirmation, retained knowledge/contacts, and a meaningful new run. Preserve backups and avoid accidental loss.

## Completion requirements for every increment

Use this template for each delivery; these boxes are not global roadmap status.

- [ ] Playable UI and complete gameplay behavior, including Korean copy.
- [ ] Existing saves load safely; new state persists and backup import/export still works.
- [ ] Relevant behavior tests and static analysis pass; regressions resolved.
- [ ] Inspect the actual sprite sheets used, frame bounds, aspect ratios, transparency, anchors, relative character/furniture scale, and layer order.
- [ ] Run the app and watch affected animations through full loops, including transitions and boss arrival/departure where relevant. Check 320- and 390-logical-pixel layouts, reduced motion, and background/resume behavior.
- [ ] Review visual-test differences individually. Do not accept new goldens solely to make tests pass.
- [ ] Update this checklist and the delivery log with scope, validation, visual evidence, remaining work, and blockers.
- [ ] Commit scoped changes and push successfully; record branch and commit in the task report. Never claim a failed push succeeded.

## Delivery log

| Date (Asia/Seoul) | Increment | Validation and visual review | Remaining work |
|---|---|---|---|
| 2026-09-25 | Roadmap and daily development workflow established | iPhone 17 Pro launch verified; static worker and boss sheets inspected. Worker typing poses have little visible variation; boss frames have tight top padding and visible edge artifacts worth checking in motion. Full motion audit remains pending. | Baseline golden failures and sprite audit before F01. No new gameplay feature delivered yet. |
| 2026-09-25 | F01 — Projects with tradeoffs | Three linked projects, seven approaches, Korean board/countdowns/results; old-save migration, dedicated deterministic RNG, SQLite and backup round trips, replay protection. iPhone 17 Pro start → wait → collect verified; 320/390 UI flows tested. Fixed invisible progress fill. Reviewed macOS scene baselines and simulator animation recording. Validation: `python3 tools/verify.py` (27 tests, clean analysis). | F02 coworker relationships next. Sprite edge cleanup and richer typing frames are optional polish, not added in this delivery. |
| 2026-09-25 | F02 increment 1 — Coworker chats, memories and project perks | Old saves without coworker fields load; invalid friendship/topic/cooldown values rejected; perks persist in the saved project run and are unaffected by later friendship changes; 320/390 widget flows for chat, memory, cooldown, coffee and SQLite reload. iPhone 17 Pro: existing save loaded, sheet opened from 커리어, chat updated line/meter/cooldown. Office scene and sprites untouched; goldens passed unchanged. Validation: `python3 tools/verify.py` (35 tests, clean analysis). | Multi-scene coworker requests with remembered decisions; 70-tier perk. No coworker sprites yet (text-only cards). |
| 2026-09-25 | F03 — Office customization | 13 cosmetic choices; free level/promotion unlocks; locked-item preview; explicit apply; optional animation preview respecting reduced motion. Old saves keep their original scene; SQLite and backup round trips covered. Inspected original atlas and four new decorated-room references; default goldens retained unchanged. Simulator: preview, apply, animation, and relaunch checks. Validation: `python3 tools/verify.py` (44 tests, clean analysis). | F02 follow-up remains as recorded by the coworker implementation; F04 is the next independent roadmap feature. No new sprite art generated. |

For each delivery, append a row and mark only completed scope above. Add sub-checklists under a feature when it spans multiple runs. If work is blocked, record the exact blocker and next action here. Once all approved features are complete, report completion and pause the daily automation rather than inventing unrelated features.
