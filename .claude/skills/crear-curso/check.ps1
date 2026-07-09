$f = "D:\poryectosPulidos\PAGINA\cursos\programa-datos-ingenieria\curso-1-data-engineering\01-modern-data-stack\index.html"
$c = Get-Content $f -Raw
Write-Host ("Length: " + $c.Length)
Write-Host ("Lines: " + ($c -split "`n").Length)
Write-Host "Has module-summary:" $c.Contains("module-summary")
Write-Host "Has <footer>:" $c.Contains("<footer>")
Write-Host "Has </html>:" $c.Contains("</html>")
Write-Host "---Last 300 chars---"
Write-Host $c.Substring([Math]::Max(0,$c.Length-300))
