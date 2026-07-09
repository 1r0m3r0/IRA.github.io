#!/usr/bin/env python3
"""
Enhance ALL 79 trading course module files with 5 new self-learning sections.
Adds: ¿Qué aprenderás?, info panels, paso a paso, quiz with explanations, resumen.
Preserves ALL existing functionality, localStorage, insignias, quizzes, etc.
"""

import os, re, json

BASE = r"D:\poryectosPulidos\PAGINA\cursos\trading-algoritmico-python"

def hex_to_rgb(h):
    h = h.lstrip('#')
    return f"{int(h[0:2],16)},{int(h[2:4],16)},{int(h[4:6],16)}"

# Course definitions: (folder, default_color, course_name, course_desc_short)
COURSES = {
    "curso-1-python-financiero":   {"color": "#ffb347", "name": "Python Financiero", "short": "Python financiero", "container": "curso1-container", "logo": "🐍"},
    "curso-2-mercados-analisis":   {"color": "#ffb347", "name": "Mercados y Análisis", "short": "análisis de mercados", "container": "curso2-container", "logo": "📊"},
    "curso-3-estrategias-backtesting": {"color": "#2b9eff", "name": "Estrategias y Backtesting", "short": "estrategias y backtesting", "container": "curso3-container", "logo": "📈"},
    "curso-4-machine-learning":    {"color": "#00e0ff", "name": "ML para Trading", "short": "machine learning", "container": "curso4-container", "logo": "🤖"},
    "curso-5-ejecucion-despliegue": {"color": "#ffb347", "name": "Ejecución y Despliegue", "short": "ejecución y despliegue", "container": "curso5-container", "logo": "⚡"},
    "curso-6-avanzado":             {"color": "#2b9eff", "name": "Trading Avanzado", "short": "trading avanzado", "container": "curso6-container", "logo": "🚀"},
}

# Module-specific accent colors per module number (for variety within courses)
MOD_COLORS = {
    "01": "#00e0ff", "02": "#ffb347", "03": "#00ffc8", "04": "#2b9eff",
    "05": "#ff6b6b", "06": "#9c64ff", "07": "#ffd700", "08": "#ff64dc",
    "09": "#ffb347", "10": "#00ffc8", "11": "#ff6b6b", "12": "#3d7eff",
}

# ──────────────────────────────────────────────
# CONTENT DATABASE — SPA ific for each module
# ──────────────────────────────────────────────

