#!/usr/bin/env python3
"""
Enhance all 79 trading course module files with 5 new self-learning sections.
Preserves ALL existing functionality. Only ADDS new CSS and HTML.
"""

import os, re

BASE = r"D:\poryectosPulidos\PAGINA\cursos\trading-algoritmico-python"

def hex_to_rgb(h):
    h = h.lstrip('#')
    return f"{int(h[0:2],16)},{int(h[2:4],16)},{int(h[4:6],16)}"

def get_questions(m):
    qs = {
        "02": ("¿Cómo verificas el tipo de una variable en Python?", ["type(", "type()"]),
        "03": ("¿Qué estructura de datos usarías para una lista ordenada y mutable de precios?", ["lista", "list", "array"]),
        "04": ("¿Qué palabra clave permite ejecutar código solo si una condición es True?", ["if"]),
        "05": ("¿Qué palabra clave devuelve un valor desde una función en Python?", ["return"]),
        "06": ("¿Qué método de NumPy calcula el logaritmo natural de un array?", ["np.log", "log"]),
        "07": ("¿Qué método de Pandas calcula una media móvil sobre una ventana?", ["rolling", ".rolling", "rolling()"]),
        "08": ("¿Qué biblioteca de Python se usa principalmente para gráficos de línea?", ["matplotlib", "plt.plot", "pyplot"]),
        "09": ("¿Qué método de requests convierte la respuesta HTTP a diccionario Python?", [".json()", "json()"]),
        "10": ("¿Qué parámetro especial recibe el constructor __init__ de una clase?", ["self"]),
        "11": ("¿Qué palabra clave captura una excepción en Python?", ["except"]),
    }
    return qs.get(m, ("¿Cuál es el concepto más importante que aprendiste en este módulo?", ["importante", "clave", "aprendi"]))

def get_trivia(m):
    pool = {
        "01": "Python fue creado en 1991 por Guido van Rossum y hoy es el lenguaje #1 en finanzas cuantitativas. Fondos como Two Sigma y Citadel lo usan para modelar mercados.",
        "02": "En un solo día, el order book de BTC/USD en Binance genera ~500 GB de datos. Cada precio es un tipo de dato distinto: int, float, str o bool.",
        "03": "El primer DataFrame de la historia fue implementado por Wes McKinney en 2008. Una lista de Python almacena ~3650 velas (10 años de datos diarios) en ~200 KB.",
        "04": "El 75% de las estrategias algorítmicas usan condicionales if/else como núcleo. Un bot moderno evalúa miles de condiciones por segundo.",
        "05": "Si ahorras 0.01ms por llamada de función, en un backtest de 1M de velas ahorras 10 segundos enteros. ¡La modularización paga dividendos!",
        "06": "NumPy procesa arrays de 1M de elementos en ~10ms. Python puro toma ~2s. La vectorización es el superpoder del cómputo científico.",
        "07": "Renaissance Technologies, el hedge fund más exitoso, usa Pandas extensivamente. Su fondo Medallion generó ~66% anual promedio desde 1988.",
        "08": "El gráfico de velas fue creado por Munehisa Homma, comerciante de arroz japonés, en el siglo XVIII. Sigue siendo el estándar 300 años después.",
        "09": "La API financiera más antigua data de 2010 (MtGox). Hoy hay cientos de APIs gratuitas. yfinance descarga datos de Yahoo Finance (~10M req/min).",
        "10": "La POO permite heredar estrategias. Hedge funds como DE Shaw y Jane Street tienen miles de clases en sus librerías internas de trading.",
        "11": "El bug más caro fue Knight Capital 2012: algoritmo sin monitoreo causó $460M en 45 min. El logging y monitoreo salvan carreras (y capital).",
        "12": "Menos del 10% completa un curso completo de trading algorítmico. Ya casi terminas — estás en el percentil 90 de traders en formación.",
    }
    return pool.get(m, "El trading algorítmico mueve >$50 mil millones por día en exchanges. Python está en el centro de esta industria.")


