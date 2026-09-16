# Economy — canonical arithmetic

All numbers below are **seed balance values**. Change them through a versioned config and CP14 evidence. This document owns units, formulas, caps, and accounting; other documents may explain them but must not redefine them.

## Units and rounding

Cash is integer fictional won (`Money`, BigInt in Dart, decimal string in JSON). XP, time in whole seconds, skill levels, and basis points are integers. 10,000 basis points (bp) = 100%. Multiplication uses arbitrary-precision integers; never floating point for authoritative money. Reject negative spending, nonfinite input, invalid IDs, and commands exceeding caps. Display abbreviation: 만 at 10,000, 억 at 100,000,000, 조 at 1,000,000,000,000; round display down to at most two decimals and expose exact value in details.

`floorDiv` means floor on nonnegative amounts; use explicitly signed helpers for losses. All costs round up; credits round down except continuous accrual retains remainder. Maximum cash per wallet is 10^30 won; overflow is capped with a diagnostic counter, never wrapped. Maximum skill level 100, core upgrade level 200, character level 100. Domain XP at level cap is retained up to 10^12, then capped.

## Earnings

Career rank config owns `baseRateWonPerSec`; employers own `salaryBp`. Base rate starts at 100. Rate derivation is the following ordered integer pipeline:

1. Resolve `salaryBp = employer.salaryBp + negotiatedSalaryBp + activeComebackSalaryBp` (the last term is 1000 only during the qualifying comeback bonus); then `R = baseRate * salaryBp ~/ 10000`.
2. `R = R * (10000 + 500*speedLevel + 500*efficiencyLevel) ~/ 10000`.
3. `R = R * (10000 + 100*effectiveWork) ~/ 10000`.
4. `R = R * (10000 + equipmentIncomeBp + prestigeIncomeBp) ~/ 10000`.
5. `R = R * stressFactorBp ~/ 10000`.

Effective skill = trained level + equipped flat bonuses, clamped 0–150. Equipment income bonus cap 3,000 bp; prestige income cap 2,000 bp. Stress factor is 10,000 below stress 70, 8,000 at 70–89, 6,000 at 90–100. Starting stress is 0. Slice stress stays 0 until CP08. Derived rate remains at least 1 while employed. Founder mode pays no employment wages.

Continuous accrual uses `numerator = R * creditedMs + cashRemainder`; credit `numerator ~/ 1000` and persist `numerator % 1000`. The credited simulation itself advances whole seconds; the adapter retains subsecond elapsed time. Settle before changing rate. XP is `(1000 + 100*focusLevel + 20*effectiveExpertise + prestigeXpBp~/10)` milli-XP/second; prestigeXpBp is always divisible by 10. Keep milli-XP remainder. Founder XP uses the same rate. Level n→n+1 costs `100*n*n` XP; repeatedly subtract thresholds, cap level at 100. Level itself does not multiply wages.

Reference: untouched new hire earns exactly ₩6,000 and 60 XP in 60 seconds. `speedLevel=1` earns ₩105/s before other changes. ₩100/s over a capped eight-hour absence earns ₩2,880,000 with no other systems enabled.

## Upgrade and training costs

At current core upgrade level L, `cost = ceil(base * 115^L / 100^L)`; bases speed=500, efficiency=700, focus=600. Training one level costs `ceil(1000 * 118^L / 100^L)` for each skill. Purchase exactly one level initially. Batch purchase later is the sum of per-level rounded costs, with the same atomic affordability check. Training is instant; there is no parallel training timer. Cost is a sink and never increases lifetime earned income.

## Ledgers

Personal cash, business cash, debt, and investment holdings are separate. `runEarnedWon` increments for wages, positive event grants, deposit interest, positive realized investment profit, positive business distributions/exit profit, and achievement cash rewards. It excludes starting money, transfers between wallets, refunds, principal returned, borrowing, rescue grants, ads, and paid currency. `lifetimeEarnedWon` accumulates eligible run earnings and is not reset. Every credit has a typed source. Debits record sinks separately. Do not derive earnings from changes in wallet balance.

`netWorth = personalCash + liquidationValue(holdings) + resaleValue(lifeAssets) + businessLiquidationValue - personalDebt`. Gear has no resale value. Business liquidation value is business cash only; displayed valuation is informational and not spendable. Net worth can be negative even though wallets cannot. Investment liquidation includes fees. Business capital and personal cash must never be counted twice.

## Time and recurring costs

One game month = 3,600 credited simulation seconds; one game year = 12 months. Age is `22 + floor(runSeconds/43200)`. Only credited time ages the player. Employment is continuous fiction, including nights; no real-calendar wage claims. UI primary rate is ₩/s; “게임 월 예상 급여” is rate×3,600 and may change with modifiers. Never label this as a real annual salary.

Life upkeep and business accounting settle at each game-month boundary, not each login. Income for the ending interval is credited before expenses. Shared offline cap is 28,800 seconds per absence; time beyond it produces neither earnings, expenses, aging, market moves, nor cooldown progress. Daily mission dates use wall-clock UTC, separately from this calendar.

## Sources, sinks, and restraint

| Source | Sink | Bound |
|---|---|---|
| Wages and XP | Core upgrades and training | Level caps and exponential prices |
| Events and milestones | Equipment and lifestyle | One outcome per event instance |
| Investments | Fees and market losses | No leverage, no shorting |
| Business revenue | Payroll, costs, upgrades | Only committed funds exposed |
| Career Points | Permanent upgrades | Cannot be bought or converted to cash |
| Cosmetic gems, later | Cosmetic items | No career requirements or randomized paid rewards |

There is no loan system in the baseline economy: personalDebt must remain zero until a separately specified expansion. This explicitly defers the conversation's mortgage/personal-debt examples and prevents an undefined debt spiral. Business liabilities never become personal debt. Displayed paid-currency balances are not authoritative local wallets.
