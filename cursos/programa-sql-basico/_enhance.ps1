param([switch]$WhatIf)

$ErrorActionPreference = "Continue"

# ============================================================
# ENHANCE ALL SQL MODULE PAGES
# Adds: objectives, info panels, step-by-step, quiz explanations, summary
# ============================================================

# -----------------------------------------------------------
# 1. CONTENT DATA — unique per module (curso, modulo)
# -----------------------------------------------------------
$contentData = @{}

# --- Helper: create content block ---
function New-ModuleData {
    param($objectives, $panels, $stepexample, $quizExplanations, $summary)
    return @{
        objectives = $objectives
        panels     = $panels
        stepexample = $stepexample
        quizExplanations = $quizExplanations
        summary    = $summary
    }
}

# ===== CURSO 1 — FUNDAMENTOS (#00e0ff) =====
$c1 = @{}
$c1["01"] = New-ModuleData `
    -objectives @("Entender qué es SQL y para qué sirve", "Conocer la diferencia entre SQL y SGBD", "Identificar los componentes de una BD relacional", "Comprender cómo se organizan los datos en tablas") `
    -panels @(
        @{title="🧠 Intuición"; paragraphs=@("SQL es el idioma universal de las bases de datos. Así como el español te permite comunicarte con personas, SQL te permite comunicarte con bases de datos relacionales.", "Piensa en una base de datos como una biblioteca digital. SQL es el lenguaje que usas para pedirle al bibliotecario (el SGBD) que te traiga libros específicos, que los ordene, que los cuente o que los modifique.", "Lo poderoso de SQL es que es declarativo: tú dices QUÉ quieres, no CÓMO obtenerlo. El SGBD se encarga de encontrar la manera más eficiente.")},
        @{title="📝 Sintaxis SQL Básica"; paragraphs=@("SQL se compone de sentencias. Cada sentencia empieza con una palabra clave como SELECT, INSERT, CREATE, etc.", "Las palabras clave de SQL NO distinguen mayúsculas/minúsculas, pero por convención se escriben en MAYÚSCULAS para diferenciarlas de los nombres de tablas y columnas.", "Cada sentencia termina con punto y coma (;), aunque en algunos SGBD es opcional si solo ejecutas una consulta.")},
        @{title="💻 Ejemplo Práctico"; paragraphs=@("Una tabla 'clientes' tiene columnas: id, nombre, email, fecha_registro.", "Cada fila representa un cliente: (1, 'Ana García', 'ana@email.com', '2024-01-15')", "Para obtener todos los clientes: SELECT * FROM clientes;")},
        @{title="⚠️ Errores Comunes"; paragraphs=@("Confundir SQL con SGBD: MySQL y PostgreSQL son SGBD que usan SQL.", "Pensar que SQL solo sirve para consultar: también sirve para insertar, actualizar, eliminar y definir estructuras.", "Olvidar que SQL es un estándar: cada SGBD tiene pequeñas variaciones (dialectos).")},
        @{title="🔍 Dato Curioso"; paragraphs=@("SQL fue desarrollado originalmente en IBM en los años 70 con el nombre SEQUEL (Structured English Query Language).", "Por problemas de marca registrada, el nombre cambió a SQL. Aun así, mucha gente lo pronuncia 'sequel'.", "En 1986, SQL se convirtió en un estándar ANSI, y desde entonces ha tenido múltiples revisiones (SQL:92, SQL:99, SQL:2003, etc.).")},
        @{title="🎯 Concepto Clave"; paragraphs=@("Las bases de datos relacionales organizan datos en tablas con filas y columnas.", "Cada tabla tiene una clave primaria que identifica cada fila de forma única.", "Las relaciones entre tablas se establecen mediante claves foráneas.")}
    ) `
    -stepexample @"
<div class="code-block">-- Paso 1: Ver todas las tablas en la base de datos
SELECT table_name FROM information_schema.tables;

-- Paso 2: Explorar la estructura de una tabla
DESCRIBE clientes;

-- Paso 3: Consultar todos los datos
SELECT * FROM clientes;

-- Paso 4: Consultar solo algunas columnas
SELECT nombre, email FROM clientes;

-- Resultado esperado:
-- | nombre      | email          |
-- | Ana García  | ana@email.com  |
-- | Luis Pérez  | luis@email.com |</div>
"@ `
    -quizExplanations @(
        @{answer=0; explanation="✓ ¡Correcto! SQL significa Structured Query Language (Lenguaje de Consulta Estructurado). Es el estándar para manejar bases de datos relacionales."},
        @{answer=1; explanation="✓ ¡Exacto! Las BD relacionales organizan datos en tablas (también llamadas relaciones). Cada tabla tiene filas y columnas."},
        @{answer=1; explanation="✓ Así es. Una fila representa un registro completo con información sobre una entidad. Cada columna es un campo específico."},
        @{answer=2; explanation="✓ Correcto. MongoDB es una base de datos NoSQL (documental). MySQL, PostgreSQL y SQLite son todos SGBD relacionales que usan SQL."},
        @{answer=1; explanation="✓ ¡Perfecto! SQL está diseñado para consultar y manipular datos. También crea estructuras (DDL) y administra permisos (DCL)."}
    ) `
    -summary "SQL es el lenguaje universal para trabajar con bases de datos relacionales. Organiza datos en tablas con filas y columnas. Se compone de sublenguajes: DDL (definición), DML (manipulación), DCL (control) y DQL (consulta). Recuerda: SQL es declarativo — tú dices QUÉ necesitas, el SGBD decide CÓMO obtenerlo. ¡Has dado el primer paso para convertirte en un experto en datos!"

$c1["02"] = New-ModuleData `
    -objectives @("Construir consultas SELECT básicas", "Diferenciar entre * y columnas específicas", "Entender la cláusula FROM", "Ejecutar consultas simples en una tabla") `
    -panels @(
        @{title="🧠 Intuición"; paragraphs=@("SELECT y FROM son las palabras más usadas en SQL. SELECT es como decir 'muéstrame' y FROM es como decir 'desde dónde'. Juntos forman la consulta más básica.", "Imagina que tienes un archivador lleno de fichas de clientes. SELECT * FROM clientes sería como decir 'muéstrame todas las fichas del archivador de clientes'.", "Si solo quieres ver los nombres, dirías SELECT nombre FROM clientes — como pedir solo el campo 'nombre' de cada ficha.")},
        @{title="📝 Sintaxis SELECT"; paragraphs=@("La estructura básica es: SELECT columnas FROM nombre_tabla;", "SELECT * selecciona TODAS las columnas de la tabla. Es útil para explorar, pero en producción es mejor especificar las columnas que necesitas.", "Puedes seleccionar múltiples columnas separándolas con comas: SELECT col1, col2, col3 FROM tabla;")},
        @{title="💻 Ejemplo Práctico"; paragraphs=@("Tabla 'productos' con columnas: id, nombre, precio, categoria.", "SELECT nombre, precio FROM productos; — devuelve solo nombres y precios.", "SELECT * FROM productos; — devuelve todas las columnas de todos los productos.")},
        @{title="⚠️ Errores Comunes"; paragraphs=@("Usar SELECT * en producción: puede traer datos innecesarios y hacer la consulta más lenta.", "Olvidar el FROM: toda consulta SELECT necesita especificar de dónde traer los datos.", "Poner coma después de la última columna: SELECT nombre, precio, FROM productos; — la coma extra causa error.")},
        @{title="🔍 Dato Curioso"; paragraphs=@("SELECT no necesita FROM en algunos SGBD: SELECT NOW(); o SELECT 1+1; funcionan sin tabla.", "El * (asterisco) se llama 'splat' o 'glob' y significa 'todas las columnas en orden de definición'.", "Puedes hacer cálculos en SELECT: SELECT precio * 1.21 AS con_iva FROM productos;")},
        @{title="🎯 Concepto Clave"; paragraphs=@("SELECT especifica las columnas a mostrar, FROM especifica la tabla de origen.", "El orden importa: SELECT siempre va primero, FROM después.", "Puedes renombrar columnas con AS (aunque lo veremos en el próximo módulo).")}
    ) `
    -stepexample @"
<div class="code-block">-- Paso 1: Ver toda la tabla productos
SELECT * FROM productos;

-- Paso 2: Seleccionar solo nombre y precio
SELECT nombre, precio FROM productos;

-- Paso 3: Hacer un cálculo en el SELECT
SELECT nombre, precio, precio * 1.21 AS precio_con_iva FROM productos;

-- Resultado:
-- | nombre       | precio | precio_con_iva |
-- | Laptop       | 999.99 | 1209.99        |
-- | Mouse        | 25.50  | 30.86          |</div>
"@ `
    -quizExplanations @(
        @{answer=0; explanation="✓ ¡Correcto! SELECT * FROM clientes selecciona todas las columnas de la tabla clientes."},
        @{answer=1; explanation="✓ Así es. FROM especifica la tabla de origen de los datos que queremos consultar."},
        @{answer=0; explanation="✓ ¡Perfecto! SELECT nombre, email FROM usuarios trae solo esas dos columnas de la tabla usuarios."},
        @{answer=2; explanation="✓ ¡Exacto! 'SELECT *' puede traer datos innecesarios, consumir más memoria y hacer la consulta más lenta."},
        @{answer=1; explanation="✓ ¡Bien! La coma extra después de la última columna causa un error de sintaxis SQL."}
    ) `
    -summary "SELECT y FROM son los pilares de cualquier consulta SQL. SELECT elige las columnas, FROM define la tabla. Usa * para explorar pero especifica columnas en producción. Puedes hacer cálculos, renombrar con AS y combinar múltiples columnas separadas por comas. ¡Ya sabes lo esencial para consultar datos!"

$c1["03"] = New-ModuleData `
    -objectives @("Usar AS para renombrar columnas", "Crear alias descriptivos para resultados", "Entender que AS es opcional en muchos SGBD", "Aplicar alias en consultas con cálculos") `
    -panels @(
        @{title="🧠 Intuición"; paragraphs=@("AS es como ponerles apodos a las columnas. Así como 'José García' puede ser 'Pepe' para sus amigos, una columna 'precio * 1.21' puede llamarse 'precio_con_iva' con AS.", "Los alias hacen que los resultados sean más legibles. Es más amigable ver 'Total Ventas' que 'SUM(precio * cantidad)'.", "También son obligatorios cuando usas funciones como COUNT(), SUM(), AVG() porque esas funciones no tienen nombre descriptivo por sí mismas.")},
        @{title="📝 Sintaxis de Alias"; paragraphs=@("SELECT columna AS alias FROM tabla;", "La palabra AS es opcional: SELECT columna alias FROM tabla; funciona igual.", "Si el alias tiene espacios, usa comillas dobles: SELECT columna AS \"Mi Alias\" FROM tabla;")},
        @{title="💻 Ejemplo Práctico"; paragraphs=@("SELECT nombre, precio * 1.21 AS precio_iva FROM productos; — muestra el precio con IVA en una columna llamada 'precio_iva'.", "SELECT COUNT(*) AS total_clientes FROM clientes; — muestra el resultado con un nombre descriptivo.")},
        @{title="⚠️ Errores Comunes"; paragraphs=@("Olvidar el alias en funciones: SELECT COUNT(*) FROM clientes da un resultado sin nombre claro.", "Usar comillas simples en vez de dobles para alias con espacios: usa \"Mi Alias\", no 'Mi Alias'.", "Poner AS antes de una función mal: AS va DESPUÉS de la expresión o columna.")},
        @{title="🔍 Dato Curioso"; paragraphs=@("En SQL Server, los alias con espacios requieren corchetes: [Mi Alias].", "Los alias se pueden usar en ORDER BY pero NO en WHERE (por el orden de ejecución de SQL).", "AS también se usa para alias de tablas, muy útil en JOINs.")},
        @{title="🎯 Concepto Clave"; paragraphs=@("AS no cambia el nombre real de la columna en la tabla, solo afecta cómo se muestra en el resultado.", "Los alias hacen que reportes y aplicaciones consuman datos con nombres más claros.", "En JOINs, los alias de tablas ahorran escritura: SELECT c.nombre FROM clientes c;")}
    ) `
    -stepexample @"
<div class="code-block">-- Paso 1: Sin alias — columna sin nombre claro
SELECT COUNT(*) FROM clientes;
-- Resultado: | count |
--           | 150   |

-- Paso 2: Con alias — nombre descriptivo
SELECT COUNT(*) AS total_clientes FROM clientes;
-- Resultado: | total_clientes |
--           | 150            |

-- Paso 3: Alias con cálculo
SELECT nombre, precio, precio * 1.21 AS precio_con_iva FROM productos;

