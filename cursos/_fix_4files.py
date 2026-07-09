import os

files = {
    r'D:\poryectosPulidos\PAGINA\cursos\programa-sql-medio\curso-1-window-functions\12-mini-proyecto.html': '#ffb347',
    r'D:\poryectosPulidos\PAGINA\cursos\programa-sql-medio\curso-2-ctes\03-ctes-vs-subconsultas.html': '#00cc6a',
    r'D:\poryectosPulidos\PAGINA\cursos\programa-sql-medio\curso-2-ctes\12-mini-proyecto.html': '#00cc6a',
    r'D:\poryectosPulidos\PAGINA\cursos\programa-sql-medio\curso-3-indices\12-mini-proyecto.html': '#2b9eff',
}

def hex_to_rgb(h):
    h = h.lstrip('#')
    return int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16)

def find_matching_close(content, start):
    depth = 0
    i = start
    while i < len(content):
        if content[i:i+4] == '<div' and (i+4 >= len(content) or content[i+4] in ' \t\n\r>'):
            if content[i:i+2] != '</':
                depth += 1
                tag_end = content.find('>', i+4)
                if tag_end != -1:
                    i = tag_end + 1
                    continue
                else:
                    i += 4
                    continue
        if content[i:i+6] == '</div>':
            depth -= 1
            i += 6
            if depth == 0:
                return i
            continue
        i += 1
    return -1

for fpath, color in files.items():
    fname = os.path.basename(fpath)
    print(f"\n{fname}:")
    
    # Read with utf-8-sig and error replacement
    with open(fpath, 'r', encoding='utf-8-sig', errors='replace') as f:
        original = f.read()
    
    # Check if already enhanced
    if '.objectives' in original and '<div class="objectives">' in original and '<div class="module-recap">' in original:
        print("  Already fully enhanced")
        continue
    
    content = original
    r, g, b = hex_to_rgb(color)
    
    # Add CSS before </style>
    if '</style>' in content:
        css_block = f"""
.objectives {{ background: rgba({r},{g},{b},0.1); border-radius: 1.5rem; padding: 1rem 1.5rem; margin: 1.5rem 2rem; border: 1px solid rgba({r},{g},{b},0.3); }}
.objectives h3 {{ color: {color}; font-size: 1.1rem; margin-bottom: 0.7rem; }}
.objectives li {{ color: #b9ccee; font-size: 0.9rem; margin: 0.4rem 0; list-style: none; }}
.objectives li::before {{ content: "\U0001f3af "; }}
.module-recap {{ background: rgba({r},{g},{b},0.08); border-radius: 1.5rem; padding: 1rem 1.5rem; margin: 1.5rem 2rem; border: 1px dashed rgba({r},{g},{b},0.4); }}
.module-recap h3 {{ color: {color}; font-size: 1rem; margin-bottom: 0.5rem; }}
.module-recap li {{ color: #8899bb; font-size: 0.85rem; margin: 0.3rem 0; }}
"""
        content = content.replace('</style>', css_block + '\n</style>', 1)
        print("  CSS added")
    
    # Add objectives after analogy card
    objectives_html = """
<div class="objectives">
 <h3>\U0001f3af \u00bfQu\u00e9 aprender\u00e1s?</h3>
 <ul>
  <li>Comprender el concepto fundamental de SQL explicado en este m\u00f3dulo</li>
  <li>Aplicar la sintaxis correcta con ejemplos pr\u00e1cticos de consultas</li>
  <li>Evitar errores comunes y optimizar el rendimiento</li>
  <li>Desarrollar intuici\u00f3n para elegir la t\u00e9cnica adecuada</li>
 </ul>
</div>
"""
    
    for pat in ['<div class="analogy-card"', '<div class="analogy"']:
        p = content.find(pat)
        if p != -1:
            close_pos = find_matching_close(content, p)
            if close_pos != -1:
                content = content[:close_pos] + '\n' + objectives_html + '\n' + content[close_pos:]
                print("  Objectives HTML added")
                break
    
    # Add recap before btn-next
    recap_html = """
<div class="module-recap">
 <h3>\U0001f4cc Resumen del m\u00f3dulo</h3>
 <ul>
  <li>Concepto clave: domina la idea central de SQL presentada</li>
  <li>Sintaxis: recuerda las reglas y patrones de consulta</li>
  <li>Casos de uso: aplica lo aprendido en escenarios reales</li>
  <li>Buenas pr\u00e1cticas: escribe SQL eficiente y mantenible</li>
 </ul>
</div>
"""
    
    # Find class="btn-next" or nav-links
    btn_positions = []
    for pat in ['class="btn-next"', '<div class="nav-links">']:
        p = content.find(pat)
        if p != -1:
            tag_start = content.rfind('<', 0, p)
            if tag_start != -1:
                btn_positions.append(tag_start)
            else:
                btn_positions.append(p)
    
    if btn_positions:
        btn_pos = min(btn_positions)
        content = content[:btn_pos] + '\n' + recap_html + '\n' + content[btn_pos:]
        print("  Recap HTML added")
    
    if content != original:
        with open(fpath, 'w', encoding='utf-8') as f:
            f.write(content)
        print("  SAVED")
    else:
        print("  No changes")
