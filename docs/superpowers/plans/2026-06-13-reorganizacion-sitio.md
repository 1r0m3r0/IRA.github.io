# Reorganización del sitio (Fase 1 + Fase 2) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reorganizar los 47 HTML del repo en una estructura de carpetas clara (`proyectos/`, `articulos/`, `cursos/<slug>/`, `legal/`), con nombres descriptivos, todos los enlaces internos corregidos, formulario de contacto eliminado, README actualizado, y una capa mínima de coherencia visual (tema compartido + nav de retorno) en los materiales de docencia.

**Architecture:** Fase 1 se ejecuta con un script Python de migración (`migrate.py`, temporal) que hace `git mv` + reescritura de enlaces relativos según una tabla de mapeo explícita, seguido de ediciones manuales puntuales (index.html, cursos/index.html nuevo, README.md). Fase 2 agrega `assets/css/theme.css` (variables de tema compartidas) y un snippet de nav/footer de retorno inyectado en las páginas de `cursos/taller-blockchain/` y `cursos/docencia/`.

**Tech Stack:** HTML/CSS/JS estático, Python 3 (script de migración temporal), git.

---

## Tabla de mapeo (ruta vieja → ruta nueva)

| Viejo | Nuevo |
|---|---|
| demo-trading-bot.html | proyectos/demo-trading-bot.html |
| demo-defi-dashboard.html | proyectos/demo-defi-dashboard.html |
| demo-risk-analytics.html | proyectos/demo-risk-analytics.html |
| demo-crypto-payment.html | proyectos/demo-crypto-payment.html |
| demo-market-sentiment.html | proyectos/demo-market-sentiment.html |
| demo-blockchain-explorer.html | proyectos/demo-blockchain-explorer.html |
| articulo-defi-layer2.html | articulos/articulo-defi-layer2.html |
| articulo-estrategias-algoritmicas.html | articulos/articulo-estrategias-algoritmicas.html |
| articulo-ml-trading.html | articulos/articulo-ml-trading.html |
| Presentaciondetesis.html | articulos/presentacion-tesis.html |
| TallerBasico.html | cursos/taller-blockchain/index.html |
| 1.html..12.html | cursos/taller-blockchain/01-portal-inicio.html ... 12-certificado.html (ver lista completa abajo) |
| c1.html..c8.html | cursos/taller-blockchain/nivel2-01-nfts.html ... nivel2-08-escape-room.html |
| curso-analisis-cuantitativo.html | cursos/docencia/index.html |
| articulocientifico.html | cursos/docencia/articulos-cientificos-economia.html |
| normal.html | cursos/docencia/herramientas/laboratorio-pruebas-hipotesis.html |
| normalidad.html | cursos/docencia/herramientas/pruebas-normalidad.html |
| chicuadrado.html | cursos/docencia/herramientas/prueba-chi-cuadrado.html |
| pruebast.html | cursos/docencia/herramientas/prueba-t.html |
| pruebasz.html | cursos/docencia/herramientas/prueba-z.html |
| regresymu.html | cursos/docencia/herramientas/regresion-lineal-python.html |
| Logit.html | cursos/docencia/herramientas/regresion-logistica-python.html |
| PythonCorr.html | cursos/docencia/herramientas/correlaciones-python.html |
| curso-smart-contracts.html | cursos/smart-contracts/index.html |
| curso-trading-bots.html | cursos/trading-bots/index.html |
| privacidad.html | legal/privacidad.html |
| terminos.html | legal/terminos.html |
| cookies.html | legal/cookies.html |

Lista completa 1-12 / c1-c8:

