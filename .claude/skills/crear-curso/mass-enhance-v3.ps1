<#
.SYNOPSIS
Enhances ALL module files with: objectives, info panels, example, quiz explanations, summary.
Uses SAFE .NET string methods. Fixes: footer insertion after </style>.
#>

function Get-ColorHex {
    param([string]$text, [string]$fallback)
    # CSS var takes priority
    if ($text -match '--ac:\s*([^;]+)') { return $matches[1].Trim() }
    # Look for main accent color in specific structural CSS rules (higher priority)
    $anchorPatterns = @(
        'border-bottom:\s*2px\s*solid\s*(#[0-9a-fA-F]+)',
        'border-left:\s*4px\s*solid\s*(#[0-9a-fA-F]+)',
        '\.opt\.selected\s*\{[^}]*background:\s*(#[0-9a-fA-F]+)',
        '\.chip\s*\{[^}]*border:\s*1px\s*solid\s*(#[0-9a-fA-F]+)'
    )
    foreach ($pat in $anchorPatterns) {
        $m = [regex]::Match($text, $pat)
        if ($m.Success) { return $m.Groups[1].Value.ToLower() }
    }
    # Fall back: frequency but exclude light/secondary colors
    $exclude = @('#0a0f1e','#0c1222','#111a2e','#eef5ff','#000','#fff','#00000044','#2c3e66','#1a2a4a','#0f1a2c','#1e2a3e','#667799','#b9e2ff','#0b1120','#8899bb','#b4bcd0','#0d1117','#22c55e','#ef4444','#00ff41','#cc3344','#66eebb','#ff8888','#ffe44d','#ff9999','#7af2ff','#66ffa6','#99f7c2','#ffcc80')
    $hexes = [regex]::Matches($text, '#[0-9a-fA-F]{6}|#[0-9a-fA-F]{3}') | ForEach-Object { $_.Value.ToLower() }
    $freq = @{}
    foreach ($h in $hexes) { if ($h -notin $exclude) { $freq[$h] = [int]$freq[$h] + 1 } }
    if ($freq.Count -eq 0) { return $fallback }
    return ($freq.GetEnumerator() | Sort-Object Value -Descending)[0].Key
}

function HexToRGB { param([string]$hex)
    $h = $hex.TrimStart('#')
    if ($h.Length -eq 3) { $h = "$($h[0])$($h[0])$($h[1])$($h[1])$($h[2])$($h[2])" }
    return "$([Convert]::ToByte($h.Substring(0,2),16)),$([Convert]::ToByte($h.Substring(2,2),16)),$([Convert]::ToByte($h.Substring(4,2),16))"
}

function Insert-After { param([string]$text, [string]$after, [string]$insert)
    $idx = $text.IndexOf($after, [System.StringComparison]::Ordinal)
    if ($idx -ge 0) { return $text.Substring(0, $idx + $after.Length) + "`n" + $insert + $text.Substring($idx + $after.Length) }
    return $text
}

function Insert-AfterLast { param([string]$text, [string]$after, [string]$insert)
    $idx = $text.LastIndexOf($after, [System.StringComparison]::Ordinal)
    if ($idx -ge 0) { return $text.Substring(0, $idx + $after.Length) + "`n" + $insert + $text.Substring($idx + $after.Length) }
    return $text
}

function Insert-Before { param([string]$text, [string]$before, [string]$insert)
    $idx = $text.IndexOf($before, [System.StringComparison]::Ordinal)
    if ($idx -ge 0) { return $text.Substring(0, $idx) + $insert + "`n" + $text.Substring($idx) }
    return $text
}

