# Balance plan and simulation

## Goals

Seed values are deliberately explicit so they can be tested and changed. Deliver a readable first hour, several days to a first voluntary retirement, and distinct company/business choices. An eight-hour return should create useful decisions without skipping all intermediate ranks automatically. No mandatory active tapping or ad reward may be needed to reach a milestone.

## Runner

CP14 creates a pure Dart CLI using the production simulator and config. Inputs: profile, seeds, duration, visit schedule and deterministic policy. Output JSON plus Markdown report: config hash, seed, policy, first upgrade/promotion/employer/investment/founding/retirement times, cash/income/XP timelines, sources/sinks, failures, state caps, and invariant violations. The runner is not a second independent economy implementation.

Policies: idle-only (never buys; baseline income sanity); cheapest-affordable upgrade; career-focused (train only unmet next-rank requirements, evaluate ASAP); wealth-focused (career goals plus investments); founder-risk (minimum qualified capital, then preset hires); comfort-first; adversarial (rapid equip, clock manipulation, repeated close/reopen, repeated reset attempts). Tie by stable ID. Visits: continuous, 5min every4h, twice daily, and 72h absence. Distinguish wall time and credited simulation time in every report.

## Targets to measure

| Milestone | Seed target / interpretation |
|---|---|
| First upgrade | ≤60 credited seconds |
| First promotion opportunity | 5–10 minutes under guided career policy |
| First employer change | 10–30 minutes |
| Slice engagement | 30–60 minutes with at least3 meaningful choices |
| Investment access | Day1–2 for two daily visits after tuning |
| Founder access | Day2–4 for two daily visits after tuning |
| Retirement eligibility | Day3–7 under two daily visits after tuning |
| First prestige award | 10–30 points median under career policy |
| Comeback | Wages resume at the closure boundary, always |

Age60 takes456 credited hours under seed time conversion, so early retirement in the day3–7 target must use level50. If XP cannot support this under the specified policy, revise seed XP/thresholds or target explicitly. Do not silently accelerate the age clock or force retirement.

## Experiments and acceptance

Run at least1,000 deterministic seeds for stochastic progression; report p10/median/p90 and impossible states, not just averages. For basic regression use seeds1,42,2026. Sweep cost growth110–125%, initial wage80–150, employer differentials, stress rates and business downside independently. Compare free-player policies first. Cap and extreme-value tests run even if typical players never reach them.

Promotion bound: every eligible player succeeds by fourth attempt independent of seed. No unpayable training gate before first promotion. No employer should dominate every salary/stress/difficulty dimension. Investment risk/fees must be visible and realized losses possible. Founder scenarios must demonstrate both survival and closure without personal loss beyond contributed capital. Prestige cash-transfer cycles must not increase points.

Tune one parameter family at a time; update config version, expected math fixtures and report together. Check long-horizon outcomes after any compounding change. Small values can grow dramatically when multiplied across wages, skills, gear and prestige. Report effects on existing saves and offline settlement before activating a new configuration.

## Human review

Simulation proves arithmetic and reachability, not fun. Observe first visits without directing clicks; ask what the next goal is, why one employer is preferable, and what the player expects to retain after failure. Record confusion and waiting separately. CP14 may return work to CP01–CP07; do not add services to mask a weak core loop.