```
1.html  -> cursos/taller-blockchain/01-portal-inicio.html
2.html  -> cursos/taller-blockchain/02-problema-confianza.html
3.html  -> cursos/taller-blockchain/03-construye-tu-cadena.html
4.html  -> cursos/taller-blockchain/04-hashing-magico.html
5.html  -> cursos/taller-blockchain/05-bitcoin-mineria.html
6.html  -> cursos/taller-blockchain/06-wallet-monedero.html
7.html  -> cursos/taller-blockchain/07-contratos-inteligentes.html
8.html  -> cursos/taller-blockchain/08-defi-banco-sin-ventanillas.html
9.html  -> cursos/taller-blockchain/09-tokenizacion-activos.html
10.html -> cursos/taller-blockchain/10-riesgos-y-seguridad.html
11.html -> cursos/taller-blockchain/11-quiz-repaso.html
12.html -> cursos/taller-blockchain/12-certificado.html
c1.html -> cursos/taller-blockchain/nivel2-01-nfts.html
c2.html -> cursos/taller-blockchain/nivel2-02-daos.html
c3.html -> cursos/taller-blockchain/nivel2-03-interoperabilidad.html
c4.html -> cursos/taller-blockchain/nivel2-04-layer2.html
c5.html -> cursos/taller-blockchain/nivel2-05-crea-tu-token.html
c6.html -> cursos/taller-blockchain/nivel2-06-forense-blockchain.html
c7.html -> cursos/taller-blockchain/nivel2-07-carreras-blockchain.html
c8.html -> cursos/taller-blockchain/nivel2-08-escape-room.html
```

Archivos sin mover: `index.html`, `README.md`, `CNAME`, `.gitignore`, `.github/`, `assets/`.

## Reglas de reescritura de enlaces

1. **Enlaces entre archivos movidos** (presentes en la tabla de mapeo): reescribir el `href` a la ruta relativa correcta entre el archivo nuevo y el destino nuevo.
2. **Referencias a `assets/...`** (css/js/images): el nuevo prefijo relativo depende de la profundidad del archivo destino:
   - `proyectos/`, `articulos/`, `legal/` (profundidad 1) → `../assets/...`
   - `cursos/docencia/`, `cursos/smart-contracts/`, `cursos/trading-bots/` (profundidad 2) → `../../assets/...`
   - `cursos/docencia/herramientas/`, `cursos/taller-blockchain/` (profundidad 2, mismo nivel) → no referencian `assets/` (no aplica)
3. **`legal/...`** referencias (`cookies.html`, `privacidad.html`, `terminos.html`): mismo criterio de profundidad que assets (`../legal/...` o `../../legal/...`).
4. **`index.html#seccion`** (anclas al portfolio: `#contacto`, `#proyectos`, `#blog`, `#cursos`): reescribir a `../index.html#seccion` (profundidad 1) o `../../index.html#seccion` (profundidad 2).
5. **`styles.css`** roto en cookies/privacidad/terminos → corregir a `../assets/css/styles.css`.
6. Enlaces internos de `1.html`..`12.html`/`c1.html`..`c8.html` hacia `index.html` (que en realidad es `TallerBasico.html`) **no cambian** porque `TallerBasico.html` se convierte en `cursos/taller-blockchain/index.html` (mismo nombre, misma carpeta).

---

### Task 1: Crear estructura de carpetas y script de migración

**Files:**
- Create: `migrate.py` (temporal, se borra al final de Fase 1)

- [ ] **Paso 1: Crear carpetas vacías**

```bash
mkdir -p proyectos articulos legal cursos/taller-blockchain cursos/docencia/herramientas cursos/smart-contracts cursos/trading-bots
```

- [ ] **Paso 2: Crear `migrate.py`** con el siguiente contenido completo:

```python
import re
import subprocess
from pathlib import Path

# old path -> new path
MOVES = {
    "demo-trading-bot.html": "proyectos/demo-trading-bot.html",
    "demo-defi-dashboard.html": "proyectos/demo-defi-dashboard.html",
    "demo-risk-analytics.html": "proyectos/demo-risk-analytics.html",
    "demo-crypto-payment.html": "proyectos/demo-crypto-payment.html",
    "demo-market-sentiment.html": "proyectos/demo-market-sentiment.html",
    "demo-blockchain-explorer.html": "proyectos/demo-blockchain-explorer.html",
    "articulo-defi-layer2.html": "articulos/articulo-defi-layer2.html",
    "articulo-estrategias-algoritmicas.html": "articulos/articulo-estrategias-algoritmicas.html",
    "articulo-ml-trading.html": "articulos/articulo-ml-trading.html",
    "Presentaciondetesis.html": "articulos/presentacion-tesis.html",
    "TallerBasico.html": "cursos/taller-blockchain/index.html",
    "1.html": "cursos/taller-blockchain/01-portal-inicio.html",
    "2.html": "cursos/taller-blockchain/02-problema-confianza.html",
    "3.html": "cursos/taller-blockchain/03-construye-tu-cadena.html",
    "4.html": "cursos/taller-blockchain/04-hashing-magico.html",
    "5.html": "cursos/taller-blockchain/05-bitcoin-mineria.html",
    "6.html": "cursos/taller-blockchain/06-wallet-monedero.html",
    "7.html": "cursos/taller-blockchain/07-contratos-inteligentes.html",
    "8.html": "cursos/taller-blockchain/08-defi-banco-sin-ventanillas.html",
    "9.html": "cursos/taller-blockchain/09-tokenizacion-activos.html",
    "10.html": "cursos/taller-blockchain/10-riesgos-y-seguridad.html",
    "11.html": "cursos/taller-blockchain/11-quiz-repaso.html",
    "12.html": "cursos/taller-blockchain/12-certificado.html",
    "c1.html": "cursos/taller-blockchain/nivel2-01-nfts.html",
    "c2.html": "cursos/taller-blockchain/nivel2-02-daos.html",
    "c3.html": "cursos/taller-blockchain/nivel2-03-interoperabilidad.html",
    "c4.html": "cursos/taller-blockchain/nivel2-04-layer2.html",
    "c5.html": "cursos/taller-blockchain/nivel2-05-crea-tu-token.html",
    "c6.html": "cursos/taller-blockchain/nivel2-06-forense-blockchain.html",
    "c7.html": "cursos/taller-blockchain/nivel2-07-carreras-blockchain.html",
    "c8.html": "cursos/taller-blockchain/nivel2-08-escape-room.html",
    "curso-analisis-cuantitativo.html": "cursos/docencia/index.html",
    "articulocientifico.html": "cursos/docencia/articulos-cientificos-economia.html",
    "normal.html": "cursos/docencia/herramientas/laboratorio-pruebas-hipotesis.html",
    "normalidad.html": "cursos/docencia/herramientas/pruebas-normalidad.html",
    "chicuadrado.html": "cursos/docencia/herramientas/prueba-chi-cuadrado.html",
    "pruebast.html": "cursos/docencia/herramientas/prueba-t.html",
    "pruebasz.html": "cursos/docencia/herramientas/prueba-z.html",
    "regresymu.html": "cursos/docencia/herramientas/regresion-lineal-python.html",
    "Logit.html": "cursos/docencia/herramientas/regresion-logistica-python.html",
    "PythonCorr.html": "cursos/docencia/herramientas/correlaciones-python.html",
    "curso-smart-contracts.html": "cursos/smart-contracts/index.html",
    "curso-trading-bots.html": "cursos/trading-bots/index.html",
    "privacidad.html": "legal/privacidad.html",
    "terminos.html": "legal/terminos.html",
    "cookies.html": "legal/cookies.html",
}

def depth(path: str) -> int:
    return path.count("/")

def rel_prefix(new_path: str) -> str:
    return "../" * depth(new_path)

def git_mv_all():
    for old, new in MOVES.items():
        subprocess.run(["git", "mv", old, new], check=True)

def rewrite_links():
    for old, new in MOVES.items():
        p = Path(new)
        text = p.read_text(encoding="utf-8")
        d = depth(new)
        prefix = rel_prefix(new)

        # 1. Links between moved files: rewrite href="OLDNAME.html" (and #anchors)
        for o, n in MOVES.items():
            if o == old:
                continue
            # only filenames without slashes (the original flat names)
            if "/" in o:
                continue
            pattern = re.compile(r'href="' + re.escape(o) + r'(#[^"]*)?"')
            target = prefix + n
            text = pattern.sub(lambda m, t=target: f'href="{t}{m.group(1) or ""}"', text)

        # 2. assets/ references
        if d > 0:
            text = re.sub(r'(href|src)="assets/', rf'\1="{prefix}assets/', text)

        # 3. legal/ references (cookies.html, privacidad.html, terminos.html -> legal/...)
        for legal_old, legal_new in [("cookies.html", "legal/cookies.html"),
                                      ("privacidad.html", "legal/privacidad.html"),
                                      ("terminos.html", "legal/terminos.html")]:
            if new == legal_new:
                continue
            text = re.sub(rf'href="{re.escape(legal_old)}"', f'href="{prefix}{legal_new}"', text)

        # 4. broken styles.css -> assets/css/styles.css
        text = text.replace('href="styles.css"', f'href="{prefix}assets/css/styles.css"')

        # 5. index.html#section anchors (portfolio root index)
        if d > 0:
            text = re.sub(r'href="index\.html(#[^"]*)"', rf'href="{prefix}index.html\1"', text)

        p.write_text(text, encoding="utf-8")

if __name__ == "__main__":
    git_mv_all()
    rewrite_links()
    print("Migration done.")
```