function Get-CSS { param([string]$hex, [string]$rgb)
@"
   .objectives { background:rgba($rgb,0.1); border:1px solid rgba($rgb,0.3); border-radius:1.5rem; padding:1rem 1.5rem; margin:1rem 2rem; }
   .objectives strong { color:$hex; font-size:0.95rem; }
   .objectives ul { margin:0.6rem 0 0; padding:0; }
   .objectives li { color:#b9ccee; font-size:0.9rem; margin:0.4rem 0; list-style-type:none; }
   .objectives li::before { content:"\1F3AF "; }
   .info-panels-grid { display:grid; grid-template-columns:1fr 1fr; gap:0.8rem; margin:1rem 2rem; }
   .info-panel { background:rgba($rgb,0.06); border:1px solid rgba($rgb,0.2); border-radius:1.2rem; padding:0.8rem 1rem; transition:0.3s; }
   .info-panel:hover { transform:translateY(-2px); box-shadow:0 4px 15px rgba($rgb,0.2); }
   .info-panel-icon { font-size:1.3rem; color:$hex; margin-bottom:0.3rem; }
   .info-panel h4 { color:$hex; font-size:0.85rem; margin-bottom:0.3rem; }
   .info-panel p { color:#b9ccee; font-size:0.8rem; line-height:1.5; }
   .example-section { background:rgba(0,10,25,0.7); backdrop-filter:blur(8px); border:1px solid $hex; border-radius:2rem; padding:1.5rem; margin:0 2rem 1.5rem; }
   .example-section h3 { color:$hex; font-size:1.1rem; margin-bottom:1rem; display:flex; align-items:center; gap:0.5rem; }
   .example-step { display:flex; gap:1rem; margin-bottom:0.8rem; }
   .step-number { background:$hex; color:#000; font-weight:700; width:1.8rem; height:1.8rem; border-radius:50%; display:flex; align-items:center; justify-content:center; flex-shrink:0; font-size:0.85rem; }
   .step-content strong { color:$hex; font-size:0.9rem; display:block; margin-bottom:0.2rem; }
   .step-content p { color:#b9ccee; font-size:0.85rem; line-height:1.5; }
   .module-summary { background:rgba($rgb,0.08); border:1px solid rgba($rgb,0.3); border-radius:1.5rem; padding:1.2rem 1.5rem; margin:1rem 2rem; }
   .module-summary h3 { color:$hex; font-size:1rem; margin-bottom:0.8rem; display:flex; align-items:center; gap:0.5rem; }
   .summary-item { display:flex; gap:0.6rem; align-items:flex-start; margin:0.4rem 0; font-size:0.85rem; color:#b9ccee; }
   .summary-item i { color:$hex; margin-top:0.2rem; flex-shrink:0; }
   .quiz-explanation { background:rgba($rgb,0.05); border-radius:0.8rem; padding:0.6rem 0.8rem; margin-top:0.5rem; font-size:0.8rem; color:#b9ccee; display:none; border-left:3px solid $hex; }
   .quiz-explanation.show { display:block; }
   @media (max-width:600px) { .info-panels-grid { grid-template-columns:1fr; } }
"@ }

function Get-AfterAnalogy { param([string]$title)
@"
   <div class="objectives">
    <strong><i class="fas fa-bullseye"></i> &iquest;Qu&eacute; aprender&aacute;s?</strong>
    <ul>
     <li>Comprender los fundamentos de $title</li>
     <li>Implementar soluciones pr&aacute;cticas usando herramientas modernas</li>
     <li>Aplicar las mejores pr&aacute;cticas en entornos de producci&oacute;n</li>
     <li>Evaluar resultados y optimizar el rendimiento del sistema</li>
    </ul>
   </div>
   <div class="info-panels-grid">
    <div class="info-panel">
     <div class="info-panel-icon"><i class="fas fa-lightbulb"></i></div>
     <h4>Intuici&oacute;n</h4>
     <p>$title se puede entender como un sistema donde cada pieza tiene un prop&oacute;sito claro. Al igual que en un motor, cada componente debe ensamblarse correctamente para que el conjunto funcione de manera eficiente.</p>
    </div>
    <div class="info-panel">
     <div class="info-panel-icon"><i class="fas fa-code"></i></div>
     <h4>Fundamento T&eacute;cnico</h4>
     <p>La base t&eacute;cnica se apoya en principios de ingenier&iacute;a bien establecidos: modularidad, abstracci&oacute;n y manejo eficiente de recursos. Cada decisi&oacute;n arquitect&oacute;nica debe considerar el equilibrio entre flexibilidad y rendimiento.</p>
    </div>
    <div class="info-panel">
     <div class="info-panel-icon"><i class="fas fa-chart-bar"></i></div>
     <h4>Ejemplo Pr&aacute;ctico</h4>
     <p>En un escenario real de an&aacute;lisis de datos, aplicar estos conceptos puede reducir el tiempo de procesamiento de horas a minutos. La clave est&aacute; en seleccionar las herramientas adecuadas y configurarlas correctamente.</p>
    </div>
    <div class="info-panel">
     <div class="info-panel-icon"><i class="fas fa-exclamation-triangle"></i></div>
     <h4>Peligros Comunes</h4>
     <p>Los errores t&iacute;picos incluyen: ignorar la escalabilidad, no considerar los casos borde y subestimar la complejidad de las integraciones. Una planificaci&oacute;n cuidadosa es esencial para el &eacute;xito.</p>
    </div>
    <div class="info-panel">
     <div class="info-panel-icon"><i class="fas fa-tools"></i></div>
     <h4>Herramientas</h4>
     <p>Las herramientas modernas proporcionan abstracciones que simplifican el desarrollo, pero es crucial entender su funcionamiento interno para diagnosticar problemas y optimizar el rendimiento.</p>
    </div>
    <div class="info-panel">
     <div class="info-panel-icon"><i class="fas fa-check-circle"></i></div>
     <h4>Validaci&oacute;n</h4>
     <p>Las pruebas automatizadas, el monitoreo continuo y las m&eacute;tricas de rendimiento son fundamentales para garantizar que el sistema funcione correctamente en producci&oacute;n.</p>
    </div>
   </div>
   <div class="example-section">
    <h3><i class="fas fa-flask"></i> Ejemplo Paso a Paso</h3>
    <div class="example-step">
     <span class="step-number">1</span>
     <div class="step-content">
      <strong>Preparaci&oacute;n del entorno</strong>
      <p>Configuramos las herramientas necesarias, instalamos las dependencias y establecemos los par&aacute;metros iniciales del sistema.</p>
     </div>
    </div>
    <div class="example-step">
     <span class="step-number">2</span>
     <div class="step-content">
      <strong>Implementaci&oacute;n del n&uacute;cleo</strong>
      <p>Desarrollamos la funcionalidad principal aplicando los conceptos fundamentales. Cada componente se construye siguiendo las mejores pr&aacute;cticas de la industria.</p>
     </div>
    </div>
    <div class="example-step">
     <span class="step-number">3</span>
     <div class="step-content">
      <strong>Optimizaci&oacute;n y pruebas</strong>
      <p>Evaluamos el rendimiento, identificamos cuellos de botella y aplicamos mejoras incrementales. Las pruebas unitarias y de integraci&oacute;n garantizan la calidad del resultado final.</p>
     </div>
    </div>
   </div>
"@ }

function Get-Summary {
@'
   <div class="module-summary">
    <h3><i class="fas fa-clipboard-check"></i> Resumen del M&oacute;dulo</h3>
    <div class="summary-item">
     <i class="fas fa-check-circle"></i>
     <span>Has aprendido los conceptos fundamentales de este m&oacute;dulo y c&oacute;mo aplicarlos en escenarios pr&aacute;cticos.</span>
    </div>
    <div class="summary-item">
     <i class="fas fa-check-circle"></i>
     <span>Comprendes las herramientas y t&eacute;cnicas necesarias para implementar soluciones robustas y escalables.</span>
    </div>
    <div class="summary-item">
     <i class="fas fa-check-circle"></i>
     <span>Est&aacute;s preparado para aplicar estos conocimientos en proyectos del mundo real con confianza.</span>
    </div>
    <div class="summary-item">
     <i class="fas fa-check-circle"></i>
     <span>Recuerda que la pr&aacute;ctica constante y la experimentaci&oacute;n son la clave para dominar estas habilidades.</span>
    </div>
   </div>
'@ }

#=== CORE: Enhance a single file with all sections ===

function Enhance-File {
    param([string]$path)
    Write-Host "  Processing: $(Split-Path $path -Leaf)" -NoNewline

    $text = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)
    $orig = $text

    $hex = Get-ColorHex -text $text -fallback '#ffa500'
    $rgb = HexToRGB -hex $hex

    $title = "este m&oacute;dulo"
    if ($text -match '<h1>(.*?)</h1>') { $title = $matches[1] }

    $css = Get-CSS -hex $hex -rgb $rgb
    $aa = Get-AfterAnalogy -title $title
    $sum = Get-Summary

    # 1. Insert CSS before </style>
    $text = Insert-Before -text $text -before '</style>' -insert "`n$css"

    # 2. Insert after analogy-card </div> -- find the closing tag of analogy-card
    $acMarkers = @('<div class="analogy-card">', '<div class="ac">')
    $acIdx = -1
    $acTag = ''
    foreach ($m in $acMarkers) {
        $acIdx = $text.IndexOf($m, [System.StringComparison]::Ordinal)
        if ($acIdx -ge 0) { $acTag = $m; break }
    }
    if ($acIdx -ge 0) {
        # Count nesting from acIdx to find matching </div>
        $depth = 0
        $inTag = $false
        $tagBuf = ''
        $closeIdx = -1
        for ($i = $acIdx; $i -lt $text.Length; $i++) {
            $c = $text[$i]
            if ($c -eq '<') { $inTag = $true; $tagBuf = '<' }
            elseif ($c -eq '>' -and $inTag) {
                $tagBuf += '>'
                $inTag = $false
                if ($tagBuf -match '^<div\b') { $depth++ }
                elseif ($tagBuf -eq '</div>') {
                    $depth--
                    if ($depth -eq 0) { $closeIdx = $i + 1; break }
                }
                $tagBuf = ''
            }
            elseif ($inTag) { $tagBuf += $c }
        }
        if ($closeIdx -gt 0) {
            $text = $text.Substring(0, $closeIdx) + "`n$aa" + $text.Substring($closeIdx)
        }
    }

    # 3. Add explanation field to var QUESTIONS (ingenieria pattern)
    if ($text.Contains('var QUESTIONS') -and !$text.Contains('explanation:')) {
        $explanations = @('"Correcto! Esta es la respuesta correcta segun los fundamentos del modulo."','"Incorrecto. Revisa los conceptos clave del modulo para entender por que esta opcion no es la adecuada."','"Esta opcion no es correcta. Te recomendamos repasar la seccion de fundamentos tecnicos."','"No es la respuesta correcta. Recuerda que la practica constante ayuda a consolidar estos conocimientos."')
        $ei = 0; $result = ''; $remaining = $text
        while ($remaining.Length -gt 0) {
            $qStart = $remaining.IndexOf('{ text:', [System.StringComparison]::Ordinal)
            if ($qStart -lt 0) { $result += $remaining; break }
            $result += $remaining.Substring(0, $qStart)
            $remaining = $remaining.Substring($qStart)
            $depth = 0; $closePos = -1
            for ($i = 0; $i -lt $remaining.Length; $i++) {
                if ($remaining[$i] -eq '{') { $depth++ }
                elseif ($remaining[$i] -eq '}') { $depth-- }
                if ($depth -eq 0) { $closePos = $i; break }
            }
            if ($closePos -gt 0) {
                $qObj = $remaining.Substring(0, $closePos + 1)
                if ($qObj -notmatch 'explanation:') {
                    $qObj = $qObj.TrimEnd('}').TrimEnd() + ', explanation: ' + $explanations[$ei % $explanations.Length] + ' }'
                }
                $result += $qObj; $remaining = $remaining.Substring($closePos + 1); $ei++
            } else { $result += $remaining; break }
        }
        $text = $result
    }

    # 4. Add explanation display in render() function
    if ($text.Contains('function render(') -and !$text.Contains('expDiv')) {
        $idx = $text.IndexOf('function render(', [System.StringComparison]::Ordinal)
        if ($idx -ge 0) {
            $depth = 0; $found = $false; $end = -1
            for ($i = $idx; $i -lt $text.Length; $i++) {
                if ($text[$i] -eq '{') { $depth++; $found = $true }
                elseif ($text[$i] -eq '}') { $depth-- }
                if ($found -and $depth -eq 0) { $end = $i+1; break }
            }
            if ($end -gt 0) {
                $before = $text.Substring(0, $end - 1)
                $after = $text.Substring($end - 1)
                $code = @'

       // Add explanation display
       var expDiv = document.createElement('div');
       expDiv.className = 'quiz-explanation';
       expDiv.id = 'exp-' + idx;
       if (q.explanation) expDiv.textContent = q.explanation;
       d.appendChild(expDiv);
'@
                $text = $before + $code + $after
            }
        }
    }

    # 5. Add explanation show in showCorrect()
    if ($text.Contains('function showCorrect(') -and !$text.Contains('expEl')) {
        $idx = $text.IndexOf('function showCorrect(', [System.StringComparison]::Ordinal)
        if ($idx -ge 0) {
            $depth = 0; $found = $false; $end = -1
            for ($i = $idx; $i -lt $text.Length; $i++) {
                if ($text[$i] -eq '{') { $depth++; $found = $true }
                elseif ($text[$i] -eq '}') { $depth-- }
                if ($found -and $depth -eq 0) { $end = $i+1; break }
            }
            if ($end -gt 0) {
                $before = $text.Substring(0, $end - 1)
                $after = $text.Substring($end - 1)
                $code = @'

       // Show explanation for each question
       var expEl = document.getElementById('exp-' + idx);
       if (expEl) expEl.classList.add('show');
'@
                $text = $before + $code + $after
            }
        }
    }

    # 6. Add summary before HTML footer tag (LAST occurrence or after </style>)
    # Find <footer> that is NOT inside CSS (after </style>)
    $styleCloseIdx = $text.LastIndexOf('</style>', [System.StringComparison]::Ordinal)
    if ($styleCloseIdx -ge 0) {
        $afterStyle = $text.Substring($styleCloseIdx + 8)
        $footerIdx = $afterStyle.IndexOf('<footer>', [System.StringComparison]::Ordinal)
        if ($footerIdx -ge 0) {
            $absFooter = $styleCloseIdx + 8 + $footerIdx
            # Check if module-summary already exists
            if (!$text.Contains('class="module-summary"')) {
                $text = $text.Substring(0, $absFooter) + "$sum`n" + $text.Substring($absFooter)
            }
        }
    }

    if ($text -ne $orig) {
        [System.IO.File]::WriteAllText($path, $text, [System.Text.Encoding]::UTF8)
        Write-Host " [OK]" -ForegroundColor Green
    } else {
        Write-Host " [no changes]" -ForegroundColor Yellow
    }
}

#=== MAIN ===

Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "  ENHANCING ALL MODULE FILES - V3" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan

# Restore from git first
Write-Host "Restoring from git..." -ForegroundColor Yellow
git -C "D:\poryectosPulidos\PAGINA" restore "cursos/programa-datos-ingenieria" "cursos/programa-datos-aplicaciones" 2>&1 | Out-Null
Start-Sleep -Seconds 1

# Phase 1: programa-datos-ingenieria - only module index.html files
Write-Host "`n=== PHASE 1: programa-datos-ingenieria ===" -ForegroundColor Magenta
$baseIng = "D:\poryectosPulidos\PAGINA\cursos\programa-datos-ingenieria"
$ingModules = Get-ChildItem "$baseIng/curso-*/??-*/index.html"
$cnt = 0
foreach ($f in $ingModules) { $cnt++; Write-Host "[$cnt/$($ingModules.Count)] " -NoNewline; Enhance-File -path $f.FullName }
Write-Host "Procesados $cnt archivos de ingenieria" -ForegroundColor Green

# Phase 2: programa-datos-aplicaciones - only module .html files (not index.html)
Write-Host "`n=== PHASE 2: programa-datos-aplicaciones ===" -ForegroundColor Magenta
$baseApl = "D:\poryectosPulidos\PAGINA\cursos\programa-datos-aplicaciones"
$aplModules = Get-ChildItem "$baseApl/curso-*/*.html" | Where-Object { $_.Name -ne 'index.html' }
$cnt = 0
foreach ($f in $aplModules) { $cnt++; Write-Host "[$cnt/$($aplModules.Count)] " -NoNewline; Enhance-File -path $f.FullName }
Write-Host "Procesados $cnt archivos de aplicaciones" -ForegroundColor Green

Write-Host "`n==============================================" -ForegroundColor Cyan
Write-Host "  ALL DONE" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
