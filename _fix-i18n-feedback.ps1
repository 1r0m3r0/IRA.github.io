# Batch convert JS feedback strings to I18N.t() in programa-* module pages
# Handles two patterns:
#   Pattern A: 'Acertaste ' + correct + '/N' (string concat)
#   Pattern B: `Acertaste ${correct} de ${total}` (template literal)

$scriptRoot = "D:\poryectosPulidos\PAGINA"

# First, add keys to translation files if they don't exist
$esJson = Get-Content "$scriptRoot\assets\lang\es.json" -Raw -Encoding UTF8 | ConvertFrom-Json
$enJson = Get-Content "$scriptRoot\assets\lang\en.json" -Raw -Encoding UTF8 | ConvertFrom-Json

$newKeys = @{
    "feedback_acertaste_success" = @{
        es = "Acertaste {0} de {1}"
        en = "You got {0} out of {1}"
    }
    "feedback_acertaste_error" = @{
        es = "Acertaste {0} de {1}. Necesitas al menos {2}."
        en = "You got {0} out of {1}. You need at least {2}."
    }
    "feedback_modulo_completado" = @{
        es = "Módulo completado. ¡La insignia es tuya!"
        en = "Module completed. The badge is yours!"
    }
    "feedback_bien_hecho" = @{
        es = "Bien hecho"
        en = "Well done"
    }
}

foreach ($key in $newKeys.Keys) {
    if (-not ($esJson.PSObject.Properties.Name -contains $key)) {
        $esJson | Add-Member -NotePropertyName $key -NotePropertyValue $newKeys[$key].es
    }
    if (-not ($enJson.PSObject.Properties.Name -contains $key)) {
        $enJson | Add-Member -NotePropertyName $key -NotePropertyValue $newKeys[$key].en
    }
}

$esJson | ConvertTo-Json | Set-Content "$scriptRoot\assets\lang\es.json" -Encoding UTF8
$enJson | ConvertTo-Json | Set-Content "$scriptRoot\assets\lang\en.json" -Encoding UTF8
Write-Host "Translation files updated"

# Now batch-convert module pages
$files = Get-ChildItem -Path "$scriptRoot\cursos\programa-*\curso-*\*.html" -Recurse | Where-Object { $_.Name -ne "index.html" }
Write-Host "Found $($files.Count) module files"

$changed = 0
foreach ($f in $files) {
    $content = Get-Content $f.FullName -Raw -Encoding UTF8
    $original = $content
    
    # Pattern A1: innerHTML = '<span...>Acertaste ' + correct + '/N.</span>' (success)
    $content = $content -replace "(?s)fb\.innerHTML\s*=\s*'<span[^>]*>Acertaste '\s*\+\s*correct\s*\+\s*'/\d+\.</span>';", "fb.innerHTML = '<span class=""feedback-success"">' + I18N.t('feedback_acertaste_success').replace('{0}', correct).replace('{1}', '3') + '</span>';"
    
    # Pattern A2: innerHTML = '<span...>Acertaste ' + correct + '/N. Necesitas M.</span>' (error)
    $content = $content -replace "(?s)fb\.innerHTML\s*=\s*'<span[^>]*>Acertaste '\s*\+\s*correct\s*\+\s*'/\d+\.\s*Necesitas\s*\d+\.</span>';", "fb.innerHTML = '<span class=""feedback-error"">' + I18N.t('feedback_acertaste_error').replace('{0}', correct).replace('{1}', '3').replace('{2}', '2') + '</span>';"
    
    # Pattern A3: feedbackMsg.innerHTML = 'Módulo completado...'
    $content = $content -replace "document\.getElementById\('feedbackMsg'\)\.innerHTML\s*=\s*'[^']*';", "document.getElementById('feedbackMsg').innerHTML = I18N.t('feedback_modulo_completado');"
    
    if ($content -cne $original) {
        Set-Content $f.FullName -Value $content -NoNewLine -Encoding UTF8
        $changed++
    }
}

Write-Host "Changed $changed files"