def get_practical_tip(m):
    pool = {
        "01": "Siempre ejecuta df.describe() antes de analizar cualquier dataset.",
        "02": "type() e isinstance() son tus mejores aliados para debuggear datos.",
        "03": "df.to_dict() es ideal para compartir datos entre Python y otros lenguajes.",
        "04": "Combina condiciones: if precio > media AND volumen > media_vol para señales más robustas.",
        "05": "Una función debe hacer UNA cosa y hacerla bien (principio de responsabilidad única).",
        "06": "Usa np.where(cond, val_if, val_else) para reemplazar if/else en arrays.",
        "07": "df.isna().sum() revela al instante cuántos valores faltan en cada columna.",
        "08": "Guarda tus scripts de matplotlib como funciones reutilizables. Te ahorrarán horas.",
        "09": "Siempre verifica if resp.status_code == 200 antes de parsear JSON de APIs.",
        "10": "Nombra las clases como sustantivos y los métodos como verbos en infinitivo.",
        "11": "Implementa logging rotativo para no llenar tu disco con archivos de log enormes.",
        "12": "El mercado cambia constantemente — mantén un mindset de aprendizaje continuo.",
    }
    return pool.get(m, "Documenta cada prueba y experimento. Lo que no se mide no se mejora.")


def get_checklist(m):
    items = {
        "01": ["Entiendo qué es Python y por qué se usa en finanzas", "Puedo importar pandas y numpy", "Cargo y visualizo datos desde un CSV", "Identifico las librerías clave del ecosistema"],
        "02": ["Diferencio int, float, str y bool", "Convierto entre tipos con int(), float(), str()", "Evalúo condiciones booleanas", "Uso type() para inspeccionar variables"],
        "03": ["Creo listas con [] y accedo por índice", "Uso diccionarios con clave:valor", "Elijo la estructura adecuada para cada problema financiero", "Comprendo mutable vs inmutable"],
        "04": ["Escribo if/elif/else correctamente", "Uso for loops para iterar precios", "Aplico while para monitoreo continuo", "Combino condicionales con bucles para estrategias"],
        "05": ["Defino funciones con def y parámetros", "Uso return para devolver resultados", "Reutilizo funciones en diferentes contextos", "Comprendo por qué las funciones puras son mejores"],
        "06": ["Creo arrays con np.array()", "Uso np.log() y np.diff() en datos financieros", "Comprendo la ventaja de la vectorización", "Sé cuándo usar NumPy vs Python puro"],
        "07": ["Creo DataFrames desde diccionarios", "Aplico rolling().mean() para medias móviles", "Filtro filas con condiciones booleanas", "Uso resample para cambiar frecuencias temporales"],
        "08": ["Creo gráficos con plt.plot()", "Personalizo colores, etiquetas y títulos", "Diferencio tipos de gráfico (línea, vela, indicador)", "Interpreto tendencias visualmente"],
        "09": ["Entiendo qué es una API REST", "Hago requests.get() a endpoints financieros", "Parseo respuestas JSON a diccionarios", "Extraigo campos específicos del JSON"],
        "10": ["Defino clases con la palabra class", "Uso __init__ para inicializar atributos", "Creo métodos que operan con self", "Comprendo cómo la POO facilita el trading"],
        "11": ["Identifico errores comunes (TypeError, KeyError, ZeroDivisionError)", "Uso try/except para manejar excepciones", "Comprendo la importancia del logging estructurado", "Depuro sistemáticamente los bugs"],
        "12": ["He completado y repasado todos los módulos", "Puedo explicar cada concepto con mis palabras", "Tengo claros mis próximos pasos de aprendizaje", "Estoy listo para mi propio proyecto de trading"],
    }
    return items.get(m, ["Comprendo el concepto principal", "Puedo explicarlo con mis palabras", "Sé aplicarlo en trading", "Estoy listo para el siguiente módulo"])


