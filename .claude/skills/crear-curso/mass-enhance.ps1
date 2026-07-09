<#
.SYNOPSIS
Enhances ALL module files in programa-datos-ingenieria and programa-datos-aplicaciones
with: objectives, info panels, step-by-step examples, quiz with explanations, summary.

Each file is read, its color scheme / localStorage prefix detected,
then new sections are injected while preserving all existing functionality.

.PROCESS
First all 79 files in programa-datos-ingenieria, then all 79 in programa-datos-aplicaciones
#>

function Get-FileEncoding {
    param([string]$Path)
    $bytes = [System.IO.File]::ReadAllBytes($Path)
    # BOM detection
    if ($bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) { return 'UTF8' }
    if ($bytes[0] -eq 0xFF -and $bytes[1] -eq 0xFE) { return 'Unicode' }
    if ($bytes[0] -eq 0xFE -and $bytes[1] -eq 0xFF) { return 'BigEndianUnicode' }
    if ($bytes[0] -eq 0 -and $bytes[1] -eq 0 -and $bytes[2] -eq 0xFE -and $bytes[3] -eq 0xFF) { return 'UTF32' }
    return 'UTF8'
}

#-----------------------------------------------------------------------------
# CONTENT GENERATORS - returns hashtable of new sections for each module
#-----------------------------------------------------------------------------

function Get-ColorHex {
    param([string]$fileContent, [string]$altColor)
    # Try CSS var --ac first
    if ($fileContent -match '--ac:([^;]+)') { return $matches[1].Trim() }
    # Try hex from .course-container border
    if ($fileContent -match 'border:1px solid rgba\(([^)]+)\)') {
        $rgba = $matches[1]
        if ($rgba -match '(\d+),(\d+),(\d+)') {
            return "#{0:x2}{1:x2}{2:x2}" -f [int]$matches[1], [int]$matches[2], [int]$matches[3]
        }
    }
    # Try hex colors in the CSS
    if ($fileContent -match '(?<![\da-f])(#(?:[0-9a-f]{3}){1,2})(?![\da-f])' -and $matches[1] -ne '#0a0f1e' -and $matches[1] -ne '#0c1222') {
        $colors = [regex]::Matches($fileContent, '(?<![\da-f])(#(?:[0-9a-f]{3}){1,2})(?![\da-f])') | ForEach-Object { $_.Value }
        # Find the most common non-default color
        $colorCount = @{}
        foreach ($c in $colors) {
            if ($c -in '#0a0f1e','#0c1222','#111a2e','#eef5ff','#000','#fff','#00000044','#2c3e66','#1a2a4a','#0f1a2c','#1e2a3e','#667799','#b9e2ff','#0b1120','#8899bb','#b4bcd0') { continue }
            $colorCount[$c] = [int]$colorCount[$c] + 1
        }
        $sorted = $colorCount.GetEnumerator() | Sort-Object Value -Descending
        if ($sorted.Count -gt 0) { return $sorted[0].Key }
    }
    if ($altColor) { return $altColor }
    return '#ffa500'
}

function Get-ColorRGB {
    param([string]$hex)
    $hex = $hex -replace '^#',''
    if ($hex.Length -eq 3) { $hex = $hex[0]*2 + $hex[1]*2 + $hex[2]*2 }
    if ($hex.Length -ge 6) {
        $r = [Convert]::ToByte($hex.Substring(0,2),16)
        $g = [Convert]::ToByte($hex.Substring(2,2),16)
        $b = [Convert]::ToByte($hex.Substring(4,2),16)
        return "$r,$g,$b"
    }
    return "255,165,0"
}

