import re
with open(r'D:\poryectosPulidos\PAGINA\cursos\trading-algoritmico-python\curso-1-python-financiero\02-variables-tipos.html', 'rb') as f:
    raw = f.read()
text = raw.decode('latin-1')

# Find Codigo or Código
for m in re.finditer(r'C.gi.o|Codigo', text):
    start = max(0, m.start()-10)
    print('Found at {}: {}'.format(m.start(), repr(text[m.start():m.end()+60])))

# Count enhance sections
idx = text.find('class="enhance-section"')
count = 0
while idx >= 0:
    count += 1
    end = text.find('</div>', idx)
    h3 = text.find('<h3>', idx, end)
    if h3 >= 0:
        h3end = text.find('</h3>', h3)
        print('  Section {}: {}'.format(count, text[h3:h3end+5]))
    else:
        print('  Section {}: NO H3'.format(count))
    idx = text.find('class="enhance-section"', end)

print('Total enhance sections:', count)