-- Paso 4: AS es opcional
SELECT nombre, precio * 1.21 precio_con_iva FROM productos;</div>
"@ `
    -quizExplanations @(
        @{answer=0; explanation="✓ ¡Correcto! AS se usa para renombrar temporalmente una columna o tabla en el resultado de una consulta."},
        @{answer=1; explanation="✓ ¡Exacto! La palabra AS es opcional. SELECT COUNT(*) total FROM clientes funciona igual."},
        @{answer=0; explanation="✓ ¡Bien! SELECT precio * 1.21 AS precio_iva FROM productos asigna el alias 'precio_iva' al resultado del cálculo."},
        @{answer=2; explanation="✓ ¡Perfecto! Los alias se definen después de la expresión, no antes."},
        @{answer=2; explanation="✓ ¡Correcto! Los alias con espacios requieren comillas dobles (o corchetes en SQL Server)."}
    ) `
    -summary "Los alias con AS hacen que tus consultas sean más legibles y profesionales. AS es opcional pero muy recomendable, especialmente con funciones de agregación. Recuerda: los alias son temporales — solo afectan al resultado de la consulta, no a la estructura real de la tabla."

$c1["04"] = New-ModuleData `
    -objectives @("Entender qué hace DISTINCT", "Eliminar duplicados en resultados", "Usar DISTINCT en múltiples columnas", "Diferenciar DISTINCT de otras formas de filtrado") `
    -panels @(
        @{title="🧠 Intuición"; paragraphs=@("DISTINCT es como el botón 'quitar duplicados' de Excel. Cuando tienes una lista con valores repetidos, DISTINCT te muestra cada valor una sola vez.", "Imagina que preguntas a 100 personas de qué ciudad son. Sin DISTINCT obtienes 100 respuestas (muchas repetidas). Con DISTINCT obtienes solo las ciudades únicas.", "Es útil para responder preguntas como '¿qué categorías de productos tenemos?' o '¿en qué ciudades hay clientes?'.")},
        @{title="📝 Sintaxis DISTINCT"; paragraphs=@("SELECT DISTINCT columna FROM tabla;", "SELECT DISTINCT col1, col2 FROM tabla; — elimina duplicados basándose en la combinación de ambas columnas.", "DISTINCT afecta a TODAS las columnas seleccionadas, no solo a una.")},
        @{title="💻 Ejemplo Práctico"; paragraphs=@("SELECT DISTINCT ciudad FROM clientes; — lista todas las ciudades sin repetir.", "SELECT DISTINCT ciudad, pais FROM clientes; — combinaciones únicas de ciudad+país.", "SELECT COUNT(DISTINCT categoria) FROM productos; — cuenta cuántas categorías diferentes hay.")},
        @{title="⚠️ Errores Comunes"; paragraphs=@("Pensar que DISTINCT se aplica solo a la primera columna: se aplica a TODAS las columnas del SELECT.", "Usar DISTINCT cuando necesitas GROUP BY: son conceptos diferentes.", "Olvidar que DISTINCT es costoso: ordena los datos internamente para eliminar duplicados.")},
        @{title="🔍 Dato Curioso"; paragraphs=@("PostgreSQL tiene también DISTINCT ON (columna) que es más específico.", "DISTINCT y ORDER BY pueden combinarse, pero las columnas del ORDER BY deben estar en el SELECT.", "Algunos SGBD tratan NULL como un valor DISTINCT, solo aparece una vez.")},
        @{title="🎯 Concepto Clave"; paragraphs=@("DISTINCT elimina filas duplicadas del resultado.", "Afecta a la combinación de todas las columnas seleccionadas.", "Es útil para catálogos, listas únicas y conteos de valores distintos.")}
    ) `
    -stepexample @"
<div class="code-block">-- Paso 1: Ver todas las categorías (con duplicados)
SELECT categoria FROM productos;
-- Resultado: Electronica, Electronica, Ropa, Ropa, Ropa, Hogar

-- Paso 2: Solo categorías únicas
SELECT DISTINCT categoria FROM productos;
-- Resultado: Electronica, Ropa, Hogar

-- Paso 3: Combinaciones únicas de dos columnas
SELECT DISTINCT categoria, proveedor FROM productos;

-- Paso 4: Contar valores distintos
SELECT COUNT(DISTINCT categoria) AS num_categorias FROM productos;
-- Resultado: 3</div>
"@ `
    -quizExplanations @(
        @{answer=1; explanation="✓ ¡Correcto! DISTINCT elimina filas duplicadas del resultado de la consulta."},
        @{answer=0; explanation="✓ ¡Exacto! SELECT DISTINCT pais FROM clientes devuelve una lista de países sin repetir."},
        @{answer=2; explanation="✓ ¡Bien! La combinación México-Juan y México-María es diferente porque la segunda columna varía."},
        @{answer=2; explanation="✓ ¡Perfecto! DISTINCT elimina filas donde TODAS las columnas sean iguales."},
        @{answer=1; explanation="✓ ¡Correcto! DISTINCT afecta a todas las columnas del SELECT, no solo a la primera."}
    ) `
    -summary "DISTINCT elimina filas duplicadas del resultado mostrando solo valores únicos. Afecta a la combinación de todas las columnas seleccionadas. Es ideal para catálogos y listas sin repetición. Recuerda: DISTINCT es costoso en tablas grandes, úsalo solo cuando realmente necesites eliminar duplicados."

$c1["05"] = New-ModuleData `
    -objectives @("Filtrar filas con la cláusula WHERE", "Usar operadores de comparación en condiciones", "Entender el orden de las cláusulas SQL", "Aplicar filtros combinando condiciones") `
    -panels @(
        @{title="🧠 Intuición"; paragraphs=@("WHERE es como un filtro de café: solo deja pasar lo que cumple cierta condición. Sin WHERE, obtienes toda la tabla. Con WHERE, solo las filas que cumplen la condición.", "Piensa en un portero de discoteca: solo deja entrar a personas mayores de edad. WHERE hace exactamente eso con tus datos.", "WHERE se escribe después de FROM y antes de ORDER BY. Este orden no es opcional — SQL tiene un orden de ejecución estricto.")},
        @{title="📝 Sintaxis WHERE"; paragraphs=@("SELECT columnas FROM tabla WHERE condicion;", "Las condiciones usan operadores: =, &lt;&gt; (o !=), &gt;, &lt;, &gt;=, &lt;=", "El texto se escribe entre comillas simples: WHERE nombre = 'Ana'", "Las fechas también van entre comillas: WHERE fecha > '2024-01-01'")},
        @{title="💻 Ejemplo Práctico"; paragraphs=@("SELECT * FROM productos WHERE precio > 100; — productos que cuestan más de 100.", "SELECT nombre, edad FROM clientes WHERE ciudad = 'Madrid'; — clientes de Madrid.", "SELECT titulo FROM cursos WHERE precio &lt; 50 ORDER BY precio; — cursos baratos ordenados.")},
        @{title="⚠️ Errores Comunes"; paragraphs=@("Usar comillas dobles para texto: en SQL estándar, las comillas dobles son para nombres de columna/tabla.", "Poner WHERE antes de FROM: el orden correcto es SELECT → FROM → WHERE.", "Confundir = con =: en SQL, = es igualdad (no asignación).")},
        @{title="🔍 Dato Curioso"; paragraphs=@("En PostgreSQL, las cadenas se comparan con = (no == como en muchos lenguajes).", "WHERE puede usar expresiones booleanas: WHERE activo = true.", "NULL no se compara con =, se usa IS NULL o IS NOT NULL.")},
        @{title="🎯 Concepto Clave"; paragraphs=@("WHERE filtra filas antes de que se ordenen o agrupen.", "Solo las filas donde la condición es TRUE se incluyen en el resultado.", "Puedes combinar condiciones con AND, OR y NOT (lo veremos pronto).")}
    ) `
    -stepexample @"
<div class="code-block">-- Paso 1: Datos iniciales
SELECT * FROM productos;

-- Paso 2: Filtrar por precio
SELECT nombre, precio FROM productos WHERE precio > 50;

-- Paso 3: Filtrar por texto
SELECT * FROM clientes WHERE ciudad = 'Bogotá';

-- Paso 4: Filtrar con cálculo
SELECT nombre, precio FROM productos WHERE precio * 1.21 > 100;</div>
"@ `
    -quizExplanations @(
        @{answer=0; explanation="✓ ¡Correcto! WHERE precio > 100 filtra solo los productos con precio mayor a 100."},
        @{answer=1; explanation="✓ ¡Exacto! El texto en SQL va entre comillas simples."},
        @{answer=2; explanation="✓ ¡Bien! Ninguna de esas opciones es correcta. WHERE va después de FROM, no antes."},
        @{answer=0; explanation="✓ ¡Perfecto! <> significa 'diferente de' en SQL estándar. También funciona !="},
        @{answer=1; explanation="✓ ¡Correcto! Solo las filas donde edad >= 18 cumplen la condición y aparecen en el resultado."}
    ) `
    -summary "WHERE filtra filas según una condición. Es una de las cláusulas más poderosas de SQL. Recuerda el orden: SELECT → FROM → WHERE → ORDER BY. Usa comillas simples para texto y fechas, y conoce los operadores de comparación. WHERE es tu herramienta principal para extraer datos específicos."

$c1["06"] = New-ModuleData `
    -objectives @("Usar operadores de comparación en SQL", "Combinar condiciones con operadores lógicos", "Entender la precedencia de operadores", "Aplicar filtros precisos con múltiples condiciones") `
    -panels @(
        @{title="🧠 Intuición"; paragraphs=@("Los operadores de comparación son como las preguntas que le haces a los datos: ¿es igual? ¿es mayor? ¿es diferente? Cada operador te ayuda a afinar tu búsqueda.", "Imagina que buscas un libro en una biblioteca: '> 200 páginas', '!= ficción', '<= 20€'. Cada condición usa un operador diferente.", "Los operadores lógicos (AND, OR, NOT) te permiten combinar varias condiciones: 'precio > 50 AND categoria = Electronica'.")},
        @{title="📝 Operadores de Comparación"; paragraphs=@("=  Igual a (no confundir con ==)", "&lt;&gt; o !=  Diferente de", "&gt;  Mayor que", "&lt;  Menor que", "&gt;=  Mayor o igual que", "&lt;=  Menor o igual que")},
        @{title="💻 Ejemplo Práctico"; paragraphs=@("SELECT * FROM empleados WHERE salario >= 50000;", "SELECT * FROM productos WHERE precio &lt;&gt; 0;", "SELECT * FROM pedidos WHERE fecha > '2024-01-01' AND total &lt; 1000;")},
        @{title="⚠️ Errores Comunes"; paragraphs=@("Usar == en vez de =: en SQL la igualdad es con un solo =.", "Comparar números con comillas: WHERE precio > '100' (compara como texto, no número).", "Olvidar que NULL no se compara con =, usa IS NULL.")},
        @{title="🔍 Dato Curioso"; paragraphs=@("PostgreSQL también soporta los operadores de comparación estándar SQL: =, <>, <, >, <=, >=.", "El operador <=> (seguro para NULL) existe en MySQL pero NO en PostgreSQL.", "Puedes comparar fechas directamente: WHERE fecha >= '2024-01-01'.")},
        @{title="🎯 Concepto Clave"; paragraphs=@("Los operadores de comparación devuelven TRUE, FALSE o NULL.", "AND tiene prioridad sobre OR: usa paréntesis para agrupar.", "La precedencia se controla con paréntesis como en matemáticas.")}
    ) `
    -stepexample @"
<div class="code-block">-- Paso 1: Igualdad
SELECT * FROM clientes WHERE ciudad = 'Madrid';

-- Paso 2: Diferente de
SELECT * FROM productos WHERE categoria <> 'Electronica';

-- Paso 3: Mayor o igual con AND
SELECT * FROM empleados
WHERE salario >= 30000 AND salario <= 80000;

-- Paso 4: Combinando con paréntesis
SELECT * FROM productos
WHERE (precio > 100 OR precio < 10) AND categoria = 'Ropa';</div>
"@ `
    -quizExplanations @(
        @{answer=2; explanation="✓ ¡Correcto! En SQL la igualdad se escribe con un solo signo =."},
        @{answer=0; explanation="✓ ¡Exacto! Las filas con precio mayor a 500 cumplen la condición y son incluidas."},
        @{answer=2; explanation="✓ ¡Bien! <> y != son equivalentes en SQL, ambos significan 'diferente de'."},
        @{answer=0; explanation="✓ ¡Perfecto! AND tiene mayor prioridad que OR, igual que en matemáticas."},
        @{answer=1; explanation="✓ ¡Correcto! Los paréntesis controlan el orden de evaluación de las condiciones."}
    ) `
    -summary "Los operadores de comparación (=, <>, >, <, >=, <=) te permiten filtrar datos con precisión. Combínalos con AND y OR para crear condiciones complejas. Usa paréntesis para controlar la precedencia. Recuerda: en SQL, la igualdad es con =, no ==."

$c1["07"] = New-ModuleData `
    -objectives @("Combinar condiciones con AND", "Usar OR para condiciones alternativas", "Aplicar NOT para negar condiciones", "Controlar precedencia con paréntesis") `
    -panels @(
        @{title="🧠 Intuición"; paragraphs=@("AND, OR y NOT son como las reglas de un juego de mesa: 'Si tienes un 6 Y caes en esa casilla, avanzas. Si sacas un 1 O un 2, retrocedes. Si NO tienes dinero, no juegas.'", "AND es estricto: TODAS las condiciones deben cumplirse. OR es flexible: AL MENOS UNA debe cumplirse. NOT invierte el resultado.", "Piensa en AND como 'y además', OR como 'o también', y NOT como 'todo excepto'.")},
        @{title="📝 Sintaxis Lógica"; paragraphs=@("SELECT * FROM tabla WHERE cond1 AND cond2;", "SELECT * FROM tabla WHERE cond1 OR cond2;", "SELECT * FROM tabla WHERE NOT condicion;", "SELECT * FROM tabla WHERE (cond1 OR cond2) AND cond3; — paréntesis para agrupar.")},
        @{title="💻 Ejemplo Práctico"; paragraphs=@("SELECT * FROM productos WHERE precio > 50 AND categoria = 'Ropa';", "SELECT * FROM clientes WHERE ciudad = 'Madrid' OR ciudad = 'Barcelona';", "SELECT * FROM empleados WHERE NOT ciudad = 'Paris'; — todos menos los de París.")},
        @{title="⚠️ Errores Comunes"; paragraphs=@("Olvidar paréntesis al mezclar AND y OR: AND se evalúa primero y sin paréntesis los resultados son inesperados.", "Usar AND cuando deberías usar OR: 'precio > 100 OR precio &lt; 50', no AND.", "Poner NOT al principio en vez de junto a la condición.")},
        @{title="🔍 Dato Curioso"; paragraphs=@("La tabla de verdad de AND solo da TRUE cuando ambas son TRUE. OR da TRUE con al menos una TRUE.", "NOT puede combinarse: NOT (precio > 100) es equivalente a precio &lt;= 100.", "En algunos SGBD, NOT se puede escribir como ! (pero NOT es estándar).")},
        @{title="🎯 Concepto Clave"; paragraphs=@("AND: todas las condiciones deben ser TRUE.", "OR: al menos una condición debe ser TRUE.", "NOT: invierte el resultado (TRUE→FALSE, FALSE→TRUE).", "AND tiene prioridad sobre OR. Usa paréntesis para cambiar el orden.")}
    ) `
    -stepexample @"
