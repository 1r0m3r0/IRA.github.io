#!/usr/bin/env python3
import os, glob
base = r'D:\poryectosPulidos\PAGINA\cursos\programa-marketing-digital'
html_files = glob.glob(os.path.join(base, '**', '*.html'), recursive=True)
total = 0
enhanced = 0
for f in sorted(html_files):
    bn = os.path.basename(f)
    if bn == 'index.html':
        continue
    total += 1
    with open(f, 'rb') as fp:
        raw = fp.read()
    c = raw.decode('utf-8', errors='replace')
    sections = {
        'objectives': '<div class="objectives"' in c,
        'info-panels': '<div class="info-panels"' in c,
        'step': '<div class="step-section"' in c,
        'quiz': '<div class="quiz-section"' in c,
        'summary': '<div class="summary-section"' in c,
        'quiz-js': 'checkLearningBtn' in c,
    }
    if all(sections.values()):
        enhanced += 1
    else:
        missing = [k for k, v in sections.items() if not v]
        print(f'MISSING in {os.path.relpath(f, base)}: {missing}')

print(f'\nTotal: {total}, Fully enhanced: {enhanced}')
