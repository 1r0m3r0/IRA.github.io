#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Enhance all module HTML files with self-learning sections.
Each file gets: Que aprenderas, 6 info panels, step-by-step, quiz explanations, resumen.
"""

import os, re, sys

BASE = r"D:\poryectosPulidos\PAGINA\cursos\programa-datos-fundamentos"

COLORS = {
    "curso-1-python-data-science": ("#00e0ff", "0,224,255"),
    "curso-2-estadistica": ("#ffb347", "255,179,71"),
    "curso-3-probabilidad": ("#2b9eff", "43,158,255"),
    "curso-4-visualizacion": ("#9c64ff", "156,100,255"),
    "curso-5-sql-data-science": ("#ff5050", "255,80,80"),
    "curso-6-intro-machine-learning": ("#ffd700", "255,215,0"),
}

def extract_theme(title, subtitle):
    text = (title + " " + subtitle).lower()
    checks = [
        ("entorno", r"jupyter|vscode|entorno|introducci.n"),
        ("numpy", r"numpy|arrays|vectorizacion"),
        ("pandas", r"series|dataframe|pandas[^a]"),
        ("pandas_avanzado", r"pandas avanza|merge|groupby|pivot"),
        ("archivos", r"archivos|csv|excel|parquet|json|lectura|escritura"),
        ("polars", r"polars"),
        ("duckdb", r"duckdb.*sql|sql embebido"),
        ("hibrido", r"hibrido|stack hibrido"),
        ("limpieza", r"limpieza|null|duplicados|outliers|imputacion"),
        ("feature_engineering", r"feature engineering|creacion de variables"),
        ("performance", r"performance|rendimiento|optimizacion|profiling"),
        ("etl", r"etl|extraer|transformar|cargar"),
        ("descriptiva", r"descriptiva|media.*mediana|varianza"),
        ("vis_estadistica", r"visualizacion estad|histograma|boxplot|qq"),
        ("tcl", r"teorema central|limite.*central|tcl"),
        ("intervalos", r"intervalos.*confianza"),
        ("hipotesis", r"hipotesis|prueba.*hipotesis|p.valor"),
        ("anova", r"anova"),
        ("correlacion", r"correlacion|pearson|spearman"),
        ("regresion_lineal", r"regresion lineal|ols"),
        ("regresion_logistica", r"regresion logistica|logistic"),
        ("bootstrapping", r"bootstrap"),
        ("bayesiana", r"bayesiana.*pymc|inferencia bayesiana"),
        ("prob_fundamentos", r"fundamentos.*probabilidad|axiomas|monty hall"),
        ("combinatoria", r"combinatoria|permutaciones"),
        ("discretas", r"variables discretas|bernoulli|binomial|poisson"),
        ("continuas", r"variables continuas|normal.*exponencial|gamma"),
        ("conjuntas", r"distribuciones conjuntas|conjunta marginal"),
        ("bayes_profundo", r"teorema bayes|bayes profundo"),
        ("markov", r"cadenas markov|markov.*transicion"),
        ("poisson", r"proceso poisson"),
        ("grandes_numeros", r"grandes numeros|ley de grandes"),
        ("distribuciones_ml", r"distribuciones.*ml|machine learning.*distribucion"),
        ("ab_testing", r"ab testing|testing.*ab"),
        ("matplotlib", r"matplotlib|fig.*ax.*subplots"),
        ("seaborn", r"seaborn|histplot|pairplot|heatmap"),
        ("plotly_express", r"plotly express|interactivos.*plotly|hover.*animacion"),
        ("plotly_avanzado", r"plotly avanzado|dash|mapas.*choropleth"),
        ("streamlit", r"streamlit|widgets.*caching.*deployment"),
        ("temporal", r"temporal|lineas.*velas.*timelines"),
        ("multidimensional", r"multidimensional|pca.*2d|coordenadas paralelas"),
        ("storytelling", r"storytelling|3 actos|chart junk"),
        ("dashboard", r"dashboard.*ejecutivos|kpi.*scorecards"),
        ("geoespacial", r"geoespacial|folium|kepler"),
        ("reportes", r"reportes.*pdf|jinja2|automatizados"),
        ("sql_basico", r"sql analitico|select.*where.*group.*having"),
        ("window_functions", r"window functions|row_number|rank.*lag.*lead"),
        ("cte", r"cte.*subconsultas|with.*recursivas"),
        ("joins", r"joins.*analiticos|inner.*left.*self.*anti.*lateral"),
        ("duckdb_analisis", r"duckdb.*analisis|embebido.*parquet"),
        ("postgresql", r"postgresql|jsonb.*arrays"),
        ("pgvector", r"pgvector|embeddings.*cosine.*hnsw"),
        ("window_avanzadas", r"window functions avanz|filter.*exclude"),
        ("materialized_views", r"materialized views|refresh.*vistas"),
        ("sql_feature", r"sql.*feature engineering|case.*date_trunc"),
        ("olap_oltp", r"olap.*oltp|columnar.*parquet.*arrow"),
        ("pipeline_ml", r"pipeline de ml|eda.*splits.*preprocesamiento.*evaluacion"),
        ("preprocesamiento", r"preprocesamiento|scalers.*encoders.*columntransformer"),
        ("regresion_ml", r"regresion lineal.*regularizada|ridge.*lasso.*elasticnet"),
        ("regresion_log_ml", r"regresion logistica.*frontera.*multiclase"),
        ("arboles", r"arboles.*decision|criterio.*poda.*feature.importance"),
        ("random_forest", r"random forest|bagging.*oob"),
        ("svm", r"svm.*kernels|gamma.*svr"),
        ("knn", r"knn.*distancia|k.optimo.*curse.*dimensionality"),
        ("evaluacion_modelos", r"evaluacion.*modelos|cross.val|roc.*f1.*log.loss"),
        ("hiperparametros", r"hiperparametros|gridsearch.*optuna"),
        ("shap", r"shap.*shapley|interpretacion.*summary.plot"),
    ]
    for theme, pat in checks:
        if re.search(pat, text):
            return theme
    return "generico"


def build_sections(theme, color_hex, color_rgb, badge):
    """Build all HTML sections for the given theme."""
    name = theme.replace("_", " ").title()
    
    # Que aprenderas items
    items_map = {
        "entorno": ["Configurar Jupyter Notebook y VSCode para data science", "Gestionar entornos virtuales con uv", "Crear y ejecutar tu primer notebook interactivo", "Organizar tu flujo de trabajo entre exploracion y produccion"],
        "numpy": ["Crear y manipular arrays multidimensionales", "Aplicar operaciones vectorizadas sin bucles", "Utilizar broadcasting para operaciones eficientes", "Dominar indexacion avanzada y slicing"],
        "pandas": ["Crear y manipular Series y DataFrames", "Seleccionar, filtrar y transformar datos", "Manejar indices y alineacion automatica", "Aplicar funciones por filas y columnas"],
        "sql_basico": ["Escribir consultas SELECT con filtros WHERE", "Agrupar datos con GROUP BY y agregaciones", "Filtrar grupos con HAVING", "Ordenar resultados con ORDER BY y LIMIT"],
        "pipeline_ml": ["Disenar un pipeline completo de Machine Learning", "Realizar EDA para entender las variables", "Dividir datos en train, validation y test", "Evaluar modelos con metricas adecuadas"],
        "matplotlib": ["Comprender la anatomia de una figura Matplotlib", "Crear subplots y personalizar ejes", "Aplicar estilos, colores y tipografia", "Guardar figuras en alta calidad"],
    }
    items = items_map.get(theme, [
        "Comprender los conceptos fundamentales del modulo",
        "Aplicar tecnicas con ejemplos practicos reales",
        "Resolver problemas mediante ejercicios guiados paso a paso",
        "Evaluar tu comprension con cuestionarios interactivos"
    ])
    
    # Info panels (same structure, themed title)
    panels_intro = [
        f"Dominar {name} es como construir los cimientos de una casa: sin una base solida, todo lo demas se derrumba. Cada concepto que aprendas sera un ladrillo mas en tu construccion como cientifico de datos. La clave esta en entender el 'por que' detras de cada tecnica, no solo el 'como'.",
        f"La preparacion de datos es como lavar y cortar ingredientes antes de cocinar. Por muy buena que sea tu receta, si los ingredientes estan sucios, el plato final sera decepcionante. Esta fase consume el 60-80% del tiempo en proyectos de datos y determina la calidad de los resultados.",
        f"La teoria sin practica es como tener la receta pero nunca cocinar. Las aplicaciones reales aparecen en finanzas, salud, marketing y cualquier industria que genere datos. Cada caso requiere adaptar los fundamentos al contexto especifico del negocio.",
        f"Optimizar codigo es como ajustar un motor: no necesitas maxima velocidad siempre, pero con millones de registros cada milisegundo cuenta. La clave es medir antes de optimizar y enfocarse en los cuellos de botella reales.",
        f"Los mejores cientificos de datos no son los que mas algoritmos conocen, sino los que saben aplicar las herramientas correctas al problema correcto. Netflix, Amazon y Spotify usan los mismos fundamentos que aprendes aqui, escalados a millones de usuarios.",
        f"Depurar errores es parte natural del proceso, no una senal de fracaso. Los errores mas comunes incluyen problemas de tipos de datos, valores nulos inesperados e indexacion incorrecta. Cada error es una oportunidad de aprendizaje."
    ]
    
    panels = []
    titles = [
        f"Conceptos Fundamentales de {name}",
        f"Preparacion de Datos en {name}",
        f"Aplicaciones Practicas de {name}",
        f"Optimizacion y Rendimiento en {name}",
        f"Casos de Uso Reales de {name}",
        f"Errores Tipicos y Depuracion en {name}"
    ]
    
    # Code snippets per panel
    code_snips = [
        "Comienza importando las bibliotecas necesarias para el modulo. Carga tus datos con la funcion apropiada. Explora la estructura con .info(), .describe() y .head(). Identifica tipos de datos y valores nulos antes de cualquier transformacion.",
        "Operaciones tipicas: df.dropna() para eliminar nulos, df.fillna(valor) para imputar, pd.to_datetime() para fechas, df.astype() para tipos. Crea una pipeline de limpieza con funciones modulares reutilizables.",
        "Identifica primero el tipo de problema: analisis, clasificacion, regresion o visualizacion. Selecciona la herramienta adecuada. Estructura: cargar, explorar, preparar, transformar, validar, documentar. Sin atajos para resultados de calidad.",
        "Mide con %timeit o time.perf_counter(). Luego optimiza: prefiere operaciones vectorizadas sobre bucles, elige el tipo de dato mas pequeno posible, usa indices y filtros eficientes.",
        "Sigue el marco estructurado: comprension del problema, exploracion de datos, preparacion, aplicacion, validacion y documentacion. Cada ciclo de iteracion refina y mejora los resultados anteriores.",
        "Usa try/except para errores esperados, assert para validar supuestos y logging para seguimiento. No ignores warnings. Prueba con datos limite: vacios, extremos o con valores nulos."
    ]
    
    examples = [
        "Tienes un dataset de ventas mensuales. Descubres fechas en formato texto y valores nulos en 'precio'. Aplicas las tecnicas del modulo: conviertes fechas a datetime, imputas nulos, y verificas consistencia antes de continuar con el analisis.",
        "Un dataset de clientes tiene edades negativas y salarios con formato incorrecto. Limpias: edades con .abs(), salarios con .str.replace().astype(float), y validas rangos logicos. Todo documentado para reproducibilidad.",
        "En marketing: segmentar clientes por comportamiento. En finanzas: predecir tendencias. En salud: clasificar diagnosticos. La metodologia es la misma, cambian los datos y los objetivos de negocio.",
        "Un bucle que procesa 1M de filas toma 45 segundos. Con operaciones vectorizadas, el mismo calculo toma 0.3 segundos. Con paralelizacion, baja a 0.1 segundos. La diferencia entre codigo amateur y profesional.",
        "Netflix usa recomendaciones personalizadas ahorrando $1B anual. Amazon optimiza su cadena de suministro. Spotify genera discover weekly. Todas usan los mismos fundamentos adaptados a su dominio.",
        "ValueError: cannot convert float NaN to integer. Ocurre al convertir columna con nulos a entero. Solucion: imputa antes con fillna(0).astype(int). Otro comun: KeyError por columna que no existe."
    ]
    
    pitfalls = [
        "Error comun: saltar la exploracion inicial y asumir datos limpios. Otro: no verificar tipos despues de transformaciones. Clave: mantener copia de datos originales antes de modificar.",
        "Error comun: modificar datos sin backup. Otro: asumir formatos consistentes entre columnas. Clave: documentar cada transformacion y su justificacion para reproducibilidad.",
        "Error comun: elegir el metodo mas complejo sin probar primero los simples. Otro: no alinear resultados con objetivos. Clave: validar resultados con conocimiento de dominio.",
        "Optimizar prematuramente sin identificar cuellos de botella reales. No sacrificar legibilidad por micro-optimizaciones. Recordar que la optimizacion cambia segun el volumen de datos.",
        "Error comun: enfocarse solo en lo tecnico y olvidar el impacto de negocio. Otro: no comunicar resultados claramente. Clave: un analisis excelente que nadie entiende no genera valor.",
        "Ignorar warnings porque 'no pasa nada' hasta que produce resultados incorrectos. No probar con datos limite. Asumir que funciona igual con datos grandes que con pequenos."
    ]
    
    for i in range(6):
        panels.append(f"""<div class="info-panel">
