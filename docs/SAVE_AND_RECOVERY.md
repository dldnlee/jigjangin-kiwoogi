# Local saves, migration, recovery

## Storage implementation

Use Drift/SQLite behind SaveRepository. One database transaction writes current snapshot (canonical JSON text plus schema/config/revision columns), previous valid snapshot, command receipt, and durable claim rows. Tables: `save_slots` (current/previous), `command_receipts` (id unique), `durable_claims` (kind+key unique), `config_snapshots` (version+hash), `analytics_outbox` (optional, bounded). Drift is the selected persistence implementation; verify its current setup via [official documentation](https://drift.simonbinder.eu/) at CP00.

Keep last 1,000 ordinary command receipts, and never prune unresolved operations. Durable one-time claims survive ordinary receipt pruning; command revision validation prevents replay of an older ordinary command. Save checkpoints are local crash recovery, not an anti-cheat security system. Store no purchase secrets or identity provider tokens in these JSON fields.

## Transaction protocol

Read committed revision → advance time → validate command against settled state → calculate new state/receipts → transaction checks prior revision → copy old current into previous → write new current and claims → commit → publish UI. If a stale command's exact ID already has a receipt, return that receipt. Otherwise reject stale revision. UI retries with a new ID only after refreshed intentional action.

Crash before commit leaves old state; crash after commit returns stored receipt on retry. A closure, promotion, achievement claim, prestige or ad reward must never be split across saves. A file-full/DB error must not report successful spending; retain old state and actionable retry/export notice. Periodic write failures keep a visible save warning until resolved.

## Migration

Maintain pure ordered migrations vN→vN+1 with fixtures. Preserve original backup before migration; apply migration and content-ID mapping to a copy, validate invariants, then commit atomically. Test migrations from every publicly released schema. Never use launch dates or screen visibility as a migration condition. If a profile config changes ladder, preserve current rank by ID and recompute its next target; pity maps to target ID, not ordinal index.

## Recovery paths

Current snapshot fails checksum/parse/invariants: attempt previous snapshot, show recovery notice and last valid save time. Previous also invalid: stop automatic writes, offer export of corrupt data and explicit reset. Do not overwrite corruption just because initialization throws. A checksum mismatch means possible corruption, not proof of malicious editing.

Allow user-triggered local export/import with schema/size/ID validation. Import creates a backup and requires confirmation of the exact replacement profile/run summary. Never import entitlements or cloud authentication from a local file. Debug reset operates only in non-production builds. Production reset uses a clear destructive-action confirmation and preserves purchased cosmetics once services exist.

## Config activation

Pin config hash in save. Keep previous compatible bundle until all dependent snapshots migrate. Remote config downloads later are validated to a staging slot and activated only after current time settles under old config. Recompute future rates; do not retroactively recalculate paid rewards, past months, or snapshots. Rejected config leaves last known good active. Config rollout/rollback must include migration reversibility assessment; never downgrade a save schema automatically.
