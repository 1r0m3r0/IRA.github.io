// Phase 2: Convert all remaining unconverted feedback patterns to I18N.t() + I18N_DATA
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

// Translation map for common Spanish phrases
const enMap = {
  '🎉 ¡Perfecto!': '🎉 Perfect!',
  '🎉 ¡Excelente!': '🎉 Excellent!',
  '🎉 ¡Bien hecho!': '🎉 Well done!',
  '🎉 ¡LO LOGRASTE!': '🎉 YOU DID IT!',
  '🎉 ¡Lo lograste!': '🎉 You did it!',
  '✅ ¡Correcto!': '✅ Correct!',
  '✅ ¡Excelente!': '✅ Excellent!',
  '❌ Acertaste': '❌ You got',
  '😅 No es correcto': '😅 Not correct',
  '😊 ¡Así se hace!': '😊 Way to go!',
  '📚 Sigue practicando': '📚 Keep practicing',
  '¡Correcto!': 'Correct!',
  'Incorrecto': 'Incorrect',
  '¡Insignia desbloqueada!': 'Badge unlocked!',
  'Has completado': 'You completed',
  'Dominas': 'You mastered',
  'los fundamentos de': 'the fundamentals of',
  'Necesitas al menos': 'You need at least',
  '¡Intenta de nuevo!': 'Try again!',
  'para aprobar': 'to pass',
  'Casi': 'Almost',
  'La respuesta correcta es': 'The correct answer is',
  'Consulta correcta': 'Correct query',
  'Revisa': 'Review',
  'Acertaste': 'You got',
  'correctas': 'correct',
  'pregunta': 'question',
  'Puntuación': 'Score',
  'Aciertos': 'Hits',
  'Tiempo': 'Time',
};

function roughTranslate(es) {
  let en = es;
  for (const [esPhrase, enPhrase] of Object.entries(enMap)) {
    en = en.split(esPhrase).join(enPhrase);
  }
  return en;
}

