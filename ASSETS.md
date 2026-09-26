# Pixel asset atlas

Generated with the built-in image generation tool; copied into this project. Original outputs are retained. Runtime rendering uses the PNG files directly, preserving alpha transparency. No external image service is used by the game.

## Files

- `assets/sprites/office-rooms.png`: 1536 × 1024 opaque PNG. Four 768 × 512 rooms in row-major order: starter, open plan, manager, executive.
- `assets/sprites/office-sprites.png`: 1254 × 1254 RGBA PNG. Two worker outfits with four typing/blinking frames each; desk, executive desk, plant, bookcase, printer, cooler, cat, trophy.
- `assets/sprites/office-moments.png`: 1254 × 1254 RGBA PNG, sixteen frames in an equal 4 × 4 grid. Rows: deadline stress, quiet celebration, listening/nodding with a report, senior colleague gesturing. The original generation baked in a checkerboard. After explicit user approval, `tools/remove-sprite-checkerboard.ps1` removed only light neutral pixels connected to the outside, preserving the dark outlines and enclosed white clothing. The untouched original is in `art-source/office-moments-generated.png`.
- `assets/office-pixel.png`: first concept scene, retained but superseded in the live scene.
- `assets/fonts/neodgm.ttf`: NeoDunggeunmo 1.601 from https://github.com/neodgm/neodgm. SIL Open Font License in `assets/fonts/OFL.txt`.

- `assets/sprites/office-workstation.png`: 1536 x 1024 RGBA PNG with genuine alpha; four columns and four rows of complete side-view workstations. Each cell is 384 x 256. Rows: typing, deadline stress, celebration, report discussion. The worker sits on a visible chair with feet down, monitor facing them and keyboard under their hands. These replace the separate worker and desk in all scenes; the moments atlas now supplies only the visiting senior.

## Frame layout

The image generator did not produce perfectly equal cells, so the renderer uses explicit normalized source bounds to avoid cutting off feet or sampling adjacent props. `lib/ui/office_scene.dart` contains these source rectangles.

| Frames | Horizontal bounds | Vertical bounds |
|---|---|---|
| Worker 0–3 | four equal quarters | 0–0.28 |
| Manager 4–7 | four equal quarters | 0.28–0.54 |
| Furniture 8–11 | 0 / .265 / .565 / .77 / 1 | .54–.775 |
| Decorations 12–15 | four equal quarters | .775–1 |

Animation: four frames per 1.2 seconds. Layer order: room, lighting tint, rear furniture, visiting senior, complete workstation, cat/award. Room milestones: 1, 6, 11, 16; promotion rank can advance the room sooner. Every level changes furnishing positions and the five-step daylight palette. Draw calls use `FilterQuality.none` and integer destination coordinates.

## Generation prompts

### Workplace moments atlas

Create a NEW transparent pixel-art animation spritesheet matching the attached reference's Korean black-haired glasses worker, white shirt green tie olive pants, same crisp 16-bit cozy office game style. Reference is style/character identity only, not edit target. Exact square image, strict FOUR columns FOUR rows of equal cells, sixteen separate full body figures on genuine alpha transparency. No furniture, no chairs, no background, no letters or labels or grid. Each figure centered in its cell with 12% clear margin all sides, fixed scale and feet anchor. Row1 four animation frames: worker seated pose without chair, stressed by report deadline, hunched, hand on forehead then rubbing temples, worried eyebrows, little blue sweat drop. Row2 four frames: same worker seated, happy approval, smile, small double fist pump and hands raised in quiet celebration. Row3 four frames: same worker seated listening nervously to senior colleague, holding report politely with BOTH HANDS, slight nod and bowed head then looking up; no tears, no violence. Row4 four frames: older Korean team leader with short neatly combed gray-black hair, navy blazer and ID lanyard, standing facing LEFT toward worker, holding a report, stern but professional, small pointing and explaining gestures, mouth variations. Senior roughly same head size as worker, full legs. All rows same pixel scale and consistent frame positions. Keep figures strictly inside their equal quarter cells with transparent padding. No desks or chairs. Output alpha PNG spritesheet suitable for actual frame slicing.

Runtime scenes include focused work, deadline revisions, approval, stern report feedback, iced-coffee break, and meeting preparation. Each vignette lasts 6.5–8.5 seconds, with 8–14 seconds of normal work between them. A shuffled bag prevents immediate repetitions and includes every vignette before reshuffling. Visitors enter, gesture and leave. Cosmetic randomness is independent of the simulation. Reduced motion and backgrounding stop both frames and scene progression. Pixel sparkles, sweat and a coffee cup are separate code-drawn effects.

### Background atlas

Create a production pixel-art background atlas for a cozy Korean office mobile game. Exact 1536x1024 image, a strict 2 column by 2 row grid of four equally sized 768x512 rooms, no gutters or borders. Each cell fills its rectangle. 16-bit crisp square pixels, muted cream sage oak amber palette, straight-on side-view cutaway office with floor bottom 35%, wall upper 65%. NO PEOPLE, NO desk at center foreground (space reserved for sprite worker desk). Top-left: tiny starter office, chipped cream walls, small window Seoul skyline, corkboard, shelves left. Top-right: bright open plan midlevel office, wide window, glass dividers, teal carpet. Bottom-left: manager private office, warm wood wall trim, large skyline window and bookcase. Bottom-right: executive penthouse office, panoramic Seoul sunset windows, walnut wall, awards shelf. All rooms floor baseline y=80% cell height, central lower area clear for sprites. No text, no labels, no UI, no antialiasing. Consistent pixel scale and perspective.

### Character and prop atlas

