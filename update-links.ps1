# Script para actualizar todos los enlaces de index.html
$indexPath = "c:\Users\IRA\Desktop\ProyectoWeb\index.html"
$content = Get-Content $indexPath -Raw

# Mapeo de proyectos a páginas demo (en orden de aparición)
$projects = @(
    "demo-trading-bot.html",
    "demo-defi-dashboard.html", 
    "demo-risk-analytics.html",
    "demo-crypto-payment.html",
    "demo-market-sentiment.html",
    "demo-blockchain-explorer.html"
)

# Actualizar enlaces a demos (primero buscar y reemplazar cada uno único)
# Trading Bot
$content = $content -replace '(<div class="project-card">[\s\S]*?Trading Bot AI[\s\S]*?<a href=")[^"]*(" class="project-link">[\s\S]*?Ver Demo)', "`${1}demo-trading-bot.html`$2"

# DeFi Dashboard  
$content = $content -replace '(<div class="project-card">[\s\S]*?DeFi Dashboard[\s\S]*?<a href=")[^"]*(" class="project-link">[\s\S]*?Ver Demo)', "`${1}demo-defi-dashboard.html`$2"

# Risk Analytics
$content = $content -replace '(<div class="project-card">[\s\S]*?Risk Analytics Engine[\s\S]*?<a href=")[^"]*(" class="project-link">[\s\S]*?Ver Demo)', "`${1}demo-risk-analytics.html`$2"

# Crypto Payment
$content = $content -replace '(<div class="project-card">[\s\S]*?Crypto Payment Gateway[\s\S]*?<a href=")[^"]*(" class="project-link">[\s\S]*?Ver Demo)', "`${1}demo-crypto-payment.html`$2"

# Market Sentiment
$content = $content -replace '(<div class="project-card">[\s\S]*?Market Sentiment AI[\s\S]*?<a href=")[^"]*(" class="project-link">[\s\S]*?Ver Demo)', "`${1}demo-market-sentiment.html`$2"

# Blockchain Explorer
$content = $content -replace '(<div class="project-card">[\s\S]*?Blockchain Explorer[\s\S]*?<a href=")[^"]*(" class="project-link">[\s\S]*?Ver Demo)', "`${1}demo-blockchain-explorer.html`$2"

# Remover todos los botones de GitHub de proyectos (segundo enlace project-link)
$content = $content -replace '</a>\s*<a href="[^"]*" target="_blank" class="project-link">[\s\S]*?GitHub[\s\S]*?</a>\s*(</div>\s*</div>\s*</div>)', "</a>`$1"

# Actualizar enlaces de cursos
$content = $content -replace '(<div class="course-card">[\s\S]*?Trading Bots[\s\S]*?<a href=")[^"]*(" class="course-link">[\s\S]*?Ver [Cc]urso)', "`${1}curso-trading-bots.html`$2"
$content = $content -replace '(<div class="course-card">[\s\S]*?Smart Contracts[\s\S]*?<a href=")[^"]*(" class="course-link">[\s\S]*?Ver [Cc]urso)', "`${1}curso-smart-contracts.html`$2"
$content = $content -replace '(<div class="course-card">[\s\S]*?Análisis Cuantitativo[\s\S]*?<a href=")[^"]*(" class="course-link">[\s\S]*?Ver [Cc]urso)', "`${1}curso-analisis-cuantitativo.html`$2"

# Actualizar enlaces de blog
$content = $content -replace '(<article class="blog-card">[\s\S]*?Estrategias Algorítmicas[\s\S]*?<a href=")[^"]*(" class="blog-link">[\s\S]*?Leer más)', "`${1}articulo-estrategias-algoritmicas.html`$2"
$content = $content -replace '(<article class="blog-card">[\s\S]*?DeFi:? Layer 2[\s\S]*?<a href=")[^"]*(" class="blog-link">[\s\S]*?Leer más)', "`${1}articulo-defi-layer2.html`$2"
$content = $content -replace '(<article class="blog-card">[\s\S]*?Machine Learning en Trading[\s\S]*?<a href=")[^"]*(" class="blog-link">[\s\S]*?Leer más)', "`${1}articulo-ml-trading.html`$2"

# Guardar cambios
$content | Set-Content $indexPath -Encoding UTF8

Write-Output "✅ Enlaces actualizados correctamente"
