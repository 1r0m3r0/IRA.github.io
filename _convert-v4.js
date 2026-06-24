// v4: Single-pass regex replacement with callback
// Uses one regex to find all .innerHTML = /.../ patterns
// Replacement callback builds I18N_DATA and returns I18N.t() call

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
  for (const [k, v] of Object.entries(enMap)) en = en.split(k).join(v);
  return en;
}

function escapeStr(s) {
  return s.replace(/\\/g, '\\\\').replace(/'/g, "\\'").replace(/\n/g, '\\n').replace(/\r/g, '');
}

function isFeedbackText(text) {
  return /[\u00e0-\u024f¡¿🎉✅❌😅😊📚⚠️🔥🏆⏰💡📊📈]/.test(text) ||
    /^(¡|Correcto|Incorrecto|Necesitas|Revisa|Acertaste|Has completado|Dominas|Casi|Consulta|💡|⚠️|🔥|🏆)/.test(text) ||
    /(correcto|incorrecto|acertaste|perfecto|excelente|intenta|revisa|insignia|completaste|lograste)/i.test(text);
}

let modified = 0;
let skippedAlready = 0;
let skippedNoMatch = 0;

for (const f of files) {
  let content = fs.readFileSync(f, 'utf-8');
  
  if (/I18N\.t\(['"]/.test(content)) { skippedAlready++; continue; }
  
  const replacements = [];
  let keyIdx = 0;
  
  // Regex for .innerHTML = '...' (single quotes, including escaped quotes)
  // Capture: full match, quote char, text content
  const reInner = /((?:\w+\.innerHTML|document\.getElementById\(['"]\w+['"]\)\.innerHTML)\s*=\s*)(['"`])((?:(?!\2)[^])*?)\2/g;
  
  let newContent = content;
  
  // Use replace with callback for single-quote and double-quote strings
  // The callback returns the replacement AND tracks what was replaced
  const replacementsToApply = [];
  
  newContent = newContent.replace(
    /((?:\w+\.innerHTML|document\.getElementById\(['"]\w+['"]\)\.innerHTML)\s*=\s*)'((?:[^'\\]|\\.)*)'/g,
    (match, prefix, text) => {
      if (!isFeedbackText(text)) return match;
      const key = 'fb_' + (keyIdx++);
      replacementsToApply.push({ key, text, en: roughTranslate(text) });
      return prefix + "I18N.t('" + key + "')";
    }
  );
  
  // Handle double-quoted strings
  newContent = newContent.replace(
    /((?:\w+\.innerHTML|document\.getElementById\(['"]\w+['"]\)\.innerHTML)\s*=\s*)"((?:[^"\\]|\\.)*)"/g,
    (match, prefix, text) => {
      if (!isFeedbackText(text)) return match;
      const key = 'fb_' + (keyIdx++);
      replacementsToApply.push({ key, text, en: roughTranslate(text) });
      return prefix + "I18N.t('" + key + "')";
    }
  );
  
  if (replacementsToApply.length === 0) { skippedNoMatch++; continue; }
  
  // Build I18N_DATA block
  const dataLines = replacementsToApply.map(s =>
    `  '${s.key}': { es: '${escapeStr(s.text)}', en: '${escapeStr(s.en)}' }`
  );
  const i18nDataBlock = `\nwindow.I18N_DATA={\n${dataLines.join(',\n')}\n};`;
  
  // Insert I18N_DATA before the i18n.js script tag, or at end of last script block
  const i18nScriptIdx = newContent.indexOf('<script src="');
  if (i18nScriptIdx >= 0) {
    // Find the opening <script> before the i18n.js reference
    const beforeScript = newContent.lastIndexOf('<script', i18nScriptIdx - 1);
    if (beforeScript >= 0) {
      newContent = newContent.slice(0, beforeScript) + i18nDataBlock + '\n' + newContent.slice(beforeScript);
    } else {
      newContent = newContent.slice(0, i18nScriptIdx) + i18nDataBlock + '\n' + newContent.slice(i18nScriptIdx);
    }
  } else {
    // Find last script block
    const lastClose = newContent.lastIndexOf('</script>');
    if (lastClose >= 0) {
      newContent = newContent.slice(0, lastClose) + i18nDataBlock + '\n' + newContent.slice(lastClose);
    } else {
      newContent += '\n' + i18nDataBlock;
    }
  }
  
  fs.writeFileSync(f, newContent, 'utf-8');
  modified++;
  
  if (modified <= 3) {
    console.log(`\n${path.basename(f)} (${replacementsToApply.length} strings):`);
    for (const s of replacementsToApply.slice(0, 5)) {
      console.log(`  ${s.key}: "${s.text.substring(0, 80)}"`);
    }
  }
}

console.log(`\n=== Complete ===`);
console.log(`Modified: ${modified}`);
console.log(`Skipped (already I18N.t): ${skippedAlready}`);
console.log(`Skipped (no feedback): ${skippedNoMatch}`);