function escapeJs(s) {
  return s.replace(/\\/g, '\\\\').replace(/'/g, "\\'").replace(/\n/g, '\\n').replace(/\r/g, '');
}

let modified = 0;
let skipped = 0;
let errors = 0;

for (const f of files) {
  let content = fs.readFileSync(f, 'utf-8');
  
  // Skip already converted files
  if (/I18N\.t\(['"]/.test(content)) { skipped++; continue; }
  
  // Find <script> blocks
  const scriptMatch = content.match(/<script>([\s\S]*?)<\/script>/);
  if (!scriptMatch) { skipped++; continue; }
  let scriptContent = scriptMatch[1];
  let originalScript = scriptContent;
  
  // Find all .innerHTML = ... lines that contain Spanish feedback
  const lines = scriptContent.split('\n');
  const replacements = []; // { from: fullLine, to: newLine, key: string }
  let fbIdx = 0;
  
  for (let li = 0; li < lines.length; li++) {
    const line = lines[li];
    const trimmed = line.trim();
    
    // Must contain .innerHTML assignment
    const innerMatch = trimmed.match(/(\w+\.innerHTML|document\.getElementById\(['"]\w+['"]\)\.innerHTML)\s*=\s*(.+)/);
    if (!innerMatch) continue;
    
    const lhs = innerMatch[1];
    const rhs = innerMatch[2].replace(/;$/, '');
    
    // Skip non-feedback assignments
    if (/quizArea|timerFill|badgeArea|container/.test(lhs)) continue;
    
    const fullAssign = lhs + ' = ' + rhs;
    
    // Check if it's a simple single-quoted string
    let simpleMatch = rhs.match(/^'([^']*)'$/);
    let templateMatch = rhs.match(/^`([^`]*)`$/);
    let concatMatch = rhs.match(/^'([^']*)'\s*\+/);
    
    let extracted = null;
    let isTemplate = false;
    let isConcat = false;
    
    if (simpleMatch) {
      extracted = simpleMatch[1];
    } else if (templateMatch) {
      extracted = templateMatch[1];
      isTemplate = true;
    } else if (trimmed.includes("' + ") || trimmed.includes("' +") || trimmed.includes("+ '")) {
      // String concatenation - try to extract just the first string part
      // Actually for concat we need to handle the whole expression
      isConcat = true;
    }
    
    if (!extracted && !isConcat) continue;
    
    // Check if extracted text is likely Spanish (has accented chars or Spanish words)
    if (extracted && !/[\u00e0-\u024f¡¿🎉✅❌😅😊📚⚠️🔥🏆⏰]/.test(extracted) && 
        !/^(¡|Correcto|Incorrecto|Necesitas|Revisa|Acertaste|Has completado|Dominas|Casi|Consulta)/.test(extracted)) {
      continue;
    }
    
    // Skip empty strings
    if (extracted && extracted.trim() === '') continue;
    
    const key = 'fb_' + fbIdx++;
    
    if (isConcat) {
      // Handle string concat: extract static parts and variable parts
      let rest = rhs;
      let parts = [];
      let varIdx = 0;
      
      // Extract the template structure
      // Pattern: 'static1' + var1 + 'static2' + var2 ...
      // or backtick template: `static ${var} static`
      
      if (trimmed.includes('`')) {
        // Backtick template - find the complete template
        const btMatch = trimmed.match(/`([^`]*)`/);
        if (btMatch) {
          const tpl = btMatch[1];
          // Replace ${var} with {N} placeholders
          const varParts = tpl.split(/\$\{[^}]+\}/);
          const varNames = tpl.match(/\$\{[^}]+\}/g) || [];
          let result = '';
          for (let i = 0; i < varParts.length; i++) {
            result += varParts[i];
            if (i < varNames.length) result += '{' + i + '}';
          }
          
          // Build the .replace() chain
          let replaceChain = '';
          for (let i = 0; i < varNames.length; i++) {
            const vname = varNames[i].replace(/^\$\{/, '').replace(/\}$/, '');
            replaceChain += `.replace('{${i}}',${vname})`;
          }
          
          replacements.push({
            from: trimmed,
            to: `${lhs}=I18N.t('${key}')${replaceChain};`,
            key: key,
            es: result,
            en: roughTranslate(result)
          });
        }
      } else {
        // Single-quote concatenation
        // Find all static string parts
        const parts = [];
        let remaining = rhs;
        let fullStatic = '';
        let staticParts = [];
        let varParts = [];
        
        // Try to parse: 'static' + var + 'static' + var2 ...
        const sqRegex = /'([^']*)'\s*\+\s*([^+]+?)(?=\s*\+\s*'|$)/g;
        let m;
        while ((m = sqRegex.exec(rhs)) !== null) {
          staticParts.push(m[1]);
          varParts.push(m[2].trim());
        }
        
        // Also handle trailing static part after last variable
        const lastPlus = rhs.lastIndexOf("+ '");
        if (lastPlus >= 0) {
          const trail = rhs.substring(lastPlus + 1).trim();
          const trailMatch = trail.match(/^'([^']*)'/);
          if (trailMatch) {
            staticParts.push(trailMatch[1]);
          }
        }
        
        // Handle case with only one static part
        if (staticParts.length === 0) {
          // Try simpler pattern: 'static ' + var
          const simpleConcat = rhs.match(/^'([^']*)'\s*\+\s*(.+)/);
          if (simpleConcat) {
            staticParts = [simpleConcat[1]];
            varParts = [simpleConcat[2].trim()];
          }
        }
        
        if (staticParts.length > 0) {
          let result = staticParts[0] || '';
          for (let i = 0; i < varParts.length; i++) {
            const vp = varParts[i].replace(/;$/, '');
            // Check if the variable part includes a subsequent static part
            const nextStatic = staticParts[i + 1];
            if (nextStatic !== undefined) {
              result += '{' + i + '}' + nextStatic;
            } else {
              // If no next static part, the variable might include trailing text
              // Check if there's more in the original line after the last found match
              if (i === varParts.length - 1 && i < staticParts.length - 1) {
                result += '{' + i + '}';
              }
            }
          }
          
          // Build replace chain
          let replaceChain = '';
          for (let i = 0; i < varParts.length; i++) {
            const vp = varParts[i].replace(/;$/, '');
            replaceChain += `.replace('{${i}}',${vp})`;
          }
          
          if (result) {
            replacements.push({
              from: trimmed,
              to: `${lhs}=I18N.t('${key}')${replaceChain};`,
              key: key,
              es: result,
              en: roughTranslate(result)
            });
          }
        }
      }
    } else if (extracted) {
      // Simple string or template literal without variables
      replacements.push({
        from: trimmed,
        to: `${lhs}=I18N.t('${key}');`,
        key: key,
        es: extracted,
        en: roughTranslate(extracted)
      });
    }
  }
  
  if (replacements.length === 0) { skipped++; continue; }
  
  // Apply replacements to script content
  for (const r of replacements) {
    scriptContent = scriptContent.split(r.from).join(r.to);
  }
  
  // Generate I18N_DATA block
  let dataEntries = [];
  for (const r of replacements) {
    dataEntries.push(`  '${r.key}': { es: '${escapeJs(r.es)}', en: '${escapeJs(r.en)}' }`);
  }
  const i18nDataBlock = `\nwindow.I18N_DATA={\n${dataEntries.join(',\n')}\n};`;
  
  // Find where to insert I18N_DATA - after the i18n.js script tag
  // Or at the end of the main script block
  const i18nScriptTag = '<script src="';
  const i18nPos = content.indexOf(i18nScriptTag, content.lastIndexOf('</script>'));
  
  if (i18nPos >= 0) {
    // Insert before the i18n.js script tag
    const insertionPoint = content.lastIndexOf('</script>', i18nPos);
    if (insertionPoint >= 0) {
      const beforeTag = content.lastIndexOf('<script', insertionPoint - 1);
      if (beforeTag >= 0) {
        content = content.substring(0, beforeTag) + i18nDataBlock + '\n' + content.substring(beforeTag);
      } else {
        content = content.substring(0, insertionPoint) + i18nDataBlock + '\n' + content.substring(insertionPoint);
      }
    } else {
      content = content.replace(scriptMatch[1], i18nDataBlock + '\n' + scriptMatch[1]);
    }
  } else {
    // No i18n.js script tag - insert after the last script block
    content = content.replace(scriptMatch[1], i18nDataBlock + '\n' + scriptMatch[1]);
  }
  
  // Write the modified file
  fs.writeFileSync(f, content, 'utf-8');
  modified++;
  
  if (modified <= 5) {
    console.log(`\n=== Modified: ${path.basename(f)} ===`);
    for (const r of replacements) {
      console.log(`  ${r.key}: "${r.es.substring(0, 60)}..."`);
    }
  }
}

console.log(`\n=== Phase 2 Complete ===`);
console.log(`Modified: ${modified}`);
console.log(`Skipped (already conv / no feedback): ${skipped}`);
console.log(`Errors: ${errors}`);
