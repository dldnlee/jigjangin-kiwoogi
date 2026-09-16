# Skills, upgrades, and equipment

## Skill effects

All training levels 0–100; effective level with gear 0–150. Slice enables work, expertise, talk; alpha enables all six. Disabled skills contribute zero and their UI is hidden.

| ID / label | Consequence one | Consequence two |
|---|---|---|
| work / 업무력 | +100 bp salary per effective level | +1 performance/min per 10 levels |
| expertise / 전문성 | +20 milli-XP/s per level | Employer and founder eligibility |
| talk / 말빨 | Negotiated salary +50 bp/level, cap 1,000 | Extra event option at configured thresholds |
| mental / 멘탈 | Reduce stress gain by one per 10 levels | Mitigate event stress gain by min(50%, level%) |
| leadership / 리더십 | Business revenue multiplier +100 bp/level | Founder and staff tier eligibility |
| luck / 운 | Promotion chance +50 bp/level | Positive event category weight +min(50,level)% |

Work speed/efficiency/focus are purchasable core upgrades, not extra skill stats. Preview every training purchase with price and the currently affected mechanics. Cap purchases return a typed `atCap` result without deducting cash. Flat equipment bonuses do not reduce future training prices or count as trained levels for achievements.

## Equipment model

Seven wearable/device slots: laptop, phone, suit, shoes, watch, bag, accessory. Desk and chair are office scenery upgrades unlocked by ranks; cars belong to life. No durability, random affixes, enchantment failures, consumables, resale, or gacha in baseline.

Each item has stable ID, slot, display key, rarity, price, unlock rank, flat skill modifiers, incomeBp (optional), icon ID, visual attachment ID (optional). Rarity is a presentation tier (`common`, `uncommon`, `rare`, `epic`, `legendary`), not an extra multiplier. Price and stats are explicit config values. Own at most one of each ID. Buy and equip are separate commands; “구매 후 장착” is one atomic compound command. At most one equipped per slot. Equip/unequip first settles income and recalculates from base, never applies/subtracts cumulative modifiers.

## Slice catalogue — 15 items

All prices in won; unlock ranks use the slice ladder. Skill abbreviations are canonical IDs.

| ID | Slot | Price | Unlock | Modifiers |
|---|---|---:|---|---|
| laptop_01 | laptop | 2000 | new_hire | work +1 |
| laptop_02 | laptop | 12000 | employee | work +3 |
| laptop_03 | laptop | 60000 | assistant_manager | work +6, incomeBp +200 |
| phone_01 | phone | 2500 | new_hire | talk +1 |
| phone_02 | phone | 15000 | employee | talk +3 |
| suit_01 | suit | 3000 | new_hire | talk +1 |
| suit_02 | suit | 18000 | employee | talk +4 |
| shoes_01 | shoes | 2000 | new_hire | work +1 |
| shoes_02 | shoes | 14000 | employee | work +3 |
| watch_01 | watch | 4000 | employee | expertise +1 |
| watch_02 | watch | 24000 | assistant_manager | expertise +3 |
| bag_01 | bag | 2500 | new_hire | expertise +1 |
| bag_02 | bag | 16000 | employee | expertise +3 |
| accessory_01 | accessory | 3500 | new_hire | work +1, talk +1 |
| accessory_02 | accessory | 20000 | assistant_manager | work +2, expertise +2 |

Use item_01 common, item_02 uncommon, laptop_03 rare. Korean item names are fictional, e.g. 중고 노트북, 조용한 키보드, 구김 적은 셔츠. Do not use commercial hardware marks. Only laptop/suit/bag/accessory require scene variants; other items can remain icons with visible slot feedback. Expand to 50 and 100 authored items with explicit values in later content gates.