# Section A: "¿Qué aprenderás?" objectives
OBJECTIVES = {
    # Curso 1 — Python Financiero
    ("1","01"): ["Escribir tu primer script en Python para analizar datos financieros",
                 "Importar las librerías esenciales: pandas, numpy, matplotlib",
                 "Entender por qué Python domina la industria cuantitativa",
                 "Cargar y explorar un dataset de precios desde cero"],
    ("1","02"): ["Declarar variables con nombres descriptivos siguiendo PEP8",
                 "Diferenciar int, float, str y bool en contexto de trading",
                 "Convertir entre tipos (string → float → int) para APIs",
                 "Evaluar condiciones booleanas para señales de compra/venta"],
    ("1","03"): ["Crear listas ordenadas de precios y acceder por índice",
                 "Construir diccionarios con pares ticker → precio",
                 "Elegir entre lista, dict, tupla y set según el problema",
                 "Manipular datos de mercado con métodos nativos de Python"],
    ("1","04"): ["Escribir condicionales if/elif/else para lógica de trading",
                 "Iterar velas con for loops para calcular indicadores",
                 "Usar while para monitoreo continuo de precios en vivo",
                 "Combinar bucles y condicionales en estrategias reales"],
    ("1","05"): ["Definir funciones reutilizables con def y parámetros",
                 "Devolver valores con return para composición de estrategias",
                 "Aplicar funciones puras para backtesting determinista",
                 "Organizar el código en módulos de análisis, señales, riesgo"],
    ("1","06"): ["Crear arrays NumPy desde listas de precios",
                 "Calcular rendimientos con np.diff y np.log",
                 "Aplicar operaciones vectorizadas sin un solo for loop",
                 "Medir la ganancia de velocidad: 100x más rápido que listas"],
    ("1","07"): ["Construir DataFrames desde datos OHLC",
                 "Calcular medias móviles con rolling().mean()",
                 "Filtrar velas con máscaras booleanas",
                 "Remuestrear a timeframe semanal con resample"],
    ("1","08"): ["Trazar gráficos de precios con matplotlib",
                 "Personalizar colores, ejes y leyendas profesionales",
                 "Crear gráficos de velas con mplfinance",
                 "Interpretar tendencias, soportes y resistencias visualmente"],
    ("1","09"): ["Hacer requests GET a APIs REST de Binance y Bybit",
                 "Parsear respuestas JSON a diccionarios Python",
                 "Extraer precios y volúmenes de market data endpoints",
                 "Construir un pipeline de datos automático desde APIs"],
    ("1","10"): ["Definir clases Estrategia con atributos y métodos",
                 "Usar __init__ para configurar parámetros del bot",
                 "Heredar comportamientos comunes entre estrategias",
                 "Modelar carteras, órdenes y riesgos con POO"],
    ("1","11"): ["Capturar excepciones con try/except en pipelines de datos",
                 "Implementar logging rotativo con logging.handlers",
                 "Depurar TypeError, KeyError y ZeroDivisionError",
                 "Construir un sistema de monitoreo para tu bot"],
    ("1","12"): ["Repasar todos los módulos del curso con ejercicios integrados",
                 "Identificar las fortalezas y áreas de mejora en tu aprendizaje",
                 "Aplicar conceptos a un proyecto personal de trading",
                 "Planificar tu ruta de aprendizaje avanzado (Cursos 2-6)"],

    # Curso 2 — Mercados y Análisis
    ("2","01"): "Comprenderás la microestructura de mercados electrónicos modernos. Identificarás los participantes clave (market makers, traders, algoritmos). Leerás un order book real de Binance y entenderás liquidez.",
    ("2","02"): "Distinguirás entre market orders y limit orders con ejemplos visuales. Calcularás spreads, slippage y profundidad desde un order book. Simularás el match de órdenes en un DEX simulado.",
    ("2","03"): "Construirás velas OHLC desde ticks crudos usando pandas. Descargarás datos históricos de yfinance y Binance API. Detectarás gaps, sesiones y anomalías en datos del mundo real.",
    ("2","04"): "Calcularás soportes y resistencias con rolling min/max. Implementarás un detector de quiebres alcistas y bajistas. Visualizarás niveles clave en gráficos de precios reales.",
    ("2","05"): "Programarás medias móviles SMA, EMA y WMA desde cero. Calcularás bandas de Bollinger y MACD paso a paso. Aplicarás indicadores de tendencia a estrategias de follow.",
    ("2","06"): "Implementarás RSI, Stochastic y CCI para medir momentum. Detectarás divergencias alcistas y bajistas en datos reales. Combinarás momentum y tendencia para señales robustas.",
    ("2","07"): "Medirás volatilidad histórica con desviación estándar. Calcularás ATR para stops dinámicos. Normalizarás riesgo por volatilidad en cada operación.",
    ("2","08"): "Calcularás volumen relativo y OBV con pandas. Detectarás acumulación vs distribución. Confirmarás señales de precio con volumen en estrategias.",
    ("2","09"): "Identificarás 12 patrones de velas japonesas clave. Programarás detectores para doji, engulfing y hammer. Combinarás patrones con indicadores para señales de alta probabilidad.",
    ("2","10"): "Descargarás y sincronizarás datos de múltiples timeframes. Aplicarás la teoría de Wyckoff a 3 timeframes. Construirás señales multi-tf con confirmación jerárquica.",
    ("2","11"): "Extraerás datos fundamentalistas de earnings y news. Correlacionarás fundamentales con precio usando Python. Construirás un score compuesto fundamentals + técnico.",
    ("2","12"): "Integrarás todos los análisis previos en un dashboard. Repasarás los 11 módulos con ejercicios de síntesis. Validarás tu capacidad de análisis de mercados reales.",

    # Curso 3 — Estrategias y Backtesting
    ("3","01"): "",
    ("3","02"): "Implementarás MA Crossover con golden cross y death cross. Ejecutarás Channel Breakout y Donchian Channels. Compararás sistemas de tendencia vs mercados laterales.",
    ("3","03"): "Programarás Bollinger Bands para reversión a la media. Implementarás mean reversion con z-score y pares. Medirás la estacionariedad de spreads con tests ADF.",
    ("3","04"): "Calcularás momentum con tasa de cambio y ROC. Construirás un sistema de ranking de activos por momentum. Aplicarás momentum cross-sectional vs time-series.",
    ("3","05"): "Calcularás ATR para stops basados en volatilidad. Implementarás estrategia de expansión de volatilidad. Ajustarás tamaño de posición por volatilidad dinámica.",
    ("3","06"): "Ejecutarás backtesting vectorizado con pandas vectorial. Calcularás equity curve, drawdown y Sharpe Ratio. Compararás resultados con buy-and-hold benchmark.",
    ("3","07"): "Construirás un event-driven backtester con ordenes. Simularás slippage, comisiones y latencia de ejecución. Validarás resultados contra el backtest vectorizado.",
    ("3","08"): "Calcularás métricas clave: Sharpe, Sortino, Calmar, Win Rate. Implementarás Maximum Drawdown y recovery factor. Evaluarás estrategias con múltiples métricas simultáneas.",
    ("3","09"): "Implementarás walk-forward con ventanas de train/test. Optimizarás parámetros sin overfitting. Validarás robustez con out-of-sample real.",
    ("3","10"): "Identificarás survivor bias, look-ahead bias y selection bias. Corregirás forward-looking en indicadores técnicos. Construirás backtests libres de sesgos comunes.",
    ("3","11"): "Optimizarás parámetros de estrategias con grid search. Aplicarás optimización bayesiana con scikit-optimize. Diseñarás funciones objetivo robustas (Sharpe, Profit Factor, Calmar).",
    ("3","12"): "Repasarás las 11 estrategias aprendidas en el curso. Seleccionarás una estrategia para tu portafolio personal. Documentarás resultados con equipo de traders.",

    # Curso 4 — ML para Trading
    ("4","01"): "",
    ("4","02"): "Crearás features técnicas: SMA, RSI, MACD, ATR, volatility. Generarás lags, rolling stats y ventanas de observación. Aplicarás feature selection con correlación y importance.",
    ("4","03"): "Limpiarás datos financieros con tratamiento de NaN y outliers. Normalizarás y estandarizarás precios (MinMax, Z-score). Balancearás clases en señales de compra/venta/hold.",
    ("4","04"): "Implementarás regresión lineal para predicción de precios. Clasificarás señales con regresión logística. Evaluarás con MSE, MAE y F1-score específicos de trading.",
    ("4","05"): "Entrenarás Random Forest para clasificación de señales. Implementarás XGBoost con early stopping. Compararás bagging vs boosting en precisión de señales.",
    ("4","06"): "Aplicarás SVM para clasificación de regímenes de mercado. Clasificarás tendencia, rango y volatilidad. Visualizarás fronteras de decisión en 2D.",
    ("4","07"): "Construirás redes feedforward (MLP) con TensorFlow. Entrenarás modelos de clasificación de señales. Regularizarás con dropout y early stopping.",
    ("4","08"): "Implementarás LSTM para predicción de series temporales. Compararás GRU vs LSTM en precisión y velocidad. Predecirás precios con ventanas deslizantes.",
    ("4","09"): "Aplicarás CNN 1D a series de precios como señales. Extraerás features automáticos con convoluciones. Compararás CNN vs LSTM en patrones locales.",
    ("4","10"): "Segmentarás mercados con K-Means clustering. Identificarás regímenes de baja, media y alta volatilidad. Asignarás estrategias diferentes por cluster.",
    ("4","11"): "Evaluarás modelos con walk-forward validation. Medirás accuracy, precision, recall en trading. Construirás pipeline ML completo con validación robu sta.",
    ("4","12"): "Integrarás pipeline ML completo: features → modelo → señal. Seleccionarás modelo final basado en rendimiento OOS. Documentarás el proceso completo tu primer modelo.",

    # Curso 5 — Ejecución y Despliegue
    ("5","01"): "",
    ("5","02"): "Conectarás con APIs REST de Binance, Bybit, Alpaca e IB. Autenticarás con API keys de forma segura. Parsearás respuestas JSON a estructuras Python.",
    ("5","03"): "Enviarás órdenes market y limit con parámetros específicos. Leerás confirmaciones de fill parcial y total. Implementarás verificación de estado de órdenes.",
    ("5","04"): "Conectarás WebSocket para streams de precios en vivo. Suscribirás a canales de trades y orderbook. Manejarás reconexión automática con backoff exponencial.",
    ("5","05"): "Implementarás asyncio para ejecución concurrente. Coordinarás lecturas de WebSocket + ejecución de órdenes. Construirás un event loop para trading en vivo.",
    ("5","06"): "Implementarás TWAP y VWAP para ejecución institucional. Dividirás órdenes grandes en slices para minimizar slippage. Simularás ejecución con data histórica.",
    ("5","07"): "Calcularás tamaño de posición con Kelly Criterion. Implementarás stop-loss dinámico con ATR. Aplicarás risk budgeting por activo y por cartera.",
    ("5","08"): "Configurarás logging con timestamps y niveles. Monitorearás trades en tiempo real con dashboards. Implementarás alertas de errores con notificaciones.",
    ("5","09"): "Desplegarás bot en AWS EC2 con Docker. Configurarás cron jobs para ejecución programada. Construirás arquitectura de alta disponibilidad 24/7.",
    ("5","10"): "Registrarás trades con entry, exit, P&L en tu journal. Analizarás tu historial con Python para mejorar. Implementarás análisis de desempeño mensual.",
    ("5","11"): "Protegerás API keys con variables de entorno. Implementarás rate limiting y IP whitelisting. Encriptarás datos sensibles en reposo y tránsito.",
    ("5","12"): "Repasarás técnicas de ejecución de los 11 módulos. Integrarás bot completo: API → orden → log → reporte. Documentarás despliegue para produccción.",

    # Curso 6 — Trading Avanzado
    ("6","01"): "",
    ("6","02"): "Implementarás MPT con frontera eficiente de Markovitz. Calcularás portafolio de mínima varianza. Optimizarás Sharpe para máxima rentabilidad ajustada por riesgo.",
    ("6","03"): "Implementarás modelo Black-Litterman con views de mercado. Construirás HRP (Hierarchical Risk Parity). Compararás BL vs tradicional en portafolios reales.",
    ("6","04"): "Calcularás VaR paramétrico, histórico y Monte Carlo. Implementarás CVaR (Expected Shortfall). Backtestearás límites de VaR en datos históricos.",
    ("6","05"): "Implementarás rebalanceo dinámico con bandas de tolerancia. Ajustarás pesos por cambio de volatilidad y correlación. Compararás rebalanceo periódico vs oportunista.",
    ("6","06"): "Generarás señales multi-activo correlacionadas. Asignarás pesos por score compuesto (momentum+valor+tamaño). Construirás sistema de ranking automático.",
    ("6","07"): "Ejecutarás cointegración Johansen y pair trading. Calcularás spreads estacionarios y z-scores. Implementarás mean-reversion sobre el spread sintético.",
    ("6","08"): "Entrenarás agentes RL para ejecución en simulador. Implementarás Q-learning y Deep Q-Networks. Compararás RL vs heurísticas en ejecución de órdenes.",
    ("6","09"): "Conectarás LangChain con APIs de datos y brokers. Construirás agent autónomo de trading con herramientas. Analizarás el razonamiento del agente en decisiones.",
    ("6","10"): "Analizarás noticias financieras con spaCy y TextBlob. Construirás pipeline de NLP para sentimiento de mercado. Combinarás sentimiento con técnico en señales.",
    ("6","11"): "Integrarás módulos 01-10 en sistema único de trading. Desplegarás sistema completo con monitoreo en vivo. Validarás sistema con paper trading real.",
    ("6","12"): "Repasarás los 11 módulos avanzados y técnicas aprendidas. Evaluarás tu capacidad para construir sistemas completos. Proyectarás ruta de aprendizaje post-curso.",
}

