# Integración de la Página Principal Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Integrar en `index.html` el contenido huérfano del sitio (taller "Blockchain Adventure",
herramientas de estadística, artículos científicos de economía, presentación de tesis) de forma
coherente, fusionando la sección `#cursos` en "Formación & Recursos" sin romper los enlaces
existentes.

**Architecture:** Edición directa de `index.html` (nav, sección `#cursos`, sección `#blog`, footer)
y de `assets/css/styles.css` (una nueva clase `.subsection-title`). No se crean páginas nuevas. El
`id="cursos"` se conserva.

**Tech Stack:** HTML estático, CSS (variables existentes en `assets/css/styles.css`), verificación
con un script Python de enlaces y Playwright MCP para revisión visual.

**Spec:** `docs/superpowers/specs/2026-06-13-integracion-pagina-principal-design.md`

---

### Task 1: CSS — clase `.subsection-title`

**Files:**
- Modify: `assets/css/styles.css` (cerca de `.section-title`, línea ~688)

- [ ] **Step 1: Añadir la clase `.subsection-title`**

Busca el bloque `.section-title` en `assets/css/styles.css`:

```css
.section-title {
    font-size: clamp(2rem, 5vw, 3rem);
    font-weight: 800;
    margin-bottom: var(--spacing-md);
    letter-spacing: -0.02em;
}
```

Inserta inmediatamente después (antes de la siguiente regla en blanco):

```css
.section-title {
    font-size: clamp(2rem, 5vw, 3rem);
    font-weight: 800;
    margin-bottom: var(--spacing-md);
    letter-spacing: -0.02em;
}

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

- [ ] **Step 2: Verificar visualmente que la regla no rompe el CSS**

Run: `python -m http.server 8123` desde la raíz del repo, abrir `http://localhost:8123/index.html`
con Playwright (`browser_navigate`) y confirmar que la página carga sin errores de consola
(`browser_console_messages`). Aún no habrá `.subsection-title` en el HTML — esto solo confirma que
el CSS es válido.

- [ ] **Step 3: Commit**

```bash
git add assets/css/styles.css
git commit -m "feat: agregar clase subsection-title para subsecciones de Formacion y Recursos"
```

---

### Task 2: Navegación (header y footer) — renombrar "Cursos" a "Formación" y arreglar columna "Recursos"

**Files:**
- Modify: `index.html` (nav header ~línea 76, footer columna Navegación ~línea 760, footer columna
  Recursos ~líneas 765-770)

- [ ] **Step 1: Renombrar el item del nav principal**

Busca en `index.html`:

```html
                <li><a href="#cursos" class="nav-link">Cursos</a></li>
```

Reemplaza por:

```html
                <li><a href="#cursos" class="nav-link">Formación</a></li>
```

- [ ] **Step 2: Renombrar el item en la columna "Navegación" del footer**

Busca:

```html
                            <li><a href="#sobre-mi">Sobre Mí</a></li>
                            <li><a href="#proyectos">Proyectos</a></li>
                            <li><a href="#cursos">Cursos</a></li>
                        </ul>
                    </div>
```

Reemplaza por:

```html
                            <li><a href="#sobre-mi">Sobre Mí</a></li>
                            <li><a href="#proyectos">Proyectos</a></li>
                            <li><a href="#cursos">Formación</a></li>
                        </ul>
                    </div>
```

- [ ] **Step 3: Reemplazar los enlaces placeholder de la columna "Recursos" del footer**

Busca:

```html
                    <div class="footer-column">
                        <h4>Recursos</h4>
                        <ul>
                            <li><a href="#blog">Blog</a></li>
                            <li><a href="#">Documentación</a></li>
                            <li><a href="#">API</a></li>
                            <li><a href="#">Newsletter</a></li>
                        </ul>
                    </div>
```

Reemplaza por:

```html
                    <div class="footer-column">
                        <h4>Recursos</h4>
                        <ul>
                            <li><a href="#blog">Blog</a></li>
                            <li><a href="cursos/index.html">Catálogo de Cursos</a></li>
                            <li><a href="cursos/docencia/index.html">Herramientas de Estadística</a></li>
                            <li><a href="cursos/docencia/articulos-cientificos-economia.html">Artículos Científicos</a></li>
                        </ul>
                    </div>
```

- [ ] **Step 4: Commit**

```bash
git add index.html
git commit -m "feat: renombrar Cursos a Formacion en nav y enlazar recursos reales en footer"
```

---

### Task 3: Sección `#cursos` → "Formación & Recursos" (encabezado + tarjeta Blockchain Adventure)

**Files:**
- Modify: `index.html` (sección `id="cursos"`, encabezado y `.courses-grid`)

- [ ] **Step 1: Actualizar el encabezado de la sección**

Busca:

```html
    <section class="section" id="cursos">
        <div class="container">
            <div class="section-header">
                <span class="section-tag">// Formación</span>
                <h2 class="section-title">Cursos & Programas</h2>
                <p class="section-description">
                    Programas especializados en tecnologías financieras y blockchain<br>
                    <a href="cursos/index.html" class="course-link">Ver catálogo completo de cursos y materiales de docencia &rarr;</a>
                </p>
            </div>

            <div class="courses-grid">
```

Reemplaza por:

```html
    <section class="section" id="cursos">
        <div class="container">
            <div class="section-header">
                <span class="section-tag">// Formación & Recursos</span>
                <h2 class="section-title">Formación & Recursos</h2>
                <p class="section-description">
                    Programas especializados en tecnologías financieras y blockchain, además de
                    recursos académicos abiertos<br>
                    <a href="cursos/index.html" class="course-link">Ver catálogo completo de cursos y materiales de docencia &rarr;</a>
                </p>
            </div>

            <h3 class="subsection-title">Cursos & Programas</h3>
            <div class="courses-grid">
```

- [ ] **Step 2: Insertar la tarjeta "Blockchain Adventure" como primera tarjeta del grid**

Busca el inicio de la primera `.course-card` ("Trading Bots con Python & Machine Learning"):

```html
            <h3 class="subsection-title">Cursos & Programas</h3>
            <div class="courses-grid">
                <div class="course-card">
                    <div class="course-header">
                        <span class="course-category">TRADING ALGORÍTMICO</span>
                        <span class="course-duration">12 SEMANAS</span>
                    </div>
```

Reemplaza por (inserta la nueva tarjeta antes de la de Trading Bots):

```html
            <h3 class="subsection-title">Cursos & Programas</h3>
            <div class="courses-grid">
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

                <div class="course-card">
                    <div class="course-header">
                        <span class="course-category">TRADING ALGORÍTMICO</span>
                        <span class="course-duration">12 SEMANAS</span>
                    </div>
```

- [ ] **Step 3: Commit**

```bash
git add index.html
git commit -m "feat: renombrar seccion cursos a Formacion y Recursos y agregar tarjeta Blockchain Adventure"
```

---

### Task 4: Sección "Recursos Académicos" (nuevo bloque dentro de `#cursos`)

**Files:**
- Modify: `index.html` (cierre del `.courses-grid` de la sección `#cursos`)

- [ ] **Step 1: Insertar el bloque "Recursos Académicos" después del `.courses-grid` de cursos**

Busca el cierre de la sección `#cursos` (la tarjeta "Análisis Cuantitativo para Finanzas" es la
última del grid, seguida del cierre de `.courses-grid`, `.container` y `</section>`):

```html
                    <a href="cursos/docencia/index.html" class="course-link">Ver curso →</a>
                </div>
            </div>
        </div>
    </section>

    <!-- Blog Section -->
```

Reemplaza por:

```html
                    <a href="cursos/docencia/index.html" class="course-link">Ver curso →</a>
                </div>
            </div>

            <h3 class="subsection-title">Recursos Académicos</h3>
            <div class="courses-grid">
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
            </div>
        </div>
    </section>

    <!-- Blog Section -->
```

> ⚠️ Nota: hay dos cierres `</div></div></section>` muy similares en la sección `#cursos` (uno por
> cada `.course-card` y otro por la sección). Usa el contexto completo del bloque de búsqueda
> (incluye `<a href="cursos/docencia/index.html" class="course-link">Ver curso →</a>` que es único
> — solo aparece en la tarjeta de "Análisis Cuantitativo para Finanzas") para asegurar una
> coincidencia única.

- [ ] **Step 2: Commit**

```bash
git add index.html
git commit -m "feat: agregar bloque Recursos Academicos con herramientas y articulos cientificos"
```

---

### Task 5: Sección `#blog` — tarjeta "Presentación de Tesis"

**Files:**
- Modify: `index.html` (`.blog-grid` dentro de `id="blog"`)

- [ ] **Step 1: Insertar la 4ª tarjeta de blog**

Busca el final del `.blog-grid` (después de la tarjeta "Machine Learning en Trading Cuantitativo"):

```html
                <article class="blog-card">
                    <div class="blog-meta">
                        <span class="blog-category">AI & ML</span>
                        <span class="blog-date">15.NOV.2024</span>
                    </div>
                    <h3 class="blog-title">Machine Learning en Trading Cuantitativo</h3>
                    <p class="blog-excerpt">
                        Implementación de redes neuronales LSTM para predicción de series temporales en
                        mercados financieros. Resultados y optimización de hiperparámetros...
                    </p>
                    <a href="articulos/articulo-ml-trading.html" class="blog-link">Leer más →</a>
                </article>
            </div>
        </div>
    </section>

    <!-- Contact Section -->
```

