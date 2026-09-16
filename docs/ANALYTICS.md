# Analytics and research plan

## Before a service

CP01 emits typed in-process domain events for tests and local diagnostics. No network telemetry until CP15. Use observed play sessions and exported aggregate balance reports to decide whether to expand the core. Export only with user action; local character names/free text are excluded.

## Event taxonomy

All telemetry uses schemaVersion, eventId, anonymous installation ID, sessionId, appVersion, configVersion, platform, milestone profile, occurrenceUtcMs, and coarse progression bucket. Never send exact names, ad IDs, receipts, auth tokens, email, unstructured event text, or exact local save dumps. For optional authentication use a pseudonymous account ID only where needed for cohort continuity.

| Event | Trigger | Additional properties |
|---|---|---|
| session_started/ended | Foreground starts / ends, session split after30min away | elapsed bucket; missing end tolerated |
| tutorial_step | First completion per step | stepId |
| upgrade_bought | Committed upgrade/training | type, level bucket, cost bucket |
| promotion_attempted | Committed roll | targetRankId, probabilityBp, pityCount, outcome |
| job_offer_accepted | Committed switch | employerId, salary change bucket |
| equipment_equipped | Committed change | itemId, slot |
| event_resolved | Committed choice | definitionId, choiceId, outcomeIndex |
| offline_settled | New committed receipt | elapsed/credited buckets, income bucket, capped bool |
| investment_traded | Committed trade | modelId, buy/sell, value bucket |
| business_started/closed | Committed transition | typeId, duration bucket, insolvent bool |
| retirement_completed | Committed archive | age bucket, points bucket, highestRankId |
| achievement_claimed | Committed reward | achievementId |
| save_recovery | Backup restore or migration failure | error enum, schemaVersion |
| ad_offer/ad_completed/ad_rewarded | Separate stages | placement, receiptId hashed |
| purchase_started/verified/refunded | Service-confirmed stage | productId, result enum; no receipt body |

Money buckets: [0,1k), [1k,10k), [10k,100k), [100k,1m), [1m,10m), [10m,100m), [100m,+). Time buckets: <1min,1–5min,5–30min,30min–2h,2–8h,>8h. Use these consistently, not per-screen custom categories.

## Delivery and privacy

Opt-in analytics toggle defaults off in this project design; declining leaves gameplay identical. Consent revocation disables collection and deletes unsent outbox. Outbox max1,000 events/7 days, dropping oldest noncritical events; no telemetry failure blocks saves. Server deduplicates eventId. Record consent text/version. Retain raw product events at most90 days as a project policy; aggregate anonymized cohorts separately. Region/store privacy requirements and vendor disclosures must be verified at CP15/CP18; this document does not claim legal sufficiency.

## Metrics and decisions

Tutorial conversion = distinct consenting new installs completing final tutorial step / consenting new installs starting tutorial. D1 retention = installs whose first start is on UTC date D and with any session on D+1 / eligible installs from D; D7 analogous D+7. Exclude cohorts whose observation window is incomplete. Report consent rate and opt-in selection bias; do not extrapolate opt-in sample to all players without qualification.

Track median/p90 time-to-first-upgrade/promotion, unaffordable-action frequency, session duration, offline return rate (returning sessions with settled absence≥60s / returning sessions), job-switch use, percentage reaching retirement, closure→next-earned-wage success, and duplicate receipt count (must0). Retention is not inferred from session length. Experimental monetization tracks completion vs reward separately to detect lost rewards.

Internal expansion gate: two qualitative rounds show readable goals, no repeated complaints of forced waiting in first10min, and no severe data/economy defects. Soft-launch provisional targets: D1≥30%, D7≥10% among consenting eligible installs; do not use as hard evidence without at least200 eligible installs and uncertainty intervals. These are project hypotheses, not researched market benchmarks. Pause monetization expansion if nonpaying progression worsens.
