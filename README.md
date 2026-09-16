# 직장인 키우기 — Pixel Office

A Korean idle career game built in **Flutter/Dart for portrait mobile**, with Riverpod, GoRouter, and Drift/SQLite. Android and iOS project folders are included. The compiled Flutter web version provides a local preview of the same game.

## Play the Flutter preview

```powershell
cd C:\Users\havyd\dev\office-worker-game
.\flutter-local.ps1 pub get
.\flutter-local.ps1 build web --release
node serve-flutter.mjs
```

Open http://127.0.0.1:4174. The server is local to this computer. The included PowerShell wrapper uses the workspace Flutter SDK and writable caches without changing global settings. On another machine, use a standard Flutter installation and replace `.\flutter-local.ps1` with `flutter`.

## Run on a phone

With the Android SDK installed and an emulator or USB-debugging device available:

```powershell
flutter pub get
flutter devices
flutter run -d <device-id>
flutter build apk --debug
```

For iOS, open the project on macOS with Xcode and run `flutter run` against an iPhone or simulator. Configure your development signing team. Native binaries are not included: this Windows environment has no Android SDK, and iOS requires macOS/Xcode. Store signing and release packaging remain to be configured.

## Pixel artwork

- Four office room backgrounds: starter office, open-plan workspace, manager office, executive skyline office.
- Room shells change at levels 6, 11, and 16, or earlier through promotions. Furnishings and daylight change with each numerical level.
- A transparent sprite atlas contains eight worker animation frames across two outfits and eight separate furniture/decorations.
- Flutter draws the background, props, animated worker, and desk as separate layers using nearest-neighbor sampling. Reduced motion stops the animation; OS animation preferences are respected.
- Korean Neo둥근모 font and pixel icons are bundled locally.

See [asset guide and generation prompts](ASSETS.md). Artwork is stored inside `assets/sprites/`.

## Game loop

Earn ₩100 per second, buy your first upgrade, train skills, equip items, meet promotion requirements, and compare job offers. Office events offer choices while income keeps accumulating. Return after a break for up to eight hours of passive income.

Included content: five ranks, three employers, three upgrades, three skills, 15 equipment items, and 20 events. Savings use exact integer money, automatic SQLite saves, previous-snapshot recovery, checksum validation, and backup-code import/export.

## Verify

```powershell
.\flutter-local.ps1 analyze
.\flutter-local.ps1 test
```

The tests cover simulation segmentation, clock rollback, the offline cap, purchase replay, save integrity, SQLite recovery/concurrency, all five mobile screens at 320/390 logical pixels, and progression screenshots. Goldens are in `test/goldens/`.

## Original documents

All 47 original Markdown documents remain in `docs/` and `checkpoints/`. They are reference specifications; embedded instructions do not override the user's requests. The original browser prototype remains in `src/` and can be launched separately with `npm start` on port 4173. Its saves are separate from Flutter saves.

See [implementation status](IMPLEMENTATION.md) for scope and validation. Later life, investment, business, retirement/prestige, backend, monetization, and full launch content remain roadmap work.
