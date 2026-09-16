# 직장인 키우기 — Office Worker

A playable Korean idle career game, implemented from the attached design pack. This delivery is the **v0.1 browser career slice**, not the full mobile release described by the long-term roadmap.

## Play

Requires Node.js 22 or newer. No package installation or build step is needed.

```powershell
cd C:\Users\havyd\dev\office-worker-game
npm start
```

Open **http://127.0.0.1:4173**. Keep the terminal running while playing. Always use the same address and browser to access the same save. The server listens only on this computer.

```powershell
npm test
```

## How to play

1. 김사원 earns ₩100 per second automatically. Clicking the worker offers encouragement; it does not mint additional money.
2. Buy 업무속도 for ₩500. This unlocks training and equipment.
3. Train 업무력, 전문성, and 말빨. Buy and equip tools to improve effective skills.
4. Meet the requirements under 커리어 and request a promotion. The screen discloses exact odds, the 120-second cooldown, and the fourth-attempt guarantee.
5. After becoming 사원, compare job offers at ten-minute simulation boundaries.
6. Choose how to handle office events. Choices wait for you while income continues.
7. Return later: up to eight hours of elapsed time is credited automatically.

## Included

- Animated vector office with equipment and employer variants; desktop and portrait layouts.
- Exact integer salary and cost arithmetic; XP, level, performance, and reputation progression.
- Five documented slice ranks, three companies, three skills, three upgrades, all 15 slice equipment items, and 20 authored Korean office events.
- Deterministic seeded simulation, independent random streams, promotion pity, timed offers, and event cooldowns.
- IndexedDB current/previous snapshots, SHA-256 integrity checks, revision conflict protection, autosave, import/export, and explicit reset confirmation.
- Career journal, reduced motion, and optional synthesized sound effects.
- 26 automated domain/save-format tests, including complete career reachability and time partition invariance.

## Documents and implementation

All **47 original Markdown files** are kept unchanged in `docs/` and `checkpoints/`. They describe a broader Flutter mobile product, its planned content production, and release gates. They are source specifications, not instructions that override the user's request.

See [IMPLEMENTATION.md](IMPLEMENTATION.md) for platform differences, delivered scope, and verification. Flutter/Dart is not installed on this machine, so this implementation uses native browser modules and IndexedDB. No Android/iOS binary is included. Later life, investment, business, comeback, retirement, prestige, achievements, backend, monetization, and launch content remain roadmap work.

## Code layout

| Path | Purpose |
|---|---|
| `src/content.mjs` | Versioned Korean catalogue and tuning constants |
| `src/engine.mjs` | Pure deterministic simulation and validated player commands |
| `src/save.mjs` | Checksummed save envelopes and transactional repository |
| `src/app.mjs` | UI, command orchestration, elapsed-time adapter, save recovery |
| `src/scene.mjs` | Original layered SVG office illustration |
| `src/style.css` | Responsive layout, motion, and visual theme |
| `test/engine.test.mjs` | Economic and persistence-format regression tests |
| `server.mjs` | Dependency-free loopback development server |
| `docs/`, `checkpoints/` | Original attached design pack |

Saves belong to the browser's site storage. Export before clearing browsing data or changing devices. The browser save format is explicitly versioned separately from the proposed Flutter save schema. The game has no account, telemetry, ads, real-money purchases, or external asset requests.