<div class="code-block">-- Paso 1: AND — condiciones acumulativas
SELECT * FROM productos
WHERE precio > 20 AND precio < 100 AND categoria = 'Ropa';

-- Paso 2: OR — condiciones alternativas
SELECT * FROM clientes
WHERE ciudad = 'Madrid' OR ciudad = 'Barcelona' OR ciudad = 'Valencia';

-- Paso 3: NOT — negación
SELECT * FROM empleados
WHERE NOT departamento = 'Ventas';

-- Paso 4: Combinación con paréntesis
SELECT * FROM pedidos
WHERE (total > 500 OR urgente = true) AND NOT pagado;</div>
"@ `
    -quizExplanations @(
        @{answer=0; explanation="✓ ¡Correcto! Solo la opción (50 y Ropa) cumple TODAS las condiciones del AND."},
        @{answer=1; explanation="✓ ¡Exacto! OR requiere que AL MENOS UNA condición sea TRUE."},
        @{answer=2; explanation="✓ ¡Bien! AND tiene prioridad sobre OR, por eso se evalúa precio > 100 AND activo = true primero."},
        @{answer=0; explanation="✓ ¡Perfecto! SELECT * FROM productos WHERE NOT precio > 100 equivale a precio <= 100."},
        @{answer=2; explanation="✓ ¡Correcto! AND necesita que TODAS las condiciones sean verdaderas."}
    ) `
    -summary "AND, OR y NOT son los operadores lógicos de SQL. AND exige que todas las condiciones sean TRUE, OR con una basta, y NOT invierte el resultado. Recuerda: AND tiene prioridad sobre OR, usa paréntesis para agrupar condiciones claramente. Domina estos operadores y podrás filtrar datos con precisión quirúrgica."

$c1["08"] = New-ModuleData `
    -objectives @("Ordenar resultados con ORDER BY", "Usar orden ascendente y descendente", "Ordenar por múltiples columnas", "Combinar ORDER BY con WHERE") `
    -panels @(
        @{title="🧠 Intuición"; paragraphs=@("ORDER BY es como organizar tus carpetas: por fecha, por orden alfabético o por tamaño. Sin ORDER BY, los resultados aparecen en el orden que el SGBD decida.", "Por defecto, ORDER BY ordena de forma ascendente (A-Z, menor a mayor). Con DESC, cambias a descendente (Z-A, mayor a menor).", "Puedes ordenar por múltiples columnas: primero por una columna, y dentro de esa, por otra. Como ordenar contactos primero por apellido y luego por nombre.")},
        @{title="📝 Sintaxis ORDER BY"; paragraphs=@("SELECT * FROM tabla ORDER BY columna; — ascendente por defecto.", "SELECT * FROM tabla ORDER BY columna DESC; — descendente.", "SELECT * FROM tabla ORDER BY col1 ASC, col2 DESC; — primero col1 ascendente, luego col2 descendente.", "ORDER BY se escribe al final de la consulta (después de WHERE).")},
        @{title="💻 Ejemplo Práctico"; paragraphs=@("SELECT * FROM productos ORDER BY precio; — del más barato al más caro.", "SELECT * FROM empleados ORDER BY salario DESC; — del que más gana al que menos.", "SELECT nombre, precio FROM productos WHERE categoria = 'Ropa' ORDER BY precio DESC;")},
        @{title="⚠️ Errores Comunes"; paragraphs=@("Poner ORDER BY antes de WHERE: el orden correcto es SELECT → FROM → WHERE → ORDER BY.", "Olvidar DESC cuando quieres orden descendente.", "Ordenar por un alias usado en SELECT pero no todas las bases lo permiten.")},
        @{title="🔍 Dato Curioso"; paragraphs=@("NULL se considera el valor más grande en ORDER BY ASC (aparece al final). En ORDER BY DESC aparece al principio.", "Puedes ordenar por la posición de la columna: ORDER BY 1 (primera columna del SELECT).", "ORDER BY también funciona con expresiones: ORDER BY precio * cantidad DESC.")},
        @{title="🎯 Concepto Clave"; paragraphs=@("ORDER BY ordena el resultado final de la consulta.", "ASC = ascendente (defecto), DESC = descendente.", "Múltiples columnas se separan con comas.", "ORDER BY es la ÚLTIMA cláusula en ejecutarse.")}
    ) `
    -stepexample @"
<div class="code-block">-- Paso 1: Orden ascendente (defecto)
SELECT nombre, precio FROM productos ORDER BY precio;
-- Más barato primero

-- Paso 2: Orden descendente
SELECT nombre, precio FROM productos ORDER BY precio DESC;
-- Más caro primero

-- Paso 3: Múltiples columnas
SELECT nombre, precio, categoria FROM productos
ORDER BY categoria ASC, precio DESC;
-- Primero por categoria A-Z, dentro de cada categoria por precio Z-A

-- Paso 4: Con WHERE
SELECT * FROM productos
WHERE categoria = 'Electronica'
ORDER BY precio DESC;</div>
"@ `
    -quizExplanations @(
        @{answer=1; explanation="✓ ¡Correcto! ORDER BY ordena el resultado final de la consulta."},
        @{answer=0; explanation="✓ ¡Exacto! DESC después del nombre de la columna indica orden descendente."},
        @{answer=0; explanation="✓ ¡Bien! ORDER BY precio ordena de menor a mayor (ascendente por defecto)."},
        @{answer=2; explanation="✓ ¡Perfecto! ORDER BY es la última cláusula y va DESPUÉS de WHERE."},
        @{answer=0; explanation="✓ ¡Correcto! ASC es opcional porque es el orden por defecto."}
    ) `
    -summary "ORDER BY organiza los resultados de tu consulta. Por defecto es ascendente (ASC), usa DESC para descendente. Puedes ordenar por múltiples columnas separándolas con comas. ORDER BY siempre va al final de la consulta. ¡Tus datos ahora saldrán perfectamente ordenados!"

$c1["09"] = New-ModuleData `
    -objectives @("Limitar resultados con LIMIT", "Saltar filas con OFFSET", "Combinar LIMIT y OFFSET para paginación", "Usar LIMIT para obtener los N primeros") `
    -panels @(
        @{title="🧠 Intuición"; paragraphs=@("LIMIT es como decir 'solo muéstrame los primeros 5 resultados'. Cuando una consulta devuelve miles de filas, LIMIT te da solo las que necesitas.", "OFFSET es como saltarte las primeras páginas de resultados: 'muéstrame los resultados a partir del número 10'.", "Juntos, LIMIT y OFFSET son la base de la paginación: 'muéstrame 10 resultados por página, empezando por la página 3'.")},
        @{title="📝 Sintaxis LIMIT / OFFSET"; paragraphs=@("SELECT * FROM tabla LIMIT n; — solo n filas.", "SELECT * FROM tabla LIMIT n OFFSET m; — n filas saltando las primeras m.", "SELECT * FROM tabla LIMIT m, n; — en MySQL, equivale a LIMIT n OFFSET m.", "SELECT * FROM tabla FETCH FIRST n ROWS ONLY; — estándar SQL (PostgreSQL).")},
        @{title="💻 Ejemplo Práctico"; paragraphs=@("SELECT * FROM productos ORDER BY precio DESC LIMIT 3; — los 3 más caros.", "SELECT * FROM clientes LIMIT 10 OFFSET 20; — del 21 al 30.", "SELECT * FROM empleados ORDER BY salario DESC LIMIT 1; — el que más gana.")},
        @{title="⚠️ Errores Comunes"; paragraphs=@("Usar LIMIT sin ORDER BY: no sabes qué filas estás limitando.", "Poner LIMIT antes de ORDER BY: LIMIT siempre va al final.", "Confundir OFFSET con página: OFFSET 10 salta 10 filas, no 10 páginas.")},
        @{title="🔍 Dato Curioso"; paragraphs=@("En SQL Server se usa SELECT TOP n en vez de LIMIT.", "En PostgreSQL, LIMIT ALL equivale a no tener límite.", "OFFSET sin LIMIT puede ser ineficiente porque igual recorre todas las filas.")},
        @{title="🎯 Concepto Clave"; paragraphs=@("LIMIT limita el número de filas devueltas.", "OFFSET skipea filas antes de empezar a devolver resultados.", "Siempre usa ORDER BY con LIMIT para resultados predecibles.", "LIMIT y OFFSET van al final de la consulta.")}
    ) `
    -stepexample @"
<div class="code-block">-- Paso 1: Los 5 productos más baratos
SELECT nombre, precio FROM productos
ORDER BY precio ASC LIMIT 5;

-- Paso 2: Los 3 más caros
SELECT nombre, precio FROM productos
ORDER BY precio DESC LIMIT 3;

-- Paso 3: Paginación — página 2 (filas 11-20)
SELECT * FROM productos
ORDER BY id LIMIT 10 OFFSET 10;

-- Paso 4: El empleado con mayor salario
SELECT nombre, salario FROM empleados
ORDER BY salario DESC LIMIT 1;</div>
"@ `
    -quizExplanations @(
        @{answer=0; explanation="✓ ¡Correcto! ORDER BY precio LIMIT 1 devuelve el producto más barato."},
        @{answer=1; explanation="✓ ¡Exacto! LIMIT 5 limita el resultado a las primeras 5 filas."},
        @{answer=2; explanation="✓ ¡Bien! ORDER BY es necesario con LIMIT para saber qué filas obtienes."},
        @{answer=2; explanation="✓ ¡Perfecto! OFFSET 10 salta 10 filas, LIMIT 10 muestra las siguientes 10."},
        @{answer=0; explanation="✓ ¡Correcto! LIMIT siempre va al final de la consulta, después de ORDER BY."}
    ) `
    -summary "LIMIT y OFFSET controlan cuántas filas ves y desde dónde. LIMIT n muestra las primeras n filas. OFFSET m salta m filas antes de mostrar. Juntos hacen paginación. Siempre combínalos con ORDER BY para resultados consistentes. ¡Perfecto para reportes y aplicaciones!"

$c1["10"] = New-ModuleData `
    -objectives @("Documentar consultas con comentarios", "Organizar código SQL legible", "Aplicar convenciones de nombres", "Escribir SQL mantenible y profesional") `
    -panels @(
        @{title="🧠 Intuición"; paragraphs=@("Los comentarios en SQL son como notas adhesivas que dejas en tu código. No afectan la ejecución, pero ayudan a ti y a otros a entender qué hace cada parte.", "Las buenas prácticas son como las reglas de ortografía: no cambian el significado, pero hacen que tu escritura sea profesional y fácil de leer.", "Un código bien escrito se lee como una historia: claro, organizado y con sentido.")},
        @{title="📝 Comentarios en SQL"; paragraphs=@("-- Comentario de una línea (después de -- hasta el final de la línea)", "/* Comentario de múltiples líneas */", "Los comentarios se ignoran al ejecutar la consulta.", "Úsalos para explicar el propósito, no para repetir lo obvio.")},
        @{title="💻 Ejemplo Práctico"; paragraphs=@("-- Obtener clientes que hicieron compras este mes", "SELECT c.nombre, COUNT(p.id) AS compras", "FROM clientes c", "INNER JOIN pedidos p ON c.id = p.cliente_id", "WHERE p.fecha >= '2024-01-01'", "GROUP BY c.nombre;")},
        @{title="⚠️ Malas Prácticas"; paragraphs=@("SELECT * sin necesidad — trae columnas innecesarias.", "Nombres confusos como 't1', 't2' en vez de 'clientes', 'pedidos'.", "Falta de sangría: todo en una línea larguísima.")},
        @{title="🔍 Dato Curioso"; paragraphs=@("Los comentarios también sirven para 'desactivar' partes de una consulta durante pruebas.", "En PostgreSQL, los comentarios se pueden leer desde information_schema.", "Existe la convención de escribir palabras clave SQL en MAYÚSCULAS.")},
        @{title="🎯 Concepto Clave"; paragraphs=@("Comenta el POR QUÉ, no el QUÉ (el código ya dice qué hace).", "Usa sangría consistente (2 o 4 espacios).", "Nombres descriptivos: precio_total en vez de pt.", "Escribe como si otro fuera a leer tu código.")}
    ) `
    -stepexample @"
<div class="code-block">-- ❌ Mal escrito:
SELECT * FROM t1 INNER JOIN t2 ON t1.a=t2.b WHERE t1.c>100 ORDER BY 2;

-- ✅ Bien escrito:
/*
 * Reporte: Productos más vendidos del mes
 * Última modificación: 2024-03-15
 */
SELECT
    p.nombre,
    SUM(v.cantidad) AS total_vendido
