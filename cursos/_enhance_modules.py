import os
import re

# Color config per course directory
COURSE_COLORS = {
    'curso-1-window-functions': '#ffb347',
    'curso-2-ctes': '#00cc6a',
    'curso-3-indices': '#2b9eff',
    'curso-4-vistas-procedimientos': '#9c64ff',
    'curso-5-transacciones': '#ff5050',
    'curso-6-json-case': '#ffd700',
    'curso-1-planes-ejecucion': '#ff5050',
    'curso-2-particionamiento': '#9c64ff',
    'curso-3-fulltext-search': '#00e0ff',
    'curso-4-replicacion-backup': '#00cc6a',
    'curso-5-seguridad': '#ffb347',
    'curso-6-sql-moderno': '#ff64dc',
}

def hex_to_rgb(h):
    h = h.lstrip('#')
    return int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16)

def find_matching_close(content, start):
    """Find position right after the matching </div> for a <div> at start."""
    depth = 0
    i = start
    while i < len(content):
        # Check for opening <div (not </div)
        if content[i:i+4] == '<div' and (i+4 >= len(content) or content[i+4] in ' \t\n\r>'):
            # Make sure it's not a closing tag or self-closing
            if content[i:i+2] != '</':
                depth += 1
                tag_end = content.find('>', i+4)
                if tag_end != -1:
                    i = tag_end + 1
                    continue
                else:
                    i += 4
                    continue
        # Check for closing </div>
        if content[i:i+6] == '</div>':
            depth -= 1
            i += 6
            if depth == 0:
                return i
            continue
        i += 1
    return -1

def process_file(filepath, course_dir):
    with open(filepath, 'r', encoding='utf-8') as f:
        original = f.read()

    content = original

    # Skip if both CSS and HTML sections already exist
    style_start = content.find('<style')
    style_end = content.find('</style>')
    has_css = style_start != -1 and style_end != -1 and '.objectives' in content[style_start:style_end]
    has_html_obj = '<div class="objectives">' in content
    has_html_recap = '<div class="module-recap">' in content
    if has_css and has_html_obj and has_html_recap:
        print(f"  SKIP (already enhanced)")
        return None

    color = COURSE_COLORS[course_dir]
    r, g, b = hex_to_rgb(color)

    # ── A. Add CSS before </style> ──
    if style_end != -1:
        css_block = f"""
.objectives {{ background: rgba({r},{g},{b},0.1); border-radius: 1.5rem; padding: 1rem 1.5rem; margin: 1.5rem 2rem; border: 1px solid rgba({r},{g},{b},0.3); }}
.objectives h3 {{ color: {color}; font-size: 1.1rem; margin-bottom: 0.7rem; }}
.objectives li {{ color: #b9ccee; font-size: 0.9rem; margin: 0.4rem 0; list-style: none; }}
.objectives li::before {{ content: "🎯 "; }}
.module-recap {{ background: rgba({r},{g},{b},0.08); border-radius: 1.5rem; padding: 1rem 1.5rem; margin: 1.5rem 2rem; border: 1px dashed rgba({r},{g},{b},0.4); }}
.module-recap h3 {{ color: {color}; font-size: 1rem; margin-bottom: 0.5rem; }}
.module-recap li {{ color: #8899bb; font-size: 0.85rem; margin: 0.3rem 0; }}
"""
        content = content[:style_end] + '\n' + css_block + content[style_end:]

    # ── B. Add objectives section after analogy card ──
    objectives_html = """
<div class="objectives">
 <h3>🎯 ¿Qué aprenderás?</h3>
 <ul>
  <li>Comprender el concepto fundamental de SQL explicado en este módulo</li>
  <li>Aplicar la sintaxis correcta con ejemplos prácticos de consultas</li>
  <li>Evitar errores comunes y optimizar el rendimiento</li>
  <li>Desarrollar intuición para elegir la técnica adecuada</li>
 </ul>
</div>
"""

    # Find analogy card - try both patterns
    analogy_pos = -1
    for pat in ['<div class="analogy-card', '<div class="analogy"']:
        p = content.find(pat)
        if p != -1:
            analogy_pos = p
            break

    if analogy_pos != -1:
        close_pos = find_matching_close(content, analogy_pos)
        if close_pos != -1:
            content = content[:close_pos] + '\n' + objectives_html + '\n' + content[close_pos:]
        else:
            print(f"  WARN: could not find closing div for analogy card")
    else:
        print(f"  WARN: no analogy card found")
        return None

    # ── C. Add recap section before btn-next or nav-links ──
    recap_html = """
<div class="module-recap">
 <h3>📌 Resumen del módulo</h3>
 <ul>
  <li>Concepto clave: domina la idea central de SQL presentada</li>
  <li>Sintaxis: recuerda las reglas y patrones de consulta</li>
  <li>Casos de uso: aplica lo aprendido en escenarios reales</li>
  <li>Buenas prácticas: escribe SQL eficiente y mantenible</li>
 </ul>
</div>
"""

    # Find btn-next or nav-links (whichever comes first)
    btn_positions = []
    for pat in ['class="btn-next"', '<div class="nav-links">']:
        p = content.find(pat)
        if p != -1:
            # Find the beginning of the tag containing this class attribute
            tag_start = content.rfind('<', 0, p)
            if tag_start != -1:
                btn_positions.append(tag_start)
            else:
                btn_positions.append(p)

    if btn_positions:
        btn_pos = min(btn_positions)
        content = content[:btn_pos] + '\n' + recap_html + '\n' + content[btn_pos:]
    else:
        print(f"  WARN: no btn-next or nav-links found")

    # Write back only if changed
    if content != original:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"  ENHANCED")
        return True
    else:
        print(f"  SKIP (no changes needed)")
        return None

def main():
    base_dirs = [
        r'D:\poryectosPulidos\PAGINA\cursos\programa-sql-medio',
        r'D:\poryectosPulidos\PAGINA\cursos\programa-sql-avanzado',
    ]

    total_enhanced = 0
    total_skipped = 0

    for base_dir in base_dirs:
        prog_name = os.path.basename(base_dir)
        print(f"\n{'='*60}")
        print(f"PROGRAMA: {prog_name}")
        print(f"{'='*60}")

        for course_dir_name in sorted(os.listdir(base_dir)):
            course_path = os.path.join(base_dir, course_dir_name)
            if not os.path.isdir(course_path):
                continue
            if course_dir_name not in COURSE_COLORS:
                print(f"\n  SKIP unknown course: {course_dir_name}")
                continue

            print(f"  {course_dir_name}:")

            html_files = sorted([
                f for f in os.listdir(course_path)
                if f.endswith('.html') and f != 'index.html'
            ])

            for html_file in html_files:
                filepath = os.path.join(course_path, html_file)
                print(f"  {html_file}:", end='')
                try:
                    result = process_file(filepath, course_dir_name)
                    if result:
                        total_enhanced += 1
                    else:
                        total_skipped += 1
                except Exception as e:
                    print(f"  ERROR: {e}")

    print(f"\n{'='*60}")
    print(f"DONE: {total_enhanced} files enhanced, {total_skipped} skipped")
    print(f"{'='*60}")

if __name__ == '__main__':
    main()
