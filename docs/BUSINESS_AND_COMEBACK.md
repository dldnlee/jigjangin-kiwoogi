# Business, closure, and comeback

## Founding

Requires level≥25, trained leadership≥10, trained expertise≥10, reputation≥30, employed mode, and cash covering chosen capital. Capital is a transfer to a separate business wallet; no extra founding fee. One active business. Founding settles employment wages, stores last employer/rank/salary, clears offers, creates business at a fresh boundary offset using `foundedAtRunSeconds`, and switches mode to founder. Company accounting still uses global game-month boundaries; the first partial month is prorated.

| ID | Capital | Base revenue/month | Base cost/month | Volatility bp outcomes / weights |
|---|---:|---:|---:|---|
| cafe | 1000000 | 140000 | 100000 | -2000,0,2000 / 25,50,25 |
| online_shop | 2000000 | 280000 | 200000 | -4000,0,4000 / 30,40,30 |
| game_studio | 5000000 | 650000 | 550000 | -8000,0,8000 / 35,30,35 |
| it_services | 3000000 | 400000 | 300000 | -3000,0,3000 / 25,50,25 |
| fashion_label | 4000000 | 540000 | 440000 | -6000,0,6000 / 30,40,30 |
| ai_tools | 8000000 | 1100000 | 1000000 | -9000,0,10000 / 40,20,40 |

First three are beta; last three are launch content. Seed values must be stress-tested; a default cafe is expected to be lower risk, not mathematically guaranteed never to close after player expansion decisions.

## Operation

Staff roles developer, designer, marketer, sales, operations. Each role count 0–10; total cap 20. Each staff costs 10,000 hiring fee and 10,000/month salary from business cash; each contributes +500 revenue bp (cosmetic role differences initially, explicitly shown). Hiring requires trained leadership≥staff total after hire. Dismissal has no refund/fee and adjusts future payroll only.

Product and marketing upgrades each level 0–20, cost `ceil(50000*150^L/100^L)`, +1,000 revenue bp per level. Office upgrade level 0–5 uses same base/growth formula, adds +2 allowed total staff per level up to the hard cap 20; initial capacity 10. Staff benefits are computed from actual roster; unavailable roles never generate bonuses.

At each month boundary compute ordered floors:

`revenue = baseRevenue * (10000+100*effectiveLeadership+500*staffCount+1000*productLevel+1000*marketingLevel) ~/ 10000`, then multiply by `(10000+marketShockBp)~/10000`.

`expenses = baseCost + 10000*staffCount`.

For partial periods split by any staff/upgrade/leadership change, compute revenue and expenses proportionally to seconds/3600, with persisted remainders. One shock is selected at the start of each business accounting month (including founding partial month), stored as `currentShockBp`, and used for every segment in that month. Segment accrual is tracked as unposted revenue/expense until the next global month boundary. This prevents last-second hiring or gear changes from retroactively changing an entire month.

At settlement add accrued revenue then subtract expenses if affordable. Business cash exactly 0 after successful payment remains active; closure happens only when the due expense cannot be paid. Surplus stays in business until withdrawn. Withdraw command cannot exceed `max(0,businessCash - accruedExpenses - nextMonthProjectedExpenses)`; projected expense uses current staff. Additional capital transfers are explicit and do not count as income.

Business return accounting tracks `unreturnedCapital`: increase on personal transfers in, reduce distributions against it first, then recognize excess as earned profit. Distributions never create duplicate lifetime earnings. Displayed valuation is `max(0, lastSettledMonthlyProfit*12) + businessCash`, informational only. Baseline exit returns available cash after accrued liabilities, not displayed valuation. Clearly label this action “청산” rather than promising an acquisition payment.

## Failure and voluntary closure

On unaffordable expenses: business wallet goes to 0, unpaid liabilities are written off, staff removed, snapshot appended, mode returns to employed at last rank and guaranteed `paper_sprout` salary (no negotiated bonus). Personal wallet/gear/skills/investments/life remain. Cooldowns and pending business events clear. Any ordinary pending event incompatible with employment is discarded without effects. Future salary starts at that boundary; no retroactive month of wages.

Award founder experience `min(100, completedBusinessMonths*5)` once per business ID; leadership +min(3, completedMonths~/3) trained levels (respect cap); reputation +min(10,completedMonths). Zero-month closures award nothing. Increment founder attempt and closure counters once, distinguishing voluntary from insolvent. First qualifying closure in a run grants a one-time comeback salary bonus +1,000 bp for 3,600 seconds, with an explicit expiration boundary. Repeated founding/closing within a month cannot farm experience, reputation, or the bonus.

After closing offer one deterministic comeback job at a currently skill-eligible employer: choose highest salary among eligible, tie by ID; expire after 1,800 seconds. No better employer is guaranteed if already best-qualified. Fallback employment always starts immediately; rejecting the offer cannot strand the player. A journal panel emphasizes skills retained and a reachable next goal.

Voluntary closure settles accrued revenue and costs to now using the stored shock, returns max(0,cash+accruedRevenue-accruedExpenses), discards unpaid liabilities, and runs the same transition. It receives no comeback bonus and no “failed business” achievement unless actually insolvent. Retirement uses this same liquidation math but gives no comeback rewards or employment transition.
