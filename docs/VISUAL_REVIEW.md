# Visual review — 2026-09-25

## Environment and baseline

Reviewed on macOS 26.5.2 with Flutter 3.47.0 / Dart 3.13.0; live app on iPhone 17 Pro / iOS 26.5 simulator. The original project records Flutter 3.47.4 / Dart 3.13.3 on Windows. Comparing the old references on this Mac produced roughly 0.8–2% pixel differences, concentrated in text rasterization and small sprite edges. Layout, room framing, and desk positions remained consistent in the reviewed images. OS and SDK changed together, so this does not isolate which renderer difference caused each pixel discrepancy.

Added separate macOS references rather than weakening pixel comparison or overwriting the original references. Reviewed the office at levels 1, 6, 11, and 16, all six scene previews, and boss arrival/departure individually. `test/mobile_layout_test.dart` selects the macOS directory on macOS and retains the original references elsewhere. Other hosts were not run during this delivery.

## Sprite and animation observations

- Inspected `office-worker-seated.png`, `office-boss.png`, and `office-workstation.png` plus the runtime source rectangles. The worker uses 384 × 256 cells; the boss uses quarter-width/quarter-height cells. Worker aspect ratio is now derived from the worker image itself instead of relying on workstation dimensions.
- The seated worker, chair, monitor, and fixed desk align across poses. Boss head scale is comparable to the worker's; walking direction changes for departure. No new stretched limbs or unexpected scene clipping was found.
- Reviewed a recorded live office cycle and scene snapshots covering report feedback, coffee, meeting preparation, approval, regular work, and deadline stress, including sequential boss arrival/gesture/departure samples. The four-frame tests verify desk pixels across all six moods, and lifecycle tests verify animation freezes when reduced motion or backgrounding is active.
- Source sheets have some soft/color fringes around the boss, and typing poses vary only subtly. At the reviewed mobile sizes these were not blocking. Richer typing motion and deliberate edge cleanup can be separate art-polish work; no sprites were regenerated in F01.
- The white strips during deadline scenes are code-drawn paper effects, not a shifting desk source crop.

## F01 interaction review

Ran presentation start, live countdown, completion, and reward collection on the simulator. Confirmed the next assignment unlocks and the result remains visible. The project board uses a scrolling sheet so the office stage stays fixed. Added automated UI checks at 320 × 568 and 390 × 844 for start, repository reload, offline notice dismissal, reward collection, and next-project unlock. Costs, success odds, loss conditions, and skill caps are shown before starting.

Visual inspection found an existing progress-meter bug: its fill had zero height. Set the fill's height factor and added a rendered-size regression test. The simulator now shows both XP and project progress fills.

## Repeatable validation

Run `python3 tools/verify.py` from the repository root. It runs analysis and all Dart test files, excludes AppleDouble sidecars from discovery, and cleans only generated native-asset metadata. Review golden differences before using `--update-goldens`; an update alone is not verification. Preserve the original references for their original host environment.
