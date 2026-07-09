$printCSS = @'
  .print-btn { margin-top: 1.5rem; text-align: center; }
  .print-btn button { background: linear-gradient(95deg, #ffd700, #ffaa00); border: none; padding: 0.8rem 2rem; font-weight: bold; border-radius: 3rem; cursor: pointer; font-size: 1rem; color: #1e1a0c; transition: 0.2s; }
  .print-btn button:hover { transform: translateY(-2px); box-shadow: 0 0 15px rgba(255,215,0,0.5); }
  @media print {
   body { background: #fff !important; animation: none !important; padding: 0 !important; }
   .course-container { box-shadow: none !important; border: 2px solid #333 !important; backdrop-filter: none !important; background: #fff !important; border-radius: 0 !important; }
   .hero-header, .progress-section, .brand-return-nav, .nav-links, footer, .quiz-area, #feedbackMsg, .objectives, .module-recap, .recap, .recap-box, .insignia, .btn-action, .name-input-wrap, #submitQuizBtn, #setNameBtn { display: none !important; }
   .main-area { padding: 0 !important; }
   .certificate, .cert-area, .cert-paper, .cert-box, .certificate-box, .certificate-area, #certArea, #certificateArea { border: 2px solid #333 !important; background: #fff !important; box-shadow: none !important; }
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

$certs = Get-ChildItem -Recurse -File "cursos" | Where-Object { $_.Name -match 'certific' }
$count = 0
foreach ($cf in $certs) {
    $content = Get-Content $cf.FullName -Raw -ErrorAction SilentlyContinue
    if (-not $content) { continue }
    if ($content -match 'print-btn') { continue }  # already has print
    
    $original = $content
    $content = $content -replace '(</style>)', "$printCSS`$1"
    $content = $content -replace '(<div class="nav-links">)', "$printHTML`$1"
    
    if ($content -ne $original) {
        [System.IO.File]::WriteAllText($cf.FullName, $content, [System.Text.Encoding]::UTF8)
        $count++
        Write-Output "FIXED: $($cf.FullName.Replace('D:\poryectosPulidos\PAGINA\cursos\',''))"
    }
}
Write-Output "`nTotal fixed: $count"