for k in list(OBJECTIVES.keys()):
    if isinstance(OBJECTIVES[k], str):
        bullets = OBJECTIVES[k].split(". ")
        OBJECTIVES[k] = [b.strip() for b in bullets if b.strip()]

# ──────────────────────────────────────────────
# INFO PANELS — 5-6 panels per module
# ──────────────────────────────────────────────

INFO_PANELS = {
    ("1","02"): [
        {
            "icon": "🧠", "title": "Intuición: las variables como contenedores",
            "paragraphs": [
                "Imagina que cada vez que consultas un precio de Bitcoin, Python necesita guardarlo en algún lado. Ahí entran las variables, como casilleros etiquetados en un vestuario de exchange. El nombre del casillero (precio_btc) es tu responsabilidad; Python solo recuerda el contenido.",
                "En Python no declaras el tipo explícitamente — el lenguaje lo infiere. Esto se llama tipado dinámico y es la razón por la que pandas suelta un DataFrame en 2 líneas. Pero ojo: la flexibilidad también permite errores silenciosos si mezclas tipos sin querer.",
                "Los tipos mutables (listas, dicts) pueden cambiar después de creados. Los inmutables (tuplas, strings, números) no. En trading, usar tuplas para precios históricos garantiza que nadie modifique tus datos accidentalmente."
            ]
        },
        {
            "icon": "🐍", "title": "Código Python: asignación y conversión",
            "paragraphs": [
                "precio_btc = 67500.50 — sin type, sin var, sin let. En Python la asignación es directa: nombre = valor. El lado derecho se evalúa primero y luego se asigna al nombre. Esto es fundamental para entender referencias compartidas.",
                "Si un API devuelve \"45000\" (string), necesitas int( ) para operar. int( ) y float( ) no redondean — truncan o lanzan error si el string no es numérico. Usa siempre try/except al parsear APIs externas.",
                "bool( ) evalúa 'veracidad': 0, None, '' y colecciones vacías son False; todo lo demás es True. En trading: if volumen: es más limpio que if volumen != 0:."
            ]
        },
        {
            "icon": "📈", "title": "Ejemplo de trading real",
            "paragraphs": [
                "Escenario: recibes precio de BTC desde WebSocket. precio_str = \"67451.50\" (viene como string del JSON). Necesitas calcular: 1.01 * precio_str para marcar un 1% arriba. Pero esto lanza TypeError porque multiplicas string por float.",
                "Solución: precio = float(precio_str). Ahora puedes calcular precio_limite = round(precio * 1.01, 2). El round( ... , 2 ) es importante porque float puede arrastrar errores de redondeo que arruinan las señales.",
                "Bonus: isinstance(precio, (int, float)) te permite verificar antes de operar. Siempre valida tipos cuando trabajas con datos externos — las APIs cambian, los tipos también."
            ]
        },
        {
            "icon": "⚠️", "title": "Error común: confundir tipos",
            "paragraphs": [
                "El error más frecuente entre traders al implementar por primera vez: concatenan strings en vez de sumar números. precio_str = \"67450\" + \"1000\" da \"674501000\", no 68450. Siempre convierte antes de operar.",
                "Otro clásico: precio = input(\"Precio: \") devuelve string aunque el usuario teclee 67500. Envías precio > 50000 y obtienes TypeError porque comparas str con int.",
                "Consejo: usa type_guard. Define una función asegurate que recibe el tipo esperado y convierte si es posible. Así encapsulas la lógica de tipo en un solo lugar."
            ]
        }
    ],
}

