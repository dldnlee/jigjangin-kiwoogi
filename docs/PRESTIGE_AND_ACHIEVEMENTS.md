# Retirement, permanent progress, achievements

## Retirement

Eligibility: age≥60 OR level≥50. No forced reset; player may continue indefinitely. A preview shows exactly what is lost and retained, liquidation, and Career Points. Retirement settles time first; confirmation carries the preview revision so changed values require refreshing it. Atomic command archives run, liquidates business/investments/life assets for reporting, grants points once, increments completed-run count, sets mode retired. Locked property is valued at its listed liquidation value for this terminal liquidation only; no early-withdrawal command is exposed during normal play.

`earnedPoints = min(1000, integerSqrt(runEarnedWon ~/ 100000))`. If retirement-eligible and this is zero, award one point. `integerSqrt` returns floor square root without double conversion. First-life target is 10–30 points after tuning, not guaranteed by seed math. Lifetime earnings are not used in this formula: previous lives cannot be counted again. Point spending is allowed on the retired screen; new-life command then initializes a new run ID. Replaying retirement or new-life command must not duplicate points or archives.

## Reset matrix

| State | New life |
|---|---|
| Cash, XP, level, age/run time, core upgrades | Reset to configured starting values |
| Rank/company, offers, performance, reputation, stress, cooldowns | Reset |
| Trained skills, owned/equipped mechanical equipment | Reset |
| Investments, life assets, business/staff, founder experience | Reset |
| Event flags, pending choices, unclaimed run missions, run counters | Reset |
| Run earnings, promotion pity, simulation remainders | Reset |
| Lifetime earnings, achievements claimed, cosmetics, archives | Retain |
| Unspent/spent Career Points and permanent upgrade levels | Retain |
| Settings, consent, account link, cosmetic gems/entitlements | Retain |
| Offline ad receipts | Expire run-specific eligibility; retain deduplication history |

Retirement-derived liquidation is not newly earned income for the same retirement reward calculation; freeze eligible earnings before liquidation. Start a new set of deterministic PRNG streams from a persisted seed allocator; never reuse an old run ID.

## Fifteen permanent upgrades

Each upgrade costs `baseCost*(currentLevel+1)` points, cap five levels. Effects are per level unless stated. Tuning must preserve aggregate caps in ECONOMY. None bypasses a skill or rank requirement.

| ID / name | Base cost | Effect |
|---|---:|---|
| head_start / 든든한 출발 | 1 | Starting cash +1000 |
| saved_notes / 업무 노트 | 1 | Income +100 bp |
| fast_learner / 빠른 배움 | 1 | XP +100 bp |
| calm_start / 느긋한 마음 | 1 | Initial mental trained +1 |
| first_network / 첫 인맥 | 1 | Initial talk trained +1 |
| craft_basics / 기본기 | 1 | Initial expertise trained +1 |
| work_habit / 좋은 습관 | 2 | Initial work trained +1 |
| team_memory / 팀의 기억 | 2 | Initial leadership trained +1 |
| lucky_charm / 작은 행운 | 2 | Initial luck trained +1 |
| deep_notes / 심화 노트 | 2 | Income +100 bp |
| study_rhythm / 공부 리듬 | 2 | XP +100 bp |
| rainy_day / 비상금 | 2 | Starting cash +1000 |
| mentor_letter / 멘토 편지 | 3 | Initial reputation +1 |
| organized_desk / 정돈된 책상 | 3 | Initial performance +2 |
| patient_path / 차근차근 | 3 | Income +100 bp |

Beta implements first five; launch fifteen. Starting stats are set from permanent levels once on new-life creation, never incremented on reload. Income bonuses sum (maximum 1,500 bp in this catalogue); XP maximum 1,000 bp. Permanent upgrades bought after retirement affect the next run only; live-run point spending is disabled.

## Achievements and missions

Achievement counters consume committed domain events, not screen impressions. Unique claim key is profile+achievementID; lifetime achievement cash rewards credit current personal wallet once and count as earned income. No reward can be claimed while retired; queue it for next run. Later cosmetic gems require authoritative service receipts and are disabled locally until CP16.

Beta ten achievements: first upgrade, first training, first gear, first promotion, first job switch, first million earned, first investment, first business, first qualifying closure, first retirement. Cash rewards respectively 500,500,1000,2000,2000,5000,5000,10000,5000,10000. Retirement reward is queued for next life. Launch expands to 50 with an audited claim table; achievements cannot grant points directly.

Daily missions are optional, three fixed types: buy three upgrades (reward 1000), resolve two events (1000), earn 10000 eligible won (2000). UTC day boundary is explicit in UI. Mission progress derives from commands and earning committed during that UTC day; offline earnings count on settlement day. No streak penalties or automatic reset of lifetime achievements. Persist highest seen day, do not re-open older days after clock rollback. At upgrade cap replace upgrade mission with “train once”; if all skills capped too, use “resolve one event”. At most one claim per profile/day/mission, across prestige. Missions unlock only after CP13.
