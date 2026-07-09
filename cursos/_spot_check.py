f = r'D:\poryectosPulidos\PAGINA\cursos\programa-sql-medio\curso-1-window-functions\12-mini-proyecto.html'
with open(f, 'r', encoding='utf-8') as fh:
    c = fh.read()
s = c.find('</style>')
print('CSS .module-recap:', '.module-recap' in c[:s])
print('HTML .module-recap:', '<div class="module-recap">' in c)
rpos = c.find('<div class="module-recap">')
if rpos > 0:
    print('Recap found at position:', rpos)
    print('Preceding 100 chars:', repr(c[rpos-100:rpos]))
    print('Recap content:', c[rpos:rpos+300])