# ──────────────────────────────────────────────
# SCENARIO STEP-BY-STEP for "Ejemplo paso a paso"
# ──────────────────────────────────────────────

WALKTHROUGH = {
    ("1","02"): {
        "title": "Calcular precio de compra con 5% de incremento",
        "background": "Un bot recibe el precio actual de BTC desde una API y debe calcular el precio límite para comprar un 5% por encima del mercado (strategia de breakout).",
        "steps": [
            ("Paso 1: Obtén el precio de la API", "precio_api = requests.get(url).json()['price'] # '67450.50'", "El valor llega como string porque viene serializado en JSON."),
            ("Paso 2: Convierte a float", "precio = float(precio_api)", "Con float( ) conviertes a número decimal. Si el string es inválido, lanza ValueError."),
            ("Paso 3: Calcula el multiplicador", "incremento = 1.05", "5% de incremento = 1 + 5/100 = 1.05"),
            ("Paso 4: Obtén precio objetivo", "precio_objetivo = round(precio * incremento, 2)", "El resultado es un float con 2 decimales."),
            ("Paso 5: Evalúa la señal", "if precio_objetivo > 70000: print('Señal de compra')", "Usas un booleano para decidir si ejecutar la orden."),
        ],
        "result": "Objetivo: 70822.80. Señal: True → ejecutar compra.",
        "code": """import requests
url = "https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT"
resp = requests.get(url).json()
precio_api = resp['price']
precio = float(precio_api)
incremento = 1.05
precio_objetivo = round(precio * incremento, 2)
print(f"Precio actual: {precio}")
print(f"Precio objetivo (+5%): {precio_objetivo}")
es_señal = precio_objetivo > 70000
print(f"¿Señal de compra? {es_señal}")"""
    },
}

