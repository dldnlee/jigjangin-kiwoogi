# Data contracts — schema version 1

This document defines semantic contracts. CP00/CP01 must materialize JSON Schema Draft 2020-12 documents, typed Dart models and validators. Examples below are valid JSON fragments, not a shipped complete content catalogue. Every persisted field is required unless explicitly nullable/defaulted by a migration; reject unknown fields in content authoring, tolerate and preserve known-forward optional metadata only in save envelopes.

## Primitive types

`Id`: lowercase ASCII `[a-z][a-z0-9_]{0,63}`. `UUID`: command/receipt/run identifiers. `Money`: nonnegative decimal string `^(0|[1-9][0-9]*)$`, max 10^30; signed ledger deltas use separate signed type. `Bp`: integer; validate per-field range. `UtcMs`: nonnegative integer epoch milliseconds. `Seconds`: integer 0…10^12. String text is a localization key, never interpreted code. Arrays have explicit max length; external save size limit 5 MiB decompressed.

## Save envelope

| Field | Type / requirement |
|---|---|
| schemaVersion | integer 1; migration chain required for changes |
| revision | integer monotonic; transaction compare-and-swap |
| profileId, runId | UUID, profile survives retirement |
| configVersion, configHash | immutable bundled/cached config identity |
| lastSettledAtMs | UtcMs high-water timestamp |
| wallRemainderMs | integer 0–999 |
| run | RunState object below |
| meta | MetaState object below |
| receipts | recent command receipt map; durable special claims separate |
| checksum | SHA-256 canonical payload; corruption detection, not authentication |

RunState fields: mode enum employed/founder/retired; runSeconds; cashWon; xp (integer remaining toward next level); level; cashRemainder (0–999); xpMilliRemainder (0–999); runEarnedWon; eligible source counters; rankId; companyId; negotiatedSalaryBp (0–1000); performance (0–1000); reputation (0–1000); stress (0–100); recovering bool; lastBreakAtSeconds nullable; skillLevels map of all six IDs; upgradeLevels map of speed/efficiency/focus; inventory list of unique equipment IDs; equipped map slot→nullable item ID; promotion {targetRankId, failureCount, nextAttemptAt}; offers[] max3; nextOfferAt; eventState {pending nullable, cooldowns map, nextDrawAt, flags map}; life {housingId,transportId}; investments map; business nullable; founderExperience; lastEmployment nullable; comebackGranted bool; modifiers[]; rngStreams map of five nonzero uint32; nextMinuteAt; nextMonthAt; domainSequence; journal[] max500; statistics map. Debt is omitted in v1 and computed as zero.

MetaState fields: lifetimeEarnedWon; careerPoints integer≥0; permanentLevels map; cosmetics list; achievementProgress map; claimedAchievements set; deferredAchievementRewards list; missionState {highestUtcDay, counters, claimedIds}; archives[] max100 full summaries (older archives compact to aggregate totals); completedRuns; seedAllocator uint32 nonzero; settings {locale,sound,music,haptics,reducedMotion}; consent {analytics bool, consentVersion nullable}; serviceLinks nullable and never containing secrets. Cosmetic paid balance belongs to entitlement adapter cache later, not spendable local run cash.

## Config envelope and collections

Required envelope fields `schemaVersion`, `configVersion`, `minSaveVersion`, `profile` (slice/alpha/beta/launch), `constants`, and all collections below. Future-disabled collections are empty arrays with feature flags false. Every file is listed in a hash manifest; all IDs, assets, localization and rank references resolve before activation.

| Collection | Required fields beyond id |
|---|---|
| careers | nameKey, order, baseRateWonPerSec:Money, requirements:{level,performance,work,expertise,reputation} |
| companies | nameKey, salaryBp, difficultyBp, stressPerMinute, expertiseMin, officeThemeId |
| skills | nameKey, maxLevel, trainBaseWon, growthNumerator, growthDenominator, enabled |
| upgrades | nameKey, maxLevel, baseCostWon, growthNumerator, growthDenominator |
| equipment | nameKey, slot enum, rarity enum, priceWon, unlockRankId, flatSkills map, incomeBp, iconId, visualId nullable |
| events | category enum office/life/business, tone enum neutral/positive, weight, cooldownSeconds, predicates, titleKey, bodyKey, choices[] 2–4 |
| lifeAssets | nameKey, slot enum housing/transport, priceWon, upkeepWon, resaleWon, comfortReduction |
| investments | nameKey, kind enum deposit/fund/equity/property, minimumWon, feeBp, settlement definition, lockMonths |
| businesses | nameKey, capitalWon, baseRevenueWon, baseCostWon, shocks[]:{deltaBp,weight} |
| achievements | titleKey, metric enum, threshold, reward:{kind,amount} |
| missions | titleKey, metric, threshold, rewardWon, fallbackId nullable |
| prestige | nameKey, baseCostPoints, maxLevel, effect enum, amountPerLevel |