- [ ] **Paso 3: Commit del script (sin ejecutar aún)**

```bash
git add migrate.py
git commit -m "chore: agregar script temporal de migracion de estructura"
```

---

### Task 2: Ejecutar la migración y verificar

- [ ] **Paso 1: Ejecutar el script**

```bash
python migrate.py
```

- [ ] **Paso 2: Verificar que no quedan referencias a archivos viejos en la raíz**

```bash
grep -rEo 'href="[a-zA-Z0-9_-]+\.html"|src="[a-zA-Z0-9_-]+\.html"' proyectos articulos legal cursos | sort -u
```

Expected: vacío, o solo referencias a nombres que siguen existiendo en la raíz (no debería haber ninguna — todos los HTML excepto `index.html` se mueven).

- [ ] **Paso 3: Verificar enlaces internos del taller (deben seguir apuntando a `index.html` relativo, que ahora es el menú)**

```bash
grep -l 'href="index.html"' cursos/taller-blockchain/*.html | wc -l
```

Expected: 20 (los 12 + 8 archivos que enlazan al menú).

- [ ] **Paso 4: Commit de los archivos movidos**

```bash
git add -A
git commit -m "refactor: reorganizar HTML en proyectos/, articulos/, cursos/, legal/"
```

---

### Task 3: Actualizar `index.html` — enlaces a nuevas rutas

**Files:**
- Modify: `index.html`

- [ ] **Paso 1: Reescribir los `href` a proyectos/articulos/cursos/legal**

Usar un script puntual (no permanente):

```bash
python - <<'EOF'
import re
from pathlib import Path

p = Path("index.html")
text = p.read_text(encoding="utf-8")

replacements = {
    "demo-trading-bot.html": "proyectos/demo-trading-bot.html",
    "demo-defi-dashboard.html": "proyectos/demo-defi-dashboard.html",
    "demo-risk-analytics.html": "proyectos/demo-risk-analytics.html",
    "demo-crypto-payment.html": "proyectos/demo-crypto-payment.html",
    "demo-market-sentiment.html": "proyectos/demo-market-sentiment.html",
    "demo-blockchain-explorer.html": "proyectos/demo-blockchain-explorer.html",
    "articulo-defi-layer2.html": "articulos/articulo-defi-layer2.html",
    "articulo-estrategias-algoritmicas.html": "articulos/articulo-estrategias-algoritmicas.html",
    "articulo-ml-trading.html": "articulos/articulo-ml-trading.html",
    "curso-analisis-cuantitativo.html": "cursos/docencia/index.html",
    "curso-smart-contracts.html": "cursos/smart-contracts/index.html",
    "curso-trading-bots.html": "cursos/trading-bots/index.html",
    "privacidad.html": "legal/privacidad.html",
    "terminos.html": "legal/terminos.html",
    "cookies.html": "legal/cookies.html",
}
for old, new in replacements.items():
    text = text.replace(f'href="{old}"', f'href="{new}"')

p.write_text(text, encoding="utf-8")
print("index.html links updated")
EOF
```

- [ ] **Paso 2: Verificar manualmente** abriendo `index.html` y confirmando que los 15 enlaces apuntan a rutas existentes:

```bash
grep -oE 'href="[^"#][^"]*\.html"' index.html | sort -u
```

Expected: todas las rutas con prefijo `proyectos/`, `articulos/`, `cursos/`, `legal/`.

- [ ] **Paso 3: Commit**

```bash
git add index.html
git commit -m "fix: actualizar enlaces de index.html a la nueva estructura"
```

---

### Task 4: Eliminar el formulario de contacto