# ──────────────────────────────────────────────
# QUIZ — 3-4 questions per module with explanations
# ──────────────────────────────────────────────

QUIZZES = {
    ("1","02"): {
        "title": "Quiz: Variables y Tipos en Trading",
        "questions": [
            {
                "question": "¿Qué tipo de dato devuelve type(\"67500\")?",
                "options": ["<class 'int'>", "<class 'float'>", "<class 'str'>", "<class 'bool'>"],
                "correct": 2,
                "explanation": "Las comillas dobles alrededor de \"67500\" convierten el valor en string. Aunque parezca un número, es texto. type() revela <class 'str'>."
            },
            {
                "question": "¿Qué sucede si ejecutas: resultado = \"50000\" + 1000?",
                "options": ["Devuelve 51000", "Lanza TypeError", "Devuelve \"500001000\"", "Devuelve None"],
                "correct": 1,
                "explanation": "No puedes sumar un str con un int. Python lanza TypeError: can only concatenate str (not 'int') to str. Primero debes convertir con int() o float()."
            },
            {
                "question": "¿Cuál de las siguientes opciones es una conversión CORRECTA?",
                "options": ["int(\"67450.50\")", "float(\"67,450.50\")", "float(\"67450.50\")", "str(True) + 1"],
                "correct": 2,
                "explanation": "float(\"67450.50\") funciona porque el string usa punto decimal. 67450.50 con coma lanza ValueError. int() no acepta punto decimal. str + int lanza TypeError."
            },
            {
                "question": "Si precio = 67450.50, ¿cuál es el resultado de bool(precio > 68000)?",
                "options": ["True", "False", "TypeError", "None"],
                "correct": 1,
                "explanation": "67450.50 > 68000 es FALSO. bool() sobre una comparación devuelve el resultado booleano de esa comparación: en este caso, False."
            }
        ]
    },
}

# ──────────────────────────────────────────────
# "Resumen del módulo" content per module
# ──────────────────────────────────────────────

SUMMARY = {
    ("1","02"): {
        "key_points": [
            "Python usa tipado dinámico — no necesitas declarar el tipo",
            "Los tipos principales son int, float, str, bool",
            "type() inspecciona el tipo de cualquier variable",
            "float(), int(), str() convierten entre tipos",
            "Las comparaciones (>, <, ==) siempre devuelven bool",
            "Los nombres de variables deben ser descriptivos: precio_btc, no p"
        ],
        "connection": "Este módulo conecta con Estructuras de Datos: ahí construirás listas y dicts con los tipos que aprendiste aquí. Una lista de precios es una secuencia de floats, y un dict mapea tickers a precios usando strings y floats.",
        "next_steps": "Practica type() con cada variable que crees. Haz conversiones explícitas aunque Python infiera. En el siguiente módulo verás estructuras que organizan estos datos."
    },
}

# ================================================================
# BUILD SECTIONS
# ================================================================

def build_objectives_section(objectives, color, rgb):
    if not objectives:
        return ""
    bullets = "\n".join(f'        <li>{b}</li>' for b in objectives)
    return f'''
<div class="objectives" style="background:rgba({rgb},0.1);border:1px solid rgba({rgb},0.3);border-radius:1.5rem;padding:1rem 1.5rem;margin:1rem 2rem;">
  <h3 style="color:{color};margin-bottom:0.5rem">🎯 ¿Qué aprenderás?</h3>
  <ul style="list-style:none;padding:0">
{bullets}
  </ul>
</div>'''

CSS = '''
.objectives ul { padding:0; }
.objectives li { color:#b9ccee; font-size:0.9rem; margin:0.4rem 0; list-style-type: none; }
.objectives li::before { content:"🎯 "; }
'''

# ================================================================
# MAIN PROCESSING
# ================================================================

def get_file_module_num(filepath):
    """Extract module number from filename like '02-variables-tipos.html'"""
    base = os.path.basename(filepath)
    m = re.match(r'(\d{2})-', base)
    return m.group(1) if m else None

def get_course_num(folder):
    m = re.match(r'curso-(\d)-', folder)
    return m.group(1) if m else None

def read_file(filepath):
    for enc in ['utf-8', 'latin-1', 'cp1252']:
        try:
            with open(filepath, 'r', encoding=enc) as f:
                return f.read()
        except UnicodeDecodeError:
            continue
    return None

