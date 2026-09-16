# Flutter implementation record

Updated 2026-09-16. Flutter 3.47.4 / Dart 3.13.3.

## Delivered

- Portrait Flutter app with five routes: office, career, skills, equipment, journal.
- Riverpod controller publishes committed actions, ticks elapsed income, saves every five seconds, and handles background/resume settlement.
- Dart simulation uses BigInt money, floor-ordered salary multipliers, exact geometric costs, independent seeded random streams, pity promotions, cooldowns, offers, and choice events.
- Drift database atomically stores current/previous snapshots and a revision. SHA-256 checksums detect corruption; stale revisions are rejected. Backup import and reset require in-game confirmation.
- Layered pixel-art scene uses room and sprite atlases, four-frame typing/blinking, level-based decor, tier-based room shells, and promotion outfits. Assets are bundled with the game.
- Android/iOS scaffolds and a compiled web preview of the same Flutter application.

## Verification

Automated domain and SQLite tests cover initial salary and leveling, integer tick accumulation, simulation segmentation, eight-hour offline cap, backward clock handling, atomic/replayed purchases, checksum tampering, room tier selection, stale SQLite writes, and recovery from a broken current snapshot.

Widget coverage visits all five routes at 320 and 390 logical pixels. Four mobile screenshots cover the starter room and levels 6, 11, 16. The real preview was checked for Korean font rendering, artwork transparency, upgrade controls and persistence.

## Boundaries

This is the playable v0.1 career content slice on the requested Flutter platform. It does not certify the design pack's full release gates. Four authored base interiors are recomposed with level-specific furniture and lighting, rather than 100 independently painted rooms. Native device performance, Android APK packaging and iOS signing/builds have not been verified in this environment. Android SDK is absent; iOS needs macOS/Xcode. Launcher icons currently use generated Flutter project defaults.

The legacy JavaScript prototype remains available separately. Flutter backups have a distinct schema and do not import legacy browser saves. Original documentation is retained unchanged; historical browser records are in LEGACY_BROWSER.md and LEGACY_IMPLEMENTATION.md.
