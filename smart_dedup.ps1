$files = Get-ChildItem -Recurse -File "cursos" | Where-Object { $_.Name -match 'certific' }
$fixed = 0
foreach ($cf in $files) {
    $content = Get-Content $cf.FullName -Raw -ErrorAction SilentlyContinue
    if (-not $content) { continue }
    
    $count = [regex]::Matches($content, 'window\.print\(\)').Count
    if ($count -le 1) { continue }
    
    # Has duplicates - find the first window.print() occurrence
    $firstIdx = $content.IndexOf('window.print()')
    
    # Find the .print-btn div that contains the DUPLICATE (not the first one)
    $pat = '<div class="print-btn">'
    $searchFrom = $firstIdx + 20
    $dupIdx = $content.IndexOf($pat, $searchFrom)
    
    if ($dupIdx -gt 0) {
        # Find the closing </div> of this .print-btn block
        $closeIdx = $content.IndexOf('</div>', $dupIdx)
        if ($closeIdx -gt $dupIdx) {
            # Remove from <div class="print-btn"> to </div> (inclusive)
            $content = $content.Substring(0, $dupIdx) + $content.Substring($closeIdx + 6)
            [System.IO.File]::WriteAllText($cf.FullName, $content, [System.Text.Encoding]::UTF8)
            $fixed++
            Write-Output "FIXED: $($cf.FullName.Replace('D:\poryectosPulidos\PAGINA\cursos\',''))"
        }
    }
}
Write-Output "Fixed $fixed files"