def build_info_panels(panels, color, rgb):
    if not panels:
        return ""
    sections = []
    for p in panels:
        paras = "\n".join(f'      <p style="margin-bottom:0.5rem">{para}</p>' for para in p["paragraphs"])
        section_html = f'''
    <div class="info-panel" style="background:rgba(0,10,25,0.6);border:1px solid rgba({rgb},0.2);border-radius:1.5rem;padding:1rem;margin-bottom:1rem">
      <h4 style="color:{color};margin-bottom:0.5rem">{p["icon"]} {p["title"]}</h4>
{paras}
    </div>'''
        sections.append(section_html)
    return f'''
<div class="enhance-section" style="border:1px solid rgba({rgb},0.3);background:rgba(0,10,25,0.4)">
  <h3 style="color:{color};margin-bottom:1rem">📖 Panel de aprendizaje profundo</h3>
{''.join(sections)}
</div>'''

def build_walkthrough(wt, color, rgb):
    if not wt:
        return ""
    steps_html = ""
    for i, (title, code, explanation) in enumerate(wt["steps"]):
        steps_html += f'''
      <div style="margin-bottom:0.8rem;padding:0.6rem;background:rgba(0,0,0,0.2);border-radius:1rem">
        <div style="font-weight:600;color:{color};margin-bottom:0.3rem">Paso {i+1}: {title}</div>
        <div style="background:#0a0f1e;border-radius:0.5rem;padding:0.4rem 0.8rem;font-family:monospace;font-size:0.82rem;color:#569cd6;margin-bottom:0.3rem">{code}</div>
        <div style="font-size:0.85rem;color:#b9ccee">{explanation}</div>
      </div>'''
    return f'''
<div class="example-section" style="background:rgba(0,10,25,0.7);backdrop-filter:blur(8px);border:1px solid {color};border-radius:2rem;padding:1.5rem;margin:1.5rem 2rem">
  <h3 style="color:{color};margin-bottom:0.8rem">💻 Ejemplo paso a paso: {wt["title"]}</h3>
  <p style="font-size:0.9rem;color:#b9ccee;margin-bottom:1rem">{wt.get("intro", "")}</p>
{steps_html}
  <div style="margin-top:1rem;padding:0.8rem;background:rgba(0,200,100,0.1);border:1px solid #00c864;border-radius:1rem">
    <strong style="color:#00c864">✅ Resultado:</strong> <span style="font-size:0.85rem">{wt["result"]}</span>
  </div>
  <div style="margin-top:0.8rem">
    <button class="btn-action" onclick="document.getElementById('code-block-wt').classList.toggle('hidden')" style="font-size:0.8rem;padding:0.5rem 1rem">
      📝 Ver código completo
    </button>
    <div id="code-block-wt" class="hidden" style="margin-top:0.5rem;background:#0a0f1e;border-radius:1rem;padding:1rem;font-family:monospace;font-size:0.8rem;white-space:pre-wrap;border:1px solid {color}">
{wt.get("code", "")}
    </div>
  </div>
</div>'''

def build_quiz(quiz_data, color, rgb, mod_num):
    if not quiz_data:
        return ""
    questions_html = ""
    for qi, q in enumerate(quiz_data.get("questions", [])):
        options_html = ""
        for oi, opt in enumerate(q["options"]):
            options_html += f'''
        <label class="quiz-option" data-q="{qi}" data-opt="{oi}" onclick="selectQuizOpt({qi},{oi},{qi})" id="qopt_{qi}_{oi}">
          {opt}
        </label>'''
        questions_html += f'''
    <div class="quiz-question" id="qdiv_{qi}" data-correct="{q['correct']}">
      <h3 style="color:{color}">Pregunta {qi+1}: {q["question"]}</h3>
{options_html}
      <div id="qexp_{qi}" class="hidden" style="margin-top:0.5rem;padding:0.6rem;background:rgba(0,0,0,0.3);border-radius:1rem;font-size:0.85rem;color:#b9ccee;border-left:3px solid {color}">
        <strong>Explicación:</strong> {q["explanation"]}
      </div>
    </div>'''
    
    return f'''
<div class="enhance-section" style="border:1px solid rgba({rgb},0.3);margin:1.5rem 2rem">
  <h3 style="color:{color}">🧪 {quiz_data.get("title", "Quiz del módulo")}</h3>
  <p style="font-size:0.85rem;color:#8899bb;margin-bottom:1rem">Responde las siguientes preguntas. Cada respuesta tiene una explicación.</p>
  <div id="quiz-area">
{questions_html}
  </div>
  <div style="text-align:center;margin-top:1rem">
    <button class="btn-action" onclick="checkAllQuiz({ci})" style="font-size:0.9rem;padding:0.6rem 1.5rem">
      ✅ Corregir todo
    </button>
    <div id="quiz-result-{mod_num}" style="margin-top:0.8rem;font-size:1rem;font-weight:600"></div>
  </div>
</div>'''

def build_summary(summary_data, color, rgb):
    if not summary_data:
        return ""
    pts = "\n".join(f'        <li style="margin:0.3rem 0;font-size:0.9rem">{p}</li>' for p in summary_data.get("key_points", []))
    return f'''
<div class="enhance-section" style="border:1px solid rgba({rgb},0.3);background:rgba(0,20,40,0.5)">
  <h3 style="color:{color};margin-bottom:0.8rem">📚 Resumen del módulo</h3>
  <div style="display:flex;flex-wrap:wrap;gap:1rem">
    <div style="flex:1;min-width:200px">
      <h4 style="color:{color};font-size:0.95rem;margin-bottom:0.5rem">🔑 Puntos clave</h4>
      <ul style="list-style:none;padding:0">
{pts}
      </ul>
    </div>
    <div style="flex:1;min-width:200px;padding:0.8rem;background:rgba(0,0,0,0.2);border-radius:1.5rem">
      <h4 style="color:{color};font-size:0.95rem;margin-bottom:0.5rem">🔗 Conexión con el siguiente módulo</h4>
      <p style="font-size:0.85rem;color:#b9ccee">{summary.get("connection", "")}</p>
      <h4 style="color:{color};font-size:0.95rem;margin:0.5rem 0">📌 Próximos pasos</h4>
      <p style="font-size:0.85rem;color:#b9ccee">{summary.get("next_steps", "")}</p>
    </div>
  </div>
</div>'''

