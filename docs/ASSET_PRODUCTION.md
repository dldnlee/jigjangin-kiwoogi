# Asset production requirements

## Art brief and delivery

Style: coherent hand-drawn 2D office comedy, readable silhouettes and restrained detail at phone scale. A character is approximately 160–200 logical pixels tall in the home scene. Produce one reference sheet before batch production: front/three-quarter view, seated pose, six expressions, palette, line weights, props and office scale. Approve registration with a working in-game composite before expanding variants.

Source files: layered PSD/Krita/SVG or equivalent editable original, sRGB, transparent foregrounds. Runtime: lossless WebP/PNG for raster sprites, SVG for simple icons only if selected renderer supports all used features. No CMYK, text embedded into art, enormous empty transparent canvases, or dependent online fonts. Artwork sources belong in an art-source repository or Git LFS; the app includes optimized exports only.

| Family | Source / export target | Anchors / constraints |
|---|---|---|
| Office/home background | 1080×1200 master; phone-appropriate export | Crop-safe 20% margin; no fixed text |
| Worker frame | 512×512 transparent | Seated pelvis at normalized (0.5,0.72); same anchor every frame |
| Scene props | up to512×512 | Separate front/back occlusion where hands overlap |
| Equipment/achievement icons | 256×256 master; 128/256 exports | 10% padding, silhouette readable at32dp |
| Navigation/actions | 24px viewBox SVG | 2px stroke baseline, 48dp tap area in UI |
| Logos/badges | 256×256 | No real corporate lookalikes |
| Store/promotional art | high-res layered master | Exact required platform dimensions checked CP18 |

Anchor may be revised once in the reference-sheet gate; all exports and manifest must change together. Asset filenames lowercase snake_case, stable ID-based, e.g. `worker_typing_000.png`. Use frame indices starting000. Keep 2px atlas padding/extrusion to avoid bleeding, atlas max2048×2048 initially. Avoid texture layout changes that require gameplay code changes.

## Animation contract

Idle4 frames@4fps loop; typing6@8fps loop; coffee8@8fps once; tired4@4fps loop; sleep4@3fps loop; celebrate10@10fps once; frustrated6@8fps once; phone6@6fps loop; stand6@8fps once; overtime reuses typing frames with a separately authored lighting overlay. Author frame counts as manifest data. Cosmetic layers share body timing and anchors. Preview all outfit+pose combinations for clipping, then sample hair/palette combinations.

Transition priority celebration > reaction > recovery/tired > ordinary typing/idle. Domain emits only semantic state; renderer decides animation transitions. No gameplay callbacks depend on animation completion. Reduced motion uses first clear pose and static glow. Rive can replace raster rig after a prototype and dependency decision, but must satisfy same states and accessibility behavior. No simultaneous Rive/Flame migration in a core checkpoint.

## Audio

WAV 48kHz source; compressed runtime format verified on both mobile platforms. Effects generally≤1s, ambience/music seamless. Normalize consistently, no clipping, soften repeated coin/tap sounds, cap simultaneous effects at4. Start muted until user interaction if a platform requires it; preserve preferences and interruptions. No voice acting required. Include cue sheet, loop points, rights, and short descriptions for reviewers.

## Budgets and QA

Initial download budget≤100MiB, runtime office textures≤40MiB decoded, overall idle memory target≤200MiB on baseline device. Measure actual decoded texture size rather than compressed file size. Lazy-load late-game scenes; precache only current scene and likely next transition. All assets must work offline. Test light/dark OS settings, safe-area crop, text scale, reduced motion, low memory, and scene swapping after equip/promotion.

Rights records must identify author, source, license, commercial use permission, modification permission and attribution. For generated assets record tool, prompt, revision and human approval; inspect hands, Korean glyphs, unintended logos and style consistency. Reference art is guidance, not permission to copy protected characters. Use [ASSET_MANIFEST.md](ASSET_MANIFEST.md) as the handoff checklist.

## Production order

CP00 placeholder office → CP01 income feedback → CP04 rank transformation → CP06 gear registration → CP07 three animation slice → CP08 life scenes → CP10 founder props → CP12 retirement → CP17 complete art/audio/copy → CP18 actual store captures. Before commissioning all 100 item icons, approve five across different slots at real phone size.