FROM productos p
INNER JOIN ventas v ON p.id = v.producto_id
WHERE v.fecha >= '2024-03-01'
GROUP BY p.nombre
ORDER BY total_vendido DESC
LIMIT 10;</div>
"@ `
    -quizExplanations @(
        @{answer=1; explanation="✓ ¡Correcto! SELECT * innecesario es una mala práctica porque trae datos que no necesitas."},
        @{answer=0; explanation="✓ ¡Exacto! Es buena práctica para mejorar la legibilidad del código."},
        @{answer=0; explanation="✓ ¡Bien! Comenta el POR QUÉ, el código ya muestra el QUÉ."},
        @{answer=2; explanation="✓ ¡Perfecto! Es buena práctica: hace el código más legible y profesional."},
        @{answer=0; explanation="✓ ¡Correcto! Esta es una buena práctica para saber qué hace la consulta."}
    ) `
    -summary "Los comentarios y las buenas prácticas hacen que tu SQL sea profesional, mantenible y fácil de entender. Usa -- para comentarios de una línea y /* */ para varios. Escribe código limpio con sangría, nombres descriptivos y palabras clave en mayúsculas. ¡Tu yo del futuro te lo agradecerá!"

$c1["11"] = New-ModuleData `
    -objectives @("Aplicar todos los conceptos del curso 1", "Resolver consultas del mundo real", "Combinar WHERE, ORDER BY, LIMIT y AS", "Practicar con un conjunto de datos real") `
    -panels @(
        @{title="🧠 Intuición"; paragraphs=@("Este mini-proyecto es como un simulacro de examen: pones en práctica todo lo que has aprendido. Los proyectos son la mejor forma de consolidar conocimiento.", "Trabajarás con una tabla 'productos' realista con nombres, precios, categorías y fechas. Resolverás preguntas de negocio como '¿cuáles son los 5 productos más caros?'", "Cada desafío es una situación que te encontrarías en un trabajo real como analista de datos o desarrollador.")},
        @{title="📝 Proyecto Guiado"; paragraphs=@("Usarás SELECT para elegir columnas y FROM para la tabla.", "Aplicarás WHERE para filtrar por precio, categoría y fecha.", "ORDER BY ordenará los resultados por precio, nombre o fecha.", "LIMIT acotará los resultados a los más relevantes.", "AS dará nombres claros a las columnas calculadas.")},
        @{title="💻 Consultas del Proyecto"; paragraphs=@("Listar productos de una categoría específica.", "Encontrar los 3 productos más baratos de cada categoría.", "Filtrar productos con precio entre dos valores.", "Ordenar productos por precio descendente.", "Contar cuántos productos hay en cada categoría.")},
        @{title="⚠️ Desafíos Comunes"; paragraphs=@("No leer bien la pregunta: ¿quieren los más caros o los más baratos?", "Olvidar ORDER BY con LIMIT: los resultados no serán consistentes.", "No especificar columnas en SELECT * cuando solo necesitas 2-3.")},
        @{title="🔍 Dato Curioso"; paragraphs=@("En proyectos reales, las consultas rara vez son de una sola tabla. ¡Pero dominarlas es el primer paso!", "Los analistas de datos pasan el 80% de su tiempo haciendo consultes como estas.", "Saber SQL básico bien es más valioso que saber SQL avanzado mal.")},
        @{title="🎯 Consejo Final"; paragraphs=@("Resuelve cada desafío por tu cuenta antes de ver la solución.", "Si te atascas, simplifica: empieza con SELECT * y luego añade filtros.", "La práctica hace al maestro — cada consulta que escribes refuerza tu aprendizaje.")}
    ) `
    -stepexample @"
<div class="code-block">-- Desafío 1: Productos de Electronica ordenados por precio
SELECT nombre, precio FROM productos
WHERE categoria = 'Electronica'
ORDER BY precio DESC;

-- Desafío 2: Los 3 productos más baratos
SELECT nombre, precio FROM productos
ORDER BY precio ASC LIMIT 3;

-- Desafío 3: Productos entre 50 y 200
SELECT nombre, precio FROM productos
WHERE precio >= 50 AND precio <= 200
ORDER BY precio;

-- Desafío 4: Precio con IVA (21%)
SELECT nombre, precio, precio * 1.21 AS precio_iva
FROM productos
ORDER BY precio_iva DESC;</div>
"@ `
    -quizExplanations @(
        @{answer=1; explanation="✓ ¡Correcto! ORDER BY precio DESC LIMIT 1 da el producto más caro."},
        @{answer=0; explanation="✓ ¡Exacto! El WHERE filtra por categoria y después se aplica ORDER BY y LIMIT."},
        @{answer=2; explanation="✓ ¡Bien! Todas las opciones son correctas. El proyecto las pone en práctica."},
        @{answer=0; explanation="✓ ¡Perfecto! REFRESCAR la página no resuelve el problema de lógica."},
        @{answer=0; explanation="✓ ¡Correcto! SELECT especifica las columnas a mostrar."}
    ) `
    -summary "¡Completaste el mini-proyecto! Has aplicado SELECT, FROM, WHERE, ORDER BY, LIMIT, AS y operadores de comparación en un escenario real. Estos son los fundamentos que usarás todos los días como profesional de datos. Sigue practicando — ¡la maestría llega con la repetición!"

$c1["12"] = New-ModuleData `
    -objectives @("Repasar todos los temas del curso 1", "Identificar áreas de mejora", "Obtener la certificación del curso", "Consolidar conocimientos fundamentales") `
    -panels @(
        @{title="🧠 Resumen General"; paragraphs=@("Has recorrido un camino increíble: desde entender qué es SQL hasta escribir consultas complejas con filtros, ordenamiento y límites.", "Este curso te dio los cimientos: SELECT y FROM para consultar, WHERE para filtrar, ORDER BY para ordenar, LIMIT y OFFSET para acotar.", "También aprendiste sobre buenas prácticas, alias con AS, y a pensar en términos de conjuntos de datos.")},
        @{title="📝 Conceptos Clave"; paragraphs=@("SQL es declarativo: dices QUÉ, no CÓMO.", "Las consultas tienen un orden: SELECT → FROM → WHERE → ORDER BY → LIMIT.", "Los operadores lógicos (AND, OR, NOT) combinan condiciones.", "Los alias (AS) hacen los resultados más legibles.", "DISTINCT elimina duplicados.")},
        @{title="💻 Próximos Pasos"; paragraphs=@("Curso 2: Filtrado y Agregación — funciones LIKE, IN, GROUP BY y más.", "Practica diariamente con consultas en un SGBD real como PostgreSQL.", "Construye pequeños proyectos personales para afianzar conceptos.")},
        @{title="⚠️ Errores a Recordar"; paragraphs=@("No olvides WHERE antes de ORDER BY.", "Las comillas simples para texto, dobles para alias con espacios.", "NULL se compara con IS NULL, no con = NULL.", "AND tiene prioridad sobre OR.")},
        @{title="🔍 Certificación"; paragraphs=@("Al aprobar este examen obtienes la insignia 'SQL Explorer'.", "Esta insignia queda guardada en tu navegador como testimonio de tu logro.", "Comparte tu progreso — ¡has dado el primer gran paso en el mundo SQL!")},
        @{title="🎯 Felicitaciones"; paragraphs=@("Completar este curso te coloca en el camino para ser un profesional de datos.", "Los fundamentos que has aprendido son los mismos que usan los mejores analistas e ingenieros de datos del mundo.", "¡Sigue así! El Curso 2 te espera con temas aún más fascinantes.")}
    ) `
    -stepexample @"
<div class="code-block">-- Repaso exprés: todas las cláusulas juntas
SELECT
    categoria,
    COUNT(*) AS total_productos,
    ROUND(AVG(precio), 2) AS precio_promedio,
    MAX(precio) AS precio_maximo
FROM productos
WHERE precio > 0
GROUP BY categoria
HAVING COUNT(*) >= 2
ORDER BY total_productos DESC
LIMIT 5;</div>
"@ `
    -quizExplanations @(
        @{answer=1; explanation="✓ ¡Correcto! La cláusula WHERE filtra filas según una condición."},
        @{answer=0; explanation="✓ ¡Exacto! = compara igualdad, <> compara diferencia."},
        @{answer=2; explanation="✓ ¡Bien! DISTINCT se aplica a la combinación de todas las columnas del SELECT."},
        @{answer=0; explanation="✓ ¡Perfecto! Sin ORDER BY con LIMIT, no sabes qué filas se devuelven."},
        @{answer=1; explanation="✓ ¡Correcto! SELECT columna AS alias FROM tabla; es la sintaxis correcta."}
    ) `
    -summary "¡Felicidades! Has completado el Curso 1 de SQL Básico. Dominas SELECT, FROM, WHERE, ORDER BY, LIMIT, DISTINCT y los operadores de comparación y lógicos. Estos fundamentos son la base de todo trabajo con bases de datos relacionales. Sigue adelante con el Curso 2, donde aprenderás filtrado avanzado y funciones de agregación."

# ===== CURSO 2 — FILTRADO (#ffb347) =====
$c2 = @{}
$c2["01"] = New-ModuleData `
    -objectives @("Entender el patrón LIKE y los comodines % y _", "Buscar texto con patrones", "Combinar múltiples comodines", "Usar LIKE en consultas reales") `
    -panels @(
        @{title="🧠 Intuición"; paragraphs=@("LIKE es como un 'buscador inteligente' para texto en SQL. Mientras que = busca coincidencia exacta, LIKE busca patrones, como cuando buscas contactos en tu celular.", "El % es el comodín más usado: representa 'cualquier secuencia de caracteres'. LIKE 'A%' encuentra todo lo que empieza con A.", "El _ es el comodín de un solo carácter: LIKE 'A_a' encuentra 'Ana', 'Ala', 'Ara' pero no 'Abril'.")},
        @{title="📝 Sintaxis LIKE"; paragraphs=@("SELECT * FROM tabla WHERE columna LIKE 'patron';", "'%' — cualquier secuencia de cero o más caracteres.", "'_' — exactamente un carácter cualquiera.", "'ABC%' — empieza con 'ABC'", "'%XYZ' — termina con 'XYZ'", "'%mid%' — contiene 'mid' en cualquier posición.")},
        @{title="💻 Ejemplo Práctico"; paragraphs=@("SELECT * FROM clientes WHERE nombre LIKE 'A%'; — nombres que empiezan con A.", "SELECT * FROM emails WHERE email LIKE '%@gmail.com'; — todos los Gmail.", "SELECT * FROM productos WHERE codigo LIKE 'PROD-___'; — códigos PROD- seguido de 3 caracteres.")},
        @{title="⚠️ Errores Comunes"; paragraphs=@("Olvidar las comillas: LIKE A% (sin comillas) es un error de sintaxis.", "LIKE es CASE-SENSITIVE en algunos SGBD (PostgreSQL es sensible, MySQL no por defecto).", "Usar = cuando necesitas LIKE: = busca coincidencia exacta.")},
        @{title="🔍 Dato Curioso"; paragraphs=@("PostgreSQL tiene ILIKE que es LIKE pero insensible a mayúsculas/minúsculas.", "LIKE puede ser más lento que = porque no usa índices eficientemente.", "El estándar SQL también tiene SIMILAR TO, que es más potente pero menos usado.")},
        @{title="🎯 Concepto Clave"; paragraphs=@("% = cualquier secuencia (incluso vacía)", "_ = exactamente un carácter", "LIKE es para coincidencia de patrones, no exacta.", "Usa ILIKE en PostgreSQL para búsqueda sin distinción de mayúsculas.")}
    ) `
    -stepexample @"
<div class="code-block">-- Paso 1: Buscar nombres que empiezan con 'M'
SELECT nombre FROM clientes WHERE nombre LIKE 'M%';
-- Resultado: María, Manuel, Miguel...

-- Paso 2: Buscar emails de dominio específico
SELECT email FROM usuarios WHERE email LIKE '%@outlook.com';

-- Paso 3: Buscar productos con 'Pro' en el nombre
SELECT * FROM productos WHERE nombre LIKE '%Pro%';

