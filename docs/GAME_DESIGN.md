# Game design and loops

## Core loop

`Work automatically → collect visible income/XP → buy upgrade or train → meet rank requirements → evaluate promotion → compare employers → improve income and office → repeat`.

Passive earning is credited automatically, including on return. Floating numbers are feedback, never separate tappable rewards. Manual tapping on the worker triggers flavor animation only. Rank changes, job acceptance, purchases, investments, and founding always require explicit player actions.

## Meta loop

`Career surplus → life comfort / investments / founder capital → grow or close business → return to employment with experience → retire voluntarily → earn Career Points → spend permanent upgrades → begin another career`.

A salary-focused player must reach retirement without founding. A failed founder keeps skills and gets a guaranteed fallback job. Prestige supports replay, but never becomes necessary just to continue a current run.

## First visit and next visits

| Time target | Experience | Feedback |
|---|---|---|
| 0–30 seconds | Worker starts earning before tutorial text | ₩/s, cash, next upgrade price |
| 30 seconds–2 minutes | Buy 업무속도 for ₩500; see before/after | Short sound and rate highlight |
| 2–5 minutes | Train 업무력; view promotion requirements | Three clear progress bars |
| 5–10 minutes | First evaluation opportunity | Chance, cooldown, guaranteed-success rule |
| 10–30 minutes | Compare employer and equip first laptop | Salary/workload comparison and visible prop |
| 30–60 minutes | Second rank goal and office event choice | Career log, next unlock |
| Return | One nonblocking away summary | Cash/XP already credited; continue button |

Timing is a tuning target checked by CP14; initial formulas are not claimed to meet it before measurement.

## Progression dependencies

Core upgrades are always available. Skills unlock after the first upgrade. Career view is always inspectable; promotion requires the configured thresholds. Job market unlocks at `employee`; equipment after one upgrade; events after 120 credited seconds. Life unlocks at level 10; investments at level 15; business at level 25 plus capital and skills; retirement at age 60 OR level 50. Locked screens show the condition and a route to progress. No feature unlock depends on payment or an advertisement.

## Modes and pause policy

`employed`, `founder`, and `retired` are mutually exclusive run modes. Retired is an archive/next-life staging screen: no simulation rewards. UI sheets never pause ordinary income. No event choice is auto-selected while away. One pending choice blocks new event draws, not earning. Investments and business settle on simulation boundaries while away, including losses, within the shared eight-hour cap.

## Narrative and collection

Store major first-time milestones in a career journal: promotion, employer change, major life choice, founding, closure/exit, retirement. The recap is generated from persisted counters and milestone records, never from an AI service. Cosmetic collection, lifetime achievements, and career archives survive prestige. Event text and rank/company names come from localization keys.

## Decision value

Before confirming an action show cost, immediate changes, recurring costs, any uncertainty, and reset implications. At least two company profiles must be useful at the same rank. A comfort purchase trades faster wealth growth for lower stress. A business can outperform wages but puts only committed capital at risk. Random outcomes use disclosed chance bands; promotions show the exact probability.