No duplicate ordered ranks; exactly one starter employer; all probability weights sum positive; price floors and maximums checked; feature gates cannot require a disabled skill. Content validation must find a reachable free path to every core unlock.

```json
{
  "id": "laptop_01",
  "nameKey": "equipmentLaptop01",
  "slot": "laptop",
  "rarity": "common",
  "priceWon": "2000",
  "unlockRankId": "new_hire",
  "flatSkills": {"work": 1},
  "incomeBp": 0,
  "iconId": "equipment_laptop_01_icon",
  "visualId": "prop_laptop_01"
}
```

```json
{
  "id": "late_request",
  "category": "office",
  "tone": "neutral",
  "weight": 10,
  "cooldownSeconds": 1800,
  "predicates": {"all": [{"modeIs": "employed"}]},
  "titleKey": "eventLateRequestTitle",
  "bodyKey": "eventLateRequestBody",
  "choices": [
    {"id": "agree_scope", "textKey": "eventAgreeScope", "requires": {"all": []}, "outcomes": [{"weight": 1, "effects": [{"type": "addReputation", "amount": 5}]}]},
    {"id": "tomorrow", "textKey": "eventTomorrow", "requires": {"all": []}, "outcomes": [{"weight": 1, "effects": [{"type": "addStress", "amount": -5}]}]},
    {"id": "prioritize", "textKey": "eventPrioritize", "requires": {"skillAtLeast": {"id": "talk", "value": 3}}, "outcomes": [{"weight": 1, "effects": [{"type": "addPerformance", "amount": 5}, {"type": "addReputation", "amount": 5}]}]}
  ]
}
```

## Runtime records

Offer: instanceId UUID, companyId, generatedAt, expiresAt in run seconds, salaryBp, configVersion. EventInstance: instanceId, definition snapshot, generatedAt, salaryRateSnapshotWon, resolvedChoiceId nullable, outcomeIndex nullable. These records are immutable except terminal resolution.

InvestmentHolding: instrumentId, units integer (fund/equity), principalWon (deposit), totalCostBasisWon, acquiredAtRunSeconds, currentPriceWon, lastSettlementMonth. Property uses units 0/1. No ambiguous quantity doubles.

BusinessState: businessId UUID, typeId, foundedAtRunSeconds, cashWon, unreturnedCapitalWon, staff map role→count, productLevel, marketingLevel, officeLevel, currentShockBp, accruedRevenueWon, accruedExpensesWon, revenueRemainder, expenseRemainder (denominator3600), lastAccruedAtSeconds, completedMonths, lastSettlementMonth, lastSettledProfitWon signed, peakValuationWon. Partial months do not increment completedMonths until 3,600 cumulative active seconds have elapsed; archive completedMonths=floor(duration/3600).

Command: commandId UUID, expectedRevision, kind enum, payload typed per kind. CommandReceipt: commandId, committedRevision, status enum applied/rejected, result payload, domainEventIds. LedgerEntry: sequence, runId, commandId nullable, source enum, wallet enum personal/business, delta signed Money, eligibleEarnedWon nonnegative. DomainEvent: id=`runId:sequence`, kind, runSeconds, configVersion, typed fields; no personal free text.

OfflineReceipt fields follow [TIME_AND_OFFLINE.md](TIME_AND_OFFLINE.md), including distinct gross income and signed net wallet delta. CareerArchive stores archiveId/runId, age, duration, eligibleEarningsWon, endNetWorthWon signed, highestRankId, maxRateWon, employers list, business counts, life milestone IDs, pointsGranted and createdAtMs. Full transaction claim IDs for retirement, achievements, business closure and future purchases are retained beyond ordinary receipt pruning.

## Compatibility

Missing/renamed content IDs require an explicit old→new mapping and economic effect review. Unknown save versions are read-only with export option; never silently reset. JSON numeric money is invalid even if small. Validate domain ranges after migration and before commit. A configuration update may not reinterpret an already-created event/offer or change historical earnings. Schema tests must cover malformed, minimum, maximum, old-version, and unknown-version fixtures.


## Initialization and canonical serialization

