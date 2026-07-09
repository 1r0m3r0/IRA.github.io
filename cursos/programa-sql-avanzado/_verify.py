import os

BASE = r'D:\poryectosPulidos\PAGINA\cursos\programa-sql-avanzado'
counts = {'total': 0, 'has_aprender': 0, 'has_panels': 0, 'has_pasos': 0, 'has_resumen': 0}

for root, dirs, files in os.walk(BASE):
    if '_verify.py' in root or '_enhance' in root:
        continue
    rel = os.path.relpath(root, BASE)
    for f in sorted(files):
        if not f.endswith('.html'):
            continue
        fp = os.path.join(root, f)
        with open(fp, 'rb') as fh:
            raw = fh.read()
        try:
            content = raw.decode('latin-1').encode('latin-1').decode('utf-8', errors='replace')
        except:
            content = raw.decode('latin-1', errors='replace')

        counts['total'] += 1
        if '\u00bfQu\u00e9 aprender\u00e1s' in content:
            counts['has_aprender'] += 1
        if 'panel-grid' in content:
            counts['has_panels'] += 1
        if 'paso-paso' in content:
            counts['has_pasos'] += 1
        if 'Resumen del m\u00f3dulo' in content:
            counts['has_resumen'] += 1

        missing = []
        if '\u00bfQu\u00e9 aprender\u00e1s' not in content:
            missing.append('aprender')
        if 'panel-grid' not in content:
            missing.append('panels')
        if 'paso-paso' not in content:
            missing.append('pasos')
        if 'Resumen del m\u00f3dulo' not in content:
            missing.append('resumen')
        if missing:
            print(f'MISSING {missing} in {rel}\\{f}')

print()
print(f'Summary: {counts["total"]} files total')
print(f'  \u00bfQu\u00e9 aprender\u00e1s: {counts["has_aprender"]}')
print(f'  panel-grid: {counts["has_panels"]}')
print(f'  paso-paso: {counts["has_pasos"]}')
print(f'  resumen: {counts["has_resumen"]}')
