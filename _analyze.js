const fs = require('fs');
const path = require('path');
const glob = require('fs').readdirSync;

const root = 'D:\\poryectosPulidos\\PAGINA\\cursos';
const files = [];

function walk(dir) {
  const entries = fs.readdirSync(dir, { withFileTypes: true });
  for (const e of entries) {
    const full = path.join(dir, e.name);
    if (e.isDirectory()) walk(full);
    else if (e.name.endsWith('.html') && e.name !== 'index.html') files.push(full);
  }
}
walk(root);

let total = 0;
const patterns = { simple: 0, htmlWrapped: 0, emoji: 0, template: 0, concat: 0, other: 0, alreadyI18n: 0, noFeedback: 0 };
const samples = [];

for (const f of files) {
  const content = fs.readFileSync(f, 'utf-8');
  if (content.includes("I18N.t('")) { patterns.alreadyI18n++; continue; }

  const lines = content.split('\n');
  let found = false;

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i].trim();

    // Skip non-feedback lines
    if (!line.includes('.innerHTML') && !line.includes('.innerHTML')) continue;
    if (line.includes('quizArea') || line.includes('timerFill') || line.includes('badgeArea')) continue;

    // Match various feedback patterns
    if (line.match(/\.innerHTML\s*=\s*'[^']*'/)) {
      found = true;
      if (line.includes('¡Correcto!') || line.includes('¡correcto!') || line.includes('Correcto') && !line.includes('Acertaste')) {
        if (line.includes('<i class')) { patterns.htmlWrapped++; }
        else { patterns.simple++; }
      } else if (line.includes('Incorrecto') || line.includes('incorrecto')) {
        if (line.includes('<i class')) { patterns.htmlWrapped++; }
        else { patterns.simple++; }
      } else if (line.includes('🎉') || line.includes('✅') || line.includes('❌') || line.includes('😅') || line.includes('😊') || line.includes('📚')) {
        patterns.emoji++;
        if (samples.length < 10) samples.push({ file: f, line: line.substring(0, 150), type: 'emoji' });
      } else if (line.includes('${')) {
        patterns.template++;
      } else if (line.includes('+')) {
        patterns.concat++;
      } else {
        patterns.other++;
        if (samples.length < 10) samples.push({ file: f, line: line.substring(0, 150), type: 'other' });
      }
    }
  }
  if (!found) patterns.noFeedback++;
  total++;
}

console.log(`Total module files: ${total}`);
console.log(`\nPattern breakdown:`);
for (const [k, v] of Object.entries(patterns)) {
  console.log(`  ${k}: ${v}`);
}
console.log(`\nSample lines:`);
for (const s of samples) {
  console.log(`\n[${s.type}] ${path.basename(path.dirname(s.file))}/${path.basename(s.file)}`);
  console.log(`  ${s.line}`);
}
