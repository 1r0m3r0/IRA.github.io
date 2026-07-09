$files = @(
    "D:\poryectosPulidos\PAGINA\cursos\programa-datos-ingenieria\curso-1-data-engineering\01-modern-data-stack\index.html",
    "D:\poryectosPulidos\PAGINA\cursos\programa-datos-ingenieria\curso-2-mlops\01-mlflow\index.html",
    "D:\poryectosPulidos\PAGINA\cursos\programa-datos-ingenieria\curso-3-cloud-bigdata\01-aws-serverless\index.html",
    "D:\poryectosPulidos\PAGINA\cursos\programa-datos-ingenieria\curso-4-causal-inference\01-correlacion-vs-causalidad\index.html",
    "D:\poryectosPulidos\PAGINA\cursos\programa-datos-ingenieria\curso-5-ia-responsable\01-xai-conceptos\index.html",
    "D:\poryectosPulidos\PAGINA\cursos\programa-datos-ingenieria\curso-6-proyecto-final\01-definicion-problema\index.html",
    "D:\poryectosPulidos\PAGINA\cursos\programa-datos-aplicaciones\curso-1-finanzas\01-datos-financieros.html",
    "D:\poryectosPulidos\PAGINA\cursos\programa-datos-aplicaciones\curso-2-healthcare\01-datos-clinicos.html",
    "D:\poryectosPulidos\PAGINA\cursos\programa-datos-aplicaciones\curso-3-marketing\01-rfm-segmentacion.html",
    "D:\poryectosPulidos\PAGINA\cursos\programa-datos-aplicaciones\curso-4-nlp-produccion\01-text-processing-pipeline-spacy-tokenizacion-pos-ner.html",
    "D:\poryectosPulidos\PAGINA\cursos\programa-datos-aplicaciones\curso-5-vision-produccion\01-clasificacion-produccion-tf-data-augmentation-amp.html",
    "D:\poryectosPulidos\PAGINA\cursos\programa-datos-aplicaciones\curso-6-multi-industria\01-energia-smart-grid-iot-anomalias-forecasting.html"
)

foreach ($f in $files) {
    if (-not (Test-Path $f)) { Write-Host "$f NOT FOUND" -ForegroundColor Red; continue }
    $c = Get-Content $f -Raw
    $lines = ($c -split [Environment]::NewLine).Count
    Write-Host "=== $(Split-Path $f -Leaf) ===" -ForegroundColor Yellow
    Write-Host "  Lines: $lines"
    Write-Host "  objectives: $($c.Contains('class="objectives"'))"
    Write-Host "  info-panels: $($c.Contains('info-panels-grid'))"
    Write-Host "  example-section: $($c.Contains('example-section'))"
    Write-Host "  module-summary: $($c.Contains('module-summary'))"
    Write-Host "  quiz-explanation CSS: $($c.Contains('quiz-explanation'))"
    Write-Host "  expDiv JS: $($c.Contains('expDiv'))"
    Write-Host "  expEl JS: $($c.Contains('expEl'))"
    Write-Host "  </html> tag: $($c.Contains('</html>'))"
    Write-Host "  localStorage preserved: $($c -match '(datos3_|datos4_)')"
}
