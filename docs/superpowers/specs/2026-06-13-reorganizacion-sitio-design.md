# Reorganización del sitio IRA.github.io (Fase 1: estructura, enlaces y limpieza)

## Contexto

El repositorio `IRA.github.io` combina dos propósitos:
1. **Portfolio profesional FinTech** de Israel Romero (index.html, demos de proyectos, cursos, artículos de blog)
2. **Materiales de docencia UMSA**: taller "Blockchain Adventure" (1-12.html, c1-c8.html, TallerBasico.html) y herramientas de estadística/econometría (normal.html, normalidad.html, chicuadrado.html, pruebast.html, pruebasz.html, regresymu.html, Logit.html, PythonCorr.html, articulocientifico.html)

Hoy los 47 archivos HTML están sueltos en la raíz del repo, con nombres poco descriptivos (1.html, c3.html, normal.html, Logit.html) y el README describe una estructura de carpetas (`pages/`, `assets/images/profile/`, etc.) que no coincide con la realidad. Los materiales de docencia no están enlazados desde el index del portfolio.

El sitio se publica vía GitHub Pages con dominio personalizado `israelromero.xyz` (archivo CNAME), desplegado automáticamente desde `main` (`.github/workflows/static.yml`).

## Objetivo de esta fase

Reorganizar archivos en una estructura de carpetas clara y escalable, con nombres de archivo descriptivos, corrigiendo todos los enlaces internos, eliminando el formulario de contacto y actualizando el README — sin tocar el diseño visual (eso es Fase 2, spec separado).

La estructura de `cursos/` debe quedar lista para que en el futuro se agreguen cursos completos nuevos siguiendo el mismo patrón `cursos/<slug>/index.html` + recursos.

## Estructura de carpetas final

```
/
├── index.html                  (portfolio, sin formulario de contacto)
├── README.md                   (actualizado a la estructura real)
├── CNAME, .gitignore, .github/
├── assets/
│   ├── css/styles.css
│   ├── js/script.js
│   └── images/
├── proyectos/
│   ├── demo-trading-bot.html
│   ├── demo-defi-dashboard.html
│   ├── demo-risk-analytics.html
│   ├── demo-crypto-payment.html
│   ├── demo-market-sentiment.html
│   └── demo-blockchain-explorer.html
├── articulos/
│   ├── articulo-defi-layer2.html
│   ├── articulo-estrategias-algoritmicas.html
│   ├── articulo-ml-trading.html
│   └── presentacion-tesis.html              (← Presentaciondetesis.html)
├── cursos/
│   ├── index.html                           (nuevo: catálogo de cursos)
│   ├── taller-blockchain/
│   │   ├── index.html                       (← TallerBasico.html, menú del taller)
│   │   ├── 01-portal-inicio.html            (← 1.html)
│   │   ├── 02-problema-confianza.html       (← 2.html)
│   │   ├── 03-construye-tu-cadena.html      (← 3.html)
│   │   ├── 04-hashing-magico.html           (← 4.html)
│   │   ├── 05-bitcoin-mineria.html          (← 5.html)
│   │   ├── 06-wallet-monedero.html          (← 6.html)
│   │   ├── 07-contratos-inteligentes.html   (← 7.html)
│   │   ├── 08-defi-banco-sin-ventanillas.html (← 8.html)
│   │   ├── 09-tokenizacion-activos.html     (← 9.html)
│   │   ├── 10-riesgos-y-seguridad.html      (← 10.html)
│   │   ├── 11-quiz-repaso.html              (← 11.html)
│   │   ├── 12-certificado.html              (← 12.html)
│   │   ├── nivel2-01-nfts.html              (← c1.html)
│   │   ├── nivel2-02-daos.html              (← c2.html)
│   │   ├── nivel2-03-interoperabilidad.html (← c3.html)
│   │   ├── nivel2-04-layer2.html            (← c4.html)
│   │   ├── nivel2-05-crea-tu-token.html     (← c5.html)
│   │   ├── nivel2-06-forense-blockchain.html (← c6.html)
│   │   ├── nivel2-07-carreras-blockchain.html (← c7.html)
│   │   └── nivel2-08-escape-room.html       (← c8.html)
│   ├── docencia/
│   │   ├── index.html                       (← curso-analisis-cuantitativo.html)
│   │   ├── articulos-cientificos-economia.html (← articulocientifico.html)
│   │   └── herramientas/
│   │       ├── laboratorio-pruebas-hipotesis.html  (← normal.html)
│   │       ├── pruebas-normalidad.html             (← normalidad.html)
│   │       ├── prueba-chi-cuadrado.html            (← chicuadrado.html)
│   │       ├── prueba-t.html                       (← pruebast.html)
│   │       ├── prueba-z.html                       (← pruebasz.html)
│   │       ├── regresion-lineal-python.html        (← regresymu.html)
│   │       ├── regresion-logistica-python.html     (← Logit.html)
│   │       └── correlaciones-python.html           (← PythonCorr.html)
│   ├── smart-contracts/
│   │   └── index.html                       (← curso-smart-contracts.html)
│   └── trading-bots/
│       └── index.html                       (← curso-trading-bots.html)
└── legal/
    ├── privacidad.html
    ├── terminos.html
    └── cookies.html
```

