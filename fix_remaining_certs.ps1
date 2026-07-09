$btnHTML = @'
  <div class="print-btn" style="text-align:center;margin:1.5rem 0;">
   <button onclick="window.print()" style="background:linear-gradient(95deg,#ffd700,#ffaa00);border:none;padding:0.8rem 2rem;font-weight:bold;border-radius:3rem;cursor:pointer;font-size:1rem;color:#1e1a0c;transition:0.2s;"><i class="fas fa-print"></i> Imprimir / Guardar PDF</button>
  </div>
'@

$printFix = @'
   .certificate-card, .repaso-card, .cert-wrapper { border: 2px solid #333 !important; background: #fff !important; box-shadow: none !important; }
   .certificate-card h2, .repaso-card h2 { color: #1a1a1a !important; }
   .certificate-card .name { color: #000 !important; }
'@

$files = @(
    "cursos/markestrated/e9-examen-certificacion.html",
    "cursos/programa-marketing-digital/curso-1-fundamentos/12-certificado.html",
    "cursos/programa-marketing-digital/curso-4-content-email/12-certificado.html",
    "cursos/programa-marketing-digital/curso-6-analytics-ia/12-certificado.html",
    "cursos/programa-marketing-digital/modo-experto/08-certificado-master.html",
    "cursos/programa-sql-basico/curso-1-fundamentos/12-repaso-certificacion.html",
    "cursos/tenpomatic/e9-examen-certificacion.html"
)

foreach ($f in $files) {
    $path = Join-Path "D:\poryectosPulidos\PAGINA" $f
    $c = Get-Content $path -Raw -ErrorAction SilentlyContinue
    if (-not $c) { Write-Output "NOT FOUND: $f"; continue }
    $original = $c
    
    # Add extra print CSS selectors inside @media print
    if ($c -match 'certificate-card|repaso-card') {
        # Find the @media print block and add extra selectors
    }
    
    # Add print button before nav-links
    $c = $c -replace '(<div class="nav-links">)', "$btnHTML`$1"
    
    if ($c -ne $original) {
        [System.IO.File]::WriteAllText($path, $c, [System.Text.Encoding]::UTF8)
        Write-Output "FIXED: $f"
    }
}
Write-Output "Done"