<div class="info-panel-header" onclick="togglePanel(this)"><span class="arrow">&#9654;</span> {titles[i]}</div>
<div class="info-panel-body">
<span class="label">Intuicion</span>
<p>{panels_intro[i]}</p>
<span class="label">Codigo paso a paso</span>
<div class="code-snip">{code_snips[i]}</div>
<span class="label">Ejemplo practico</span>
<p>{examples[i]}</p>
<span class="label">Errores comunes</span>
<p>{pitfalls[i]}</p>
</div>
</div>""")
    
    panels_html = "\n".join(panels)
    
    # Step by step
    steps = [
        ("Paso 1: Importar y cargar datos", "Importa las bibliotecas esenciales y carga tu dataset. Verifica con .head() y .info(). Identifica el tamano, columnas disponibles y tipos de datos de cada variable."),
        ("Paso 2: Exploracion y analisis inicial", "Realiza un analisis exploratorio: estadisticas con .describe(), valores nulos con .isnull().sum(), distribuciones con histogramas. Esto te da una comprension inicial de tus datos."),
        ("Paso 3: Transformacion de datos", "Aplica las transformaciones necesarias segun los conceptos del modulo. Verifica los resultados parciales despues de cada paso importante. Manten la trazabilidad de cambios."),
        ("Paso 4: Validacion de resultados", "Comprueba que los resultados sean correctos y consistentes. Compara con valores esperados. Usa graficos para validar visualmente que las transformaciones tengan sentido logico."),
        ("Paso 5: Documentacion y conclusiones", "Documenta los pasos realizados, decisiones tomadas y hallazgos principales. Guarda los resultados procesados para usarlos en modulos posteriores. Comparte tus descubrimientos.")
    ]
    steps_html = "\n".join([f"""<div class="step-item">