def get_code_lines(m):
    pool = {
        "01": [
            ("import pandas as pd", "Alias estándar de la industria"),
            ("import numpy as np", "Cómputo numérico eficiente"),
            ("df = pd.read_csv('precios.csv')", "Carga datos desde CSV"),
            ("print(df.head())", "Siempre verifica las primeras filas"),
        ],
        "02": [
            ("precio_btc = 67500.0  # float", "Python asigna el tipo automáticamente"),
            ("ticker = 'BTC-USD'    # str", "Los strings se escriben entre comillas"),
            ("es_compra = precio_btc < 70000  # bool", "Las comparaciones devuelven booleanos"),
            ("print(type(precio_btc))  # <class 'float'>", "type() revela el tipo exacto"),
        ],
        "03": [
            ("precios = [67000, 67500, 68000, 67200]", "Lista: ordenada y mutable"),
            ("precios.append(67800)", "append() agrega un elemento al final"),
            ("activos = {'BTC': 67500, 'ETH': 3400}", "Dict: acceso por clave (ticker)"),
            ("print(activos['BTC'])  # 67500", "Acceso directo por nombre del activo"),
        ],
        "04": [
            ("if precio_actual > media_movil:", "Condicional: si es True, ejecuta"),
            ("    senal = 'COMPRAR'", "Bloque indentado (4 espacios)"),
            ("elif precio_actual < media_movil * 0.98:", "elif = else + if anidado"),
            ("    senal = 'VENDER'", "Segunda condición opcional"),
        ],
        "05": [
            ("def calcular_sma(precios, ventana):", "def + nombre + parámetros entre paréntesis"),
            ("    if len(precios) < ventana:", "Validación del input primero"),
            ("        return None", "Protección contra datos insuficientes"),
            ("    return sum(precios[-ventana:]) / ventana", "Cálculo y devolución en una línea"),
        ],
        "06": [
            ("import numpy as np", "Import estándar con alias corto"),
            ("precios = np.array([100, 102, 101, 105])", "array() convierte lista a vector NumPy"),
            ("rend = np.diff(precios) / precios[:-1]", "diff(): diferencias entre elementos consecutivos"),
            ("log_rend = np.log(precios[1:] / precios[:-1])", "log(): rendimientos logarítmicos aditivos"),
        ],
        "07": [
            ("df = pd.DataFrame(datos_ohlc)", "DataFrame: tabla etiquetada bidimensional"),
            ("df['fecha'] = pd.to_datetime(df['fecha'])", "Columna convertida a tipo datetime"),
            ("df['SMA_20'] = df['close'].rolling(20).mean()", "rolling().mean(): media móvil simple"),
            ("df_semanal = df.resample('W', on='fecha').agg(...)", "resample: agrupa por semana"),
        ],
        "08": [
            ("import matplotlib.pyplot as plt", "Biblioteca de visualización estándar"),
            ("plt.figure(figsize=(12,6))", "Tamaño del canvas en pulgadas"),
            ("plt.plot(df['fecha'], df['close'], c='#f7931a')", "plot(): gráfico de líneas simple"),
            ("plt.title('Precio BTC'); plt.show()", "Título y renderizado del gráfico"),
        ],
        "09": [
            ("import requests", "Librería HTTP estándar de Python"),
            ("resp = requests.get('https://api.binance.com/...')", "GET a un endpoint REST"),
            ("datos = resp.json()", "Decodifica cuerpo JSON a dict Python"),
            ("precio = float(datos['price'])", "Extrae el campo específico parseado"),
        ],
        "10": [
            ("class Estrategia:", "Palabra clave + nombre en CamelCase"),
            ("    def __init__(self, activo, stop):", "__init__: constructor de la clase"),
            ("        self.activo = activo", "self.atributo almacena en la instancia"),
            ("    def generar_senal(self, precio):", "Método que opera sobre la instancia"),
        ],
        "11": [
            ("try:", "Inicia bloque de código protegido"),
            ("    resultado = 100 / precio", "Código que PUEDE lanzar una excepción"),
            ("except ZeroDivisionError:", "Captura específica el error de división por cero"),
            ("    logger.error('División por cero')", "Registra el error estructuradamente"),
        ],
        "12": [
            ("# Proyecto final: análisis completo", "Comentario describiendo el propósito"),
            ("# 1. Cargar datos", "Divide el problema en pasos"),
            ("# 2. Calcular indicadores", "Cada paso es un bloque lógico"),
            ("# 3. Generar señales y evaluar", "El resultado final es una estrategia completa"),
        ],
    }
    return pool.get(m, [
        ("# Código de ejemplo del módulo", "Escribe código que entiendas"),
        ("# Personaliza según tu estrategia", "Cada trader tiene su estilo"),
        ("# Prueba con datos reales", "La práctica es la mejor maestra"),
        ("# Documenta cada paso", "Tu yo del futuro te lo agradecerá"),
    ])


