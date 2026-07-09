#!/usr/bin/env python3
"""Enhance all remaining unenhanced lesson files with ¿Qué aprenderás?, panels, paso a paso, quiz explanations, resumen."""

import os
import re
import json

BASE = r"D:\poryectosPulidos\PAGINA\cursos\programa-sql-avanzado"

# Map of course -> (color, accent1, accent2, style_type, progress_offset)
COURSE_META = {
    "curso-3-fulltext-search":  ("00e0ff", "00e0ff", "00b8d4", "styleA", 24),
    "curso-4-replicacion-backup": ("00cc6a", "00cc6a", "88ffbb", "styleB", 36),
    "curso-5-seguridad":       ("ffb347", "ffb347", "ffdd88", "styleB", 48),
    "curso-6-sql-moderno":     ("ff64dc", "ff64dc", "ff88ee", "styleB", 60),
}

# ── Content generators per module ──────────────────────────────────────────

KNOWN_MODULES = {}

def load_all_content():
    """Build content lookup from file titles and descriptions."""
    d = {}
    # We load this from the files themselves by scanning
    return d

# ── Helper: extract info from file ──────────────────────────────────────────

def extract_info(filepath, content):
    """Extract course dir, module num, title, desc from file."""
    # Determine course dir
    parts = filepath.replace(BASE, "").lstrip("\\/").split(os.sep)
    course_dir = parts[0] if len(parts) > 1 else None
    filename = os.path.basename(filepath)
    
    # Extract module number from filename
    m = re.search(r'(\d+)', filename)
    module_num = int(m.group(1)) if m else 0
    
    # Extract title from <title> tag
    title_m = re.search(r'<title>(.*?)</title>', content, re.DOTALL)
    title = title_m.group(1).strip() if title_m else filename
    
    # Extract description from hero header p
    desc_m = re.search(r'<p>(.*?)</p>', content[content.find('<div class="hero-header"'):] if 'hero-header' in content else content[content.find('<div class="hero"'):])
    # Try harder
    desc = ""
    if 'hero-header' in content:
        m2 = re.search(r'<div class="hero-header">.*?<h1>.*?</h1>\s*<p>(.*?)</p>', content, re.DOTALL)
        if m2: desc = m2.group(1)
    if not desc and 'hero' in content:
        m2 = re.search(r'<div class="hero">.*?<h1>.*?</h1>\s*<p>(.*?)</p>', content, re.DOTALL)
        if m2: desc = m2.group(1)
    
    # Extract h1 from hero
    h1_m = re.search(r'<h1>(.*?)</h1>', content)
    h1 = h1_m.group(1).strip() if h1_m else title
    
    return course_dir, module_num, title, desc, h1

def make_slug(h1):
    """Make a slug from h1 for ID usage."""
    s = h1.lower().replace("í","i").replace("ó","o").replace("á","a").replace("é","e").replace("ú","u").replace("ñ","n")
    s = re.sub(r'[^a-z0-9]+', '-', s).strip('-')
    return s[:30]

# ── Style A enhancements (for curso 3, same as curso 1) ─────────────────────

STYLE_A_CSS = """
.aprender-section{background:rgba(COLOR,0.05);border:1px solid rgba(COLOR,0.15);border-radius:12px;padding:16px 20px;margin:20px 0}
.aprender-section h3{color:#COLOR;font-size:1rem;margin-bottom:8px}
.aprender-section ul{list-style:none;padding:0}
.aprender-section ul li{padding:4px 0;font-size:.85rem;color:#bcc;line-height:1.5}
.aprender-section ul li i{color:#COLOR;width:20px;margin-right:6px}
.panel-grid{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin:20px 0}
.panel-card{background:rgba(255,255,255,0.03);border:1px solid rgba(255,255,255,0.08);border-radius:12px;padding:16px;transition:.3s}
.panel-card:hover{border-color:rgba(COLOR,0.3);transform:translateY(-2px)}
.panel-card h4{color:#COLOR;font-size:.9rem;margin-bottom:6px}
.panel-card p{color:#8899aa;font-size:.82rem;line-height:1.5;margin-bottom:6px}
.panel-card .sql-example{background:rgba(0,0,0,0.3);border-radius:6px;padding:8px;font-family:monospace;font-size:.78rem;color:#bcc;margin:6px 0;overflow-x:auto}
.panel-card .pitfall{color:#COLOR;font-size:.78rem;margin-top:4px;padding:4px 8px;background:rgba(COLOR,0.1);border-radius:6px;display:inline-block}
.paso-paso{background:rgba(255,255,255,0.03);border:1px solid rgba(COLOR,0.15);border-radius:12px;padding:20px;margin:20px 0}
.paso-paso h3{color:#COLOR;font-size:1rem;margin-bottom:12px}
.paso-paso .step{display:flex;gap:12px;margin:10px 0;padding:10px 14px;background:rgba(255,255,255,0.02);border-radius:8px;border-left:3px solid rgba(COLOR,0.3)}
.paso-paso .step .snum{color:#COLOR;font-weight:700;font-size:.9rem;min-width:24px}
.paso-paso .step .scontent{flex:1}
.paso-paso .step .scontent p{color:#bcc;font-size:.85rem;line-height:1.5}
.paso-paso .step .scontent .scode{background:rgba(0,0,0,0.3);border-radius:6px;padding:8px;font-family:monospace;font-size:.8rem;color:#COLOR;margin:6px 0;overflow-x:auto}
.quiz-option{display:block;width:100%;padding:14px 18px;margin:8px 0;background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.1);border-radius:12px;color:#e8edee;font-size:.9rem;font-family:'Inter',sans-serif;cursor:pointer;transition:all .25s;text-align:left}
.quiz-option:hover{background:rgba(COLOR,0.1);border-color:#COLOR}
.quiz-option.correct{background:rgba(0,255,100,0.15);border-color:#00ff64}
.quiz-option.wrong{background:rgba(255,80,80,0.15);border-color:#ff5050}
.quiz-explain{background:rgba(255,255,255,0.02);border-radius:8px;padding:10px 14px;margin:6px 0;font-size:.82rem;color:#8899aa;line-height:1.5;border-left:3px solid rgba(COLOR,0.2)}
.resumen-modulo{background:rgba(COLOR,0.05);border:1px solid rgba(COLOR,0.15);border-radius:12px;padding:20px;margin:20px 0}
.resumen-modulo h3{color:#COLOR;font-size:1rem;margin-bottom:10px}
.resumen-modulo ul{list-style:none;padding:0}
.resumen-modulo ul li{padding:5px 0;font-size:.85rem;color:#bcc;line-height:1.5}
.resumen-modulo ul li i{color:#COLOR;width:20px;margin-right:6px}
"""

