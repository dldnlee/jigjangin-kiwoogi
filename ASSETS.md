# Pixel asset atlas

Generated with the built-in image generation tool; copied into this project. Original outputs are retained. Runtime rendering uses the PNG files directly, preserving alpha transparency. No external image service is used by the game.

## Files

- `assets/sprites/office-rooms.png`: 1536 × 1024 opaque PNG. Four 768 × 512 rooms in row-major order: starter, open plan, manager, executive.
- `assets/sprites/office-sprites.png`: 1254 × 1254 RGBA PNG. Two worker outfits with four typing/blinking frames each; desk, executive desk, plant, bookcase, printer, cooler, cat, trophy.
- `assets/office-pixel.png`: first concept scene, retained but superseded in the live scene.
- `assets/fonts/neodgm.ttf`: NeoDunggeunmo 1.601 from https://github.com/neodgm/neodgm. SIL Open Font License in `assets/fonts/OFL.txt`.

## Frame layout

The image generator did not produce perfectly equal cells, so the renderer uses explicit normalized source bounds to avoid cutting off feet or sampling adjacent props. `lib/ui/office_scene.dart` contains these source rectangles.

| Frames | Horizontal bounds | Vertical bounds |
|---|---|---|
| Worker 0–3 | four equal quarters | 0–0.28 |
| Manager 4–7 | four equal quarters | 0.28–0.54 |
| Furniture 8–11 | 0 / .265 / .565 / .77 / 1 | .54–.775 |
| Decorations 12–15 | four equal quarters | .775–1 |

Animation: four frames per 1.2 seconds. Layer order: room, lighting tint, rear furniture, worker, desk, cat/award. Room milestones: 1, 6, 11, 16; promotion rank can advance the room sooner. Every level changes furnishing positions and the five-step daylight palette. Draw calls use `FilterQuality.none` and integer destination coordinates.

## Generation prompts

### Background atlas

Create a production pixel-art background atlas for a cozy Korean office mobile game. Exact 1536x1024 image, a strict 2 column by 2 row grid of four equally sized 768x512 rooms, no gutters or borders. Each cell fills its rectangle. 16-bit crisp square pixels, muted cream sage oak amber palette, straight-on side-view cutaway office with floor bottom 35%, wall upper 65%. NO PEOPLE, NO desk at center foreground (space reserved for sprite worker desk). Top-left: tiny starter office, chipped cream walls, small window Seoul skyline, corkboard, shelves left. Top-right: bright open plan midlevel office, wide window, glass dividers, teal carpet. Bottom-left: manager private office, warm wood wall trim, large skyline window and bookcase. Bottom-right: executive penthouse office, panoramic Seoul sunset windows, walnut wall, awards shelf. All rooms floor baseline y=80% cell height, central lower area clear for sprites. No text, no labels, no UI, no antialiasing. Consistent pixel scale and perspective.

### Character and prop atlas

Production pixel-art spritesheet, exact 1024x1024 transparent PNG with genuine alpha background. Strict invisible 4 columns x 4 rows equal 256x256 cells, no gutters. Every sprite entirely within own cell with 20px transparent margin. Consistent crisp 16-bit square pixel clusters, dark olive outlines, cream sage oak amber palette. Side-view 3/4 cozy Korean office game. Row1: SAME young black-haired glasses office worker seated on chair, white shirt green trousers, facing right typing, four sequential typing animation frames, fixed body anchor bottom center, hands move slightly, one blink. No desk or computer on worker frames. Row2: SAME worker seated wearing navy manager suit, four typing frames same pose and anchor. Row3 four separate furniture props left-to-right: oak work desk with monitor keyboard (view front/side, monitor at right), premium walnut executive desk monitor, leafy terracotta potted plant, tall office bookcase. Row4 props: compact printer, water cooler, sleeping orange cat, gold award trophy. No captions, no grid lines, no baked shadows outside sprites, no backgrounds. All four worker frames identical size and alignment. Keep transparent areas truly alpha.