**Files:**
- Modify: `index.html`
- Modify: `assets/js/script.js:227-272`

- [ ] **Paso 1: En `index.html`, eliminar el bloque `<div class="contact-form-wrapper">...</div>`**

Buscar el bloque que empieza en `<div class="contact-form-wrapper">` y termina en `</div>` que cierra el `<form class="contact-form" id="contactForm">`. Eliminar todo el bloque (incluye el `<form>` completo con sus `form-group` y botón submit), dejando solo el `<div class="contact-grid">` con `contact-info` (mantiene email, LinkedIn, GitHub, WhatsApp).

- [ ] **Paso 2: En `assets/js/script.js`, eliminar el bloque del manejador del formulario**

Eliminar las líneas 226-272 (sección `FORM VALIDATION & SUBMISSION` completa, desde el comentario hasta el `}` que cierra `if (contactForm) {`). Mantener `showNotification` (se usa también para el cookie banner).

- [ ] **Paso 3: Verificar que `showNotification` sigue siendo usado**

```bash
grep -n "showNotification" assets/js/script.js
```

Expected: al menos una llamada restante (cookie banner) + la definición de la función.

- [ ] **Paso 4: Commit**

```bash
git add index.html assets/js/script.js
git commit -m "feat: eliminar formulario de contacto"
```

---

### Task 5: Crear catálogo `cursos/index.html`

**Files:**
- Create: `cursos/index.html`

- [ ] **Paso 1: Crear página de catálogo** reutilizando el header/footer/tema visual de `cursos/docencia/index.html` (copiar su `<head>` con los mismos `<link>`/fuentes/CSS y la estructura de nav básica), con un cuerpo simple tipo grid de 4 tarjetas enlazando a:
  - `taller-blockchain/index.html` — "Blockchain Adventure: Taller Interactivo"
  - `docencia/index.html` — "Análisis Cuantitativo para Finanzas (Docencia)"
  - `smart-contracts/index.html` — "Desarrollo de Smart Contracts DeFi"
  - `trading-bots/index.html` — "Trading Bots con Python & Machine Learning"

  Incluir un enlace "← Volver al inicio" a `../index.html`.

- [ ] **Paso 2: Verificar enlaces relativos**

```bash
grep -oE 'href="[^"]*"' cursos/index.html
```

Expected: las 4 rutas relativas sin `../` (mismo nivel) más `../index.html`.

- [ ] **Paso 3: Commit**

```bash
git add cursos/index.html
git commit -m "feat: agregar catalogo de cursos"
```

---

### Task 6: Actualizar README.md

**Files:**
- Modify: `README.md`

- [ ] **Paso 1: Reescribir la sección "📂 Estructura del Proyecto"** para reflejar el árbol real (raíz, `proyectos/`, `articulos/`, `cursos/<slug>/`, `legal/`, `assets/`), y agregar una sección breve "Cómo agregar un nuevo curso": crear `cursos/<slug>/index.html` siguiendo el patrón de `cursos/docencia/`.

- [ ] **Paso 2: Eliminar referencias obsoletas** (ruta `ProyectoWeb/`, sección de formulario de contacto si se menciona).

- [ ] **Paso 3: Commit**

```bash
git add README.md
git commit -m "docs: actualizar README con la estructura real del sitio"
```

---

### Task 7: Limpieza final de Fase 1

**Files:**
- Delete: `update-links.ps1`, `migrate.py`

- [ ] **Paso 1: Eliminar scripts obsoletos/temporales**

```bash
git rm update-links.ps1 migrate.py
```

- [ ] **Paso 2: Grep final de enlaces rotos** — cualquier `href`/`src` apuntando a un `.html` en la raíz que ya no existe:

```bash
grep -rEo 'href="[a-zA-Z0-9_.-]+\.html' . --include=*.html | grep -vE '(proyectos|articulos|cursos|legal|\.\./)' 
```

Expected: solo coincidencias dentro de `index.html` (que no tiene prefijo porque está en la raíz) — revisar manualmente que sean correctas (no debería haber ninguna, ya que todos los `.html` de index.html ahora tienen prefijo de carpeta).

- [ ] **Paso 3: Commit**

```bash
git add -A
git commit -m "chore: limpiar scripts obsoletos de fase 1"
```

