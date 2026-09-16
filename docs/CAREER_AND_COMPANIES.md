# Career and companies

## Rank ladder

| ID | Korean | Base ₩/s | Level | Performance | Work / expertise | Reputation |
|---|---|---:|---:|---:|---|---:|
| new_hire | 신입 | 100 | 1 | 0 | 0 / 0 | 0 |
| employee | 사원 | 180 | 2 | 30 | 1 / 0 | 0 |
| junior | 주임 | 300 | 4 | 60 | 3 / 2 | 5 |
| assistant_manager | 대리 | 500 | 7 | 100 | 5 / 3 | 10 |
| manager | 과장 | 900 | 10 | 160 | 8 / 5 | 20 |
| deputy_general | 차장 | 1600 | 15 | 220 | 12 / 8 | 30 |
| general_manager | 부장 | 2800 | 20 | 300 | 16 / 12 | 40 |
| executive | 임원 | 5000 | 30 | 400 | 22 / 18 | 60 |
| ceo | 전문경영인 | 9000 | 40 | 500 | 30 / 25 | 80 |

Thresholds apply to the target rank. Slice uses ordered IDs new_hire→employee→assistant_manager→manager→general_manager with slice config thresholds 0,30,60,100,160 and levels 1,2,4,7,10; work/expertise pairs 0/0,1/0,3/1,5/2,8/3; reputation 0,0,5,10,20. These are separate versioned config profiles, not runtime rank skipping. Promoting always uses the next ID in the profile's ladder. Existing slice saves migrate by stable rank ID when switching to alpha.

Performance starts 0, rises `6 + effectiveWork~/10` per credited minute, cap 1,000. Reputation starts 0, rises +5 for each successful promotion, plus events; cap 1,000. Slice seed events must supply at least one free repeatable +5 reputation option to avoid a gate deadlock. Promotion success sets performance to 0, retains level/skills/reputation, resets failure count for this target. Company switching resets performance but preserves rank-target pity.

## Evaluation

All thresholds must pass before attempting. No cash fee. Cooldown 120 credited seconds, starts on attempt. `pBp = min(10000, max(1000, 7000-companyDifficultyBp + 50*effectiveLuck) + 1000*failureCount)`; failureCount belongs to run+targetRank. Employer difficulty range 0–2,000. Fourth eligible attempt is always successful (if failureCount≥3, p=10000). Show chance and guarantee before rolling. Promotion never rolls passively/offline. Attempt is atomic with cooldown, PRNG, and result. Top rank view shows “최고 직급” rather than an unusable button.

## Employers

Generate at most three offers, every 600 credited seconds after employee rank; no more than one generation batch per boundary, deterministic ordered sampling without replacement. An offer lasts 1,800 credited seconds, snapshots employer terms/config version, and never expires due to uncredited time. Application checks expertise requirement; eligible offers are guaranteed offers, not another interview lottery. Negotiation is a single deterministic +min(1,000,50*effectiveTalk) salary bp added to the employer salaryBp and stored on acceptance. No reroll button at baseline.

| Employer ID / name | Salary bp | Difficulty bp | Stress/min | Expertise min | Profile |
|---|---:|---:|---:|---:|---|
| paper_sprout / 종이새싹 | 10000 | 0 | 1 | 0 | Starter; permanent fallback |
| moon_mug / 달빛머그 | 12000 | 500 | 1 | 2 | Comfort |
| cloud_step / 구름계단 | 15000 | 1500 | 3 | 4 | Slice high reward |
| quiet_code / 고요코드 | 14000 | 500 | 1 | 6 | Alpha |
| amber_labs / 호박빛연구소 | 17000 | 1000 | 2 | 8 | Alpha |
| river_pixel / 강물픽셀 | 19000 | 1000 | 2 | 10 | Alpha |
| orbit_table / 궤도테이블 | 22000 | 1500 | 3 | 12 | Alpha |
| mint_engine / 민트엔진 | 24000 | 1500 | 3 | 15 | Alpha |
| dawn_archive / 새벽기록 | 21000 | 500 | 1 | 18 | Alpha |
| blue_lantern / 파란등불 | 28000 | 2000 | 4 | 20 | Alpha |
| pebble_network / 조약돌네트워크 | 26000 | 1000 | 2 | 23 | Launch |
| forest_signal / 숲속신호 | 30000 | 1500 | 3 | 26 | Launch |
| silver_stair / 은빛계단 | 32000 | 2000 | 4 | 30 | Launch |
| morning_orbit / 아침궤도 | 29000 | 1000 | 2 | 32 | Launch |
| star_ledger / 별빛장부 | 35000 | 2000 | 4 | 35 | Launch |

All names are fictional working names; production checks for confusing similarity. Offer acceptance first settles time, verifies mode and expiration, then switches employer and snapshots negotiated salary bp. No moving fee, unemployment gap, or automatic layoff in baseline. Once accepted, clear all offers; cooldown generation schedule remains. Company “stability” is flavor until a separately designed layoff system; do not display meaningless numerical stats. Company's office theme is cosmetic and cannot change economic calculations.