<div class="step-num">&#10003;</div>
<div class="step-content"><strong>{t}</strong><p>{d}</p></div>
</div>""" for t, d in steps])
    
    step_code = """# --- Ejemplo completo ---
import pandas as pd
import numpy as np

# Cargar datos
df = pd.read_csv('datos.csv')
print(f'Dimensiones: {df.shape}')

# Exploracion
print(df.info())
print(df.describe())

# Transformacion
df = df.dropna(subset=['columna_importante'])
df['fecha'] = pd.to_datetime(df['fecha'])

# Validacion
assert df['columna_importante'].notna().all(), 'Hay nulos residuales'
print('Procesamiento completado exitosamente')"""
    
    # Summary
    summary = f"Has dominado los conceptos fundamentales de {name}. Cada tecnica y herramienta aprendida es un componente esencial en tu caja de herramientas de ciencia de datos. La insignia {badge} es testimonio de tu dedicacion y esfuerzo. Recuerda que la practica constante es la clave para convertir el conocimiento en habilidad duradera."
    
    return items, panels_html, steps_html, step_code, summary


def enhance_file(filepath):
    with open(filepath, "r", encoding="utf-8", errors="replace") as f:
        content = f.read()

    fname = os.path.basename(filepath)
    print(f"Processing: {fname}")
    
    rel = os.path.relpath(filepath, BASE)
    course_slug = rel.split(os.sep)[0]
    color_hex, color_rgb = COLORS.get(course_slug, ("#00e0ff", "0,224,255"))
    pattern = "A" if course_slug in ["curso-1-python-data-science", "curso-2-estadistica", "curso-3-probabilidad"] else "B"
    
    # Extract title
    title_m = re.search(r'<h1[^>]*>(.*?)</h1>', content, re.DOTALL)
    title = title_m.group(1).strip() if title_m else fname
    
    # Extract subtitle
    subtitle = ""
    st_m = re.search(r'<h1[^>]*>.*?</h1>\s*<p[^>]*>(.*?)</p>', content, re.DOTALL)
    if st_m: subtitle = st_m.group(1).strip()
    
    # Extract module number
    mod_num = 1
    mn = re.search(r'Modulo (\d+)', content)
    if mn: mod_num = int(mn.group(1))
    else:
        fn_m = re.match(r'0?(\d+)', fname)
        if fn_m: mod_num = int(fn_m.group(1))
    
    # Extract total
    total = 12
    tm = re.search(r'(?:TOTAL|total)\s*=\s*(\d+)', content)
    if tm: total = int(tm.group(1))
    
    # Extract badge
    badge = "Logro desbloqueado"
    if pattern == "A":
        ins_m = re.search(r'<div id="insigniaArea"[^>]*>.*?<h3[^>]*>(.*?)</h3>', content, re.DOTALL)
    else:
        ins_m = re.search(r'<div id="insignia"[^>]*>.*?<h3[^>]*>(.*?)</h3>', content, re.DOTALL)
    if ins_m:
        badge = re.sub(r'<[^>]+>', '', ins_m.group(1)).strip()
    
    # Extract questions
    questions = []
    if pattern == "A":
        qs_m = re.search(r'(?:const\s+questions|const\s+qs)\s*=\s*\[(.*?)\];', content, re.DOTALL)
    else:
        qs_m = re.search(r"const\s+questions\s*=\s*\[(.*?)\];", content, re.DOTALL)
    if qs_m:
        q_blocks = re.findall(r'\{(.*?)\}', qs_m.group(1), re.DOTALL)
        for qb in q_blocks:
            tm_q = re.search(r'(?:text|q)\s*[=:]\s*"([^"]*)"', qb)
            om_q = re.search(r'(?:options|opts)\s*[=:]\s*\[([^\]]*)\]', qb)
            am_q = re.search(r'(?:correct|a)\s*[=:]\s*(\d+)', qb)
            if tm_q:
                q_obj = {"text": tm_q.group(1)}
                if om_q: q_obj["options"] = re.findall(r'"([^"]*)"', om_q.group(1))
                if am_q: q_obj["correct"] = int(am_q.group(1))
                questions.append(q_obj)
    
    theme = extract_theme(title, subtitle)
    items, panels_html, steps_html, step_code, summary_text = build_sections(theme, color_hex, color_rgb, badge)
    
    # ---- CSS ----
    new_css = f"""
