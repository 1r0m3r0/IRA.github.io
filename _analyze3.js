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

// Collect all unique variable names used with .innerHTML = in feedback context
const varNames = {};
const sampleLines = {};
let unconvertedWithFeedback = 0;
let hasNoScript = 0;

for (const f of files) {
  const content = fs.readFileSync(f, 'utf-8');
  if (/I18N\.t\(['"]/.test(content)) continue;
  
  // Find all .innerHTML assignments
  const matches = content.matchAll(/\.innerHTML\s*=\s*.+/g);
  let count = 0;
  for (const m of matches) {
    const line = m[0].trim();
    // Skip non-feedback assignments
    if (/quizArea|timerFill|badgeArea|container\.innerHTML|\.innerHTML\s*=\s*['"]\s*['"]/.test(line)) continue;
    if (/\.innerHTML\s*=\s*['"][<>]/.test(line)) continue; // innerHTML = '< or "<
    
    // Extract the variable name before .innerHTML
    const varMatch = line.match(/(\w+)\.innerHTML\s*=/);
    if (varMatch) {
      const vname = varMatch[1];
      if (!varNames[vname]) varNames[vname] = 0;
      varNames[vname]++;
      
      if (!sampleLines[vname] && count < 2) {
        sampleLines[vname] = line.substring(0, 150);
        count++;
      }
    }
  }
}

// Print out all variable names used
const sorted = Object.entries(varNames).sort((a, b) => b[1] - a[1]);
console.log("Variable names used with .innerHTML in unconverted files:");
for (const [name, cnt] of sorted) {
  console.log(`  ${name}: ${cnt} occurrences`);
  if (sampleLines[name]) {
    console.log(`    e.g.: ${sampleLines[name]}`);
  }
}
