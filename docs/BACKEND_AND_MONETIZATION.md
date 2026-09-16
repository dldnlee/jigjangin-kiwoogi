# Optional services and monetization

## Sequence and philosophy

Core local game first, complete local meta-loop second, services third. The conversation proposed ads and purchases; this baseline stages them conservatively. No forced interstitials, paid promotion chance, paid founder rescue, cash packs, stat-bearing premium gear, offer/event rerolls, mystery boxes or leaderboards. Gems can later buy cosmetic items only. Purchases must never be required for recovery or prestige. Business revenue ads are deferred because they distort risk and cash accounting.

## Cloud backup contract — CP15

Vendor-neutral requirement: anonymous local play, opt-in account linking, save upload/download, versioned configuration delivery, diagnostics under consent. Select a managed backend after reviewing platform support and operational cost; no vendor account required to implement fakes. Profile access is server-authorized by authenticated user ID, never client-supplied owner text. Cross-user read/write must fail in integration tests. Secrets remain server-side.

Cloud is a whole-snapshot backup with compare-and-swap revision and config hash, not field-level merging. Local changes set a dirty revision. Upload includes last acknowledged cloud revision. Conflict returns both snapshots' summaries; player chooses one entire save after preview, and a backup of the replaced save is retained. Do not add wallet balances or achievement rewards across devices. While conflict unresolved, local play continues but cloud upload pauses. Account-link collision uses the same explicit replacement flow.

Downloaded saves validate schema, checksum, size and config compatibility before local replacement. Snapshot checksum detects corruption, not cheating. There is no trusted competitive economy. Purchased entitlements are separately server-verified and survive a save rollback. Remote config is declarative data only, staged/validated/activated per [SAVE_AND_RECOVERY.md](SAVE_AND_RECOVERY.md).

## Rewarded advertising — CP16

Initial placement only: optional +100% of **base employment salary** in one offline receipt. Base receipt already settled; bonus excludes XP, investments, events, business revenue, achievements, prestige and previous ad rewards. Preserve `eligibleSalaryWon` in receipt. Max one bonus/receipt and three completed bonuses per UTC day; expire eligibility after24h wall time or retirement, whichever first. Zero-salary founder receipts have no offer. Caps are persisted high-water UTC day rules.

`requested → showing → completed-awaiting-verification → granted` or `cancelled/failed`. SDK dismissal alone is never completion. Stable reward key=profile+offlineReceiptId. Verification result and reward grant must be deduplicated. Handle callback after app restart, duplicate callbacks, no fill, denied consent and lost network. If verified after eligibility expired but ad started within eligibility, honor the promised bonus once for the same active run; after retirement defer as excluded-from-earnings starting cash for next run. Retain grant history through prestige.

Server-side verification or the chosen provider's supported authoritative mechanism is required before production. Do not release a client callback-only trust path as secure. Display disabled/unavailable politely; “계속하기” remains primary and no lost base rewards. No “remove ads” purchase while there are no compulsory ads to remove.

## Purchases

First products: fixed-price cosmetic outfit packs; optionally cosmetic gem packs after entitlement ledger exists. Show platform localized price from store metadata, not hardcoded won. Product IDs/version/catalogue mapped explicitly. Server verifies transaction/purchase token, account ownership, product and environment before granting. Unique transaction ID enforces exactly once. Pending/cancelled/failed states grant nothing. Provide restore purchases and refund/revocation handling; consume/acknowledge according to current platform/provider requirements.

Paid currency and entitlements live in an authoritative ledger; local cache is read-only while offline for spending. Already-owned cosmetics remain usable offline. Restore cannot recreate consumed gems; receipts are not save-file fields. Refund handling removes affected unspent entitlement value without taking career cash or earned progression. At CP16 specify exact ledger/refund policy for each selected product before enabling it. Baseline fixed cosmetic packs avoid undefined consumable balance issues.

## Release checks

Verify current Apple/Google billing, advertising, privacy, age-rating and account-deletion requirements using official sources before store submission. Record checked dates and product/provider decisions. No legal compliance claims are made by this planning pack. Kill switches can hide purchases/ads while preserving owned items and offline play. Service credentials, store enrollment, signing and public release are operational dependencies, not preconditions for developing/testing local gameplay.