Production pixel-art spritesheet, exact 1024x1024 transparent PNG with genuine alpha background. Strict invisible 4 columns x 4 rows equal 256x256 cells, no gutters. Every sprite entirely within own cell with 20px transparent margin. Consistent crisp 16-bit square pixel clusters, dark olive outlines, cream sage oak amber palette. Side-view 3/4 cozy Korean office game. Row1: SAME young black-haired glasses office worker seated on chair, white shirt green trousers, facing right typing, four sequential typing animation frames, fixed body anchor bottom center, hands move slightly, one blink. No desk or computer on worker frames. Row2: SAME worker seated wearing navy manager suit, four typing frames same pose and anchor. Row3 four separate furniture props left-to-right: oak work desk with monitor keyboard (view front/side, monitor at right), premium walnut executive desk monitor, leafy terracotta potted plant, tall office bookcase. Row4 props: compact printer, water cooler, sleeping orange cat, gold award trophy. No captions, no grid lines, no baked shadows outside sprites, no backgrounds. All four worker frames identical size and alignment. Keep transparent areas truly alpha.

## Independent furniture and boss animation (September 2026)

- `assets/sprites/office-worker-seated.png`: transparent 1536 x 1024, four columns/four rows; typing, stress, celebration, report. No desks or computers in these frames.
- `assets/sprites/office-boss.png`: transparent four-by-four atlas; rows are leftward walk, rightward walk, scolding, calm report discussion.
- The desk/monitor/keyboard are sampled only from workstation frame zero through fixed furniture bounds. They cannot drift with frame or emotion changes.
- Boss arrival occupies the first 22% of a visit, gestures the middle 56%, departure the last 22%. Direction-specific walking frames track distance; stationary gestures keep their feet planted. Rendering updates every 33 ms for smooth travel. Reduced motion still freezes the entire scene.

Both new sheets were created with built-in image generation. Prompts: seated worker only matching the original proportions and anchor, four frames each of typing/stress/celebration/report, no desk/monitor/keyboard/plant, genuine alpha; boss in navy suit and ID lanyard, four leftward walking frames with contact/passing poses and opposing arm swing, four rightward walking frames, four stern pointing/report gestures and four calm explaining gestures, fixed scale/feet baseline, no furniture or background.

## Customization rendering

F03 reuses the existing atlases without changing the image files. Room choices select one of the existing four 768 × 512 cells, with automatic progression still the default. The walnut finish multiplies only the fixed tabletop source rectangle by a warm dark tint; monitor, keyboard, chair, and character anchors remain unchanged. The small plant scales the same source at the same bottom anchor. The silver cat uses a luminance color matrix preserving alpha and geometry. Hiding the plant or cat omits only that layer. The color filter is cleared before drawing scene effects.

Default selections render identically to old saves. Four separately reviewed `decorated-*.png` macOS references exercise room overrides, walnut finish, small plant, gray cat, and the visiting boss. The fixed-furniture test now checks customized scenes through every frame and mood.


## Chunky customizable worker (2026-09-26)

`assets/sprites/office-worker-pixel-v2.png` is the new 1536 × 1024 RGBA atlas, copied without bitmap processing from the built-in image-generation tool. The previous `office-worker-seated.png` remains available. Four columns and four rows give 384 × 256 source cells: typing, stress, celebration, and report. The source uses purple hair, green shirts, and peach skin as independent palette regions, not the default in-game appearance.

`assets/shaders/character.frag` samples the center of each of 96 × 64 logical pixels per cell. An alpha cutoff removes soft fringes. Purple/green/peach classification selects hair/shirt/skin colors, retaining relative shade; neutral outlines, chair, glasses, navy trousers, tie, and paper retain their source colors. Default colors are charcoal hair, white shirt, and warm skin. `lib/ui/character_palette.dart` contains 11 selectable colors (48 combinations). Add a color there and a matching `OfficeDecoration` entry to extend choices without duplicating animation atlases. New hairstyles or garment silhouettes still require reviewed artwork.

The worker keeps a 3:2 frame ratio, .60 scene-unit width, .18 horizontal anchor, and .02 bottom offset. Furniture still samples fixed rectangles from workstation frame zero. The source has real transparency (1,025,818 fully transparent pixels); generated opaque regions peak at alpha 254, so the renderer intentionally snaps retained samples to full opacity.

Generation prompt: redraw the seated reference in much coarser 64-pixel-tall handheld-RPG pixel art; exact 1536 × 1024 transparent PNG, strict 4 × 4 equal cells, 96 × 64 logical grid enlarged 4×; chunky square clusters, dark outlines, no antialiasing/gradients/hair strands, limited flat palette. Preserve seated proportions, glasses, rightward facing, chair, hands and feet anchors. Four typing/blink frames; four work/forehead/temples/work frames; four fist-pump/raised-hands celebration frames; four report/nod/blink frames. No desk, monitor, keyboard, floor, labels, borders or background. Purple only for hair (#8552ad/#5f387e/#ac79d1), green only for shirt (#4cbf60/#308c45/#8ae58d), peach skin (#edb98a/#bf8058), navy trousers/tie, neutral gray chair/shoes, white paper. Keep every pose inside its cell with a fixed seat and feet baseline.

Reviewed macOS static references cover all six moods, four room tiers, decorated rooms, boss entry/exit, and a silver-haired/coral-shirt/deep-skin example. Automated pixel comparisons verify palette channels change disjoint regions only within the worker bounds, and furniture stays fixed through all moods/frames. Live iOS Simulator review on 2026-09-26 covered all animation loops, boss entry/exit, and palette changes in motion; see `docs/VISUAL_REVIEW.md`. Non-macOS golden baselines have not been revalidated for this replacement artwork.