---

### Task 8 (Fase 2): Tema visual compartido

**Files:**
- Create: `assets/css/theme.css`

- [ ] **Paso 1: Crear `assets/css/theme.css`** con variables CSS extraídas del tema oscuro del portfolio (`assets/css/styles.css` `:root`), reutilizables por las páginas de docencia/taller que tienen sus propios `<style>`:

```css
/* Tema compartido - variables de color/tipografia del portfolio FinTech */
:root {
  --brand-bg: #0a0f1e;
  --brand-bg-alt: #0c1222;
  --brand-surface: #111a2e;
  --brand-primary: #00d4ff;
  --brand-secondary: #7b61ff;
  --brand-text: #e6edf3;
  --brand-text-muted: #8b96a8;
  --brand-font: 'Inter', sans-serif;
}

/* Snippet de navegacion de retorno para paginas de docencia/taller */
.brand-return-nav {
  display: flex;
  gap: 1rem;
  padding: 0.75rem 1.5rem;
  background: var(--brand-surface);
  border-bottom: 1px solid rgba(255,255,255,0.08);
  font-family: var(--brand-font);
}
.brand-return-nav a {
  color: var(--brand-primary);
  text-decoration: none;
  font-size: 0.9rem;
}
.brand-return-nav a:hover {
  text-decoration: underline;
}
```

  (Los valores exactos de `--brand-*` deben tomarse de las variables reales en `assets/css/styles.css:root` — copiarlas, no inventarlas.)

- [ ] **Paso 2: Commit**

```bash
git add assets/css/theme.css
git commit -m "feat: agregar theme.css compartido para paginas de docencia"
```

---

### Task 9 (Fase 2): Nav de retorno en páginas de taller y docencia

**Files:**
- Modify: todos los archivos en `cursos/taller-blockchain/*.html` y `cursos/docencia/**/*.html` (28 archivos)

- [ ] **Paso 1: Script de inyección** — agregar, justo después de `<body...>` en cada archivo, una barra de navegación de retorno y el `<link>` a `theme.css`:

```python
import re
from pathlib import Path

FILES = list(Path("cursos/taller-blockchain").glob("*.html")) + \
        list(Path("cursos/docencia").rglob("*.html"))

for p in FILES:
    text = p.read_text(encoding="utf-8")
    depth = len(p.relative_to(".").parts) - 1  # cursos/docencia/herramientas/x.html -> 3
    prefix = "../" * depth

    theme_link = f'  <link rel="stylesheet" href="{prefix}assets/css/theme.css">\n'
    if "theme.css" not in text:
        text = text.replace("</head>", theme_link + "</head>", 1)

    nav_html = (
        f'\n  <nav class="brand-return-nav">'
        f'<a href="{prefix}index.html">&larr; Portfolio</a>'
        f'<a href="{prefix}cursos/index.html">Cursos</a>'
        f'</nav>\n'
    )
    if "brand-return-nav" not in text:
        text = re.sub(r'(<body[^>]*>)', r'\1' + nav_html, text, count=1)

    p.write_text(text, encoding="utf-8")

print(f"Updated {len(FILES)} files")
```

  Ejecutar con `python - <<'EOF' ... EOF` (igual que en Task 3).

- [ ] **Paso 2: Verificación visual** — abrir 2-3 páginas representativas (`cursos/taller-blockchain/index.html`, `cursos/docencia/herramientas/prueba-t.html`) en navegador y confirmar que la barra de retorno aparece y los links funcionan, y que no rompe el layout existente.

- [ ] **Paso 3: Commit**

```bash
git add cursos/taller-blockchain cursos/docencia
git commit -m "feat: agregar barra de navegacion de retorno y theme compartido en paginas de docencia"
```

---

## Notas finales

- No se toca `assets/css/styles.css` ni el diseño del portfolio principal.
- Las páginas de docencia conservan su diseño propio (MathJax, jStat, gradientes específicos); Fase 2 solo añade una capa superior de navegación + variables de tema disponibles para uso futuro, sin forzar refactor de sus estilos inline existentes.
- Cursos futuros se agregan creando `cursos/<slug>/index.html` (+ recursos) y agregando una tarjeta en `cursos/index.html`.
