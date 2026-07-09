#!/usr/bin/env python3
"""Enhance all course modules with self-learning sections."""
import os
import re
import glob

PROGRAMS = [
    "programa-estadistica",
    "programa-metodologia",
    "programa-blockchain",
    "programa-marketing-digital",
    "programa-python-basico",
    "programa-python-medio",
    "programa-python-avanzado",
    "programa-sql-basico",
    "programa-sql-medio",
    "programa-sql-avanzado",
    "programa-datos-fundamentos",
    "programa-datos-machine-learning",
    "programa-datos-ingenieria",
    "programa-datos-aplicaciones",
    "trading-algoritmico-python",
    "programa-finanzas",
]

def get_module_title_from_hero(html):
    """Extract module title from hero header."""
    m = re.search(r'<h1[^>]*>([^<]+)</h1>', html)
    if m:
        title = m.group(1).strip()
        # Remove emoji
        title = re.sub(r'[\U0001F300-\U0001FFFF\U00002000-\U00002BFF]', '', title).strip()
        return title
    return "este módulo"

def has_objectives_section(html):
    return '¿Qué aprenderás' in html or 'objectives-section' in html

def add_objectives_section(html, color, color_rgb, module_title):
    """Add learning objectives section after analogy card."""
    section = f'''
   <div class="objectives-section">
    <h3>🎯 ¿Qué aprenderás?</h3>
    <ul>
     <li>Comprender los fundamentos teóricos de {module_title}</li>
     <li>Aplicar los conceptos en ejemplos prácticos y simulaciones</li>
     <li>Interpretar correctamente los resultados y diagnosticar problemas</li>
     <li>Desarrollar intuición sobre cuándo y cómo usar cada técnica</li>
    </ul>
   </div>
'''
    css = f'''
  .objectives-section {{
   background: rgba({color_rgb},0.1);
   border-radius: 1.5rem;
   padding: 1rem 1.5rem;
   margin: 1.5rem 2rem;
   border: 1px solid rgba({color_rgb},0.3);
  }}
  .objectives-section h3 {{
   color: {color};
   font-size: 1.1rem;
   margin-bottom: 0.7rem;
  }}
  .objectives-section li {{
   color: #b9ccee;
   font-size: 0.9rem;
   margin: 0.4rem 0;
   list-style: none;
  }}
  .objectives-section li::before {{
   content: "🎯 ";
  }}
'''
    # Insert CSS before closing </style>
    html = re.sub(r'(</style>)', css + r'\1', html)
    # Insert section after analogy card
    html = re.sub(r'(</div>\s*<!--\s*end analogy\s*-->|</div>\s*<div class="main-area")', lambda m: section + '\n' + m.group(1), html)
    # Or after any analogy-card div
    html = re.sub(r'(</div>\s*<div class="main-area")', section + '\n' + m.group(1) if False else section + '\n' + '<div class="main-area"', html)
    # Simple approach: insert before <div class="main-area">
    html = html.replace('<div class="main-area">', section + '\n<div class="main-area">')
    return html

def process_file(filepath):
    """Add enhancements to a single file."""
    with open(filepath, 'r', encoding='utf-8') as f:
        html = f.read()
    
    if has_objectives_section(html):
        return False  # Already done
    
    # Find color scheme
    color_match = re.search(r'#([0-9a-fA-F]{6})', html)
    if not color_match:
        return False
    color = '#' + color_match.group(1)
    # Get RGB values
    r, g, b = int(color[1:3], 16), int(color[3:5], 16), int(color[5:7], 16)
    color_rgb = f'{r},{g},{b}'
    
    module_title = get_module_title_from_hero(html)
    
    html = add_objectives_section(html, color, color_rgb, module_title)
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(html)
    return True

def process_program(program_dir):
    base = os.path.join('cursos', program_dir)
    if not os.path.isdir(base):
        print(f"  NOT FOUND: {program_dir}")
        return 0, 0
    
    files = glob.glob(os.path.join(base, '**', '*.html'), recursive=True)
    enhanced = 0
    skipped = 0
    
    for f in sorted(files):
        try:
            if process_file(f):
                enhanced += 1
            else:
                skipped += 1
        except Exception as e:
            print(f"  ERROR: {f}: {e}")
    
    print(f"  {program_dir}: {enhanced} enhanced, {skipped} already done")
    return enhanced, skipped

if __name__ == '__main__':
    total_e = 0
    total_s = 0
    for prog in PROGRAMS:
        e, s = process_program(prog)
        total_e += e
        total_s += s
    print(f"\nTotal: {total_e} files enhanced, {total_s} already done")