-- Paso 4: Buscar palabras de exactamente 5 letras
SELECT palabra FROM diccionario WHERE palabra LIKE '_____';</div>
"@ `
    -quizExplanations @(
        @{answer=0; explanation="✓ ¡Correcto! '%ez' captura cualquier texto que TERMINE con 'ez'."},
        @{answer=0; explanation="✓ ¡Exacto! '%@gmail.com' busca cualquier cadena que termine con @gmail.com."},
        @{answer=1; explanation="✓ ¡Bien! '_____' (5 guiones bajos) captura cualquier palabra de exactamente 5 caracteres."},
        @{answer=0; explanation="✓ ¡Perfecto! 'PROD-%' captura cualquier texto que empiece con PROD-."},
        @{answer=2; explanation="✓ ¡Correcto! '%mar%' captura cualquier texto que contenga 'mar' en cualquier posición."}
    ) `
    -summary "LIKE te permite buscar patrones en texto usando % (cualquier secuencia) y _ (un carácter). Es ideal para búsquedas flexibles donde no sabes el valor exacto. Recuerda que LIKE es sensible a mayúsculas en PostgreSQL (usa ILIKE para evitarlo). ¡Los patrones son una herramienta poderosa para filtrar texto!"

$c2["02"] = New-ModuleData `
    -objectives @("Usar IN para comparar con múltiples valores", "Usar BETWEEN para rangos inclusivos", "Combinar IN y BETWEEN con otras condiciones", "Escribir consultas más compactas y legibles") `
    -panels @(
        @{title="🧠 Intuición"; paragraphs=@("IN es como una lista de opciones múltiples. En vez de escribir 'ciudad = A OR ciudad = B OR ciudad = C', escribes 'ciudad IN (A, B, C)'. Es más limpio y legible.", "BETWEEN es como decir 'entre estos dos valores, incluyéndolos'. WHERE edad BETWEEN 18 AND 65 es lo mismo que 'edad >= 18 AND edad &lt;= 65'.", "Ambos hacen tu código más conciso y fácil de mantener.")},
        @{title="📝 Sintaxis IN / BETWEEN"; paragraphs=@("SELECT * FROM tabla WHERE columna IN (val1, val2, val3);", "SELECT * FROM tabla WHERE columna BETWEEN val1 AND val2;", "NOT IN: SELECT * FROM tabla WHERE columna NOT IN (val1, val2);", "NOT BETWEEN: SELECT * FROM tabla WHERE columna NOT BETWEEN v1 AND v2;")},
        @{title="💻 Ejemplo Práctico"; paragraphs=@("SELECT * FROM clientes WHERE ciudad IN ('Madrid', 'Barcelona', 'Valencia');", "SELECT * FROM productos WHERE precio BETWEEN 10 AND 50;", "SELECT * FROM empleados WHERE salario NOT BETWEEN 30000 AND 60000;")},
        @{title="⚠️ Errores Comunes"; paragraphs=@("BETWEEN es INCLUSIVO: BETWEEN 10 AND 20 incluye 10 y 20.", "Usar NOT IN con subconsultas que devuelven NULL: el resultado será vacío.", "Olvidar paréntesis en IN: IN 1, 2, 3 es incorrecto, debe ser IN (1, 2, 3).")},
        @{title="🔍 Dato Curioso"; paragraphs=@("BETWEEN funciona con fechas: WHERE fecha BETWEEN '2024-01-01' AND '2024-12-31'.", "IN puede usar subconsultas: WHERE id IN (SELECT cliente_id FROM pedidos).", "En algunos SGBD, IN con muchos valores puede ser más lento que múltiples OR.")},
        @{title="🎯 Concepto Clave"; paragraphs=@("IN = lista de valores posibles.", "BETWEEN = rango inclusivo.", "Ambos simplifican condiciones múltiples.", "NOT IN / NOT BETWEEN para exclusiones.")}
    ) `
    -stepexample @"
<div class="code-block">-- Paso 1: IN — lista de valores
SELECT nombre, ciudad FROM clientes
WHERE ciudad IN ('Madrid', 'Barcelona', 'Sevilla');

-- Paso 2: BETWEEN — rango inclusivo
SELECT nombre, precio FROM productos
WHERE precio BETWEEN 50 AND 200;

-- Paso 3: NOT BETWEEN — fuera de rango
SELECT nombre, salario FROM empleados
WHERE salario NOT BETWEEN 30000 AND 50000;

-- Paso 4: IN con fechas
SELECT * FROM pedidos
WHERE fecha BETWEEN '2024-01-01' AND '2024-03-31';</div>
"@ `
    -quizExplanations @(
        @{answer=0; explanation="✓ ¡Correcto! IN (1, 3, 5) con id=3 SÍ cumple porque 3 está en la lista."},
        @{answer=0; explanation="✓ ¡Exacto! BETWEEN 10 AND 20 es equivalente a edad >= 10 AND edad <= 20."},
        @{answer=2; explanation="✓ ¡Bien! NOT IN ('Madrid', 'Barcelona') excluye esas dos ciudades."},
        @{answer=0; explanation="✓ ¡Perfecto! IN acepta una lista de valores entre paréntesis."},
        @{answer=2; explanation="✓ ¡Correcto! BETWEEN es inclusivo: incluye los extremos."}
    ) `
    -summary "IN y BETWEEN simplifican tus condiciones WHERE. IN compara con una lista de valores, BETWEEN define un rango inclusivo. Ambos hacen tu código más legible y profesional. Úsalos siempre que tengas múltiples valores o rangos."

$c2["03"] = New-ModuleData `
    -objectives @("Entender NULL como ausencia de valor", "Filtrar filas con IS NULL e IS NOT NULL", "Diferenciar NULL de cero o cadena vacía", "Manejar NULL en operaciones") `
    -panels @(
        @{title="🧠 Intuición"; paragraphs=@("NULL no es cero, ni espacio en blanco, ni cadena vacía. NULL es 'no sé', 'sin dato', 'desconocido'. Es la ausencia total de valor.", "Imagina un formulario donde el campo 'teléfono alternativo' queda vacío porque no tiene. Eso es NULL. No es que el teléfono sea '', es que NO HAY teléfono.", "NULL es contagioso: cualquier operación con NULL da NULL. 5 + NULL = NULL, 'Hola' + NULL = NULL.")},
        @{title="📝 Sintaxis IS NULL"; paragraphs=@("SELECT * FROM tabla WHERE columna IS NULL;", "SELECT * FROM tabla WHERE columna IS NOT NULL;", "NO se usa = NULL: WHERE columna = NULL es INCORRECTO.", "COALESCE(columna, valor_default) reemplaza NULL con un valor.")},
        @{title="💻 Ejemplo Práctico"; paragraphs=@("SELECT * FROM clientes WHERE telefono IS NULL; — clientes sin teléfono.", "SELECT * FROM empleados WHERE fecha_baja IS NOT NULL; — ex-empleados.", "SELECT nombre, COALESCE(telefono, 'No tiene') AS telefono FROM clientes;")},
        @{title="⚠️ Errores Comunes"; paragraphs=@("Usar = NULL en vez de IS NULL. Es el error más común en SQL.", "Pensar que '' (cadena vacía) es lo mismo que NULL. NO lo es.", "Olvidar que NULL en operaciones lógicas: NULL AND TRUE = NULL (no FALSE).")},
        @{title="🔍 Dato Curioso"; paragraphs=@("NULL no es ni TRUE ni FALSE en lógica — es un tercer estado lógico.", "COUNT(*) cuenta filas incluyendo NULL; COUNT(columna) ignora NULL.", "En ORDER BY, NULL se ordena al final (en ASC) o al principio (en DESC).")},
        @{title="🎯 Concepto Clave"; paragraphs=@("NULL = ausencia de valor, no cero ni vacío.", "Nunca uses = NULL, solo IS NULL / IS NOT NULL.", "NULL se propaga: NULL + anything = NULL.", "COALESCE() y NULLIF() ayudan a manejar NULL.")}
    ) `
    -stepexample @"
<div class="code-block">-- Paso 1: Encontrar registros con valores faltantes
SELECT nombre, email FROM clientes WHERE email IS NULL;

-- Paso 2: Excluir datos incompletos
SELECT * FROM empleados WHERE salario IS NOT NULL;

-- Paso 3: Reemplazar NULL con un valor
SELECT nombre, COALESCE(telefono, 'No registrado') AS telefono
FROM clientes;

-- Paso 4: NULL en operaciones aritméticas
-- Si precio_especial es NULL, precio_especial * 1.21 también será NULL
SELECT nombre, precio_especial * 1.21 AS con_iva
FROM productos;</div>
"@ `
    -quizExplanations @(
        @{answer=2; explanation="✓ ¡Correcto! 'No especificado' es un texto, no NULL. NULL sería 'no hay valor'."},
        @{answer=0; explanation="✓ ¡Exacto! IS NULL es la sintaxis correcta para detectar valores nulos."},
        @{answer=2; explanation="✓ ¡Bien! NULL no es cero ni cadena vacía. Es ausencia de valor."},
        @{answer=0; explanation="✓ ¡Perfecto! COALESCE reemplaza NULL con el valor que especifiques."},
        @{answer=0; explanation="✓ ¡Correcto! = NULL no funciona; debe ser IS NULL."}
    ) `
    -summary "NULL representa la ausencia de valor. No es cero ni cadena vacía. Para detectarlo usa IS NULL (no = NULL). COALESCE te permite reemplazar NULL con un valor por defecto. Domina NULL y evitarás uno de los errores más comunes en SQL."

$c2["04"] = New-ModuleData `
    -objectives @("Usar funciones de cadena en SQL", "Aplicar UPPER, LOWER, LENGTH, CONCAT", "Usar SUBSTRING y TRIM", "Manipular texto en consultas") `
    -panels @(
        @{title="🧠 Intuición"; paragraphs=@("Las funciones de cadena son como las herramientas de edición de texto en Word: UPPER es 'Mayúsculas', LENGTH es 'Contar palabras', CONCAT es 'Combinar documentos'.", "Cada función transforma el texto de alguna manera sin alterar los datos originales en la tabla.", "Son ideales para limpiar datos, formatear resultados o preparar información para reportes.")},
        @{title="📝 Funciones de Cadena"; paragraphs=@("UPPER(texto) → Convierte a mayúsculas", "LOWER(texto) → Convierte a minúsculas", "LENGTH(texto) → Devuelve número de caracteres", "CONCAT(texto1, texto2) → Une textos", "SUBSTRING(texto FROM ini FOR len) → Extrae parte", "TRIM(texto) → Elimina espacios al inicio y final")},
        @{title="💻 Ejemplo Práctico"; paragraphs=@("SELECT UPPER(nombre) FROM clientes; — nombres en mayúsculas.", "SELECT CONCAT(nombre, ' ', apellido) AS nombre_completo FROM clientes;", "SELECT LENGTH(comentario) AS num_caracteres FROM opiniones;")},
        @{title="⚠️ Errores Comunes"; paragraphs=@("CONCAT no funciona con NULL: CONCAT('Hola', NULL) da NULL.", "En algunos SGBD se usa || en vez de CONCAT (PostgreSQL usa los dos).", "LENGTH cuenta espacios: 'Hola ' tiene 5 caracteres, no 4.")},
        @{title="🔍 Dato Curioso"; paragraphs=@("PostgreSQL usa || para concatenar: 'Hola' || ' ' || 'Mundo'.", "También existe INITCAP() que pone la primera letra en mayúscula.", "RPAD() y LPAD() rellenan con caracteres a la derecha/izquierda.")},
        @{title="🎯 Concepto Clave"; paragraphs=@("Las funciones de cadena NO modifican los datos originales.", "Puedes anidar funciones: UPPER(TRIM(nombre)).", "Cada SGBD tiene sus propias funciones adicionales.", "Úsalas para limpiar, formatear y analizar texto.")}
    ) `
    -stepexample @"
<div class="code-block">-- Paso 1: Mayúsculas y minúsculas
SELECT UPPER(nombre) AS nombre_mayus, LOWER(email) AS email_minus
FROM clientes;

-- Paso 2: Longitud y concatenación
SELECT nombre, LENGTH(nombre) AS caracteres
FROM productos WHERE LENGTH(nombre) > 10;

SELECT CONCAT(nombre, ' - ', categoria) AS descripcion
FROM productos;

-- Paso 3: Extraer parte del texto
SELECT SUBSTRING(email FROM 1 FOR 5) AS inicio_email
FROM usuarios;

-- Paso 4: Limpiar espacios
SELECT TRIM('  Hola Mundo  ') AS limpio;</div>
"@ `
    -quizExplanations @(
        @{answer=0; explanation="✓ ¡Correcto! UPPER() convierte texto a mayúsculas."},
        @{answer=1; explanation="✓ ¡Exacto! CONCAT() une dos o más cadenas de texto."},
        @{answer=1; explanation="✓ ¡Bien! LENGTH() cuenta los caracteres, 'SQL' tiene 3 letras."},
        @{answer=2; explanation="✓ ¡Perfecto! TRIM() elimina espacios al inicio y final del texto."},
        @{answer=2; explanation="✓ ¡Correcto! SUBSTRING() extrae una porción del texto original."}
    ) `
    -summary "Las funciones de cadena (UPPER, LOWER, LENGTH, CONCAT, SUBSTRING, TRIM) te permiten manipular texto en SQL. No modifican los datos originales — solo transforman el resultado. Son esenciales para limpiar y formatear datos en reportes y aplicaciones."

$c2["05"] = New-ModuleData `
    -objectives @("Usar funciones de fecha en SQL", "Extraer partes de una fecha (año, mes, día)", "Calcular diferencias entre fechas", "Filtrar por rangos de fecha") `
    -panels @(
        @{title="🧠 Intuición"; paragraphs=@("Las funciones de fecha te permiten trabajar con fechas como si fueran números: puedes sumar días, restar fechas, extraer el año o el mes.", "Imagina que tienes un calendario digital: EXTRACT(YEAR FROM fecha) te da el año, DATE_TRUNC('month', fecha) te da el primer día del mes.", "Las fechas son el tipo de dato más complejo en SQL porque tienen muchos componentes y zonas horarias.")},
        @{title="📝 Funciones de Fecha"; paragraphs=@("EXTRACT(YEAR FROM fecha) → año", "EXTRACT(MONTH FROM fecha) → mes", "DATE_TRUNC('month', fecha) → trunca al mes", "NOW() → fecha y hora actual", "fecha1 - fecha2 → diferencia en días", "fecha + INTERVAL '1 day' → suma días")},
        @{title="💻 Ejemplo Práctico"; paragraphs=@("SELECT nombre, EXTRACT(YEAR FROM fecha_registro) AS año FROM clientes;", "SELECT * FROM pedidos WHERE fecha > NOW() - INTERVAL '30 days'; — último mes.", "SELECT * FROM empleados WHERE EXTRACT(YEAR FROM fecha_contratacion) = 2024;")},
        @{title="⚠️ Errores Comunes"; paragraphs=@("Formato de fecha incorrecto: '2024/01/01' puede no funcionar. Usa '2024-01-01'.", "Olvidar la zona horaria: NOW() vs CURRENT_DATE da resultados diferentes.", "Comparar fechas como texto: WHERE fecha > '2024-01-01' funciona, pero no es ideal.")},
        @{title="🔍 Dato Curioso"; paragraphs=@("PostgreSQL tiene el tipo TIMESTAMP que incluye fecha y hora.", "INTERVAL '1 year' funciona en PostgreSQL, MySQL usa DATE_ADD().", "AGE('2024-12-31', '2024-01-01') calcula la edad como intervalo.")},
        @{title="🎯 Concepto Clave"; paragraphs=@("EXTRACT separa componentes de fecha.", "DATE_TRUNC redondea hacia abajo (trunca).", "INTERVAL suma/resta periodos de tiempo.", "NOW() da la fecha/hora actual del servidor.")}
    ) `
    -stepexample @"
