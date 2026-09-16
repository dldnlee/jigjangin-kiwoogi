# Release and operations

## Milestone delivery

Every checkpoint produces a runnable build or a verification artifact for an existing runnable build. Version app binaries separately from config and save schema. Internal distribution first; public store deployment is a separate action. GitHub review includes scope, user-visible behavior, config/schema changes, checks actually run and known gaps.

## Release candidate checklist

- CP00–CP14 complete; CP17 content/polish and CP18 platform checks complete. CP15/CP16 required only if those services ship; otherwise disabled, not marked passed.
- No placeholder production art, missing Korean keys, TODO gameplay branches, debug economy controls, test receipts or live secrets.
- Fresh install, returning save, each prior public schema, eight-hour resume and full retirement/new-life tested.
- Both iOS and Android builds on supported physical devices; frame/memory/startup/offline replay evidence saved.
- Final authored content counts meet scope or explicit re-scope decision exists.
- Save export/recovery tested; network outage still permits all local gameplay.
- Asset/audio/font rights recorded; store screenshots captured from actual shipped build.
- Store/provider rules, permissions, privacy labels, age rating and support/account deletion paths checked against current requirements.
- Signed artifacts, version/config hashes, rollback notes and release notes retained securely.

## Config rollout

Validate offline first, run balance seeds and migration fixtures, stage to internal channel, compare reports, then enable a limited production cohort only with actual authorization. Keep previous compatible config; halt new activation on crashes or economy anomalies. A kill switch hides optional services but never removes base offline rewards or purchased cosmetics. Never download executable gameplay scripts.

## Incident runbook

Severity1: save loss, purchase/reward duplication, widespread startup failure. Stop rollout, disable affected optional feature, preserve evidence without exposing personal data, reproduce on same config/schema, prepare fix/migration, verify fixtures before release. Do not overwrite saves to “fix” balances. Severity2: progression blocks/layout failures; prioritize reachable workaround and targeted fix. Severity3: nonblocking copy/visual issues; schedule normal patch.

A rollback of config is safe only if all referenced content IDs and save fields remain compatible. Otherwise ship a forward fix. Keep release manifest mapping appVersion/configVersion/schemaVersion. Reconcile purchase grants via the authoritative ledger; never mass-reset player cash. Record impact, root cause, resolution and regression test.

## Sustainable content cadence

Start with ten reviewed event additions per content batch and one balance hypothesis. Measure event exhaustion, choice distribution and progression bottlenecks before adding systems. Use an editorial checklist and asset rights status. Do not promise a live-service schedule before staffing and release process are proven. Alerts/monitoring are implementation plans; no automation is created by this pack.
