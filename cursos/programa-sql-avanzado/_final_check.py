import sys
sys.stdout.reconfigure(encoding='utf-8')

filepath = r'D:\poryectosPulidos\PAGINA\cursos\programa-sql-avanzado\curso-3-fulltext-search\01-tsvector.html'
with open(filepath, 'rb') as f:
    raw = f.read()
content = raw.decode('latin-1').encode('latin-1').decode('utf-8', errors='replace')

# Check original content preserved
term_checks = [
    ('to_tsvector', 'function'),
    ('updateProg', 'progress'),
    ('localStorage', 'storage'),
    ('BADGES', 'badges'),
    ('btn-next', 'next button'),
    ('insignia', 'badge display'),
    ('convertBtn', 'convert button'),
    ('simpleTokenize', 'tokenizer'),
]
for term, desc in term_checks:
    print(f'PRESERVED {desc}: {term in content}')

# Check new sections
print(f'COUNT aprender-section: {content.count("aprender-section")}')
print(f'COUNT panel-grid: {content.count("panel-grid")}')
print(f'COUNT paso-paso: {content.count("paso-paso")}')
print(f'COUNT resumen-modulo: {content.count("resumen-modulo")}')

# Verify file is valid HTML
has_doctype = '<!DOCTYPE html>' in content or '<!DOCTYPE html>' in content.upper()
has_html_close = '</html>' in content
has_body_close = '</body>' in content
print(f'Valid HTML (DOCTYPE): {has_doctype}')
print(f'Valid HTML (closing tags): {has_html_close and has_body_close}')