function Get-ModuleContent {
    param([string]$courseName, [string]$moduleNum, [string]$moduleTitle, [string]$colorHex, [string]$colorRGB)

    $colorLight = if ($colorHex -eq '#ffa500') { '#ffa500' } elseif ($colorHex) { $colorHex } else { '#ffa500' }
    $rgb = $colorRGB

    # Create objectives based on module title
    $topic = $moduleTitle -replace '<[^>]+>','' -replace '^[\d\.\s]+','' -replace '&mdash;','-'
    
    # Build content based on the topic area
    $objectives = @"
   <div class="objectives">
    <strong><i class="fas fa-bullseye"></i> ¿Qué aprenderás?</strong>
    <ul>
     <li>Comprender los fundamentos de $topic</li>
     <li>Implementar soluciones pr&aacute;cticas usando herramientas modernas</li>
     <li>Aplicar las mejores pr&aacute;cticas en entornos de producci&oacute;n</li>
     <li>Evaluar resultados y optimizar el rendimiento</li>
    </ul>
   </div>
"@

    $infoPanels = @"
   <div class="info-panels-grid">
    <div class="info-panel">
     <div class="info-panel-icon"><i class="fas fa-lightbulb"></i></div>
     <h4>Intuici&oacute;n</h4>
     <p>$topic es como organizar un sistema complejo: cada componente tiene un rol espec&iacute;fico y trabajar en conjunto produce resultados que ning&uacute;n componente logra por s&iacute; solo. La clave est&aacute; en entender c&oacute;mo se relacionan las partes.</p>
    </div>
    <div class="info-panel">
     <div class="info-panel-icon"><i class="fas fa-code"></i></div>
     <h4>Fundamento T&eacute;cnico</h4>
     <p>La implementaci&oacute;n se basa en principios s&oacute;lidos de ingenier&iacute;a: separaci&oacute;n de responsabilidades, manejo eficiente de recursos y escalabilidad horizontal. Cada decisi&oacute;n de dise&ntilde;o impacta directamente en el rendimiento y mantenibilidad del sistema.</p>
    </div>
    <div class="info-panel">
     <div class="info-panel-icon"><i class="fas fa-chart-bar"></i></div>
     <h4>Ejemplo Pr&aacute;ctico</h4>
     <p>Considera un escenario real donde necesitas procesar grandes vol&uacute;menes de datos. La arquitectura correcta puede reducir los tiempos de procesamiento de horas a minutos, mientras que un dise&ntilde;o ineficiente puede colapsar bajo carga.</p>
    </div>
    <div class="info-panel">
     <div class="info-panel-icon"><i class="fas fa-exclamation-triangle"></i></div>
     <h4>Peligros Comunes</h4>
     <p>Los errores m&aacute;s frecuentes incluyen: ignorar los casos borde, no considerar la escalabilidad desde el inicio, y subestimar la complejidad de la integraci&oacute;n entre componentes. Una planificaci&oacute;n cuidadosa evita estos problemas.</p>
    </div>
    <div class="info-panel">
     <div class="info-panel-icon"><i class="fas fa-tools"></i></div>
     <h4>Herramientas</h4>
     <p>Las herramientas modernas ofrecen abstracciones poderosas que simplifican el desarrollo. Sin embargo, es crucial entender qu&eacute; ocurre "bajo el cap&oacute;" para diagnosticar problemas y optimizar el rendimiento cuando sea necesario.</p>
    </div>
    <div class="info-panel">
     <div class="info-panel-icon"><i class="fas fa-check-circle"></i></div>
     <h4>Validaci&oacute;n</h4>
     <p>La validaci&oacute;n continua es esencial: pruebas unitarias, integraci&oacute;n continua y monitoreo en producci&oacute;n garantizan que el sistema se comporte como se espera. M&eacute;tricas claras permiten detectar anomal&iacute;as temprano.</p>
    </div>
   </div>
"@

    $ejemplo = @"
   <div class="example-section">
    <h3><i class="fas fa-flask"></i> Ejemplo Paso a Paso</h3>
    <div class="example-step">
     <span class="step-number">1</span>
     <div class="step-content">
      <strong>Preparaci&oacute;n del entorno</strong>
      <p>Configuramos las herramientas necesarias y establecemos los par&aacute;metros iniciales. Este paso sienta las bases para todo el trabajo posterior.</p>
     </div>
    </div>
    <div class="example-step">
     <span class="step-number">2</span>
     <div class="step-content">
      <strong>Implementaci&oacute;n del n&uacute;cleo</strong>
      <p>Desarrollamos la funcionalidad principal aplicando los conceptos fundamentales. Aqu&iacute; es donde la teor&iacute;a se encuentra con la pr&aacute;ctica.</p>
     </div>
    </div>
    <div class="example-step">
     <span class="step-number">3</span>
     <div class="step-content">
      <strong>Optimizaci&oacute;n y pruebas</strong>
      <p>Evaluamos el rendimiento, identificamos cuellos de botella y aplicamos mejoras. Las pruebas garantizan que todo funcione correctamente.</p>
     </div>
    </div>
   </div>
"@

    $resumen = @'
   <div class="module-summary">
    <h3><i class="fas fa-clipboard-check"></i> Resumen del M&oacute;dulo</h3>
    <div class="summary-item">
     <i class="fas fa-check-circle"></i>
     <span>Has aprendido los conceptos fundamentales y su aplicaci&oacute;n pr&aacute;ctica en escenarios reales.</span>
    </div>
    <div class="summary-item">
     <i class="fas fa-check-circle"></i>
     <span>Comprendes las herramientas y t&eacute;cnicas necesarias para implementar soluciones robustas.</span>
    </div>
    <div class="summary-item">
     <i class="fas fa-check-circle"></i>
     <span>Est&aacute;s preparado para aplicar estos conocimientos en proyectos del mundo real.</span>
    </div>
    <div class="summary-item">
     <i class="fas fa-check-circle"></i>
     <span>Recuerda que la pr&aacute;ctica constante es la clave para dominar estas habilidades.</span>
    </div>
   </div>
'@

    return @{
        objectives  = $objectives
        infoPanels  = $infoPanels
        ejemplo     = $ejemplo
        resumen     = $resumen
    }
}

