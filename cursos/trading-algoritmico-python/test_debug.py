import sys
sys.path.insert(0, r'D:\poryectosPulidos\PAGINA\cursos\trading-algoritmico-python')
import enhance_all

filepath = r'D:\poryectosPulidos\PAGINA\cursos\trading-algoritmico-python\curso-1-python-financiero\01-portal.html'

encodings = ['utf-8', 'latin-1', 'cp1252']
for enc in encodings:
    try:
        with open(filepath, 'r', encoding=enc) as f:
            c = f.read()
        has = 'enhance-section' in c
        print('{}: decodes OK, has enhance-section: {}'.format(enc, has))
        break
    except UnicodeDecodeError as e:
        print('{}: FAIL - {}'.format(enc, e))

result = enhance_all.process_file(filepath, '01', '#00e0ff', 'Python financiero')
print('process_file returned:', result)

# Check after
for enc in ['utf-8', 'latin-1', 'cp1252']:
    try:
        with open(filepath, 'r', encoding=enc) as f:
            c = f.read()
        has = 'enhance-section' in c
        print('After - {}: decodes OK, has enhance-section: {}'.format(enc, has))
        break
    except UnicodeDecodeError as e:
        print('After - {}: FAIL - {}'.format(enc, e))