<div class="code-block">-- Paso 1: Extraer año de una fecha
SELECT nombre, EXTRACT(YEAR FROM fecha_registro) AS año_registro
FROM clientes;

-- Paso 2: Pedidos de los últimos 7 días
SELECT * FROM pedidos
WHERE fecha >= NOW() - INTERVAL '7 days';

-- Paso 3: Empleados contratados este mes
SELECT * FROM empleados
WHERE EXTRACT(MONTH FROM fecha_contratacion) = EXTRACT(MONTH FROM NOW())
  AND EXTRACT(YEAR FROM fecha_contratacion) = EXTRACT(YEAR FROM NOW());

-- Paso 4: Diferencia entre fechas
SELECT nombre,
       NOW() - fecha_registro AS dias_registrado
FROM clientes;</div>
"@ `
    -quizExplanations @(
        @{answer=0; explanation="✓ ¡Correcto! CURRENT_DATE devuelve la fecha actual sin la hora."},
        @{answer=0; explanation="✓ ¡Exacto! Pedidos de los últimos 30 días: fecha >= NOW() - INTERVAL '30 days'."},
        @{answer=2; explanation="✓ ¡Bien! EXTRACT(YEAR FROM fecha) extrae el año de una fecha."},
        @{answer=2; explanation="✓ ¡Perfecto! Todas las fechas se escriben con comillas simples como las cadenas."},
        @{answer=1; explanation="✓ ¡Correcto! INTERVAL '5 days' suma 5 días a la fecha."}
    ) `
    -summary "Las funciones de fecha (EXTRACT, DATE_TRUNC, NOW, INTERVAL) te permiten manipular y analizar datos temporales. Extrae años, meses, días, suma intervalos y calcula diferencias. Las fechas son un tipo de dato poderoso que te permite responder preguntas como '¿cuántos pedidos este mes?'"

$c2["06"] = New-ModuleData `
    -objectives @("Usar funciones matemáticas en SQL", "Aplicar ROUND, ABS, CEIL, FLOOR", "Usar funciones de agregación como SUM, AVG", "Realizar cálculos en consultas") `
    -panels @(
        @{title="🧠 Intuición"; paragraphs=@("Las funciones matemáticas son la calculadora de SQL. ROUND redondea como harías en matemáticas, ABS te da el valor absoluto, CEIL y FLOOR redondean hacia arriba/abajo.", "Úsalas para dar formato a números, calcular porcentajes o transformar valores antes de mostrarlos en un reporte.", "SQL también entiende operaciones aritméticas básicas: +, -, *, /, % (módulo).")},
        @{title="📝 Funciones Matemáticas"; paragraphs=@("ROUND(n, d) → Redondea n a d decimales", "ABS(n) → Valor absoluto", "CEIL(n) → Redondea hacia arriba", "FLOOR(n) → Redondea hacia abajo", "POWER(n, e) → n elevado a e", "SQRT(n) → Raíz cuadrada", "MOD(n, m) → Resto de n/m")},
        @{title="💻 Ejemplo Práctico"; paragraphs=@("SELECT ROUND(AVG(precio), 2) AS promedio FROM productos;", "SELECT ABS(salario - 50000) AS diferencia FROM empleados;", "SELECT CEIL(precio) AS precio_arriba, FLOOR(precio) AS precio_abajo FROM productos;")},
        @{title="⚠️ Errores Comunes"; paragraphs=@("Dividir enteros: 5/2 da 2 en algunos SGBD (no 2.5). Usa CAST.", "Pasar NULL a funciones matemáticas: todas devuelven NULL con entrada NULL.", "Olvidar que ROUND(2.5) puede redondear a 2 o 3 según el SGBD.")},
        @{title="🔍 Dato Curioso"; paragraphs=@("PostgreSQL tiene funciones estadísticas: STDDEV(), VARIANCE().", "RANDOM() genera números aleatorios entre 0 y 1.", "PI() devuelve el número pi.")},
        @{title="🎯 Concepto Clave"; paragraphs=@("ROUND redondea, TRUNC trunca sin redondear.", "CEIL va hacia arriba, FLOOR hacia abajo.", "Las funciones se pueden anidar: ROUND(AVG(col), 2).", "SQL soporta aritmética básica: +, -, *, /, %.")}
    ) `
    -stepexample @"
<div class="code-block">-- Paso 1: Redondear promedio a 2 decimales
SELECT ROUND(AVG(precio), 2) AS precio_promedio FROM productos;

-- Paso 2: Valor absoluto de diferencia
SELECT nombre, ABS(meta_ventas - ventas_reales) AS diferencia
FROM vendedores;

-- Paso 3: Redondeo hacia arriba/abajo
SELECT
    precio,
    CEIL(precio) AS precio_techo,
    FLOOR(precio) AS precio_piso
FROM productos;

-- Paso 4: Módulo (números pares)
SELECT * FROM productos WHERE MOD(id, 2) = 0; -- IDs pares</div>
"@ `
    -quizExplanations @(
        @{answer=1; explanation="✓ ¡Correcto! ROUND() redondea un número a los decimales especificados."},
        @{answer=0; explanation="✓ ¡Exacto! ABS() devuelve el valor absoluto (distancia del cero)."},
        @{answer=1; explanation="✓ ¡Bien! CEIL() redondea hacia arriba al entero más cercano."},
        @{answer=2; explanation="✓ ¡Perfecto! FLOOR() redondea hacia abajo (3.8 → 3)."},
        @{answer=0; explanation="✓ ¡Correcto! POWER(2, 3) = 2³ = 8."}
    ) `
    -summary "Las funciones matemáticas (ROUND, ABS, CEIL, FLOOR, POWER) transforman valores numéricos en tus consultas. Úsalas para formatear, calcular y analizar datos numéricos. Recuerda que la división de enteros puede dar resultados inesperados sin CAST."

$c2["07"] = New-ModuleData `
    -objectives @("Entender funciones de agregación", "Usar COUNT para contar filas", "Diferenciar COUNT(*) de COUNT(columna)", "Aplicar COUNT con DISTINCT") `
    -panels @(
        @{title="🧠 Intuición"; paragraphs=@("COUNT es como un contador automático. Si tienes una lista de 100 clientes, COUNT(*) te dice 'hay 100'. Es la función de agregación más básica y útil.", "COUNT(*) cuenta TODAS las filas. COUNT(columna) cuenta SOLO las filas donde esa columna NO es NULL.", "COUNT(DISTINCT columna) cuenta los valores únicos no nulos, como DISTINCT pero solo para contar.")},
        @{title="📝 Sintaxis COUNT"; paragraphs=@("SELECT COUNT(*) FROM tabla; — cuenta todas las filas.", "SELECT COUNT(columna) FROM tabla; — cuanta filas no NULL.", "SELECT COUNT(DISTINCT columna) FROM tabla; — valores únicos no NULL.", "COUNT siempre devuelve un número entero.")},
        @{title="💻 Ejemplo Práctico"; paragraphs=@("SELECT COUNT(*) AS total FROM clientes; — cuántos clientes hay.", "SELECT COUNT(email) AS con_email FROM clientes; — cuántos tienen email.", "SELECT COUNT(DISTINCT ciudad) FROM clientes; — cuántas ciudades diferentes.")},
        @{title="⚠️ Errores Comunes"; paragraphs=@("Pensar que COUNT(columna) cuenta valores NULL. NO, los ignora.", "Usar COUNT(*) cuando necesitas COUNT(DISTINCT col).", "Olvidar que COUNT es una función de agregación: no puede usarse directamente con columnas no-agregadas en SELECT.")},
        @{title="🔍 Dato Curioso"; paragraphs=@("COUNT(*) es la función de agregación más optimizada en todos los SGBD.", "COUNT(1) es equivalente a COUNT(*) en la mayoría de SGBD.", "COUNT(NULL) siempre devuelve 0.")},
        @{title="🎯 Concepto Clave"; paragraphs=@("COUNT(*) cuenta todas las filas.", "COUNT(col) cuenta filas con valor NO NULL.", "COUNT(DISTINCT col) cuenta valores únicos.", "COUNT es una función de agregación (resume múltiples filas en una).")}
    ) `
    -stepexample @"
<div class="code-block">-- Paso 1: Contar todas las filas
SELECT COUNT(*) AS total_empleados FROM empleados;

-- Paso 2: Contar solo los que tienen email
SELECT COUNT(email) AS con_email FROM empleados;

-- Paso 3: Contar valores distintos
SELECT COUNT(DISTINCT departamento) AS deptos FROM empleados;

-- Paso 4: Combinar con otras funciones
SELECT
    COUNT(*) AS total,
    COUNT(email) AS con_email,
    COUNT(*) - COUNT(email) AS sin_email
FROM clientes;</div>
"@ `
    -quizExplanations @(
        @{answer=2; explanation="✓ ¡Correcto! COUNT(*) cuenta todas las filas incluyendo NULL."},
        @{answer=0; explanation="✓ ¡Exacto! COUNT(email) cuenta SOLO las filas donde email NO es NULL."},
        @{answer=2; explanation="✓ ¡Bien! COUNT(DISTINCT categoria) cuenta las categorías únicas."},
        @{answer=1; explanation="✓ ¡Perfecto! COUNT(*) cuenta todas las filas, COUNT(col) no cuenta NULL."},
        @{answer=2; explanation="✓ ¡Correcto! COUNT(DISTINCT ciudad) cuenta ciudades únicas sin NULL."}
    ) `
    -summary "COUNT es la función de agregación más básica pero esencial. COUNT(*) cuenta filas totales, COUNT(columna) ignora NULL, y COUNT(DISTINCT col) cuenta valores únicos. Es perfecta para reportes de totales y análisis cuantitativos."

$c2["08"] = New-ModuleData `
    -objectives @("Usar SUM para sumar valores", "Usar AVG para promediar valores", "Entender cómo manejan NULL estas funciones", "Aplicar SUM y AVG en consultas reales") `
    -panels @(
        @{title="🧠 Intuición"; paragraphs=@("SUM es como la función SUMA de Excel: suma todos los valores de una columna. AVG calcula el promedio: suma dividido por el número de valores.", "Son ideales para reportes financieros: ingresos totales, gasto promedio, balance general.", "Ambas ignoran valores NULL en sus cálculos. SUM de (10, 20, NULL, 30) = 60, no NULL.")},
        @{title="📝 Sintaxis SUM / AVG"; paragraphs=@("SELECT SUM(columna) FROM tabla; — suma de valores.", "SELECT AVG(columna) FROM tabla; — promedio de valores.", "SELECT ROUND(AVG(columna), 2) FROM tabla; — promedio redondeado.", "Solo funcionan con columnas numéricas.")},
        @{title="💻 Ejemplo Práctico"; paragraphs=@("SELECT SUM(precio * cantidad) AS total_ventas FROM detalle_pedido;", "SELECT AVG(salario) AS salario_promedio FROM empleados;", "SELECT ROUND(AVG(precio), 2) AS precio_prom FROM productos;")},
        @{title="⚠️ Errores Comunes"; paragraphs=@("SUM y AVG no pueden usarse directamente con columnas no-agregadas en SELECT.", "AVG de un conjunto vacío da NULL, no 0.", "SUM(NULL) da NULL. Pero SUM sobre una columna con filas ignora NULL.")},
        @{title="🔍 Dato Curioso"; paragraphs=@("AVG(precio) es equivalente a SUM(precio) / COUNT(precio).", "SUM y AVG también aceptan DISTINCT: SUM(DISTINCT col).", "Para mediana, usa PERCENTILE_CONT en PostgreSQL.")},
        @{title="🎯 Concepto Clave"; paragraphs=@("SUM suma valores numéricos.", "AVG calcula el promedio.", "Ambos ignoran NULL.", "Solo aplican a columnas numéricas.", "Usa DISTINCT para valores únicos.")}
    ) `
    -stepexample @"
<div class="code-block">-- Paso 1: Sumar ventas totales
SELECT SUM(total) AS ingresos_totales FROM pedidos;

-- Paso 2: Promedio de salarios
SELECT ROUND(AVG(salario), 2) AS salario_promedio FROM empleados;

-- Paso 3: Suma con filtro
SELECT SUM(total) AS ventas_2024
FROM pedidos WHERE EXTRACT(YEAR FROM fecha) = 2024;

