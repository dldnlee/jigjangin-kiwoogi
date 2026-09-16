# Codex development rules

## Read order and authority

Read [README.md](README.md), [PRODUCT_SPEC.md](PRODUCT_SPEC.md), [ARCHITECTURE.md](ARCHITECTURE.md), [ECONOMY.md](ECONOMY.md), [DATA_SCHEMA.md](DATA_SCHEMA.md), then the active checkpoint and linked system documents. Explicit current owner instructions override this pack. Within the pack: product scope owns milestones; economy owns arithmetic/units; time owns boundary ordering; schema owns field contracts; system docs own mechanics; checkpoints own implementation scope. If these conflict, record and resolve the contradiction before dependent code, rather than silently selecting an interpretation. Recent incidental conversation text is not a config override.

## How to implement a checkpoint

1. Inspect repository, applicable AGENTS.md and current roadmap evidence. Identify already implemented work; preserve unrelated edits.
2. Read dependencies and prerequisite evidence. Implement only the active checkpoint and necessary fixes to prior behavior.
3. State a short plan and identify any unresolved product decision that actually blocks this work.
4. Use pure functions and small typed services; add config entries instead of hardcoded numeric special cases.
5. Write targeted tests for arithmetic/state changes and failure paths. Add migrations for persisted changes before changing fixtures.
6. Run relevant format, analysis, validation and tests; exercise the affected UI on an available target.
7. Record real evidence and remaining gaps in the checkpoint. Update status only if every acceptance item passes.
8. Summarize behavior changed, verification, known risks and the next checkpoint. Never report a runnable/tested game based solely on generated files.

## Non-negotiable implementation contracts

- Money is integer-backed and serialized as strings. Never use double for authoritative balances.
- All gameplay is deterministic from state/config/command/credited time/PRNG state. No scattered clock reads or randomness.
- Settle before purchases, equips, mode changes and config activation. One mutation queue, one committed authoritative model.
- No domain state changes from widget build, animation completion or repeated provider subscription.
- Preserve stable content IDs and old save fixtures. Never silently reset on a migration error.
- Every one-time reward has durable deduplication. Failures and retries must not mint or destroy money.
- Game balance stays in JSON/config definitions; canonical operation order remains code plus tests.
- No new backend, ads, purchase SDK, Flame or notification dependency before its gate.
- No secrets, debug grants, time-travel controls, or raw user save dumps in release builds/logs.
- Localized strings use ARB keys. Inspect Korean layouts at large text; avoid text embedded in sprites.
- Do not author all future systems inside “foundation.” Keep each build runnable with unavailable tabs hidden.

## Change control

For changed product defaults, update [DECISIONS.md](DECISIONS.md), canonical doc, schemas/config, tests and affected checkpoints in the same change. “Expected files changed” lists are guidance, not permission to discard unrelated files. Prefer the established repository structure if names differ, documenting equivalents. Don't rewrite architecture just to match these example paths.

Checkpoint completion does not authorize publishing a production build, purchasing services, or sending messages to testers. Prepare concrete reviewable artifacts first; follow the owner's actual authorization for external actions. Local implementation and reversible fixes need no additional artificial sign-off gate.

## Copyable development prompt

> Implement the next ready checkpoint in checkpoints/README.md for 직장인 키우기. Read docs/CODEX_RULES.md and that checkpoint's required references first. Keep simulation pure Dart, preserve saves, and use JSON-driven configuration. Do not implement later checkpoints. Add meaningful tests for new state transitions, run applicable checks, and record evidence without marking unrun checks passed. Stop only for a genuine blocking dependency; otherwise complete the checkpoint's authorized work.

For repository-wide automatic discovery, the owner may add a root AGENTS.md pointing to this file. This pack does not overwrite an existing root agent policy.