def build_section_a(color, course_short):
    """Intuición / Diagrama conceptual"""
    rgb = hex_to_rgb(color)
    return f'''
<div class="enhance-section" style="border-left:8px solid {color}">
  <h3>🧠 Intuición conceptual</h3>
  <div style="display:flex;flex-wrap:wrap;gap:1rem;align-items:flex-start">
    <div style="flex:2;min-width:200px;font-size:0.95rem;line-height:1.6">
      <p>En trading algorítmico, <strong>{course_short}</strong> es la base que transforma datos en decisiones. Cada concepto se conecta con los demás: primero observas, luego analizas, después decides y finalmente ejecutas.</p>
      <div style="margin-top:0.8rem;padding:0.8rem;background:rgba(0,0,0,0.3);border-radius:1rem;font-size:0.85rem">
        <strong>💡 Flujo de trabajo:</strong><br>
        ❶ Datos del mercado → ❷ Análisis → ③ Decisión → ❹ Ejecución → ❺ Evaluación
      </div>
    </div>
    <div style="flex:1;min-width:140px;text-align:center;padding:1rem;background:rgba({rgb},0.1);border-radius:1.5rem;border:1px solid {color}44">
      <div style="font-size:2.2rem;margin-bottom:0.5rem">🎯</div>
      <div style="font-size:0.8rem;font-weight:600;color:{color}">Concepto clave</div>
      <div style="font-size:0.85rem;margin-top:0.3rem">{course_short}</div>
    </div>
  </div>
</div>'''


def build_section_b(color, mod, course_short):
    """Código anotado"""
    code_data = get_code_lines(mod)
    lines = []
    for code, comment in code_data:
        lines.append(f'      <span style="color:#569cd6">{code}</span>  <span style="color:#6a9955"># {comment}</span>')
    code_html = '\n'.join(lines)
    return f'''
<div class="enhance-section" style="border-left:8px solid {color}">
  <h3>💻 Código anotado</h3>
  <div style="background:#0a0f1e;border-radius:1rem;padding:0.8rem;font-family:monospace;font-size:0.82rem;border:1px solid #2c3e66;white-space:pre-wrap;overflow-x:auto;line-height:1.6">
{code_html}
  </div>
  <p style="margin-top:0.5rem;font-size:0.8rem;color:#8899bb">💡 Lee los comentarios: cada línea tiene una razón de ser. El código no se escribe, se diseña.</p>
</div>'''


