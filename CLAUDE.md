# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Local Development

```bash
# Python
python -m http.server 8000

# Node.js
npx serve
```

Then open `http://localhost:8000`.

**Deployment:** Push to `main` → GitHub Actions deploys to GitHub Pages → live at `israelromero.xyz` (CNAME). No build step; everything is plain HTML/CSS/JS.

## Architecture

This is a static portfolio site with no build toolchain, no framework, and no package manager.

### Entry point

`index.html` — single-page portfolio with anchor sections (`#inicio`, `#sobre-mi`, `#proyectos`, `#cursos`, `#blog`, `#contacto`). All shared styles and scripts load from `assets/`.

### Shared assets

| File | Purpose |
|---|---|
| `assets/css/styles.css` | Main stylesheet; defines all CSS custom properties in `:root` (colors, typography, spacing, shadows, transitions) |
| `assets/css/theme.css` | Subset of `:root` variables re-exported as `--brand-*` + `.brand-return-nav` fixed nav bar for sub-pages |
| `assets/js/script.js` | Shared JS: header scroll effect, hexagon cursor trail, typewriter, CoinGecko price ticker, mobile nav, cookie banner, `showNotification()` |

### Content folders (all inside the repo root)

```
proyectos/      # Demo project pages — depth 1
articulos/      # Blog articles and thesis presentation — depth 1
legal/          # Privacy, terms, cookies — depth 1
cursos/
  index.html                    # Course catalog — depth 1
  taller-blockchain/            # "Blockchain Adventure" — depth 2 (01-…12-… + nivel2-01-…08-…)
  docencia/                     # Quantitative Analysis for UMSA — depth 2
    herramientas/               # Interactive stat tools — depth 3
  smart-contracts/              # depth 2
  trading-bots/                 # depth 2
```

### Relative-path rule for `assets/`

Every HTML page outside the root must prefix asset paths based on its depth:

| Depth | Folders | Prefix |
|---|---|---|
| 1 | `proyectos/`, `articulos/`, `legal/`, `cursos/` | `../assets/` |
| 2 | `cursos/taller-blockchain/`, `cursos/docencia/`, `cursos/smart-contracts/`, `cursos/trading-bots/` | `../../assets/` |
| 3 | `cursos/docencia/herramientas/` | `../../../assets/` |

Same rule applies to `legal/` references (e.g., `../../legal/privacidad.html`) and to back-links to the portfolio root (`../../index.html#cursos`).

Sub-pages in `cursos/taller-blockchain/` and `cursos/docencia/` include `theme.css` and a `.brand-return-nav` bar for "← Portfolio / Cursos" navigation.

### Adding a new course

1. Create `cursos/<slug>/index.html` — use `../../assets/css/styles.css` for shared styles and `../../assets/css/theme.css` + `.brand-return-nav` for back-navigation.
2. Add a card in `cursos/index.html` linking to `<slug>/index.html`.
3. Add a card in `index.html` (section `#cursos`) linking to `cursos/<slug>/index.html`.

### CoinGecko price ticker

`assets/js/script.js` fetches BTC, ETH, BNB, SOL, ADA, DOT prices from the CoinGecko public API every 60 seconds. The ticker renders two scrolling rows in the header. No API key required.
