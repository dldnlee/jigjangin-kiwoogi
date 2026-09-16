# Browser implementation record

Date: 2026-09-15

## Scope and platform decision

The request was to build a game from the attached folder and keep the documents in the actual project. All original archive documents were extracted into this project without modification. Embedded workflow instructions were treated as source material, not user authorization for publishing, external services, or unrelated operations.

The first runnable delivery implements the product pack's v0.1 career loop. Flutter and Dart were not available in the local environment. A platform preference question was presented; in the absence of an answer, implementation continued as a browser game, with the assumption stated during work. This is an explicit platform adaptation and **does not certify CP00–CP07 or any mobile release gate**.

## Contract mapping

| Design | Browser implementation |
|---|---|
| Pure Dart simulation | Pure ES module, clock and storage injected at the application boundary |
| BigInt money | JavaScript BigInt calculations; decimal-string serialization |
| Flutter / Riverpod / GoRouter | DOM views, hash routes, immutable state replacements |
| Drift / SQLite transaction | IndexedDB transaction containing current/previous envelopes and embedded bounded receipts |
| Bundled JSON / ARB | Versioned, code-owned content module with Korean copy; no remote content execution |
| 4 Hz presentation | 250 ms view refresh; economic time follows credited whole seconds |
| 8-hour offline cap | 28,800-second absence cap with persisted high-water wall timestamp and fractional remainder |
| Exact purchase/equip ordering | Settle old rate; validate and apply on a copy; commit; acknowledge and render |
| Random streams | Persisted xorshift32 streams for promotions, offers, and events; rejection sampling |
| Offline reward sheet | Reward first committed, then dismissed with no additional credit |

## Deliberate differences and limits

- No claim of complete v1.0: life, investments, business/failure, retirement/prestige, achievements/missions, optional services, and large release catalogues have not shipped.
- Three company profiles yield up to two alternative offers because the current employer is excluded; the design permits at most three.
- Only slice mechanics participate in simulation. Stress event text is flavor with no salary effect in this version.
- Content is pinned to `browser-slice-1`; unknown versions are rejected rather than silently reinterpreted. There is no Flutter save import or migration.
- Ledger accounting retains cash and eligible earned totals, but not a full unbounded transaction ledger or the future meta-profile schema.
- Local artwork and system Korean fonts need no network. Art is original SVG rather than the planned production raster catalogue.
- Browser storage is local and recoverable from the previous snapshot when valid; it is not tamper-proof or a cloud backup.
- A conflicting second tab stops writes and asks for refresh, preventing stale overwrites.
- Imported saves resume from the import time; historical elapsed time is not credited again during import.
- Browser prototype UI uses desktop navigation plus five mobile navigation items for the implemented screens, rather than the planned final five-tab taxonomy.
- Android/iOS signing, real-device accessibility/performance, native haptics, 200% text-scale certification, Korean editorial review, and multi-day human playtests remain unverified.

## Verification

`npm test`: 26 tests passing. Coverage includes:

- Canonical ₩6,000/60 XP per minute and ₩105/s after first speed upgrade.
- Exact exponential-cost rounding, caps, rejected purchases, and no duplicate spending.
- Equipment replacement instead of bonus stacking; separate trained/effective skills.
- Whole-span versus partitioned replay, XP remainders, backwards clock, capped absence, no repeat offline credit.
- Deterministic random seed, promotion requirements/cooldown/fourth-attempt guarantee, employer switching.
- All event effects, pending-choice persistence, and reaching the highest slice rank through normal commands.
- Save checksum round trip, malformed/unsupported save rejection, wallet/XP caps.

Eight-hour pure simulation completed in approximately 1 ms in the local Node test run; this is a desktop measurement, not a mobile performance claim.

Browser checks cover the visible UI, real purchase/training/equip flow, and reload persistence. Additional responsive and storage checks are recorded below as they are completed.

### Completed browser checks

- First speed upgrade: level 0 → 1, salary 100 → 105, survives reload.
- Work training: trained level 0 → 1; cost increases to 1,180.
- Starter laptop purchase/equip: owned count 1/15, equipped slot and salary reflected, survives reload.
- Pending event: disclosed performance effect applied, dialog closes, event no longer pending.
- Promotion: first rank evaluation successfully advanced to employee, performance reset, reputation +5, cooldown shown.
- 390×844 office and 320×568 career layouts: no horizontal overflow; scrolling and fixed navigation remain available.
- Browser console: no application errors during checked flows.
- Isolated real IndexedDB tests: 7/7 pass for initial state, round trip, previous snapshot, stale writer rejection, current corruption recovery, valid backup retention after recovery, and double-corruption preservation.
- All 47 original archive documents compared byte-for-byte with extracted files: zero differences.

Run real browser storage checks at `/test/storage.html` while the local server is running. The test uses a unique isolated database and never opens the player database.
