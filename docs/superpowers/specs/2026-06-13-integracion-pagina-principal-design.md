# Diseño: Integración y mejora de la página principal (index.html)

## Contexto

Tras la reorganización de archivos (Fase 1) y la unificación visual mínima (Fase 2), `index.html`
sigue mostrando solo 3 de los cursos del catálogo y no enlaza dos piezas de contenido ya
existentes en el repo:

- `cursos/taller-blockchain/index.html` (taller "Blockchain Adventure", 12+8 niveles) — solo
  alcanzable desde `cursos/index.html`.
- `articulos/presentacion-tesis.html` (guía de presentación de tesis) — no enlazado desde
  ninguna parte de `index.html`.
- `cursos/docencia/herramientas/*.html` (8 calculadoras/laboratorios de estadística) y
  `cursos/docencia/articulos-cientificos-economia.html` ("La Filmoteca del Conocimiento") —
  solo alcanzables navegando dentro de `cursos/docencia/index.html`.

Además, la columna "Recursos" del footer tiene 3 enlaces placeholder (`#`) sin destino real
("Documentación", "API", "Newsletter").

Objetivo: integrar todo este contenido en `index.html` de forma coherente, sin romper los
enlaces existentes hacia `index.html#cursos` desde `cursos/docencia|smart-contracts|trading-bots/index.html`,
manteniendo el tema visual oscuro FinTech/blockchain actual (solo refinamientos menores).

## Alcance

Cambios en:
- `index.html` — nav, sección `#cursos` (renombrada visualmente a "Formación & Recursos"),
  sección `#blog`, columna "Recursos" del footer.
- `assets/css/styles.css` — nueva clase `.subsection-title` para los subtítulos dentro de
  "Formación & Recursos".

No se modifican otras páginas. El `id="cursos"` se conserva (no se renombra el anchor) para no
romper los 3 enlaces `../../index.html#cursos` ya existentes.

## 1. Navegación (header y footer)

- En `<ul class="nav-menu">` (línea ~76), el item `<a href="#cursos" class="nav-link">Cursos</a>`
  cambia su texto a **"Formación"** (mismo `href="#cursos"`).
- En el footer, columna "Navegación" (línea ~760), el item `<a href="#cursos">Cursos</a>` cambia
  su texto a **"Formación"**.
- Columna "Recursos" del footer (líneas ~765-771): se reemplazan los 3 enlaces placeholder
  (`#` Documentación / API / Newsletter) por enlaces reales al nuevo contenido integrado:
  - `<a href="cursos/index.html">Catálogo de Cursos</a>`
  - `<a href="cursos/docencia/index.html">Herramientas de Estadística</a>`
  - `<a href="cursos/docencia/articulos-cientificos-economia.html">Artículos Científicos</a>`
  - Se conserva `<a href="#blog">Blog</a>` como primer ítem de esa columna.

## 2. Sección `#cursos` → "Formación & Recursos"

La sección mantiene `id="cursos"` pero se reestructura en dos bloques con subtítulos
(`.subsection-title`, nueva clase).

**Encabezado de sección** (sin cambios de fondo, solo texto):
- `section-tag`: `// Formación & Recursos`
- `section-title`: `Formación & Recursos`
- `section-description`: se mantiene el texto actual + el link
  `Ver catálogo completo de cursos y materiales de docencia →` (`cursos/index.html`)

**Bloque A — "Cursos & Programas"** (`<h3 class="subsection-title">Cursos & Programas</h3>`)

`.courses-grid` con 4 `.course-card` (orden: Blockchain Adventure primero, como entrada gratuita/
de bienvenida, seguida de los 3 cursos existentes sin cambios):

```html
<div class="course-card">
    <div class="course-header">
        <span class="course-category">TALLER INTERACTIVO</span>
        <span class="course-duration">12 + 8 NIVELES</span>
    </div>
    <h3 class="course-title">Blockchain Adventure</h3>
    <p class="course-description">
        Taller gamificado de blockchain: de la confianza y el hashing al DeFi, NFTs, DAOs y
        un escape room cripto final
    </p>
    <div class="course-features">
        <div class="feature">
            <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                <path d="M10 2L13 8L19 9L14.5 13.5L15.5 19L10 16L4.5 19L5.5 13.5L1 9L7 8L10 2Z"
                    stroke="currentColor" stroke-width="2" stroke-linejoin="round" />
            </svg>
            <span>Aprendizaje gamificado</span>
        </div>
        <div class="feature">
            <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                <path d="M10 2L13 8L19 9L14.5 13.5L15.5 19L10 16L4.5 19L5.5 13.5L1 9L7 8L10 2Z"
                    stroke="currentColor" stroke-width="2" stroke-linejoin="round" />
            </svg>
            <span>20 niveles interactivos</span>
        </div>
    </div>
    <a href="cursos/taller-blockchain/index.html" class="course-link">Ver taller →</a>
</div>
```

