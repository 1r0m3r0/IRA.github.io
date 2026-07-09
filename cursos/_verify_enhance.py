import os

base_dirs = [
    r'D:\poryectosPulidos\PAGINA\cursos\programa-sql-medio',
    r'D:\poryectosPulidos\PAGINA\cursos\programa-sql-avanzado',
]

passes = 0
fails = 0
details = []

for base_dir in base_dirs:
    prog = os.path.basename(base_dir)
    for course in sorted(os.listdir(base_dir)):
        course_path = os.path.join(base_dir, course)
        if not os.path.isdir(course_path):
            continue
        for fname in sorted(os.listdir(course_path)):
            if not fname.endswith('.html') or fname == 'index.html':
                continue
            fpath = os.path.join(course_path, fname)
            with open(fpath, 'r', encoding='utf-8') as f:
                c = f.read()

            style_end = c.find('</style>')
            css_ok = '.objectives' in c[:style_end] and '.module-recap' in c[:style_end]
            html_obj = '<div class="objectives">' in c
            html_recap = '<div class="module-recap">' in c

            if css_ok and html_obj and html_recap:
                passes += 1
            else:
                fails += 1
                details.append(f"  FAIL: {prog}/{course}/{fname} -> CSS:{css_ok} HTML_OBJ:{html_obj} HTML_RECAP:{html_recap}")

print(f"Passed: {passes}, Failed: {fails}")
for d in details:
    print(d)
