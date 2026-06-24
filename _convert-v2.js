// v2: Convert all hardcoded Spanish feedback strings to I18N.t() + I18N_DATA
const fs = require('fs');
const path = require('path');

const root = 'D:\\poryectosPulidos\\PAGINA\\cursos';

// Gather all module files
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
let skippedNoFeedback = 0;
let skippedOther = 0;

for (const f of files) {
  let content = fs.readFileSync(f, 'utf-8');
  
  // Skip already converted
  if (/I18N\.t\(['"]/.test(content)) { skippedAlready++; continue; }
  
  // Find the last <script> block (where quiz logic typically is)
  const scriptMatch = content.match(/<script>([\s\S]*?)<\/script>\s*(?:<script src=["'].*?i18n.*?["']>)?\s*<\/body>/);
  if (!scriptMatch) { skippedNoFeedback++; continue; }
  
  const scriptTag = scriptMatch[0];
  const scriptBody = scriptMatch[1];
  
  // Find all innerHTML assignments in the script body
  // We'll work with the original content and do replacements
  let modifiedScript = scriptBody;
  const fbStrings = [];
  let keyIdx = 0;
  
  // Pattern: varName.innerHTML = 'text'  OR  = "text"  OR  = `text`
  const innerHTMLRegex = /(\w+)\.innerHTML\s*=\s*(['"`])([^]?)\2/g;
  const docByIdRegex = /document\.getElementById\(['"](\w+)['"]\)\.innerHTML\s*=\s*(['"`])([^]?)\2/g;
  
  // More flexible: find all .innerHTML = ... patterns and parse the RHS
  const allMatches = [...modifiedScript.matchAll(/(\w+)\.innerHTML\s*=\s*(['"`])(.*?)\2\s*[;,\n\)]/gs)];
  const docMatches = [...modifiedScript.matchAll(/document\.getElementById\(['"](\w+)['"]\)\.innerHTML\s*=\s*(['"`])(.*?)\2\s*[;,\n\)]/gs)];
  
  const combined = [...allMatches, ...docMatches.map(m => [m[0], m[1], m[2], m[3], m.index])];
  
  let replacements = [];
  
  for (const m of combined) {
    const fullMatch = m[0];
    const varName = m[1] || m[0]; // varName or doc
    const quote = m[2];
    const text = m[3];
    
    if (!text || text.trim() === '') continue;
    
    // Check if it's feedback-like content (has Spanish chars, emoji, or is a known feedback phrase)
    const isFeedback = /[\u00e0-\u024f¡¿🎉✅❌😅😊📚⚠️🔥🏆⏰💡📊📈]/.test(text) ||
      /^(¡|Correcto|Incorrecto|Necesitas|Revisa|Acertaste|Has completado|Dominas|Casi|Consulta)/.test(text) ||
      /(Correcto|Incorrecto|acertaste|perfecto|excelente|intenta|revisa)/i.test(text);
    
    if (!isFeedback) continue;
    
    // Skip non-feedback variable names
    if (/^(quizArea|timerFill|badgeArea|pool|el|d|container)$/.test(varName)) continue;
    
    const key = 'fb_' + (keyIdx++);
    fbStrings.push({ key, text, varName, quote, fullMatch });
  }
  
  if (fbStrings.length === 0) { skippedNoFeedback++; continue; }
  
  // Now build I18N_DATA and replacements
  let dataEntries = [];
  for (const s of fbStrings) {
    const es = s.text;
    const en = roughTranslate(es);
    dataEntries.push(`  '${s.key}': { es: '${escapeStr(es)}', en: '${escapeStr(en)}' }`);
    
    // Build replacement regex
    // Replace: varName.innerHTML = 'text'  →  varName.innerHTML = I18N.t('key')
    const escapedText = es.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    const pattern = new RegExp(
      `(${s.varName}\\.innerHTML\\s*=\\s*['\`])${escapedText}(['\`])`
    );
    
    const replacement = `$1I18N.t('${s.key}')$2`;
    modifiedScript = modifiedScript.replace(pattern, replacement);
  }
  
  // If no replacements were made (regex didn't match), skip
  if (modifiedScript === scriptBody) { skippedOther++; continue; }
  
  // Insert I18N_DATA before the last script tag
  const i18nDataBlock = `\nwindow.I18N_DATA={\n${dataEntries.join(',\n')}\n};`;
  
  // Insert right before the script tag that loads i18n.js, or at end of script body
  const scriptEnd = scriptTag.lastIndexOf('</script>');
  const newScriptTag = scriptTag.substring(0, scriptEnd) + i18nDataBlock + scriptTag.substring(scriptEnd);
  
  content = content.replace(scriptTag, newScriptTag);
  
  // Replace script body with modified version
  content = content.replace(scriptBody, modifiedScript);
  
  fs.writeFileSync(f, content, 'utf-8');
  modified++;
  
  if (modified <= 3) {
    console.log(`\n=== ${path.basename(f)} (${fbStrings.length} strings) ===`);
    for (const s of fbStrings) {
      console.log(`  ${s.key}: "${s.text.substring(0, 80)}..."`);
    }
  }
}

console.log(`\n=== Complete ===`);
console.log(`Modified: ${modified}`);
console.log(`Skipped (already): ${skippedAlready}`);
console.log(`Skipped (no feedback): ${skippedNoFeedback}`);
console.log(`Skipped (no match): ${skippedOther}`);
