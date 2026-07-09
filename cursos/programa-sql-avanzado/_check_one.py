import sys
sys.stdout.reconfigure(encoding='utf-8')
filepath = r'D:\poryectosPulidos\PAGINA\cursos\programa-sql-avanzado\curso-4-replicacion-backup\01-wal.html'
with open(filepath, 'rb') as f:
    raw = f.read()
content = raw.decode('latin-1').encode('latin-1').decode('utf-8', errors='replace')
content = content.lstrip('\ufeff')

# Check HTML sections (not CSS)
for tag in ['aprender-section', 'panel-grid', 'paso-paso', 'resumen-modulo']:
    html_attr = f'class="{tag}"'
    pos = content.find(html_attr)
    print(f'HTML {tag}: {"FOUND at " + str(pos) if pos >= 0 else "NOT FOUND"}')
    if pos >= 0:
        print(f'  Context: {content[pos:pos+200].strip()}')

# Also check CSS was added
css_pos = content.find('.aprender-section{')
print(f'CSS .aprender-section: {"FOUND" if css_pos >= 0 else "NOT FOUND"}')
