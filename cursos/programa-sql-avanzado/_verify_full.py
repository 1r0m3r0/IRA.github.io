import os, sys
sys.stdout.reconfigure(encoding='utf-8')

BASE = r'D:\poryectosPulidos\PAGINA\cursos\programa-sql-avanzado'

# Only check lesson files (not index.html catalogs)
lesson_extensions = ['.html']
skip_files = {'index.html'}

total = 0
ok = 0
problems = []

for root, dirs, files in os.walk(BASE):
    if '_verify' in root or '_enhance' in root:
        continue
    rel = os.path.relpath(root, BASE)
    for f in sorted(files):
        if not f.endswith('.html'):
            continue
        
        fp = os.path.join(root, f)
        with open(fp, 'rb') as fh:
            raw = fh.read()
        
        # Skip index files (catalogs)
        if f == 'index.html':
            total += 1
            # Still check they weren't corrupted
            try:
                content = raw.decode('latin-1').encode('latin-1').decode('utf-8', errors='replace')
                # Index files should NOT have lesson sections
                has_lesson_sections = ('\u00bfQu\u00e9 aprender\u00e1s' in content or 
                    'class="paso-paso"' in content or 
                    'class="resumen-modulo"' in content)
                if has_lesson_sections:
                    problems.append(f'{rel}\\{f}: CATALOG has lesson sections - REVERT NEEDED')
                else:
                    ok += 1
            except:
                problems.append(f'{rel}\\{f}: Could not decode')
            continue
        
        total += 1
        try:
            content = raw.decode('latin-1').encode('latin-1').decode('utf-8', errors='replace')
        except:
            content = raw.decode('latin-1', errors='replace')
        
        # Check required sections
        missing = []
        if '\u00bfQu\u00e9 aprender\u00e1s' not in content:
            missing.append('Que aprenderas')
        if 'class="panel-grid"' not in content and 'panel-grid' not in content:
            missing.append('panel-grid')
        if 'class="paso-paso"' not in content:
            missing.append('paso-paso')
        if 'Resumen del m\u00f3dulo' not in content:
            missing.append('resumen')
        
        if missing:
            problems.append(f'{rel}\\{f}: MISSING {missing}')
        else:
            ok += 1

print(f'Total files: {total}')
print(f'OK: {ok}')
print(f'Problems: {len(problems)}')
for p in problems[:20]:
    print(f'  {p}')
if len(problems) > 20:
    print(f'  ... and {len(problems)-20} more')
