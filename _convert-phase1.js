// Phase 1: Handle simple exact-match patterns across ALL module files
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

const replacements = [
  // Simple correct/incorrect - exact matches
  { from: "fb.innerHTML='¡Correcto!';", to: "fb.innerHTML=I18N.t('feedback_correcto');" },
  { from: 'fb.innerHTML="¡Correcto!";', to: "fb.innerHTML=I18N.t('feedback_correcto');" },
  { from: "fb.innerHTML = '¡Correcto!';", to: "fb.innerHTML = I18N.t('feedback_correcto');" },
  { from: 'fb.innerHTML = "¡Correcto!";', to: "fb.innerHTML = I18N.t('feedback_correcto');" },
  { from: "fb.innerHTML=' ¡Correcto!';", to: "fb.innerHTML=I18N.t('feedback_correcto');" },
  { from: "fb.innerHTML=' ¡Correcto! ';", to: "fb.innerHTML=I18N.t('feedback_correcto');" },

  { from: "fb.innerHTML='Incorrecto.';", to: "fb.innerHTML=I18N.t('feedback_incorrecto');" },
  { from: 'fb.innerHTML="Incorrecto.";', to: "fb.innerHTML=I18N.t('feedback_incorrecto');" },
  { from: "fb.innerHTML = 'Incorrecto.';", to: "fb.innerHTML = I18N.t('feedback_incorrecto');" },
  { from: 'fb.innerHTML = "Incorrecto.";', to: "fb.innerHTML = I18N.t('feedback_incorrecto');" },
  { from: "fb.innerHTML='Incorrecto';", to: "fb.innerHTML=I18N.t('feedback_incorrecto');" },
  { from: "fb.innerHTML = 'Incorrecto';", to: "fb.innerHTML = I18N.t('feedback_incorrecto');" },

  // HTML-wrapped correct/incorrect
  { from: "fb.innerHTML='<i class=\"fas fa-check-circle\"></i> ¡Correcto!';", to: "fb.innerHTML='<i class=\"fas fa-check-circle\"></i> '+I18N.t('feedback_correcto');" },
  { from: "fb.innerHTML = '<i class=\"fas fa-check-circle\"></i> ¡Correcto!';", to: "fb.innerHTML = '<i class=\"fas fa-check-circle\"></i> '+I18N.t('feedback_correcto');" },
  { from: "fb.innerHTML='<i class=\"fas fa-check-circle\"></i> ¡Correcto! ';", to: "fb.innerHTML='<i class=\"fas fa-check-circle\"></i> '+I18N.t('feedback_correcto');" },

  { from: "fb.innerHTML='<i class=\"fas fa-times-circle\"></i> Incorrecto.';", to: "fb.innerHTML='<i class=\"fas fa-times-circle\"></i> '+I18N.t('feedback_incorrecto');" },
  { from: "fb.innerHTML = '<i class=\"fas fa-times-circle\"></i> Incorrecto.';", to: "fb.innerHTML = '<i class=\"fas fa-times-circle\"></i> '+I18N.t('feedback_incorrecto');" },
  { from: "fb.innerHTML='<i class=\"fas fa-times-circle\"></i> Incorrecto';", to: "fb.innerHTML='<i class=\"fas fa-times-circle\"></i> '+I18N.t('feedback_incorrecto');" },

  // document.getElementById('feedback') variants
  { from: "document.getElementById('feedback').innerHTML='¡Correcto!';", to: "document.getElementById('feedback').innerHTML=I18N.t('feedback_correcto');" },
  { from: "document.getElementById('feedback').innerHTML='Incorrecto.';", to: "document.getElementById('feedback').innerHTML=I18N.t('feedback_incorrecto');" },
  { from: "document.getElementById('feedback').innerHTML='Incorrecto';", to: "document.getElementById('feedback').innerHTML=I18N.t('feedback_incorrecto');" },
];

let changed = 0;
let skipped = 0;

for (const f of files) {
  let content = fs.readFileSync(f, 'utf-8');
  // Skip files already using I18N.t()
  if (/I18N\.t\(['"]/.test(content)) { skipped++; continue; }
  let original = content;
  for (const r of replacements) {
    if (content.includes(r.from)) {
      content = content.split(r.from).join(r.to);
    }
  }
  if (content !== original) {
    fs.writeFileSync(f, content, 'utf-8');
    changed++;
  }
}
console.log(`Phase 1: ${changed} files modified, ${skipped} already converted`);
