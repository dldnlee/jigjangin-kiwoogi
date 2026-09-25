# Project working agreement

- Read `README.md`, `FEATURE_CHECKLIST.md`, and `ASSETS.md` before feature work.
- `FEATURE_CHECKLIST.md` is the persistent feature tracker. Update it whenever a feature is added or extended, including work outside scheduled runs. Record delivered scope, validation, visual checks, and remaining work in the same commit as the feature.
- Preserve the Korean portrait-mobile experience and compatibility with existing saves.
- Inspect relevant sprite sheets and the actual running scene before completing a feature. Preserve aspect ratios, frame bounds, feet/seat anchors, character-to-furniture proportions, transparency, and fixed desk placement. Watch full animation loops and transitions; static screenshots alone cannot validate motion.
- Run `flutter analyze` and appropriate tests. Investigate golden mismatches; do not blindly regenerate reference images. The initial local baseline and outstanding visual work are recorded in the checklist.
- For daily scheduled work, finish one bounded, playable increment of the next pending feature. Resolve blocking baseline issues first and record partial progress honestly.
- The user has authorized daily implementation, commits, and pushes to `origin` (`https://github.com/dldnlee/jigjangin-kiwoogi.git`). Inspect the current branch and working tree, preserve unrelated local edits, and stage only this run's changes. Fetch before integrating; never force-push, reset away user changes, or rewrite shared history. If push or validation is blocked, report the exact reason.
- Do not commit generated build files, macOS `._*` metadata, or test failure artifacts. Do not overlap another active development run.