def build_section_c(color, mod, course_short):
    """Mini-ejercicio con verificación"""
    q, answers = get_questions(mod)
    ans_json = ', '.join(f"'{a}'" for a in answers)
    return f'''
<div class="enhance-section" style="border-left:8px solid {color}">
  <h3>✏️ Mini-ejercicio</h3>
  <p style="font-size:0.9rem">{q}</p>
  <div style="display:flex;gap:0.5rem;flex-wrap:wrap;align-items:center">
    <input type="text" id="ex{mod}" placeholder="Tu respuesta..." style="flex:1;min-width:150px;padding:0.6rem 1rem;border-radius:2rem;border:1px solid {color}44;background:rgba(0,0,0,0.3);color:#eef5ff;font-size:0.85rem">
    <button class="btn-action" onclick="checkEx{mod}()" style="margin:0;padding:0.6rem 1.2rem;font-size:0.85rem">✅ Verificar</button>
  </div>
  <div id="ex{mod}Result" class="code-block" style="margin-top:0.5rem;font-size:0.82rem">// Responde y presiona Verificar</div>
</div>
<script>
function checkEx{mod}() {{
  var i = document.getElementById('ex{mod}').value.trim().toLowerCase();
  var r = document.getElementById('ex{mod}Result');
  var ok = [{ans_json}];
  if(ok.some(function(a) {{ return i.includes(a); }})) {{
    r.innerHTML = '<span style="color:#00ffc8">✅ Correcto! </span> Revisa el código anotado arriba para más detalles.';
  }} else {{
    r.innerHTML = '<span style="color:#ff5050">❌ Casi... </span> Revisa el bloque de código anotado de esta lección.';
  }}
}}
</script>
</div>'''


def build_section_d(color, mod, course_short):
    """Datos curiosos / trivia"""
    trivia = get_trivia(mod)
    tip = get_practical_tip(mod)
    return f'''
<div class="enhance-section" style="border-left:8px solid {color}">
  <h3>🔍 Sabías que... Curiosidades de trading</h3>
  <div style="display:flex;gap:1rem;flex-wrap:wrap">
    <div style="flex:1;min-width:200px;padding:0.8rem;background:rgba(0,0,0,0.2);border-radius:1rem;font-size:0.85rem;line-height:1.6">
      {trivia}
    </div>
    <div style="width:100%;padding:0.6rem;background:rgba(0,0,0,0.3);border-radius:0.8rem;font-size:0.8rem;display:flex;align-items:center;gap:0.5rem">
      <span style="color:#ffd700"><i class="fas fa-lightbulb"></i> Dato práctico:</span>
      <span style="color:#b9e2ff">{tip}</span>
    </div>
  </div>
</div>'''


def build_section_e(color, mod, course_short):
    """Checklist interactivo con localStorage"""
    items = get_checklist(mod)
    ck_id = f"ck{mod}"
    rows = []
    for i, item in enumerate(items):
        rows.append(f'''      <label style="display:flex;align-items:flex-start;gap:0.6rem;padding:0.3rem 0;cursor:pointer;font-size:0.85rem;border-bottom:1px solid rgba(255,255,255,0.05)">
        <input type="checkbox" id="{ck_id}_{i}" style="margin-top:3px;accent-color:{color}">
        <span>{item}</span>
      </label>''')
    checklist_rows = '\n'.join(rows)
    total_items = len(items)
    return f'''
<div class="enhance-section" style="border-left:8px solid {color}">
  <h3>📋 Checklist de aprendizaje</h3>
  <p style="font-size:0.85rem;color:#8899bb;margin-bottom:0.5rem">Marca lo que ya dominas. Tu progreso se guarda automáticamente.</p>
  <div style="background:rgba(0,0,0,0.15);padding:0.3rem 1rem;border-radius:1rem">
{checklist_rows}
  </div>
  <div style="margin-top:0.5rem;font-size:0.8rem;text-align:right;color:#8899bb">
    <span id="count{ck_id}">0</span>/{total_items} dominados
  </div>
</div>
<script>
(function(){{
  var total = {total_items};
  for (var i = 0; i < total; i++) {{
    var cb = document.getElementById('{ck_id}_'+i);
    if(cb) cb.addEventListener('change', function() {{
      var c = 0;
      for (var j = 0; j < total; j++) {{
        if(document.getElementById('{ck_id}_'+j).checked) c++;
      }}
      document.getElementById('count{ck_id}').textContent = c;
      try {{ localStorage.setItem('{mod}_checklist', c+'/'+total); }} catch(e) {{}}
    }});
  }}
}})();
</script>
</div>'''


