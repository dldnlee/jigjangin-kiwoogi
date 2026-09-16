# Complete planned asset manifest

This is the complete production inventory by asset family for the specified release scope. It is a work order, not a claim that art/audio exists. Every range expands to stable IDs in `assets/art/manifest.json` at CP17. Counts below are **logical assets**, not exported frame counts; animation frame requirements are in [ASSET_PRODUCTION.md](ASSET_PRODUCTION.md). Reuse is allowed only where explicitly described. Budgets are starting targets to profile.

## Character and scene

| ID family | Slice | Launch | Requirement |
|---|---:|---:|---|
| worker_base_01 | 1 | 1 | Neutral customizable office worker; full layered source |
| worker_outfit_01…06 | 2 | 6 | Entry, smart casual, manager, executive, founder, retired |
| worker_hair_01…06 | 1 | 6 | Shared anchors; cosmetic choice |
| worker_palette_01…06 | 1 | 6 | Skin palette definitions; animation shared |
| worker_anim_{idle,typing,coffee,tired,sleep,celebrate,frustrated,phone,stand,overtime} | 3 | 10 | Slice idle/typing/celebrate; all outfits must support every shipped animation |
| worker_expression_{neutral,happy,tired,worried,proud,surprised} | 3 | 6 | Face layers, not full duplicate characters |
| office_bg_01…06 | 2 | 6 | Shared desk, modern, team lead, private, executive, skyline |
| founder_bg_01…04 | 0 | 4 | Spare room, coworking, studio, headquarters |
| home_bg_01…03 | 0 | 3 | Housing variants; event/recap use |
| desk_01…06 | 2 | 6 | Rank-scene props; no equipment slot |
| chair_01…06 | 2 | 6 | Compatible sitting anchor |
| prop_laptop_01…05 | 3 | 5 | Slice items map directly; later items may reuse |
| prop_monitor_01…03 | 1 | 3 | Upgrade decoration |
| prop_bag_01…03 | 2 | 3 | Attachment beside chair |
| prop_accessory_01…05 | 2 | 5 | Desk objects; not every accessory needs a unique model |
| prop_{mug,plant,phone,calendar,files,window_light} | 6 | 6 | Reusable scene dressing |
| npc_portrait_01…08 | 2 | 8 | Boss, peer, junior, recruiter, customer, mentor, supplier, friend |
| staff_portrait_01…05 | 0 | 5 | Developer/designer/marketer/sales/operations |
| transport_01…03 | 0 | 3 | Transit, bicycle, compact car |

Scene render order: background → window light → chair rear → worker body → desk → laptop/monitor → hands/front layer → mug/attachments → feedback. Production provides occlusion masks and consistent hand/desk registration. No full combination export for every hair/skin/outfit permutation.

## Icons and UI

| ID family | Slice | Launch | Requirement |
|---|---:|---:|---|
| equipment_{slot}_{index}_icon | 15 | 100 | One identifiable icon per catalogue item; launch split laptop15, phone15, suit15, shoes15, watch10, bag15, accessory15 |
| company_{id}_logo | 3 | 15 | Fictional employer marks matching company IDs |
| rank_{id}_badge | 5 | 9 | IDs in career config |
| skill_{work,expertise,talk,mental,leadership,luck}_icon | 3 | 6 | No decorative-only stats |
| upgrade_{speed,efficiency,focus}_icon | 3 | 3 | Distinct silhouettes |
| investment_{steady_deposit,broad_basket,bright_share,rental_unit}_icon | 0 | 4 | Fictional models |
| business_{typeId}_icon | 0 | 6 | One per business table |
| achievement_01…50_icon | 0 | 50 | 10 beta; reusable frame, distinct central glyph |
| prestige_{id}_icon | 0 | 15 | Five beta; match permanent IDs |
| event_category_{boss,peer,meeting,project,review,customer,bonus,error,opportunity,life,business,leisure}_icon | 8 | 12 | Reuse across 300 events; no illustration per event required |
| life_{room_basic,room_bright,home_quiet,transit_basic,bicycle,compact_car}_icon | 0 | 6 | 3 housing+3 transport |
| currency_{won,xp,career_points,gems}_icon | 2 | 4 | Gems hidden until monetization |
| ui_navigation_{office,career,assets,life,more}_icon | 3 | 5 | Selected/unselected via color/state |
| ui_action_{settings,back,close,info,help,lock,check,plus,minus,refresh,share,sound,music,haptics,warning,save,cloud,offline}_icon | 14 | 18 | Prefer consistent licensed vector set |
| ui_rarity_{common,uncommon,rare,epic,legendary}_frame | 3 | 5 | Text label plus shape/color |
| ui_{button,panel,card,progress,tab,toast,modal,skeleton,tooltip}_component | 9 | 9 | Flutter components; no raster exports needed |

Icon item index convention uses two digits per slot (`laptop_01`, etc.). Do not reuse one ID for multiple meanings. Cosmetics launch starter set: six outfits, six hair options, six palette choices above; basic inclusive customization is free, and any paid outfit uses the same stat-free model.

## Effects, sound, and non-game assets

| IDs | Slice | Launch | Deliverable |
|---|---:|---:|---|
| fx_{income,upgrade,promotion,level_up,job_change,event_positive,event_negative,business_open,closure,retirement} | 3 | 10 | Slice first3; procedural Flutter effects preferred |
| sfx_{tap,upgrade,train,equip,promotion,level_up,offer,event,coins,error,found,closure,retire,claim} | 5 | 14 | Short, soft; slice tap/upgrade/promotion/coins/error |
| ambience_{office,cafe,studio,home} | 1 | 4 | Seamless restrained loops |
| music_{office,progress,founder,retirement} | 1 | 4 | 60–120s seamless compositions |
| app_icon_master | 0 | 1 | Layered vector/high-resolution source; platform exports generated |
| launch_mark | 1 | 1 | Platform splash-compatible mark |
| store_screenshot_{android,ios}_01…06 | 0 | 12 | Actual release UI; captions separate and localizable |
| store_feature_graphic | 0 | 1 | Platform-specific export verified at release |
| promo_key_art | 0 | 1 | Worker career transformation, 16:9 master |
| tutorial_diagram_01…03 | 0 | 3 | Optional simple vectors if hints need them; CP17 may mark unnecessary with reason |
| font_korean_family | 1 | 1 | Regular/medium/bold files and license |
| localization_ko / localization_en | 1 | 2 | Korean complete; English fallback UI and source strings, not a promised launch locale |

## Asset record and tracking

Each asset row in the implementation manifest records id, sourcePath, runtimePath, dimensions, scale, anchor, atlasGroup, animationStates, license/creator, milestone, owner, status (brief/source/export/integrated/approved), review evidence. For derived variants also record parentId. Track copy strings and audio alongside art. No asset enters approved without visual/audio review and rights record. Placeholder geometric art is permitted through CP14 but must be tagged and absent from CP18 release.
