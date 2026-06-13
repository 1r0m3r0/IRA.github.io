# 🚀 FinTech Developer Portfolio & Docencia UMSA

Portfolio profesional de Israel Romero - Especialista en desarrollo FinTech, trading algorítmico y blockchain, además de materiales de docencia para la UMSA.

## ✨ Características

- 🎨 Diseño moderno con gradientes dinámicos y animaciones fluidas
- 📱 Completamente responsivo y mobile-friendly
- ⚡ Optimizado para performance
- 💹 Ticker de precios en vivo (CoinGecko API)
- 🎯 Efectos de cursor personalizados con tema blockchain
- 🔒 SEO optimizado
- 🎓 Catálogo de cursos y materiales de docencia interactivos

## 🛠️ Tecnologías

- **Frontend**: HTML5, CSS3, JavaScript (Vanilla)
- **Fonts**: Google Fonts (Inter, JetBrains Mono)
- **APIs**: CoinGecko API para precios de criptomonedas
- **Deployment**: GitHub Pages (dominio personalizado `israelromero.xyz`)

## 📂 Estructura del Proyecto

```
.
├── index.html              # Portfolio: inicio, sobre mí, proyectos, cursos, blog, contacto
├── assets/
│   ├── css/styles.css       # Estilos compartidos del portfolio
│   ├── js/script.js         # Scripts compartidos (nav, ticker, cookies, notificaciones)
│   └── images/               # Imágenes del portfolio
├── proyectos/                # Demos de proyectos FinTech
│   ├── demo-trading-bot.html
│   ├── demo-defi-dashboard.html
│   ├── demo-risk-analytics.html
│   ├── demo-crypto-payment.html
│   ├── demo-market-sentiment.html
│   └── demo-blockchain-explorer.html
├── articulos/                # Artículos de blog y artículos/tesis
│   ├── articulo-defi-layer2.html
│   ├── articulo-estrategias-algoritmicas.html
│   ├── articulo-ml-trading.html
│   └── presentacion-tesis.html
├── cursos/                   # Catálogo de cursos y materiales de docencia
│   ├── index.html            # Catálogo de cursos
│   ├── taller-blockchain/     # Taller interactivo "Blockchain Adventure" (12 + 8 niveles)
│   ├── docencia/               # Curso de Análisis Cuantitativo para Finanzas
│   │   ├── index.html
│   │   ├── articulos-cientificos-economia.html
│   │   └── herramientas/        # Calculadoras/laboratorios interactivos de estadística
│   ├── smart-contracts/        # Curso de Desarrollo de Smart Contracts DeFi
│   └── trading-bots/           # Curso de Trading Bots con Python & ML
└── legal/                    # Privacidad, términos y cookies
```

## 🚀 Instalación Local

1. Clonar el repositorio:
```bash
git clone https://github.com/1r0m3r0/IRA.github.io.git
cd IRA.github.io
```

2. Abrir `index.html` en tu navegador o usar un servidor local:
```bash
# Con Python 3
python -m http.server 8000

# Con Node.js
npx serve
```

3. Visitar `http://localhost:8000`

## 🎓 Cómo agregar un nuevo curso

Cada curso vive en su propia carpeta dentro de `cursos/`, siguiendo el patrón de `cursos/docencia/`:

1. Crear `cursos/<slug-del-curso>/index.html` (página principal del curso)
2. Agregar recursos del curso (lecciones, herramientas, etc.) como archivos o subcarpetas dentro de `cursos/<slug-del-curso>/`
3. Agregar una tarjeta nueva en `cursos/index.html` enlazando a `cursos/<slug-del-curso>/index.html`
4. Si el curso debe aparecer en la sección "Cursos & Programas" del portfolio, agregar una tarjeta en `index.html` (sección `#cursos`)

Las páginas dentro de `cursos/<slug>/` están a 2 niveles de la raíz, por lo que las referencias a `assets/` deben usar el prefijo `../../assets/...`.

## ✨ Características Principales

### Ticker de Precios en Vivo
- Integración con CoinGecko API
- Actualización automática cada 60 segundos
- Muestra BTC, ETH, BNB, SOL, ADA, DOT

### Efectos Visuales
- Cursor personalizado con tema hexagonal (blockchain)
- Partículas digitales animadas
- Gradientes orbitales flotantes
- Grid tecnológico de fondo

### Secciones del Portfolio
- **Inicio**: Hero section con typewriter effect
- **Sobre Mí**: Experiencia y habilidades
- **Proyectos**: Portfolio de proyectos FinTech (`proyectos/`)
- **Cursos**: Programas de formación y catálogo de docencia (`cursos/`)
- **Blog**: Artículos técnicos (`articulos/`)
- **Contacto**: Información de contacto y redes sociales

## 📊 Performance

- Lighthouse Score: 95+
- Mobile-Friendly
- Fast First Contentful Paint
- Optimized Assets

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add AmazingFeature'`)
4. Push a la branch (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📝 Licencia

© 2024 Israel Romero Apo. Todos los derechos reservados.

## 📧 Contacto

- **Email**: israelromeroapo@gmail.com
- **LinkedIn**: [israelromeroapo](https://www.linkedin.com/in/israelromeroapo/)
- **GitHub**: [@1r0m3r0](https://github.com/1r0m3r0)

---

⭐ Si te gusta este proyecto, no olvides darle una estrella!
