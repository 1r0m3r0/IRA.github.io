$files = Get-ChildItem -Recurse -File "cursos" | Where-Object { $_.Name -match 'certific' }
foreach ($cf in $files) {
    $content = Get-Content $cf.FullName -Raw -ErrorAction SilentlyContinue
    if (-not $content) { continue }
    
    $count = [regex]::Matches($content, 'window\.print\(\)').Count
    if ($count -le 1) { continue }
    
    # Remove all .print-btn divs except the first one
    $pattern = '<div class="print-btn">\s*<button onclick="window\.print\(\)">.*?</button>\s*</div>'
    $matches = [regex]::Matches($content, $pattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)
    if ($matches.Count -gt 1) {
        # Keep first, remove rest (in reverse order to preserve positions)
        for ($i = $matches.Count - 1; $i -ge 1; $i--) {
            $content = $content.Remove($matches[$i].Index, $matches[$i].Length)
        }
        [System.IO.File]::WriteAllText($cf.FullName, $content, [System.Text.Encoding]::UTF8)
        Write-Output "FIXED: $($cf.FullName.Replace('D:\poryectosPulidos\PAGINA\cursos\',''))"
    }
}
Write-Output "Done"
