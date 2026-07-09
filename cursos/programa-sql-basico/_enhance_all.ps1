param([switch]$WhatIf)
$ErrorActionPreference="Continue"
$base = "D:\poryectosPulidos\PAGINA\cursos\programa-sql-basico"

function AddSections($file, $course, $mod, $color, $rgb, $obj, $panels, $step, $qe, $summary, $style) {
    if(-not (Test-Path $file)) { Write-Host "SKIP: $file" -ForegroundColor Yellow; return }
    $c = Get-Content $file -Raw -Encoding UTF8
    if($c -match "objectives") { Write-Host "SKIP (done): $file" -ForegroundColor Yellow; return }
    Write-Host "Processing: $file" -ForegroundColor Cyan

    # Build CSS
    $css = @"

.objectives { background:rgba($rgb,0.1); border:1px solid rgba($rgb,0.3); border-radius:1.5rem; padding:1rem 1.5rem; margin:1rem 2rem; }
.objectives h3 { color:$color; margin-bottom:0.5rem; font-size:1.05rem; }
.objectives ul { list-style:none; padding:0; }
.objectives li { padding:0.35rem 0; font-size:0.92rem; }
.objectives li::before { content:"🎯 "; }
.info-grid { display:grid; gap:1rem; margin:1.5rem 0; }
.info-panel { background:rgba($rgb,0.05); border:1px solid rgba($rgb,0.15); border-radius:1rem; padding:1rem 1.2rem; }
.info-panel h4 { color:$color; font-size:1rem; margin-bottom:0.5rem; }
.info-panel p { color:#b4c8e0; font-size:0.9rem; line-height:1.6; margin-bottom:0.5rem; }
.info-panel p:last-child { margin-bottom:0; }
.step-section { background:rgba($rgb,0.06); border:1px solid rgba($rgb,0.2); border-radius:1.2rem; padding:1.2rem; margin:1.5rem 0; }
.step-section h3 { color:$color; margin-bottom:0.8rem; font-size:1.05rem; }
.summary-box { background:linear-gradient(135deg,rgba($rgb,0.12),rgba($rgb,0.04)); border:1px solid rgba($rgb,0.3); border-radius:1.2rem; padding:1.2rem 1.5rem; margin:1.5rem 0; }
.summary-box h3 { color:$color; margin-bottom:0.5rem; font-size:1.05rem; }
.summary-box p { color:#b4c8e0; font-size:0.92rem; line-height:1.6; }
"@
    $c = $c -replace '(</style>)', "$css`$1"

    # Build objectives HTML
    $ohtml = '<div class="objectives"><h3><i class="fas fa-bullseye"></i> ¿Qué aprenderás?</h3><ul>'
    foreach($o in $obj) { $ohtml += "<li>$o</li>" }
    $ohtml += '</ul></div>'

    # Build panels HTML
    $phtml = '<div class="info-grid">'
    foreach($p in $panels) {
        $phtml += '<div class="info-panel"><h4>' + $p.title + '</h4>'
        foreach($par in $p.pars) { $phtml += '<p>' + $par + '</p>' }
        $phtml += '</div>'
    }
    $phtml += '</div>'

    # Build step HTML
    $shtml = '<div class="step-section"><h3><i class="fas fa-laptop-code"></i> Ejemplo Paso a Paso</h3>' + $step + '</div>'

    # Build summary
 $sumhtml = '<div class="summary-box"><h3><i class="fas fa-check-double"></i> Resumen del Módulo</h3><p>' + $summary + '</p></div>'

    $insert = "`n$ohtml`n$phtml`n$shtml`n"

    if($style -eq "classic") {
        # Insert after analogy card, before section-card (quiz/activity)
        $c = $c -replace '(</div>\s*\n\s*<div class="section-card">)', "$insert`$1"
        # Add summary before footer
        $c = $c -replace '(</div>\s*\n\s*<div class="footer-text">)', "$sumhtml`n`$1"
    } else {
        $c = $c -replace '(</div>\s*\n\s*<div class="main-area">)', "$insert`$1"
        $c = $c -replace '(</div>\s*\n\s*<footer>)', "$sumhtml`n`$1"
    }

    if(-not $WhatIf) {
        $c | Out-File -FilePath $file -Encoding UTF8 -NoNewline
        Write-Host "  ✓ Done" -ForegroundColor Green
    }
}

function P($t,$pars){ return @{title=$t;pars=$pars} }

# ============ CURSO 1 - FUNDAMENTOS (#00e0ff / 0,224,255) ============
$c1_01 = @{color="#00e0ff";rgb="0,224,255";style="classic"
obj=@("Entender qué es SQL y para qué sirve","Conocer los componentes de una BD relacional","Diferenciar SQL de SGBD","Identificar tablas, filas y columnas")
panels=@(
 (P "🧠 Intuición" @("SQL es el idioma universal de las bases de datos. Así como el español te permite comunicarte con personas, SQL te permite comunicarte con bases de datos relacionales.","Piensa en una base de datos como una biblioteca digital. SQL es el lenguaje que usas para pedirle al bibliotecario (el SGBD) que te traiga libros específicos.","Lo poderoso de SQL es que es declarativo: tú dices QUÉ quieres, no CÓMO obtenerlo. El SGBD se encarga de encontrar la manera más eficiente."))
 (P "📝 Sintaxis SQL" @("SQL se compone de sentencias. Cada sentencia empieza con una palabra clave como SELECT, INSERT, CREATE, etc.","Las palabras clave de SQL no distinguen mayúsculas/minúsculas, pero por convención se escriben en MAYÚSCULAS para diferenciarlas de los nombres de tablas y columnas.","Cada sentencia termina con punto y coma (;), aunque en algunos SGBD es opcional si solo ejecutas una consulta."))
 (P "💻 Ejemplo Práctico" @("Una tabla 'clientes' tiene columnas: id, nombre, email, fecha_registro.","Cada fila representa un cliente: (1, 'Ana García', 'ana@email.com', '2024-01-15')","Para obtener todos los clientes: SELECT * FROM clientes;"))
 (P "⚠️ Errores Comunes" @("Confundir SQL con SGBD: MySQL y PostgreSQL son SGBD que usan SQL.","Pensar que SQL solo sirve para consultar: también sirve para insertar, actualizar, eliminar y definir estructuras.","Olvidar que SQL es un estándar: cada SGBD tiene pequeñas variaciones (dialectos)."))
 (P "🔍 Dato Curioso" @("SQL fue desarrollado originalmente en IBM en los años 70 con el nombre SEQUEL (Structured English Query Language).","Por problemas de marca registrada, el nombre cambió a SQL. Aun así, mucha gente lo pronuncia 'sequel'.","En 1986, SQL se convirtió en un estándar ANSI, y desde entonces ha tenido múltiples revisiones (SQL:92, SQL:99, SQL:2003, etc.)."))
 (P "🎯 Concepto Clave" @("Las bases de datos relacionales organizan datos en tablas con filas y columnas.","Cada tabla tiene una clave primaria que identifica cada fila de forma única.","Las relaciones entre tablas se establecen mediante claves foráneas."))
)
step="<div class=""code-block"">-- Paso 1: Ver todas las tablas<br>SELECT table_name FROM information_schema.tables;<br><br>-- Paso 2: Explorar estructura de una tabla<br>DESCRIBE clientes;<br><br>-- Paso 3: Consultar todos los datos<br>SELECT * FROM clientes;<br><br>-- Paso 4: Consultar columnas específicas<br>SELECT nombre, email FROM clientes;</div>"
summary="SQL es el lenguaje universal para trabajar con bases de datos relacionales. Organiza datos en tablas con filas y columnas. Se compone de sublenguajes: DDL (definición), DML (manipulación), DCL (control) y DQL (consulta). Recuerda: SQL es declarativo — tú dices QUÉ necesitas, el SGBD decide CÓMO obtenerlo. ¡Has dado el primer paso!"
}

$c1_02 = @{color="#00e0ff";rgb="0,224,255";style="classic"
obj=@("Construir consultas SELECT básicas","Diferenciar entre * y columnas específicas","Entender la cláusula FROM","Ejecutar consultas simples en una tabla")
panels=@(
 (P "🧠 Intuición" @("SELECT y FROM son las palabras más usadas en SQL. SELECT es como decir 'muéstrame' y FROM es como decir 'desde dónde'. Juntos forman la consulta más básica.","Imagina que tienes un archivador lleno de fichas. SELECT * FROM clientes sería como decir 'muéstrame todas las fichas del archivador de clientes'.","Si solo quieres ver los nombres, dirías SELECT nombre FROM clientes — como pedir solo el campo 'nombre' de cada ficha."))
 (P "📝 Sintaxis SELECT" @("La estructura básica es: SELECT columnas FROM nombre_tabla;","SELECT * selecciona TODAS las columnas. Es útil para explorar, pero en producción es mejor especificar las columnas que necesitas.","Puedes seleccionar múltiples columnas separándolas con comas: SELECT col1, col2, col3 FROM tabla;"))
 (P "💻 Ejemplo Práctico" @("Tabla 'productos' con columnas: id, nombre, precio, categoria.","SELECT nombre, precio FROM productos; — devuelve solo nombres y precios.","SELECT * FROM productos; — devuelve todas las columnas de todos los productos."))
 (P "⚠️ Errores Comunes" @("Usar SELECT * en producción: puede traer datos innecesarios y hacer la consulta más lenta.","Olvidar el FROM: toda consulta SELECT necesita especificar de dónde traer los datos.","Poner coma después de la última columna: SELECT nombre, precio, FROM productos; — error de sintaxis."))
 (P "🔍 Dato Curioso" @("SELECT no necesita FROM en algunos SGBD: SELECT NOW(); o SELECT 1+1; funcionan sin tabla.","El * (asterisco) significa 'todas las columnas en orden de definición'.","Puedes hacer cálculos en SELECT: SELECT precio * 1.21 AS con_iva FROM productos;"))
 (P "🎯 Concepto Clave" @("SELECT especifica las columnas a mostrar, FROM especifica la tabla de origen.","El orden importa: SELECT siempre va primero, FROM después.","Puedes renombrar columnas con AS (lo veremos en el próximo módulo)."))
)
step="<div class=""code-block"">-- Paso 1: Ver toda la tabla<br>SELECT * FROM productos;<br><br>-- Paso 2: Seleccionar solo nombre y precio<br>SELECT nombre, precio FROM productos;<br><br>-- Paso 3: Hacer un cálculo en el SELECT<br>SELECT nombre, precio, precio * 1.21 AS precio_con_iva FROM productos;<br><br>-- Resultado:<br>-- Laptop | 999.99 | 1209.99</div>"
summary="SELECT y FROM son los pilares de cualquier consulta SQL. SELECT elige las columnas, FROM define la tabla. Usa * para explorar pero especifica columnas en producción. Puedes hacer cálculos, renombrar con AS y combinar múltiples columnas separadas por comas. ¡Ya sabes lo esencial para consultar datos!"
}

$c1_03 = @{color="#00e0ff";rgb="0,224,255";style="classic"
obj=@("Usar AS para renombrar columnas","Crear alias descriptivos para resultados","Entender que AS es opcional","Aplicar alias en consultas con cálculos")
panels=@(
 (P "🧠 Intuición" @("AS es como ponerles apodos a las columnas. Así como 'José García' puede ser 'Pepe' para sus amigos, una columna 'precio * 1.21' puede llamarse 'precio_con_iva' con AS.","Los alias hacen que los resultados sean más legibles. Es más amigable ver 'Total Ventas' que 'SUM(precio * cantidad)'.","También son obligatorios cuando usas funciones como COUNT(), SUM(), AVG() porque esas funciones no tienen nombre descriptivo por sí mismas."))
 (P "📝 Sintaxis de Alias" @("SELECT columna AS alias FROM tabla;","La palabra AS es opcional: SELECT columna alias FROM tabla; funciona igual.","Si el alias tiene espacios, usa comillas dobles: SELECT columna AS ""Mi Alias"" FROM tabla;"))
 (P "💻 Ejemplo Práctico" @("SELECT nombre, precio * 1.21 AS precio_iva FROM productos; — muestra el precio con IVA en una columna llamada 'precio_iva'.","SELECT COUNT(*) AS total_clientes FROM clientes; — muestra el resultado con un nombre descriptivo."))
 (P "⚠️ Errores Comunes" @("Olvidar el alias en funciones: SELECT COUNT(*) FROM clientes da un resultado sin nombre claro.","Usar comillas simples en vez de dobles para alias con espacios: usa ""Mi Alias"", no 'Mi Alias'.","Poner AS antes de una expresión mal: AS va DESPUÉS de la expresión o columna."))
 (P "🔍 Dato Curioso" @("En SQL Server, los alias con espacios requieren corchetes: [Mi Alias].","Los alias se pueden usar en ORDER BY pero NO en WHERE (por el orden de ejecución de SQL).","AS también se usa para alias de tablas, muy útil en JOINs."))
 (P "🎯 Concepto Clave" @("AS no cambia el nombre real de la columna en la tabla, solo afecta cómo se muestra en el resultado.","Los alias hacen que reportes y aplicaciones consuman datos con nombres más claros.","En JOINs, los alias de tablas ahorran escritura: SELECT c.nombre FROM clientes c;"))
)
step="<div class=""code-block"">-- Paso 1: Sin alias<br>SELECT COUNT(*) FROM clientes;<br>-- Resultado: | count |<br><br>-- Paso 2: Con alias<br>SELECT COUNT(*) AS total_clientes FROM clientes;<br>-- Resultado: | total_clientes |<br><br>-- Paso 3: Alias con cálculo<br>SELECT nombre, precio, precio * 1.21 AS precio_con_iva FROM productos;<br><br>-- Paso 4: AS es opcional<br>SELECT nombre, precio * 1.21 precio_con_iva FROM productos;</div>"
summary="Los alias con AS hacen que tus consultas sean más legibles y profesionales. AS es opcional pero muy recomendable, especialmente con funciones de agregación. Recuerda: los alias son temporales — solo afectan al resultado de la consulta, no a la estructura real de la tabla."
}

$c1_04 = @{color="#00e0ff";rgb="0,224,255";style="classic"
obj=@("Entender qué hace DISTINCT","Eliminar duplicados en resultados","Usar DISTINCT en múltiples columnas","Diferenciar DISTINCT de otras formas de filtrado")
panels=@(
 (P "🧠 Intuición" @("DISTINCT es como el botón 'quitar duplicados'. Cuando tienes una lista con valores repetidos, DISTINCT te muestra cada valor una sola vez.","Imagina que preguntas a 100 personas de qué ciudad son. Sin DISTINCT obtienes 100 respuestas (muchas repetidas). Con DISTINCT obtienes solo las ciudades únicas.","Es útil para preguntas como '¿qué categorías de productos tenemos?' o '¿en qué ciudades hay clientes?'."))
 (P "📝 Sintaxis DISTINCT" @("SELECT DISTINCT columna FROM tabla;","SELECT DISTINCT col1, col2 FROM tabla; — elimina duplicados basándose en la combinación de ambas columnas.","DISTINCT afecta a TODAS las columnas seleccionadas, no solo a una."))
 (P "💻 Ejemplo Práctico" @("SELECT DISTINCT ciudad FROM clientes; — lista todas las ciudades sin repetir.","SELECT DISTINCT ciudad, pais FROM clientes; — combinaciones únicas de ciudad+país.","SELECT COUNT(DISTINCT categoria) FROM productos; — cuenta cuántas categorías diferentes hay."))
 (P "⚠️ Errores Comunes" @("Pensar que DISTINCT se aplica solo a la primera columna: se aplica a TODAS las columnas del SELECT.","Usar DISTINCT cuando necesitas GROUP BY: son conceptos diferentes.","Olvidar que DISTINCT es costoso: ordena los datos internamente para eliminar duplicados."))
 (P "🔍 Dato Curioso" @("PostgreSQL tiene también DISTINCT ON (columna) que es más específico.","DISTINCT y ORDER BY pueden combinarse, pero las columnas del ORDER BY deben estar en el SELECT.","Algunos SGBD tratan NULL como un valor DISTINCT, solo aparece una vez."))
 (P "🎯 Concepto Clave" @("DISTINCT elimina filas duplicadas del resultado.","Afecta a la combinación de todas las columnas seleccionadas.","Es útil para catálogos, listas únicas y conteos de valores distintos."))
)
step="<div class=""code-block"">-- Paso 1: Ver todas las categorías (con duplicados)<br>SELECT categoria FROM productos;<br>-- Resultado: Electronica, Electronica, Ropa, Ropa, Hogar<br><br>-- Paso 2: Solo categorías únicas<br>SELECT DISTINCT categoria FROM productos;<br>-- Resultado: Electronica, Ropa, Hogar<br><br>-- Paso 3: Contar valores distintos<br>SELECT COUNT(DISTINCT categoria) AS num_categorias FROM productos;</div>"
summary="DISTINCT elimina filas duplicadas del resultado mostrando solo valores únicos. Afecta a la combinación de todas las columnas seleccionadas. Es ideal para catálogos y listas sin repetición. Recuerda: DISTINCT es costoso en tablas grandes, úsalo solo cuando realmente necesites eliminar duplicados."
}

$c1_05 = @{color="#00e0ff";rgb="0,224,255";style="classic"
obj=@("Filtrar filas con WHERE","Usar operadores de comparación","Entender el orden de las cláusulas","Aplicar filtros precisos")
panels=@(
 (P "🧠 Intuición" @("WHERE es como un filtro de café: solo deja pasar lo que cumple cierta condición. Sin WHERE, obtienes toda la tabla. Con WHERE, solo las filas que cumplen la condición.","Piensa en un portero de discoteca: solo deja entrar a personas mayores de edad. WHERE hace exactamente eso con tus datos.","WHERE se escribe después de FROM y antes de ORDER BY. Este orden no es opcional — SQL tiene un orden de ejecución estricto."))
 (P "📝 Sintaxis WHERE" @("SELECT columnas FROM tabla WHERE condicion;","Las condiciones usan operadores: =, <> (o !=), >, <, >=, <=","El texto se escribe entre comillas simples: WHERE nombre = 'Ana'"))
 (P "💻 Ejemplo Práctico" @("SELECT * FROM productos WHERE precio > 100; — productos que cuestan más de 100.","SELECT nombre, edad FROM clientes WHERE ciudad = 'Madrid'; — clientes de Madrid.","SELECT titulo FROM cursos WHERE precio < 50 ORDER BY precio; — cursos baratos ordenados."))
 (P "⚠️ Errores Comunes" @("Usar comillas dobles para texto: en SQL estándar, las comillas dobles son para nombres de columna/tabla.","Poner WHERE antes de FROM: el orden correcto es SELECT → FROM → WHERE.","Confundir = con =: en SQL, = es igualdad (no asignación)."))
 (P "🔍 Dato Curioso" @("En PostgreSQL, las cadenas se comparan con = (no == como en muchos lenguajes).","WHERE puede usar expresiones booleanas: WHERE activo = true.","NULL no se compara con =, se usa IS NULL o IS NOT NULL."))
 (P "🎯 Concepto Clave" @("WHERE filtra filas antes de que se ordenen o agrupen.","Solo las filas donde la condición es TRUE se incluyen en el resultado.","Puedes combinar condiciones con AND, OR y NOT."))
)
step="<div class=""code-block"">-- Paso 1: Filtrar por precio<br>SELECT nombre, precio FROM productos WHERE precio > 50;<br><br>-- Paso 2: Filtrar por texto<br>SELECT * FROM clientes WHERE ciudad = 'Bogotá';<br><br>-- Paso 3: Filtrar con cálculo<br>SELECT nombre, precio FROM productos WHERE precio * 1.21 > 100;<br><br>-- Paso 4: Combinar condiciones<br>SELECT * FROM productos WHERE precio >= 10 AND precio <= 100;</div>"
summary="WHERE filtra filas según una condición. Es una de las cláusulas más poderosas de SQL. Recuerda el orden: SELECT → FROM → WHERE → ORDER BY. Usa comillas simples para texto y fechas, y conoce los operadores de comparación. WHERE es tu herramienta principal para extraer datos específicos."
}

$c1_06 = @{color="#00e0ff";rgb="0,224,255";style="classic"
obj=@("Usar operadores de comparación en SQL","Combinar condiciones con operadores lógicos","Entender la precedencia de operadores","Aplicar filtros precisos")
panels=@(
 (P "🧠 Intuición" @("Los operadores de comparación son como las preguntas que le haces a los datos: ¿es igual? ¿es mayor? ¿es diferente?","Imagina que buscas un libro: '> 200 páginas', '!= ficción', '<= 20€'. Cada condición usa un operador diferente.","Los operadores lógicos (AND, OR, NOT) te permiten combinar varias condiciones."))
 (P "📝 Operadores" @("=  Igual a (no confundir con ==)","<> o !=  Diferente de",">  Mayor que | <  Menor que",">=  Mayor o igual | <=  Menor o igual"))
 (P "💻 Ejemplo" @("SELECT * FROM empleados WHERE salario >= 50000;","SELECT * FROM productos WHERE precio <> 0;","SELECT * FROM pedidos WHERE fecha > '2024-01-01' AND total < 1000;"))
 (P "⚠️ Errores" @("Usar == en vez de =: en SQL la igualdad es con un solo =.","Comparar números con comillas: WHERE precio > '100' (compara como texto).","Olvidar que NULL no se compara con =, usa IS NULL."))
 (P "🔍 Dato" @("PostgreSQL también soporta <=> para comparación segura con NULL.","Puedes comparar fechas directamente: WHERE fecha >= '2024-01-01'.","En MySQL, <=> es el operador de igualdad seguro para NULL."))
 (P "🎯 Clave" @("Los operadores devuelven TRUE, FALSE o NULL.","AND tiene prioridad sobre OR: usa paréntesis para agrupar.","La precedencia se controla con paréntesis como en matemáticas."))
)
step="<div class=""code-block"">-- Paso 1: Igualdad<br>SELECT * FROM clientes WHERE ciudad = 'Madrid';<br><br>-- Paso 2: Diferente de<br>SELECT * FROM productos WHERE categoria <> 'Electronica';<br><br>-- Paso 3: Mayor o igual con AND<br>SELECT * FROM empleados WHERE salario >= 30000 AND salario <= 80000;<br><br>-- Paso 4: Combinando con paréntesis<br>SELECT * FROM productos WHERE (precio > 100 OR precio < 10) AND categoria = 'Ropa';</div>"
summary="Los operadores de comparación (=, <>, >, <, >=, <=) te permiten filtrar datos con precisión. Combínalos con AND y OR para crear condiciones complejas. Usa paréntesis para controlar la precedencia. Recuerda: en SQL, la igualdad es con =, no ==."
}

$c1_07 = @{color="#00e0ff";rgb="0,224,255";style="classic"
obj=@("Combinar condiciones con AND","Usar OR para condiciones alternativas","Aplicar NOT para negar condiciones","Controlar precedencia con paréntesis")
panels=@(
 (P "🧠 Intuición" @("AND, OR y NOT son como las reglas de un juego: 'Si tienes 6 Y caes en esa casilla avanzas. Si sacas 1 O 2 retrocedes. Si NO tienes dinero no juegas.'","AND es estricto: TODAS deben cumplirse. OR es flexible: AL MENOS UNA. NOT invierte.","Piensa en AND como 'y además', OR como 'o también', NOT como 'todo excepto'."))
 (P "📝 Sintaxis" @("SELECT * FROM tabla WHERE cond1 AND cond2;","SELECT * FROM tabla WHERE cond1 OR cond2;","SELECT * FROM tabla WHERE NOT condicion;","SELECT * FROM tabla WHERE (c1 OR c2) AND c3;"))
 (P "💻 Ejemplo" @("SELECT * FROM productos WHERE precio > 50 AND categoria = 'Ropa';","SELECT * FROM clientes WHERE ciudad = 'Madrid' OR ciudad = 'Barcelona';","SELECT * FROM empleados WHERE NOT ciudad = 'Paris';"))
 (P "⚠️ Errores" @("Olvidar paréntesis al mezclar AND y OR: AND se evalúa primero.","Usar AND cuando deberías usar OR.","Poner NOT al principio en vez de junto a la condición."))
 (P "🔍 Dato" @("La tabla de verdad de AND solo da TRUE cuando ambas son TRUE.","OR da TRUE con al menos una TRUE.","NOT puede combinarse: NOT (precio > 100) equivale a precio <= 100."))
 (P "🎯 Clave" @("AND: todas las condiciones deben ser TRUE.","OR: al menos una condición debe ser TRUE.","NOT: invierte el resultado.","AND tiene prioridad sobre OR. Usa paréntesis."))
)
step="<div class=""code-block"">-- Paso 1: AND<br>SELECT * FROM productos WHERE precio > 20 AND precio < 100 AND categoria = 'Ropa';<br><br>-- Paso 2: OR<br>SELECT * FROM clientes WHERE ciudad = 'Madrid' OR ciudad = 'Barcelona';<br><br>-- Paso 3: NOT<br>SELECT * FROM empleados WHERE NOT departamento = 'Ventas';<br><br>-- Paso 4: Combinación<br>SELECT * FROM pedidos WHERE (total > 500 OR urgente = true) AND NOT pagado;</div>"
summary="AND, OR y NOT son los operadores lógicos de SQL. AND exige que todas las condiciones sean TRUE, OR con una basta, y NOT invierte el resultado. Recuerda: AND tiene prioridad sobre OR, usa paréntesis para agrupar condiciones claramente."
}

$c1_08 = @{color="#00e0ff";rgb="0,224,255";style="classic"
obj=@("Ordenar resultados con ORDER BY","Usar orden ascendente y descendente","Ordenar por múltiples columnas","Combinar ORDER BY con WHERE")
panels=@(
 (P "🧠 Intuición" @("ORDER BY es como organizar tus carpetas: por fecha, por orden alfabético o por tamaño. Sin ORDER BY, los resultados aparecen en el orden que el SGBD decida.","Por defecto, ORDER BY ordena de forma ascendente (A-Z, menor a mayor). Con DESC, cambias a descendente (Z-A, mayor a menor).","Puedes ordenar por múltiples columnas: primero por una columna, y dentro de esa, por otra."))
 (P "📝 Sintaxis" @("SELECT * FROM tabla ORDER BY columna; — ascendente por defecto.","SELECT * FROM tabla ORDER BY columna DESC; — descendente.","SELECT * FROM tabla ORDER BY col1 ASC, col2 DESC;"))
 (P "💻 Ejemplo" @("SELECT * FROM productos ORDER BY precio; — del más barato al más caro.","SELECT * FROM empleados ORDER BY salario DESC; — del que más gana al que menos.","SELECT nombre, precio FROM productos WHERE categoria = 'Ropa' ORDER BY precio DESC;"))
 (P "⚠️ Errores" @("Poner ORDER BY antes de WHERE: el orden correcto es SELECT → FROM → WHERE → ORDER BY.","Olvidar DESC cuando quieres orden descendente.","Ordenar por un alias usado en SELECT pero no todas las bases lo permiten."))
 (P "🔍 Dato" @("NULL se considera el valor más grande en ORDER BY ASC (aparece al final).","Puedes ordenar por la posición de la columna: ORDER BY 1.","ORDER BY también funciona con expresiones: ORDER BY precio * cantidad DESC."))
 (P "🎯 Clave" @("ORDER BY ordena el resultado final.","ASC = ascendente (defecto), DESC = descendente.","Múltiples columnas se separan con comas.","ORDER BY es la ÚLTIMA cláusula en ejecutarse."))
)
step="<div class=""code-block"">-- Paso 1: Orden ascendente<br>SELECT nombre, precio FROM productos ORDER BY precio;<br><br>-- Paso 2: Orden descendente<br>SELECT nombre, precio FROM productos ORDER BY precio DESC;<br><br>-- Paso 3: Múltiples columnas<br>SELECT nombre, precio, categoria FROM productos ORDER BY categoria ASC, precio DESC;<br><br>-- Paso 4: Con WHERE<br>SELECT * FROM productos WHERE categoria = 'Electronica' ORDER BY precio DESC;</div>"
summary="ORDER BY organiza los resultados de tu consulta. Por defecto es ascendente (ASC), usa DESC para descendente. Puedes ordenar por múltiples columnas separándolas con comas. ORDER BY siempre va al final de la consulta."
}

$c1_09 = @{color="#00e0ff";rgb="0,224,255";style="classic"
obj=@("Limitar resultados con LIMIT","Saltar filas con OFFSET","Combinar LIMIT y OFFSET para paginación","Usar LIMIT para obtener los N primeros")
panels=@(
 (P "🧠 Intuición" @("LIMIT es como decir 'solo muéstrame los primeros 5 resultados'. Cuando una consulta devuelve miles de filas, LIMIT te da solo las que necesitas.","OFFSET es como saltarte las primeras páginas: 'muéstrame los resultados a partir del número 10'.","Juntos, LIMIT y OFFSET son la base de la paginación en aplicaciones web."))
 (P "📝 Sintaxis" @("SELECT * FROM tabla LIMIT n; — solo n filas.","SELECT * FROM tabla LIMIT n OFFSET m; — n filas saltando las primeras m.","En algunos SGBD: SELECT * FROM tabla LIMIT m, n;"))
 (P "💻 Ejemplo" @("SELECT * FROM productos ORDER BY precio DESC LIMIT 3; — los 3 más caros.","SELECT * FROM clientes LIMIT 10 OFFSET 20; — del 21 al 30.","SELECT * FROM empleados ORDER BY salario DESC LIMIT 1; — el que más gana."))
 (P "⚠️ Errores" @("Usar LIMIT sin ORDER BY: no sabes qué filas estás limitando.","Poner LIMIT antes de ORDER BY: LIMIT siempre va al final.","Confundir OFFSET con página: OFFSET 10 salta 10 filas, no 10 páginas."))
 (P "🔍 Dato" @("En SQL Server se usa SELECT TOP n en vez de LIMIT.","En PostgreSQL, LIMIT ALL equivale a no tener límite.","OFFSET sin LIMIT puede ser ineficiente porque igual recorre todas las filas."))
 (P "🎯 Clave" @("LIMIT limita el número de filas devueltas.","OFFSET skipea filas antes de empezar a devolver resultados.","Siempre usa ORDER BY con LIMIT para resultados predecibles."))
)
step="<div class=""code-block"">-- Paso 1: Los 5 productos más baratos<br>SELECT nombre, precio FROM productos ORDER BY precio ASC LIMIT 5;<br><br>-- Paso 2: Los 3 más caros<br>SELECT nombre, precio FROM productos ORDER BY precio DESC LIMIT 3;<br><br>-- Paso 3: Paginación (filas 11-20)<br>SELECT * FROM productos ORDER BY id LIMIT 10 OFFSET 10;<br><br>-- Paso 4: El empleado con mayor salario<br>SELECT nombre, salario FROM empleados ORDER BY salario DESC LIMIT 1;</div>"
summary="LIMIT y OFFSET controlan cuántas filas ves y desde dónde. LIMIT n muestra las primeras n filas. OFFSET m salta m filas antes de mostrar. Juntos hacen paginación. Siempre combínalos con ORDER BY para resultados consistentes."
}

$c1_10 = @{color="#00e0ff";rgb="0,224,255";style="classic"
obj=@("Documentar consultas con comentarios","Organizar código SQL legible","Aplicar convenciones de nombres","Escribir SQL mantenible")
panels=@(
 (P "🧠 Intuición" @("Los comentarios son como notas adhesivas que dejas en tu código. No afectan la ejecución pero ayudan a entender qué hace cada parte.","Las buenas prácticas son como las reglas de ortografía: no cambian el significado pero hacen que tu escritura sea profesional.","Un código bien escrito se lee como una historia: claro, organizado y con sentido."))
 (P "📝 Comentarios" @("-- Comentario de una línea (hasta el final de la línea)","/* Comentario de múltiples líneas */","Los comentarios se ignoran al ejecutar la consulta.","Úsalos para explicar el propósito, no para repetir lo obvio."))
 (P "💻 Ejemplo" @("-- Obtener clientes que compraron este mes<br>SELECT c.nombre, COUNT(p.id) AS compras<br>FROM clientes c INNER JOIN pedidos p ON c.id = p.cliente_id<br>WHERE p.fecha >= '2024-01-01'<br>GROUP BY c.nombre;"))
 (P "⚠️ Malas Prácticas" @("SELECT * sin necesidad — trae columnas innecesarias.","Nombres confusos como 't1', 't2' en vez de 'clientes', 'pedidos'.","Falta de sangría: todo en una línea larguísima."))
 (P "🔍 Dato" @("Los comentarios sirven para 'desactivar' partes de una consulta durante pruebas.","En PostgreSQL, los comentarios se pueden leer desde information_schema.","Existe la convención de escribir palabras clave SQL en MAYÚSCULAS."))
 (P "🎯 Clave" @("Comenta el POR QUÉ, no el QUÉ (el código ya dice qué hace).","Usa sangría consistente (2 o 4 espacios).","Nombres descriptivos: precio_total en vez de pt.","Escribe como si otro fuera a leer tu código."))
)
step="<div class=""code-block"">-- ❌ Mal escrito:<br>SELECT * FROM t1 INNER JOIN t2 ON t1.a=t2.b WHERE t1.c>100 ORDER BY 2;<br><br>-- ✅ Bien escrito:<br>/* Reporte de productos más vendidos */<br>SELECT p.nombre, SUM(v.cantidad) AS total_vendido<br>FROM productos p INNER JOIN ventas v ON p.id = v.producto_id<br>WHERE v.fecha >= '2024-03-01'<br>GROUP BY p.nombre<br>ORDER BY total_vendido DESC LIMIT 10;</div>"
summary="Los comentarios y las buenas prácticas hacen que tu SQL sea profesional y mantenible. Usa -- para comentarios de una línea y /* */ para varios. Escribe código limpio con sangría, nombres descriptivos y palabras clave en mayúsculas."
}

$c1_11 = @{color="#00e0ff";rgb="0,224,255";style="classic"
obj=@("Aplicar todos los conceptos del curso 1","Resolver consultas del mundo real","Combinar WHERE, ORDER BY, LIMIT y AS","Practicar con datos reales")
panels=@(
 (P "🧠 Intuición" @("Este mini-proyecto es como un simulacro de examen: pones en práctica todo lo aprendido. Los proyectos son la mejor forma de consolidar conocimiento.","Trabajarás con una tabla 'productos' realista con nombres, precios, categorías y fechas. Resolverás preguntas de negocio reales.","Cada desafío es una situación que te encontrarías en un trabajo real como analista de datos."))
 (P "📝 Proyecto Guiado" @("Usarás SELECT para elegir columnas y FROM para la tabla.","Aplicarás WHERE para filtrar por precio, categoría y fecha.","ORDER BY ordenará los resultados.","LIMIT acotará los resultados.","AS dará nombres claros a las columnas calculadas."))
 (P "💻 Consultas" @("Listar productos de una categoría específica.","Encontrar los 3 productos más baratos.","Filtrar productos con precio entre dos valores.","Ordenar productos por precio descendente."))
 (P "⚠️ Desafíos" @("No leer bien la pregunta: ¿quieren los más caros o los más baratos?","Olvidar ORDER BY con LIMIT.","No especificar columnas en SELECT * cuando solo necesitas 2-3."))
 (P "🔍 Dato" @("Los analistas de datos pasan el 80% de su tiempo haciendo consultas como estas.","Saber SQL básico bien es más valioso que saber SQL avanzado mal.","La práctica hace al maestro."))
 (P "🎯 Consejo" @("Resuelve cada desafío por tu cuenta antes de ver la solución.","Si te atascas, simplifica: empieza con SELECT * y luego añade filtros."))
)
step="<div class=""code-block"">-- Desafío: Productos de Electronica ordenados por precio<br>SELECT nombre, precio FROM productos WHERE categoria = 'Electronica' ORDER BY precio DESC;<br><br>-- Desafío: Los 3 productos más baratos<br>SELECT nombre, precio FROM productos ORDER BY precio ASC LIMIT 3;<br><br>-- Desafío: Productos entre 50 y 200<br>SELECT nombre, precio FROM productos WHERE precio BETWEEN 50 AND 200 ORDER BY precio;<br><br>-- Desafío: Precio con IVA<br>SELECT nombre, precio, precio * 1.21 AS precio_iva FROM productos ORDER BY precio_iva DESC;</div>"
summary="Has aplicado SELECT, FROM, WHERE, ORDER BY, LIMIT, AS y operadores en un escenario real. Estos son los fundamentos que usarás todos los días como profesional de datos. ¡Sigue practicando!"
}

$c1_12 = @{color="#00e0ff";rgb="0,224,255";style="classic"
obj=@("Repasar todos los temas del curso 1","Identificar áreas de mejora","Obtener la certificación del curso","Consolidar conocimientos fundamentales")
panels=@(
 (P "🧠 Resumen" @("Has recorrido un camino: desde entender qué es SQL hasta escribir consultas con filtros, ordenamiento y límites.","Este curso te dio los cimientos: SELECT y FROM, WHERE, ORDER BY, LIMIT y OFFSET, alias con AS, DISTINCT y operadores lógicos.","Aprendiste sobre buenas prácticas y a pensar en términos de conjuntos de datos."))
 (P "📝 Conceptos Clave" @("SQL es declarativo: dices QUÉ, no CÓMO.","El orden de las cláusulas: SELECT → FROM → WHERE → ORDER BY → LIMIT.","AND, OR, NOT combinan condiciones.","AS hace los resultados más legibles.","DISTINCT elimina duplicados."))
 (P "💻 Próximos Pasos" @("Curso 2: Filtrado y Agregación — funciones LIKE, IN, GROUP BY y más.","Practica diariamente con consultas en un SGBD real como PostgreSQL.","Construye pequeños proyectos personales para afianzar conceptos."))
 (P "⚠️ Recordatorios" @("WHERE antes de ORDER BY.","Comillas simples para texto, dobles para alias con espacios.","NULL se compara con IS NULL, no con = NULL.","AND tiene prioridad sobre OR."))
 (P "🔍 Certificación" @("Al aprobar obtienes la insignia 'SQL Explorer'.","Esta insignia queda guardada en tu navegador.","Comparte tu progreso — has dado el primer gran paso."))
 (P "🎯 Felicitaciones" @("Completar este curso te coloca en el camino para ser un profesional de datos.","Los fundamentos que has aprendido son los mismos que usan los mejores analistas e ingenieros de datos del mundo.","¡Sigue así! El Curso 2 te espera."))
)
step="<div class=""code-block"">-- Repaso exprés: todas las cláusulas juntas<br>SELECT categoria, COUNT(*) AS total, ROUND(AVG(precio),2) AS prom, MAX(precio) AS max<br>FROM productos WHERE precio > 0 GROUP BY categoria HAVING COUNT(*) >= 2 ORDER BY total DESC LIMIT 5;</div>"
summary="¡Felicidades! Has completado el Curso 1 de SQL Básico. Dominas SELECT, FROM, WHERE, ORDER BY, LIMIT, DISTINCT y los operadores de comparación y lógicos. Estos fundamentos son la base de todo trabajo con bases de datos relacionales. ¡Sigue adelante!"
}

# ============ CURSO 2 - FILTRADO (#ffb347 / 255,179,71) ============
$c2_01 = @{color="#ffb347";rgb="255,179,71";style="classic"
obj=@("Entender LIKE y los comodines % y _","Buscar texto con patrones","Combinar múltiples comodines","Usar LIKE en consultas reales")
panels=@(
 (P "🧠 Intuición" @("LIKE es como un buscador inteligente para texto en SQL. Mientras que = busca coincidencia exacta, LIKE busca patrones, como cuando buscas contactos en tu celular.","El % es el comodín más usado: representa cualquier secuencia de caracteres. LIKE 'A%' encuentra todo lo que empieza con A.","El _ es el comodín de un solo carácter: LIKE 'A_a' encuentra 'Ana', 'Ala', pero no 'Abril'."))
 (P "📝 Sintaxis LIKE" @("SELECT * FROM tabla WHERE columna LIKE 'patron';","'%' — cualquier secuencia de cero o más caracteres.","'_' — exactamente un carácter cualquiera.","'ABC%' — empieza con 'ABC'.","'%XYZ' — termina con 'XYZ'.","'%mid%' — contiene 'mid' en cualquier posición."))
 (P "💻 Ejemplo" @("SELECT * FROM clientes WHERE nombre LIKE 'A%'; — nombres que empiezan con A.","SELECT * FROM emails WHERE email LIKE '%@gmail.com'; — todos los Gmail.","SELECT * FROM productos WHERE codigo LIKE 'PROD-___'; — códigos PROD- seguido de 3 caracteres."))
 (P "⚠️ Errores" @("Olvidar las comillas: LIKE A% (sin comillas) es error de sintaxis.","LIKE es CASE-SENSITIVE en algunos SGBD (PostgreSQL es sensible, MySQL no por defecto).","Usar = cuando necesitas LIKE."))
 (P "🔍 Dato" @("PostgreSQL tiene ILIKE que es LIKE pero insensible a mayúsculas/minúsculas.","LIKE puede ser más lento que = porque no usa índices eficientemente.","El estándar SQL también tiene SIMILAR TO."))
 (P "🎯 Clave" @("% = cualquier secuencia (incluso vacía).","_ = exactamente un carácter.","LIKE es para coincidencia de patrones, no exacta."))
)
step="<div class=""code-block"">-- Paso 1: Nombres que empiezan con 'M'<br>SELECT nombre FROM clientes WHERE nombre LIKE 'M%';<br><br>-- Paso 2: Emails de Outlook<br>SELECT email FROM usuarios WHERE email LIKE '%@outlook.com';<br><br>-- Paso 3: Productos con 'Pro' en el nombre<br>SELECT * FROM productos WHERE nombre LIKE '%Pro%';<br><br>-- Paso 4: Palabras de exactamente 5 letras<br>SELECT palabra FROM diccionario WHERE palabra LIKE '_____';</div>"
summary="LIKE te permite buscar patrones en texto usando % (cualquier secuencia) y _ (un carácter). Es ideal para búsquedas flexibles donde no sabes el valor exacto. Recuerda que LIKE es sensible a mayúsculas en PostgreSQL."
}

$c2_02 = @{color="#ffb347";rgb="255,179,71";style="classic"
obj=@("Usar IN para comparar con múltiples valores","Usar BETWEEN para rangos inclusivos","Combinar IN y BETWEEN","Escribir consultas más compactas")
panels=@(
 (P "🧠 Intuición" @("IN es como una lista de opciones múltiples. En vez de escribir 'ciudad = A OR ciudad = B OR ciudad = C', escribes 'ciudad IN (A, B, C)'.","BETWEEN es como decir 'entre estos dos valores, incluyéndolos'. WHERE edad BETWEEN 18 AND 65 es lo mismo que 'edad >= 18 AND edad <= 65'.","Ambos hacen tu código más conciso y fácil de mantener."))
 (P "📝 Sintaxis" @("SELECT * FROM tabla WHERE columna IN (val1, val2, val3);","SELECT * FROM tabla WHERE columna BETWEEN val1 AND val2;","NOT IN / NOT BETWEEN para exclusiones."))
 (P "💻 Ejemplo" @("SELECT * FROM clientes WHERE ciudad IN ('Madrid','Barcelona','Valencia');","SELECT * FROM productos WHERE precio BETWEEN 10 AND 50;","SELECT * FROM empleados WHERE salario NOT BETWEEN 30000 AND 60000;"))
 (P "⚠️ Errores" @("BETWEEN es INCLUSIVO: BETWEEN 10 AND 20 incluye 10 y 20.","Usar NOT IN con subconsultas que devuelven NULL: el resultado será vacío.","Olvidar paréntesis en IN."))
 (P "🔍 Dato" @("BETWEEN funciona con fechas: WHERE fecha BETWEEN '2024-01-01' AND '2024-12-31'.","IN puede usar subconsultas: WHERE id IN (SELECT cliente_id FROM pedidos)."))
 (P "🎯 Clave" @("IN = lista de valores posibles.","BETWEEN = rango inclusivo.","Ambos simplifican condiciones múltiples."))
)
step="<div class=""code-block"">-- Paso 1: IN<br>SELECT nombre, ciudad FROM clientes WHERE ciudad IN ('Madrid','Barcelona','Sevilla');<br><br>-- Paso 2: BETWEEN<br>SELECT nombre, precio FROM productos WHERE precio BETWEEN 50 AND 200;<br><br>-- Paso 3: NOT BETWEEN<br>SELECT nombre, salario FROM empleados WHERE salario NOT BETWEEN 30000 AND 50000;<br><br>-- Paso 4: IN con fechas<br>SELECT * FROM pedidos WHERE fecha BETWEEN '2024-01-01' AND '2024-03-31';</div>"
summary="IN y BETWEEN simplifican tus condiciones WHERE. IN compara con una lista de valores, BETWEEN define un rango inclusivo. Ambos hacen tu código más legible y profesional."
}

$c2_03 = @{color="#ffb347";rgb="255,179,71";style="classic"
obj=@("Entender NULL como ausencia de valor","Filtrar con IS NULL e IS NOT NULL","Diferenciar NULL de cero o vacío","Manejar NULL en operaciones")
panels=@(
 (P "🧠 Intuición" @("NULL no es cero, ni espacio en blanco, ni cadena vacía. NULL es 'no sé', 'sin dato', 'desconocido'. Es la ausencia total de valor.","Imagina un formulario donde el campo 'teléfono alternativo' queda vacío porque no tiene. Eso es NULL.","NULL es contagioso: cualquier operación con NULL da NULL. 5 + NULL = NULL."))
 (P "📝 Sintaxis" @("SELECT * FROM tabla WHERE columna IS NULL;","SELECT * FROM tabla WHERE columna IS NOT NULL;","NO se usa = NULL: WHERE columna = NULL es INCORRECTO.","COALESCE(columna, valor_default) reemplaza NULL."))
 (P "💻 Ejemplo" @("SELECT * FROM clientes WHERE telefono IS NULL; — clientes sin teléfono.","SELECT * FROM empleados WHERE fecha_baja IS NOT NULL; — ex-empleados.","SELECT nombre, COALESCE(telefono, 'No tiene') FROM clientes;"))
 (P "⚠️ Errores" @("Usar = NULL en vez de IS NULL. Es el error más común en SQL.","Pensar que '' es lo mismo que NULL. NO lo es.","NULL AND TRUE = NULL (no FALSE) en lógica."))
 (P "🔍 Dato" @("NULL no es ni TRUE ni FALSE — es un tercer estado lógico.","COUNT(*) cuenta filas incluyendo NULL; COUNT(col) las ignora.","En ORDER BY, NULL se ordena al final (ASC) o al principio (DESC)."))
 (P "🎯 Clave" @("NULL = ausencia de valor.","Nunca uses = NULL, solo IS NULL / IS NOT NULL.","NULL se propaga.","COALESCE() maneja NULL."))
)
step="<div class=""code-block"">-- Paso 1: Encontrar valores faltantes<br>SELECT nombre, email FROM clientes WHERE email IS NULL;<br><br>-- Paso 2: Excluir datos incompletos<br>SELECT * FROM empleados WHERE salario IS NOT NULL;<br><br>-- Paso 3: Reemplazar NULL<br>SELECT nombre, COALESCE(telefono, 'No registrado') AS telefono FROM clientes;<br><br>-- Paso 4: NULL en operaciones<br>SELECT nombre, precio_especial * 1.21 AS con_iva FROM productos;</div>"
summary="NULL representa la ausencia de valor. No es cero ni cadena vacía. Para detectarlo usa IS NULL (no = NULL). COALESCE te permite reemplazar NULL con un valor por defecto."
}

$c2_04 = @{color="#ffb347";rgb="255,179,71";style="classic"
obj=@("Usar funciones de cadena en SQL","Aplicar UPPER, LOWER, LENGTH, CONCAT","Usar SUBSTRING y TRIM","Manipular texto en consultas")
panels=@(
 (P "🧠 Intuición" @("Las funciones de cadena son como herramientas de edición de texto: UPPER es 'Mayúsculas', LENGTH es 'Contar caracteres', CONCAT es 'Combinar textos'.","Cada función transforma el texto sin alterar los datos originales en la tabla.","Son ideales para limpiar datos, formatear resultados o preparar información para reportes."))
 (P "📝 Funciones" @("UPPER(texto) → Mayúsculas","LOWER(texto) → Minúsculas","LENGTH(texto) → Número de caracteres","CONCAT(t1, t2) → Une textos","SUBSTRING(texto FROM ini FOR len) → Extrae parte","TRIM(texto) → Elimina espacios"))
 (P "💻 Ejemplo" @("SELECT UPPER(nombre) FROM clientes; — nombres en mayúsculas.","SELECT CONCAT(nombre, ' ', apellido) AS nombre_completo FROM clientes;","SELECT LENGTH(comentario) FROM opiniones;"))
 (P "⚠️ Errores" @("CONCAT no funciona con NULL: CONCAT('Hola', NULL) da NULL.","En algunos SGBD se usa || en vez de CONCAT.","LENGTH cuenta espacios: 'Hola ' tiene 5 caracteres."))
 (P "🔍 Dato" @("PostgreSQL usa || para concatenar: 'Hola' || ' ' || 'Mundo'.","También existe INITCAP() que pone la primera letra en mayúscula.","RPAD() y LPAD() rellenan con caracteres."))
 (P "🎯 Clave" @("No modifican los datos originales.","Puedes anidar funciones: UPPER(TRIM(nombre)).","Úsalas para limpiar, formatear y analizar texto."))
)
step="<div class=""code-block"">-- Paso 1: Mayúsculas y minúsculas<br>SELECT UPPER(nombre) AS nombre_mayus, LOWER(email) AS email_minus FROM clientes;<br><br>-- Paso 2: Longitud y concatenación<br>SELECT nombre, LENGTH(nombre) AS chars FROM productos WHERE LENGTH(nombre) > 10;<br>SELECT CONCAT(nombre, ' - ', categoria) AS descripcion FROM productos;<br><br>-- Paso 3: Extraer parte del texto<br>SELECT SUBSTRING(email FROM 1 FOR 5) AS inicio FROM usuarios;<br><br>-- Paso 4: Limpiar espacios<br>SELECT TRIM('  Hola Mundo  ') AS limpio;</div>"
summary="Las funciones de cadena (UPPER, LOWER, LENGTH, CONCAT, SUBSTRING, TRIM) te permiten manipular texto en SQL. No modifican los datos originales — solo transforman el resultado."
}

$c2_05 = @{color="#ffb347";rgb="255,179,71";style="classic"
obj=@("Usar funciones de fecha en SQL","Extraer partes de una fecha","Calcular diferencias entre fechas","Filtrar por rangos de fecha")
panels=@(
 (P "🧠 Intuición" @("Las funciones de fecha te permiten trabajar con fechas como si fueran números: puedes sumar días, restar fechas, extraer el año o el mes.","Imagina un calendario digital: EXTRACT(YEAR FROM fecha) te da el año, DATE_TRUNC trunca al mes.","Las fechas son el tipo de dato más complejo en SQL porque tienen muchos componentes."))
 (P "📝 Funciones de Fecha" @("EXTRACT(YEAR FROM fecha) → año","EXTRACT(MONTH FROM fecha) → mes","DATE_TRUNC('month', fecha) → trunca al mes","NOW() → fecha y hora actual","fecha + INTERVAL '1 day' → suma días"))
 (P "💻 Ejemplo" @("SELECT nombre, EXTRACT(YEAR FROM fecha_registro) AS año FROM clientes;","SELECT * FROM pedidos WHERE fecha > NOW() - INTERVAL '30 days';","SELECT * FROM empleados WHERE EXTRACT(YEAR FROM fecha_contratacion) = 2024;"))
 (P "⚠️ Errores" @("Formato incorrecto: '2024/01/01' puede no funcionar. Usa '2024-01-01'.","Olvidar la zona horaria: NOW() vs CURRENT_DATE.","Comparar fechas como texto."))
 (P "🔍 Dato" @("PostgreSQL tiene el tipo TIMESTAMP que incluye fecha y hora.","INTERVAL '1 year' funciona en PostgreSQL, MySQL usa DATE_ADD().","AGE() calcula la edad como intervalo."))
 (P "🎯 Clave" @("EXTRACT separa componentes de fecha.","DATE_TRUNC redondea hacia abajo.","INTERVAL suma/resta periodos de tiempo."))
)
step="<div class=""code-block"">-- Paso 1: Extraer año<br>SELECT nombre, EXTRACT(YEAR FROM fecha_registro) AS año FROM clientes;<br><br>-- Paso 2: Últimos 7 días<br>SELECT * FROM pedidos WHERE fecha >= NOW() - INTERVAL '7 days';<br><br>-- Paso 3: Contratados este mes<br>SELECT * FROM empleados WHERE EXTRACT(MONTH FROM fecha_contratacion) = EXTRACT(MONTH FROM NOW()) AND EXTRACT(YEAR FROM fecha_contratacion) = EXTRACT(YEAR FROM NOW());<br><br>-- Paso 4: Diferencia entre fechas<br>SELECT nombre, NOW() - fecha_registro AS dias_registrado FROM clientes;</div>"
summary="Las funciones de fecha (EXTRACT, DATE_TRUNC, NOW, INTERVAL) te permiten manipular y analizar datos temporales. Extrae años, meses, días, suma intervalos y calcula diferencias."
}

$c2_06 = @{color="#ffb347";rgb="255,179,71";style="classic"
obj=@("Usar funciones matemáticas en SQL","Aplicar ROUND, ABS, CEIL, FLOOR","Realizar cálculos en consultas","Usar aritmética básica")
panels=@(
 (P "🧠 Intuición" @("Las funciones matemáticas son la calculadora de SQL. ROUND redondea, ABS da valor absoluto, CEIL y FLOOR redondean hacia arriba/abajo.","Úsalas para dar formato a números, calcular porcentajes o transformar valores antes de mostrarlos.","SQL también entiende operaciones aritméticas básicas: +, -, *, /, %."))
 (P "📝 Funciones" @("ROUND(n, d) → Redondea n a d decimales","ABS(n) → Valor absoluto","CEIL(n) → Redondea hacia arriba","FLOOR(n) → Redondea hacia abajo","POWER(n, e) → n elevado a e","SQRT(n) → Raíz cuadrada"))
 (P "💻 Ejemplo" @("SELECT ROUND(AVG(precio), 2) AS promedio FROM productos;","SELECT ABS(salario - 50000) AS diferencia FROM empleados;","SELECT CEIL(precio), FLOOR(precio) FROM productos;"))
 (P "⚠️ Errores" @("Dividir enteros: 5/2 da 2 en algunos SGBD. Usa CAST.","NULL en funciones matemáticas: todas devuelven NULL.","ROUND(2.5) puede redondear a 2 o 3 según el SGBD."))
 (P "🔍 Dato" @("PostgreSQL tiene funciones estadísticas: STDDEV(), VARIANCE().","RANDOM() genera números aleatorios.","PI() devuelve el número pi."))
 (P "🎯 Clave" @("ROUND redondea, TRUNC trunca.","CEIL hacia arriba, FLOOR hacia abajo.","Funciones se pueden anidar.","SQL soporta +, -, *, /, %."))
)
step="<div class=""code-block"">-- Paso 1: Redondear promedio<br>SELECT ROUND(AVG(precio), 2) AS precio_promedio FROM productos;<br><br>-- Paso 2: Valor absoluto<br>SELECT nombre, ABS(meta_ventas - ventas_reales) AS diferencia FROM vendedores;<br><br>-- Paso 3: Redondeo arriba/abajo<br>SELECT precio, CEIL(precio) AS techo, FLOOR(precio) AS piso FROM productos;<br><br>-- Paso 4: Módulo (ids pares)<br>SELECT * FROM productos WHERE MOD(id, 2) = 0;</div>"
summary="Las funciones matemáticas (ROUND, ABS, CEIL, FLOOR, POWER) transforman valores numéricos en tus consultas. Úsalas para formatear, calcular y analizar datos numéricos."
}

$c2_07 = @{color="#ffb347";rgb="255,179,71";style="classic"
obj=@("Entender funciones de agregación","Usar COUNT para contar filas","Diferenciar COUNT(*) de COUNT(columna)","Aplicar COUNT con DISTINCT")
panels=@(
 (P "🧠 Intuición" @("COUNT es como un contador automático. Si tienes 100 clientes, COUNT(*) te dice 'hay 100'.","COUNT(*) cuenta TODAS las filas. COUNT(columna) cuenta SOLO las filas donde esa columna NO es NULL.","COUNT(DISTINCT columna) cuenta los valores únicos no nulos."))
 (P "📝 Sintaxis COUNT" @("SELECT COUNT(*) FROM tabla; — todas las filas.","SELECT COUNT(columna) FROM tabla; — filas no NULL.","SELECT COUNT(DISTINCT columna) FROM tabla; — valores únicos.","COUNT siempre devuelve un entero."))
 (P "💻 Ejemplo" @("SELECT COUNT(*) AS total FROM clientes;","SELECT COUNT(email) AS con_email FROM clientes;","SELECT COUNT(DISTINCT ciudad) FROM clientes;"))
 (P "⚠️ Errores" @("COUNT(columna) NO cuenta NULL.","Usar COUNT(*) cuando necesitas COUNT(DISTINCT col).","COUNT es agregación: no puede usarse con columnas no-agregadas sin GROUP BY."))
 (P "🔍 Dato" @("COUNT(*) es la función más optimizada en todos los SGBD.","COUNT(1) equivale a COUNT(*).","COUNT(NULL) siempre devuelve 0."))
 (P "🎯 Clave" @("COUNT(*) cuenta todas las filas.","COUNT(col) cuenta filas NO NULL.","COUNT(DISTINCT col) cuenta valores únicos."))
)
step="<div class=""code-block"">-- Paso 1: Contar todas las filas<br>SELECT COUNT(*) AS total FROM empleados;<br><br>-- Paso 2: Contar solo con email<br>SELECT COUNT(email) AS con_email FROM empleados;<br><br>-- Paso 3: Contar valores distintos<br>SELECT COUNT(DISTINCT departamento) AS deptos FROM empleados;<br><br>-- Paso 4: Combinar<br>SELECT COUNT(*) AS total, COUNT(email) AS con_email, COUNT(*) - COUNT(email) AS sin_email FROM clientes;</div>"
summary="COUNT es la función de agregación más básica pero esencial. COUNT(*) cuenta filas totales, COUNT(columna) ignora NULL, y COUNT(DISTINCT col) cuenta valores únicos."
}

$c2_08 = @{color="#ffb347";rgb="255,179,71";style="classic"
obj=@("Usar SUM para sumar valores","Usar AVG para promediar valores","Entender cómo manejan NULL","Aplicar SUM y AVG en consultas reales")
panels=@(
 (P "🧠 Intuición" @("SUM es como la función SUMA de Excel: suma todos los valores de una columna. AVG calcula el promedio.","Son ideales para reportes financieros: ingresos totales, gasto promedio, balance general.","Ambas ignoran valores NULL: SUM de (10, 20, NULL, 30) = 60."))
 (P "📝 Sintaxis" @("SELECT SUM(columna) FROM tabla;","SELECT AVG(columna) FROM tabla;","SELECT ROUND(AVG(columna), 2) FROM tabla;","Solo funcionan con columnas numéricas."))
 (P "💻 Ejemplo" @("SELECT SUM(precio * cantidad) AS total FROM detalle_pedido;","SELECT AVG(salario) AS salario_promedio FROM empleados;","SELECT ROUND(AVG(precio), 2) FROM productos;"))
 (P "⚠️ Errores" @("No pueden usarse con columnas no-agregadas sin GROUP BY.","AVG de conjunto vacío da NULL, no 0.","SUM(NULL) da NULL. SUM sobre columna ignora NULL."))
 (P "🔍 Dato" @("AVG(precio) = SUM(precio) / COUNT(precio).","SUM y AVG aceptan DISTINCT: SUM(DISTINCT col).","Para mediana usa PERCENTILE_CONT en PostgreSQL."))
 (P "🎯 Clave" @("SUM suma valores numéricos.","AVG calcula el promedio.","Ambos ignoran NULL.","Solo aplican a columnas numéricas."))
)
step="<div class=""code-block"">-- Paso 1: Sumar ventas totales<br>SELECT SUM(total) AS ingresos_totales FROM pedidos;<br><br>-- Paso 2: Promedio de salarios<br>SELECT ROUND(AVG(salario), 2) AS salario_promedio FROM empleados;<br><br>-- Paso 3: Suma con filtro<br>SELECT SUM(total) AS ventas_2024 FROM pedidos WHERE EXTRACT(YEAR FROM fecha) = 2024;<br><br>-- Paso 4: Promedio por categoría<br>SELECT categoria, ROUND(AVG(precio), 2) AS precio_prom FROM productos GROUP BY categoria;</div>"
summary="SUM suma valores y AVG calcula promedios. Ambas ignoran NULL y requieren columnas numéricas. Son esenciales para análisis financieros y reportes estadísticos."
}

$c2_09 = @{color="#ffb347";rgb="255,179,71";style="classic"
obj=@("Usar MIN para el valor mínimo","Usar MAX para el valor máximo","Aplicar MIN y MAX en diferentes tipos","Combinar con GROUP BY")
panels=@(
 (P "🧠 Intuición" @("MIN y MAX son como el 'más pequeño' y 'más grande' de una lista. En edades, MIN encuentra el más joven y MAX el más mayor.","Funcionan con números, fechas y texto. MIN de fechas = fecha más antigua. MIN de texto = alfabéticamente primero.","Perfectas para '¿cuál es el producto más caro?' o '¿cuándo fue la primera venta?'?"))
 (P "📝 Sintaxis" @("SELECT MIN(columna) FROM tabla;","SELECT MAX(columna) FROM tabla;","SELECT MIN(col), MAX(col) FROM tabla;","Con GROUP BY: SELECT cat, MAX(precio) FROM productos GROUP BY cat;"))
 (P "💻 Ejemplo" @("SELECT MIN(precio) AS barato, MAX(precio) AS caro FROM productos;","SELECT MIN(fecha) AS primer_pedido FROM pedidos;","SELECT departamento, MAX(salario) FROM empleados GROUP BY departamento;"))
 (P "⚠️ Errores" @("MIN(texto) ordena alfabéticamente.","MAX(texto) compara carácter por carácter.","MIN/MAX ignoran NULL."))
 (P "🔍 Dato" @("Para el segundo valor más alto: ORDER BY ... LIMIT 1 OFFSET 1.","MIN/MAX funcionan sin GROUP BY (agrupan toda la tabla).","Algunos SGBD tienen LEAST y GREATEST."))
 (P "🎯 Clave" @("MIN → valor más pequeño.","MAX → valor más grande.","Soportan números, fechas y texto.","Ignoran NULL."))
)
step="<div class=""code-block"">-- Paso 1: Precios mínimo y máximo<br>SELECT MIN(precio) AS barato, MAX(precio) AS caro FROM productos;<br><br>-- Paso 2: Primera/última fecha<br>SELECT MIN(fecha_contratacion) AS primero, MAX(fecha_contratacion) AS ultimo FROM empleados;<br><br>-- Paso 3: Máximo por grupo<br>SELECT departamento, MAX(salario) AS salario_max FROM empleados GROUP BY departamento;<br><br>-- Paso 4: Mínimo con filtro<br>SELECT MIN(precio) AS electronica_barata FROM productos WHERE categoria = 'Electronica';</div>"
summary="MIN y MAX encuentran valores extremos. MIN para el mínimo, MAX para el máximo. Funcionan con números, fechas y texto. Combínalos con GROUP BY para análisis por categoría."
}

$c2_10 = @{color="#ffb347";rgb="255,179,71";style="classic"
obj=@("Agrupar datos con GROUP BY","Combinar GROUP BY con agregación","Entender cómo GROUP BY afecta SELECT","Agrupar por múltiples columnas")
panels=@(
 (P "🧠 Intuición" @("GROUP BY es como organizar un cajón desordenado: agrupas cosas por tipo. En SQL, agrupa filas con el mismo valor y permite calcular agregados por grupo.","Sin GROUP BY, AVG(precio) da un solo promedio global. Con GROUP BY categoria, obtienes el promedio para cada categoría.","Después de GROUP BY, el SELECT solo puede contener columnas del GROUP BY o funciones de agregación."))
 (P "📝 Sintaxis" @("SELECT col, AVG(precio) FROM productos GROUP BY col;","SELECT col, COUNT(*), SUM(precio) FROM productos GROUP BY col;","GROUP BY va después de WHERE y antes de ORDER BY."))
 (P "💻 Ejemplo" @("SELECT ciudad, COUNT(*) FROM clientes GROUP BY ciudad;","SELECT categoria, ROUND(AVG(precio),2) FROM productos GROUP BY categoria;","SELECT YEAR(fecha), SUM(total) FROM pedidos GROUP BY YEAR(fecha);"))
 (P "⚠️ Errores" @("Columnas en SELECT no agregadas deben estar en GROUP BY.","GROUP BY ordena por defecto (pero no confíes en ello).","WHERE va antes de GROUP BY."))
 (P "🔍 Dato" @("GROUP BY convierte en consulta de agregación.","Puedes agrupar por expresiones: GROUP BY EXTRACT(YEAR FROM fecha).","GROUP BY 1 agrupa por la primera columna del SELECT."))
 (P "🎯 Clave" @("GROUP BY agrupa filas con valores iguales.","Columnas en SELECT: deben estar en GROUP BY o ser agregadas.","GROUP BY va después de WHERE, antes de ORDER BY."))
)
step="<div class=""code-block"">-- Paso 1: Contar por categoría<br>SELECT categoria, COUNT(*) AS total FROM productos GROUP BY categoria;<br><br>-- Paso 2: Promedio y total por categoría<br>SELECT categoria, ROUND(AVG(precio),2) AS prom, SUM(precio) AS total FROM productos GROUP BY categoria;<br><br>-- Paso 3: Ventas por año<br>SELECT EXTRACT(YEAR FROM fecha) AS año, SUM(total) AS ventas FROM pedidos GROUP BY año ORDER BY año;<br><br>-- Paso 4: Múltiples columnas<br>SELECT ciudad, COUNT(*) AS pedidos FROM clientes c INNER JOIN pedidos p ON c.id=p.cliente_id GROUP BY ciudad;</div>"
summary="GROUP BY es la clave del análisis de datos por categorías. Agrupa filas con valores comunes y permite calcular métricas por grupo. Recuerda: las columnas del SELECT deben estar en GROUP BY o ser funciones de agregación."
}

$c2_11 = @{color="#ffb347";rgb="255,179,71";style="classic"
obj=@("Filtrar grupos con HAVING","Diferenciar HAVING de WHERE","Usar HAVING con funciones de agregación","Aplicar HAVING en consultas complejas")
panels=@(
 (P "🧠 Intuición" @("HAVING es como WHERE pero para grupos. WHERE filtra FILAS antes de agrupar, HAVING filtra GRUPOS después de agrupar.","Imagina que agrupas clientes por ciudad y quieres solo las ciudades con más de 10 clientes. Eso es HAVING.","WHERE no puede filtrar basado en COUNT, SUM, AVG porque esas funciones se calculan durante GROUP BY."))
 (P "📝 Sintaxis" @("SELECT col, COUNT(*) FROM tabla GROUP BY col HAVING COUNT(*) > n;","WHERE filtra antes, HAVING después del GROUP BY.","HAVING solo funciona con GROUP BY."))
 (P "💻 Ejemplo" @("SELECT ciudad, COUNT(*) FROM clientes GROUP BY ciudad HAVING COUNT(*) > 5;","SELECT categoria, AVG(precio) FROM productos GROUP BY categoria HAVING AVG(precio) > 100;","SELECT YEAR(fecha), SUM(total) FROM pedidos GROUP BY año HAVING SUM(total) > 10000;"))
 (P "⚠️ Errores" @("Usar WHERE con funciones de agregación: NO funciona.","Usar HAVING sin GROUP BY: posible pero extraño.","Poner HAVING antes de GROUP BY."))
 (P "🔍 Dato" @("HAVING sin GROUP BY es como WHERE a nivel de toda la tabla.","WHERE se ejecuta antes que GROUP BY, HAVING después.","Menos filas en WHERE = GROUP BY más rápido."))
 (P "🎯 Clave" @("WHERE filtra FILAS antes de agrupar.","HAVING filtra GRUPOS después de agrupar.","HAVING usa funciones de agregación.","HAVING va después de GROUP BY."))
)
step="<div class=""code-block"">-- Paso 1: WHERE + GROUP BY + HAVING<br>SELECT cliente_id, COUNT(*) AS pedidos FROM pedidos WHERE total > 0 GROUP BY cliente_id HAVING COUNT(*) >= 5 ORDER BY pedidos DESC;<br><br>-- Paso 2: Categorías con promedio > 100<br>SELECT categoria, ROUND(AVG(precio),2) AS prom FROM productos GROUP BY categoria HAVING AVG(precio) > 100;<br><br>-- Paso 3: Años con ventas > 50000<br>SELECT EXTRACT(YEAR FROM fecha) AS año, SUM(total) AS ventas FROM pedidos GROUP BY año HAVING SUM(total) > 50000;</div>"
summary="HAVING es el filtro de grupos. WHERE filtra filas antes de agrupar, HAVING filtra grupos después. Úsalos juntos: WHERE primero, GROUP BY, HAVING, ORDER BY."
}

$c2_12 = @{color="#ffb347";rgb="255,179,71";style="classic"
obj=@("Aplicar COUNT, SUM, AVG, GROUP BY y HAVING","Analizar datos de ventas reales","Combinar filtros con agregación","Interpretar resultados")
panels=@(
 (P "🧠 Intuición" @("Este proyecto te pone en la piel de un analista de ventas. Tienes datos de productos, clientes y pedidos.","Usarás GROUP BY, HAVING, MIN, MAX, SUM y AVG para extraer información valiosa.","Estos análisis se usan en empresas para tomar decisiones: ¿qué se vende más? ¿qué clientes gastan más?"))
 (P "📝 Proyecto" @("Agrupar productos por categoría y contar.","Calcular precio promedio por categoría.","Encontrar clientes con más pedidos.","Identificar meses con mayores ventas."))
 (P "💻 Consultas" @("SELECT categoria, COUNT(*) FROM productos GROUP BY categoria;","SELECT YEAR(fecha), SUM(total) FROM pedidos GROUP BY YEAR(fecha);","SELECT producto_id, COUNT(*) FROM detalle GROUP BY producto_id HAVING COUNT(*) > 5;"))
 (P "⚠️ Desafíos" @("No agrupar correctamente: SELECT sin GROUP BY con agregación da error.","Olvidar HAVING: WHERE no funciona con funciones de agregación.","No redondear: AVG da muchos decimales."))
 (P "🔍 Dato" @("Los analistas junior pasan el 70% del tiempo haciendo GROUP BY.","Estas consultas se llaman OLAP.","Con GROUP BY respondes preguntas que en Excel tomarían horas."))
 (P "🎯 Consejo" @("Empieza simple y añade complejidad.","Verifica resultados con conteos manuales.","Cada respuesta de negocio es una consulta SQL."))
)
step="<div class=""code-block"">-- Ventas totales por mes<br>SELECT EXTRACT(YEAR FROM fecha) AS año, EXTRACT(MONTH FROM fecha) AS mes, SUM(total) AS ventas FROM pedidos GROUP BY año, mes ORDER BY año, mes;<br><br>-- Top 5 clientes por gasto<br>SELECT c.nombre, SUM(p.total) AS gasto FROM clientes c INNER JOIN pedidos p ON c.id=p.cliente_id GROUP BY c.nombre ORDER BY gasto DESC LIMIT 5;</div>"
summary="Has aplicado funciones de agregación, GROUP BY, HAVING y funciones de fecha para extraer información valiosa. Estas habilidades son las que buscan las empresas en un analista de datos."
}

# ============ CURSO 3 - JOINS (#2b9eff / 43,158,255) ============
$c3_01 = @{color="#2b9eff";rgb="43,158,255";style="classic"
obj=@("Entender qué son las llaves primarias","Entender qué son las llaves foráneas","Diferenciar PK de FK","Aplicar PK y FK en el diseño de tablas")
panels=@(
 (P "🧠 Intuición" @("La llave primaria (PK) es como el DNI de cada fila: identifica de forma única a cada registro. No puede haber dos filas con la misma PK.","La llave foránea (FK) es como un enlace a otra tabla: dice 'este valor existe en esa otra tabla'. Conecta tablas entre sí.","PK y FK son la base de las relaciones en bases de datos relacionales. Sin ellas, no podrías conectar tablas."))
 (P "📝 Sintaxis" @("CREATE TABLE tabla (id INTEGER PRIMARY KEY, ...);","CREATE TABLE hijos (id INTEGER PRIMARY KEY, padre_id INTEGER REFERENCES padres(id));","Una PK es única y no NULL.","Una FK apunta a una PK de otra tabla."))
 (P "💻 Ejemplo" @("Tabla clientes: id (PK), nombre, email.","Tabla pedidos: id (PK), cliente_id (FK → clientes.id), total, fecha.","Cada pedido pertenece a un cliente gracias a la FK."))
 (P "⚠️ Errores" @("Olvidar definir PK: las tablas sin PK pueden tener duplicados.","FK que apunta a columna incorrecta: tipo de dato debe coincidir.","No crear índice en FK: búsquedas serán lentas."))
 (P "🔍 Dato" @("PostgreSQL puede usar UUID como PK además de SERIAL.","Una tabla puede tener PK compuesta (múltiples columnas).","Las FK pueden tener acciones asociadas: CASCADE, SET NULL."))
 (P "🎯 Clave" @("PK = identifica cada fila de forma única.","FK = conecta con otra tabla.","PK/FK mantienen la integridad referencial.","Toda FK debe referenciar a una PK existente."))
)
step="<div class=""code-block"">-- Paso 1: Crear tabla con PK<br>CREATE TABLE clientes (id SERIAL PRIMARY KEY, nombre VARCHAR(100));<br><br>-- Paso 2: Crear tabla con FK<br>CREATE TABLE pedidos (id SERIAL PRIMARY KEY, cliente_id INTEGER REFERENCES clientes(id), total DECIMAL(10,2));<br><br>-- Paso 3: Consultar con PK/FK<br>SELECT c.nombre, p.total FROM clientes c INNER JOIN pedidos p ON c.id = p.cliente_id;</div>"
summary="Las llaves primarias (PK) identifican cada fila de forma única. Las llaves foráneas (FK) conectan tablas entre sí. Juntas mantienen la integridad referencial y son la base de las bases de datos relacionales."
}

$c3_02 = @{color="#2b9eff";rgb="43,158,255";style="classic"
obj=@("Entender relaciones 1:1, 1:M y M:M","Diseñar tablas según el tipo de relación","Implementar relaciones con PK y FK","Identificar el tipo de relación correcto")
panels=@(
 (P "🧠 Intuición" @("Las relaciones describen cómo se conectan las tablas. 1:1 es como persona-DNI (cada persona tiene un DNI). 1:M es como cliente-pedidos (un cliente tiene muchos pedidos). M:M es como estudiante-cursos (muchos estudiantes, muchos cursos).","Identificar la relación correcta es clave para diseñar bien la base de datos.","Las relaciones M:M requieren una tabla intermedia (tabla pivote)."))
 (P "📝 Tipos de Relaciones" @("1:1 — Una fila en A se relaciona con una en B. La FK puede estar en cualquier lado con UNIQUE.","1:M — Una fila en A se relaciona con muchas en B. La FK va en la tabla B (la 'muchos').","M:M — Muchas filas en A se relacionan con muchas en B. Se necesita tabla intermedia."))
 (P "💻 Ejemplo" @("1:1: usuario - perfil (cada usuario tiene un perfil).","1:M: cliente - pedidos (un cliente tiene muchos pedidos).","M:M: estudiante - inscripciones - curso (tabla intermedia inscripciones)."))
 (P "⚠️ Errores" @("Confundir 1:M con M:M: si no hay tabla intermedia, es 1:M.","No poner FK en el lado correcto: en 1:M, la FK va en el lado M.","Olvidar UNIQUE en la FK de 1:1."))
 (P "🔍 Dato" @("Las relaciones M:M siempre necesitan una tercera tabla con dos FK.","1:1 es rara en la práctica, normalmente es 1:M o M:M.","Las relaciones se representan en diagramas ER."))
 (P "🎯 Clave" @("1:1 — uno a uno (poco común).","1:M — uno a muchos (más común).","M:M — muchos a muchos (requiere tabla pivote).","Identificar bien la relación es clave del diseño."))
)
step="<div class=""code-block"">-- 1:M: Un cliente tiene muchos pedidos<br>CREATE TABLE clientes (id SERIAL PRIMARY KEY, nombre TEXT);<br>CREATE TABLE pedidos (id SERIAL PRIMARY KEY, cliente_id INTEGER REFERENCES clientes(id), total DECIMAL);<br><br>-- M:M: Estudiantes y cursos con tabla pivote<br>CREATE TABLE estudiantes (id SERIAL PRIMARY KEY, nombre TEXT);<br>CREATE TABLE cursos (id SERIAL PRIMARY KEY, titulo TEXT);<br>CREATE TABLE inscripciones (estudiante_id INTEGER REFERENCES estudiantes(id), curso_id INTEGER REFERENCES cursos(id), PRIMARY KEY (estudiante_id, curso_id));</div>"
summary="Las relaciones 1:1, 1:M y M:M definen cómo se conectan las tablas. 1:M es la más común, M:M requiere tabla intermedia. Identificar correctamente la relación es fundamental para diseñar buenas bases de datos."
}

$c3_03 = @{color="#2b9eff";rgb="43,158,255";style="classic"
obj=@("Usar INNER JOIN para combinar tablas","Entender qué filas devuelve INNER JOIN","Combinar datos de dos tablas relacionadas","Escribir la sintaxis correcta de JOIN")
panels=@(
 (P "🧠 Intuición" @("INNER JOIN es como una reunión de dos listas de invitados: solo ves a las personas que están en AMBAS listas. Si alguien falta en una, no aparece.","Cuando haces INNER JOIN de clientes y pedidos, solo obtienes los clientes que TIENEN pedidos y los pedidos que TIENEN cliente.","Es el tipo de JOIN más común y el que devuelve menos filas (solo las que coinciden)."))
 (P "📝 Sintaxis" @("SELECT columnas FROM tabla1 INNER JOIN tabla2 ON tabla1.col = tabla2.col;","La palabra INNER es opcional: JOIN = INNER JOIN.","ON especifica la condición de coincidencia (normalmente PK = FK).","Puedes usar alias: SELECT c.nombre, p.total FROM clientes c JOIN pedidos p ON c.id = p.cliente_id;"))
 (P "💻 Ejemplo" @("SELECT c.nombre, p.total FROM clientes c INNER JOIN pedidos p ON c.id = p.cliente_id;","SELECT p.nombre, c.nombre FROM productos p JOIN categorias c ON p.categoria_id = c.id;"))
 (P "⚠️ Errores" @("Olvidar la condición ON: sin ON obtienes un producto cartesiano.","Usar la columna equivocada en ON: c.id = p.cliente_id (PK = FK).","No usar alias: en tablas grandes es difícil leer la consulta."))
 (P "🔍 Dato" @("INNER JOIN puede usarse con operadores distintos de = (pero es raro).","SQL ejecuta el JOIN antes que WHERE.","Puedes hacer JOIN de una tabla consigo misma (self-join)."))
 (P "🎯 Clave" @("INNER JOIN = solo filas que coinciden en ambas tablas.","ON = condición de coincidencia (normalmente PK = FK).","Usa alias para tablas.","INNER es opcional."))
)
step="<div class=""code-block"">-- Paso 1: Datos separados<br>SELECT * FROM clientes; -- id, nombre<br>SELECT * FROM pedidos; -- id, cliente_id, total<br><br>-- Paso 2: Combinar con INNER JOIN<br>SELECT c.nombre, p.total, p.fecha<br>FROM clientes c<br>INNER JOIN pedidos p ON c.id = p.cliente_id;<br><br>-- Paso 3: Clientes que NO han pedido no aparecen<br>-- (solo clientes con al menos un pedido)</div>"
summary="INNER JOIN combina filas de dos tablas donde hay coincidencia. Solo devuelve las filas que existen en AMBAS tablas según la condición ON. Es el JOIN más usado y el que debes dominar primero."
}

$c3_04 = @{color="#2b9eff";rgb="43,158,255";style="classic"
obj=@("Usar LEFT JOIN para incluir filas de la izquierda","Usar RIGHT JOIN para incluir filas de la derecha","Entender la diferencia con INNER JOIN","Aplicar LEFT JOIN en consultas reales")
panels=@(
 (P "🧠 Intuición" @("LEFT JOIN es como una fiesta donde INVITAS a TODOS, pero no todos vienen. La lista de invitados (tabla izquierda) está completa, y los que vinieron aparecen con sus datos. Los que no vinieron aparecen con NULL.","LEFT JOIN da TODAS las filas de la izquierda y las coincidentes de la derecha. Si no hay coincidencia, la derecha es NULL.","RIGHT JOIN es lo mismo pero al revés: todas las de la derecha."))
 (P "📝 Sintaxis" @("SELECT * FROM tabla1 LEFT JOIN tabla2 ON cond;","SELECT * FROM tabla1 RIGHT JOIN tabla2 ON cond;","LEFT JOIN se usa más que RIGHT JOIN por convención.","Para excluir las que NO coinciden: WHERE tabla2.col IS NULL."))
 (P "💻 Ejemplo" @("Todos los clientes con sus pedidos (incluyendo los que no han pedido): SELECT c.nombre, p.total FROM clientes c LEFT JOIN pedidos p ON c.id = p.cliente_id;","Clientes sin pedidos: SELECT c.nombre FROM clientes c LEFT JOIN pedidos p ON c.id = p.cliente_id WHERE p.id IS NULL;"))
 (P "⚠️ Errores" @("Confundir LEFT JOIN con INNER JOIN: LEFT JOIN conserva todas las filas de la izquierda.","Poner WHERE con condición de la derecha: convierte LEFT JOIN en INNER JOIN.","Olvidar que RIGHT JOIN es el inverso de LEFT JOIN."))
 (P "🔍 Dato" @("LEFT JOIN se escribe a veces LEFT OUTER JOIN (OUTER es opcional).","RIGHT JOIN es poco usado porque puedes reordenar las tablas con LEFT JOIN.","PostgreSQL trata LEFT/RIGHT JOIN de forma muy eficiente."))
 (P "🎯 Clave" @("LEFT JOIN = todas las filas de la izquierda + coincidencias de la derecha.","RIGHT JOIN = todas las filas de la derecha + coincidencias de la izquierda.","Sin coincidencia → valores NULL.","WHERE ... IS NULL para filas sin coincidencia."))
)
step="<div class=""code-block"">-- Paso 1: Todos los clientes (con o sin pedidos)<br>SELECT c.nombre, p.total FROM clientes c LEFT JOIN pedidos p ON c.id = p.cliente_id;<br><br>-- Paso 2: Solo clientes sin pedidos<br>SELECT c.nombre FROM clientes c LEFT JOIN pedidos p ON c.id = p.cliente_id WHERE p.id IS NULL;<br><br>-- Paso 3: Equivalentes RIGHT JOIN<br>SELECT c.nombre, p.total FROM pedidos p RIGHT JOIN clientes c ON c.id = p.cliente_id;</div>"
summary="LEFT JOIN conserva todas las filas de la tabla izquierda más las coincidencias de la derecha. RIGHT JOIN hace lo inverso. Úsalos cuando necesites incluir filas aunque no tengan correspondencia en la otra tabla."
}

$c3_05 = @{color="#2b9eff";rgb="43,158,255";style="classic"
obj=@("Usar FULL OUTER JOIN","Entender su comportamiento con NULL","Diferenciarlo de LEFT y RIGHT JOIN","Aplicarlo cuando se necesitan ambas direcciones")
panels=@(
 (P "🧠 Intuición" @("FULL OUTER JOIN es como tomar DOS listas de invitados y ver quién está en alguna. Muestra TODAS las filas de ambas tablas, coincidan o no. Las que no coinciden aparecen con NULL.","Es útil para encontrar datos que están en una tabla pero no en la otra, en ambas direcciones.","Es el menos usado de los JOINs pero muy valioso para auditorías y comparaciones."))
 (P "📝 Sintaxis" @("SELECT * FROM tabla1 FULL OUTER JOIN tabla2 ON cond;","Devuelve filas de LEFT JOIN + RIGHT JOIN combinadas.","Sin coincidencia: una tabla da NULL.","Equivalente a: LEFT JOIN + RIGHT JOIN - INNER JOIN."))
 (P "💻 Ejemplo" @("SELECT c.nombre, p.total FROM clientes c FULL OUTER JOIN pedidos p ON c.id = p.cliente_id;","Clientes sin pedidos O pedidos sin clientes (datos huérfanos)."))
 (P "⚠️ Errores" @("Usar FULL OUTER JOIN cuando LEFT JOIN es suficiente.","Olvidar que puede devolver NULL de cualquiera de las dos tablas.","No todos los SGBD soportan FULL OUTER JOIN (MySQL no nativamente)."))
 (P "🔍 Dato" @("MySQL no soporta FULL OUTER JOIN directamente, pero se simula con UNION de LEFT y RIGHT JOIN.","FULL OUTER JOIN es muy usado en análisis de datos y migraciones.","En PostgreSQL, FULL OUTER JOIN es muy eficiente."))
 (P "🎯 Clave" @("FULL OUTER JOIN = todas las filas de ambas tablas.","NULL donde no hay coincidencia.","Útil para encontrar datos huérfanos.","LEFT JOIN + RIGHT JOIN + INNER JOIN en uno."))
)
step="<div class=""code-block"">-- Paso 1: FULL OUTER JOIN básico<br>SELECT c.nombre, p.total FROM clientes c FULL OUTER JOIN pedidos p ON c.id = p.cliente_id;<br><br>-- Paso 2: Encontrar datos huérfanos<br>SELECT c.nombre, p.total FROM clientes c FULL OUTER JOIN pedidos p ON c.id = p.cliente_id WHERE c.id IS NULL OR p.id IS NULL;<br><br>-- Paso 3: En PostgreSQL, también se puede hacer con UNION<br>SELECT c.nombre, p.total FROM clientes c LEFT JOIN pedidos p ON c.id = p.cliente_id<br>UNION<br>SELECT c.nombre, p.total FROM clientes c RIGHT JOIN pedidos p ON c.id = p.cliente_id;</div>"
summary="FULL OUTER JOIN combina todas las filas de ambas tablas. Las que no tienen coincidencia aparecen con NULL. Es ideal para auditorías y para encontrar datos huérfanos en migraciones."
}

$c3_06 = @{color="#2b9eff";rgb="43,158,255";style="classic"
obj=@("Usar CROSS JOIN","Entender el producto cartesiano","Diferenciarlo de otros JOINs","Aplicar CROSS JOIN en casos específicos")
panels=@(
 (P "🧠 Intuición" @("CROSS JOIN es como multiplicar dos listas: cada elemento de la primera se combina con cada elemento de la segunda. Si tienes 3 colores y 2 tallas, obtienes 6 combinaciones.","Se llama producto cartesiano (como en matemáticas). Si tabla A tiene 100 filas y tabla B tiene 50, CROSS JOIN devuelve 5000 filas.","Es poco usado pero esencial para generar combinaciones completas."))
 (P "📝 Sintaxis" @("SELECT * FROM tabla1 CROSS JOIN tabla2;","SELECT * FROM tabla1, tabla2; — sintaxis implícita.","No tiene cláusula ON.","También se puede hacer con FROM tabla1, tabla2 (JOIN implícito)."))
 (P "💻 Ejemplo" @("-- Todas las combinaciones de productos y meses<br>SELECT p.nombre, m.mes FROM productos p CROSS JOIN meses m;","-- Generar horarios: empleados × turnos<br>SELECT e.nombre, t.hora FROM empleados e CROSS JOIN turnos t;"))
 (P "⚠️ Errores" @("Olvidar la condición WHERE en un JOIN implícito: SELECT * FROM A, B sin WHERE da CROSS JOIN accidental.","CROSS JOIN en tablas grandes produce resultados enormes.","No es lo mismo que INNER JOIN sin ON."))
 (P "🔍 Dato" @("CROSS JOIN es el JOIN más costoso: N × M filas.","Útil para generar data de prueba o calendarios.","Muchos SGBD optimizan CROSS JOIN si detectan que no es necesario."))
 (P "🎯 Clave" @("CROSS JOIN = todas las combinaciones posibles.","Sin condición ON.","N × M filas resultantes.","Usar con cuidado (puede generar muchos datos)."))
)
step="<div class=""code-block"">-- Paso 1: CROSS JOIN básico<br>SELECT * FROM colores CROSS JOIN tallas;<br>-- Rojo | S, Rojo | M, Rojo | L, Azul | S, Azul | M, Azul | L...<br><br>-- Paso 2: Para generar un calendario<br>SELECT d.dia, m.mes FROM dias d CROSS JOIN meses m WHERE m.mes_num <= 12;<br><br>-- Paso 3: Sintaxis implícita (antigua)<br>SELECT * FROM productos, categorias;</div>"
summary="CROSS JOIN produce el producto cartesiano: cada fila de A se combina con cada fila de B. No tiene condición ON. Es útil para generar combinaciones completas pero peligroso en tablas grandes."
}

$c3_07 = @{color="#2b9eff";rgb="43,158,255";style="classic"
obj=@("Usar NATURAL JOIN","Usar la cláusula USING","Entender sus diferencias con INNER JOIN","Saber cuándo usarlos con precaución")
panels=@(
 (P "🧠 Intuición" @("NATURAL JOIN es como un INNER JOIN automático: SQL descubre por sí mismo las columnas con el mismo nombre y hace la coincidencia. Es cómodo pero peligroso.","USING es más explícito: le dices a SQL qué columna(s) usar para la coincidencia, pero sin escribir la tabla.","Ambos son atajos para escribir menos código, pero reducen la claridad."))
 (P "📝 Sintaxis" @("SELECT * FROM tabla1 NATURAL JOIN tabla2;","SELECT * FROM tabla1 JOIN tabla2 USING (columna_comun);","NATURAL JOIN usa TODAS las columnas con el mismo nombre.","USING usa solo las columnas especificadas."))
 (P "💻 Ejemplo" @("SELECT * FROM clientes NATURAL JOIN pedidos; — si ambas tienen 'id' como mismo significado, funciona.","SELECT * FROM clientes JOIN pedidos USING (cliente_id); — más seguro que NATURAL."))
 (P "⚠️ Errores" @("NATURAL JOIN puede dar resultados incorrectos si hay columnas con el mismo nombre pero diferente significado.","No hay control sobre qué columnas usa NATURAL.","USING elimina la columna duplicada del resultado."))
 (P "🔍 Dato" @("NATURAL JOIN es parte del estándar SQL pero muchos expertos lo evitan.","USING es más seguro que NATURAL JOIN.","Algunos SGBD no soportan NATURAL JOIN."))
 (P "🎯 Clave" @("NATURAL JOIN = JOIN automático por columnas con mismo nombre.","USING = JOIN por columna(s) específica(s).","Ambos evitan escribir la condición ON.","Úsalos con precaución: prefiero ON explícito."))
)
step="<div class=""code-block"">-- Paso 1: NATURAL JOIN (automático)<br>SELECT * FROM clientes NATURAL JOIN pedidos;<br>-- Asume que 'id' en clientes = 'id' en pedidos (peligroso si no es así)<br><br>-- Paso 2: USING (más seguro)<br>SELECT * FROM clientes JOIN pedidos USING (cliente_id);<br>-- Solo usa la columna 'cliente_id' para la coincidencia<br><br>-- Paso 3: Equivalente con ON<br>SELECT * FROM clientes c JOIN pedidos p ON c.cliente_id = p.cliente_id;</div>"
summary="NATURAL JOIN y USING son atajos para escribir JOINs sin ON explícito. NATURAL es automático (y peligroso), USING es más controlado. En código profesional, prefiere ON explícito para mayor claridad."
}

$c3_08 = @{color="#2b9eff";rgb="43,158,255";style="classic"
obj=@("Usar Self-Join para unir una tabla consigo misma","Aplicar Self-Join con relaciones jerárquicas","Usar alias para distinguir las copias de la tabla","Resolver problemas de empleados-jefe, categorías anidadas")
panels=@(
 (P "🧠 Intuición" @("Self-Join es como un espejo: una tabla se mira a sí misma. Se usa para relaciones jerárquicas como empleados que tienen un jefe (que también es empleado).","Necesitas usar alias para distinguir la 'tabla de empleados' de la 'tabla de jefes', aunque sean la misma tabla física.","Es confuso al principio pero muy poderoso para datos jerárquicos."))
 (P "📝 Sintaxis" @("SELECT a.col, b.col FROM tabla a JOIN tabla b ON a.id = b.padre_id;","Los alias (a, b) son OBLIGATORIOS en Self-Join.","Puedes usar cualquier tipo de JOIN (INNER, LEFT, etc.)."))
 (P "💻 Ejemplo" @("SELECT e.nombre AS empleado, j.nombre AS jefe FROM empleados e LEFT JOIN empleados j ON e.jefe_id = j.id;","SELECT c1.nombre AS cat, c2.nombre AS subcat FROM categorias c1 JOIN categorias c2 ON c1.id = c2.padre_id;"))
 (P "⚠️ Errores" @("Olvidar los alias: SQL no sabe a qué copia de la tabla te refieres.","Usar INNER JOIN y perder empleados sin jefe (usa LEFT JOIN).","Crear uniones cíclicas accidentales."))
 (P "🔍 Dato" @("Self-Join se usa para listas de adyacencia en grafos.","PostgreSQL soporta WITH RECURSIVE para jerarquías más complejas.","Self-Join funciona con cualquier tipo de JOIN."))
 (P "🎯 Clave" @("Self-Join = una tabla unida consigo misma.","Los alias son obligatorios.","Útil para jerarquías (empleado-jefe, categorías).","LEFT JOIN para no perder filas sin relación."))
)
step="<div class=""code-block"">-- Paso 1: Self-Join básico (empleado - jefe)<br>SELECT e.nombre AS empleado, j.nombre AS jefe<br>FROM empleados e<br>LEFT JOIN empleados j ON e.jefe_id = j.id;<br><br>-- Paso 2: Categorías y subcategorías<br>SELECT c1.nombre AS principal, c2.nombre AS subcategoria<br>FROM categorias c1<br>INNER JOIN categorias c2 ON c1.id = c2.padre_id;</div>"
summary="Self-Join une una tabla consigo misma usando alias. Es esencial para datos jerárquicos como empleados con jefes o categorías anidadas. Usa LEFT JOIN para conservar todos los registros."
}

$c3_09 = @{color="#2b9eff";rgb="43,158,255";style="classic"
obj=@("Unir más de 2 tablas con JOINs múltiples","Combinar INNER, LEFT y otros JOINs","Construir consultas complejas con varias tablas","Usar alias para mantener legibilidad")
panels=@(
 (P "🧠 Intuición" @("Unir 3+ tablas es como armar un rompecabezas de varias piezas. Cada JOIN añade una pieza nueva conectada por una FK.","El orden de los JOINs importa para el rendimiento: primero las tablas más pequeñas o más restrictivas.","Cada JOIN adicional aumenta la complejidad mental de la consulta."))
 (P "📝 Sintaxis" @("SELECT * FROM a JOIN b ON a.id = b.a_id JOIN c ON b.id = c.b_id;","Puedes mezclar tipos: FROM a LEFT JOIN b ON ... JOIN c ON ...","Cada JOIN necesita su propia condición ON."))
 (P "💻 Ejemplo" @("SELECT c.nombre, p.total, pr.nombre FROM clientes c JOIN pedidos p ON c.id = p.cliente_id JOIN productos pr ON p.producto_id = pr.id;","SELECT e.nombre, d.nombre, s.nombre FROM empleados e JOIN deptos d ON e.depto_id = d.id JOIN sucursales s ON d.sucursal_id = s.id;"))
 (P "⚠️ Errores" @("Olvidar una condición ON: error de sintaxis.","JOIN en orden incorrecto: puede ser más lento.","No usar alias: consultas largas e ilegibles."))
 (P "🔍 Dato" @("Cada JOIN adicional puede multiplicar el número de filas.","El optimizador de PostgreSQL reordena los JOINs si es más eficiente.","Puedes usar subconsultas para simplificar JOINs múltiples."))
 (P "🎯 Clave" @("Cada tabla adicional necesita un JOIN.","Cada JOIN necesita ON.","Usa alias para claridad.","El orden afecta al rendimiento."))
)
step="<div class=""code-block"">-- Paso 1: JOIN de 3 tablas<br>SELECT c.nombre AS cliente, p.total AS pedido, pr.nombre AS producto<br>FROM clientes c<br>JOIN pedidos p ON c.id = p.cliente_id<br>JOIN productos pr ON p.producto_id = pr.id;<br><br>-- Paso 2: 4 tablas con LEFT JOIN<br>SELECT e.nombre, d.nombre AS depto, s.ciudad, r.nombre AS region<br>FROM empleados e<br>JOIN departamentos d ON e.depto_id = d.id<br>LEFT JOIN sucursales s ON d.sucursal_id = s.id<br>LEFT JOIN regiones r ON s.region_id = r.id;</div>"
summary="Puedes unir 3 o más tablas encadenando JOINs. Cada JOIN necesita su condición ON. Usa alias para mantener la legibilidad. El orden de los JOINs puede afectar al rendimiento."
}

$c3_10 = @{color="#2b9eff";rgb="43,158,255";style="classic"
obj=@("Usar condiciones compuestas en JOIN","Combinar múltiples condiciones con AND/OR","Aplicar JOIN con condiciones no-igualdad","Resolver casos donde una columna no es suficiente")
panels=@(
 (P "🧠 Intuición" @("A veces una sola condición no basta para conectar dos tablas. Las condiciones compuestas usan AND/OR para múltiples criterios de coincidencia.","Por ejemplo, unir pedidos con descuentos donde la fecha del pedido esté entre la fecha_inicio y fecha_fin del descuento.","La condición ON puede usar cualquier expresión booleana, no solo igualdad."))
 (P "📝 Sintaxis" @("SELECT * FROM a JOIN b ON a.col1 = b.col1 AND a.col2 = b.col2;","SELECT * FROM a JOIN b ON a.fecha BETWEEN b.ini AND b.fin;","SELECT * FROM a JOIN b ON a.precio BETWEEN b.precio_min AND b.precio_max;"))
 (P "💻 Ejemplo" @("-- Descuentos aplicables por fecha<br>SELECT p.*, d.descuento FROM pedidos p JOIN descuentos d ON p.fecha BETWEEN d.valido_desde AND d.valido_hasta AND p.total >= d.minimo;"))
 (P "⚠️ Errores" @("Poner condiciones del filtro en ON en vez de WHERE: aunque funciona, es confuso.","Usar OR en condiciones de JOIN: puede generar productos cartesianos no deseados."))
 (P "🔍 Dato" @("Las condiciones compuestas en JOIN son menos comunes pero muy poderosas.","PostgreSQL optimiza bien las condiciones compuestas.","Útil para tablas de rangos y períodos de validez."))
 (P "🎯 Clave" @("ON puede tener múltiples condiciones con AND/OR.","No solo igualdad: BETWEEN, >, < también funcionan.","Condiciones en ON filtran antes del JOIN.","Útil para rangos de fechas y precios."))
)
step="<div class=""code-block"">-- Paso 1: JOIN con AND<br>SELECT * FROM pedidos p JOIN descuentos d ON p.total BETWEEN d.minimo AND d.maximo AND p.fecha BETWEEN d.ini AND d.fin;<br><br>-- Paso 2: JOIN compuesto por clave<br>SELECT * FROM pedidos p JOIN detalle_pedido dp ON p.id = dp.pedido_id AND p.cliente_id = dp.cliente_id;<br><br>-- Paso 3: JOIN con rango de precios<br>SELECT pr.nombre, o.precio_oferta FROM productos pr JOIN ofertas o ON pr.precio BETWEEN o.precio_min AND o.precio_max;</div>"
summary="Las condiciones compuestas en JOIN permiten múltiples criterios de coincidencia usando AND/OR y operadores como BETWEEN. Son útiles para rangos de fechas, precios y claves compuestas."
}

$c3_11 = @{color="#2b9eff";rgb="43,158,255";style="classic"
obj=@("Entender qué son los anti-joins","Usar NOT EXISTS y NOT IN","Usar LEFT JOIN ... IS NULL","Aplicar anti-joins para exclusión")
panels=@(
 (P "🧠 Intuición" @("Anti-join es lo opuesto a INNER JOIN: encuentra filas que NO tienen correspondencia. 'Dame los clientes que NO han hecho pedidos'.","Hay tres formas: NOT EXISTS, NOT IN, y LEFT JOIN ... IS NULL. Cada una tiene sus ventajas y riesgos.","NOT EXISTS es la más segura y recomendada."))
 (P "📝 Sintaxis" @("SELECT * FROM a WHERE NOT EXISTS (SELECT 1 FROM b WHERE a.id = b.a_id);","SELECT * FROM a WHERE id NOT IN (SELECT a_id FROM b);","SELECT a.* FROM a LEFT JOIN b ON a.id = b.a_id WHERE b.id IS NULL;"))
 (P "💻 Ejemplo" @("-- Clientes sin pedidos (recomendado)<br>SELECT * FROM clientes c WHERE NOT EXISTS (SELECT 1 FROM pedidos p WHERE p.cliente_id = c.id);","-- Productos nunca vendidos<br>SELECT * FROM productos p WHERE NOT EXISTS (SELECT 1 FROM ventas v WHERE v.producto_id = p.id);"))
 (P "⚠️ Errores" @("NOT IN con NULL: si la subconsulta devuelve NULL, el resultado es vacío. Siempre.","LEFT JOIN ... IS NULL puede ser más lento en tablas grandes.","NOT EXISTS es generalmente la más segura y eficiente."))
 (P "🔍 Dato" @("NOT EXISTS corta la ejecución en cuanto encuentra la primera coincidencia.","PostgreSQL optimiza NOT EXISTS muy bien.","En SQL Server, NOT IN puede ser problemático con NULL."))
 (P "🎯 Clave" @("Anti-join = filas que NO se corresponden.","NOT EXISTS es la forma recomendada.","NOT IN es peligroso con NULL.","LEFT JOIN ... IS NULL es la forma visual."))
)
step="<div class=""code-block"">-- Las 3 formas de anti-join:<br><br>-- Forma 1: NOT EXISTS (recomendada)<br>SELECT * FROM clientes c WHERE NOT EXISTS (SELECT 1 FROM pedidos p WHERE p.cliente_id = c.id);<br><br>-- Forma 2: LEFT JOIN ... IS NULL<br>SELECT c.* FROM clientes c LEFT JOIN pedidos p ON c.id = p.cliente_id WHERE p.id IS NULL;<br><br>-- Forma 3: NOT IN (cuidado con NULL)<br>SELECT * FROM clientes WHERE id NOT IN (SELECT cliente_id FROM pedidos);</div>"
summary="Los anti-joins encuentran filas sin correspondencia. NOT EXISTS es la forma más segura y recomendada. NOT IN es riesgoso con NULL. LEFT JOIN ... IS NULL es clara visualmente. Anti-joins son esenciales para encontrar datos huérfanos o excluir categorías."
}

$c3_12 = @{color="#2b9eff";rgb="43,158,255";style="classic"
obj=@("Aplicar todos los tipos de JOIN","Resolver consultas complejas de pedidos","Combinar múltiples tablas en una consulta","Usar JOINs en un escenario real")
panels=@(
 (P "🧠 Intuición" @("Este mini-proyecto simula un sistema de pedidos real con clientes, productos, pedidos y detalle de pedidos. Usarás todos los tipos de JOIN.","Es el proyecto más completo del curso, integrando PK/FK, INNER/LEFT/Self-Join y agregaciones.","Al completarlo, estarás listo para modelar cualquier sistema de ventas."))
 (P "📝 Proyecto" @("Diseñar tablas con PK y FK.","Usar INNER JOIN para consultas básicas.","LEFT JOIN para incluir todos los clientes.","Self-Join para jerarquías de productos.","Agregaciones con GROUP BY y JOIN."))
 (P "💻 Consultas" @("Total gastado por cada cliente.","Productos más vendidos.","Clientes que nunca compraron.","Categorías con más productos."))
 (P "⚠️ Desafíos" @("JOINs sin ON: producto cartesiano accidental.","LEFT JOIN convertido en INNER JOIN por WHERE.","No usar alias en consultas largas."))
 (P "🔍 Dato" @("En sistemas reales, las consultas tienen 5-10 JOINs o más.","Saber JOINs bien es la habilidad más valorada en SQL."))
 (P "🎯 Consejo" @("Dibuja el diagrama de tablas antes de escribir la consulta.","Empieza con 2 tablas y ve añadiendo.","Usa LEFT JOIN si no estás seguro del tipo."))
)
step="<div class=""code-block"">-- Sistema de pedidos completo<br>SELECT c.nombre, COUNT(p.id) AS pedidos, SUM(p.total) AS gasto_total<br>FROM clientes c<br>LEFT JOIN pedidos p ON c.id = p.cliente_id<br>GROUP BY c.nombre<br>ORDER BY gasto_total DESC NULLS LAST;<br><br>-- Productos más vendidos<br>SELECT pr.nombre, SUM(dp.cantidad) AS vendidos<br>FROM productos pr<br>JOIN detalle_pedido dp ON pr.id = dp.producto_id<br>GROUP BY pr.nombre ORDER BY vendidos DESC LIMIT 10;</div>"
summary="Has completado el sistema de pedidos usando todos los tipos de JOIN: INNER, LEFT, RIGHT, FULL, CROSS, Self-Join y anti-joins. Estas habilidades son las que diferencian a un analista SQL avanzado."
}

# ============ CURSO 4 - SUBCONSULTAS (#9c64ff / 156,100,255) ============
$c4_01 = @{color="#9c64ff";rgb="156,100,255";style="modern"
obj=@("Entender qué son las subconsultas escalares","Usar subconsultas dentro de SELECT","Devolver un solo valor con subconsultas","Combinar subconsultas con consultas principales")
panels=@(
 (P "🧠 Intuición" @("Una subconsulta escalar es como preguntar '¿cuál es el promedio del salón?' y usar ese número en otra pregunta. Es una consulta dentro de otra que devuelve un solo valor.","La subconsulta se ejecuta PRIMERO y su resultado se usa en la consulta principal. Como calcular el promedio antes de comparar.","Solo puede devolver UNA fila y UNA columna. Si devuelve más, da error."))
 (P "📝 Sintaxis" @("SELECT col, (SELECT AVG(col2) FROM tabla2) AS promedio FROM tabla1;","La subconsulta va entre paréntesis.","Debe devolver exactamente un valor (una fila, una columna).","Se usa en SELECT, WHERE, HAVING y otras cláusulas."))
 (P "💻 Ejemplo" @("SELECT nombre, salario, (SELECT AVG(salario) FROM empleados) AS promedio FROM empleados; — cada empleado ve su salario vs el promedio.","SELECT nombre, (SELECT MAX(precio) FROM productos) AS maximo FROM clientes;"))
 (P "⚠️ Errores" @("Subconsulta devuelve varias filas: error de subconsulta escalar.","Olvidar paréntesis: error de sintaxis.","No alinear correctamente: las subconsultas pueden ser difíciles de leer."))
 (P "🔍 Dato" @("Las subconsultas escalares se ejecutan UNA vez para toda la consulta principal (si no son correlacionadas).","Pueden anidarse varias niveles.","Son menos eficientes que JOINs en algunos casos."))
 (P "🎯 Clave" @("Devuelve exactamente UN valor.","Va entre paréntesis.","Se ejecuta antes (si es no-correlacionada).","Útil para comparaciones con agregados."))
)
step="<div class=""code-block"">-- Paso 1: Subconsulta escalar en SELECT<br>SELECT nombre, salario, (SELECT AVG(salario) FROM empleados) AS salario_promedio FROM empleados;<br><br>-- Paso 2: Se ve el salario de cada empleado junto al promedio general<br>-- Esto permite comparar: ¿ganas más o menos que el promedio?<br><br>-- Paso 3: También en WHERE<br>SELECT nombre FROM empleados WHERE salario > (SELECT AVG(salario) FROM empleados);</div>"
summary="Las subconsultas escalares devuelven un solo valor usado en la consulta principal. Son ideales para comparar valores individuales contra agregados. Siempre van entre paréntesis y deben devolver exactamente una fila y una columna."
}

$c4_02 = @{color="#9c64ff";rgb="156,100,255";style="modern"
obj=@("Usar subconsultas en WHERE con =","Comparar con subconsultas de una fila","Asegurar que la subconsulta devuelve una fila","Aplicar en filtros dinámicos")
panels=@(
 (P "🧠 Intuición" @("Cuando sabes que una subconsulta devuelve UNA fila, puedes usar = para comparar. Es como decir 'dame los productos cuyo precio sea igual al precio más caro'.","La subconsulta calcula un valor específico (mínimo, máximo, promedio) y la consulta principal lo usa como filtro.","Es más elegante que hacer dos consultas separadas."))
 (P "📝 Sintaxis" @("SELECT * FROM tabla WHERE col = (SELECT col2 FROM tabla2 WHERE condicion);","La subconsulta debe devolver EXACTAMENTE una fila.","Si devuelve 0 filas → el resultado es NULL.","Si devuelve >1 filas → error."))
 (P "💻 Ejemplo" @("SELECT * FROM productos WHERE precio = (SELECT MAX(precio) FROM productos); — producto más caro.","SELECT * FROM empleados WHERE salario = (SELECT MIN(salario) FROM empleados); — el que menos gana."))
 (P "⚠️ Errores" @("Usar = con subconsulta que devuelve varias filas: usa IN en su lugar.","Asumir que la subconsulta siempre devolverá una fila (puede ser ninguna)."))
 (P "🔍 Dato" @("Esta técnica se llama 'subconsulta de una fila'.","Es común con funciones de agregación (MIN, MAX, AVG).","PostgreSQL es estricto: si devuelve más de una fila, da error."))
 (P "🎯 Clave" @("Usa = solo cuando sepas que devuelve una fila.","Funciones agregadas siempre devuelven una fila.","Si puede devolver varias, usa IN."))
)
step="<div class=""code-block"">-- Paso 1: Producto más caro<br>SELECT * FROM productos WHERE precio = (SELECT MAX(precio) FROM productos);<br><br>-- Paso 2: Empleado con menor salario<br>SELECT * FROM empleados WHERE salario = (SELECT MIN(salario) FROM empleados);<br><br>-- Paso 3: Productos con precio mayor al promedio<br>SELECT * FROM productos WHERE precio > (SELECT AVG(precio) FROM productos);</div>"
summary="Usa subconsultas con = en WHERE cuando la subconsulta devuelva una sola fila. Es perfecto para comparar con valores agregados como MAX, MIN, AVG. Si puede devolver varias filas, usa IN."
}

$c4_03 = @{color="#9c64ff";rgb="156,100,255";style="modern"
obj=@("Usar IN con subconsultas","Usar NOT IN con subconsultas","Manejar subconsultas de múltiples filas","Evitar el problema de NULL en NOT IN")
panels=@(
 (P "🧠 Intuición" @("IN con subconsultas es como tener una lista dinámica. En vez de escribir IN (1, 2, 3), la subconsulta genera la lista automáticamente.","Perfecto para 'dame todos los clientes que han hecho pedidos' sin necesidad de JOIN.","NOT IN hace lo contrario: 'dame los que NO han hecho pedidos'."))
 (P "📝 Sintaxis" @("SELECT * FROM tabla WHERE col IN (SELECT col2 FROM tabla2);","SELECT * FROM tabla WHERE col NOT IN (SELECT col2 FROM tabla2);","La subconsulta puede devolver múltiples filas.","La subconsulta devuelve una sola columna."))
 (P "💻 Ejemplo" @("SELECT * FROM clientes WHERE id IN (SELECT cliente_id FROM pedidos); — clientes con pedidos.","SELECT * FROM productos WHERE id NOT IN (SELECT producto_id FROM ventas); — productos no vendidos."))
 (P "⚠️ Errores" @("NOT IN con NULL en la subconsulta: el resultado SIEMPRE será vacío. Usa NOT EXISTS.","Olvidar que la subconsulta debe devolver UNA columna."))
 (P "🔍 Dato" @("IN con subconsulta se optimiza internamente como un JOIN.","NOT EXISTS es más seguro que NOT IN porque maneja NULL correctamente."))
 (P "🎯 Clave" @("IN = múltiples valores de subconsulta.","NOT IN es peligroso con NULL → usa NOT EXISTS.","La subconsulta devuelve una columna, varias filas."))
)
step="<div class=""code-block"">-- Paso 1: IN con subconsulta<br>SELECT nombre FROM clientes WHERE id IN (SELECT cliente_id FROM pedidos);<br><br>-- Paso 2: NOT IN (cuidado con NULL)<br>SELECT nombre FROM productos WHERE id NOT IN (SELECT producto_id FROM ventas WHERE producto_id IS NOT NULL);<br><br>-- Paso 3: Alternativa segura con NOT EXISTS<br>SELECT nombre FROM productos p WHERE NOT EXISTS (SELECT 1 FROM ventas v WHERE v.producto_id = p.id);</div>"
summary="IN con subconsultas crea listas dinámicas de valores. NOT IN es útil pero peligroso si hay NULL. Prefiere NOT EXISTS para exclusión cuando haya posibilidad de NULL en los resultados."
}

$c4_04 = @{color="#9c64ff";rgb="156,100,255";style="modern"
obj=@("Usar ANY para comparar con un conjunto","Usar ALL para comparar con todo un conjunto","Entender SOME como sinónimo de ANY","Aplicar comparaciones avanzadas")
panels=@(
 (P "🧠 Intuición" @("ANY y ALL son como comparadores 'superpoderosos'. ANY responde '¿es mayor que ALGUNO?'. ALL responde '¿es mayor que TODOS?'.","ANY es como OR: si cumple con cualquiera de la lista, es TRUE. ALL es como AND: debe cumplir con todos.","SOME es sinónimo de ANY, se usan igual."))
 (P "📝 Sintaxis" @("WHERE col > ANY (SELECT col2 FROM tabla2) — mayor que al menos uno.","WHERE col > ALL (SELECT col2 FROM tabla2) — mayor que todos.","Operadores: =, <>, >, <, >=, <=","= ANY equivale a IN."))
 (P "💻 Ejemplo" @("SELECT * FROM productos WHERE precio > ANY (SELECT precio FROM productos WHERE categoria = 'Premium');","SELECT * FROM empleados WHERE salario > ALL (SELECT salario FROM empleados WHERE depto = 'Ventas');"))
 (P "⚠️ Errores" @("Confundir ANY con ALL: ANY es 'al menos uno', ALL es 'todos'.","ALL con conjunto vacío siempre es TRUE (condición vacía).","ANY con conjunto vacío siempre es FALSE."))
 (P "🔍 Dato" @("= ANY (SELECT ...) es equivalente a IN (SELECT ...).","SOME se introdujo para legibilidad pero es idéntico a ANY.","PostgreSQL optimiza ANY/ALL de forma diferente a IN."))
 (P "🎯 Clave" @("ANY = al menos un valor del conjunto.","ALL = todos los valores del conjunto.","= ANY = IN.","SOME = ANY."))
)
step="<div class=""code-block"">-- Paso 1: ANY — mayor que algún producto de Electronica<br>SELECT * FROM productos WHERE precio > ANY (SELECT precio FROM productos WHERE categoria = 'Electronica');<br><br>-- Paso 2: ALL — mayor que TODOS los productos de Electronica<br>SELECT * FROM productos WHERE precio > ALL (SELECT precio FROM productos WHERE categoria = 'Electronica');<br><br>-- Paso 3: = ANY equivale a IN<br>SELECT * FROM clientes WHERE id = ANY (SELECT cliente_id FROM pedidos);</div>"
summary="ANY compara con 'al menos uno' del conjunto, ALL con 'todos'. = ANY equivale a IN. Son operadores poderosos para comparaciones avanzadas con subconsultas."
}

$c4_05 = @{color="#9c64ff";rgb="156,100,255";style="modern"
obj=@("Usar EXISTS para verificar existencia","Usar NOT EXISTS para ausencia","Entender la eficiencia de EXISTS","Diferenciar EXISTS de IN")
panels=@(
 (P "🧠 Intuición" @("EXISTS solo pregunta '¿existe al menos una fila que cumpla?'. No le importa qué datos devuelve, solo si hay o no. Es como preguntar '¿hay alguien en casa?' sin importar quién.","Es la forma más eficiente de verificar existencia porque corta la ejecución en cuanto encuentra la primera coincidencia.","NOT EXISTS es la forma más segura de hacer anti-joins (no tiene problemas con NULL)."))
 (P "📝 Sintaxis" @("SELECT * FROM a WHERE EXISTS (SELECT 1 FROM b WHERE a.id = b.a_id);","SELECT * FROM a WHERE NOT EXISTS (SELECT 1 FROM b WHERE a.id = b.a_id);","El SELECT 1 es convención (podría ser SELECT *).","EXISTS solo mira si hay filas, no los valores."))
 (P "💻 Ejemplo" @("SELECT * FROM clientes c WHERE EXISTS (SELECT 1 FROM pedidos p WHERE p.cliente_id = c.id); — clientes que han pedido.","SELECT * FROM productos p WHERE NOT EXISTS (SELECT 1 FROM ventas v WHERE v.producto_id = p.id); — productos nunca vendidos."))
 (P "⚠️ Errores" @("Usar SELECT * en EXISTS: es ineficiente, usa SELECT 1.","Pensar que EXISTS devuelve datos: solo devuelve TRUE/FALSE.","No correlacionar: la subconsulta debe referenciar la consulta externa."))
 (P "🔍 Dato" @("EXISTS es más rápido que IN cuando la subconsulta puede devolver muchas filas.","PostgreSQL para NOT EXISTS es extremadamente eficiente.","SELECT 1 en EXISTS es solo una convención; SELECT * funciona igual."))
 (P "🎯 Clave" @("EXISTS = ¿hay filas? TRUE/FALSE.","NOT EXISTS = ¿no hay filas?","Más eficiente que IN/NOT IN.","Sin problemas con NULL.","Usa SELECT 1 en la subconsulta."))
)
step="<div class=""code-block"">-- Paso 1: EXISTS — clientes que han pedido<br>SELECT * FROM clientes c WHERE EXISTS (SELECT 1 FROM pedidos p WHERE p.cliente_id = c.id);<br><br>-- Paso 2: NOT EXISTS — clientes sin pedidos<br>SELECT * FROM clientes c WHERE NOT EXISTS (SELECT 1 FROM pedidos p WHERE p.cliente_id = c.id);<br><br>-- Paso 3: Comparación con IN<br>-- EXISTS corta al encontrar el primero, IN evalua toda la subconsulta</div>"
summary="EXISTS verifica existencia de filas en una subconsulta. Es más eficiente que IN para búsquedas de existencia. NOT EXISTS es la forma más segura de hacer anti-joins. Usa SELECT 1 para optimizar."
}

$c4_06 = @{color="#9c64ff";rgb="156,100,255";style="modern"
obj=@("Entender subconsultas correlacionadas","Diferenciarlas de subconsultas simples","Identificar la referencia externa","Usar alias de tabla para correlacionar")
panels=@(
 (P "🧠 Intuición" @("Una subconsulta correlacionada es como preguntar para CADA persona '¿cuál es el promedio de su departamento?'. La respuesta cambia según la fila que estés evaluando.","A diferencia de las subconsultas simples (se ejecutan UNA vez), la correlacionada se ejecuta UNA VEZ POR CADA FILA de la consulta externa.","El truco está en que la subconsulta referencia una columna de la consulta externa mediante alias."))
 (P "📝 Sintaxis" @("SELECT * FROM empleados e1 WHERE salario > (SELECT AVG(salario) FROM empleados e2 WHERE e2.depto_id = e1.depto_id);","La subconsulta usa e1.depto_id de la consulta externa.","Los alias son clave para distinguir interna de externa."))
 (P "💻 Ejemplo" @("SELECT nombre FROM productos p WHERE precio > (SELECT AVG(precio) FROM productos WHERE categoria_id = p.categoria_id); — productos por encima del promedio de su categoría."))
 (P "⚠️ Errores" @("Olvidar el alias de la tabla externa.","No incluir la condición de correlación (WHERE e2.x = e1.x).","Usar correlacionada cuando una simple bastaría (es más lenta)."))
 (P "🔍 Dato" @("Las correlacionadas son más lentas porque se ejecutan N veces.","PostgreSQL puede transformar algunas correlacionadas en JOINs.","Son necesarias para problemas como 'el mejor de cada grupo'."))
 (P "🎯 Clave" @("Referencia a la consulta externa.","Se ejecuta por cada fila externa.","Útil para comparaciones dentro de grupos.","Puede ser lenta en tablas grandes."))
)
step="<div class=""code-block"">-- Paso 1: Subconsulta correlacionada<br>SELECT nombre, salario FROM empleados e1 WHERE salario > (SELECT AVG(salario) FROM empleados e2 WHERE e2.departamento_id = e1.departamento_id);<br><br>-- Paso 2: Productos sobre el promedio de su categoría<br>SELECT nombre, precio FROM productos p WHERE precio > (SELECT AVG(precio) FROM productos WHERE categoria_id = p.categoria_id);<br><br>-- La clave: e2.departamento_id = e1.departamento_id conecta interna con externa</div>"
summary="Las subconsultas correlacionadas referencian la consulta externa y se ejecutan por cada fila. Son ideales para comparaciones dentro de grupos pero pueden ser lentas. Los alias son obligatorios."
}

$c4_07 = @{color="#9c64ff";rgb="156,100,255";style="modern"
obj=@("Usar subconsultas en FROM (tablas derivadas)","Crear tablas temporales con subconsultas","Nombrar tablas derivadas con alias","Combinar tablas derivadas con JOINs")
panels=@(
 (P "🧠 Intuición" @("Las tablas derivadas son como consultas 'desechables': creas una tabla temporal con una subconsulta y la usas como si fuera una tabla real.","Son útiles para crear 'vistas' temporales que simplifican consultas complejas.","La subconsulta en FROM se ejecuta PRIMERO, y luego la consulta principal la usa como tabla."))
 (P "📝 Sintaxis" @("SELECT alias.col FROM (SELECT * FROM tabla WHERE condicion) AS alias;","SELECT a.nombre, b.total FROM (SELECT * FROM clientes) a JOIN (SELECT * FROM pedidos) b ON a.id = b.cliente_id;","El alias es OBLIGATORIO para tablas derivadas."))
 (P "💻 Ejemplo" @("SELECT * FROM (SELECT nombre, precio, precio * 1.21 AS con_iva FROM productos) AS p WHERE p.con_iva > 100;","SELECT depto, promedio FROM (SELECT depto_id, AVG(salario) AS promedio FROM empleados GROUP BY depto_id) AS promedios;"))
 (P "⚠️ Errores" @("Olvidar el alias de la tabla derivada: error de sintaxis.","No todas las columnas de la subconsulta están disponibles fuera.","Las tablas derivadas no tienen índices."))
 (P "🔍 Dato" @("Las tablas derivadas son la base de las CTEs (WITH).","PostgreSQL materializa la tabla derivada en memoria.","Se pueden anidar varias niveles."))
 (P "🎯 Clave" @("Subconsulta en FROM = tabla derivada.","El alias es obligatorio.","Se ejecuta primero.","Útil para simplificar consultas."))
)
step="<div class=""code-block"">-- Paso 1: Tabla derivada básica<br>SELECT * FROM (SELECT nombre, precio, precio * 1.21 AS con_iva FROM productos) AS p WHERE p.con_iva > 100;<br><br>-- Paso 2: Promedios por departamento<br>SELECT d.nombre, pd.promedio FROM departamentos d JOIN (SELECT depto_id, AVG(salario) AS promedio FROM empleados GROUP BY depto_id) AS pd ON d.id = pd.depto_id;<br><br>-- La subconsulta en FROM se ejecuta primero, luego el JOIN</div>"
summary="Las tablas derivadas (subconsultas en FROM) crean tablas temporales para simplificar consultas. El alias es obligatorio. Son el paso previo a las CTEs y muy útiles para consultas complejas."
}

$c4_08 = @{color="#9c64ff";rgb="156,100,255";style="modern"
obj=@("Usar UNION para combinar resultados","Usar UNION ALL para conservar duplicados","Entender la diferencia entre UNION y UNION ALL","Combinar resultados de múltiples consultas")
panels=@(
 (P "🧠 Intuición" @("UNION es como apilar dos listas una encima de otra. Si tienes empleados de Madrid y empleados de Barcelona, UNION te da todos.","UNION elimina DUPLICADOS, UNION ALL los conserva. UNION ALL es más rápido porque no hace el trabajo extra de eliminar repetidos.","Las consultas deben tener el MISMO número de columnas y tipos compatibles."))
 (P "📝 Sintaxis" @("SELECT * FROM tabla1 UNION SELECT * FROM tabla2;","SELECT * FROM tabla1 UNION ALL SELECT * FROM tabla2;","Los nombres de columna vienen de la PRIMERA consulta.","ORDER BY al final de todo."))
 (P "💻 Ejemplo" @("SELECT nombre, email FROM clientes_madrid UNION SELECT nombre, email FROM clientes_barcelona;","SELECT nombre FROM empleados_actuales UNION ALL SELECT nombre FROM empleados_historicos;"))
 (P "⚠️ Errores" @("Número diferente de columnas: error.","Tipos incompatibles: error.","ORDER BY en cada consulta (solo al final).","UNION puede ser lento en tablas grandes por la eliminación de duplicados."))
 (P "🔍 Dato" @("UNION hace un DISTINCT implícito (ordena y elimina duplicados).","UNION ALL es más rápido y recomendado si sabes que no hay duplicados.","PostgreSQL optimiza UNION con hash o sort según el caso."))
 (P "🎯 Clave" @("UNION = combina y elimina duplicados.","UNION ALL = combina sin eliminar.","Mismo número de columnas.","Tipos compatibles.","ORDER BY al final."))
)
step="<div class=""code-block"">-- Paso 1: UNION elimina duplicados<br>SELECT ciudad FROM clientes_madrid UNION SELECT ciudad FROM clientes_barcelona;<br><br>-- Paso 2: UNION ALL conserva duplicados (más rápido)<br>SELECT nombre FROM empleados_2023 UNION ALL SELECT nombre FROM empleados_2024;<br><br>-- Paso 3: Con ORDER BY al final<br>SELECT nombre, total FROM enero UNION ALL SELECT nombre, total FROM febrero ORDER BY total DESC;</div>"
summary="UNION combina resultados de múltiples consultas eliminando duplicados. UNION ALL los conserva, siendo más rápido. Las consultas deben tener el mismo número de columnas y tipos compatibles."
}

$c4_09 = @{color="#9c64ff";rgb="156,100,255";style="modern"
obj=@("Usar INTERSECT para filas comunes","Entender cómo INTERSECT elimina duplicados","Diferenciar INTERSECT de INNER JOIN","Aplicar INTERSECT en consultas de conjuntos")
panels=@(
 (P "🧠 Intuición" @("INTERSECT es como ver qué elementos están en DOS listas a la vez. Solo devuelve las filas que aparecen en AMBAS consultas.","Es la operación de intersección de conjuntos (como en matemáticas: A ∩ B).","INTERSECT también elimina duplicados en el resultado final."))
 (P "📝 Sintaxis" @("SELECT * FROM tabla1 INTERSECT SELECT * FROM tabla2;","SELECT col FROM t1 INTERSECT SELECT col FROM t2;","Mismas reglas que UNION: mismo número y tipo de columnas.","ORDER BY al final."))
 (P "💻 Ejemplo" @("SELECT producto_id FROM pedidos_2023 INTERSECT SELECT producto_id FROM pedidos_2024; — productos vendidos ambos años.","SELECT email FROM newsletter INTERSECT SELECT email FROM clientes; — suscriptores que también son clientes."))
 (P "⚠️ Errores" @("Asumir que INTERSECT respeta orden de filas (no lo hace).","Usar INTERSECT cuando INNER JOIN es más apropiado (INTERSECT es para conjuntos completos)."))
 (P "🔍 Dato" @("No todos los SGBD soportan INTERSECT (MySQL no).","PostgreSQL soporta INTERSECT y también INTERSECT ALL (conserva duplicados).","INTERSECT es parte del estándar SQL."))
 (P "🎯 Clave" @("INTERSECT = filas en AMBAS consultas.","Elimina duplicados.","Mismo número de columnas.","Útil para encontrar elementos comunes."))
)
step="<div class=""code-block"">-- Paso 1: Productos vendidos en ambos años<br>SELECT producto_id FROM ventas_2023 INTERSECT SELECT producto_id FROM ventas_2024;<br><br>-- Paso 2: Clientes que también son empleados<br>SELECT email FROM clientes INTERSECT SELECT email FROM empleados;<br><br>-- Paso 3: Equivalente con INNER JOIN<br>SELECT DISTINCT v.producto_id FROM ventas_2023 v JOIN ventas_2024 v2 ON v.producto_id = v2.producto_id;</div>"
summary="INTERSECT devuelve las filas comunes entre dos consultas. Es la intersección de conjuntos en SQL. Elimina duplicados y requiere el mismo número de columnas. Útil para encontrar elementos compartidos."
}

$c4_10 = @{color="#9c64ff";rgb="156,100,255";style="modern"
obj=@("Usar EXCEPT (MINUS) para restar conjuntos","Encontrar filas en una consulta pero no en otra","Diferenciar EXCEPT de NOT EXISTS","Aplicar EXCEPT en análisis de diferencias")
panels=@(
 (P "🧠 Intuición" @("EXCEPT (llamado MINUS en Oracle) es como decir 'dame lo que está en la lista A pero NO en la B'. Es la resta de conjuntos: A - B.","Útil para encontrar diferencias entre dos conjuntos de datos. Por ejemplo, 'clientes que pidieron en 2023 pero no en 2024'.","EXCEPT elimina duplicados del resultado."))
 (P "📝 Sintaxis" @("SELECT * FROM tabla1 EXCEPT SELECT * FROM tabla2;","SELECT col FROM t1 EXCEPT SELECT col FROM t2;","MINUS es el nombre en Oracle (hace lo mismo).","ORDER BY al final."))
 (P "💻 Ejemplo" @("SELECT producto_id FROM catalogo_2023 EXCEPT SELECT producto_id FROM catalogo_2024; — productos descontinuados.","SELECT email FROM clientes EXCEPT SELECT email FROM empleados; — clientes que no son empleados."))
 (P "⚠️ Errores" @("Confundir EXCEPT con EXCEPTION (manejo de errores).","EXCEPT no es lo mismo que NOT EXISTS aunque a veces logren lo mismo.","Oracle usa MINUS, no EXCEPT."))
 (P "🔍 Dato" @("PostgreSQL soporta EXCEPT. MySQL no.","EXCEPT ALL conserva duplicados (PostgreSQL).","EXCEPT es estándar SQL desde SQL:2003."))
 (P "🎯 Clave" @("EXCEPT = filas en A pero no en B.","Elimina duplicados.","Oracle usa MINUS.","Útil para encontrar diferencias."))
)
step="<div class=""code-block"">-- Paso 1: Productos descontinuados (en 2023 pero no en 2024)<br>SELECT producto_id FROM catalogo_2023 EXCEPT SELECT producto_id FROM catalogo_2024;<br><br>-- Paso 2: Clientes nuevos (en 2024 pero no en 2023)<br>SELECT cliente_id FROM pedidos_2024 EXCEPT SELECT cliente_id FROM pedidos_2023;<br><br>-- Paso 3: Equivalente con NOT EXISTS<br>SELECT c.* FROM clientes c WHERE NOT EXISTS (SELECT 1 FROM empleados e WHERE e.email = c.email);</div>"
summary="EXCEPT resta conjuntos: devuelve filas de la primera consulta que NO están en la segunda. Es la operación A - B de conjuntos. Oracle lo llama MINUS. Útil para encontrar diferencias entre conjuntos."
}

$c4_11 = @{color="#9c64ff";rgb="156,100,255";style="modern"
obj=@("Comparar subconsultas, JOINs y CTEs","Elegir la técnica adecuada según el caso","Entender las ventajas de cada enfoque","Optimizar consultas con la herramienta correcta")
panels=@(
 (P "🧠 Intuición" @("Tres herramientas para un mismo problema: subconsultas, JOINs y CTEs. Cada una tiene sus fortalezas. Los JOINs son más eficientes para relaciones directas. Las subconsultas son intuitivas para 'un valor de referencia'. Las CTEs (WITH) son ideales para legibilidad y pasos intermedios."))
 (P "📝 Cuándo usar cada una" @("JOIN: cuando necesitas columnas de varias tablas relacionadas.","Subconsulta: para comparar con un valor agregado o filtrar por existencia.","CTE: para consultas con pasos intermedios o recursivas."))
 (P "💻 Ejemplo" @("JOIN: SELECT c.nombre, p.total FROM clientes c JOIN pedidos p ON c.id = p.cliente_id;","Subconsulta: SELECT * FROM productos WHERE precio > (SELECT AVG(precio) FROM productos);","CTE: WITH ventas_altas AS (SELECT * FROM pedidos WHERE total > 1000) SELECT * FROM ventas_altas;"))
 (P "⚠️ Errores" @("Usar subconsulta cuando un JOIN sería más eficiente.","Usar JOIN cuando una subconsulta sería más legible.","No usar CTE cuando hay múltiples pasos."))
 (P "🔍 Dato" @("Las CTEs se pueden referenciar múltiples veces, las subconsultas no.","PostgreSQL optimiza las CTEs de forma diferente (materializa vs inline).","Los JOINs suelen ser más rápidos que subconsultas correlacionadas."))
 (P "🎯 Clave" @("JOIN: eficiente, combina columnas.","Subconsulta: simple, valor de referencia.","CTE: legible, pasos intermedios, reutilizable."))
)
step="<div class=""code-block"">-- JOIN: combinar datos relacionados<br>SELECT c.nombre, p.total FROM clientes c JOIN pedidos p ON c.id = p.cliente_id;<br><br>-- Subconsulta: comparar con agregado<br>SELECT * FROM productos WHERE precio > (SELECT AVG(precio) FROM productos);<br><br>-- CTE: pasos intermedios<br>WITH clientes_vip AS (SELECT * FROM clientes WHERE total_gastado > 5000)<br>SELECT * FROM clientes_vip WHERE fecha_registro > '2024-01-01';</div>"
summary="JOINs, subconsultas y CTEs son herramientas complementarias. JOINs para relaciones, subconsultas para comparaciones, CTEs para legibilidad. Elige según el caso: eficiencia, claridad y reutilización."
}

$c4_12 = @{color="#9c64ff";rgb="156,100,255";style="modern"
obj=@("Aplicar todos los tipos de subconsultas","Crear reportes complejos","Combinar subconsultas con JOINs","Resolver problemas reales de análisis")
panels=@(
 (P "🧠 Intuición" @("Este proyecto integrador te reta a construir reportes usando todas las técnicas del curso: subconsultas escalares, correlacionadas, IN, EXISTS, UNION, INTERSECT y EXCEPT.","Los reportes son el producto final del análisis de datos. Con estas herramientas puedes responder preguntas de negocio complejas."))
 (P "📝 Proyecto" @("Reportes de ventas con subconsultas escalares.","Análisis de clientes con EXISTS.","Comparativas anuales con UNION e INTERSECT.","Detección de cambios con EXCEPT."))
 (P "💻 Consultas" @("Productos por encima del promedio de su categoría.","Clientes que compraron este año pero no el anterior.","Categorías con más ventas que el promedio general."))
 (P "⚠️ Desafíos" @("Subconsultas correlacionadas lentas en tablas grandes.","NOT IN con NULL.","Elegir entre JOIN, subconsulta o CTE."))
 (P "🔍 Dato" @("Los reportes avanzados combinan varias técnicas en una sola consulta.","Saber cuándo usar cada técnica es más valioso que saber la sintaxis."))
 (P "🎯 Consejo" @("Diseña la consulta en papel antes de escribirla.","Empieza con la subconsulta más interna.","Prueba cada parte por separado."))
)
step="<div class=""code-block"">-- Reporte: Productos sobre promedio de su categoría<br>SELECT p.nombre, p.precio, p.categoria_id, (SELECT AVG(precio) FROM productos WHERE categoria_id = p.categoria_id) AS prom_categoria FROM productos p WHERE p.precio > (SELECT AVG(precio) FROM productos WHERE categoria_id = p.categoria_id);<br><br>-- Clientes que compraron en 2024 pero no en 2023<br>SELECT cliente_id FROM pedidos WHERE EXTRACT(YEAR FROM fecha) = 2024 EXCEPT SELECT cliente_id FROM pedidos WHERE EXTRACT(YEAR FROM fecha) = 2023;</div>"
summary="Has completado el curso de subconsultas. Dominas subconsultas escalares, correlacionadas, IN/NOT IN, ANY/ALL, EXISTS, UNION, INTERSECT, EXCEPT y sabes cuándo usar JOIN vs subconsulta vs CTE. ¡Eres un experto en consultas avanzadas!"
}

# ============ CURSO 5 - DDL y DML (#ff5050 / 255,80,80) ============
$c5_01 = @{color="#ff5050";rgb="255,80,80";style="modern"
obj=@("Crear bases de datos con CREATE DATABASE","Crear tablas con CREATE TABLE","Definir columnas con tipos de datos","Entender la sintaxis DDL básica")
panels=@(
 (P "🧠 Intuición" @("CREATE DATABASE es como comprar un terreno vacío. CREATE TABLE es como construir una casa en ese terreno, con habitaciones (columnas) para cada tipo de cosa que guardarás.","Sin CREATE no hay nada — es el primer paso de cualquier proyecto de base de datos.","DDL (Data Definition Language) incluye CREATE, ALTER, DROP y TRUNCATE."))
 (P "📝 Sintaxis CREATE" @("CREATE DATABASE nombre;","CREATE TABLE nombre (columna tipo, columna tipo, ...);","Tipos comunes: INTEGER, VARCHAR(n), DECIMAL(p,s), DATE, BOOLEAN.","Las columnas se separan con comas (la última no lleva coma)."))
 (P "💻 Ejemplo" @("CREATE DATABASE tienda;","CREATE TABLE productos (id INTEGER, nombre VARCHAR(100), precio DECIMAL(10,2));","CREATE SCHEMA ventas; CREATE TABLE ventas.pedidos (...);"))
 (P "⚠️ Errores" @("Olvidar el punto y coma al final.","Poner coma después de la última columna.","Usar nombres reservados como ORDER o TABLE como nombre de tabla."))
 (P "🔍 Dato" @("PostgreSQL tiene CREATE SCHEMA además de CREATE DATABASE.","Los nombres en SQL se convierten a minúsculas a menos que uses comillas dobles.","IF NOT EXISTS evita errores si ya existe."))
 (P "🎯 Clave" @("CREATE DATABASE → crear BD.","CREATE TABLE → crear tabla.","Especifica tipos de datos.","Las columnas se separan con comas."))
)
step="<div class=""code-block"">-- Paso 1: Crear la base de datos<br>CREATE DATABASE mi_tienda;<br><br>-- Paso 2: Crear tabla de productos<br>CREATE TABLE productos (<br>  id INTEGER,<br>  nombre VARCHAR(100),<br>  precio DECIMAL(10,2)<br>);<br><br>-- Paso 3: Verificar la tabla creada<br>\\d productos -- en PostgreSQL</div>"
summary="CREATE DATABASE crea una base de datos, CREATE TABLE define sus tablas. DDL es el lenguaje de definición de datos. Especifica nombres de tablas, columnas y tipos de datos. ¡El inicio de todo proyecto!"
}

$c5_02 = @{color="#ff5050";rgb="255,80,80";style="modern"
obj=@("Añadir columnas con ALTER TABLE ADD","Modificar columnas con ALTER TABLE ALTER","Eliminar columnas con ALTER TABLE DROP","Entender las limitaciones de ALTER")
panels=@(
 (P "🧠 Intuición" @("ALTER TABLE es como reformar tu casa: puedes añadir una habitación (columna), cambiar el tamaño (tipo de dato) o derribar una pared (eliminar columna).","A diferencia de CREATE que se hace una vez, ALTER se usa cuando la base de datos ya está en funcionamiento.","Es una operación delicada: modificar tablas con datos puede ser lento o imposible."))
 (P "📝 Sintaxis ALTER" @("ALTER TABLE tabla ADD COLUMN columna tipo;","ALTER TABLE tabla ALTER COLUMN col TYPE nuevo_tipo;","ALTER TABLE tabla DROP COLUMN columna;","ALTER TABLE tabla RENAME COLUMN viejo TO nuevo;"))
 (P "💻 Ejemplo" @("ALTER TABLE productos ADD COLUMN descripcion TEXT;","ALTER TABLE productos ALTER COLUMN precio TYPE NUMERIC(12,2);","ALTER TABLE productos DROP COLUMN descripcion;","ALTER TABLE productos RENAME COLUMN nombre TO titulo;"))
 (P "⚠️ Errores" @("Eliminar una columna que es referenciada por una FK.","Cambiar tipo a uno incompatible con los datos existentes.","ALTER TABLE en tablas grandes puede ser muy lento y bloquear la tabla."))
 (P "🔍 Dato" @("PostgreSQL soporta ALTER TABLE ... SET DEFAULT para añadir valor por defecto.","Algunos cambios de tipo requieren USING para convertir los datos existentes.","En PostgreSQL, ADD COLUMN es instantáneo (solo metadata)."))
 (P "🎯 Clave" @("ADD COLUMN → añade columna.","ALTER COLUMN → cambia tipo.","DROP COLUMN → elimina columna.","RENAME COLUMN → renombra."))
)
step="<div class=""code-block"">-- Paso 1: Añadir columna<br>ALTER TABLE productos ADD COLUMN descripcion TEXT;<br><br>-- Paso 2: Modificar tipo<br>ALTER TABLE productos ALTER COLUMN precio TYPE NUMERIC(12,2);<br><br>-- Paso 3: Eliminar columna<br>ALTER TABLE productos DROP COLUMN descripcion;<br><br>-- Paso 4: Renombrar<br>ALTER TABLE productos RENAME COLUMN nombre TO titulo;</div>"
summary="ALTER TABLE modifica la estructura de tablas existentes. ADD añade columnas, ALTER COLUMN cambia tipos, DROP elimina columnas. Es útil para evolucionar el esquema sin perder datos."
}

$c5_03 = @{color="#ff5050";rgb="255,80,80";style="modern"
obj=@("Eliminar tablas con DROP TABLE","Vaciar tablas con TRUNCATE","Diferenciar DROP de TRUNCATE","Entender el impacto de cada operación")
panels=@(
 (P "🧠 Intuición" @("DROP TABLE es como derribar toda la casa: desaparece la estructura y los datos. No hay vuelta atrás (sin backup).","TRUNCATE es como vaciar la casa de muebles: la estructura sigue en pie pero los datos se pierden. Es más rápido que DELETE.","DELETE es como sacar los muebles uno por uno: puedes usar WHERE para seleccionar cuáles."))
 (P "📝 Diferencias" @("DROP: elimina la tabla completa (estructura + datos). No se puede deshacer.","TRUNCATE: vacía la tabla (solo datos). Resetea los contadores SERIAL. Más rápido que DELETE.","DELETE: elimina filas una por una. Puede tener WHERE. Más lento pero más controlado."))
 (P "💻 Ejemplo" @("DROP TABLE productos; — elimina toda la tabla.","TRUNCATE TABLE productos; — vacía la tabla pero la mantiene.","DELETE FROM productos WHERE precio = 0; — elimina solo ciertas filas."))
 (P "⚠️ Errores" @("DROP sin verificar: no hay confirmación.","TRUNCATE no puede usarse si hay FK referenciando la tabla.","DELETE sin WHERE borra TODAS las filas (pero más lento que TRUNCATE)."))
 (P "🔍 Dato" @("TRUNCATE es DDL, no DML (no se puede usar en transacciones en algunos SGBD).","PostgreSQL permite TRUNCATE en cascada (CASCADE).","DROP TABLE ... CASCADE elimina también objetos dependientes."))
 (P "🎯 Clave" @("DROP → elimina tabla completa.","TRUNCATE → vacía datos, mantiene estructura.","DELETE → elimina filas selectivamente.","TRUNCATE es más rápido que DELETE."))
)
step="<div class=""code-block"">-- Comparativa:<br><br>-- Opción 1: DROP (elimina todo)<br>DROP TABLE productos;<br>-- La tabla ya no existe<br><br>-- Opción 2: TRUNCATE (vacía datos)<br>TRUNCATE TABLE productos;<br>-- La tabla existe pero sin datos<br><br>-- Opción 3: DELETE (selectivo)<br>DELETE FROM productos WHERE precio = 0;<br>-- Solo elimina filas que cumplen la condición</div>"
summary="DROP elimina la tabla completa, TRUNCATE la vacía (más rápido que DELETE), y DELETE elimina filas selectivamente. DROP y TRUNCATE son DDL, DELETE es DML. Elige según necesites: eliminar todo, vaciar o seleccionar."
}

$c5_04 = @{color="#ff5050";rgb="255,80,80";style="modern"
obj=@("Definir PRIMARY KEY en tablas","Definir FOREIGN KEY para relaciones","Entender la integridad referencial","Aplicar PK y FK en CREATE TABLE")
panels=@(
 (P "🧠 Intuición" @("PRIMARY KEY es la cédula de identidad de cada fila: única y obligatoria. FOREIGN KEY es un enlace que dice 'este valor debe existir en esa otra tabla'.","Las PK y FK mantienen la integridad referencial: no puedes tener un pedido de un cliente que no existe.","Son la base del diseño relacional."))
 (P "📝 Sintaxis" @("CREATE TABLE t (id INTEGER PRIMARY KEY, ...);","CREATE TABLE t (id INTEGER, ..., PRIMARY KEY (id)); — alternativa.","CREATE TABLE hijo (padre_id INTEGER REFERENCES padre(id)); — FK inline.","CREATE TABLE hijo (..., FOREIGN KEY (col) REFERENCES padre(col)); — FK explícita."))
 (P "💻 Ejemplo" @("CREATE TABLE clientes (id SERIAL PRIMARY KEY, nombre TEXT);","CREATE TABLE pedidos (id SERIAL PRIMARY KEY, cliente_id INTEGER REFERENCES clientes(id), total DECIMAL);"))
 (P "⚠️ Errores" @("FK apuntando a columna de tipo diferente: error.","Insertar en tabla con FK un valor que no existe en la PK: error.","Dos PK en una tabla: solo puede haber una."))
 (P "🔍 Dato" @("PostgreSQL crea automáticamente un índice para la PK.","Las FK pueden ser compuestas (múltiples columnas).","Las FK pueden tener acciones: CASCADE, SET NULL, RESTRICT."))
 (P "🎯 Clave" @("PK = única, no NULL, identifica cada fila.","FK = referencia a PK de otra tabla.","Mantienen integridad referencial.","Solo una PK por tabla, múltiples FK."))
)
step="<div class=""code-block"">-- Crear tabla con PK<br>CREATE TABLE clientes (<br>  id SERIAL PRIMARY KEY,<br>  nombre VARCHAR(100) NOT NULL,<br>  email VARCHAR(200) UNIQUE<br>);<br><br>-- Crear tabla con FK<br>CREATE TABLE pedidos (<br>  id SERIAL PRIMARY KEY,<br>  cliente_id INTEGER NOT NULL REFERENCES clientes(id),<br>  total DECIMAL(10,2),<br>  fecha DATE DEFAULT CURRENT_DATE<br>);</div>"
summary="PRIMARY KEY identifica cada fila de forma única. FOREIGN KEY conecta tablas manteniendo la integridad referencial. Son fundamentales para el diseño de bases de datos relacionales."
}

$c5_05 = @{color="#ff5050";rgb="255,80,80";style="modern"
obj=@("Aplicar UNIQUE para valores únicos","Aplicar NOT NULL para valores obligatorios","Combinar constraints en columnas","Diferenciar UNIQUE de PRIMARY KEY")
panels=@(
 (P "🧠 Intuición" @("UNIQUE es como un carnet de socio: no puede haber dos personas con el mismo número. NOT NULL es como un campo obligatorio en un formulario: no puedes dejarlo vacío.","UNIQUE permite un solo NULL (en algunos SGBD). NOT NULL no permite NULL en absoluto.","Puedes tener múltiples UNIQUE en una tabla, pero solo una PRIMARY KEY."))
 (P "📝 Sintaxis" @("CREATE TABLE t (email VARCHAR(200) UNIQUE, nombre TEXT NOT NULL);","UNIQUE puede ser de tabla: UNIQUE (col1, col2) — combinación única.","NOT NULL no permite valores nulos en la columna.","Los constraints se definen al crear la tabla o con ALTER."))
 (P "💻 Ejemplo" @("CREATE TABLE usuarios (id SERIAL PRIMARY KEY, email VARCHAR(200) UNIQUE NOT NULL, username VARCHAR(50) UNIQUE NOT NULL);","ALTER TABLE productos ADD CONSTRAINT uq_nombre UNIQUE (nombre);"))
 (P "⚠️ Errores" @("UNIQUE permite NULL (un NULL no es igual a otro NULL).","NOT NULL no acepta cadenas vacías ('') — solo NULL es rechazado.","Crear UNIQUE en columna que ya tiene duplicados: error."))
 (P "🔍 Dato" @("PostgreSQL crea un índice automático para UNIQUE.","UNIQUE acepta múltiples NULL en PostgreSQL.","UNIQUE compuesto: la combinación debe ser única."))
 (P "🎯 Clave" @("UNIQUE = valores no repetidos.","NOT NULL = valores obligatorios.","UNIQUE permite NULL (depende del SGBD).","Se pueden combinar ambos en una columna."))
)
step="<div class=""code-block"">-- Paso 1: UNIQUE y NOT NULL en columna<br>CREATE TABLE usuarios (<br>  id SERIAL PRIMARY KEY,<br>  email VARCHAR(200) UNIQUE NOT NULL,<br>  username VARCHAR(50) UNIQUE NOT NULL,<br>  nombre TEXT NOT NULL<br>);<br><br>-- Paso 2: UNIQUE compuesto (combinación única)<br>CREATE TABLE inscripciones (<br>  estudiante_id INTEGER,<br>  curso_id INTEGER,<br>  UNIQUE (estudiante_id, curso_id)<br>);</div>"
summary="UNIQUE asegura que no haya valores duplicados en una columna o combinación de columnas. NOT NULL obliga a tener un valor. Son constraints esenciales para la integridad de datos."
}

$c5_06 = @{color="#ff5050";rgb="255,80,80";style="modern"
obj=@("Usar CHECK para validar datos","Usar DEFAULT para valores por defecto","Crear condiciones de validación","Aplicar constraints CHECK en columnas")
panels=@(
 (P "🧠 Intuición" @("CHECK es como un portero que verifica que los datos de entrada cumplan las reglas: 'precio debe ser > 0', 'edad debe ser >= 18'.","DEFAULT es como tener una respuesta automática: si no proves datos, se usa este valor. Como un formulario que pone 'No especificado' si dejas el campo vacío.","Ambos se definen al crear la tabla y se aplican automáticamente."))
 (P "📝 Sintaxis" @("CREATE TABLE t (precio DECIMAL CHECK (precio > 0));","CREATE TABLE t (activo BOOLEAN DEFAULT true);","CHECK (edad >= 18); — condición booleana.","DEFAULT valor; — valor por defecto al insertar."))
 (P "💻 Ejemplo" @("CREATE TABLE empleados (salario DECIMAL CHECK (salario > 0), fecha_ingreso DATE DEFAULT CURRENT_DATE);","CREATE TABLE productos (precio DECIMAL CHECK (precio >= 0), activo BOOLEAN DEFAULT true);"))
 (P "⚠️ Errores" @("CHECK solo valida datos nuevos, no los existentes (a menos que se especifique).","CHECK con función que depende del tiempo: puede dar resultados inconsistentes.","DEFAULT no valida nada, solo provee un valor si no se especifica."))
 (P "🔍 Dato" @("PostgreSQL permite CHECK que referencie otras columnas de la misma fila.","CHECK (precio > 0 AND precio < 10000) — condiciones compuestas.","DEFAULT puede usar expresiones como NOW() o NEXT VALUE FOR."))
 (P "🎯 Clave" @("CHECK valida datos con una condición.","DEFAULT provee valor si no se especifica.","CHECK se aplica al insertar o actualizar.","DEFAULT no reemplaza valores explícitos."))
)
step="<div class=""code-block"">-- Paso 1: CHECK y DEFAULT en acción<br>CREATE TABLE productos (<br>  id SERIAL PRIMARY KEY,<br>  nombre TEXT NOT NULL,<br>  precio DECIMAL CHECK (precio >= 0),<br>  stock INTEGER DEFAULT 0,<br>  activo BOOLEAN DEFAULT true,<br>  creado_en DATE DEFAULT CURRENT_DATE<br>);<br><br>-- CHECK evita precios negativos<br>-- DEFAULT asigna 0 si no se especifica stock</div>"
summary="CHECK valida que los datos cumplan condiciones (precio > 0, edad >= 18). DEFAULT asigna valores automáticos si no se especifican. Juntos mantienen la calidad de los datos en la base de datos."
}

$c5_07 = @{color="#ff5050";rgb="255,80,80";style="modern"
obj=@("Insertar filas con INSERT INTO","Insertar múltiples filas","Usar RETURNING en PostgreSQL","Insertar datos parciales")
panels=@(
 (P "🧠 Intuición" @("INSERT INTO es como añadir una ficha a un archivador. Cada INSERT es una nueva fila que guardas en la tabla correcta.","Puedes añadir una ficha a la vez o varias en lote. Con RETURNING, PostgreSQL te devuelve los datos insertados como recibo.","INSERT es la operación DML más básica: sin datos, las tablas están vacías."))
 (P "📝 Sintaxis" @("INSERT INTO tabla (col1, col2) VALUES (val1, val2);","INSERT INTO tabla VALUES (val1, val2); — todas las columnas en orden.","INSERT INTO tabla (col1, col2) VALUES (v1, v2), (v3, v4); — múltiples filas.","INSERT INTO ... RETURNING *; — PostgreSQL, devuelve los datos insertados."))
 (P "💻 Ejemplo" @("INSERT INTO clientes (nombre, email) VALUES ('Ana', 'ana@email.com');","INSERT INTO productos (nombre, precio) VALUES ('Laptop', 999.99), ('Mouse', 25.50);","INSERT INTO pedidos (cliente_id, total) VALUES (1, 150.00) RETURNING id;"))
 (P "⚠️ Errores" @("INSERT sin especificar columnas NOT NULL: error.","Valor duplicado en columna UNIQUE: error.","FK que apunta a PK inexistente: error."))
 (P "🔍 Dato" @("INSERT ... RETURNING es específico de PostgreSQL (muy útil).","INSERT múltiple es más rápido que varios INSERT individuales.","Puedes INSERT desde SELECT: INSERT INTO copia SELECT * FROM original;"))
 (P "🎯 Clave" @("INSERT INTO tabla (cols) VALUES (vals);","Puedes insertar múltiples filas.","RETURNING devuelve lo insertado.","Debes respetar NOT NULL y UNIQUE."))
)
step="<div class=""code-block"">-- Paso 1: INSERT básico<br>INSERT INTO clientes (nombre, email) VALUES ('Ana García', 'ana@email.com');<br><br>-- Paso 2: INSERT múltiple<br>INSERT INTO productos (nombre, precio) VALUES ('Teclado', 45.00), ('Monitor', 299.99), ('Mouse', 25.50);<br><br>-- Paso 3: INSERT con RETURNING<br>INSERT INTO pedidos (cliente_id, total) VALUES (1, 150.00) RETURNING id, fecha;</div>"
summary="INSERT INTO añade filas a una tabla. Puedes insertar una o múltiples filas. Con RETURNING, PostgreSQL devuelve los datos insertados. Respeta los constraints: NOT NULL, UNIQUE y FK."
}

$c5_08 = @{color="#ff5050";rgb="255,80,80";style="modern"
obj=@("Actualizar filas con UPDATE","Usar SET para cambiar valores","Aplicar WHERE en UPDATE (crítico)","Actualizar múltiples columnas")
panels=@(
 (P "🧠 Intuición" @("UPDATE es como usar corrector líquido en una ficha: cambias información existente sin crear una nueva fila.","SET indica qué columna(s) cambiar y con qué valor. WHERE determina qué filas se actualizan.","El error más grave: UPDATE sin WHERE actualiza TODAS las filas. Siempre verifica con SELECT antes."))
 (P "📝 Sintaxis" @("UPDATE tabla SET columna = valor WHERE condicion;","UPDATE tabla SET col1 = val1, col2 = val2 WHERE condicion;","UPDATE tabla SET col = col + 1 WHERE condicion; — operaciones aritméticas.","Sin WHERE → todas las filas."))
 (P "💻 Ejemplo" @("UPDATE productos SET precio = 49.99 WHERE id = 5;","UPDATE empleados SET salario = salario * 1.1 WHERE depto_id = 3; — aumentar 10%.","UPDATE productos SET stock = stock - 1 WHERE id = 10 AND stock > 0;"))
 (P "⚠️ Errores" @("OLVIDAR WHERE — actualiza toda la tabla. Error más común y peligroso.","Violar UNIQUE o CHECK al actualizar.","Actualizar PK referenciada por FK."))
 (P "🔍 Dato" @("PostgreSQL permite UPDATE ... FROM ... WHERE para updates con JOIN.","Siempre haz SELECT con el mismo WHERE antes del UPDATE para verificar.","UPDATE genera bloqueos en las filas afectadas."))
 (P "🎯 Clave" @("UPDATE → modifica datos existentes.","SET → columna = nuevo valor.","WHERE → CRÍTICO: sin él se actualizan TODAS las filas.","Verifica con SELECT antes de UPDATE."))
)
step="<div class=""code-block"">-- Paso 1: SIEMPRE verifica primero<br>SELECT * FROM productos WHERE id = 5;<br><br>-- Paso 2: UPDATE seguro<br>UPDATE productos SET precio = 49.99 WHERE id = 5;<br><br>-- Paso 3: Múltiples columnas<br>UPDATE productos SET precio = 55.00, stock = stock + 10 WHERE id = 5;<br><br>-- Paso 4: ¡Peligro! Sin WHERE<br>-- UPDATE productos SET precio = 0;  -- ¡TODOS los productos a precio 0!</div>"
summary="UPDATE modifica filas existentes. SET especifica los nuevos valores. WHERE determina qué filas cambiar. NUNCA olvides el WHERE — verifica siempre con SELECT antes. Es la operación DML más peligrosa si se usa mal."
}

$c5_09 = @{color="#ff5050";rgb="255,80,80";style="modern"
obj=@("Comparar DELETE, TRUNCATE y DROP","Usar DELETE para eliminar filas selectivamente","Elegir la operación correcta según el caso","Entender el rendimiento de cada una")
panels=@(
 (P "🧠 Intuición" @("DELETE, TRUNCATE y DROP son tres formas de 'quitar cosas' pero a diferentes niveles. DELETE quita filas (DML), TRUNCATE vacía la tabla (DDL), DROP elimina la tabla completa (DDL).","DELETE es como sacar libros de un estante uno por uno. TRUNCATE es como vaciar el estante entero. DROP es como desmontar el estante.","Cada una tiene un caso de uso diferente."))
 (P "📝 Comparativa" @("DELETE: elimina filas, puede tener WHERE, es DML (se puede deshacer con transacción), lento.","TRUNCATE: elimina todas las filas, no puede tener WHERE, es DDL (no se deshace), rápido, resetea SERIAL.","DROP: elimina la tabla (estructura + datos), no se deshace, inmediato."))
 (P "💻 Ejemplo" @("DELETE FROM productos WHERE stock = 0; — elimina solo sin stock.","TRUNCATE TABLE productos; — vacía toda la tabla.","DROP TABLE productos; — elimina la tabla completa."))
 (P "⚠️ Errores" @("DELETE sin WHERE: elimina TODAS las filas (pero más lento que TRUNCATE).","TRUNCATE con FK referenciando: no se puede (usa CASCADE).","DROP sin verificar: pérdida total de datos."))
 (P "🔍 Dato" @("TRUNCATE es más rápido porque no escanea filas ni genera registros de transacción.","PostgreSQL permite TRUNCATE CASCADE para truncar tablas relacionadas.","DELETE puede activar triggers, TRUNCATE no."))
 (P "🎯 Clave" @("DELETE = elimina filas (con WHERE posible).","TRUNCATE = vacía la tabla (rápido).","DROP = elimina tabla completa.","DELETE es DML (transaccional), DROP y TRUNCATE son DDL."))
)
step="<div class=""code-block"">-- Comparativa de las 3 operaciones:<br><br>-- 1. DELETE: quita filas específicas (más lento, con WHERE)<br>DELETE FROM productos WHERE stock = 0;<br><br>-- 2. TRUNCATE: vacía toda la tabla (rápido, sin WHERE)<br>TRUNCATE TABLE productos;<br><br>-- 3. DROP: elimina toda la tabla<br>DROP TABLE productos;</div>"
summary="DELETE elimina filas selectivamente (DML, lento, transaccional). TRUNCATE vacía la tabla (DDL, rápido, no transaccional). DROP elimina toda la tabla. Elige según necesites precisión, velocidad o eliminación total."
}

$c5_10 = @{color="#ff5050";rgb="255,80,80";style="modern"
obj=@("Entender acciones referenciales ON DELETE","Usar CASCADE para eliminar en cascada","Usar SET NULL para poner NULL en FK","Usar RESTRICT para prevenir eliminación")
panels=@(
 (P "🧠 Intuición" @("Cuando eliminas un cliente, ¿qué pasa con sus pedidos? ON DELETE define la regla. CASCADE los elimina también. SET NULL deja el pedido pero sin cliente. RESTRICT impide eliminar si hay pedidos.","Es como la cláusula de cancelación de un contrato: define qué pasa con lo relacionado cuando cancelas algo principal.","Elegir la acción correcta es importante para la integridad de datos."))
 (P "📝 Acciones ON DELETE" @("ON DELETE CASCADE: elimina las filas relacionadas automáticamente.","ON DELETE SET NULL: pone NULL en la FK de las filas relacionadas.","ON DELETE RESTRICT: impide eliminar si hay filas relacionadas.","ON DELETE NO ACTION: similar a RESTRICT (diferencia en orden de evaluación)."))
 (P "💻 Ejemplo" @("FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE;","FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE SET NULL;","FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE RESTRICT;"))
 (P "⚠️ Errores" @("CASCADE en cascada múltiple: puede eliminar muchas tablas.","SET NULL en FK con NOT NULL: error.","RESTRICT rechaza con error de violación de FK."))
 (P "🔍 Dato" @("PostgreSQL también tiene ON UPDATE CASCADE/SET NULL/RESTRICT.","CASCADE es la opción más conveniente pero también la más peligrosa.","SET NULL puede dejar datos huérfanos con NULL."))
 (P "🎯 Clave" @("CASCADE → elimina relacionados.","SET NULL → pone NULL en FK.","RESTRICT → impide eliminar.","Elige según la lógica de negocio."))
)
step="<div class=""code-block"">-- ON DELETE CASCADE: elimina pedidos al eliminar cliente<br>CREATE TABLE pedidos (<br>  id SERIAL PRIMARY KEY,<br>  cliente_id INTEGER REFERENCES clientes(id) ON DELETE CASCADE,<br>  total DECIMAL<br>);<br><br>-- ON DELETE SET NULL: deja pedidos sin cliente<br>CREATE TABLE pedidos (<br>  id SERIAL PRIMARY KEY,<br>  cliente_id INTEGER REFERENCES clientes(id) ON DELETE SET NULL,<br>  total DECIMAL<br>);</div>"
summary="ON DELETE define qué pasa con las filas relacionadas al eliminar. CASCADE elimina en cascada, SET NULL deja NULL, RESTRICT bloquea la eliminación. Elige según la lógica de negocio y la integridad de datos."
}

$c5_11 = @{color="#ff5050";rgb="255,80,80";style="modern"
obj=@("Combinar múltiples constraints en una tabla","Aplicar PK, FK, UNIQUE, CHECK juntos","Diseñar esquemas completos con constraints","Entender el orden de evaluación")
panels=@(
 (P "🧠 Intuición" @("Los constraints combinados son como las reglas de un juego: todas se aplican simultáneamente. Una tabla bien diseñada tiene PK, FK, UNIQUE, NOT NULL y CHECK trabajando juntos.","Cada constraint protege un aspecto diferente de la integridad. Juntos hacen que la base de datos sea robusta y confiable."))
 (P "📝 Constraints combinados" @("PK: identidad única.","FK: relaciones válidas.","UNIQUE: sin duplicados.","NOT NULL: datos obligatorios.","CHECK: valores válidos.","DEFAULT: valores automáticos."))
 (P "💻 Ejemplo" @("CREATE TABLE pedidos (id SERIAL PRIMARY KEY, codigo VARCHAR(20) UNIQUE NOT NULL, cliente_id INTEGER NOT NULL REFERENCES clientes(id), total DECIMAL CHECK (total >= 0), fecha DATE DEFAULT CURRENT_DATE);"))
 (P "⚠️ Errores" @("Demasiados constraints: pueden hacer lentas las inserciones.","Constraints contradictorios: CHECK (edad > 0) y CHECK (edad > 100) a la vez.","No planificar constraints desde el inicio."))
 (P "🔍 Dato" @("Los constraints se evalúan en el orden en que se definen (PostgreSQL).","Las tablas con muchos constraints son más seguras pero más lentas en escritura.","Los nombres descriptivos ayudan a diagnosticar errores: CONSTRAINT ck_edad_positiva CHECK (edad > 0)."))
 (P "🎯 Clave" @("Combina constraints para integridad completa.","Cada constraint protege algo diferente.","Diseña constraints al crear la tabla.","Nombra los constraints descriptivamente."))
)
step="<div class=""code-block"">-- Tabla con constraints combinados<br>CREATE TABLE productos (<br>  id SERIAL PRIMARY KEY,<br>  codigo VARCHAR(20) UNIQUE NOT NULL,<br>  nombre VARCHAR(200) NOT NULL,<br>  precio DECIMAL(10,2) CHECK (precio >= 0),<br>  stock INTEGER DEFAULT 0 CHECK (stock >= 0),<br>  categoria_id INTEGER REFERENCES categorias(id),<br>  activo BOOLEAN DEFAULT true,<br>  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP<br>);</div>"
summary="Los constraints combinados (PK, FK, UNIQUE, NOT NULL, CHECK, DEFAULT) trabajan juntos para garantizar la integridad de datos. Diseña todos los constraints al crear la tabla para una base de datos robusta."
}

$c5_12 = @{color="#ff5050";rgb="255,80,80";style="modern"
obj=@("Diseñar el esquema completo de una BD","Aplicar todos los conceptos DDL y DML","Crear tablas con constraints","Insertar y manipular datos")
panels=@(
 (P "🧠 Intuición" @("Este proyecto te reta a diseñar la base de datos completa de un sistema. Desde cero: creas la BD, las tablas con sus relaciones, insertas datos y aplicas constraints.","Es el proyecto más completo de DDL/DML: diseñar es más difícil que consultar.","Un buen diseño evita problemas futuros de datos inconsistentes o consultas lentas."))
 (P "📝 Proyecto" @("Crear base de datos y esquema.","Definir tablas con PK y FK.","Aplicar UNIQUE, NOT NULL, CHECK, DEFAULT.","ON DELETE CASCADE/SET NULL.","Insertar datos de prueba."))
 (P "💻 Ejemplo" @("Sistema de biblioteca: libros, autores, préstamos, usuarios.","Sistema de tienda: productos, categorías, pedidos, clientes.","Sistema de escuela: estudiantes, cursos, inscripciones, profesores."))
 (P "⚠️ Desafíos" @("Relaciones M:M requieren tabla pivote.","ON DELETE CASCADE puede ser peligroso.","No olvidar UNIQUE en emails/usernames."))
 (P "🔍 Dato" @("Los diseñadores de BD profesionales pasan el 60% del tiempo en el diseño conceptual.","Un buen diseño se nota en la velocidad de las consultas.","Los cambios de esquema en producción son costosos."))
 (P "🎯 Consejo" @("Dibuja el diagrama ER antes de escribir SQL.","Empieza con las tablas principales y luego las secundarias.","Verifica cada constraint con datos de prueba."))
)
step="<div class=""code-block"">-- Sistema de biblioteca — diseño completo<br><br>CREATE TABLE autores (id SERIAL PRIMARY KEY, nombre TEXT NOT NULL);<br><br>CREATE TABLE libros (id SERIAL PRIMARY KEY, titulo TEXT NOT NULL, autor_id INTEGER REFERENCES autores(id) ON DELETE CASCADE, isbn VARCHAR(20) UNIQUE, año INTEGER CHECK (año > 1400));<br><br>CREATE TABLE usuarios (id SERIAL PRIMARY KEY, nombre TEXT NOT NULL, email VARCHAR(200) UNIQUE NOT NULL);<br><br>CREATE TABLE prestamos (id SERIAL PRIMARY KEY, libro_id INTEGER REFERENCES libros(id) ON DELETE RESTRICT, usuario_id INTEGER REFERENCES usuarios(id), fecha DATE DEFAULT CURRENT_DATE, devuelto BOOLEAN DEFAULT false);</div>"
summary="Has diseñado una base de datos completa con tablas, PK, FK, constraints y relaciones. Este es el flujo de trabajo real de un diseñador de bases de datos. ¡Felicidades! Ahora entiendes cómo se crean las bases de datos desde cero."
}

# ============ CURSO 6 - DISEÑO DE DATOS (#ffd700 / 255,215,0) ============
$c6_01 = @{color="#ffd700";rgb="255,215,0";style="modern"
obj=@("Conocer tipos numéricos en SQL","Elegir el tipo numérico correcto","Entender INTEGER, DECIMAL, NUMERIC","Diferenciar precisión y escala")
panels=@(
 (P "🧠 Intuición" @("Los tipos numéricos son como diferentes tamaños de recipientes. INTEGER es una taza medidora (números sin decimales). DECIMAL es una báscula de precisión (con decimales exactos). NUMERIC es una báscula científica de alta precisión.","Usar el tipo correcto ahorra espacio y evita errores de redondeo. Un SMALLINT ocupa 2 bytes, un INTEGER 4, un BIGINT 8."))
 (P "📝 Tipos Numéricos" @("SMALLINT: 2 bytes, -32K a +32K.","INTEGER: 4 bytes, -2B a +2B.","BIGINT: 8 bytes, -9Q a +9Q.","DECIMAL(p,s): exacto, p dígitos, s decimales.","NUMERIC(p,s): exacto, igual que DECIMAL.","REAL: 4 bytes, aproximado.","DOUBLE: 8 bytes, aproximado."))
 (P "💻 Ejemplo" @("Edad: SMALLINT es suficiente (0-150).","Precio: DECIMAL(10,2) para exactitud con 2 decimales.","Población mundial: BIGINT.","Promedio: REAL o DOUBLE es aceptable."))
 (P "⚠️ Errores" @("Usar INTEGER para precios: pierdes los decimales.","Usar DECIMAL sin especificar decimales: DECIMAL(10,0) = solo enteros.","Usar REAL para dinero: errores de redondeo."))
 (P "🔍 Dato" @("PostgreSQL tiene tipos adicionales: SMALLSERIAL, SERIAL, BIGSERIAL.","NUMERIC y DECIMAL son sinónimos en PostgreSQL.","DOUBLE se llama DOUBLE PRECISION en PostgreSQL."))
 (P "🎯 Clave" @("Elige el tipo según el rango y precisión.","DECIMAL/NUMERIC para dinero (exactos).","INTEGER/BIGINT para conteos.","REAL/DOUBLE para aproximaciones."))
)
step="<div class=""code-block"">-- Paso 1: Crear tabla con tipos numéricos<br>CREATE TABLE productos (<br>  id SERIAL PRIMARY KEY,           -- entero autoincremental<br>  precio DECIMAL(10,2) NOT NULL,    -- exacto, 2 decimales<br>  stock INTEGER DEFAULT 0,          -- entero<br>  peso REAL                         -- aproximado<br>);<br><br>-- DECIMAL(10,2) = 8 dígitos enteros + 2 decimales<br>-- Rango: -99999999.99 a 99999999.99</div>"
summary="Los tipos numéricos SQL incluyen SMALLINT, INTEGER, BIGINT (enteros) y DECIMAL/NUMERIC (exactos) y REAL/DOUBLE (aproximados). Elige según rango y precisión necesaria. Para dinero siempre usa DECIMAL."
}

$c6_02 = @{color="#ffd700";rgb="255,215,0";style="modern"
obj=@("Conocer tipos de texto en SQL","Diferenciar CHAR, VARCHAR y TEXT","Elegir el tipo de texto adecuado","Entender las limitaciones de cada tipo")
panels=@(
 (P "🧠 Intuición" @("CHAR es como un aparcamiento de tamaño fijo: siempre ocupa el mismo espacio aunque esté vacío. VARCHAR es como un aparcamiento flexible: solo ocupa lo necesario. TEXT es como un campo abierto sin límite.","CHAR(10) siempre ocupa 10 caracteres (rellena con espacios). VARCHAR(10) ocupa solo los caracteres que uses (más 1-2 bytes extra). TEXT no tiene límite práctico."))
 (P "📝 Tipos de Texto" @("CHAR(n): longitud fija, rellena con espacios.","VARCHAR(n): longitud variable, límite n.","TEXT: longitud variable, sin límite práctico.","Todos almacenan texto en la codificación de la BD."))
 (P "💻 Ejemplo" @("Código postal: CHAR(5) — siempre 5 caracteres.","Nombre: VARCHAR(100) — longitud variable.","Descripción larga: TEXT — sin límite.","Email: VARCHAR(254) — máximo estándar."))
 (P "⚠️ Errores" @("CHAR desperdicia espacio si el texto es más corto.","VARCHAR(n) con n demasiado pequeño: truncamiento.","TEXT en columnas de índice: limitaciones de tamaño."))
 (P "🔍 Dato" @("En PostgreSQL, VARCHAR sin n equivale a TEXT.","CHAR(1) y VARCHAR(1) son diferentes en almacenamiento.","TEXT y VARCHAR(n) tienen el mismo rendimiento en PostgreSQL."))
 (P "🎯 Clave" @("CHAR = longitud fija (códigos, abreviaturas).","VARCHAR = longitud variable con límite (nombres, emails).","TEXT = texto largo sin límite (descripciones).","VARCHAR es el más usado."))
)
step="<div class=""code-block"">-- Paso 1: Tipos de texto en acción<br>CREATE TABLE usuarios (<br>  id SERIAL PRIMARY KEY,<br>  codigo CHAR(10) UNIQUE,           -- fijo: 'USR0000001'<br>  nombre VARCHAR(100) NOT NULL,      -- variable: 'Ana García'<br>  bio TEXT,                          -- texto largo: 'Nacida en...'<br>  email VARCHAR(254) UNIQUE NOT NULL -- estándar email<br>);</div>"
summary="CHAR para longitud fija, VARCHAR para variable con límite, TEXT para texto largo. VARCHAR es el tipo más versátil y usado. TEXT es ideal para descripciones y contenido largo."
}

$c6_03 = @{color="#ffd700";rgb="255,215,0";style="modern"
obj=@("Conocer tipos de fecha/hora en SQL","Usar DATE, TIME, TIMESTAMP","Trabajar con INTERVAL","Elegir el tipo de fecha adecuado")
panels=@(
 (P "🧠 Intuición" @("DATE guarda solo la fecha (año-mes-día). TIME guarda solo la hora. TIMESTAMP guarda ambos. INTERVAL guarda periodos de tiempo.","Elegir el tipo correcto evita conversiones y errores. Si solo necesitas la fecha, no uses TIMESTAMP.","PostgreSQL tiene TIMESTAMP con y sin zona horaria (TIMESTAMPTZ)."))
 (P "📝 Tipos de Fecha/Hora" @("DATE: fecha (2024-01-15).","TIME: hora (14:30:00).","TIMESTAMP: fecha + hora (2024-01-15 14:30:00).","TIMESTAMPTZ: con zona horaria.","INTERVAL: periodo (1 year 2 months)."))
 (P "💻 Ejemplo" @("fecha_nacimiento DATE, hora_entrada TIME, creado_en TIMESTAMP DEFAULT NOW(), duracion INTERVAL '2 hours'"))
 (P "⚠️ Errores" @("Guardar hora en DATE: se pierde.","No considerar zona horaria: TIMESTAMP sin TZ puede confundir.","Formato incorrecto: '2024/01/15' vs '2024-01-15'."))
 (P "🔍 Dato" @("PostgreSQL almacena TIMESTAMP en 8 bytes.","CURRENT_DATE, CURRENT_TIME, NOW() son funciones útiles.","AGE() calcula la edad entre dos fechas como INTERVAL."))
 (P "🎯 Clave" @("DATE = solo fecha.","TIME = solo hora.","TIMESTAMP = fecha + hora.","TIMESTAMPTZ = con zona horaria.","INTERVAL = periodo de tiempo."))
)
step="<div class=""code-block"">-- Paso 1: Tabla con tipos de fecha/hora<br>CREATE TABLE eventos (<br>  id SERIAL PRIMARY KEY,<br>  fecha_evento DATE NOT NULL,          -- solo fecha<br>  hora_inicio TIME,                     -- solo hora<br>  creado_en TIMESTAMP DEFAULT NOW(),    -- fecha + hora<br>  duracion INTERVAL                     -- periodo:'2 hours'<br>);<br><br>-- INSERT ejemplo<br>INSERT INTO eventos (fecha_evento, hora_inicio, duracion)<br>VALUES ('2024-12-25', '20:00:00', '3 hours');</div>"
summary="DATE para fechas, TIME para horas, TIMESTAMP para fecha+hora, INTERVAL para periodos. TIMESTAMPTZ incluye zona horaria. Elige el tipo según la precisión temporal que necesites."
}

$c6_04 = @{color="#ffd700";rgb="255,215,0";style="modern"
obj=@("Entender el tipo BOOLEAN","Usar TRUE, FALSE y NULL","Aplicar operaciones lógicas","Filtrar con condiciones booleanas")
panels=@(
 (P "🧠 Intuición" @("BOOLEAN es el tipo más simple: solo puede ser TRUE, FALSE o NULL. Es como un interruptor de luz: encendido/apagado.","En SQL, BOOLEAN se usa para indicar estados binarios: activo/inactivo, pagado/no pagado, completo/incompleto.","NULL en BOOLEAN significa 'desconocido' — ni verdadero ni falso."))
 (P "📝 Sintaxis BOOLEAN" @("CREATE TABLE t (activo BOOLEAN DEFAULT true);","WHERE activo = true (o WHERE activo, es equivalente).","WHERE NOT activo (o WHERE activo = false).","WHERE activo IS NULL — para valor desconocido."))
 (P "💻 Ejemplo" @("SELECT * FROM productos WHERE activo; — productos activos.","UPDATE usuarios SET activo = false WHERE id = 5; — desactivar usuario.","SELECT * FROM tareas WHERE completado IS NULL; — tareas sin estado."))
 (P "⚠️ Errores" @("Usar = true vs solo el nombre: WHERE activo es más limpio que WHERE activo = true.","Pensar que NOT activo es lo mismo que activo = false: NOT activo incluye NULL como NULL (no FALSE).","Comparar BOOLEAN con 0/1: en SQL estándar no son equivalentes."))
 (P "🔍 Dato" @("PostgreSQL acepta 'yes'/'no', 't'/'f', '1'/'0' como BOOLEAN.","MySQL no tiene BOOLEAN real (usa TINYINT(1)).","SQL estándar define BOOLEAN como tipo nativo."))
 (P "🎯 Clave" @("TRUE, FALSE, NULL — tres estados.","WHERE activo = WHERE activo = true.","NOT activo no es lo mismo que activo = false (NULL).","Ideal para estados binarios."))
)
step="<div class=""code-block"">-- Paso 1: Crear tabla con BOOLEAN<br>CREATE TABLE tareas (<br>  id SERIAL PRIMARY KEY,<br>  titulo TEXT NOT NULL,<br>  completado BOOLEAN DEFAULT false,<br>  activo BOOLEAN DEFAULT true<br>);<br><br>-- Paso 2: Insertar y filtrar<br>INSERT INTO tareas (titulo) VALUES ('Aprender SQL');<br>SELECT * FROM tareas WHERE NOT completado; -- tareas pendientes<br>SELECT * FROM tareas WHERE activo; -- tareas activas</div>"
summary="BOOLEAN tiene tres estados: TRUE, FALSE y NULL. Es ideal para indicadores binarios. WHERE activo es equivalente a WHERE activo = true. Recuerda que NOT activo puede dar NULL si activo es NULL."
}

$c6_05 = @{color="#ffd700";rgb="255,215,0";style="modern"
obj=@("Usar COALESCE para reemplazar NULL","Usar NULLIF para evitar división por cero","Manejar valores nulos en cálculos","Aplicar funciones de control de NULL")
panels=@(
 (P "🧠 Intuición" @("COALESCE es como tener un plan B: 'si este valor es NULL, usa este otro'. Como cuando preguntas el teléfono de alguien y si no tiene, dices 'no registrado'.","NULLIF es como un detector de casos especiales: si dos valores son iguales, devuelve NULL. Útil para evitar división por cero: NULLIF(cero, 0) da NULL, y dividir por NULL da NULL (no error)."))
 (P "📝 Sintaxis" @("COALESCE(valor1, valor2, ..., default) — devuelve el primer NO NULL.","NULLIF(valor1, valor2) — si son iguales, devuelve NULL; si no, valor1.","COALESCE(columna, 'sin dato') — reemplazo simple."))
 (P "💻 Ejemplo" @("SELECT nombre, COALESCE(telefono, 'No registrado') AS telefono FROM clientes;","SELECT nombre, salario / NULLIF(horas, 0) AS salario_hora FROM empleados; — evita división por cero.","SELECT COALESCE(precio_oferta, precio_regular, 0) FROM productos;"))
 (P "⚠️ Errores" @("COALESCE con todos NULL: devuelve NULL (no da error).","NULLIF solo compara dos valores, no más.","Confundir COALESCE con IFNULL (IFNULL solo acepta 2 args)."))
 (P "🔍 Dato" @("COALESCE es estándar SQL, IFNULL es de MySQL/SQLite.","NVL es la versión de Oracle (2 args).","PostgreSQL acepta COALESCE con múltiples argumentos."))
 (P "🎯 Clave" @("COALESCE = reemplaza NULL con alternativa.","NULLIF = devuelve NULL si dos valores son iguales.","Útiles para cálculos seguros con NULL.","COALESCE acepta múltiples argumentos."))
)
step="<div class=""code-block"">-- Paso 1: COALESCE — valor por defecto<br>SELECT nombre, COALESCE(telefono, 'No registrado') AS telefono FROM clientes;<br><br>-- Paso 2: NULLIF — evitar división por cero<br>SELECT nombre, salario / NULLIF(horas_trabajadas, 0) AS salario_hora FROM empleados;<br><br>-- Paso 3: COALESCE con múltiples opciones<br>SELECT nombre, COALESCE(precio_oferta, precio_regular, 0) AS precio_final FROM productos;</div>"
summary="COALESCE reemplaza NULL con un valor alternativo. NULLIF devuelve NULL si dos valores son iguales (útil para evitar división por cero). Ambas son esenciales para manejar NULL de forma segura en cálculos."
}

$c6_06 = @{color="#ffd700";rgb="255,215,0";style="modern"
obj=@("Usar CAST para convertir tipos","Usar :: para conversión en PostgreSQL","Convertir texto a número y viceversa","Entender las reglas de conversión")
panels=@(
 (P "🧠 Intuición" @("CAST es como un traductor: convierte un valor de un tipo a otro. Como cambiar dólares a euros: el valor es el mismo pero en otra moneda.",":: es la sintaxis abreviada de PostgreSQL: CAST( texto AS INTEGER ) = texto::INTEGER.","Algunas conversiones son automáticas, otras necesitan CAST explícito."))
 (P "📝 Sintaxis CAST" @("CAST(expresion AS tipo) — estándar SQL.","expresion::tipo — sintaxis PostgreSQL.","SELECT CAST('123' AS INTEGER);","SELECT '123'::INTEGER; — equivalente."))
 (P "💻 Ejemplo" @("SELECT CAST(precio AS DECIMAL(10,2)) FROM productos;","SELECT '2024-01-15'::DATE; — convertir texto a fecha.","SELECT CAST(total AS TEXT) FROM pedidos; — número a texto.","SELECT CAST(5 AS DECIMAL) / 2; — división exacta."))
 (P "⚠️ Errores" @("Cast inválido: CAST('ABC' AS INTEGER) da error.","Pérdida de precisión: CAST(10.99 AS INTEGER) da 10.","Conversión implícita puede dar resultados inesperados."))
 (P "🔍 Dato" @("PostgreSQL tiene formatos adicionales: to_date(), to_char(), to_number().",":: es más legible para conversiones rápidas.","CAST puede usarse en cualquier expresión."))
 (P "🎯 Clave" @("CAST convierte entre tipos compatibles.",":: es la sintaxis abreviada de PostgreSQL.","Necesario cuando la conversión implícita no funciona.","Puede perder precisión en algunos casos."))
)
step="<div class=""code-block"">-- Paso 1: CAST estándar<br>SELECT CAST('123' AS INTEGER) + 1; -- 124<br><br>-- Paso 2: Sintaxis :: (PostgreSQL)<br>SELECT '2024-12-25'::DATE;<br>SELECT '14:30:00'::TIME;<br>SELECT precio::DECIMAL(10,2) FROM productos;<br><br>-- Paso 3: CAST para división exacta<br>SELECT CAST(5 AS DECIMAL) / 2; -- 2.5 (no 2)</div>"
summary="CAST convierte valores entre tipos de datos. :: es la sintaxis abreviada de PostgreSQL. Úsalo cuando necesites conversión explícita, especialmente para división exacta o para cambiar formato de fechas/números."
}

$c6_07 = @{color="#ffd700";rgb="255,215,0";style="modern"
obj=@("Entender la Primera Forma Normal (1NF)","Aplicar atomicidad en columnas","Eliminar grupos repetitivos","Identificar violaciones de 1NF")
panels=@(
 (P "🧠 Intuición" @("1NF es como organizar tu refrigerador: cada compartimento guarda UNA sola cosa. No mezcles frutas y verduras en el mismo cajón.","Regla 1: cada celda contiene UN SOLO valor (atómico). Regla 2: no hay grupos repetitivos (varios teléfonos en una celda). Regla 3: cada fila tiene una clave única.","1NF es lo MÍNIMO para que algo sea una tabla relacional."))
 (P "📝 Reglas de 1NF" @("1. Atomicidad: cada columna debe contener un solo valor.","2. Sin grupos repetitivos: no múltiples valores separados por coma.","3. Clave primaria: cada fila debe ser identificable de forma única."))
 (P "💻 Ejemplo" @("❌ Violación: tabla con columna 'telefonos' con '555-0101, 555-0202'.","✅ 1NF: separar en filas individuales o crear tabla relacionada.","❌ Violación: columna 'curso' con 'SQL, Python, Java'.","✅ 1NF: crear tabla estudiante_curso separada."))
 (P "⚠️ Errores" @("Múltiples valores en una celda separados por coma.","Varios números de teléfono en el mismo campo.","Listas de valores en una columna de texto."))
 (P "🔍 Dato" @("1NF es el primer paso de la normalización.","Sin 1NF las consultas se vuelven muy complejas.","Las bases de datos NoSQL no requieren 1NF."))
 (P "🎯 Clave" @("Cada celda = un solo valor.","No hay listas dentro de una celda.","Cada fila tiene clave única.","1NF es el mínimo para tablas relacionales."))
)
step="<div class=""code-block"">-- ❌ Violación de 1NF: múltiples valores en una columna<br>CREATE TABLE estudiantes (<br>  id INTEGER PRIMARY KEY,<br>  nombre TEXT,<br>  telefonos TEXT,      -- '555-0101, 555-0202'<br>  cursos TEXT           -- 'SQL, Python'<br>);<br><br>-- ✅ Solución 1NF: tabla separada para teléfonos<br>CREATE TABLE estudiantes (id SERIAL PRIMARY KEY, nombre TEXT);<br>CREATE TABLE telefonos (id SERIAL PRIMARY KEY, estudiante_id INTEGER REFERENCES estudiantes(id), numero TEXT);<br>CREATE TABLE inscripciones (estudiante_id INTEGER, curso TEXT);</div>"
summary="1NF exige: 1) columnas atómicas (un valor por celda), 2) sin grupos repetitivos, 3) clave primaria. Es el nivel mínimo de normalización para tablas relacionales. Violarla complica consultas y mantenimiento."
}

$c6_08 = @{color="#ffd700";rgb="255,215,0";style="modern"
obj=@("Entender la Segunda Forma Normal (2NF)","Aplicar 2NF después de 1NF","Eliminar dependencias parciales","Identificar claves compuestas")
panels=@(
 (P "🧠 Intuición" @("2NF aplica cuando tienes una clave compuesta (varias columnas como PK). Dice: 'cada columna NO clave debe depender de TODA la clave, no solo de una parte'.","Si tu PK es (estudiante_id, curso_id) y guardas el nombre del estudiante, eso depende solo de estudiante_id — es una dependencia parcial que hay que eliminar.","2NF solo aplica a tablas con clave compuesta. Si la PK es una sola columna, automáticamente está en 2NF si está en 1NF."))
 (P "📝 Reglas de 2NF" @("1. Estar en 1NF (prerrequisito).","2. Toda columna no clave debe depender de TODA la clave primaria.","3. Si hay dependencia parcial, separa en otra tabla."))
 (P "💻 Ejemplo" @("❌ Tabla: inscripciones(estudiante_id, curso_id, nombre_estudiante, nombre_curso, nota). nombre_estudiante depende solo de estudiante_id. nombre_curso depende solo de curso_id.","✅ Separar en: estudiantes(id, nombre), cursos(id, nombre), inscripciones(estudiante_id, curso_id, nota)."))
 (P "⚠️ Errores" @("No identificar correctamente la clave primaria compuesta.","Dejar dependencias parciales en la tabla.","Aplicar 2NF cuando no hay clave compuesta."))
 (P "🔍 Dato" @("2NF fue definida por Edgar Codd en 1971.","La mayoría de tablas con PK simple ya están en 2NF si están en 1NF.","2NF ayuda a eliminar redundancia de datos."))
 (P "🎯 Clave" @("Aplica solo con clave compuesta.","Elimina dependencias PARCIALES.","Cada columna debe depender de TODA la clave.","Separa en tablas cuando hay dependencia parcial."))
)
step="<div class=""code-block"">-- ❌ Violación de 2NF: dependencias parciales<br>CREATE TABLE inscripciones (<br>  estudiante_id INTEGER,<br>  curso_id INTEGER,<br>  nombre_estudiante TEXT,  -- depende solo de estudiante_id<br>  nombre_curso TEXT,        -- depende solo de curso_id<br>  nota DECIMAL,<br>  PRIMARY KEY (estudiante_id, curso_id)<br>);<br><br>-- ✅ Solución 2NF<br>CREATE TABLE estudiantes (id SERIAL PRIMARY KEY, nombre TEXT);<br>CREATE TABLE cursos (id SERIAL PRIMARY KEY, titulo TEXT);<br>CREATE TABLE inscripciones (estudiante_id INTEGER REFERENCES estudiantes(id), curso_id INTEGER REFERENCES cursos(id), nota DECIMAL, PRIMARY KEY (estudiante_id, curso_id));</div>"
summary="2NF elimina dependencias parciales: cada columna no clave debe depender de TODA la clave primaria (no solo de una parte). Aplica solo a tablas con clave compuesta. Separa en tablas cuando encuentres dependencias parciales."
}

$c6_09 = @{color="#ffd700";rgb="255,215,0";style="modern"
obj=@("Entender la Tercera Forma Normal (3NF)","Eliminar dependencias transitivas","Aplicar 3NF después de 2NF","Diferenciar 2NF de 3NF")
panels=@(
 (P "🧠 Intuición" @("3NF dice: 'ninguna columna NO clave debe depender de otra columna NO clave'. Si A → B y B → C, entonces C depende transitivamente de A y debe separarse.","Imagina: empleado(id, nombre, depto_id, depto_ciudad). depto_ciudad depende de depto_id, no del empleado. Es una dependencia transitiva.","3NF elimina estas 'cadenas' de dependencias entre columnas no clave."))
 (P "📝 Reglas de 3NF" @("1. Estar en 2NF (prerrequisito).","2. Toda columna no clave debe depender DIRECTAMENTE de la PK.","3. No debe haber dependencias transitivas (A→B→C)."))
 (P "💻 Ejemplo" @("❌ Tabla: empleados(id, nombre, depto_id, depto_nombre, depto_ciudad). depto_nombre y depto_ciudad dependen de depto_id, no del empleado.","✅ Separar: empleados(id, nombre, depto_id), departamentos(id, nombre, ciudad)."))
 (P "⚠️ Errores" @("Confundir dependencia transitiva con dependencia parcial (2NF vs 3NF).","No normalizar hasta 3NF puede causar anomalías de actualización.","Sobrenormalizar: a veces 3NF es suficiente, no necesitas BCNF."))
 (P "🔍 Dato" @("La mayoría de bases de datos en producción están en 3NF.","3NF elimina la redundancia de datos.","Las anomalías de actualización ocurren cuando modificas un dato en un lugar pero no en otro."))
 (P "🎯 Clave" @("Elimina dependencias TRANSITIVAS.","Columna no clave depende de otra no clave.","Separa en tablas para evitar redundancia.","3NF es el nivel estándar para BD en producción."))
)
step="<div class=""code-block"">-- ❌ Violación de 3NF: dependencia transitiva<br>CREATE TABLE empleados (<br>  id SERIAL PRIMARY KEY,<br>  nombre TEXT,<br>  depto_id INTEGER,<br>  depto_nombre TEXT,    -- depende de depto_id, no del empleado<br>  depto_ciudad TEXT     -- depende de depto_id<br>);<br><br>-- ✅ Solución 3NF<br>CREATE TABLE departamentos (id SERIAL PRIMARY KEY, nombre TEXT, ciudad TEXT);<br>CREATE TABLE empleados (id SERIAL PRIMARY KEY, nombre TEXT, depto_id INTEGER REFERENCES departamentos(id));</div>"
summary="3NF elimina dependencias transitivas: ninguna columna no clave debe depender de otra columna no clave. Es el nivel estándar de normalización para bases de datos en producción. Separa en tablas para eliminar redundancia."
}

$c6_10 = @{color="#ffd700";rgb="255,215,0";style="modern"
obj=@("Entender cuándo desnormalizar","Conocer los beneficios y riesgos","Aplicar desnormalización por rendimiento","Balancear normalización y velocidad")
panels=@(
 (P "🧠 Intuición" @("Desnormalizar es como tener una libreta de direcciones en vez de consultar la guía telefónica cada vez. Es más rápido pero tienes que mantenerla actualizada.","A veces la normalización estricta hace las consultas muy lentas (muchos JOINs). Desnormalizar añade redundancia controlada para mejorar velocidad de lectura.","Es una decisión de ingeniería: consistencia vs rendimiento."))
 (P "📝 Cuándo Desnormalizar" @("Reportes y dashboards (muchas lecturas, pocas escrituras).","Tablas con millones de filas y JOINs frecuentes.","Caché de datos calculados (totales, promedios).","Sistemas donde la velocidad de lectura es crítica."))
 (P "💻 Ejemplo" @("Añadir total_gastado directamente en clientes (en vez de SUM en cada consulta).","Guardar nombre de categoría en productos (en vez de JOIN cada vez).","Tablas pre-agregadas para reportes mensuales."))
 (P "⚠️ Riesgos" @("Inconsistencia de datos: si actualizas en un lugar pero no en otro.","Mayor espacio de almacenamiento.","Más complejidad en actualizaciones (triggers, procesos ETL)."))
 (P "🔍 Dato" @("Las bases de datos analíticas (OLAP) suelen estar desnormalizadas.","Las transaccionales (OLTP) suelen estar normalizadas.","La desnormalización se aplica DESPUÉS de normalizar, no en lugar de."))
 (P "🎯 Clave" @("Desnormalizar = redundancia controlada.","Mejora velocidad de lectura.","Riesgo de inconsistencia.","Aplica solo cuando el rendimiento lo justifique."))
)
step="<div class=""code-block"">-- ❌ Normalizado (muchos JOINs)<br>SELECT c.nombre, SUM(p.total) AS gasto FROM clientes c JOIN pedidos p ON c.id = p.cliente_id GROUP BY c.nombre;<br><br>-- ✅ Desnormalizado (sin JOIN)<br>SELECT nombre, total_gastado FROM clientes;<br>-- Nota: total_gastado se actualiza con cada nuevo pedido (trigger o app)</div>"
summary="La desnormalización añade redundancia controlada para mejorar el rendimiento de lectura. Se aplica después de normalizar, cuando los JOINs son demasiado lentos. Balancea consistencia vs velocidad según las necesidades."
}

$c6_11 = @{color="#ffd700";rgb="255,215,0";style="modern"
obj=@("Conocer SERIAL para autoincremento","Usar IDENTITY (SQL estándar)","Entender UUID como alternativa","Elegir la estrategia de IDs adecuada")
panels=@(
 (P "🧠 Intuición" @("SERIAL es como un contador automático que asigna 1, 2, 3... a cada nueva fila. IDENTITY es la versión estándar SQL de lo mismo. UUID genera identificadores únicos universales (como 'abc123...' de 36 caracteres).","SERIAL es simple y eficiente pero solo único dentro de la tabla. UUID es único globalmente (útil para sistemas distribuidos) pero ocupa más espacio."))
 (P "📝 Estrategias" @("SERIAL: autoincremental (1, 2, 3...). PostgreSQL: SMALLSERIAL, SERIAL, BIGSERIAL.","IDENTITY: estándar SQL: GENERATED ALWAYS AS IDENTITY.","UUID: identificador único de 128 bits: gen_random_uuid()."))
 (P "💻 Ejemplo" @("id SERIAL PRIMARY KEY — autoincremental.","id INTEGER GENERATED ALWAYS AS IDENTITY — estándar.","id UUID DEFAULT gen_random_uuid() PRIMARY KEY — UUID."))
 (P "⚠️ Errores" @("SERIAL no previene huecos (si se elimina una fila, el número no se reusa).","SERIAL no es único entre tablas (cada tabla tiene su propio contador).","UUID es más lento como PK porque es más grande y aleatorio."))
 (P "🔍 Dato" @("PostgreSQL 10+ tiene IDENTITY (más estándar que SERIAL).","UUID es ideal para sistemas distribuidos o microservicios.","SERIAL ocupa 4 bytes, UUID ocupa 16 bytes."))
 (P "🎯 Clave" @("SERIAL = autoincremental simple.","IDENTITY = estándar SQL moderno.","UUID = único globalmente.","SERIAL es suficiente para la mayoría de casos."))
)
step="<div class=""code-block"">-- Opción 1: SERIAL (PostgreSQL clásico)<br>CREATE TABLE clientes (id SERIAL PRIMARY KEY, nombre TEXT);<br><br>-- Opción 2: IDENTITY (estándar SQL)<br>CREATE TABLE clientes (id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, nombre TEXT);<br><br>-- Opción 3: UUID<br>CREATE TABLE clientes (id UUID DEFAULT gen_random_uuid() PRIMARY KEY, nombre TEXT);</div>"
summary="SERIAL es el autoincremental clásico de PostgreSQL. IDENTITY es el estándar SQL moderno. UUID genera identificadores únicos globalmente. SERIAL es suficiente para la mayoría de aplicaciones, UUID para sistemas distribuidos."
}

$c6_12 = @{color="#ffd700";rgb="255,215,0";style="modern"
obj=@("Diseñar la BD completa de una biblioteca","Aplicar normalización 1NF, 2NF, 3NF","Usar todos los tipos de datos y constraints","Crear un esquema listo para producción")
panels=@(
 (P "🧠 Intuición" @("Este proyecto final integra TODO lo aprendido: diseño, tipos de datos, normalización, constraints y DDL. Diseñarás la base de datos de una biblioteca desde cero.","Una biblioteca real tiene libros, autores, socios, préstamos, multas, categorías... Es el caso perfecto para aplicar diseño relacional."))
 (P "📝 Proyecto" @("Diseñar diagrama ER.","Crear tablas normalizadas hasta 3NF.","Aplicar PK, FK, UNIQUE, CHECK, DEFAULT.","Elegir tipos de datos correctos.","Estrategia de IDs (SERIAL).","ON DELETE CASCADE/SET NULL."))
 (P "💻 Esquema" @("libros(id, titulo, isbn, año, editorial_id, categoria_id).","autores(id, nombre, nacionalidad).","libros_autores(libro_id, autor_id) — M:M.","socios(id, nombre, email, fecha_alta).","prestamos(id, libro_id, socio_id, fecha_prestamo, fecha_devolucion, estado)."))
 (P "⚠️ Desafíos" @("Recordar los 3 niveles de normalización.","Relaciones M:M requieren tabla pivote.","CHECK en fechas: fecha_devolucion > fecha_prestamo.","UNIQUE en email e ISBN."))
 (P "🔍 Dato" @("Este diseño es similar al que usan bibliotecas reales.","En producción añadirías índices, vistas y funciones.","El diseño es la parte más importante de cualquier proyecto de BD."))
 (P "🎯 Consejo" @("Empieza con el diagrama en papel.","Identifica las entidades principales y sus relaciones.","Normaliza paso a paso: 1NF → 2NF → 3NF.","Revisa cada constraint antes de crearlo."))
)
step="<div class=""code-block"">-- Sistema de Biblioteca — Diseño Final 3NF<br><br>CREATE TABLE categorias (id SERIAL PRIMARY KEY, nombre TEXT UNIQUE NOT NULL);<br>CREATE TABLE editoriales (id SERIAL PRIMARY KEY, nombre TEXT NOT NULL, pais TEXT);<br>CREATE TABLE autores (id SERIAL PRIMARY KEY, nombre TEXT NOT NULL, nacionalidad TEXT);<br><br>CREATE TABLE libros (id SERIAL PRIMARY KEY, titulo TEXT NOT NULL, isbn VARCHAR(20) UNIQUE, año INTEGER CHECK (año > 1400), editorial_id INTEGER REFERENCES editoriales(id) ON DELETE SET NULL, categoria_id INTEGER REFERENCES categorias(id) ON DELETE SET NULL);<br><br>CREATE TABLE libros_autores (libro_id INTEGER REFERENCES libros(id) ON DELETE CASCADE, autor_id INTEGER REFERENCES autores(id) ON DELETE CASCADE, PRIMARY KEY (libro_id, autor_id));<br><br>CREATE TABLE socios (id SERIAL PRIMARY KEY, nombre TEXT NOT NULL, email VARCHAR(254) UNIQUE NOT NULL, fecha_alta DATE DEFAULT CURRENT_DATE);<br><br>CREATE TABLE prestamos (id SERIAL PRIMARY KEY, libro_id INTEGER REFERENCES libros(id) ON DELETE RESTRICT, socio_id INTEGER REFERENCES socios(id) ON DELETE CASCADE, fecha_prestamo DATE DEFAULT CURRENT_DATE, fecha_devolucion DATE, CHECK (fecha_devolucion IS NULL OR fecha_devolucion > fecha_prestamo));</div>"
summary="¡Has completado el proyecto final! Diseñaste una base de datos de biblioteca en 3NF con todos los elementos: tipos de datos correctos, PK, FK, UNIQUE, CHECK, DEFAULT, y relaciones M:M. Este es el mismo proceso que siguen los profesionales de bases de datos. ¡Felicidades, has completado todo el programa SQL Básico!"
}

# ============ EXECUTION ============
$base = "D:\poryectosPulidos\PAGINA\cursos\programa-sql-basico"

$course1 = @("01-que-es-sql","02-select-from","03-alias-as","04-distinct","05-where","06-operadores-comparacion","07-and-or-not","08-order-by","09-limit-offset","10-comentarios-buenas-practicas","11-mini-proyecto-consultas","12-repaso-certificacion")
$course2 = @("01-like-patrones","02-in-between","03-is-null","04-funciones-cadena","05-funciones-fecha","06-funciones-matematicas","07-count-agregacion","08-sum-avg","09-min-max","10-group-by","11-having","12-mini-proyecto-ventas")
$course3 = @("01-llave-primaria-foranea","02-relaciones","03-inner-join","04-left-right-join","05-full-outer-join","06-cross-join","07-natural-join-using","08-self-join","09-join-3-tablas","10-join-condiciones-compuestas","11-anti-joins","12-mini-proyecto-pedidos")
$course4 = @("01-subconsultas-escalares-en-select","02-subconsultas-en-where-con","03-subconsultas-con-in-not-in","04-any-all-some","05-exists-not-exists","06-subconsultas-correlacionadas","07-derived-tables-from","08-union-union-all","09-intersect","10-except-minus","11-subconsultas-vs-joins-vs-ctes","12-mini-proyecto-reportes")
$course5 = @("01-create-database-table","02-alter-table","03-drop-truncate","04-primary-key-foreign-key","05-unique-not-null","06-check-default","07-insert-into","08-update","09-delete-vs-truncate-vs-drop","10-on-delete-cascade-set-null-restrict","11-constraints-combinados","12-mini-proyecto-disena-bd")
$course6 = @("01-tipos-numericos","02-tipos-de-texto","03-tipos-fecha-hora","04-boolean","05-coalesce-nullif","06-cast-y-conversion","07-1nf","08-2nf","09-3nf","10-desnormalizacion","11-serial-identity-uuid","12-proyecto-final-biblioteca")

$courses = @(
    @{num=1; mods=$course1; data=$c1_01,$c1_02,$c1_03,$c1_04,$c1_05,$c1_06,$c1_07,$c1_08,$c1_09,$c1_10,$c1_11,$c1_12; dir="curso-1-fundamentos"},
    @{num=2; mods=$course2; data=$c2_01,$c2_02,$c2_03,$c2_04,$c2_05,$c2_06,$c2_07,$c2_08,$c2_09,$c2_10,$c2_11,$c2_12; dir="curso-2-filtrado"},
    @{num=3; mods=$course3; data=$c3_01,$c3_02,$c3_03,$c3_04,$c3_05,$c3_06,$c3_07,$c3_08,$c3_09,$c3_10,$c3_11,$c3_12; dir="curso-3-joins"},
    @{num=4; mods=$course4; data=$c4_01,$c4_02,$c4_03,$c4_04,$c4_05,$c4_06,$c4_07,$c4_08,$c4_09,$c4_10,$c4_11,$c4_12; dir="curso-4-subconsultas"},
    @{num=5; mods=$course5; data=$c5_01,$c5_02,$c5_03,$c5_04,$c5_05,$c5_06,$c5_07,$c5_08,$c5_09,$c5_10,$c5_11,$c5_12; dir="curso-5-ddl-dml"},
    @{num=6; mods=$course6; data=$c6_01,$c6_02,$c6_03,$c6_04,$c6_05,$c6_06,$c6_07,$c6_08,$c6_09,$c6_10,$c6_11,$c6_12; dir="curso-6-diseno-datos"}
)

$total = 0
foreach($course in $courses) {
    for($i = 0; $i -lt $course.mods.Count; $i++) {
        $modNum = "{0:D2}" -f ($i + 1)
        $file = Join-Path $base "$($course.dir)\$($course.mods[$i]).html"
        if(Test-Path $file) {
            $d = $course.data[$i]
            AddSections -file $file -course $course.num -mod ($i+1) -color $d.color -rgb $d.rgb -obj $d.obj -panels $d.panels -step $d.step -summary $d.summary -style $d.style
            $total++
        }
    }
}

Write-Host "`n=== COMPLETED: $total files processed ===" -ForegroundColor Green
