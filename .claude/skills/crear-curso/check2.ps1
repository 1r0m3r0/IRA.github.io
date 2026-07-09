$f = "D:\poryectosPulidos\PAGINA\cursos\programa-datos-ingenieria\curso-1-data-engineering\01-modern-data-stack\index.html"
$lines = Get-Content $f
for ($i=0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match 'module-summary|<footer>|</html>') {
        Write-Host ("Line $($i+1): " + $lines[$i].Trim())
    }
}
