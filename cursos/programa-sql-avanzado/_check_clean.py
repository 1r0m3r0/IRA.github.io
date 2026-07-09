import sys
sys.stdout.reconfigure(encoding='utf-8')

filepath = r'D:\poryectosPulidos\PAGINA\cursos\programa-sql-avanzado\curso-3-fulltext-search\01-tsvector.html'
with open(filepath, 'rb') as f:
    raw = f.read()
content = raw.decode('latin-1').encode('latin-1').decode('utf-8', errors='replace')

# Check for duplicated tags
for tag in ['</style>', '<div class="aprender-section"', '<div class="panel-grid"', '<div class="paso-paso"', '<div class="resumen-modulo"']:
    count = content.count(tag)
    print(f'{tag}: {count} occurences')

# Show where the CSS ends and where aprender-section HTML begins
css_end = content.find('</style>')
print(f'CSS end: {css_end}')
html_start = content.find('class="aprender-section"')
print(f'HTML aprender: {html_start} (after CSS: {html_start > css_end})')

# Show the structure
pos = content.find('class="aprender-section"')
if pos > 0:
    print(f'Context: ...{content[pos-50:pos+150]}...')
    
# Check no doubled CSS
css_count = content.count('.aprender-section{')
print(f'CSS .aprender-section rules: {css_count}')
