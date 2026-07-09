$printCSS = @'
  @media print {
   body { background: #fff !important; animation: none !important; padding: 0 !important; }
   .course-container { box-shadow: none !important; border: 2px solid #333 !important; backdrop-filter: none !important; background: #fff !important; border-radius: 0 !important; }
   .hero-header, .progress-section, .brand-return-nav, .nav-links, footer, .quiz-area, #feedbackMsg, .objectives, .module-recap, .recap, .recap-box, .insignia, .btn-action, .name-input-wrap, #submitQuizBtn, #setNameBtn, .print-btn { display: none !important; }
   .main-area { padding: 0 !important; }
   .certificate, .cert-area, .cert-paper, .cert-box, .certificate-box, .certificate-area, #certArea, #certificateArea, .cert-body { border: 2px solid #333 !important; background: #fff !important; box-shadow: none !important; }
   .certificate h2, .cert-paper h2 { color: #1a1a1a !important; }
   .certificate .name, .cert-paper .student-name, #certName { color: #000 !important; }
   .certificate p, .cert-paper p { color: #333 !important; }
  }
'@

$printBtn = @'
  <div class="print-btn" style="text-align:center;margin:1.5rem 0;">
   <button onclick="window.print()" style="background:linear-gradient(95deg,#ffd700,#ffaa00);border:none;padding:0.8rem 2rem;font-weight:bold;border-radius:3rem;cursor:pointer;font-size:1rem;color:#1e1a0c;transition:0.2s;"><i class="fas fa-print"></i> Imprimir / Guardar PDF</button>
  </div>
'@

$allCerts = Get-ChildItem -Recurse -File "cursos" | Where-Object { $_.Name -match 'certific' }
$cssAdded = 0
$btnAdded = 0
foreach ($cf in $allCerts) {
    $content = Get-Content $cf.FullName -Raw -ErrorAction SilentlyContinue
    if (-not $content) { continue }
    $original = $content
    
    # Add @media print CSS if missing
    if ($content -notmatch '@media print') {
        $content = $content -replace '(</style>)', "$printCSS`$1"
    }
    
    # Add print button if missing (no window.print call)
    if ($content -notmatch 'window\.print\(\)') {
        $content = $content -replace '(<div class="nav-links">)', "$printBtn`$1"
        $btnAdded++
    }
    
    if ($content -ne $original) {
        [System.IO.File]::WriteAllText($cf.FullName, $content, [System.Text.Encoding]::UTF8)
        $cssAdded++
        $rel = $cf.FullName.Replace("D:\poryectosPulidos\PAGINA\cursos\", "")
        Write-Output "FIXED: $rel"
    }
}
Write-Output "`nCSS added to $cssAdded files, buttons added to $btnAdded files"