# ── Style B enhancements (for cursos 4, 5, 6) ─────────────────────────────

STYLE_B_CSS = """
.aprender-section{background:rgba(COLOR,0.08);margin:1.5rem 2rem;padding:1.2rem 1.5rem;border-radius:1.5rem;border-left:5px solid #COLOR}
.aprender-section h3{color:#COLOR;font-size:1.1rem;margin-bottom:0.8rem}
.aprender-section ul{list-style:none;padding:0}
.aprender-section ul li{padding:0.35rem 0;font-size:0.85rem;color:#b9ccee;line-height:1.5}
.aprender-section ul li i{color:#COLOR;width:20px;margin-right:8px}
.panel-grid{display:grid;grid-template-columns:1fr 1fr;gap:1rem;margin:1.5rem 2rem}
.panel-card{background:rgba(0,0,0,0.3);border-radius:1.5rem;padding:1.2rem 1.5rem;border:1px solid #2c3e66;transition:.3s}
.panel-card:hover{border-color:rgba(COLOR,0.3);transform:translateY(-2px)}
.panel-card h4{color:#COLOR;font-size:0.95rem;margin-bottom:0.5rem}
.panel-card p{color:#8899bb;font-size:0.8rem;line-height:1.5;margin-bottom:0.5rem}
.panel-card .sql-example{background:#0a0f1e;border-radius:1rem;padding:0.6rem 0.8rem;font-family:monospace;font-size:0.75rem;color:#b9ccee;margin:0.5rem 0;overflow-x:auto;border:1px solid #2c3e66}
.panel-card .pitfall{color:#COLOR;font-size:0.75rem;margin-top:0.3rem;padding:0.3rem 0.6rem;background:rgba(COLOR,0.12);border-radius:0.8rem;display:inline-block}
.paso-paso{background:rgba(0,0,0,0.2);margin:1.5rem 2rem;padding:1.2rem 1.5rem;border-radius:1.5rem;border:1px solid rgba(COLOR,0.2)}
.paso-paso h3{color:#COLOR;font-size:1.05rem;margin-bottom:0.8rem}
.paso-paso .step{display:flex;gap:0.8rem;margin:0.6rem 0;padding:0.7rem 1rem;background:rgba(255,255,255,0.03);border-radius:1rem;border-left:3px solid rgba(COLOR,0.3)}
.paso-paso .step .snum{color:#COLOR;font-weight:700;font-size:0.9rem;min-width:24px}
.paso-paso .step .scontent{flex:1}
.paso-paso .step .scontent p{color:#b9ccee;font-size:0.82rem;line-height:1.5}
.paso-paso .step .scontent .scode{background:#0a0f1e;border-radius:0.8rem;padding:0.5rem 0.7rem;font-family:monospace;font-size:0.78rem;color:#COLOR;margin:0.4rem 0;overflow-x:auto;border:1px solid #2c3e66}
.quiz-option{display:block;width:100%;padding:0.9rem 1.2rem;margin:0.5rem 0;background:rgba(0,0,0,0.4);border:1px solid #2c3e66;border-radius:1.2rem;color:#eef5ff;font-size:0.9rem;font-family:'Inter',sans-serif;cursor:pointer;transition:all .25s;text-align:left}
.quiz-option:hover{background:rgba(COLOR,0.1);border-color:#COLOR}
.quiz-option.correct{background:rgba(0,255,100,0.15);border-color:#00ff64}
.quiz-option.wrong{background:rgba(255,80,80,0.15);border-color:#ff5050}
.quiz-explain{background:rgba(255,255,255,0.02);border-radius:0.8rem;padding:0.5rem 0.8rem;margin:0.4rem 0;font-size:0.8rem;color:#8899bb;line-height:1.5;border-left:3px solid rgba(COLOR,0.2)}
.resumen-modulo{background:rgba(COLOR,0.06);margin:1.5rem 2rem;padding:1.2rem 1.5rem;border-radius:1.5rem;border:1px solid rgba(COLOR,0.2)}
.resumen-modulo h3{color:#COLOR;font-size:1rem;margin-bottom:0.8rem}
.resumen-modulo ul{list-style:none;padding:0}
.resumen-modulo ul li{padding:0.35rem 0;font-size:0.82rem;color:#b9ccee;line-height:1.5}
.resumen-modulo ul li i{color:#COLOR;width:20px;margin-right:8px}
@media(max-width:700px){.panel-grid{grid-template-columns:1fr}.aprender-section{margin:1rem}.panel-grid{margin:1rem}.paso-paso{margin:1rem}.resumen-modulo{margin:1rem}}
"""

