# Life, age, comfort, and fictional investments

## Life

Age derives from credited simulation time ([ECONOMY.md](ECONOMY.md)); age 60 invites retirement but never ends play. Visual age milestones are flavor and never reduce output. Slice hides aging UI, while `runSeconds` is persisted from the start so alpha migrations have a coherent calendar.

Stress starts 0, range 0–100. Every credited minute, when working normally, gain `max(0, employerStressPerMinute - effectiveMental~/10 - comfortReduction)`. Founder base gain is 2/min. At 90 enter automatic recovery. While recovering, gain no stress and lose 5 stress/min until stress≤40; then resume normal stress gain next minute. Wages still use the current stress band, so recovery never stops income. One manual free break per 300 credited seconds removes 20 stress instantly. No energy meter in baseline; it duplicates stress.

Housing and transport are independent one-owned-choice slots. Each purchase replaces the previous asset, receiving its resale proceeds in the same transaction. Free options never charge upkeep. Costs are fictional, not real housing guidance.

| ID | Slot | Buy | Upkeep / game month | Resale | Comfort reduction |
|---|---|---:|---:|---:|---:|
| room_basic | housing | 0 | 0 | 0 | 0 |
| room_bright | housing | 100000 | 1000 | 50000 | 1 |
| home_quiet | housing | 1000000 | 5000 | 500000 | 2 |
| transit_basic | transport | 0 | 0 | 0 | 0 |
| bicycle | transport | 50000 | 500 | 25000 | 1 |
| compact_car | transport | 500000 | 3000 | 250000 | 1 |

If a month's total upkeep is unaffordable, automatically sell paid lifestyle assets at their listed resale values, replace with free defaults, and charge no upkeep for that boundary. Record downgrade reason and funds returned; no debt. Confirmation previews recurring obligations and this safety behavior. Lifestyle comfort sums across slots, capped at 3. Leisure costs 5,000, reduces stress 30, cooldown 600 seconds; the free break remains available.

Relationships, marriage, parenting and trips use optional event flags and journal entries; no extra currencies, real-date timers, or mandatory advantages. CP08 supplies moving and leisure milestones; CP17 authors the larger life catalogue. Baseline excludes mortgages, dependency simulation, fertility/death systems and mandatory age deadlines.

## Fictional investments

Unlock level 15. No live feeds, actual tickers, leverage, debt, shorting or real-money returns. Label all rates “게임 내 수익률”; do not use real-world annual return language. Monthly boundaries follow simulation time. Holdings retain principal/cost basis for reporting and earned-profit accounting.

| ID | Model | Minimum | Liquidity and rule |
|---|---|---:|---|
| steady_deposit | Deposit | 10000 | Interest 50 bp/game month, principal freely withdrawable |
| broad_basket | Fund | 10000 | Units initially priced 1000; fee 50 bp each trade; monthly move -500/0/+600 bp with 30/40/30% weights |
| bright_share | Equity | 10000 | Units initially 1000; fee 100 bp; move -1500/0/+1800 bp with 35/30/35% weights |
| rental_unit | Property | 1000000 | One unit; fixed liquidation price 900000; pays 3000/month; cannot sell until 3 game months held |

All are game models, not predictions. Deposit interest is `principal*50 ~/ 10000`, credited to personal cash, without automatic reinvestment. Fund/equity price updates use each instrument's own deterministic draw from the market stream in sorted ID order; price floor 1 won, ceiling 10^12. Units are nonnegative integers. A buy command specifies units; total debit = units×price + ceil(notional×feeBp/10000). Sell credits notional minus ceil(fee), never negative. Market update precedes a same-time trade. No delayed orders or free repricing between preview and commit; stale preview returns current quote for reconfirmation.

Cost basis is maintained per holding as total won including buy fees. On a partial sale remove `floor(totalBasis * soldUnits / priorUnits)`; on final sale remove all remaining basis. Eligible earned income adds `max(0, netSaleProceeds - removedBasis)`; returned basis is not earnings. Unrealized gains never enter earned income. Rental purchase allowed once and has no separate maintenance cost. Rent counts as income; sale below original price contributes no earned profit.

All settlement uses calendar boundary IDs. Reopening, restoring or changing tabs cannot pay interest twice. UI shows principal, current value, realized return, fees, lock time, and the actual possible monthly changes. A loss never consumes cash outside the purchased position.