New profile defaults: schemaVersion1, revision0, mode employed, level1, company paper_sprout, rank new_hire, zero cash/XP/performance/reputation/stress/earnings, recovering=false, all six trained skills and three upgrade levels0. Permanent start effects apply only when initializing a run and are added once to these defaults. Every counter and remainder starts0. Inventory, offers, journal, modifiers, archives, claims and flags start empty; every equipment slot is explicitly null. Business/lastEmployment/pendingEvent are null. Housing room_basic; transport transit_basic. Investment holdings start with zero units/principal/basis, initial fund/equity prices1000, settlementMonth0, acquiredAtRunSeconds0. No property is owned.

Initial nextMinuteAt60, nextMonthAt3600, nextDrawAt120, nextOfferAt600. While offer feature is locked, skip generation and advance its scheduled boundary; once unlocked, use the next600s boundary (no backfilled batches). Promotion target is the profile's next rank, failureCount0, nextAttemptAt0. lastBreakAtSeconds is null, allowing an immediate first free break once life is unlocked. Startup timestamp is injected current UTC, not0. Day tracker starts the injected current UTC day; settings default ko, sound/music/haptics true, reducedMotion follows OS until user override, analytics consent false. Tutorial completion flags are persisted profile metadata; they survive retirement.

Initial seedAllocator is an OS-generated nonzero uint32 created once outside the pure domain. To initialize each run, advance the allocator five times through xorshift32 and assign outputs in promotion/offers/events/market/business order; persist final allocator and all streams atomically. Tests inject allocator1. This is for reproducibility, not cryptographic randomness.

Canonical payload serialization: recursively sort object keys by ASCII/Unicode code-point order, preserve array order, compact JSON without insignificant whitespace, UTF-8 without BOM, no floating numbers, omit only the checksum field. Hash these bytes using SHA-256 and lowercase hex. Normalize no user text during checksum calculation; validation/localization happens earlier. Special sets serialize as sorted unique arrays. Signed money is a decimal string with optional leading minus and no negative zero.

## Config constants and validation boundaries

Materialize at least: offlineCapSeconds28800; gameMonthSeconds3600; monthsPerYear12; initialAge22; maxMoneyWon="1000000000000000000000000000000"; maxLevel100; maxXp1000000000000; coreUpgradeCap200; trainedSkillCap100; effectiveSkillCap150; equipmentIncomeCapBp3000; prestigeIncomeCapBp2000; performanceCap1000; reputationCap1000; stressCap100; minuteSeconds60; performanceBasePerMinute6; promotionCooldownSeconds120; promotionBaseBp7000; promotionMinBp1000; promotionPityStepBp1000; promotionGuaranteedAttempt4; offerIntervalSeconds600; offerExpirySeconds1800; eventFirstAtSeconds120; eventIntervalSeconds300; eventDefaultCooldownSeconds1800; maxOffers3; maxPendingEvents1; breakCooldownSeconds300; retirementAge60; retirementLevel50; retirementPointsCap1000.

Constants with dimensional meaning must carry their unit in the field name. Probability chance is clamped0–10000; positive-weight distributions use integer weights and need not sum10000. Salary bp is positive, employer difficulty0–2000, stress gain0–10, equipment income0–3000, flat item skill modifiers0–100, prestige point costs positive integers. Require growth numerator≥denominator>0. Validate each release profile's feature flags and content counts against PRODUCT_SPEC. Unknown effect enums or missing required fields reject an entire candidate config before activation.

Commands are a closed union: buyUpgrade{id}; trainSkill{id}; attemptPromotion{}; acceptOffer{instanceId}; declineOffer{instanceId}; buyEquipment{id,equip:bool}; equip{id}; unequip{slot}; resolveEvent{instanceId,choiceId}; buyLifeAsset{id}; takeBreak{}; takeLeisure{}; buyInvestment{id,units,quoteRevision} (deposit uses amountWon instead of units); sellInvestment{id,units,quoteRevision} (deposit withdrawal uses amountWon); foundBusiness{typeId}; transferBusinessCapital{amountWon}; withdrawBusiness{amountWon}; hireStaff{role}; dismissStaff{role}; upgradeBusiness{kind}; closeBusiness{previewRevision}; retire{previewRevision}; buyPrestigeUpgrade{id}; startNewLife{}; claimAchievement{id}; claimMission{id,utcDay}; dismissOfflineReceipt{id}. All carry the common command envelope. A command with a payload from another union member is invalid. Asset purchase/deposit/property UI restricts fields to its model; property buy/sell uses units1 only.

Metric enums for achievements/missions: upgradesBought, trainingBought, equipmentBought, promotionsSucceeded, jobsAccepted, eligibleWonEarned, investmentsBought, businessesFounded, qualifyingClosures, retirementsCompleted, eventsResolved. Additional launch metrics need explicit domain event/counter definitions rather than arbitrary property access.