# ── Course-specific content ─────────────────────────────────────────────────

# For each file, define: aprender_items, panels, pasos, quiz_data, resumen_items
# We key by (course_dir, filename_without_ext)

CONTENT = {}

def make_content_key(course_dir, filename):
    key = os.path.join(course_dir, filename.replace(".html", ""))
    return key

# ── Helper to build aprender section HTML ───────────────────────────────────

def build_aprender(items):
    lis = "".join(f'<li><i class="fas fa-check-circle"></i> {item}</li>' for item in items)
    return f'<div class="aprender-section"><h3><i class="fas fa-graduation-cap"></i> ¿Qué aprenderás?</h3><ul>{lis}</ul></div>'

def build_panels(panels, color):
    cards = ""
    for p in panels:
        cards += f'<div class="panel-card"><h4>{p["title"]}</h4><p>{p["desc"]}</p>'
        if "sql" in p:
            cards += f'<div class="sql-example">{p["sql"]}</div>'
        if "tip" in p:
            cards += f'<span class="pitfall">⚠ {p["tip"]}</span>'
        cards += "</div>"
    return f'<div class="panel-grid">{cards}</div>'

def build_pasos(pasos, color):
    steps = ""
    for i, s in enumerate(pasos, 1):
        steps += f'<div class="step"><div class="snum">{i}</div><div class="scontent"><p>{s["text"]}</p>'
        if "code" in s:
            steps += f'<div class="scode">{s["code"]}</div>'
        steps += '</div></div>'
    return f'<div class="paso-paso"><h3><i class="fas fa-code"></i> Ejemplo paso a paso</h3>{steps}</div>'

def build_resumen(items):
    lis = "".join(f'<li><i class="fas fa-check"></i> {item}</li>' for item in items)
    return f'<div class="resumen-modulo"><h3><i class="fas fa-clipboard-list"></i> Resumen del módulo</h3><ul>{lis}</ul></div>'

def build_quiz_html(qdata, color):
    """qdata = {question, options: [{label, text, correct, explain}], reveal_text}"""
    buttons = ""
    for i, opt in enumerate(qdata["options"]):
        letters = ["🅰", "🅱", "🅲", "🅳", "🅴", "🅵"]
        l = letters[i] if i < len(letters) else f"({i+1})"
        buttons += f'<button class="quiz-option" data-ans="{i}">{l} {opt["text"]}</button>'
    # Reveal button + explainers
    explains = ""
    for i, opt in enumerate(qdata["options"]):
        explains += f'<div class="quiz-explain" data-explain="{i}" style="display:none"><strong style="color:#{color}">{opt["label"]}</strong> {opt["explain"]}</div>'
    html = f'''
<div class="main-area">
<p style="margin-bottom:14px;color:#bcc;font-weight:600"><i class="fas fa-question-circle" style="color:#{color}"></i> {qdata["question"]}</p>
<div id="quizContainer">{buttons}</div>
<div style="margin-top:16px"><button class="quiz-option" id="revealBtn" style="background:rgba({int(color[:2],16)},{int(color[2:4],16)},{int(color[4:6],16)},0.12);border-color:#{color};text-align:center;font-weight:600"><i class="fas fa-eye"></i> Mostrar explicación de cada opción</button></div>
<div id="explainerContainer" style="display:none;margin-top:16px">{explains}</div>
</div>
<div id="feedback" class="feedback">💬 Haz clic en una opción para responder.</div>
'''
    return html

def build_quiz_fb_entries(qdata, prefix="q_"):
    entries = {}
    for i, opt in enumerate(qdata["options"]):
        correct_i = next(j for j, o in enumerate(qdata["options"]) if o["correct"])
        if opt["correct"]:
            entries[f'{prefix}{i}'] = {
                "es": f'✅ ¡Correcto! {opt["explain"]}',
                "en": f'✅ Correct! {opt["explain"]}'
            }
        else:
            entries[f'{prefix}{i}'] = {
                "es": f'❌ No exactamente. {opt["explain"]} Intenta de nuevo.',
                "en": f'❌ Not quite. {opt["explain"]} Try again.'
            }
    return entries

# ── Process a single file ──────────────────────────────────────────────────

