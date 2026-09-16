# Technical architecture

## Stack and decision

Flutter/Dart mobile client, Riverpod for dependency injection and UI state, GoRouter for navigation, Drift/SQLite for durable local state, bundled JSON for configuration, Flutter localization (ARB) for Korean copy. Pin mutually compatible stable versions and commit `pubspec.lock` at CP00; this document deliberately does not guess future SDK constraints. Maintain Android and iOS build verification separately; iOS signing/builds require a macOS runner.

The architecture separates UI and data access as recommended by [Flutter's architecture guide](https://docs.flutter.dev/app-architecture/guide), with an additional pure Dart simulation for this game. [Flutter's offline-first guidance](https://docs.flutter.dev/app-architecture/design-patterns/offline-first) informs the local repository boundary. Riverpod providers support injected dependencies ([official setup](https://riverpod.dev/docs/introduction/getting_started)); [GoRouter](https://pub.dev/packages/go_router) supplies declarative navigation. These sources support library capabilities; game rules and performance budgets are project decisions.

## Dependency direction

`widgets → Riverpod controllers → application command service → pure domain`.

`application service → repository interfaces ← Drift / optional cloud adapters`.

Domain imports Dart core and its own value objects only. No BuildContext, Riverpod, SQL classes, JSON map mutation, clocks or SDK clients in domain. Rendering observes read models; its animation frame rate never drives economic time. Application owns scheduling, transactions and orchestration. Config parsers convert JSON into immutable validated domain definitions.

## Expected repository

```text
lib/
  app/                 # bootstrap, theme, router, provider composition
  domain/
    model/             # immutable state and typed IDs
    economy/           # Money, formulas, ledger sources
    simulation/        # advance, boundaries, deterministic RNG
    career/ skills/ equipment/ events/ life/
    investments/ business/ prestige/ achievements/
  application/         # command queue, controller, clock, receipts
  data/
    config/            # parse/validate bundled and cached configs
    persistence/       # Drift database, repository, migrations
    services/          # disabled/no-op ports, optional adapters
  features/
    office/ career/ skills/ equipment/ events/ life/
    investments/ business/ retirement/ achievements/ settings/ shop/
  shared/              # widgets, localized number formatting
assets/data/           # JSON content profiles and schema manifests
assets/art/            # optimized runtime graphics only
assets/audio/
lib/l10n/              # ARB copy
test/domain/ test/data/ test/widgets/ test/fixtures/
integration_test/
tool/                  # validation, deterministic balance runner
docs/ checkpoints/
```

## State flow

1. Boot reads bundled config, validates it, then opens/migrates save.
2. Restore latest valid committed snapshot and its pinned config.
3. Inject production clock; settle elapsed time through pure simulation.
4. Commit new snapshot, receipts, and events atomically.
5. Publish immutable state through GameController provider.
6. On action enqueue typed command with ID, expected revision and arguments. Settle to now; revalidate and apply; commit; then acknowledge UI.

Use a loading/error/ready bootstrap state. Commands during migration are disabled. UI can animate optimistic button feedback but must not display an uncommitted purchase as successful. A DB failure keeps the last committed model authoritative and offers retry.

## Performance and rendering

Start with layered Flutter images and a single animation controller. Isolate rapidly changing cash text from static panels using narrow provider selections. Only the office scene animates continuously while visible; pause animations when backgrounded. Use repaint boundaries where profiling supports them. Rate updates are 4Hz presentation snapshots; accounting uses elapsed time. Target 60fps on the agreed baseline device, p95 frame≤16.7ms during office idle, cold-start usable≤3s, eight-hour replay≤500ms after optimization. Treat these as measured budgets, not promises. If replay exceeds budget, move pure calculation to an isolate and revision-check result.

Optional Flame decision requires profiling evidence that Flutter scene composition is the bottleneck and a prototype preserving semantics/accessibility. Introduce only behind `OfficeSceneRenderer`; no domain rewrite or engine-owned save state. No dependency added solely for possible future use.

## Services

Define small ports for analytics, cloud backup, entitlements, rewarded ads and remote config when their checkpoints begin. No SDK initialization before the relevant feature/consent gate. Baseline adapters are absent or no-op; testing uses fakes. Vendor selection is recorded before CP15/CP16, with package/platform/privacy verification at that time. Remote code execution and script-based gameplay are prohibited.