(Las 3 tarjetas existentes — Trading Bots, Smart Contracts, Análisis Cuantitativo — se mueven
sin cambios dentro de este mismo `.courses-grid`, después de la nueva.)

**Bloque B — "Recursos Académicos"** (`<h3 class="subsection-title">Recursos Académicos</h3>`)

Nuevo `.courses-grid` (mismo componente reutilizado) con 2 `.course-card` sin `.course-features`
(las features son opcionales en el componente):

```html
<div class="course-card">
    <div class="course-header">
        <span class="course-category">LABORATORIOS</span>
        <span class="course-duration">8 HERRAMIENTAS</span>
    </div>
    <h3 class="course-title">Herramientas Interactivas de Estadística</h3>
    <p class="course-description">
        Calculadoras y laboratorios interactivos: pruebas de hipótesis, regresión lineal y
        logística, correlaciones, chi-cuadrado y más
    </p>
    <a href="cursos/docencia/index.html" class="course-link">Explorar herramientas →</a>
</div>

<div class="course-card">
    <div class="course-header">
        <span class="course-category">LECTURA GUIADA</span>
        <span class="course-duration">ECONOMÍA</span>
    </div>
    <h3 class="course-title">La Filmoteca del Conocimiento</h3>
    <p class="course-description">
        Guía divertida para distinguir los "géneros cinematográficos" de los artículos
        científicos, con enlaces a investigaciones reales en ciencias económicas
    </p>
    <a href="cursos/docencia/articulos-cientificos-economia.html" class="course-link">Ver guía →</a>
</div>
```

## 3. Sección `#blog`

Se agrega una 4ª `.blog-card` al `.blog-grid` existente (después de "Machine Learning en Trading
Cuantitativo"):

```html
<article class="blog-card">
    <div class="blog-meta">
        <span class="blog-category">ACADEMIA</span>
        <span class="blog-date">GUÍA</span>
    </div>
    <h3 class="blog-title">La Mejor Presentación de Tesis</h3>
    <p class="blog-excerpt">
        Guía experta para preparar y defender una presentación de tesis: estructura, diseño de
        slides, manejo del tiempo y respuestas al jurado...
    </p>
    <a href="articulos/presentacion-tesis.html" class="blog-link">Leer más →</a>
</article>
```

## 4. CSS — `assets/css/styles.css`

Nueva clase `.subsection-title`, agregada cerca de `.section-title` (línea ~688):

```css
.subsection-title {
    font-family: var(--font-mono);
    font-size: 1.25rem;
    font-weight: 700;
    color: var(--color-accent-cyan);
    text-transform: uppercase;
    letter-spacing: 0.05em;
    margin: var(--spacing-2xl) 0 var(--spacing-lg);
}

.subsection-title:first-of-type {
    margin-top: 0;
}
```

`.course-card` ya soporta tarjetas sin `.course-features` (es un `<div>` opcional dentro de la
tarjeta), por lo que las tarjetas de "Recursos Académicos" no requieren CSS adicional.

## 5. Verificación

- Revisión visual con Playwright en `index.html` (servidor local `python -m http.server`):
  comprobar que la sección "Formación & Recursos" renderiza correctamente con sus 2 bloques
  (6 tarjetas en total) y que el nav/footer muestran "Formación".
- Verificar que los 3 enlaces `../../index.html#cursos` desde `cursos/docencia|smart-contracts|trading-bots/index.html`
  siguen llevando a la sección correcta (el `id="cursos"` no cambia).
- Script de verificación de enlaces (igual al usado en Fase 1/2): 0 enlaces internos rotos tras
  los cambios.
- Confirmar que la nueva tarjeta de blog y las 2 tarjetas de "Recursos Académicos" enlazan a
  archivos existentes (`articulos/presentacion-tesis.html`, `cursos/docencia/index.html`,
  `cursos/docencia/articulos-cientificos-economia.html`).

## Fuera de alcance

- Cambios a las páginas internas de `cursos/taller-blockchain/`, `cursos/docencia/`, etc.
  (ya tienen `.brand-return-nav` + `theme.css` de la Fase 2).
- Rediseño visual mayor (paleta, tipografía, layout del hero) — se mantiene el tema actual.
- Enlaces placeholder de redes sociales ("Twitter", "Telegram" con `href="#"`) — no relacionados
  con el contenido de docencia, fuera del alcance de esta integración.