def process_file(filepath):
    print(f"Processing: {filepath}")
    # Use latin-1 to handle any byte corruption
    with open(filepath, "rb") as f:
        raw = f.read()
    content = raw.decode("latin-1")
    
    # Convert to proper utf-8 for processing
    content = content.encode("latin-1").decode("utf-8", errors="replace")
    
    if "¿Qué aprenderás" in content:
        print(f"  Already enhanced, skipping.")
        return
    
    course_dir, module_num, title, desc, h1 = extract_info(filepath, content)
    meta = COURSE_META.get(course_dir)
    if not meta:
        print(f"  Unknown course: {course_dir}, skipping.")
        return
    
    color, accent1, accent2, style_type, offset = meta
    slug = make_slug(h1)
    key = make_content_key(course_dir, os.path.basename(filepath))
    
    # Check if we have custom content
    custom = CONTENT.get(key, {})
    aprender_items = custom.get("aprender", GENERIC_APRENDER.get(course_dir, []))
    panels = custom.get("panels", [])
    pasos = custom.get("pasos", [])
    resumen_items = custom.get("resumen", [])
    quiz_data = custom.get("quiz", None)
    
    if not panels or not resumen_items:
        print(f"  No custom content for {key}, generating generic...")
        gen = generate_generic_content(filepath, h1, desc, color, course_dir, module_num)
        if not panels: panels = gen["panels"]
        if not pasos: pasos = gen["pasos"]
        if not resumen_items: resumen_items = gen["resumen"]
        if not aprender_items: aprender_items = gen["aprender"]
    
    # ── Style A: curso 3 ──
    if style_type == "styleA":
        # Insert CSS before </style>
        css_insert = STYLE_A_CSS.replace("COLOR", color)
        content = content.replace("</style>", css_insert + "</style>")
        
        # Build sections
        aprender_html = build_aprender(aprender_items)
        panels_html = build_panels(panels, color)
        pasos_html = build_pasos(pasos, color)
        resumen_html = build_resumen(resumen_items)
        
        # Insert aprender + panels + pasos after analogy-card, before main-area
        # pattern: </div>\n<div class="main-area"> or </div>\n<div id="feedback"
        # Actually better place after analogy-card closing
        analogy_end = content.find('</div>', content.find('analogy-card'))
        if analogy_end > 0:
            # Find the next non-whitespace content after analogy-card
            insert_point = analogy_end + 6  # after </div>
            new_sections = aprender_html + panels_html + pasos_html
            content = content[:insert_point] + "\n" + new_sections + "\n" + content[insert_point:]
        
        # Add resumen before btn-next
        content = content.replace(
            '<button class="btn-next" onclick',
            resumen_html + '\n<button class="btn-next" onclick'
        )
        
        # Add quiz I18N entries
        if quiz_data:
            fb_entries = build_quiz_fb_entries(quiz_data)
        else:
            fb_entries = {
                "quiz_correct": {"es": f"✅ ¡Correcto! Has respondido acertadamente sobre {h1}.", "en": f"✅ Correct! You answered correctly about {h1}."},
                "quiz_wrong": {"es": f"❌ No es correcto. Revisa el material sobre {h1} e intenta de nuevo.", "en": f"❌ Not correct. Review the material about {h1} and try again."}
            }
        
        # Insert I18N data for quiz
        fb_json_str = json.dumps(fb_entries, ensure_ascii=False, indent=1)
        # Find existing I18N_DATA
        if 'window.I18N_DATA={' in content:
            # Add entries before closing }
            content = content.replace(
                'window.I18N_DATA={',
                'window.I18N_DATA=Object.assign({\n' + fb_json_str.replace('{', '').replace('}', '').strip() + ','
            )
        else:
            # Create new I18N_DATA block
            i18n_block = f'\n<script>\nwindow.I18N_DATA={fb_json_str};\n</script>\n'
            content = content.replace('</body>', i18n_block + '</body>')
        
        # Add quiz JS for revelaBtn
        quiz_js = f'''
document.getElementById('revealBtn')?.addEventListener('click',function(){{
let e=document.getElementById('explainerContainer');
if(e){{
e.style.display=e.style.display==='none'?'block':'none';
this.innerHTML=e.style.display==='block'?'<i class="fas fa-eye-slash"></i> Ocultar explicación':'<i class="fas fa-eye"></i> Mostrar explicación de cada opción';
}}
}});
document.querySelectorAll('#quizContainer .quiz-option')?.forEach(b=>{{
b.addEventListener('click',function(){{
let ans=this.dataset.ans;
let fb=document.getElementById('feedback');
// Mark correct/wrong
let correctIdx=0; // default first
document.querySelectorAll('#quizContainer .quiz-option').forEach((o,i)=>{{
if(o.dataset.correct==='true') correctIdx=i;
}});
if(ans==correctIdx.toString()){{
this.className='quiz-option correct';
fb.innerHTML=I18N.t('quiz_correct');
let bd=JSON.parse(localStorage.getItem(BADGES))||[];
if(!bd.includes('{slug}')){{bd.push('{slug}');localStorage.setItem(BADGES,JSON.stringify(bd))}}
document.getElementById('insignia')?.classList.remove('hidden');
updateProg();
}}else{{
this.className='quiz-option wrong';
fb.innerHTML=I18N.t('quiz_wrong');
setTimeout(()=>this.className='quiz-option',600);
}}
document.querySelectorAll('#quizContainer .quiz-option').forEach(o=>o.style.pointerEvents='none');
setTimeout(()=>document.querySelectorAll('#quizContainer .quiz-option').forEach(o=>o.style.pointerEvents=''),2000);
}});
}});
'''
        # Insert quiz JS before the last </script> or after existing scripts
        content = content.replace('</script>', '</script>\n' + quiz_js)
        
    # ── Style B: cursos 4, 5, 6 ──
    elif style_type == "styleB":
        # Insert CSS before </style>
        css_insert = STYLE_B_CSS.replace("COLOR", color)
        content = content.replace("</style>", css_insert + "</style>")
        
        # Build sections
        aprender_html = build_aprender(aprender_items)
        panels_html = build_panels(panels, color)
        pasos_html = build_pasos(pasos, color)
        resumen_html = build_resumen(resumen_items)
        
        # Insert aprender + panels + pasos after analogy div, before content div
        analogy_end = content.find('</div>', content.find('<div class="analogy"'))
        if analogy_end > 0:
            insert_point = analogy_end + 6
            new_sections = aprender_html + panels_html + pasos_html
            content = content[:insert_point] + "\n" + new_sections + "\n" + content[insert_point:]
        
        # Add resumen before btn-next-area
        btn_next_area = content.find('<div class="btn-next-area"')
        if btn_next_area > 0:
            insert_point = content.rfind('</div>', content.find('class="insignia"'), btn_next_area)
            if insert_point > 0:
                insert_point = insert_point + 6
                content = content[:insert_point] + "\n" + resumen_html + "\n" + content[insert_point:]
            else:
                content = content.replace('<div class="btn-next-area"', resumen_html + '\n<div class="btn-next-area"')
        else:
            content = content.replace('<div class="btn-next-area"', resumen_html + '\n<div class="btn-next-area"')
        
        # Add quiz I18N entries
        if quiz_data:
            fb_entries = build_quiz_fb_entries(quiz_data)
        else:
            fb_entries = {
                "quiz_correct": {"es": f"✅ ¡Correcto! Has comprendido {h1}.", "en": f"✅ Correct! You understood {h1}."},
                "quiz_wrong": {"es": f"❌ No es correcto. Revisa el material sobre {h1} e intenta de nuevo.", "en": f"❌ Not correct. Review the material about {h1} and try again."}
            }
        
        # Insert I18N data
        fb_json_str = json.dumps(fb_entries, ensure_ascii=False, indent=1)
        if 'window.I18N_DATA={' in content:
            content = content.replace(
                'window.I18N_DATA={',
                'window.I18N_DATA=Object.assign({\n' + fb_json_str.replace('{', '').replace('}', '').strip() + ','
            )
        else:
            i18n_block = f'\n<script>\nwindow.I18N_DATA={fb_json_str};\n</script>\n'
            content = content.replace('</body>', i18n_block + '</body>')
    
    # Write file
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(content)
        f.write(content)
    print(f"  [OK] Enhanced!")