Reemplaza por:

```html
                <article class="blog-card">
                    <div class="blog-meta">
                        <span class="blog-category">AI & ML</span>
                        <span class="blog-date">15.NOV.2024</span>
                    </div>
                    <h3 class="blog-title">Machine Learning en Trading Cuantitativo</h3>
                    <p class="blog-excerpt">
                        Implementación de redes neuronales LSTM para predicción de series temporales en
                        mercados financieros. Resultados y optimización de hiperparámetros...
                    </p>
                    <a href="articulos/articulo-ml-trading.html" class="blog-link">Leer más →</a>
                </article>

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
            </div>
        </div>
    </section>

    <!-- Contact Section -->
```

- [ ] **Step 2: Commit**

```bash
git add index.html
git commit -m "feat: agregar tarjeta de blog para presentacion de tesis"
```

---

### Task 6: Verificación final (enlaces + visual)

**Files:** ninguno (solo verificación)

- [ ] **Step 1: Verificar que no hay enlaces internos rotos**

Crea un script temporal `check_links.py` en la raíz del repo:

```python
import re
from pathlib import Path
from urllib.parse import urlparse

root = Path(".")
broken = []

for html_file in root.rglob("*.html"):
    if ".git" in html_file.parts:
        continue
    text = html_file.read_text(encoding="utf-8")
    for m in re.finditer(r'(?:href|src)="([^"]+)"', text):
        link = m.group(1)
        if link.startswith(("http://", "https://", "#", "mailto:", "javascript:", "tel:")):
            continue
        parsed = urlparse(link)
        path_part = parsed.path
        if not path_part:
            continue
        target = (html_file.parent / path_part).resolve()
        if not target.exists():
            broken.append((str(html_file), link))

if broken:
    for f, l in broken:
        print(f"BROKEN: {f} -> {l}")
    print(f"\nTotal broken: {len(broken)}")
else:
    print("OK: no broken internal links")
```

Run: `python check_links.py`
Expected: `OK: no broken internal links`

- [ ] **Step 2: Eliminar el script temporal**

```bash
rm check_links.py
```

- [ ] **Step 3: Revisión visual con Playwright**

1. Levantar servidor local: `python -m http.server 8123` desde la raíz del repo.
2. `browser_navigate` a `http://localhost:8123/index.html`.
3. `browser_evaluate` o `browser_press_key` para hacer scroll hasta la sección `#cursos`
   ("Formación & Recursos") y tomar `browser_take_screenshot`. Verificar:
   - El título de la sección dice "Formación & Recursos".
   - El subtítulo "Cursos & Programas" aparece sobre las 4 tarjetas (Blockchain Adventure +
     Trading Bots + Smart Contracts + Análisis Cuantitativo).
   - El subtítulo "Recursos Académicos" aparece sobre las 2 nuevas tarjetas (Herramientas de
     Estadística + Filmoteca del Conocimiento).
4. Scroll hasta `#blog` y tomar screenshot. Verificar que aparecen 4 tarjetas, la última siendo
   "La Mejor Presentación de Tesis".
5. Verificar el nav superior muestra "Formación" en vez de "Cursos", y que al hacer click
   (`browser_click`) navega/scrollea a la sección `#cursos`.
6. `browser_console_messages` — confirmar que no hay errores nuevos.
7. Navegar a `http://localhost:8123/cursos/docencia/index.html` y hacer click en
   "← Volver a Cursos" (`../../index.html#cursos`) — confirmar que el navegador llega a la
   sección "Formación & Recursos" de `index.html`.
8. Borrar cualquier screenshot temporal y la carpeta `.playwright-mcp/` generada, igual que en
   verificaciones anteriores.

- [ ] **Step 4: Commit final si hubo ajustes**

Si la revisión visual no requirió cambios, no hay nada que commitear en este paso. Si se detectó
algún ajuste menor (p. ej. espaciado), aplicarlo y:

```bash
git add index.html assets/css/styles.css
git commit -m "fix: ajustes visuales tras verificacion de Formacion y Recursos"
```

---

## Self-Review

**Cobertura del spec:**
- Nav header/footer "Cursos" → "Formación": Task 2.
- Footer columna "Recursos" con enlaces reales: Task 2.
- Sección `#cursos` → "Formación & Recursos" con subtítulos: Tasks 3-4.
- Tarjeta "Blockchain Adventure": Task 3.
- Bloque "Recursos Académicos" (herramientas + filmoteca): Task 4.
- Tarjeta de blog "Presentación de Tesis": Task 5.
- CSS `.subsection-title`: Task 1.
- Verificación de enlaces + visual + compatibilidad con `id="cursos"`: Task 6.

Todo lo especificado en el spec está cubierto. No quedan placeholders ni referencias a
funciones/clases no definidas.