def add_quiz_scripts(color, mod_num, ci, course_name):
    """Generate JS for quiz checking"""
    return f'''
<script>
var correctCount_{ci}_{mod_num} = 0;
var totalQuiz_{ci}_{mod_num} = 0;
function selectQuiz(el, idx, qi) {{
  var parent = document.getElementById('qdiv_'+qi);
  var opts = parent.querySelectorAll('.quiz-option');
  opts.forEach(function(o) {{ o.classList.remove('selected'); }});
  el.classList.add('selected');
}}
function checkQuiz_{ci}_{mod_num}(qi) {{
  var div = document.getElementById('qdiv_'+qi);
  var correct = parseInt(div.dataset.correct);
  var selected = div.querySelector('.quiz-option.selected');
  if (!selected) {{
    document.getElementById('qexp_'+qi).classList.remove('hidden');
    return false;
  }}
  var chosen = parseInt(selected.dataset.opt);
  if (chosen === correct) {{
    selected.classList.add('correct');
    document.getElementById('qexp_'+qi).classList.remove('hidden');
    return true;
  }} else {{
    selected.classList.add('wrong');
    var correctEl = div.querySelector('.quiz-option[data-opt="'+correct+'"]');
    if (correctEl) correctEl.classList.add('correct');
    document.getElementById('qexp_'+qi).classList.remove('hidden');
    return false;
  }}
}}
function checkAllQuiz_{ci}() {{
  var total = document.querySelectorAll && document.querySelectorAll('#qarea_{ci}_{mod_num} .quiz-question');
  if (!total) return;
  var correct = 0;
  total.forEach(function(div, i) {{
    if (checkQuiz(div, i)) correct++;
  }});
  document.getElementById('quiz-result-{mod_num}').textContent = 'Puntaje: ' + correct + '/' + total.length;
}}
</script>'''

