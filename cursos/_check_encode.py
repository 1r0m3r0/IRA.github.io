import os

files = [
    r'D:\poryectosPulidos\PAGINA\cursos\programa-sql-medio\curso-1-window-functions\12-mini-proyecto.html',
    r'D:\poryectosPulidos\PAGINA\cursos\programa-sql-medio\curso-2-ctes\03-ctes-vs-subconsultas.html',
    r'D:\poryectosPulidos\PAGINA\cursos\programa-sql-medio\curso-2-ctes\12-mini-proyecto.html',
    r'D:\poryectosPulidos\PAGINA\cursos\programa-sql-medio\curso-3-indices\12-mini-proyecto.html',
]

for fpath in files:
    with open(fpath, 'rb') as f:
        raw = f.read()
    # Try to decode, find issues
    try:
        text = raw.decode('utf-8')
        print(f"OK: {os.path.basename(fpath)} - UTF-8")
    except UnicodeDecodeError as e:
        print(f"ERR: {os.path.basename(fpath)} - {e}")
        # Try windows-1252
        try:
            text = raw.decode('windows-1252')
            print(f"  -> Can decode as windows-1252")
        except:
            print(f"  -> Not windows-1252 either")
