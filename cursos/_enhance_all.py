import os

BASE = os.path.dirname(os.path.abspath(__file__))

CONFIG = {
    'probabilidades':           {'hex': '#2b9eff', 'rgb': '43,158,255'},
    'estadistica-descriptiva':  {'hex': '#2b9eff', 'rgb': '43,158,255'},
    'estadistica-inferencial':  {'hex': '#2b9eff', 'rgb': '43,158,255'},
    'ia-investigacion':         {'hex': '#2b9eff', 'rgb': '43,158,255'},
    'macroeconomia':            {'hex': '#2b9eff', 'rgb': '43,158,255'},
    'microeconomia':            {'hex': '#ffb347', 'rgb': '255,179,71'},
    'quant-trading':            {'hex': '#ffb347', 'rgb': '255,179,71'},
    'mql5-trading-algoritmico': {'hex': '#ffb347', 'rgb': '255,179,71'},
    'markestrated':             {'hex': '#ffb347', 'rgb': '255,179,71'},
    'tenpomatic':               {'hex': '#00e0ff', 'rgb': '0,224,255'},
}

CSS_CODE = """\
.objectives {{ background: rgba({rgb},0.1); border-radius: 1.5rem; padding: 1rem 1.5rem; margin: 1.5rem 2rem; border: 1px solid rgba({rgb},0.3); }}
.objectives h3 {{ color: {hex}; font-size: 1.1rem; margin-bottom: 0.7rem; }}
.objectives li {{ color: #b9ccee; font-size: 0.9rem; margin: 0.4rem 0; list-style: none; }}
.objectives li::before {{ content: "\U0001f3af "; }}
.module-recap {{ background: rgba({rgb},0.08); border-radius: 1.5rem; padding: 1rem 1.5rem; margin: 1.5rem 2rem; border: 1px dashed rgba({rgb},0.4); }}
.module-recap h3 {{ color: {hex}; font-size: 1rem; margin-bottom: 0.5rem; }}
.module-recap li {{ color: #8899bb; font-size: 0.85rem; margin: 0.3rem 0; }}
"""

OBJECTIVES_HTML = """\
<div class="objectives">
 <h3>\U0001f3af \u00bfQu\u00e9 aprender\u00e1s?</h3>
 <ul>
  <li>Comprender los conceptos fundamentales explicados en este m\u00f3dulo</li>
  <li>Aplicar las t\u00e9cnicas con ejemplos pr\u00e1cticos</li>
  <li>Interpretar resultados y diagnosticar problemas</li>
  <li>Desarrollar intuici\u00f3n para aplicar lo aprendido</li>
 </ul>
</div>
"""

RECAP_HTML = """\
<div class="module-recap">
 <h3>\U0001f4cc Resumen del m\u00f3dulo</h3>
 <ul>
  <li>Concepto clave: domina la idea central del m\u00f3dulo</li>
  <li>Aplicaci\u00f3n: preparado para casos pr\u00e1cticos reales</li>
  <li>Errores comunes: identifica y evita las trampas</li>
  <li>Pr\u00f3ximos pasos: base para continuar aprendiendo</li>
 </ul>
</div>
"""


def find_analogy_end(content):
    for cls in ['analogy-card', 'analogy-box']:
        for q in ['"', "'"]:
            pattern = f'class={q}{cls}{q}'
            idx = content.find(pattern)
            if idx == -1:
                continue
            tag_start = content.rfind('<', 0, idx)
            if tag_start == -1:
                continue
            div_marker = content[tag_start:tag_start + 5]
            if div_marker != '<div ' and div_marker != '<div>':
                continue
            gt_pos = content.find('>', idx)
            if gt_pos == -1:
                continue
            pos = gt_pos + 1
            depth = 1
            while pos < len(content) and depth > 0:
                next_open = content.find('<div', pos)
                next_close = content.find('</div>', pos)
                if next_close == -1:
                    break
                if next_open != -1 and next_open < next_close:
                    depth += 1
                    pos = next_open + 4
                else:
                    depth -= 1
                    pos = next_close + 6
            if depth == 0:
                return pos
    return -1


def find_navlinks_start(content):
    pattern = 'class="nav-links"'
    idx = content.find(pattern)
    if idx == -1:
        pattern = "class='nav-links'"
        idx = content.find(pattern)
    if idx != -1:
        tag_start = content.rfind('<', 0, idx)
        if tag_start != -1:
            return tag_start
    return -1


def process_file(filepath, cfg):
    with open(filepath, 'r', encoding='utf-8', errors='replace') as f:
        content = f.read()

    if '.objectives' in content:
        return False

    changes = []

    style_end = content.find('</style>')
    if style_end == -1:
        return False

    css_block = CSS_CODE.format(hex=cfg['hex'], rgb=cfg['rgb'])
    content = content[:style_end] + '\n' + css_block + content[style_end:]
    changes.append('CSS')

    analogy_end = find_analogy_end(content)
    if analogy_end != -1:
        content = content[:analogy_end] + '\n' + OBJECTIVES_HTML + content[analogy_end:]
        changes.append('OBJ')

    nav_pos = find_navlinks_start(content)
    if nav_pos != -1:
        content = content[:nav_pos] + '\n' + RECAP_HTML + content[nav_pos:]
        changes.append('REC')

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

    print(f"  {'+'.join(changes):12s} {os.path.basename(filepath)}")
    return True


def main():
    total = 0
    ok = 0
    for dirname, cfg in sorted(CONFIG.items()):
        dirpath = os.path.join(BASE, dirname)
        if not os.path.isdir(dirpath):
            print(f"NOT FOUND: {dirpath}")
            continue
        html_files = sorted([
            f for f in os.listdir(dirpath)
            if f.endswith('.html') and os.path.isfile(os.path.join(dirpath, f))
        ])
        print(f"\n=== {dirname} ({len(html_files)} files) ===")
        for fname in html_files:
            total += 1
            if process_file(os.path.join(dirpath, fname), cfg):
                ok += 1

    print(f"\nDone: {ok}/{total} files enhanced")


if __name__ == '__main__':
    main()