# ── Generic content generator ──────────────────────────────────────────────

GENERIC_APRENDER = {
    "curso-3-fulltext-search": [
        "A crear tsvectors con to_tsvector para indexar texto en PostgreSQL",
        "A construir tsqueries con operadores &, |, ! y <->",
        "A usar el operador @@ para hacer búsqueda de texto completo",
        "A optimizar búsquedas con índices GIN y GiST",
        "A ordenar resultados por relevancia con ts_rank y ts_rank_cd"
    ],
    "curso-4-replicacion-backup": [
        "A configurar WAL para durabilidad y Point-In-Time Recovery",
        "A implementar streaming replication para alta disponibilidad",
        "A realizar backups con pg_basebackup y pgbackrest",
        "A configurar failover automático con herramientas de clustering",
        "A recuperar una base de datos a un punto exacto en el tiempo"
    ],
    "curso-5-seguridad": [
        "A gestionar roles y permisos con CREATE ROLE y GRANT",
        "A implementar seguridad a nivel de fila con Row-Level Security",
        "A configurar autenticación con SCRAM-SHA-256 y SSL/TLS",
        "A auditar actividades con pgAudit",
        "A proteger la base de datos contra inyección SQL"
    ],
    "curso-6-sql-moderno": [
        "A usar MERGE y UPSERT para sincronización de datos",
        "A crear columnas generadas para datos derivados",
        "A usar GROUPING SETS, ROLLUP y CUBE para análisis multidimensional",
        "A implementar tablas temporales con SYSTEM VERSIONING",
        "A realizar búsquedas vectoriales con pgvector"
    ],
}

# ── Main ────────────────────────────────────────────────────────────────────

def main():
    for root, dirs, files in os.walk(BASE):
        rel_root = os.path.relpath(root, BASE)
        if rel_root == ".":
            continue
        for f in sorted(files):
            if not f.endswith(".html"):
                continue
            # Get course_dir
            parts = rel_root.split(os.sep)
            course_dir = parts[0] if len(parts) > 0 else None
            if course_dir not in COURSE_META:
                continue
            filepath = os.path.join(root, f)
            process_file(filepath)

# ── Generate generic content per file ──────────────────────────────────────