.info-panel{{background:rgba({color_rgb},0.06);border-radius:1.2rem;margin:0.6rem 0;overflow:hidden;border:1px solid rgba({color_rgb},0.12);transition:0.2s;}}
.info-panel:hover{{border-color:{color_hex};box-shadow:0 0 8px rgba({color_rgb},0.1);}}
.info-panel-header{{padding:1rem 1.2rem;cursor:pointer;display:flex;align-items:center;gap:0.8rem;font-weight:600;font-size:1rem;user-select:none;background:rgba({color_rgb},0.03);}}
.info-panel-header:hover{{background:rgba({color_rgb},0.08);}}
.info-panel-header .arrow{{transition:transform 0.3s ease;font-size:0.8rem;}}
.info-panel-header.active .arrow{{transform:rotate(90deg);}}
.info-panel-body{{padding:0 1.2rem 1.2rem;display:none;}}
.info-panel-body.open{{display:block;animation:fadeSlide 0.3s ease;}}
.info-panel-body p{{margin-bottom:0.7rem;line-height:1.6;font-size:0.9rem;color:#c8d0e0;}}
.info-panel-body .code-snip{{background:#0d1520;border-radius:0.6rem;padding:0.6rem 1rem;font-family:'Courier New',monospace;font-size:0.8rem;border:1px solid rgba({color_rgb},0.15);margin:0.5rem 0;white-space:pre-wrap;overflow-x:auto;color:#b8d4ff;}}
.info-panel-body .label{{font-weight:700;color:{color_hex};font-size:0.75rem;text-transform:uppercase;letter-spacing:1px;margin-top:0.5rem;display:block;}}
.step-section{{background:rgba({color_rgb},0.04);border-radius:1.5rem;padding:1.5rem;margin:1.5rem 0;border:1px solid rgba({color_rgb},0.15);}}
.step-item{{display:flex;gap:1rem;margin-bottom:1rem;align-items:flex-start;}}
.step-num{{background:{color_hex};color:#000;min-width:32px;height:32px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-weight:800;font-size:0.8rem;flex-shrink:0;}}
.step-content{{flex:1;}}
.step-content strong{{display:block;font-size:0.95rem;margin-bottom:0.2rem;}}
.step-content p{{font-size:0.85rem;color:#b0c0d8;line-height:1.5;}}
.step-code{{background:#0d1520;border-radius:0.8rem;padding:1rem;font-family:'Courier New',monospace;font-size:0.82rem;border:1px solid rgba({color_rgb},0.12);margin:1rem 0;white-space:pre-wrap;overflow-x:auto;}}
.learning-section{{background:rgba({color_rgb},0.04);border-radius:1.5rem;padding:1.5rem;margin:1.5rem 0;border-left:4px solid {color_hex};}}
.learning-item{{display:flex;gap:0.8rem;align-items:flex-start;margin-bottom:0.8rem;}}
.learning-item i{{color:{color_hex};font-size:1.1rem;margin-top:0.15rem;min-width:20px;}}
.learning-item span{{font-size:0.9rem;color:#c8d8ee;line-height:1.4;}}
.explanation-item{{background:rgba(0,0,0,0.2);border-radius:0.8rem;padding:0.8rem 1rem;margin:0.5rem 0;font-size:0.85rem;line-height:1.5;border-left:3px solid {color_hex};}}
.explanation-item.correct{{border-left-color:#00cc88;}}
.explanation-item.wrong{{border-left-color:#ff4455;}}
.resumen-card{{background:linear-gradient(135deg,rgba({color_rgb},0.08),rgba({color_rgb},0.02));border-radius:1.5rem;padding:1.5rem;margin:1.5rem 0;border:1px solid {color_hex};}}
.resumen-card h3{{color:{color_hex};margin-bottom:1rem;font-size:1.2rem;}}
.resumen-card p{{font-size:0.9rem;line-height:1.7;color:#c8d8ee;}}
.resumen-card .key-points{{display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:0.8rem;margin-top:1rem;}}
.resumen-card .key-point{{background:rgba(0,0,0,0.2);border-radius:0.8rem;padding:0.8rem;border:1px solid rgba({color_rgb},0.1);}}
.resumen-card .key-point i{{color:{color_hex};margin-right:0.5rem;}}
@keyframes fadeSlide{{from{{opacity:0;transform:translateY(-8px);}}to{{opacity:1;transform:translateY(0);}}}}
.que-aprenderas{{background:rgba({color_rgb},0.05);border-radius:1.5rem;padding:1.5rem;margin:1.5rem 0;border-left:4px solid {color_hex};}}
.que-aprenderas h3{{color:{color_hex};margin-bottom:1rem;font-size:1.1rem;}}
"""
    
    # ---- HTML SECTIONS ----
    
    # Que aprenderas
    items_html = "\n".join([f"""<div class="learning-item"><i class="fas fa-check-circle"></i><span>{it}</span></div>""" for it in items])
    qa_html = f"""<div class="que-aprenderas">
<h3><i class="fas fa-bullseye"></i> Que aprenderas en este modulo</h3>
{items_html}
</div>"""
    
    # Info panels wrapper
    info_wrapper = f"""<div class="info-panels">
<h3 style="color:{color_hex};font-size:1.2rem;margin-bottom:1rem;"><i class="fas fa-book-open"></i> Contenido del Modulo</h3>
{panels_html}
</div>"""
    
    # Step by step
    step_full = f"""<div class="step-section">
<h3 style="color:{color_hex};margin-bottom:1rem;font-size:1.15rem;"><i class="fas fa-list-ol"></i> Ejemplo Practico: Aplicacion de {theme.replace('_',' ').title()}</h3>
{steps_html}
<div class="step-code">{step_code}</div>
</div>"""
    
    # Summary
    summary_html = f"""<div class="resumen-card">
<h3><i class="fas fa-graduation-cap"></i> Resumen del Modulo</h3>
<p>{summary_text}</p>
<div class="key-points">
<div class="key-point"><i class="fas fa-check-circle"></i> Has completado el modulo {mod_num} de {total}: {theme.replace('_',' ').title()}</div>
<div class="key-point"><i class="fas fa-check-circle"></i> Practica con datasets reales para consolidar los conceptos</div>
<div class="key-point"><i class="fas fa-check-circle"></i> Experimenta variando parametros para entender su efecto</div>
<div class="key-point"><i class="fas fa-check-circle"></i> Documenta tus aprendizajes y compartelos con la comunidad</div>
</div>
</div>"""
    
    # Explanations
    expl_parts = []
    for ei, q in enumerate(questions):
        qtext = q.get("text", "")
        opts = q.get("options", [])
        correct_idx = q.get("correct", 0)
        expl_parts.append(f"""<div id="expl-{ei}" class="explanation-section" style="display:none;">
<p style="font-weight:600;font-size:0.9rem;margin-bottom:0.5rem;color:#eef5ff;">{qtext}</p>""")
        for ej in range(len(opts)):
            if ej < len(opts):
                cls = "correct" if ej == correct_idx else "wrong"
                expl_parts.append(f"""<div class="explanation-item {cls}">{(opts[ej] if ej < len(opts) else '')}: Respuesta {'correcta' if ej == correct_idx else 'incorrecta'}. Revisa el material del modulo para afianzar este concepto.</div>""")
        expl_parts.append("</div>")
    expl_html = "\n".join(expl_parts)
    
    toggle_js = "\nfunction togglePanel(h){h.classList.toggle('active');var b=h.nextElementSibling;b.classList.toggle('open');}\n"
    
    # ---- INJECTION ----
    
    # 1. CSS at end of <style>
    style_end = content.rfind("</style>")
    if style_end != -1:
        content = content[:style_end] + new_css + content[style_end:]
    
    # 2. Que aprenderas after analogy card
    analogy_end = content.find("</div>", content.find('<div class="analogy-card"'))
    if analogy_end != -1:
        analogy_end = content.find("</div>", analogy_end + 5) + 6
        content = content[:analogy_end] + "\n" + qa_html + "\n" + content[analogy_end:]
    
    # 3. Info panels before interactive/section-title
    if pattern == "A":
        marker = '<div class="section-title"'
    else:
        marker = '<div class="interactive-area"'
    pos = content.find(marker, content.find("que-aprenderas") if "que-aprenderas" in content else 0)
    if pos != -1:
        content = content[:pos] + "\n" + info_wrapper + "\n" + content[pos:]
    
    # 4. Step by step before quiz
    marker2 = '<div class="quiz-area"'
    pos2 = content.find(marker2, content.find("info-panels") if "info-panels" in content else 0)
    if pos2 != -1:
        content = content[:pos2] + "\n" + step_full + "\n" + content[pos2:]
    
    # 5. Explanations after feedback
    fb_id = 'id="feedbackMsg"' if pattern == "A" else 'id="feedback"'
    pos3 = content.find(fb_id)
    if pos3 != -1:
        end3 = content.find("</div>", pos3) + 6
        content = content[:end3] + "\n" + expl_html + "\n" + content[end3:]
    
    # 6. Toggle JS before last </script>
    script_pos = content.rfind("</script>", 0, content.rfind("</script>") - 5)
    last_script_close = content.rfind("</script>")
    insert_pos = content.rfind("<script", 0, last_script_close - 5)
    if insert_pos != -1:
        # Find the closing of the second-to-last script tag
        close_pos = content.find("</script>", insert_pos) + 9
        content = content[:close_pos] + toggle_js + content[close_pos:]
    
    # 7. Add explanation display to handleSubmit/checkQuiz
    if pattern == "A":
        # Add expl display logic into handleSubmit
        old_hs = "function handleSubmit"
        hs_start = content.find(old_hs)
        if hs_start != -1:
            # Find the var correct line
            var_correct = content.find("var correct=answers.filter", hs_start) or content.find("const correct=answers.filter", hs_start)
            if var_correct != -1:
                # Insert expl display before the correct count
                expl_display_js = "document.querySelectorAll('.question').forEach(function(d,i){var expl=document.getElementById('expl-'+i);if(expl)expl.style.display='block';});"
                # Find the line that calculates correct
                content = content[:var_correct] + expl_display_js + content[var_correct:]
    else:
        # Pattern B: modify checkQuiz to show explanations
        old_cq = "function checkQuiz"
        cq_start = content.find(old_cq)
        if cq_start != -1:
            # Insert after the opening brace
            brace_pos = content.find("{", cq_start)
            if brace_pos != -1:
                expl_js_cq = "document.querySelectorAll('.explanation-section').forEach(function(e){e.style.display='block';});"
                content = content[:brace_pos+1] + expl_js_cq + content[brace_pos+1:]
    
    # 8. Summary after insignia before nav/button
    if pattern == "A":
        nav_start = content.find('<div class="nav-links"')
        if nav_start != -1:
            content = content[:nav_start] + summary_html + "\n" + content[nav_start:]
    else:
        btn_next = content.find('class="btn-next"')
        if btn_next != -1:
            # Find the button end
            btn_end = content.find("</button>", btn_next) + 9
            content = content[:btn_end] + "\n" + summary_html + "\n" + content[btn_end:]
        else:
            # Try before footer
            footer_pos = content.find("<footer")
            if footer_pos != -1:
                content = content[:footer_pos] + summary_html + "\n" + content[footer_pos:]
    
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(content)
    
    print(f"  + DONE Enhanced: {fname}")


def main():
    courses = sorted([d for d in os.listdir(BASE) if os.path.isdir(os.path.join(BASE, d)) and d.startswith("curso-")])
    total = 0
    for course in courses:
        cpath = os.path.join(BASE, course)
        files = sorted([f for f in os.listdir(cpath) if f.endswith(".html") and f != "index.html"])
        for fname in files:
            fpath = os.path.join(cpath, fname)
            try:
                enhance_file(fpath)
                total += 1
            except Exception as e:
                print(f"  ERROR in {fname}: {str(e)}")
    print(f"\n+ DONE Completed {total} files enhanced!")


if __name__ == "__main__":
    main()
