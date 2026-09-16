# UI/UX specification

## Visual direction

Warm, readable 2D office illustration: cream backgrounds, dark ink text, muted teal actions, amber income highlights. Candidate tokens: background #F7F3EB, surface #FFFFFF, ink #202833, primary #176B62, warning #8A4B00, error #B3261E. Verify contrast in implementation; never assume a palette alone is accessible. Rounded panels, restrained outlines, Korean sans-serif font with licensed Hangul coverage. Standard eight-point spacing scale (4,8,12,16,24,32); body 16sp, secondary 14sp, numeric balance 28sp. Touch targets at least 48×48 logical pixels.

Portrait baseline 390×844 logical pixels; support 320×568 through large phones and safe areas. Layout scrolls instead of shrinking text; support 200% text scale and screen readers. Tablet uses centered content max width600 with decorative margins. No critical text baked into raster art. Show chance and rarity with words/icons as well as color.

## Navigation and screen contracts

Five final tabs: 업무 `/office`, 커리어 `/career`, 자산 `/assets`, 인생 `/life`, 더보기 `/more`. Slice shows 업무/커리어/더보기; skills and gear are accessible from office shortcuts and more. Locked future tabs are hidden until their implementation ships, then reveal with stated unlock conditions. GoRouter redirects inaccessible deep links to a lock explainer or safe office screen; never assumes a business object exists.

| Route / screen | Required content and primary action | Empty/locked/error behavior |
|---|---|---|
| /boot | Progress and recovery state | Retry, export, or explicit reset after recovery fails |
| /office | Name/rank/company, cash, net rate, XP, scene, 3 upgrades, next goal | Ready without art/network; placeholders preserve layout |
| /career | Current ladder, thresholds, probability, pity, cooldown | Highest rank state; no hidden probability |
| /career/offers | ≤3 employer comparison cards; accept | Countdown to next batch; expired cards explain refresh |
| /skills | Levels, effects and single train button per skill | At cap; insufficient cash; prerequisite link |
| /equipment | Shop/inventory, slots, modifiers; buy/equip | Empty slot, owned, locked, price changed states |
| /events/:id | Narrative, 2–4 options, outcomes/costs | Already resolved returns journal; safe option always enabled |
| /assets | Cash/net worth breakdown, investments, founder shortcut | Definitions distinguish spendable cash and value |
| /assets/investments/:id | Model outcomes, quote, units, fees, holdings; buy/sell | Invalid input, stale quote, property lock countdown |
| /business | Capital, revenue, expenses, cash runway, staff, upgrades | Employed: founding choices; closed: archive and comeback |
| /business/found | Eligibility, capital at risk, employment ends; confirm | Unaffordable capital or skill reason |
| /life | Age, stress/recovery, housing/transport, free break | Explain auto-recovery; no energy bar |
| /retirement | Eligibility, recap, reset matrix, points preview; confirm | Stay in current life is equally visible |
| /prestige | Point balance, permanent upgrades; new life | No live-run spending |
| /achievements | Progress, claim, journal | Claimed/queued for next run states |
| /shop | Cosmetics only when service enabled | Offline catalogue cache; disabled purchase with clear reason |
| /settings | Audio, haptics, motion, language, export, consent, support | Settings persist without account |

## Office hierarchy

Top safe area: profile and settings. Financial header: cash, ₩/s, XP bar. Middle 35–40%: layered office and worker, optional quiet speech bubble. Bottom: next-goal panel and three upgrade cards, then navigation. Upgrades show current level, cost, benefit and unaffordable reason; never just “+power”. Compact mode prioritizes controls over scene height. Repeated income text is throttled to one visual burst/s and excluded from live accessibility announcements.

## Sheets and confirmation

One presentation queue with priority: save/recovery blocking error → retirement/closure recap → offline summary → event notification → ordinary toast. Business failure changes state immediately even if its recap is queued. Never stack modal dialogs. Pending events can be dismissed to a badge and reopened; this is not choice resolution. Back respects unsent investment amounts but does not pause time.

Confirmation required for founding, voluntary closure, retirement/new life, import/reset and purchases of real-money products. Routine upgrades/equip/training execute on one tap. Disable duplicate submit while command pending; announce success only after commit. Error messages explain how to continue and never expose stack traces.

## Korean copy examples

- Offline heading: “자리를 비운 동안”; body “보상이 이미 반영됐어요.”; action “계속하기”.
- Promotion: “승진 가능성 70% · 최대 4번째 평가에서 확정”.
- Funds: “₩2,000이 더 필요해요”.
- Business: “창업 자금만 위험에 노출돼요. 개인 자산은 유지돼요.”
- Closure: “이번 사업은 여기까지. 경험은 남았어요.”
- Retirement: “현재 인생을 마치고 새 인생을 준비할까요?”

## Accessibility and feedback

Semantic labels include amounts and units; announce milestone changes once. Reduced motion swaps celebration for static banner; respects OS preference plus saved override. Haptics/music/effects individually optional. No flashing effects. Use locale-aware plurals/particles where appropriate and grapheme-safe truncation. Production Korean copy receives human review. No forced tutorial overlays that prevent passive earning; guided hints skip and resume persistently.