`docencia/` queda como el primer curso dentro de `cursos/`; cursos futuros se agregan como nuevas carpetas hermanas (`cursos/<slug>/index.html` + recursos propios), siguiendo el mismo patrón.

## Cambios de contenido

- **index.html**:
  - Eliminar el formulario de contacto (`<form class="contact-form" id="contactForm">` y su JS asociado en `assets/js/script.js`)
  - Mantener la información de contacto/redes sociales de la sección `#contacto` (sin el form)
  - Quitar el link "Contactar" del nav/hero si apuntaba al form, o dejarlo apuntando a la sección de info de contacto
  - Actualizar todos los `href` a proyectos/articulos/cursos a las nuevas rutas
- **cursos/index.html** (nuevo): catálogo simple que enlaza a los 4 cursos (`taller-blockchain`, `docencia`, `smart-contracts`, `trading-bots`)
- **README.md**: reescribir reflejando la estructura real anterior, con instrucciones para agregar nuevos cursos en `cursos/<slug>/`
- Eliminar `update-links.ps1` (script obsoleto, ruta local hardcodeada `c:\Users\IRA\Desktop\ProyectoWeb`)

## Estrategia de migración de enlaces

Mover y renombrar 47 archivos rompe referencias relativas (`href`, `src`, `url()` en CSS inline) tanto entre páginas como hacia `assets/`. Pasos:

1. **Mapeo previo**: un sub-agente (Explore) recorre los 47 archivos y construye un inventario de:
   - Todas las referencias a `assets/...` (rutas a CSS/JS/imágenes)
   - Todos los enlaces entre páginas HTML (incluye los enlaces de navegación del taller `1.html` → `2.html`, `TallerBasico.html` → `c1.html`, etc.)
   - Referencias desde `index.html` hacia proyectos/articulos/cursos
2. **Migración por lotes** (commits separados por categoría): `proyectos/`, `articulos/`, `cursos/taller-blockchain/`, `cursos/docencia/`, `cursos/smart-contracts/` + `trading-bots/`, `legal/`
3. **Reescritura de rutas relativas** según la nueva profundidad de cada archivo (ej. raíz → `cursos/taller-blockchain/` es 2 niveles, por lo que `assets/css/styles.css` se convierte en `../../assets/css/styles.css`)
4. **Verificación final**: grep de enlaces rotos (referencias a archivos `.html` que ya no existen en la raíz) + revisión manual de páginas clave (index, taller-blockchain/index, docencia/index, cursos/index)

## Riesgos / consideraciones

- **URLs públicas cambian**: páginas que antes eran `israelromero.xyz/normal.html` pasarán a `israelromero.xyz/cursos/docencia/herramientas/laboratorio-pruebas-hipotesis.html`. Si estos links están compartidos con estudiantes (ej. en aulas virtuales, grupos), deberán actualizarse ahí. GitHub Pages no genera redirects automáticos — fuera de alcance de esta fase crear redirects.
- No se modifica el diseño visual ni el CSS/JS compartido más allá de ajustar rutas — eso es Fase 2.
- `cursos/docencia/` se trata como el primer curso de la nueva carpeta `cursos/`; queda preparado para que el usuario agregue más cursos después de esta fase.

## Fuera de alcance (Fase 2, spec futuro)

Unificación visual: extraer paleta/tema compartido a `assets/css`, dar coherencia entre el portfolio y los materiales de docencia, agregar nav/footer consistente.