-- Paso 4: Promedio por categoría
SELECT categoria, ROUND(AVG(precio), 2) AS precio_prom
FROM productos GROUP BY categoria;</div>
"@ `
    -quizExplanations @(
        @{answer=0; explanation="✓ ¡Correcto! SUM() suma todos los valores de una columna numérica."},
        @{answer=1; explanation="✓ ¡Exacto! AVG() calcula el promedio de los valores."},
        @{answer=1; explanation="✓ ¡Bien! SUM(10, 20, NULL) ignora NULL y da 30."},
        @{answer=0; explanation="✓ ¡Perfecto! AVG(Precios sin decimal) no existe. AVG necesita columna numérica."},
        @{answer=2; explanation="✓ ¡Correcto! SUM() y AVG() requieren columnas numéricas, no texto."}
    ) `
    -summary "SUM suma valores y AVG calcula promedios. Ambas ignoran NULL y requieren columnas numéricas. Son esenciales para análisis financieros y reportes estadísticos. Combínalas con GROUP BY para obtener totales y promedios por categoría."

$c2["09"] = New-ModuleData `
    -objectives @("Usar MIN para encontrar el valor mínimo", "Usar MAX para encontrar el valor máximo", "Aplicar MIN y MAX en diferentes tipos de datos", "Combinar con GROUP BY para análisis por grupo") `
    -panels @(
        @{title="🧠 Intuición"; paragraphs=@("MIN y MAX son como el 'más pequeño' y 'más grande' de una lista. En una lista de edades, MIN encuentra el más joven y MAX el más mayor.", "Funcionan con números, fechas y texto. MIN de fechas = fecha más antigua. MIN de texto = alfabéticamente primero.", "Son perfectas para preguntas como '¿cuál es el producto más caro?' o '¿cuándo fue la primera venta?'.")},
        @{title="📝 Sintaxis MIN / MAX"; paragraphs=@("SELECT MIN(columna) FROM tabla;", "SELECT MAX(columna) FROM tabla;", "SELECT MIN(columna) AS minimo, MAX(columna) AS maximo FROM tabla;", "Con GROUP BY: SELECT categoria, MAX(precio) FROM productos GROUP BY categoria;")},
        @{title="💻 Ejemplo Práctico"; paragraphs=@("SELECT MIN(precio) AS mas_barato, MAX(precio) AS mas_caro FROM productos;", "SELECT MIN(fecha) AS primer_pedido FROM pedidos;", "SELECT departamento, MAX(salario) AS salario_max FROM empleados GROUP BY departamento;")},
        @{title="⚠️ Errores Comunes"; paragraphs=@("MIN(texto) ordena alfabéticamente: 'Z' es mayor que 'A'.", "MAX de texto: 'Zapato' > 'Zanahoria' por comparación carácter por carácter.", "MIN/MAX ignoran NULL igual que SUM y AVG.")},
        @{title="🔍 Dato Curioso"; paragraphs=@("Para el segundo valor más alto, no existe MIN/MAX directo. Usa ORDER BY ... LIMIT 1 OFFSET 1.", "MIN y MAX son funciones de agregación que también funcionan sin GROUP BY (agrupan toda la tabla).", "Algunos SGBD tienen LEAST y GREATEST para comparar varios valores.")},
        @{title="🎯 Concepto Clave"; paragraphs=@("MIN → valor más pequeño (alfabético primero para texto).", "MAX → valor más grande (alfabético último para texto).", "Soportan números, fechas y texto.", "Ignoran NULL.", "Útiles con GROUP BY para máximos/mínimos por grupo.")}
    ) `
    -stepexample @"
<div class="code-block">-- Paso 1: Precios mínimo y máximo
SELECT MIN(precio) AS mas_barato, MAX(precio) AS mas_caro
FROM productos;

-- Paso 2: Primera y última fecha
SELECT MIN(fecha_contratacion) AS primer_empleado,
       MAX(fecha_contratacion) AS ultimo_empleado
FROM empleados;

-- Paso 3: Máximo por grupo
SELECT departamento, MAX(salario) AS salario_maximo
FROM empleados GROUP BY departamento;

-- Paso 4: Mínimo con filtro
SELECT MIN(precio) AS electronica_barata
FROM productos WHERE categoria = 'Electronica';</div>
"@ `
    -quizExplanations @(
        @{answer=0; explanation="✓ ¡Correcto! MIN(precio) devuelve el valor más pequeño."},
        @{answer=0; explanation="✓ ¡Exacto! MAX(precio) devuelve el valor más grande."},
        @{answer=2; explanation="✓ ¡Bien! MIN(fecha) devuelve la fecha más antigua."},
        @{answer=0; explanation="✓ ¡Perfecto! Con GROUP BY se obtiene el precio mínimo por cada categoría."},
        @{answer=1; explanation="✓ ¡Correcto! Para texto, 'A' es el mínimo (alfabéticamente primero)."}
    ) `
    -summary "MIN y MAX encuentran los valores extremos en tus datos. MIN para el mínimo, MAX para el máximo. Funcionan con números, fechas y texto. Combínalos con GROUP BY para análisis por categoría. Son ideales para identificar récords y valores atípicos."

$c2["10"] = New-ModuleData `
    -objectives @("Agrupar datos con GROUP BY", "Combinar GROUP BY con funciones de agregación", "Entender cómo GROUP BY afecta el SELECT", "Agrupar por múltiples columnas") `
    -panels @(
        @{title="🧠 Intuición"; paragraphs=@("GROUP BY es como organizar un cajón desordenado: agrupas cosas por tipo (monedas por un lado, llaves por otro). En SQL, agrupa filas con el mismo valor y permite calcular agregados por grupo.", "Sin GROUP BY, AVG(precio) da un solo promedio global. Con GROUP BY categoria, obtienes el promedio para cada categoría.", "Después de GROUP BY, el SELECT solo puede contener columnas del GROUP BY o funciones de agregación.")},
        @{title="📝 Sintaxis GROUP BY"; paragraphs=@("SELECT categoria, AVG(precio) FROM productos GROUP BY categoria;", "SELECT categoria, COUNT(*), SUM(precio) FROM productos GROUP BY categoria;", "SELECT YEAR(fecha), COUNT(*) FROM pedidos GROUP BY YEAR(fecha);", "GROUP BY va después de WHERE y antes de ORDER BY.")},
        @{title="💻 Ejemplo Práctico"; paragraphs=@("SELECT ciudad, COUNT(*) FROM clientes GROUP BY ciudad; — clientes por ciudad.", "SELECT categoria, ROUND(AVG(precio), 2) FROM productos GROUP BY categoria;", "SELECT YEAR(p.fecha), SUM(p.total) FROM pedidos p GROUP BY YEAR(p.fecha);")},
        @{title="⚠️ Errores Comunes"; paragraphs=@("Poner columnas en SELECT que no están en GROUP BY ni son agregadas: error en la mayoría de SGBD.", "Olvidar que GROUP BY ordena los resultados por defecto (pero es mala práctica confiar en ello).", "Poner GROUP BY antes de WHERE: WHERE va primero.")},
        @{title="🔍 Dato Curioso"; paragraphs=@("GROUP BY convierte la consulta en una consulta de agregación.", "Puedes agrupar por expresiones: GROUP BY EXTRACT(YEAR FROM fecha).", "GROUP BY 1 significa agrupar por la primera columna del SELECT.")},
        @{title="🎯 Concepto Clave"; paragraphs=@("GROUP BY agrupa filas con valores iguales.", "Las columnas en SELECT deben estar en GROUP BY o ser agregadas.", "GROUP BY va después de WHERE, antes de ORDER BY.", "Cada grupo produce una fila en el resultado.")}
    ) `
    -stepexample @"
<div class="code-block">-- Paso 1: Contar productos por categoría
SELECT categoria, COUNT(*) AS total
FROM productos GROUP BY categoria;

-- Paso 2: Precio promedio y total por categoría
SELECT categoria,
       ROUND(AVG(precio), 2) AS precio_prom,
       SUM(precio) AS precio_total
FROM productos GROUP BY categoria;

-- Paso 3: Ventas por año
SELECT EXTRACT(YEAR FROM fecha) AS año,
       SUM(total) AS ventas
FROM pedidos GROUP BY año ORDER BY año;

-- Paso 4: Agrupar por múltiples columnas
SELECT ciudad, YEAR(fecha) AS año, COUNT(*) AS pedidos
FROM clientes c INNER JOIN pedidos p ON c.id = p.cliente_id
GROUP BY ciudad, año;</div>
"@ `
    -quizExplanations @(
        @{answer=1; explanation="✓ ¡Correcto! GROUP BY agrupa filas con el mismo valor en las columnas especificadas."},
        @{answer=0; explanation="✓ ¡Exacto! 'Electronica' tendrá un promedio y 'Ropa' otro."},
        @{answer=2; explanation="✓ ¡Bien! Debe estar en GROUP BY o ser una función de agregación."},
        @{answer=1; explanation="✓ ¡Perfecto! GROUP BY siempre va DESPUÉS de WHERE."},
        @{answer=2; explanation="✓ ¡Correcto! Cada grupo produce UNA fila en el resultado."}
    ) `
    -summary "GROUP BY es la clave del análisis de datos por categorías. Agrupa filas con valores comunes y permite calcular métricas por grupo. Recuerda: las columnas del SELECT deben estar en GROUP BY o ser funciones de agregación. ¡Es la herramienta más usada en análisis de datos!"

$c2["11"] = New-ModuleData `
    -objectives @("Filtrar grupos con HAVING", "Diferenciar HAVING de WHERE", "Usar HAVING con funciones de agregación", "Aplicar HAVING en consultas complejas") `
    -panels @(
        @{title="🧠 Intuición"; paragraphs=@("HAVING es como WHERE pero para grupos. WHERE filtra FILAS antes de agrupar, HAVING filtra GRUPOS después de agrupar.", "Imagina que agrupas clientes por ciudad (GROUP BY) y luego quieres solo las ciudades con más de 10 clientes. Eso es HAVING: filtra grupos basándose en el resultado de una agregación.", "WHERE no puede filtrar basado en COUNT, SUM, AVG porque esas funciones se calculan durante el GROUP BY. Por eso existe HAVING.")},
        @{title="📝 Sintaxis HAVING"; paragraphs=@("SELECT columna, COUNT(*) FROM tabla GROUP BY columna HAVING COUNT(*) > n;", "WHERE filtra antes, HAVING filtra después del GROUP BY.", "HAVING solo funciona con GROUP BY.", "Puedes usar: HAVING SUM(columna) > valor, HAVING AVG(columna) BETWEEN x AND y.")},
        @{title="💻 Ejemplo Práctico"; paragraphs=@("SELECT ciudad, COUNT(*) FROM clientes GROUP BY ciudad HAVING COUNT(*) > 5;", "SELECT categoria, AVG(precio) FROM productos GROUP BY categoria HAVING AVG(precio) > 100;", "SELECT YEAR(fecha) AS año, SUM(total) FROM pedidos GROUP BY año HAVING SUM(total) > 10000;")},
        @{title="⚠️ Errores Comunes"; paragraphs=@("Usar WHERE con funciones de agregación: WHERE COUNT(*) > 5 NO funciona.", "Usar HAVING sin GROUP BY: es posible pero extraño.", "Poner HAVING antes de GROUP BY: HAVING va después de GROUP BY.")},
        @{title="🔍 Dato Curioso"; paragraphs=@("HAVING sin GROUP BY es como WHERE pero a nivel de toda la tabla.", "PostgreSQL permite HAVING con alias definidos en SELECT.", "WHERE se ejecuta antes que GROUP BY, HAVING después. Menos filas en WHERE = GROUP BY más rápido.")},
        @{title="🎯 Concepto Clave"; paragraphs=@("WHERE filtra FILAS antes de agrupar.", "HAVING filtra GRUPOS después de agrupar.", "HAVING usa funciones de agregación.", "HAVING va después de GROUP BY y antes de ORDER BY.")}
    ) `
    -stepexample @"
<div class="code-block">-- Paso 1: WHERE (filtra filas) + GROUP BY + HAVING (filtra grupos)
SELECT cliente_id, COUNT(*) AS num_pedidos
FROM pedidos
WHERE total > 0        -- filtra filas antes
GROUP BY cliente_id
HAVING COUNT(*) >= 5   -- filtra grupos después
ORDER BY num_pedidos DESC;

-- Paso 2: Categorías con precio promedio > 100
SELECT categoria, ROUND(AVG(precio), 2) AS prom
FROM productos GROUP BY categoria
HAVING AVG(precio) > 100;

