// Convert template literal feedback patterns to I18N.t() + .replace() chains
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

const enMap = {
  '❌ Acertaste': '❌ You got',
  'Acertaste': 'You got',
  'Revisa': 'Review',
  'de': 'out of',
  '¡Perfecto!': 'Perfect!',
  '¡Excelente!': 'Excellent!',
  '¡Bien hecho!': 'Well done!',
  'Dominas': 'You mastered',
  'los fundamentos de': 'the fundamentals of',
  '¡Insignia desbloqueada!': 'Badge unlocked!',
};

function roughTranslate(es) {
  let en = es;
  for (const [k, v] of Object.entries(enMap)) en = en.split(k).join(v);
  return en;
}

function escapeStr(s) {
  return s.replace(/\\/g, '\\\\').replace(/'/g, "\\'").replace(/\n/g, '\\n').replace(/\r/g, '');
}

let modified = 0;
let skipped = 0;

for (const f of files) {
  let content = fs.readFileSync(f, 'utf-8');
  
  // Only process files that already have I18N.t() (already have I18N_DATA from v5)
  if (!/I18N\.t\(['"]/.test(content)) { skipped++; continue; }
  
  // Find existing I18N_DATA to append to
  const dataMatch = content.match(/window\.I18N_DATA\s*=\s*\{([\s\S]*?)\};/);
  if (!dataMatch) { skipped++; continue; }
  
  let existingData = dataMatch[1];
  const dataStart = dataMatch.index;
  const dataEnd = dataStart + dataMatch[0].length;
  
  // Find backtick template literals in the script AFTER the I18N_DATA block
  // These are the unconverted feedback strings
  const afterData = content.substring(dataEnd);
  
  // Find fb.innerHTML = `...` patterns
  const tplRegex = /fb\.innerHTML\s*=\s*`((?:[^`\\$]|\\.|\$\{[^}]*\})*)`/g;
  let tplMatch;
  let replacements = [];
  let keyIdx = 0;
  
  // Get the highest existing key index
  const existingKeys = content.match(/fb_(\d+)/g) || [];
  const maxKey = existingKeys.reduce((max, k) => {
    const n = parseInt(k.replace('fb_', ''));
    return n > max ? n : max;
  }, -1);
  keyIdx = maxKey + 1;
  
  while ((tplMatch = tplRegex.exec(content)) !== null) {
    const fullMatch = tplMatch[0];
    const tplContent = tplMatch[1];
    
    // Skip non-feedback templates
    if (!/❌|🎉|✅|Acertaste|Revisa|Perfecto|Excelente/i.test(tplContent)) continue;
    
    // Parse template: split by ${...}
    const parts = tplContent.split(/\$\{[^}]+\}/);
    const vars = tplContent.match(/\$\{[^}]+\}/g) || [];
    
    // Build static string with {N} placeholders
    let staticStr = '';
    for (let i = 0; i < parts.length; i++) {
      staticStr += parts[i];
      if (i < vars.length) staticStr += '{' + i + '}';
    }
    
    // Build .replace() chain
    let replaceChain = '';
    for (let i = 0; i < vars.length; i++) {
      const expr = vars[i].replace(/^\$\{/, '').replace(/\}$/, '');
      replaceChain += `.replace('{${i}}',${expr})`;
    }
    
    const key = 'fb_' + (keyIdx++);
    const enText = roughTranslate(staticStr);
    
    replacements.push({
      from: fullMatch,
      to: `fb.innerHTML=I18N.t('${key}')${replaceChain}`,
      key,
      es: staticStr,
      en: enText
    });
  }
  
  if (replacements.length === 0) { skipped++; continue; }
  
  // Apply replacements to content
  let newContent = content;
  for (const r of replacements) {
    newContent = newContent.replace(r.from, r.to);
  }
  
  // Append to existing I18N_DATA (before the closing };)
  const dataClose = newContent.indexOf('};', dataStart);
  if (dataClose >= 0) {
    const newEntries = replacements.map(r =>
      `  '${r.key}': { es: '${escapeStr(r.es)}', en: '${escapeStr(r.en)}' }`
    ).join(',\n');
    newContent = newContent.slice(0, dataClose) + ',\n' + newEntries + '\n' + newContent.slice(dataClose);
  }
  
  fs.writeFileSync(f, newContent, 'utf-8');
  modified++;
  
  if (modified <= 3) {
    console.log(`\n${path.basename(f)} (${replacements.length} tpl strings):`);
    for (const r of replacements) {
      console.log(`  ${r.key}: "${r.es.substring(0, 80)}"`);
    }
  }
}

console.log(`\n=== Complete ===`);
console.log(`Modified: ${modified}`);
console.log(`Skipped (no I18N.t or no data): ${skipped}`);