def process_file(filepath, mod, color, cshort):
    encodings = ['utf-8', 'latin-1', 'cp1252']
    html = None
    for enc in encodings:
        try:
            with open(filepath, 'r', encoding=enc) as f:
                html = f.read()
            break
        except UnicodeDecodeError:
            continue
    if html is None:
        raise ValueError(f"Cannot decode {filepath}")

    if 'enhance-section' in html:
        return False

    # Insert section A after analogy-card
    sec_a = build_section_a(color, cshort)
    html = html.replace(
        '</div>\n<div class="main-area">',
        f'</div>\n{sec_a}\n<div class="main-area">'
    )

    # Insert sections B, C, D, E before nav-links
    sec_b = build_section_b(color, mod, cshort)
    sec_c = build_section_c(color, mod, cshort)
    sec_d = build_section_d(color, mod, cshort)
    sec_e = build_section_e(color, mod, cshort)
    
    all_bcde = f'\n{sec_b}\n{sec_c}\n{sec_d}\n{sec_e}\n'
    html = html.replace(
        '<div class="nav-links">',
        all_bcde + '<div class="nav-links">'
    )

    # Add CSS for new sections before </head>
    css = f'''
<style>
.enhance-section{{margin:1.5rem 2rem;padding:1.2rem 1.8rem;border-radius:2rem;background:rgba(20,35,60,0.6)}}
.enhance-section h3{{font-size:1.1rem;margin-bottom:0.8rem;color:{color}}}
.enhance-section .code-block{{margin-top:0.5rem;font-size:0.82rem}}
</style>'''
    html = html.replace('</head>', css + '\n</head>')

    with open(filepath, 'w', encoding='utf-8', errors='replace') as f:
        f.write(html)
    return True


def main():
    # Course definitions
    courses = [
        ("curso-1-python-financiero",   "py_trade_1_", "curso1-container", "Python financiero"),
        ("curso-2-mercados-analisis",   "py_trade_2_", "curso2-container", "análisis de mercados"),
        ("curso-3-estrategias-backtesting", "py_trade_3_", "curso3-container", "estrategias y backtesting"),
        ("curso-4-machine-learning",    "py_trade_4_", "curso4-container", "machine learning"),
        ("curso-5-ejecucion-despliegue","", "curso5-container", "ejecución y despliegue"),
        ("curso-6-avanzado",            "", "curso6-container", "trading avanzado"),
    ]

    # Module color scheme (used across all courses via module number)
    module_colors = {
        "01": "#00e0ff", "02": "#ffb347", "03": "#00ffc8", "04": "#2b9eff",
        "05": "#ff5050", "06": "#9c64ff", "07": "#ffd700", "08": "#ff64dc",
        "09": "#ffb347", "10": "#00ffc8", "11": "#ff5050", "12": "#3d7eff",
    }

    total = 0
    for folder, prefix, container, cshort in courses:
        folder_path = os.path.join(BASE, folder)
        if not os.path.isdir(folder_path):
            continue
        
        max_mod = 12
        if folder == "curso-6-avanzado":
            max_mod = 12  # All have 12 modules
            
        print(f"\n--- {folder}")
        for m_num in range(1, max_mod + 1):
            mod = f"{m_num:02d}"
            color = module_colors.get(mod, "#00e0ff")
            
            # Find file starting with module number
            for fname in sorted(os.listdir(folder_path)):
                if not fname.endswith('.html') or fname == 'index.html':
                    continue
                if fname.startswith(mod + '-'):
                    filepath = os.path.join(folder_path, fname)
                    try:
                        if process_file(filepath, mod, color, cshort):
                            total += 1
                            print(f"  ✅ {fname}")
                        else:
                            print(f"  ⏭️ {fname}")
                    except Exception as e:
                        print(f"  ❌ {fname}: {e}")
                    break
            else:
                print(f"  ⚠️  Módulo {mod} no encontrado")

    print(f"\n{'='*50}")
    print(f"Total: {total} archivos mejorados")

if __name__ == '__main__':
    main()