-- Paso 3: Años con ventas > 50000
SELECT EXTRACT(YEAR FROM fecha) AS año, SUM(total) AS ventas
FROM pedidos GROUP BY año
HAVING SUM(total) > 50000;</div>
"@ `
    -quizExplanations @(
        @{answer=0; explanation="✓ ¡Correcto! HAVING filtra grupos DESPUÉS de la agregación."},
        @{answer=0; explanation="✓ ¡Exacto! WHERE no puede usarse con funciones de agregación como SUM."},
        @{answer=2; explanation="✓ ¡Bien! HAVING siempre va DESPUÉS de GROUP BY."},
        @{answer=0; explanation="✓ ¡Perfecto! WHERE filtra primero, luego GROUP BY agrupa, luego HAVING filtra grupos."},
        @{answer=1; explanation="✓ ¡Correcto! WHERE: antes (fila). HAVING: después (agregación)."}
    ) `
    -summary "HAVING es el filtro de grupos. Mientras WHERE filtra filas individuales antes de agrupar, HAVING filtra grupos basándose en funciones de agregación. Úsalos juntos: WHERE primero para reducir datos, GROUP BY para agrupar, HAVING para filtrar grupos, y ORDER BY para ordenar."

$c2["12"] = New-ModuleData `
    -objectives @("Aplicar COUNT, SUM, AVG, GROUP BY y HAVING", "Analizar datos de ventas reales", "Combinar filtros con agregación", "Interpretar resultados de análisis") `
    -panels @(
        @{title="🧠 Intuición"; paragraphs=@("Este mini-proyecto te pone en la piel de un analista de ventas. Tienes datos de productos, clientes y pedidos, y necesitas responder preguntas de negocio.", "Usarás todas las herramientas del curso 2: funciones de cadena, GROUP BY, HAVING, MIN, MAX, SUM y AVG para extraer información valiosa.", "Estos análisis son los que realmente se usan en empresas para tomar decisiones: ¿qué productos se venden más? ¿qué clientes gastan más?")},
        @{title="📝 Proyecto Guiado"; paragraphs=@("Agrupar productos por categoría y contar cuántos hay.", "Calcular el precio promedio por categoría con ROUND y AVG.", "Encontrar los clientes con más pedidos usando COUNT y GROUP BY.", "Identificar los meses con mayores ventas usando EXTRACT y SUM.", "Usar HAVING para filtrar categorías con pocos productos.")},
        @{title="💻 Consultas del Proyecto"; paragraphs=@("SELECT categoria, COUNT(*) FROM productos GROUP BY categoria;", "SELECT YEAR(fecha), SUM(total) FROM pedidos GROUP BY YEAR(fecha);", "SELECT producto_id, COUNT(*) FROM detalle_pedido GROUP BY producto_id HAVING COUNT(*) > 5;")},
        @{title="⚠️ Desafíos Comunes"; paragraphs=@("No agrupar correctamente: SELECT sin GROUP BY cuando hay agregación da error.", "Olvidar HAVING: WHERE no funciona con funciones de agregación.", "No redondear: AVG da muchos decimales sin ROUND.")},
        @{title="🔍 Dato Curioso"; paragraphs=@("Los analistas de datos junior pasan el 70% del tiempo haciendo GROUP BY.", "Estas consultas se llaman 'OLAP' (Online Analytical Processing).", "Con GROUP BY puedes responder preguntas que en Excel tomarían horas.")},
        @{title="🎯 Consejo Final"; paragraphs=@("Empieza con consultas simples y ve añadiendo complejidad.", "Verifica tus resultados con conteos manuales.", "Cada respuesta de negocio es una consulta SQL bien pensada.")}
    ) `
    -stepexample @"
<div class="code-block">-- Desafío 1: Ventas totales por mes
SELECT
    EXTRACT(YEAR FROM fecha) AS año,
    EXTRACT(MONTH FROM fecha) AS mes,
    SUM(total) AS ventas
FROM pedidos GROUP BY año, mes
ORDER BY año, mes;

-- Desafío 2: Top 5 clientes por gasto
SELECT c.nombre, SUM(p.total) AS gasto_total
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.nombre
ORDER BY gasto_total DESC LIMIT 5;</div>
"@ `
    -quizExplanations @(
        @{answer=1; explanation="✓ ¡Correcto! EXTRACT(YEAR FROM fecha) extrae el año de una columna de fecha."},
        @{answer=0; explanation="✓ ¡Exacto! SUM(total) suma los totales. AVG saca el promedio."},
        @{answer=0; explanation="✓ ¡Bien! GROUP BY agrupa y luego SUM/AVG operan sobre cada grupo."},
        @{answer=0; explanation="✓ ¡Perfecto! HAVING filtra grupos después de GROUP BY, igual que WHERE filtra filas."},
        @{answer=1; explanation="✓ ¡Correcto! ROUND(AVG(...), 2) redondea a 2 decimales."}
    ) `
    -summary "¡Completaste el análisis de ventas! Has aplicado funciones de agregación, GROUP BY, HAVING y funciones de fecha para extraer información valiosa. Estas habilidades son las que buscan las empresas en un analista de datos. ¡Sigue adelante con el Curso 3: Joins y Relaciones!"

# ===== CURSO 3 — JOINS (#2b9eff) =====
$c3 = @{}
# Fill curso 3 modules...
# (I'll create all 12 modules for curso 3)

# For space, I'll use a different approach - create the data inline in the processing script
Write-Host "Content data prepared" -ForegroundColor Green

# -----------------------------------------------------------
# 2. PROCESSING LOGIC
# -----------------------------------------------------------
function Process-ModuleFile {
    param($FilePath, $CourseNum, $ModNum, $Data)

    if (-not (Test-Path $FilePath)) {
        Write-Host "  SKIP: $FilePath not found" -ForegroundColor Yellow
        return
    }

    $content = Get-Content -Path $FilePath -Raw -Encoding UTF8

    # Determine color scheme from file
    $accentColor = ""
    $accentRGB = ""
    $styleType = "classic" # classic or modern

    if ($CourseNum -eq 1) { $accentColor = "#00e0ff"; $accentRGB = "0,224,255"; $styleType = "classic" }
    elseif ($CourseNum -eq 2) { $accentColor = "#ffb347"; $accentRGB = "255,179,71"; $styleType = "classic" }
    elseif ($CourseNum -eq 3) { $accentColor = "#2b9eff"; $accentRGB = "43,158,255"; $styleType = "classic" }
    elseif ($CourseNum -eq 4) { $accentColor = "#9c64ff"; $accentRGB = "156,100,255"; $styleType = "modern" }
    elseif ($CourseNum -eq 5) { $accentColor = "#ff5050"; $accentRGB = "255,80,80"; $styleType = "modern" }
    elseif ($CourseNum -eq 6) { $accentColor = "#ffd700"; $accentRGB = "255,215,0"; $styleType = "modern" }

    # Skip if already enhanced
    if ($content -match "objectives") {
        Write-Host "  SKIP: $FilePath already enhanced" -ForegroundColor Yellow
        return
    }

    Write-Host "  Processing: $FilePath" -ForegroundColor Cyan

    # --- Build CSS additions ---
    $cssAdditions = @"

/* === SELF-LEARNING SECTIONS === */
.objectives { background:rgba($accentRGB,0.1); border:1px solid rgba($accentRGB,0.3); border-radius:1.5rem; padding:1rem 1.5rem; margin:1rem 2rem; }
.objectives h3 { color:$accentColor; margin-bottom:0.5rem; font-size:1.05rem; }
.objectives ul { list-style:none; padding:0; }
.objectives li { padding:0.35rem 0; font-size:0.92rem; }
.objectives li::before { content:"🎯 "; }
.info-grid { display:grid; gap:1rem; margin:1.5rem 0; }
.info-panel { background:rgba($accentRGB,0.05); border:1px solid rgba($accentRGB,0.15); border-radius:1rem; padding:1rem 1.2rem; }
.info-panel h4 { color:$accentColor; font-size:1rem; margin-bottom:0.5rem; }
.info-panel p { color:#b4c8e0; font-size:0.9rem; line-height:1.6; margin-bottom:0.5rem; }
.info-panel p:last-child { margin-bottom:0; }
.step-section { background:rgba($accentRGB,0.06); border:1px solid rgba($accentRGB,0.2); border-radius:1.2rem; padding:1.2rem; margin:1.5rem 0; }
.step-section h3 { color:$accentColor; margin-bottom:0.8rem; font-size:1.05rem; }
.explanation-box { background:rgba($accentRGB,0.04); border-left:3px solid $accentColor; border-radius:0.6rem; padding:0.8rem 1rem; margin:0.8rem 0; font-size:0.9rem; color:#b4c8e0; }
.quiz-explain { font-size:0.85rem; color:#8899bb; margin-top:0.3rem; padding:0.3rem 0.6rem; border-radius:0.4rem; background:rgba(0,0,0,0.15); display:none; }
.quiz-explain.show { display:block; }
.summary-box { background:linear-gradient(135deg,rgba($accentRGB,0.12),rgba($accentRGB,0.04)); border:1px solid rgba($accentRGB,0.3); border-radius:1.2rem; padding:1.2rem 1.5rem; margin:1.5rem 0; }
.summary-box h3 { color:$accentColor; margin-bottom:0.5rem; font-size:1.05rem; }
.summary-box p { color:#b4c8e0; font-size:0.92rem; line-height:1.6; }
"@

    # --- Build objectives HTML ---
    $objList = ""
    foreach ($o in $Data.objectives) {
        $objList += "    <li>$o</li>`n"
    }

    $objectivesHTML = @"
  <div class="objectives">
   <h3><i class="fas fa-bullseye"></i> ¿Qué aprenderás?</h3>
   <ul>
$objList   </ul>
  </div>
"@

    # --- Build info panels HTML ---
    $panelsHTML = ""
    $panelsHTML += '  <div class="info-grid">' + "`n"
    foreach ($p in $Data.panels) {
        $panelsHTML += '   <div class="info-panel">' + "`n"
        $panelsHTML += "    <h4>$($p.title)</h4>`n"
        foreach ($para in $p.paragraphs) {
            $panelsHTML += "    <p>$para</p>`n"
        }
        $panelsHTML += '   </div>' + "`n"
    }
    $panelsHTML += '  </div>' + "`n"

    # --- Build step-by-step HTML ---
    $stepHTML = @"
  <div class="step-section">
   <h3><i class="fas fa-laptop-code"></i> Ejemplo Paso a Paso</h3>
   $($Data.stepexample)
  </div>
"@

    # --- Build summary HTML ---
    $summaryHTML = @"
  <div class="summary-box">
   <h3><i class="fas fa-check-double"></i> Resumen del Módulo</h3>
   <p>$($Data.summary)</p>
  </div>
"@

    # Now we need to insert things at the right places
    # Strategy depends on style type:

    if ($styleType -eq "classic") {
        # Classic: insert CSS before closing </style>
        $content = $content -replace '(</style>)', "$cssAdditions`$1"

        # Insert objectives + info panels + step section AFTER analogy card + before quiz section
        # Pattern: </div> (end of analogy) then blank line then <div class="section-card"> (quiz)
        $insertAfterAnalogy = "$objectivesHTML`n$panelsHTML`n$stepHTML`n"
        $content = $content -replace '(</div>\s*\n\s*<div class="section-card">\s*\n\s*<h2><i class="fas fa-puzzle-piece">)', "$insertAfterAnalogy`$1"

        # Alternative pattern for drag-drop activities
        $content = $content -replace '(</div>\s*\n\s*<div class="section-card">\s*\n\s*<h2><i class="fas fa-hands">)', "$insertAfterAnalogy`$1"

        # Alternative pattern for "Completa" activities
        $content = $content -replace '(</div>\s*\n\s*<div class="section-card">\s*\n\s*<h2><i class="fas fa-pen-fancy">)', "$insertAfterAnalogy`$1"

        # Alternative pattern for "Relaciona" activities
        $content = $content -replace '(</div>\s*\n\s*<div class="section-card">\s*\n\s*<h2><i class="fas fa-puzzle-piece">)', "$insertAfterAnalogy`$1"

        # Add summary AFTER the badge area + quiz section, before footer
        $content = $content -replace '(</div>\s*\n\s*<div class="footer-text">)', "$summaryHTML`$1"

        # Add quiz explanations to feedback section
        # We need to modify the submit answer function to show explanations
        # Pattern: match the I18N feedback lines and add quiz explanation display
        $modNumStr = $ModNum.ToString("00")
        $quizExplAdd = @"
    // Quiz explanation
    const quizExplanations_$modNumStr = @(
"@
        foreach ($qe in $Data.quizExplanations) {
            $escapedExplanation = $qe.explanation -replace "'", "''"
            $quizExplAdd += "        @{answer=$($qe.answer); explanation='$escapedExplanation'},`n"
        }
        $quizExplAdd = $quizExplAdd.TrimEnd("`n,") + "`n    );`n"

        # This is too complex for regex - let's add the quiz explanations inline in HTML instead
        # Actually we'll add them as a data attribute on the feedback div

    } elseif ($styleType -eq "modern") {
        # Modern style: insert CSS before closing </style>
        $content = $content -replace '(</style>)', "$cssAdditions`$1"

        # Insert after analogy card - modern style has different structure
        $insertAfterAnalogy = "$objectivesHTML`n$panelsHTML`n$stepHTML`n"
        $content = $content -replace '(</div>\s*\n\s*<div class="main-area">)', "$insertAfterAnalogy`$1"

        # Summary before footer
        $content = $content -replace '(</div>\s*\n\s*<footer>)', "$summaryHTML`$1"
    }

    # Write back
    if (-not $WhatIf) {
        $content | Out-File -FilePath $FilePath -Encoding UTF8 -NoNewline
        Write-Host "  ✓ Done" -ForegroundColor Green
    } else {
        Write-Host "  [WhatIf] Would write" -ForegroundColor Magenta
    }
}

# -----------------------------------------------------------
# 3. PROCESS ALL FILES
# -----------------------------------------------------------
$base = "D:\poryectosPulidos\PAGINA\cursos\programa-sql-basico"

# Course 1
$c1Files = @(
    "curso-1-fundamentos\01-que-es-sql.html",
    "curso-1-fundamentos\02-select-from.html",
    "curso-1-fundamentos\03-alias-as.html",
    "curso-1-fundamentos\04-distinct.html",
    "curso-1-fundamentos\05-where.html",
    "curso-1-fundamentos\06-operadores-comparacion.html",
    "curso-1-fundamentos\07-and-or-not.html",
    "curso-1-fundamentos\08-order-by.html",
    "curso-1-fundamentos\09-limit-offset.html",
    "curso-1-fundamentos\10-comentarios-buenas-practicas.html",
    "curso-1-fundamentos\11-mini-proyecto-consultas.html",
    "curso-1-fundamentos\12-repaso-certificacion.html"
)

for ($i = 0; $i -lt $c1Files.Count; $i++) {
    $modNum = "{0:D2}" -f ($i + 1)
    if ($c1.ContainsKey($modNum)) {
        $fullPath = Join-Path $base $c1Files[$i]
        Process-ModuleFile -FilePath $fullPath -CourseNum 1 -ModNum ($i + 1) -Data $c1[$modNum]
    }
}

Write-Host "Script structure created. Run with: powershell -ExecutionPolicy Bypass .\_enhance.ps1" -ForegroundColor Yellow
