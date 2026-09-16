# Time, simulation, and offline progress

## Pure contract

`advance(state, creditedSeconds, config) -> SimulationResult(state, ledgerEntries, domainEvents)` is pure Dart. No Flutter, clock reads, storage, networking, or unseeded random calls. `applyCommand(state, command, config)` runs after advancement to the command time. Single-threaded command queue serializes all mutations; background work returns immutable proposals checked against save revision.

Persist `runSeconds`, UTC `lastSettledAtMs`, fractional wall elapsed milliseconds, accrual remainders, next boundary counters, separate PRNG streams, and pending UI notifications. Resume computes `elapsed=max(0, now-lastSettledAt)` and credits `min(elapsed, 8h)`. Move timestamp to max(old timestamp, now), including when capped, in the same transaction as the credited state. Never leave the truncated excess available to claim next launch.

On backgrounding, settle foreground elapsed and persist. On resume, settle only after that timestamp. Unexpected process death uses the most recent committed timestamp; replay from it restores uncommitted foreground progress as away time. Background operating-system execution is neither requested nor required. Autosave at most every five seconds while actively earning and immediately after any player command or boundary with a one-time consequence.

## Boundary algorithm

Advance in segments to the nearest whole simulation second where a rate or state can change: stress minute, game month, event draw, offer generation, boost expiration. Constant-rate spans may be aggregated. At an identical boundary use this order:

1. Credit wages/XP for the preceding interval; grant level-ups.
2. Update stress and recovery mode.
3. Settle investments, then business revenue/costs/failure.
4. Charge life upkeep or downgrade to free defaults.
5. Expire job offers and timed modifiers.
6. Generate job offers and eligible event instance (if none pending).
7. Evaluate unlocks and achievement counters; append notifications.

Then accept a queued user command. Month settlement is one transaction with all downstream state. Retired mode advances no run time. Avoid one tick per millisecond; eight hours has at most 28,800 one-second steps and should use aggregation where possible. Set a device-tested performance budget in CP14.

## Randomness

Use a specified portable xorshift32 generator per stream (`promotion`, `offers`, `events`, `market`, `business`), nonzero uint32 seeds persisted. For each draw: x ^= (x << 13) masked32; x ^= x >> 17 (logical shift); x ^= (x << 5) masked32; mask final result. Map to bounded integers with rejection sampling, not modulo bias. Seed 1 produces first uint32 270369. The deterministic simulation never uses Dart `Random` as a serialization contract.

Generate random event outcome when the choice command is accepted; persist result and PRNG change with its effects. Promotions likewise. A crash/retry of an already committed command returns the stored receipt. Separate streams mean an investment draw cannot change a promotion outcome. This discourages casual rerolling, but local saves are not cheat-proof; no competitive claims.

## Away summary

Rewards are applied before the summary opens. `OfflineReceipt` records ID, from/to times, actual elapsed, credited seconds, gross salary, net wallet delta, XP, investments, expenses, business closure, and dismissed flag. “계속하기” only dismisses. Never apply rewards again on claim/dismiss or widget rebuild. Under 60 seconds show a toast; at least 60 seconds show the sheet. A second resume merges undismissed summaries using transaction IDs while preserving per-receipt ad eligibility later.

## Clock changes

UTC storage removes timezone and daylight-saving arithmetic. A backwards clock credits zero and retains the previous high-water timestamp; show a neutral time-sync notice if drift exceeds five minutes. Forward jumps credit at most eight hours. A deliberately advanced local clock can affect future progression; disclose this as a local-first limitation in technical records. Do not accuse players of cheating or delete saves. Debug time is injected and cannot ship in production.

## Required invariants

Given the same state/config and no user commands, `advance(a+b)` equals `advance(a);advance(b)` in balances, boundaries, and PRNG streams. Presentation notifications may be grouped differently, but their underlying IDs and totals match. Repeated settlement with zero elapsed has no effect. One eight-hour away period and eight one-hour segments produce the same result with the same total credited time. More than eight hours in one absence intentionally differs due to the cap.