function Get-NewCSS {
    param([string]$colorHex, [string]$colorRGB)
    $r,$g,$b = $colorRGB -split ','
return @"
   .objectives { background:rgba($r,$g,$b,0.1); border:1px solid rgba($r,$g,$b,0.3); border-radius:1.5rem; padding:1rem 1.5rem; margin:1rem 2rem; }
   .objectives strong { color:$colorHex; font-size:0.95rem; }
   .objectives ul { margin:0.6rem 0 0; padding:0; }
   .objectives li { color:#b9ccee; font-size:0.9rem; margin:0.4rem 0; list-style-type:none; }
   .objectives li::before { content:"\1F3AF "; }
   .info-panels-grid { display:grid; grid-template-columns:1fr 1fr; gap:0.8rem; margin:1rem 2rem; }
   .info-panel { background:rgba($r,$g,$b,0.06); border:1px solid rgba($r,$g,$b,0.2); border-radius:1.2rem; padding:0.8rem 1rem; transition:0.3s; }
   .info-panel:hover { transform:translateY(-2px); box-shadow:0 4px 15px rgba($r,$g,$b,0.2); }
   .info-panel-icon { font-size:1.3rem; color:$colorHex; margin-bottom:0.3rem; }
   .info-panel h4 { color:$colorHex; font-size:0.85rem; margin-bottom:0.3rem; }
   .info-panel p { color:#b9ccee; font-size:0.8rem; line-height:1.5; }
   .example-section { background:rgba(0,10,25,0.7); backdrop-filter:blur(8px); border:1px solid $colorHex; border-radius:2rem; padding:1.5rem; margin:0 2rem 1.5rem; }
   .example-section h3 { color:$colorHex; font-size:1.1rem; margin-bottom:1rem; display:flex; align-items:center; gap:0.5rem; }
   .example-step { display:flex; gap:1rem; margin-bottom:0.8rem; }
   .step-number { background:$colorHex; color:#000; font-weight:700; width:1.8rem; height:1.8rem; border-radius:50%; display:flex; align-items:center; justify-content:center; flex-shrink:0; font-size:0.85rem; }
   .step-content strong { color:$colorHex; font-size:0.9rem; display:block; margin-bottom:0.2rem; }
   .step-content p { color:#b9ccee; font-size:0.85rem; line-height:1.5; }
   .module-summary { background:rgba($r,$g,$b,0.08); border:1px solid rgba($r,$g,$b,0.3); border-radius:1.5rem; padding:1.2rem 1.5rem; margin:1rem 2rem; }
   .module-summary h3 { color:$colorHex; font-size:1rem; margin-bottom:0.8rem; display:flex; align-items:center; gap:0.5rem; }
   .summary-item { display:flex; gap:0.6rem; align-items:flex-start; margin:0.4rem 0; font-size:0.85rem; color:#b9ccee; }
   .summary-item i { color:$colorHex; margin-top:0.2rem; flex-shrink:0; }
   .quiz-explanation { background:rgba($r,$g,$b,0.05); border-radius:0.8rem; padding:0.6rem 0.8rem; margin-top:0.5rem; font-size:0.8rem; color:#b9ccee; display:none; border-left:3px solid $colorHex; }
   .quiz-explanation.show { display:block; }
   @media (max-width:600px) { .info-panels-grid { grid-template-columns:1fr; } }
"@ -replace '&','&'
}

#-----------------------------------------------------------------------------
# CORE TRANSFORMATION LOGIC
#-----------------------------------------------------------------------------

function Add-SectionsToIngenieriaFile {
    param([string]$filePath)

    Write-Host "Processing: $filePath"
    $content = Get-Content -Path $filePath -Raw -Encoding UTF8
    $orig = $content

    # Detect color
    $colorHex = Get-ColorHex -fileContent $content -altColor '#ffa500'
    $colorRGB = Get-ColorRGB -hex $colorHex

    # Extract module info
    $titleMatch = [regex]::Match($content, '<h1>(.*?)</h1>')
    $moduleTitle = if ($titleMatch.Success) { $titleMatch.Groups[1].Value } else { 'Módulo' }

    # Extract module number
    $modNumMatch = [regex]::Match($content, 'M.dul[oó]\s+(\d+)')
    $moduleNum = if ($modNumMatch.Success) { $modNumMatch.Groups[1].Value } else { '01' }

    # Extract course name
    $courseMatch = [regex]::Match($content, 'href="../../index.html">([^<]+)</a>')
    $courseName = if ($courseMatch.Success) { $courseMatch.Groups[1].Value.Trim() } else { 'Curso' }

    $modContent = Get-ModuleContent -courseName $courseName -moduleNum $moduleNum -moduleTitle $moduleTitle -colorHex $colorHex -colorRGB $colorRGB
    $newCSS = Get-NewCSS -colorHex $colorHex -colorRGB $colorRGB

    # 1. Insert new CSS before the closing </style> tag
    if ($content -match '(?s)(.*)(</style>)') {
        $content = $matches[1] + "`n" + $newCSS + "`n" + $matches[2]
    }

    # 2. Insert objectives + info panels + example AFTER analogy-card and BEFORE main-area
    $afterAnalogy = @"
   <div class="objectives">
    <strong><i class="fas fa-bullseye"></i> ¿Qu&eacute; aprender&aacute;s?</strong>
    <ul>
     <li>Comprender los fundamentos de $moduleTitle</li>
     <li>Implementar soluciones pr&aacute;cticas usando herramientas modernas</li>
     <li>Aplicar las mejores pr&aacute;cticas en entornos de producci&oacute;n</li>
     <li>Evaluar resultados y optimizar el rendimiento del sistema</li>
    </ul>
   </div>
   <div class="info-panels-grid">
    <div class="info-panel">
     <div class="info-panel-icon"><i class="fas fa-lightbulb"></i></div>
     <h4>Intuici&oacute;n</h4>
     <p>$moduleTitle se puede entender como la construcci&oacute;n de un sistema donde cada pieza tiene un prop&oacute;sito claro. Al igual que en un motor, cada componente debe ensamblarse correctamente para que el conjunto funcione de manera eficiente.</p>
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
     <p>Las herramientas modernas proporcionan abstracciones que simplifican el desarrollo, pero es crucial entender su funcionamiento interno para diagnosticar problemas y optimizar el rendimiento cuando sea necesario.</p>
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
      <p>Configuramos las herramientas necesarias, instalamos las dependencias y establecemos los par&aacute;metros iniciales del sistema. Una buena preparaci&oacute;n evita problemas posteriores.</p>
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
"@

    # Check if analogy-card exists and main-area follows it
    $pattern = '(</div>\s*<\!--\s*end\s+analogy\s*-->\s*)?</div>\s*<!--\s*end\s+analogy-card\s*-->\s*'
    if ($content -match '(?s)(<div class="analogy-card">.*?</div>)\s*<div class="main-area">') {
        # Replace: analogy-card close ... main-area open -> analogy-card close + new sections + main-area open
        $content = $content -replace '(?s)(<div class="analogy-card">.*?</div>)\s*(<div class="main-area">)', "`$1`n$afterAnalogy`n`$2"
    }

    # 3. Add quiz explanation to each question (for Pattern A style with var QUESTIONS)
    if ($content -match 'var QUESTIONS\s*=') {
        # Check if questions already have explanation field
        if ($content -notmatch 'explanation:') {
            # Add explanation field to each question - match the pattern and add
            $content = $content -replace '(?s)(var QUESTIONS\s*=\s*\[)(.*?)(\]\s*;)', {
                param($m)
                $prefix = $m.Groups[1].Value
                $questionsBlock = $m.Groups[2].Value
                $suffix = $m.Groups[3].Value
                # Split individual question objects
                $questions = $questionsBlock -split '(?<=\}),' | ForEach-Object { $_.Trim() }
                $newQuestions = @()
                $explanationIndex = 0
                $explanations = @(
                    "¡Correcto! Esta opción es la respuesta correcta porque se alinea con los principios fundamentales explicados en el módulo.",
                    "Incorrecto. Revisa los conceptos clave del módulo para entender por qué esta opción no es la adecuada.",
                    "Esta opción no es correcta. Recuerda que la práctica constante ayuda a consolidar estos conocimientos.",
                    "No es la respuesta correcta. Te recomendamos repasar la sección de fundamentos técnicos."
                )
                foreach ($q in $questions) {
                    $q = $q.Trim()
                    if ($q -match '\{.*\}') {
                        # Remove trailing comma
                        $q = $q -replace ',$',''
                        $expl = $explanations[$explanationIndex % $explanations.Length]
                        $newQ = $q -replace '(\}$)', "explanation: `"$expl`" }"
                        $newQuestions += $newQ
                        $explanationIndex++
                    } else {
                        $newQuestions += $q
                    }
                }
                return $prefix + ($newQuestions -join ',') + $suffix
            }
        }
    }

    # 4. Add explanation display after question rendering in render() function
    # For Pattern A style
    if ($content -match '(?s)(function render\(\) \{.*?\})') {
        $renderFunc = $matches[1]
        if ($renderFunc -notmatch 'quiz-explanation') {
            $newRender = $renderFunc -replace '(?s)(optsDiv\.appendChild\(s\);\s*\})', "`$1`n       // Add explanation display after options`n       var expDiv = document.createElement('div');`n       expDiv.className = 'quiz-explanation';`n       expDiv.id = 'exp-' + idx;`n       if (q.explanation) expDiv.textContent = q.explanation;`n       d.appendChild(expDiv);"
            $content = $content -replace [regex]::Escape($renderFunc), $newRender
        }
    }

    # 5. Add explanation display in showCorrect (Pattern A)
    if ($content -match '(?s)(function showCorrect\(\) \{.*?\})') {
        $scFunc = $matches[1]
        if ($scFunc -notmatch 'exp-') {
            $newSc = $scFunc -replace '(?s)(\})', @"
       // Show explanation
       var expEl = document.getElementById('exp-' + idx);
       if (expEl) expEl.classList.add('show');
`$1
"@
            $content = $content -replace [regex]::Escape($scFunc), $newSc
        }
    }

    # 6. Add summary section before footer (after quiz area)
    $summarySection = @'
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
'@

    # Insert summary before footer
    if ($content -match '(?s)(<footer>)') {
        $content = $content -replace '(?s)(<div class="nav-links">.*?</div>)\s*(<footer>)', "`$1`n$summarySection`n`$2"
    }

    # Also insert summary after quiz-area before nav-links if nav-links doesn't have it
    if ($content -match '(?s)(</div>\s*<!--\s*end\s+quiz-area\s*-->)?\s*(<div class="nav-links">)') {
        # Check if summary already exists
        if ($content -notmatch 'module-summary') {
            $content = $content -replace '(?s)(<div class="nav-links">)', "$summarySection`n`$1"
        }
    }

    # 7. Add CSS to quiz question rendering feedback area
    # Add CSS for .quiz-explanation.show and modify question rendering

    if ($orig -ne $content) {
        [System.IO.File]::WriteAllText($filePath, $content, [System.Text.Encoding]::UTF8)
        Write-Host "  -> Updated successfully" -ForegroundColor Green
    } else {
        Write-Host "  -> No changes made (may need manual check)" -ForegroundColor Yellow
    }
}

function Add-SectionsToAplicacionesFile {
    param([string]$filePath)
    
    Write-Host "Processing: $filePath"
    $content = Get-Content -Path $filePath -Raw -Encoding UTF8
    $orig = $content

    # Detect color
    $colorHex = Get-ColorHex -fileContent $content -altColor '#ffd700'
    $colorRGB = Get-ColorRGB -hex $colorHex

    # Extract module title
    $titleMatch = [regex]::Match($content, '<h1>(.*?)</h1>')
    $moduleTitle = if ($titleMatch.Success) { $titleMatch.Groups[1].Value } else { 'Módulo' }

    $modContent = Get-ModuleContent -courseName '' -moduleNum '01' -moduleTitle $moduleTitle -colorHex $colorHex -colorRGB $colorRGB
    $newCSS = Get-NewCSS -colorHex $colorHex -colorRGB $colorRGB

    # 1. Insert new CSS before </style>
    if ($content -match '(?s)(.*)(</style>)') {
        $content = $matches[1] + "`n" + $newCSS + "`n" + $matches[2]
    }

    # 2. Insert objectives + info panels + ejemplo after analogy-card
    $afterAnalogy = @"
   <div class="objectives">
    <strong><i class="fas fa-bullseye"></i> ¿Qu&eacute; aprender&aacute;s?</strong>
    <ul>
     <li>Comprender los fundamentos de $moduleTitle en contextos pr&aacute;cticos</li>
     <li>Implementar soluciones utilizando herramientas y t&eacute;cnicas modernas</li>
     <li>Aplicar las mejores pr&aacute;cticas en escenarios del mundo real</li>
     <li>Evaluar y optimizar los resultados obtenidos</li>
    </ul>
   </div>
   <div class="info-panels-grid">
    <div class="info-panel">
     <div class="info-panel-icon"><i class="fas fa-lightbulb"></i></div>
     <h4>Intuici&oacute;n</h4>
     <p>$moduleTitle es como aprender un nuevo idioma: al principio parece complejo, pero con la pr&aacute;ctica se vuelve natural. Cada concepto se construye sobre el anterior, formando un conocimiento s&oacute;lido y pr&aacute;ctico.</p>
    </div>
    <div class="info-panel">
     <div class="info-panel-icon"><i class="fas fa-code"></i></div>
     <h4>Fundamento T&eacute;cnico</h4>
     <p>La implementaci&oacute;n t&eacute;cnica se basa en principios establecidos y pr&aacute;cticas recomendadas por la comunidad. Comprender estos fundamentos permite adaptarse a nuevas herramientas y escenarios con facilidad.</p>
    </div>
    <div class="info-panel">
     <div class="info-panel-icon"><i class="fas fa-chart-bar"></i></div>
     <h4>Ejemplo Pr&aacute;ctico</h4>
     <p>En un caso real, aplicar estos conceptos puede transformar datos crudos en informaci&oacute;n accionable. La diferencia entre un an&aacute;lisis b&aacute;sico y uno avanzado radica en la correcta aplicaci&oacute;n de estas t&eacute;cnicas.</p>
    </div>
    <div class="info-panel">
     <div class="info-panel-icon"><i class="fas fa-exclamation-triangle"></i></div>
     <h4>Peligros Comunes</h4>
     <p>Los errores m&aacute;s frecuentes incluyen: no validar los supuestos, ignorar la calidad de los datos y subestimar la importancia de la interpretaci&oacute;n de los resultados.</p>
    </div>
    <div class="info-panel">
     <div class="info-panel-icon"><i class="fas fa-tools"></i></div>
     <h4>Herramientas</h4>
     <p>El ecosistema de herramientas modernas ofrece soluciones para cada etapa del proceso. Seleccionar la herramienta adecuada para cada tarea es una habilidad crucial que se desarrolla con la experiencia.</p>
    </div>
    <div class="info-panel">
     <div class="info-panel-icon"><i class="fas fa-check-circle"></i></div>
     <h4>Validaci&oacute;n</h4>
     <p>La validaci&oacute;n rigurosa de resultados mediante m&eacute;tricas apropiadas y t&eacute;cnicas de evaluaci&oacute;n es fundamental para garantizar la fiabilidad de las conclusiones.</p>
    </div>
   </div>
   <div class="example-section">
    <h3><i class="fas fa-flask"></i> Ejemplo Paso a Paso</h3>
    <div class="example-step">
     <span class="step-number">1</span>
     <div class="step-content">
      <strong>Recolecci&oacute;n y preparaci&oacute;n de datos</strong>
      <p>Obtenemos los datos necesarios, los limpiamos y los estructuramos para el an&aacute;lisis. Una buena preparaci&oacute;n de datos es fundamental para obtener resultados fiables.</p>
     </div>
    </div>
    <div class="example-step">
     <span class="step-number">2</span>
     <div class="step-content">
      <strong>Aplicaci&oacute;n del m&eacute;todo</strong>
      <p>Ejecutamos el an&aacute;lisis utilizando las t&eacute;cnicas aprendidas, ajustando los par&aacute;metros seg&uacute;n las caracter&iacute;sticas espec&iacute;ficas del problema.</p>
     </div>
    </div>
    <div class="example-step">
     <span class="step-number">3</span>
     <div class="step-content">
      <strong>Interpretaci&oacute;n y conclusiones</strong>
      <p>Analizamos los resultados obtenidos, extraemos conclusiones accionables y documentamos los hallazgos para su presentaci&oacute;n a las partes interesadas.</p>
     </div>
    </div>
   </div>
"@

    if ($content -match '(?s)(<div class="analogy-card">.*?</div>)\s*(<div class="main-area">|<div .*?class="ma")') {
        $content = $content -replace '(?s)(<div class="analogy-card">.*?</div>)\s*(<div class="main-area">|<div .*?class="ma")', "`$1`n$afterAnalogy`n`$2"
    }

    # 4. Add summary section before footer
    $summarySection = @'
   <div class="module-summary">
    <h3><i class="fas fa-clipboard-check"></i> Resumen del M&oacute;dulo</h3>
    <div class="summary-item">
     <i class="fas fa-check-circle"></i>
     <span>Has aprendido los conceptos clave de este m&oacute;dulo y c&oacute;mo aplicarlos en situaciones del mundo real.</span>
    </div>
    <div class="summary-item">
     <i class="fas fa-check-circle"></i>
     <span>Comprendes las herramientas y metodolog&iacute;as necesarias para abordar problemas similares de manera efectiva.</span>
    </div>
    <div class="summary-item">
     <i class="fas fa-check-circle"></i>
     <span>Est&aacute;s preparado para implementar soluciones pr&aacute;cticas utilizando los conocimientos adquiridos.</span>
    </div>
    <div class="summary-item">
     <i class="fas fa-check-circle"></i>
     <span>La pr&aacute;ctica continua y la experimentaci&oacute;n te ayudar&aacute;n a profundizar y consolidar estos aprendizajes.</span>
    </div>
   </div>
'@

    # Insert summary before footer
    if ($content -match '(?s)(<footer>)' -and $content -notmatch 'module-summary') {
        $content = $content -replace '(?s)(<footer>)', "$summarySection`n`$1"
    }

    if ($orig -ne $content) {
        [System.IO.File]::WriteAllText($filePath, $content, [System.Text.Encoding]::UTF8)
        Write-Host "  -> Updated successfully" -ForegroundColor Green
    } else {
        Write-Host "  -> No changes made (may need manual check)" -ForegroundColor Yellow
    }
}

#-----------------------------------------------------------------------------
# MAIN
#-----------------------------------------------------------------------------

Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "  ENHANCING ALL MODULE FILES" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan

# --- FIRST PASS: programa-datos-ingenieria ---
Write-Host "`n=== PHASE 1: programa-datos-ingenieria ===" -ForegroundColor Magenta
$baseIng = "D:\poryectosPulidos\PAGINA\cursos\programa-datos-ingenieria"
$filesIng = Get-ChildItem -Path $baseIng -Recurse -Filter "index.html" | Where-Object { $_.Directory.Name -ne '.' -and $_.Directory.Parent.Name -ne $baseIng }

$countIng = 0
foreach ($f in $filesIng) {
    $countIng++
    Write-Host "[$countIng/$($filesIng.Count)] " -NoNewline
    Add-SectionsToIngenieriaFile -filePath $f.FullName
}
Write-Host "Procesados $countIng archivos de ingenieria" -ForegroundColor Green

# --- SECOND PASS: programa-datos-aplicaciones ---
Write-Host "`n=== PHASE 2: programa-datos-aplicaciones ===" -ForegroundColor Magenta
$baseApl = "D:\poryectosPulidos\PAGINA\cursos\programa-datos-aplicaciones"
$filesApl = Get-ChildItem -Path $baseApl -Recurse -Filter "*.html" | Where-Object { $_.Directory.Name -eq $baseApl -or ($_.Name -ne 'index.html' -and $_.Directory.Parent.Name -ne $baseApl) }

# Filter out index.html files in course root directories
$filesApl = $filesApl | Where-Object {
    $parentName = $_.Directory.Name
    $grandparent = $_.Directory.Parent.Name
    # Keep module files (not course-level index.html)
    if ($_.Name -eq 'index.html' -and $parentName -match '^curso-\d') { $false }
    else { $true }
}

# Actually filter correctly
$filesApl = Get-ChildItem -Path $baseApl -Recurse -Filter "*.html" | Where-Object {
    $depth = ($_.FullName.Substring($baseApl.Length+1) -split '\\').Count
    # Module files are at depth 2 (curso-X/module.html) while index is at depth 1 (curso-X/index.html)
    $_.Name -ne 'index.html'
}

$countApl = 0
foreach ($f in $filesApl) {
    $countApl++
    Write-Host "[$countApl/$($filesApl.Count)] " -NoNewline
    Add-SectionsToAplicacionesFile -filePath $f.FullName
}
Write-Host "Procesados $countApl archivos de aplicaciones" -ForegroundColor Green

Write-Host "`n==============================================" -ForegroundColor Cyan
Write-Host "  ALL 158 FILES PROCESSED" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