def process_file(filepath, course_folder, course_info, mod_num):
    ci = course_num
    color = course_info["color"]
    rgb = hex_to_rgb(color)
    cname = course_info["name"]
    cshort = course_info["short"]
    
    html = read_file(filepath)
    if html is None:
        return False, "Cannot read"
    
    # Only process module files (02-11 or 12), skip index, portal, certificado
    base = os.path.basename(filepath)
    if base == 'index.html' or base == '01-portal.html' or base == '12-certificado.html':
        return False, "Skipped (portal/index/cert)"
    
    # Check if already enhanced
    if 'objectives' in html or 'Panel de aprendizaje profundo' in html or 'Quiz del módulo' in html:
        return False, "Already enhanced"
    
    # Build all sections
    obj_key = (str(course_num), mod_num)
    objectives = OBJECTIVES.get(obj_key, ["Comprender los conceptos fundamentales del módulo",
                                           "Aplicarlos a ejercicios prácticos de trading",
                                           "Integrarlos con módulos anteriores",
                                           "Prepararte para el siguiente nivel"])
    if isinstance(objectives, str):
        objectives = [b.strip() for b in objectives.split(". ") if b.strip()]
    
    obj_section = build_objectives_section(objectives, color, rgb)
    
    panels = INFO_PANELS.get(obj_key, None)
    if panels is None:
        # Generate default panels based on module number
        panels = [
            {"icon": "🧠", "title": "Intuición conceptual",
             "paragraphs": [
                 f"En {cshort}, cada concepto se construye sobre el anterior. La intuición es tu brújula: sin ella, el algoritmo es solo código sin dirección.",
                 f"Piensa en términos de flujo: entrada de datos → procesamiento → decisión → ejecución. Cada módulo de este curso añade una capa a ese flujo.",
                 f"El objetivo no es memorizar sintaxis, sino desarrollar un mapa mental de cómo Python modela los mercados financieros."
             ]},
            {"icon": "🐍", "title": "Código Python aplicado",
             "paragraphs": [
                 "El código de trading algorítmico se distingue por su necesidad de velocidad, precisión y robustez. No escribes para usuarios — escribes para máquinas que ejecutan dinero real.",
                 "Sigue el principio KISS: cada función debe hacer una sola cosa y hacerla bien. Las estrategias más rentables suelen ser las más simples.",
                 "Documenta con tipos: def mi_funcion(param: float) -> bool. En producción, esto previene errores de tipo en pipelines de datos de alta frecuencia."
             ]},
            {"icon": "📈", "title": "Ejemplo en mercado real",
             "paragraphs": [
                 "Los ejemplos de este módulo usan datos reales de Binance, Bybit o Yahoo Finance. No trabajamos con datos sintéticos — queremos que veas el ruido real del mercado.",
                 "Los patrones que aprenderás aquí aparecen en todos los activos: cripto, acciones, forex y futuros. Las herramientas son las mismas; solo cambian los símbolos.",
                 "Aplica cada ejemplo a tu mercado favorito. La práctica deliberada con datos reales es el camino más rápido al dominio del trading algorítmico."
             ]},
            {"icon": "⚠️", "title": "Trampas y errores frecuentes",
             "paragraphs": [
                 "Los errores más comunes en trading algorítmico no son técnicos — son conceptuales: usar look-ahead bias, overoptimizar parámetros o ignorar costos de transacción.",
                 "El código correcto no garantiza ganancias. Una estrategia perfectamente implementada puede perder dinero porque el mercado cambió. La validación continua es tu seguro.",
                 "Sé escéptico de resultados de backtest que parecen demasiado buenos — probablemente lo son. La regla de oro: si funciona en backtest pero no en vivo, es un sesgo."
             ]},
        ]
    
    info_section = build_info_panels(panels, color, rgb)
    
    wt_key = (str(course_num), mod_num)
    walk = WALKTHROUGH.get(wt_key, None)
    walk_section = build_walkthrough(walk, color, rgb) if info_section else ""
    
    quiz_data = QUIZZES.get(wt_key, None)
    quiz_section = build_quiz(quiz_data, color, rgb, mod_num) if quiz_data else ""
    
    summary_data = SUMMARY.get(wt_key, None)
    if summary_data is None:
        summary_data = {
            "key_points": [
                "Cada concepto de este módulo se conecta con los siguientes",
                "La práctica es más importante que la teoría",
                "Aplica lo aprendido a un dataset real",
                "Documenta tus experimentos para aprendizaje futuro",
                "Repite y refina: el trading algorítmico es iterativo"
            ],
            "connection": "Este módulo prepara el terreno para los siguientes, donde exploraremos conceptos más avanzados que requieren dominar los fundamentos.",
            "next_steps": "Repite los ejercicios hasta que puedas hacerlos sin consultar el código de referencia. Luego, intenta modificar los parámetros y observa cómo cambian los resultados."
        }
    sum_section = build_summary(summary_data, color, rgb)
    
    # Insert the enhance-section CSS before </head>
    css_block = f'''
<style>
.objectives ul {{ padding:0; }}
.objectives li {{ color:#b9ccee; font-size:0.9rem; margin:0.4rem 0; list-style-type: none; }}
.objectives li::before {{ content:"🎯 "; }}
</style>'''
    
    if '</head>' in html:
        html = html.replace('</head>', css_block + '\n</head>')
    
    # Insert objectives after analogy-card
    if obj_section and '</div>\n<div class="main-area">' in html:
        html = html.replace('</div>\n<div class="main-area">', f'</div>\n{obj_section}\n<div class="main-area">')
    elif obj_section and '<!-- objectives-insert -->' not in html:
        pos = html.find('<div class="main-area">')
        if pos > 0:
            html = html[:pos] + obj_section + '\n' + html[pos:]
    
    # Insert info panels before exercise1 or nav-links
    if info_section:
        if '<div id="exercise1"' in html:
            html = html.replace('<div id="exercise1"', info_section + '\n<div id="exercise1"')
        elif '<div class="nav-links">' in html:
            html = html.replace('<div class="nav-links">', info_section + '\n<div class="nav-links">')
    
    if walk_section:
        if '<div class="nav-links">' in html:
            html = html.replace('<div class="nav-links">', walk_section + '\n<div class="nav-links">')
    
    if quiz_section:
        if '<div class="nav-links">' in html:
            html = html.replace('<div class="nav-links">', quiz_section + '\n' + quiz_scripts + '\n<div class="nav-links">')
    
    if sum_section:
        if '<div class="nav-links">' in html:
            html = html.replace('<div class="nav-links">', sum_section + '\n<div class="nav-links">')
    
    # Write back
    with open(filepath, 'w', encoding='utf-8', errors='replace') as f:
        f.write(html)
    
    return True, "Enhanced"

def main():
    total = 0
    skipped = 0
    errors = 0
    
    for folder, course_info in COURSES.items():
        folder_path = os.path.join(BASE, folder)
        if not os.path.isdir(folder_path):
            print(f"⚠️  Folder not found: {folder_path}")
            continue
        
        ci = folder[-2] if folder[-2].isdigit() else folder[-1]
        course_num = get_course_num(folder)
        print(f"\n{'='*60}")
        print(f"📁 {folder} (Curso {course_num})")
        print(f"{'='*60}")
        
        files = sorted([f for f in os.listdir(folder_path) if f.endswith('.html')])
        for fname in files:
            filepath = os.path.join(folder_path, fname)
            mod_num = get_file_module_num(filepath)
            if not mod_num:
                continue
            
            try:
                ok, msg = process_file(filepath, course_num, info, mod_num)
                if ok:
                    total += 1
                    print(f"  ✅ {fname}")
                else:
                    skipped += 1
                    print(f"  ⏭️ {fname} ({msg})")
            except Exception as e:
                errors += 1
                print(f"  ❌ {fname}: {e}")
    
    print(f"\n{'='*60}")
    print(f"📊 Resumen: {total} mejorados, {skipped} omitidos, {errors} errores")
    print(f"{'='*60}")

if __name__ == '__main__':
    main()