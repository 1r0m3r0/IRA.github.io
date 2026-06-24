const fs = require('fs');
const path = require('path');

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

let converted = 0, simplePattern = 0, templateLit = 0, concatPattern = 0, noFB = 0;
const detail = {};

for (const f of files) {
  const content = fs.readFileSync(f, 'utf-8');
  if (/I18N\.t\(['"]/.test(content)) { converted++; continue; }

  let fbLines = content.match(/fb\.innerHTML\s*=\s*.+/g) || [];
  fbLines = fbLines.filter(l => !/quizArea|timerFill|badgeArea/.test(l));
  
  let feedbackElLines = content.match(/feedbackEl\.innerHTML\s*=\s*.+/g) || [];
  let resultDivLines = content.match(/resultDiv\.innerHTML\s*=\s*.+/g) || [];
  let getEbfLines = content.match(/document\.getElementById\(['"]feedback['"]\)\.innerHTML\s*=\s*.+/g) || [];
  
  const allLines = [...fbLines, ...feedbackElLines, ...resultDivLines, ...getEbfLines];
  
  if (allLines.length === 0) { noFB++; continue; }

  let hasTemplate = false, hasConcat = false, hasSimple = false;
  for (const l of allLines) {
    if (l.includes('`')) hasTemplate = true;
    else if (l.includes('+')) hasConcat = true;
    else hasSimple = true;
  }

  if (hasTemplate) templateLit++;
  if (hasConcat) concatPattern++;
  if (hasSimple) simplePattern++;
}

console.log(`Total files: ${files.length}`);
console.log(`Already converted: ${converted}`);
console.log(`No feedback innerHTML: ${noFB}`);
console.log(`Has template literals: ${templateLit}`);
console.log(`Has string concat: ${concatPattern}`);
console.log(`Has simple strings: ${simplePattern}`);
console.log(`\nNote: files can have multiple pattern types`);