def generate_generic_content(filepath, h1, desc, color, course_dir, module_num):
    """Generate generic but relevant content based on the file name and h1."""
    filename = os.path.basename(filepath)
    slug = make_slug(h1)
    
    # Default panels based on course
    if "curso-3" in course_dir:
        panels = [
            {"title": "Tokenización", "desc": "El proceso de dividir el texto en tokens individuales (palabras). PostgreSQL elimina signos de puntuación y normaliza mayúsculas/minúsculas antes de crear el tsvector.", "sql": "SELECT to_tsvector('spanish', 'Hola Mundo!');", "tip": "Siempre especifica el idioma para una mejor tokenización"},
            {"title": "Lexemas", "desc": "Los lexemas son las unidades básicas de búsqueda. PostgreSQL reduce cada palabra a su raíz (lematización) para que 'corriendo', 'correr' y 'correré' coincidan.", "sql": "SELECT to_tsvector('spanish', 'corriendo correr correré');", "tip": "El diccionario de español maneja conjugaciones verbales"},
            {"title": "Stop Words", "desc": "Palabras comunes (el, la, de, y, en) que se eliminan automáticamente porque no aportan valor semántico a la búsqueda. PostgreSQL tiene listas por idioma.", "sql": "SELECT to_tsvector('spanish', 'el gato y el perro');", "tip": "Puedes crear tu propia lista de stop words personalizada"},
            {"title": "Posiciones", "desc": "tsvector guarda la posición de cada lexema en el documento original. Esto permite búsquedas por proximidad y frases exactas con el operador <->.", "sql": "SELECT tsvector('gato:1 perro:2 casa:3');", "tip": "Las posiciones permiten búsqueda de frases exactas"},
            {"title": "Configuración de Idioma", "desc": "PostgreSQL soporta múltiples idiomas para FTS. 'spanish', 'english', 'french', etc. Cada uno tiene su propio diccionario de stemming y stop words.", "sql": "SELECT to_tsvector('english', 'running dogs');", "tip": "Usa el idioma correcto para mejores resultados"},
            {"title": "to_tsvector vs tsvector", "desc": "to_tsvector() aplica el diccionario completo (tokenización + stemming + stop words). El cast ::tsvector solo parsea el formato ya procesado.", "sql": "SELECT to_tsvector('spanish', 'corriendo') VS 'corriendo'::tsvector;", "tip": "Siempre prefiere to_tsvector() para texto nuevo"},
        ]
        pasos = [
            {"text": "Crea una tabla de ejemplo con contenido textual para buscar", "code": "CREATE TABLE articulos (\n  id SERIAL PRIMARY KEY,\n  titulo TEXT,\n  contenido TEXT\n);"},
            {"text": "Inserta algunos documentos de ejemplo con diferentes temáticas", "code": "INSERT INTO articulos (titulo, contenido) VALUES\n('PostgreSQL Avanzado', 'Guía completa sobre optimización de consultas en PostgreSQL'),\n('Búsqueda de Texto', 'Cómo implementar full-text search con tsvector y tsquery');"},
            {"text": "Agrega una columna tsvector generada automáticamente para búsqueda", "code": "ALTER TABLE articulos ADD COLUMN contenido_tsv TSVECTOR\nGENERATED ALWAYS AS (to_tsvector('spanish', titulo || ' ' || contenido)) STORED;"},
            {"text": "Crea un índice GIN para acelerar las búsquedas de texto completo", "code": "CREATE INDEX idx_fts_articulos ON articulos USING GIN (contenido_tsv);"},
            {"text": "Ejecuta una búsqueda FTS y observa la velocidad con EXPLAIN ANALYZE", "code": "EXPLAIN ANALYZE SELECT * FROM articulos\nWHERE contenido_tsv @@ to_tsquery('spanish', 'postgres & optimización');"},
        ]
        resumen = [
            "to_tsvector() tokeniza, elimina stop words y reduce a lexemas con posiciones",
            "tsvector almacena lexemas únicos con sus posiciones en el documento",
            "La lematización (stemming) permite encontrar palabras relacionadas",
            "Los índices GIN aceleran las búsquedas FTS órdenes de magnitud",
            "Siempre especifica el idioma para una tokenización correcta"
        ]
        aprender = GENERIC_APRENDER.get("curso-3-fulltext-search", [])
        
    elif "curso-4" in course_dir:
        panels = [
            {"title": "WAL Segments", "desc": "Los archivos WAL (por defecto 16 MB cada uno) almacenan todos los cambios antes de aplicarse a los datos. PostgreSQL escribe en WAL secuencialmente para máximo rendimiento.", "sql": "SHOW wal_segment_size; -- 16777216 (16MB)", "tip": "Aumenta el tamaño en sistemas con mucha escritura"},
            {"title": "Checkpoints", "desc": "Los checkpoints fuerzan que todos los buffers sucios en memoria se escriban a disco. PostgreSQL ajusta automáticamente la frecuencia basado en el volumen de WAL generado.", "sql": "SHOW checkpoint_completion_target; -- 0.9", "tip": "checkpoint_timeout controla la frecuencia máxima"},
            {"title": "Archivado WAL", "desc": "El archivado WAL (archive_mode = on) permite copiar segmentos WAL a un almacenamiento externo para PITR y replicación.", "sql": "archive_command = 'cp %p /backups/%f'", "tip": "Comprime WALs viejos con gzip para ahorrar espacio"},
            {"title": "Redo y Undo", "desc": "PostgreSQL solo implementa REDO (rehacer) desde WAL. No necesita UNDO porque usa MVCC: las versiones viejas de filas permanecen en el heap hasta que VACUUM las limpia.", "sql": "-- PostgreSQL no tiene UNDO LOG como Oracle", "tip": "El WAL solo contiene datos para REDO, simplificando el diseño"},
            {"title": "Full Page Writes", "desc": "En el primer cambio después de un checkpoint, PostgreSQL escribe la página completa en WAL. Esto evita páginas corruptas durante la recuperación tras un crash.", "sql": "SHOW full_page_writes; -- on", "tip": "Causa WAL más grande pero garantiza recuperación segura"},
            {"title": "WAL y Replicación", "desc": "Los segmentos WAL son la base de la replicación física. El standby lee el WAL del primario y aplica los mismos cambios, manteniendo una copia idéntica.", "sql": "SELECT * FROM pg_stat_replication;", "tip": "El WAL también se usa para replicación lógica con Decodificación Lógica"},
        ]
        pasos = [
            {"text": "Verifica la configuración actual del WAL en tu instancia", "code": "SHOW wal_level;\nSHOW wal_buffers;\nSHOW wal_segment_size;"},
            {"text": "Revisa el estado de los checkpoints y la generación de WAL", "code": "SELECT * FROM pg_stat_checkpoints\nORDER BY checkpoint_time DESC LIMIT 5;"},
            {"text": "Monitorea el tamaño total del directorio pg_wal en el servidor", "code": "SELECT pg_size_pretty(SUM(size)) as total_wal\nFROM pg_ls_waldir();"},
            {"text": "Habilita el archivado WAL para backup continuo", "code": "ALTER SYSTEM SET archive_mode = 'on';\nALTER SYSTEM SET archive_command = 'cp %p /backups/wal/%f';\nSELECT pg_reload_conf();"},
            {"text": "Simula una recuperación restaurando desde un backup base + WAL", "code": "# En recovery.conf (o postgresql.auto.conf):\nrestore_command = 'cp /backups/wal/%f %p'\nrecovery_target_time = '2026-06-15 14:30:00'"},
        ]
        resumen = [
            "WAL garantiza la D de ACID: todas las transacciones confirmadas sobreviven a crashes",
            "Los segmentos WAL se escriben secuencialmente para máximo rendimiento",
            "Checkpoints sincronizan buffers sucios a disco periódicamente",
            "Full page writes protegen contra páginas medianamente escritas",
            "El WAL es la base de replicación física, lógica y PITR"
        ]
        aprender = GENERIC_APRENDER.get("curso-4-replicacion-backup", [])
        
    elif "curso-5" in course_dir:
        panels = [
            {"title": "Roles y Privilegios", "desc": "PostgreSQL maneja permisos mediante roles. Los roles pueden ser usuarios (con LOGIN) o grupos (sin LOGIN). Los permisos se heredan a través de la membresía de roles.", "sql": "CREATE ROLE analista LOGIN PASSWORD 'segura';\nGRANT SELECT ON tablas TO analista;", "tip": "NUNCA uses contraseñas débiles en producción"},
            {"title": "Row-Level Security", "desc": "RLS permite restringir qué filas puede ver o modificar cada usuario basado en una política. Es como un WHERE automático que PostgreSQL añade a cada consulta.", "sql": "CREATE POLICY solo_propios ON pedidos\nUSING (cliente_id = current_user_id());", "tip": "RLS funciona incluso si el usuario tiene SELECT en la tabla"},
            {"title": "SSL/TLS", "desc": "PostgreSQL soporta conexiones cifradas con SSL/TLS. El servidor puede requerir certificados del cliente para autenticación mutua.", "sql": "ssl = on\nssl_cert_file = 'server.crt'\nssl_key_file = 'server.key'", "tip": "Usa certificados de Let's Encrypt o una CA interna"},
            {"title": "pgAudit", "desc": "La extensión pgAudit permite auditar todas las operaciones de la base de datos a nivel de sesión u objeto. Genera logs detallados de cada comando ejecutado.", "sql": "CREATE EXTENSION pgaudit;\nSET pgaudit.log = 'write,ddl';", "tip": "Configura la rotación de logs para evitar llenar el disco"},
            {"title": "SCRAM-SHA-256", "desc": "El método de autenticación más seguro en PostgreSQL. Reemplaza al antiguo MD5. SCRAM almacena un hash salado y utiliza un protocolo de desafío-respuesta.", "sql": "password_encryption = 'scram-sha-256'\nCREATE ROLE usuario LOGIN PASSWORD 'pass';", "tip": "Migra de MD5 a SCRAM con ALTER SYSTEM y pg_reload_conf"},
            {"title": "Protección contra Inyección SQL", "desc": "La mejor defensa es usar consultas parametrizadas. Nunca concatenes Input de usuario en SQL. Usa sentencias preparadas o funciones con parámetros.", "sql": "PREPARE busca (INT) AS SELECT * FROM usuarios WHERE id = $1;\nEXECUTE busca(42);", "tip": "Las funciones PL/pgSQL también protegen contra inyección"},
        ]
        pasos = [
            {"text": "Crea roles con diferentes niveles de acceso para tu aplicación", "code": "CREATE ROLE app_readonly LOGIN PASSWORD 'read123';\nCREATE ROLE app_writer LOGIN PASSWORD 'write456';\nCREATE ROLE admin LOGIN PASSWORD 'admin789' SUPERUSER;"},
            {"text": "Otorga permisos específicos a cada rol según sus necesidades", "code": "GRANT SELECT ON ALL TABLES IN SCHEMA public TO app_readonly;\nGRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO app_writer;"},
            {"text": "Configura RLS para que los usuarios solo vean sus propios datos", "code": "ALTER TABLE pedidos ENABLE ROW LEVEL SECURITY;\nCREATE POLICY pedidos_propios ON pedidos\nUSING (usuario_id = current_setting('app.usuario_id')::INT);"},
            {"text": "Habilita SSL/TLS y verifica la conexión segura", "code": "openssl req -new -x509 -days 365 -nodes -out server.crt -keyout server.key\nchmod 600 server.key\n-- En postgresql.conf:\nssl = on\nssl_cert_file = 'server.crt'\nssl_key_file = 'server.key'"},
            {"text": "Verifica quién está conectado y qué permisos tiene", "code": "SELECT usename, application_name, client_addr, ssl\nFROM pg_stat_activity WHERE state = 'active';\n\nSELECT * FROM information_schema.table_privileges\nWHERE grantee = 'app_readonly';"},
        ]
        resumen = [
            "CREATE ROLE define usuarios y grupos; GRANT asigna permisos específicos",
            "Row-Level Security filtra filas automáticamente por política",
            "SCRAM-SHA-256 es el método de autenticación más seguro de PostgreSQL",
            "SSL/TLS cifra la comunicación entre cliente y servidor",
            "pgAudit registra cada operación para cumplimiento normativo",
            "Siempre usa consultas parametrizadas para evitar inyección SQL"
        ]
        aprender = GENERIC_APRENDER.get("curso-5-seguridad", [])
        
    elif "curso-6" in course_dir:
        panels = [
            {"title": "MERGE (UPSERT)", "desc": "INSERT ... ON CONFLICT (UPSERT) permite insertar o actualizar en una sola operación. Si el registro existe por la clave primaria, se actualiza; si no, se inserta.", "sql": "INSERT INTO inventario (id, producto, stock)\nVALUES (1, 'Laptop', 10)\nON CONFLICT (id) DO UPDATE SET stock = inventario.stock + EXCLUDED.stock;", "tip": "EXCLUDED referencia los valores que se intentaron insertar"},
            {"title": "Columnas Generadas", "desc": "Las columnas generadas (STORED o VIRTUAL) se calculan automáticamente a partir de otras columnas. PostgreSQL 12+ soporta STORED, que guarda físicamente el valor.", "sql": "CREATE TABLE productos (\n  precio NUMERIC,\n  iva NUMERIC GENERATED ALWAYS AS (precio * 0.16) STORED\n);", "tip": "Las columnas generadas no se pueden modificar directamente"},
            {"title": "GROUPING SETS", "desc": "GROUPING SETS, ROLLUP y CUBE permiten múltiples agrupaciones en una sola consulta. Más eficiente que hacer UNION de varios GROUP BY.", "sql": "SELECT año, mes, SUM(ventas)\nFROM ventas\nGROUP BY GROUPING SETS ((año), (año, mes), ());", "tip": "El orden de las columnas afecta los resultados de ROLLUP"},
            {"title": "Tablas Temporales", "desc": "PostgreSQL no tiene tablas temporales del sistema (como SQL:2011), pero se puede emular con triggers o extensiones como temporal_tables.", "sql": "-- Con extensión temporal_tables:\nCREATE EXTENSION temporal_tables;\nSELECT version_sys_period(pedidos);", "tip": "Las tablas versionadas permiten consultar el estado en cualquier momento"},
            {"title": "pgvector", "desc": "La extensión pgvector permite almacenar y buscar vectores de embeddings directamente en PostgreSQL. Soporta distancia coseno, L2 e inner product.", "sql": "CREATE EXTENSION vector;\nCREATE TABLE items (id INT, embedding VECTOR(3));\nSELECT * FROM items ORDER BY embedding <=> '[1,2,3]' LIMIT 5;", "tip": "Usa índices IVFFlat para acelerar búsquedas en más de 1000 vectores"},
            {"title": "LATERAL Joins", "desc": "LATERAL permite que una subconsulta en FROM haga referencia a columnas de tablas anteriores en la misma cláusula FROM. Ideal para top-N por grupo.", "sql": "SELECT * FROM usuarios u,\nLATERAL (SELECT * FROM pedidos WHERE usuario_id = u.id\n ORDER BY fecha DESC LIMIT 3) p;", "tip": "LATERAL se ejecuta como un bucle correlacionado optimizado"},
        ]
        pasos = [
            {"text": "Crea una tabla de ejemplo con datos maestros para practicar operaciones modernas", "code": "CREATE TABLE ventas (\n  id SERIAL PRIMARY KEY,\n  producto TEXT,\n  categoria TEXT,\n  monto NUMERIC,\n  fecha DATE\n);\n\nINSERT INTO ventas VALUES\n(1, 'Laptop', 'Electrónica', 1500, '2026-01-15'),\n(2, 'Mouse', 'Electrónica', 25, '2026-01-16');"},
            {"text": "Usa MERGE para sincronizar datos desde una tabla de staging", "code": "MERGE INTO ventas AS v\nUSING (VALUES (1, 'Laptop Pro', 1600), (3, 'Teclado', 80))\n  AS s(id, producto, monto)\nON v.id = s.id\nWHEN MATCHED THEN UPDATE SET producto = s.producto, monto = s.monto\nWHEN NOT MATCHED THEN INSERT (id, producto, monto, fecha)\n  VALUES (s.id, s.producto, s.monto, CURRENT_DATE);"},
            {"text": "Usa GROUPING SETS para analizar ventas por múltiples dimensiones", "code": "SELECT categoria, producto, SUM(monto) as total\nFROM ventas\nGROUP BY GROUPING SETS (\n  (categoria),\n  (categoria, producto),\n  ()\n)\nORDER BY categoria NULLS LAST, producto NULLS LAST;"},
            {"text": "Agrega una columna generada para calcular IVA automáticamente", "code": "ALTER TABLE ventas ADD COLUMN iva NUMERIC\nGENERATED ALWAYS AS (monto * 0.16) STORED;\n\nSELECT * FROM ventas; -- El IVA se calcula automáticamente"},
            {"text": "Usa pgvector para búsqueda semántica de productos similares", "code": "CREATE EXTENSION IF NOT EXISTS vector;\nALTER TABLE ventas ADD COLUMN embedding VECTOR(3);\n\nUPDATE ventas SET embedding = '[0.5,0.3,0.8]' WHERE id = 1;\nUPDATE ventas SET embedding = '[0.1,0.9,0.2]' WHERE id = 2;\n\nSELECT producto, monto FROM ventas\nORDER BY embedding <=> '[0.4,0.4,0.7]' LIMIT 3;"},
        ]
        resumen = [
            "MERGE / UPSERT permite insertar o actualizar en una sola operación atómica",
            "Columnas generadas automatizan cálculos derivados sin triggers",
            "GROUPING SETS, ROLLUP y CUBE analizan datos en múltiples dimensiones",
            "Tablas temporales versionadas permiten consultar datos históricos",
            "pgvector agrega búsqueda semántica de vectores en PostgreSQL",
            "LATERAL optimiza consultas 'top-N por grupo' tradicionalmente difíciles"
        ]
        aprender = GENERIC_APRENDER.get("curso-6-sql-moderno", [])
    else:
        panels = []
        pasos = []
        resumen = []
        aprender = []
    
    return {"panels": panels, "pasos": pasos, "resumen": resumen, "aprender": aprender}

if __name__ == "__main__":
    main()
    print("\n✨ Done!")
