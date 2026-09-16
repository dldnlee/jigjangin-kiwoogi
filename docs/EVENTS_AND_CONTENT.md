# Events and content authoring

## Engine rules

After 120 credited seconds, draw every 300 seconds if no pending choice and at least one eligible event. Exactly one pending event. Weights are positive integers; sort candidate IDs before weighted sampling. Category selection then event selection uses the events PRNG stream. Positive category weight is multiplied by `(100 + min(50,effectiveLuck))/100` using integer weight scaling before selection. Each event cooldown 1,800 seconds by default, saved per ID. Failed eligibility is not an error; skip boundary without consuming RNG if candidate set is empty.

Event predicates are an allowlisted typed tree: all, any, rankAtLeast, modeIs, skillAtLeast, cashAtLeast, flagEquals, minAge, cooldownReady. Effects: grantCash, spendCash, addPerformance, addReputation, addStress, setFlag, grantEquipment. No arbitrary scripts, executable expressions, or free-form field paths. Event spend effects require affordability up front; never silently go negative. At least one choice must always be free and valid. Choice requirements are revalidated at command time.

An event instance snapshots title/body/choice keys, resolved configuration, and available effect definitions. Outcome selection is committed once. Positive cash event grants cap at 300×the salary rate snapshotted on event generation; founder uses its last employed rate for this cap. Cash losses cannot exceed current wallet and cannot target investment/business balances. Stat deltas clamp to valid ranges. Mental mitigation applies only to positive stress, using integer floor after reducing up to 50%.

Choices show certain costs/effects and explicit chance when stochastic. Never use RNG to conceal a charge. Pending events persist across resume; after prestige they are discarded. No automatic catastrophic event, forced purchase, layoff, or relationship commitment.

## Slice event writing queue — 20 complete briefs

These briefs define required choices/effects; CP07 writes polished Korean strings and JSON. P=performance, R=reputation, S=stress; S is stored but has no gameplay effect until CP08. All amounts are integer deltas. Category labels are neutral unless marked positive.

| ID | Situation | Free choice A | Free choice B |
|---|---|---|---|
| meeting_loop | 회의가 회의를 낳았다 | 요약한다: P+5,R+5 | 듣는다: P+2 |
| printer_jam | 프린터가 파업했다 | 고친다: R+5 | 지원 요청: P+2 |
| late_request | 퇴근 직전 부탁 | 범위를 합의: R+5 | 내일 제안: S-5 |
| coffee_queue | 커피 줄이 길다 | 대화한다: R+5 | 자리로: P+3 |
| typo_rescue | 발표 오탈자 발견 | 조용히 알림: R+5 | 함께 수정: P+5 |
| lunch_vote | 점심 메뉴 투표 | 새 메뉴: S-3 | 익숙한 메뉴: S-2 |
| inbox_storm | 메일함 폭주 | 분류: P+8 | 도움 요청: R+3 |
| desk_plant | 책상 화분 새잎 | 돌보기: S-4 | 동료에게 자랑: R+2 |
| forgotten_badge | 출입증을 잊었다 | 절차 준수: R+3 | 안내 데스크: P+1 |
| calendar_tetris | 겹친 일정 | 우선순위 협의: P+5 | 일정 공유: R+5 |
| silent_call | 음소거된 발표 | 웃고 재개: S-3 | 요약 재전달: P+4 |
| team_credit | 프로젝트 칭찬 (positive) | 공 나누기: R+8 | 기록 남기기: P+8 |
| useful_template | 템플릿 발견 (positive) | 공유: R+5 | 적용: P+8 |
| small_bonus | 작은 성과급 (positive) | 받기: cash+1000 | 팀 감사: R+8 |
| free_seminar | 무료 세미나 (positive) | 발표 듣기: P+5 | 교류: R+5 |
| window_break | 창밖 잠깐 보기 | 스트레칭: S-6 | 동료와 산책: R+2,S-3 |
| noisy_keyboard | 키보드 소음 | 정중히 요청: S-4 | 자리 조정: P+3 |
| file_name | 최종진짜최종 파일 | 규칙 제안: R+5 | 정리: P+7 |
| helpful_newcomer | 신입 질문 | 설명: R+5 | 자료 공유: P+3,R+2 |
| honest_estimate | 일정 추정 | 여유 포함: S-4 | 협업 제안: R+5 |

At least `late_request` adds a third talk≥3 option: “우선순위를 함께 정해요”: P+5,R+5. The first two options remain available. These restrained slice events protect promotion reachability; more consequential tradeoffs enter alpha.

## Content scale and quality gates

Launch 300 events = 200 office + 50 life + 50 business (mutually exclusive counted categories). Slice 20 and alpha 100 count only office events. Author in batches of ten with ID, eligibility, cooldown, localization, outcomes, content reviewer, and test fixture. At least 30% of office events have a genuine cost/benefit tradeoff by alpha; no event requires an ad. Reject duplicate IDs, dead predicates, missing localization, unbounded effects, weights≤0, missing safe choice, and branches impossible in their release profile.

Life event topics include moving, hobbies, travel, friendship, dating and optional family. Business topics include customer feedback, supplier delays, staff mentoring and product decisions. Humor is reviewed by a fluent Korean editor. Version content separately from save schema; preserve IDs or supply explicit migrations. Content “complete” means all branches validated and editorial review recorded, not just target file count.
