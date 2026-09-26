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

## F03 customization review

Reviewed the original props atlas (plant and cat), fixed-workstation source crop, and all four decorated-room reference images. The first reference-generation attempt lacked a Material text-style ancestor, producing placeholder glyphs; corrected the test harness to use a Scaffold and reviewed the newly rendered Korean text before accepting references. Existing golden images were not replaced.

The custom desk maintains the same tabletop, monitor, and leg geometry across moods. The gray cat preserves its silhouette and alpha; the smaller plant keeps its floor anchor. Room changes use a cover crop, preserving the background aspect ratio. Live simulator checks covered the explicit apply flow, a saved walnut selection, and animated preview. Widget tests at 320/390 cover locked previews, discarding an unapplied choice when changing categories, applying, SQLite reload, and rendering the saved selection on the office screen. Domain tests cover old saves, rank/level unlocks, malformed backups, reversible choices, replay, and absence of gameplay bonuses.


## 2026-09-26 — Character appearance, hold-to-repeat, navy UI refresh

Inspected the generated 1536×1024 transparent 4×4 worker source. Runtime uses a 96×64 cell grid, hard alpha edges, and independent hair/shirt/skin colors. Worker is coarser, keeps chair/feet seated at the floor and hands near the keyboard; raised arms remain clear of the monitor. Boss artwork retains its existing finer detail. Palette-isolation tests confirm changing one channel cannot recolor another, the room, or furniture.

Each of the 16 changed macOS references was compared against the previous commit. The 12 scene, decorated-room and boss references differ only inside the worker bounds (about x 100–305, y 252–408 at 390 px): the new sprite, whose chair and shoes are neutral gray instead of the previous green chair and brown shoes. The four full-screen references (`mobile-office`, `office-level-6/11/16`) also change outside the scene because of the navy backdrop, rounded panels/buttons/meter, and light-on-navy captions. Desk, monitor, props, cat, and boss pixels are unchanged. `character-customized.png` is new.

Live iOS review passed on 2026-09-26 (iPhone 17 Pro Simulator, debug build from an APFS mirror because external-volume `._*` files break Xcode's native-asset step). Screen recordings were inspected frame by frame: typing loop, deadline stress, report pose, boss arrival, scolding, reply, departure off the right edge, and return to typing, both in the office and in the animated customization preview with a silver-haired worker. The fragment shader works on iOS: silver/purple hair, sage shirt, and deep skin each recolored only their channel. Applied choices persisted across a force-quit. Holding the 전문성 training button bought consecutive levels and stopped on release. The existing level-14 save loaded without migration issues.

Legacy non-macOS golden references have not been regenerated on their target renderer.
