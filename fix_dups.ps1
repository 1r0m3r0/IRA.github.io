$files = Get-ChildItem -Recurse -File "cursos" | Where-Object { $_.Name -match 'certific' }
foreach ($cf in $files) {
    $content = Get-Content $cf.FullName -Raw -ErrorAction SilentlyContinue
    if (-not $content) { continue }
    
    # Find all .print-btn divs
    $pattern = '<div class="print-btn">.*?</div>\s*'
    $matches = [regex]::Matches($content, $pattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)
    if ($matches.Count -gt 1) {
        # Remove all but the last one (keep the last one since it's before nav-links)
        for ($i = $matches.Count - 2; $i -ge 0; $i--) {
            $content = $content.Remove($matches[$i].Index, $matches[$i].Length)
        }
        [System.IO.File]::WriteAllText($cf.FullName, $content, [System.Text.Encoding]::UTF8)
        Write-Output "CLEANED: $($cf.FullName.Replace('D:\poryectosPulidos\PAGINA\cursos\',''))"
    }
}
Write-Output "Done"
