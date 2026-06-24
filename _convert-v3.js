// v3: Simple, robust conversion
// For each file, find .innerHTML = 'spanish text' or = "text" patterns
// Extract text, create I18N_DATA, replace with I18N.t() calls
// Uses content.indexOf() for reliable matching

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
  '🎉 ¡Perfecto!': '🎉 Perfect!',
  '🎉 ¡Excelente!': '🎉 Excellent!',
  '🎉 ¡Bien hecho!': '🎉 Well done!',
  '🎉 ¡LO LOGRASTE!': '🎉 YOU DID IT!',
  '✅ ¡Correcto!': '✅ Correct!',
  '❌ Acertaste': '❌ You got',
  '😅 No es correcto': '😅 Not correct',
  '😊 ¡Así se hace!': '😊 Way to go!',
  '📚 Sigue practicando': '📚 Keep practicing',
  '¡Correcto!': 'Correct!',
  '¡correcto!': 'correct!',
  'Incorrecto.': 'Incorrect.',
  'Incorrecto': 'Incorrect',
  '¡Insignia desbloqueada!': 'Badge unlocked!',
  'Has completado': 'You completed',
  'Dominas': 'You mastered',
  'los fundamentos de': 'the fundamentals of',
  'Necesitas al menos': 'You need at least',
  '¡Intenta de nuevo!': 'Try again!',
  'para aprobar': 'to pass',
  'Casi.': 'Almost.',
  'Casi': 'Almost',
  'La respuesta correcta es': 'The correct answer is',
  'Consulta correcta.': 'Correct query.',
  'Revisa': 'Review',
  'Acertaste': 'You got',
  'Puntuación': 'Score',
  'Aciertos': 'Correct',
  'Tiempo': 'Time',
  '¡Bien!': 'Great!',
  '¡Cerca!': 'Close!',
  '¡Respuesta correcta!': 'Correct answer!',
  '¡Sigue así!': 'Keep it up!',
  '¡Sigue aprendiendo!': 'Keep learning!',
  'Has ganado la insignia': 'You earned the badge',
  'Puedes seguir experimentando': 'You can keep experimenting',
  'o avanzar al siguiente módulo': 'or move to the next module',
};

function roughTranslate(es) {
  let en = es;
  for (const [k, v] of Object.entries(enMap)) {
    en = en.split(k).join(v);
  }
  return en;
}

function escapeStr(s) {
  return s.replace(/\\/g, '\\\\').replace(/'/g, "\\'").replace(/\n/g, '\\n').replace(/\r/g, '');
}

let modified = 0;
let skippedAlready = 0;
let skippedNoMatch = 0;

for (const f of files) {
  let content = fs.readFileSync(f, 'utf-8');
  
  if (/I18N\.t\(['"]/.test(content)) { skippedAlready++; continue; }
  
  // Find all innerHTML assignments with string literals
  // Match pattern: .innerHTML = 'TEXT'  or  .innerHTML = "TEXT"  
  // Or document.getElementById('x').innerHTML = 'TEXT'
  // Handle template literals too: .innerHTML = `TEXT${var}TEXT`
  
  const reSimple = /\.innerHTML\s*=\s*'([^']*(?:''[^']*)*)'/g;
  const reDQuote = /\.innerHTML\s*=\s*"([^"]*)"/g;
  const reBacktick = /\.innerHTML\s*=\s*`([^`]*)`/g;
  
  const allTexts = [];
  let match;
  
  // Single-quoted strings
  while ((match = reSimple.exec(content)) !== null) {
    const text = match[1];
    const fullMatch = match[0];
    if (!text || text.trim() === '') continue;
    // Check if it's Spanish feedback
    if (!/[\u00e0-\u024f¡¿🎉✅❌😅😊📚⚠️🔥🏆⏰💡📊📈]/.test(text) &&
        !/^(¡|Correcto|Incorrecto|Necesitas|Revisa|Acertaste|Has completado|Dominas|Casi|Consulta)/.test(text) &&
        !/(Correcto|Incorrecto|acertaste|perfecto|excelente|intenta|revisa)/i.test(text)) continue;
    // Skip non-feedback like 'quizArea', 'timerFill', badges, etc
    if (/^(quizArea|timerFill|badgeArea|container|pool)$/.test(text)) continue;
    
    allTexts.push({ text, fullMatch, quote: "'" });
  }
  
  // Double-quoted strings
  while ((match = reDQuote.exec(content)) !== null) {
    const text = match[1];
    const fullMatch = match[0];
    if (!text || text.trim() === '') continue;
    if (!/[\u00e0-\u024f¡¿🎉✅❌😅😊📚]/.test(text) &&
        !/^(¡|Correcto|Incorrecto|Necesitas|Revisa|Acertaste|Has completado|Dominas)/.test(text)) continue;
    allTexts.push({ text, fullMatch, quote: '"' });
  }
  
  if (allTexts.length === 0) { skippedNoMatch++; continue; }
  
  // Sort matches by position in reverse order (last to first)
  // This way replacements don't shift indices
  // Actually, we use string.replace() which handles it
  
  // Create I18N_DATA entries
  let dataEntries = [];
  let newContent = content;
  
  for (let i = 0; i < allTexts.length; i++) {
    const s = allTexts[i];
    const key = 'fb_' + i;
    const en = roughTranslate(s.text);
    dataEntries.push(`  '${key}': { es: '${escapeStr(s.text)}', en: '${escapeStr(en)}' }`);
    
    // Replace in content
    const oldStr = s.fullMatch;
    const newStr = s.fullMatch.replace(/=['"`]/, "=I18N.t('" + key + "')");
    newContent = newContent.replace(oldStr, newStr);
  }
  
  // Insert I18N_DATA after the main script tag
  const i18nDataBlock = `\nwindow.I18N_DATA={\n${dataEntries.join(',\n')}\n};`;
  
  // Find the best insertion point
  // Look for the script tag that loads i18n.js
  const i18nScriptIdx = newContent.indexOf('<script src="');
  const lastScriptClose = newContent.lastIndexOf('</script>');
  
  if (i18nScriptIdx >= 0) {
    // Insert before the i18n.js script
    const beforeI18n = newContent.lastIndexOf('<script', i18nScriptIdx - 1);
    if (beforeI18n >= 0) {
      newContent = newContent.slice(0, beforeI18n) + i18nDataBlock + '\n' + newContent.slice(beforeI18n);
    } else {
      newContent = newContent.slice(0, i18nScriptIdx) + i18nDataBlock + '\n' + newContent.slice(i18nScriptIdx);
    }
  } else if (lastScriptClose >= 0) {
    newContent = newContent.slice(0, lastScriptClose) + i18nDataBlock + '\n' + newContent.slice(lastScriptClose);
  } else {
    newContent += '\n' + i18nDataBlock;
  }
  
  fs.writeFileSync(f, newContent, 'utf-8');
  modified++;
  
  if (modified <= 3) {
    console.log(`\n${path.basename(f)} (${allTexts.length} strings):`);
    for (const s of allTexts) {
      console.log(`  ${s.text.substring(0, 100)}`);
    }
  }
}

console.log(`\n=== Complete ===`);
console.log(`Modified: ${modified}`);
console.log(`Skipped (already I18N.t): ${skippedAlready}`);
console.log(`Skipped (no feedback texts found): ${skippedNoMatch}`);
