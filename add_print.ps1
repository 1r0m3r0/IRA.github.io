$printCSS = @'
  .print-btn { margin-top: 1.5rem; text-align: center; }
  .print-btn button { background: linear-gradient(95deg, #ffd700, #ffaa00); border: none; padding: 0.8rem 2rem; font-weight: bold; border-radius: 3rem; cursor: pointer; font-size: 1rem; color: #1e1a0c; transition: 0.2s; }
  .print-btn button:hover { transform: translateY(-2px); box-shadow: 0 0 15px rgba(255,215,0,0.5); }
  @media print {
   body { background: #fff !important; animation: none !important; padding: 0 !important; }
   .course-container { box-shadow: none !important; border: 2px solid #333 !important; backdrop-filter: none !important; background: #fff !important; border-radius: 0 !important; }
   .hero-header, .progress-section, .brand-return-nav, .nav-links, footer, .quiz-area, #feedbackMsg, .objectives, .module-recap, .recap, .recap-box, .insignia, .btn-action, .name-input-wrap, #submitQuizBtn, #setNameBtn { display: none !important; }
   .main-area { padding: 0 !important; }
   .certificate, .cert-area, .cert-paper, .cert-box, .certificate-box, #certArea, #certificateArea, .certificate-area { border: 2px solid #333 !important; background: #fff !important; box-shadow: none !important; }
   .certificate h2, .cert-paper h2 { color: #1a1a1a !important; }
   .certificate .name, .cert-paper .student-name, #certName { color: #000 !important; }
   .certificate p, .cert-paper p { color: #333 !important; }
  }
'@

$printHTML = @'
  <div class="print-btn">
   <button onclick="window.print()"><i class="fas fa-print"></i> Imprimir / Guardar PDF</button>
  </div>
'@

$files = @(
    "cursos/programa-blockchain/curso-4-rwa-tokenizacion/12-certificado.html",
    "cursos/programa-blockchain/curso-5-ai-criptografia/12-certificado.html",
    "cursos/programa-econometria/curso-3-causalidad/12-certificado.html",
    "cursos/programa-econometria/curso-4-machine-learning/12-certificado.html",
    "cursos/programa-econometria/curso-5-series-tiempo/12-certificado.html",
    "cursos/programa-econometria/curso-6-microeconometria/12-certificado.html",
    "cursos/programa-econometria/curso-7-macroeconometria/12-certificado.html",
    "cursos/programa-estadistica/curso-1-probabilidad/12-certificado.html",
    "cursos/programa-estadistica/curso-3-inferencia/12-certificado.html",
    "cursos/programa-estadistica/curso-4-predictivos/12-certificado.html",
    "cursos/programa-estadistica/curso-5-machine-learning/12-certificado.html",
    "cursos/programa-marketing-digital/curso-2-seo-sem/12-certificado.html",
    "cursos/mql5-trading-algoritmico/curso-4-risk-management/12-certificado.html"
)

$count = 0
foreach ($file in $files) {
    $path = Join-Path "D:\poryectosPulidos\PAGINA" $file
    if (-not (Test-Path $path)) { Write-Output "NOT FOUND: $file"; continue }
    
    $content = Get-Content $path -Raw
    $original = $content
    
    # Check if already has print
    if ($content -match 'print-btn|window\.print') {
        Write-Output "ALREADY HAS PRINT: $file"
        continue
    }
    
    # Add CSS before </style>
    $content = $content -replace '(</style>)', "$printCSS`$1"
    
    # Add print button before <div class="nav-links">
    $content = $content -replace '(<div class="nav-links">)', "$printHTML`$1"
    
    if ($content -ne $original) {
        [System.IO.File]::WriteAllText($path, $content, [System.Text.Encoding]::UTF8)
        $count++
        Write-Output "FIXED: $file"
    } else {
        Write-Output "NO CHANGE: $file"
    }
}
Write-Output "`nFixed $count files"
