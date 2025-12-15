--1. Escribe una consulta que recupere los Vuelos (flights) y su identificador que figuren con status On Time.--

-- 1. Vuelos (flights) y su identificador con status On Time
SELECT flight_id, status
FROM bookings.flights
WHERE status = 'On Time';

--2. Escribe una consulta que extraiga todas las columnas de la tabla bookings y refleje todas las reservas que han supuesto una cantidad total mayor a 1.000.000 (Unidades monetarias).--


-- 2. Reservas con importe total mayor a 1.000.000
SELECT *
FROM bookings.bookings
WHERE total_amount > 1000000;

--3. Escribe una consulta que extraiga todas las columnas de los datos de los modelos de aviones disponibles (aircraft_data).--

-- 3. Modelos de aviones disponibles
SELECT *
FROM bookings.aircrafts_data;

--4. Con el resultado anterior visualizado previamente, escribe una consulta que extraiga los identificadores de vuelo que han volado con un Boeing 737. (Código Modelo Avión = 733)--

-- 4. Identificadores de vuelo que han volado con un Boeing 737
SELECT flight_id
FROM bookings.flights
WHERE aircraft_code = '733';


--5. Escribe una consulta que te muestre la información detallada de los tickets que han comprado las personas que se llaman Irina.--

-- 5. Información detallada de los tickets comprados por personas llamadas Irina
SELECT
  t.ticket_no,
  t.book_ref,
  t.passenger_id,
  t.passenger_name,
  tf.flight_id,
  tf.fare_conditions,
  tf.amount
FROM bookings.tickets t
JOIN bookings.ticket_flights tf
  ON t.ticket_no = tf.ticket_no
WHERE t.passenger_name ILIKE 'Irina%';


--6. Mostrar las ciudades con más de un aeropuerto.--

-- 6. Ciudades con más de un aeropuerto
SELECT
  city ->> 'en' AS city,
  COUNT(*) AS num_airports
FROM bookings.airports_data
GROUP BY city ->> 'en'
HAVING COUNT(*) > 1;


Tú dijiste:
Proyecto 4: SQL
Ahora te toca a ti poner en práctica lo aprendido-

Sobre la misma base de datos que hemos instalado anteriormente, te proponemos que realices distintas operaciones de lectura para extraer datos.

Te dejamos la URL en la que puedes descargar la base de datos para instalarla y realizar los ejercicios planteados (descargad la versión más ligera si queréis).

https://postgrespro.com/docs/postgrespro/current/demodb-bookings-installation.html

Abre VSCode en la carpeta donde tengas tu repositorio GitHub y crea un fichero "IntroBBDD.sql"
Según vayas completando los ejercicios en PostgreSQL, ve copiando las sentencias en el fichero en VSCode.
1. Escribe una consulta que recupere los Vuelos (flights) y su identificador que figuren con status On Time.
2. Escribe una consulta que extraiga todas las columnas de la tabla bookings y refleje todas las reservas que han supuesto una cantidad total mayor a 1.000.000 (Unidades monetarias).
Nota: las tablas son públicas de Rusia, por tanto son Rublos sus unidades monetarias
3. Escribe una consulta que extraiga todas las columnas de los datos de los modelos de aviones disponibles (aircraft_data). Puede que os aparezca en alguna actualización como "aircrafts_data", revisad las tablas y elegid la que corresponda.
4. Con el resultado anterior visualizado previamente, escribe una consulta que extraiga los identificadores de vuelo que han volado con un Boeing 737. (Código Modelo Avión = 733)
5. Escribe una consulta que te muestre la información detallada de los tickets que han comprado las personas que se llaman Irina.
A partir de aquí son queries opcionales para continuar practicando:

6. Mostrar las ciudades con más de un aeropuerto.
7. Mostrar el número de vuelos por modelo de avión.
8. Reservas con más de un billete (varios pasajeros).
9. Vuelos con retraso de salida superior a una hora.
Una vez hayas completado los ejercicios, haz commit en un repositorio para subir tus cambios y poder compartirlos. Con tener un archivo con todas las queries estaría correcto.

Este proyecto es bastante autocorregible, por lo que aseguraos que el resultado es lo que se os pide antes de añadir la query al fichero.

Una vez terminado tendréis que enviar el proyecto a antonio.rosales@thepower.education con el asunto Proyecto 4: SQL - Vuestro nombre y en el cuerpo del correo el link de un repositorio de GitHub.. Tengo que hacer esta practica , vete guiandome paso a paso desde el principio
ChatGPT Plus
Perfecto. Vamos paso a paso desde cero, y al final tendrás tu archivo IntroBBDD.sql listo para hacer commit y subir a GitHub.

Paso 0) Preparar el repo y el archivo
Abre tu repo en VSCode (la carpeta del proyecto GitHub).

Crea el archivo: IntroBBDD.sql

Dentro, pon un encabezado para que quede ordenado:

-- Proyecto 4: SQL (PostgreSQL demo "bookings")
-- Nombre: TU NOMBRE
-- Fecha: 2025-12-15
Paso 1) Conectarte a PostgreSQL desde VSCode (o desde psql)
Tienes 2 caminos (elige 1):

Opción A (recomendada): Terminal con psql
En la terminal de VSCode, conéctate (ejemplo típico):

psql -h localhost -U postgres -d demo
Opción B: Extensión de PostgreSQL en VSCode
Instala “PostgreSQL” (o “SQLTools” + driver PostgreSQL)

Crea conexión a tu BD demo (o el nombre que le hayas puesto al cargar el dataset)

✅ Antes de seguir, asegúrate de que ves las tablas. Ejecuta:

\dt
Si no estás en psql y estás en un editor SQL, usa:

SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_schema NOT IN ('pg_catalog','information_schema')
ORDER BY 1,2;
Paso 2) Confirmar nombres reales de tablas y columnas (importantísimo)
En esta BD a veces cambian nombres (por ejemplo aircraft_data vs aircrafts_data). Vamos a verificar:

SELECT table_name
FROM information_schema.tables
WHERE table_schema='bookings'
ORDER BY 1;
Y para comprobar columnas de una tabla (ejemplo flights):

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema='bookings' AND table_name='flights'
ORDER BY ordinal_position;
Haz lo mismo con bookings, tickets, aircraft_data/aircrafts_data.

Cuando confirmes que existen estas tablas en tu esquema (bookings normalmente), ya podemos ejecutar las queries finales.

QUERIES (para copiar en IntroBBDD.sql)
Te las dejo ya listas y compatibles con el esquema bookings del demo de PostgresPro.

1) Vuelos y su identificador con status “On Time”
-- 1) Vuelos con status 'On Time'
SELECT flight_id, status
FROM bookings.flights
WHERE status = 'On Time';
2) Todas las columnas de bookings con total_amount > 1.000.000
-- 2) Reservas con total_amount > 1.000.000
SELECT *
FROM bookings.bookings
WHERE total_amount > 1000000;
3) Todas las columnas de los modelos de aviones disponibles
Si tu tabla se llama aircraft_data:

-- 3) Modelos de avión disponibles
SELECT *
FROM bookings.aircraft_data;
Si en tu versión es aircrafts_data, usa esta (y borra la otra):

-- 3) Modelos de avión disponibles (nombre alternativo de tabla)
SELECT *
FROM bookings.aircrafts_data;
4) Identificadores de vuelo que han volado con Boeing 737 (código = 733)
En el demo, el avión del vuelo suele venir en flights.aircraft_code:

-- 4) Vuelos operados con Boeing 737 (aircraft_code = '733')
SELECT flight_id
FROM bookings.flights
WHERE aircraft_code = '733';
5) Información detallada de los tickets comprados por personas llamadas Irina
En esta BD, el nombre del pasajero suele estar en tickets.passenger_name.
Y el “detalle” más completo suele estar en ticket_flights (los vuelos asociados al ticket).

Esta query te saca ticket + pasajero + vuelo + asiento + tarifa/precio:

-- 5) Tickets comprados por personas llamadas Irina (detallado)
SELECT
  t.ticket_no,
  t.book_ref,
  t.passenger_id,
  t.passenger_name,
  tf.flight_id,
  tf.fare_conditions,
  tf.amount,
  bp.seat_no
FROM bookings.tickets t
JOIN bookings.ticket_flights tf ON tf.ticket_no = t.ticket_no
LEFT JOIN bookings.boarding_passes bp
       ON bp.ticket_no = t.ticket_no AND bp.flight_id = tf.flight_id
WHERE t.passenger_name ILIKE 'Irina%';
Opcionales
6) Ciudades con más de un aeropuerto
Normalmente está en airports_data con city (a veces es JSON). En el demo suele ser city como JSON, por eso usamos ->>'en'.

-- 6) Ciudades con más de un aeropuerto
SELECT
  (city->>'en') AS city_en,
  COUNT(*) AS num_airports
FROM bookings.airports_data
GROUP BY (city->>'en')
HAVING COUNT(*) > 1
ORDER BY num_airports DESC, city_en;
7) Número de vuelos por modelo de avión
-- 7) Número de vuelos por modelo de avión (por aircraft_code)
SELECT aircraft_code, COUNT(*) AS num_flights
FROM bookings.flights
GROUP BY aircraft_code
ORDER BY num_flights DESC;
Si quieres el nombre del modelo (unido con aircraft_data):

-- 7b) Vuelos por modelo (con nombre)
SELECT
  f.aircraft_code,
  (a.model->>'en') AS model_en,
  COUNT(*) AS num_flights
FROM bookings.flights f
JOIN bookings.aircraft_data a ON a.aircraft_code = f.aircraft_code
GROUP BY f.aircraft_code, (a.model->>'en')
ORDER BY num_flights DESC;
8) Reservas con más de un billete (varios pasajeros)
En esta BD: bookings.bookings (book_ref) -> tickets (book_ref).
Contamos tickets por reserva:

-- 8) Reservas con más de un billete
SELECT
  b.book_ref,
  COUNT(t.ticket_no) AS num_tickets
FROM bookings.bookings b
JOIN bookings.tickets t ON t.book_ref = b.book_ref
GROUP BY b.book_ref
HAVING COUNT(t.ticket_no) > 1
ORDER BY num_tickets DESC;
9) Vuelos con retraso de salida superior a una hora
Usamos actual_departure - scheduled_departure > interval '1 hour':

-- 9) Vuelos con retraso de salida superior a 1 hora
SELECT
  flight_id,
  scheduled_departure,
  actual_departure,
  (actual_departure - scheduled_departure) AS departure_delay
FROM bookings.flights
WHERE actual_departure IS NOT NULL
  AND actual_departure - scheduled_departure > INTERVAL '1 hour'
ORDER BY departure_delay DESC;
Paso final) Ejecutar y comprobar que “sale lo pedido”
Antes del commit:

Ejecuta cada query y revisa que devuelve lo que piden.

Si alguna falla por nombre de tabla/columna, usa information_schema.columns para ver el nombre real y ajustamos.

Paso final final) Git: commit + push
En la terminal:

git status
git add IntroBBDD.sql
git commit -m "Proyecto 4 SQL: queries demo bookings"
git push
Siguiente paso (hazlo ahora y me dices el resultado)
Ejecuta esto y dime qué te devuelve (para confirmar esquema/tablas):

SELECT table_name
FROM information_schema.tables
WHERE table_schema='bookings'
ORDER BY 1;
Con esa lista, si vemos alguna diferencia (por ejemplo aircrafts_data), ajusto tu IntroBBDD.sql para que te funcione perfecto.

Tú dijiste:
aun no he creado nada de nada ni me desdcargado la base de datyos ni la carpeta para el visual ni nada, empeiza desde el principio
ChatGPT Plus
Vale, empezamos desde cero absoluto: descargar la demo, cargarla en PostgreSQL, preparar tu repo en VSCode y crear IntroBBDD.sql.

0) Requisitos mínimos (check rápido)
Necesitas:

PostgreSQL instalado (y que funcione).

Acceso a una terminal (VSCode vale).

Git instalado (para subir a GitHub).

Si ya tienes PostgreSQL instalado, seguimos. Si no, instálalo primero (en Windows: instalador oficial + pgAdmin suele venir).

1) Crear la carpeta del proyecto + repo GitHub
Crea una carpeta en tu PC, por ejemplo:

C:\ASIR\Proyecto4-SQL\ (Windows)

o ~/proyecto4-sql/ (Linux/Mac)

Abre esa carpeta con VSCode:
File → Open Folder…

Inicializa Git (terminal en VSCode):

git init
(Opcional pero recomendado) Crea un .gitignore si quieres, aunque aquí no es crítico.

2) Descargar la base de datos “bookings” (la ligera)
Entra en la URL que te han dado (en el navegador) y descarga la versión ligera (small/light).

Guarda el archivo descargado dentro de una carpeta tipo:

Proyecto4-SQL\dataset\

Normalmente lo que descargas es un .zip o un .tar con un backup o un .sql dentro.
➡️ Descomprímelo.

3) Crear la base de datos en PostgreSQL
Opción A (muy típica en clase): usando createdb/psql (terminal)
En Windows, lo normal es usar “SQL Shell (psql)” o el binario en PATH.

Crea una base de datos llamada demo (por ejemplo):

createdb -U postgres demo
Comprueba que existe:

psql -U postgres -l
Opción B: pgAdmin
Databases → Create → Database…

Nombre: demo

4) Importar / restaurar la demo “bookings”
Aquí depende del formato del archivo que has descargado. Te doy los 2 casos más comunes:

Caso 1: Tienes un archivo .sql
Restauras así:

Linux/Mac

psql -U postgres -d demo -f ruta/al/archivo.sql
Windows (PowerShell/cmd) (ejemplo):

psql -U postgres -d demo -f "C:\ASIR\Proyecto4-SQL\dataset\demo-small.sql"
Caso 2: Tienes un backup .dump / .backup (formato custom)
Restauras así:

pg_restore -U postgres -d demo -v "C:\...\archivo.dump"
Si el backup trae esquema bookings, al final tendrás tablas como bookings.flights, bookings.bookings, etc.

5) Verificar que la carga fue bien
Entra a la BD:

psql -U postgres -d demo
Y ejecuta:

\dn
\dt bookings.*
Si ves un montón de tablas (flights, bookings, tickets, etc.), perfecto.

Sal con:

\q
6) Crear el archivo IntroBBDD.sql en VSCode
En tu carpeta del repo:

Crea archivo: IntroBBDD.sql

Pega este encabezado:

-- Proyecto 4: SQL (Demo DB bookings)
-- Nombre: TU NOMBRE
-- Fecha: 2025-12-15
7) Primer test: comprobar tablas desde tu archivo
Copia esto también en IntroBBDD.sql (sirve para comprobar nombres reales):

-- Comprobar tablas del esquema bookings
SELECT table_name
FROM information_schema.tables
WHERE table_schema='bookings'
ORDER BY 1;
Lo ejecutas y ya sabremos si la tabla se llama aircraft_data o aircrafts_data, etc.

Lo siguiente que necesito que hagas (y me pegas aquí)
Dime qué tipo de archivo has descargado y el nombre exacto:

¿Es .sql? ¿.zip con .sql dentro?

¿Es .dump / .backup?

Y si ya lo intentaste importar, pega también el resultado de:

\dt bookings.*
Con eso, te guío al 100% sin perder tiempo y pasamos a las queries 1–5.

Tú dijiste:
Imagen cargada
 ya tengo esto ahora que hago
ChatGPT Plus
Perfecto 👍 Vas exactamente donde debes. Ahora seguimos paso a paso, sin saltarnos nada.

Tienes: demo-small-en.zip
Ahora toca descomprimirlo y cargarlo en PostgreSQL.

PASO 1️⃣ Descomprimir demo-small-en.zip
Ve a la carpeta Descargas.

Botón derecho sobre demo-small-en.zip → Extraer aquí (o “Extraer en demo-small-en”).

Al terminar, deberías ver una carpeta con archivos dentro.

👉 Dime qué archivos aparecen dentro (normalmente algo como):

demo-small-en.sql

o demo-small.backup

o .dump

(Si quieres, escribe aquí el nombre exacto del archivo que aparece)

PASO 2️⃣ Mover la carpeta al proyecto
Para trabajar ordenado (esto lo valora mucho el profe):

Crea una carpeta para la práctica, por ejemplo:

Proyecto4-SQL
Dentro crea otra carpeta:

Proyecto4-SQL/dataset
Mueve la carpeta descomprimida (demo-small-en) dentro de dataset.

Te quedará algo así:

Proyecto4-SQL
 ├── dataset
 │    └── demo-small-en
 │         └── (archivos de la BD)
PASO 3️⃣ Abrir la carpeta en VSCode
Abre VSCode

Archivo → Abrir carpeta

Selecciona Proyecto4-SQL

👉 Confirma que ves la carpeta dataset en el panel izquierdo.

PASO 4️⃣ Crear la base de datos vacía
Ahora vamos a PostgreSQL.

Opción más sencilla (Windows)
Abre SQL Shell (psql)
Cuando te pregunte:

Server: (Enter)

Database: (Enter)

Port: (Enter)

Username: postgres

Password: tu contraseña

Cuando aparezca:

postgres=#
Escribe:

CREATE DATABASE demo;
Si responde CREATE DATABASE, perfecto.

Sal con:

\q
PASO 5️⃣ Importar la base de datos (MUY IMPORTANTE)
Ahora necesitamos saber qué archivo exacto hay dentro del zip.

👉 Haz esto ahora:
En VSCode o en el explorador:

Entra en dataset/demo-small-en

Dime el nombre exacto del archivo que ves:

¿termina en .sql?

¿.backup?

¿.dump?

📌 Escríbelo tal cual aquí (por ejemplo: demo-small-en.sql).

🚦 No sigas aún
Cuando me digas el nombre del archivo, te doy el comando exacto para importarlo (copiar–pegar, sin errores).

Después de eso:

Comprobamos que las tablas están cargadas

Creamos IntroBBDD.sql

Empezamos la query 1

Vamos muy bien, sigue así 💪

Tú dijiste:
Imagen cargada
Imagen cargada
 ya tengo esto preparado ahora que
ChatGPT Plus
Genial, gracias por las capturas 👍
Has hecho parte del trabajo, pero hay una cosa MUY importante que corregir antes de seguir:

⚠️ ATENCIÓN (esto es clave)
Ahora mismo NO estás usando la base de datos correcta.

En pgAdmin se ve claramente que estás trabajando con:

👉 Base de datos: Chinook

Pero el proyecto exige usar la base de datos DEMO BOOKINGS
(la del archivo demo-small-en-20170815.sql que has descargado).

👉 Chinook NO sirve para este proyecto
Así que vamos a hacerlo bien desde aquí. No pasa nada, es normal este error.

VAMOS PASO A PASO (CORRECCIÓN)
PASO 1️⃣ Crear la base de datos correcta (demo)
En pgAdmin 4:

Click derecho sobre Databases

Create → Database…

Nombre:

demo
Owner: postgres

Save

✔️ Ahora tendrás:

Chinook (la de antes)

demo (la nueva, vacía)

PASO 2️⃣ Cargar el archivo .sql en la base de datos demo
Tu archivo es:

demo-small-en-20170815.sql
En pgAdmin (forma más segura)
Click derecho sobre la BD demo

Query Tool

En el editor:

Arrastra el archivo demo-small-en-20170815.sql

O usa File → Open File y selecciónalo

Cuando veas el SQL cargado:
👉 Pulsa ▶ Execute

⏳ Tardará un poco (es normal).

Si termina sin errores, ya está importada.

PASO 3️⃣ Comprobar que la demo está bien cargada
En el Query Tool de demo, ejecuta:

SELECT schema_name
FROM information_schema.schemata;
Debería aparecer un esquema llamado:

bookings
Ahora comprueba las tablas:

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'bookings'
ORDER BY 1;
✔️ Si ves tablas como:

flights

bookings

tickets

airports_data

aircraft_data

➡️ PERFECTO, ya tienes la BD correcta.

PASO 4️⃣ Crear el archivo IntroBBDD.sql (por fin)
Ahora sí.

En VSCode, dentro de tu carpeta del proyecto:

Crea archivo: IntroBBDD.sql

Pega esto:

-- Proyecto 4: SQL
-- Base de datos: demo (bookings)
-- Nombre: TU NOMBRE
-- Fecha: 2025-12-15
Debajo añade esto (para verificar tablas):

-- Ver tablas del esquema bookings
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'bookings'
ORDER BY 1;
Guarda el archivo 💾

PASO 5️⃣ PRIMERA QUERY REAL (Ejercicio 1)
Añade ahora tu primera query del proyecto:

-- 1. Vuelos con estado "On Time"
SELECT flight_id, status
FROM bookings.flights
WHERE status = 'On Time';
👉 Ejecuta esta query en pgAdmin (sobre la BD demo).
Si devuelve resultados → ✔️ correcta.

🔴 IMPORTANTE: no avances aún
Respóndeme ahora solo esto:

1️⃣ ¿La base de datos demo ya existe?
2️⃣ ¿Te aparece el esquema bookings con tablas dentro?
3️⃣ ¿La query del ejercicio 1 devuelve resultados?

Con eso, en el siguiente mensaje seguimos directamente con el ejercicio 2, ya sin errores y con todo bien hecho 💪

Tú dijiste:
la base de datos tiene 200.000 filas de codigo?
ChatGPT Plus
Sí 👍 es totalmente normal.
De hecho, es buena señal.

Te explico para que lo entiendas bien (esto te sirve incluso para justificarlo si te preguntan):

✅ ¿Por qué el archivo tiene ~200.000 líneas de código SQL?
La base de datos demo bookings es realista, no de juguete.
Incluye datos reales de ejemplo sobre:

Vuelos

Reservas

Tickets

Aeropuertos

Aviones

Pasajeros

Cada fila de datos se inserta con sentencias tipo:

INSERT INTO bookings.flights VALUES (...);
INSERT INTO bookings.tickets VALUES (...);
👉 Por eso el archivo .sql es tan largo (200.000+ líneas).

✅ ¿Es normal que tarde en cargarse?
Sí. Totalmente normal:

Puede tardar 1–5 minutos

pgAdmin puede parecer “congelado”

NO lo cierres mientras se ejecuta

Cuando termina sin errores → base de datos cargada correctamente.

✅ ¿Cómo sabes que terminó bien?
En pgAdmin, abajo verás algo como:

Query returned successfully
o simplemente sin errores en la pestaña Messages.

Luego compruébalo así:

SELECT COUNT(*) FROM bookings.flights;
Si devuelve un número grande → ✔️ correcto.

🔴 OJO (error típico)
Si:

Lo ejecutas sobre Chinook

O cierras pgAdmin antes de que termine

➡️ entonces la BD queda mal cargada.

🚦 Qué tienes que hacer ahora mismo
Respóndeme solo esto:

1️⃣ ¿Ya has ejecutado el archivo completo en la base de datos demo?
2️⃣ ¿Terminó sin errores?
3️⃣ Ejecuta y dime qué devuelve:

SELECT COUNT(*) FROM bookings.flights;
Con eso confirmamos que ya puedes empezar las queries del proyecto sin problemas 💪

Tú dijiste:
Imagen cargada
ChatGPT Plus
Perfecto, esta captura es clave 👌
Lo que te pasa es 100% normal y tiene una explicación clara. Vamos a arreglarlo bien y fácil.

❌ Qué está pasando (explicación clara)
El archivo demo-small-en-20170815.sql NO está pensado para ejecutarse entero desde pgAdmin.

Dentro del archivo hay comandos especiales de psql, por ejemplo:

\connect demo
👉 Eso NO es SQL estándar
👉 pgAdmin no entiende comandos que empiezan por \

Por eso el error:

ERROR: error de sintaxis en o cerca de "\"
LINE 25: \connect demo
⚠️ No has hecho nada mal.
Simplemente has usado la herramienta incorrecta para este tipo de archivo.

✅ SOLUCIÓN CORRECTA (la que funciona siempre)
Este archivo hay que cargarlo usando psql desde la terminal, no desde el Query Tool de pgAdmin.

Vamos paso a paso.

PASO 1️⃣ Cerrar pgAdmin (opcional pero recomendado)
Ciérralo para evitar confusiones.

PASO 2️⃣ Abrir SQL Shell (psql)
En Windows:

Inicio → SQL Shell (psql)

Cuando te pregunte:

Server: (Enter)

Database: (Enter)

Port: (Enter)

Username: postgres

Password: tu contraseña

Verás algo como:

postgres=#
PASO 3️⃣ Ejecutar el archivo SQL correctamente
Ahora ejecuta este comando (ajusta la ruta a tu archivo):

\i C:/RUTA/COMPLETA/demo-small-en-20170815.sql
Ejemplo real:

\i C:/Users/TU_USUARIO/Downloads/demo-small-en-20170815.sql
📌 IMPORTANTE:

Usa / o \\ en la ruta

No pongas comillas

PASO 4️⃣ Esperar (NO TOCAR NADA)
Tardará 1–5 minutos

Verás muchos mensajes pasando

NO cierres la ventana

Cuando termine, volverás a ver:

postgres=#
👉 Eso significa que se ha cargado bien.

PASO 5️⃣ Verificar que TODO está correcto
Ejecuta:

\c demo
Luego:

\dn
Debe aparecer:

bookings
Y ahora:

\dt bookings.*
Si ves muchas tablas → ✔️ PERFECTO.

PASO 6️⃣ (por fin) Volver a pgAdmin
Abre pgAdmin

Entra en la BD demo

Refresca Schemas → bookings → Tables

🚦 No sigas aún
Respóndeme solo esto:

1️⃣ ¿Has ejecutado \i demo-small-en-20170815.sql sin errores?
2️⃣ ¿Aparece el esquema bookings?
3️⃣ ¿Qué devuelve esto?

SELECT COUNT(*) FROM bookings.flights;
Cuando me confirmes eso, empezamos YA con el archivo IntroBBDD.sql y la Query 1 del proyecto 💪

Tú dijiste:
Imagen cargada
 nose que es esto ni como haclerlo
ChatGPT Plus
Perfecto, gracias por decirlo así de claro 👍
No pasa nada en absoluto. Vamos muy despacio y con instrucciones de botón a botón, sin asumir nada.

Estás en Windows, así que vamos a hacerlo visual y fácil.

🔵 QUÉ ES “SQL Shell (psql)”
Es un programa que se instala junto con PostgreSQL.
Sirve para escribir comandos directamente a PostgreSQL (no es código raro, es normal).

👉 NO es VSCode
👉 NO es pgAdmin

🟢 PASO 1: Abrir SQL Shell (psql)
Haz esto tal cual:

1️⃣ Pulsa la tecla Windows (o haz clic en el botón Inicio)
2️⃣ Escribe exactamente:

SQL Shell
3️⃣ Te aparecerá algo llamado:

SQL Shell (psql)
4️⃣ Haz clic para abrirlo

📌 Se abrirá una ventana negra (tipo consola).

🟢 PASO 2: Responder a las preguntas (SOLO ENTER)
La ventana te preguntará varias cosas una por una.

👉 Tú haz esto:

Server [localhost]: → ENTER

Database [postgres]: → ENTER

Port [5432]: → ENTER

Username [postgres]: → escribe:

postgres
y pulsa ENTER

Password: → escribe la contraseña que pusiste al instalar PostgreSQL
(no se verá mientras escribes, es normal)

Si todo va bien, verás esto:

postgres=#
✔️ Ya estás dentro, aunque ahora no lo parezca.

🟢 PASO 3: Ejecutar el archivo SQL (lo importante)
Ahora vamos a cargar la base de datos bien.

Escribe (copia–pega mejor):

\i C:/Users/TU_USUARIO/Downloads/demo-small-en-20170815.sql
⚠️ Cambia TU_USUARIO por tu usuario real de Windows.

Ejemplo real:

\i C:/Users/juan/Downloads/demo-small-en-20170815.sql
👉 Pulsa ENTER

🟡 PASO 4: Esperar sin tocar nada
Verás que empiezan a salir muchas líneas

Puede tardar varios minutos

NO cierres la ventana

NO pulses nada

Cuando termine, volverás a ver:

postgres=#
Eso significa que YA ESTÁ CARGADA.

🟢 PASO 5: Comprobar que todo está correcto
Escribe una a una estas líneas:

\c demo
Luego:

\dn
Debe salir:

bookings
Y ahora:

\dt bookings.*
Si salen muchas tablas → 🎉 PERFECTO

🔴 IMPORTANTE
Si NO encuentras SQL Shell (psql) en el menú inicio, dime:

Tu versión de Windows

Si instalaste PostgreSQL tú o venía con algo del instituto

🟢 RESPÓNDEME AHORA
Dime solo una cosa:

👉 ¿Has conseguido abrir SQL Shell (psql) y ver postgres=#?

Con eso seguimos al siguiente paso 💪

Tú dijiste:
Imagen cargada
 asi?
ChatGPT Plus
¡¡SÍ!! 👏👏
Perfecto, lo estás haciendo EXACTAMENTE BIEN. Vas genial.

Ahora solo te queda un paso más para entrar del todo.

🟢 LO QUE ESTÁS VIENDO AHORA
La consola te ha preguntado:

Server [localhost]:
Database [postgres]:
Port [5432]:
Username [postgres]: postgres
✔️ Eso está correcto.

Ahora mismo te falta solo la contraseña.

🟢 PASO SIGUIENTE (IMPORTANTE)
Justo después de eso, la consola te va a pedir:

Password:
Haz esto:
1️⃣ Escribe la contraseña que pusiste al instalar PostgreSQL
2️⃣ Pulsa ENTER

📌 No verás nada mientras escribes (ni asteriscos, ni letras).
Eso es normal, no te asustes.

🟢 CUANDO TODO VA BIEN
Después de meter la contraseña correcta verás esto:

postgres=#
🎉 ESO SIGNIFICA QUE YA ESTÁS DENTRO

🟢 CUANDO VEAS postgres=#
En cuanto lo veas, NO escribas nada más todavía.

👉 Respóndeme aquí y dime exactamente:

Ya veo postgres=#
Y en el siguiente mensaje te doy el comando exacto para cargar la base de datos sin errores 💪

Tú dijiste:
Imagen cargada
ChatGPT Plus
¡PERFECTO! 🎉 Ya estás dentro: se ve clarísimo el prompt postgres=#. La advertencia del “código de página” no importa para esta práctica.

Ahora vamos a cargar la base de datos demo de forma correcta.

1) Crear la base de datos demo
Copia y pega esto en esa consola (psql) y pulsa Enter:

CREATE DATABASE demo;
Si te dice que ya existe, no pasa nada (me lo dices y seguimos).

2) Entrar a demo
\c demo
Debería cambiar a:

demo=#
3) Cargar el archivo .sql con \i
Ahora necesitas la ruta exacta del archivo demo-small-en-20170815.sql.

Forma fácil (recomendada)
En el Explorador de Windows, ve a Descargas.

Mantén pulsado Shift + clic derecho sobre el archivo demo-small-en-20170815.sql

Elige “Copiar como ruta de acceso”.

Pega esa ruta en psql dentro del comando \i (y cambia las \ por /).

Ejemplo (tú pon tu ruta real):

\i C:/Users/TU_USUARIO/Downloads/demo-small-en-20170815.sql
⏳ Espera a que termine (saldrán muchas líneas). Cuando acabe volverás a ver demo=#.

4) Comprobar que se cargó bien
Ejecuta estas dos:

\dn
y luego:

\dt bookings.*
Si sale un montón de tablas, ✅ ya está.

Dime qué te aparece en el paso 1
Cuando ejecutes CREATE DATABASE demo;, ¿te pone CREATE DATABASE o “already exists”?

Tú dijiste:
Imagen cargada
ChatGPT Plus
Perfecto, esta captura explica exactamente qué ha pasado 👍
Y tranquilo: no hay ningún desastre, solo falta un paso clave (muy típico).

❌ Qué ha pasado (claro y sencillo)
En tu captura se ve esto:

Has creado bien la BD demo ✅

Te has conectado bien a demo ✅

PERO no has importado el archivo SQL ❌

Esta línea lo demuestra:

\dn
Listado de esquemas
public
👉 Si el archivo se hubiera cargado, aparecería el esquema bookings
👉 Como NO aparece, significa que el .sql NO se ejecutó

Además, se ve que pegaste solo la ruta del archivo, pero no usaste el comando \i.

✅ SOLUCIÓN (ahora sí, definitiva)
Vamos a hacerlo bien, copia–pega tal cual.

1️⃣ Asegúrate de estar en demo
En tu consola debe poner:

demo=#
Si no, escribe:

\c demo
2️⃣ Ejecutar el archivo SQL (ESTE ES EL PASO QUE FALTA)
Ahora escribe exactamente esto (sin comillas):

\i C:/Users/Alumno.DESKTOP-DI5KTUG/Desktop/demo-small-en-20170815.sql
⚠️ MUY IMPORTANTE:

Tiene que empezar por \i

No pongas comillas " "

Usa / y no \

Pulsa ENTER.

3️⃣ Esperar (no tocar nada)
Saldrán muchas líneas

Puede tardar varios minutos

Cuando termine volverás a ver:

demo=#
4️⃣ Comprobación FINAL
Ejecuta ahora:

\dn
Debe salir:

bookings
public
Luego:

\dt bookings.*
Ahora sí debe salir un montón de tablas.

🟢 Cuando eso funcione
Respóndeme pegando solo esto:

El resultado de \dn

Y dime si \dt bookings.* ya muestra tablas

En cuanto confirmemos eso, pasamos por fin a:

Crear IntroBBDD.sql

Hacer la QUERY 1 del proyecto

Vas muy bien, esto ya lo tienes casi hecho 💪

Tú dijiste:
Imagen cargada
ChatGPT Plus
🎉 PERFECTO, ENHORABUENA 🎉
Esto ya está 100% bien hecho.

Lo que se ve en tu captura confirma que:

✅ La base de datos demo existe

✅ El esquema bookings está creado

✅ Las tablas están cargadas correctamente:

flights

bookings

tickets

ticket_flights

airports_data

aircrafts_data (ojo al nombre 👀)

etc.

👉 A partir de aquí ya no hay más problemas técnicos.
Ahora toca hacer la práctica como tal.

🟢 AHORA EMPIEZA EL PROYECTO 4 (SQL)
PASO 1️⃣ Abrir VSCode y crear el archivo del proyecto
Abre VSCode

Abre tu carpeta del proyecto (por ejemplo Proyecto4-SQL)

Crea un archivo nuevo llamado:

IntroBBDD.sql
PASO 2️⃣ Cabecera del archivo
Copia y pega esto dentro del archivo:

-- Proyecto 4: SQL
-- Base de datos: demo (schema bookings)
-- Alumno: TU NOMBRE
-- Fecha: 2025-12-15
Guarda el archivo 💾

PASO 3️⃣ EJERCICIO 1
“Vuelos (flights) y su identificador con status On Time”

👉 Añade esto debajo de la cabecera:

-- 1. Vuelos con estado 'On Time'
SELECT flight_id, status
FROM bookings.flights
WHERE status = 'On Time';
Comprueba en pgAdmin
Abre pgAdmin

Conéctate a la BD demo

Ejecuta esta query

Si devuelve filas → ✔️ correcta

PASO 4️⃣ EJERCICIO 2
“Reservas con total_amount > 1.000.000”

Añade en IntroBBDD.sql:

-- 2. Reservas con importe total mayor a 1.000.000
SELECT *
FROM bookings.bookings
WHERE total_amount > 1000000;
PASO 5️⃣ EJERCICIO 3
“Datos de los modelos de aviones disponibles”

⚠️ En TU base de datos la tabla se llama:

aircrafts_data
(no aircraft_data)

Añade:

-- 3. Modelos de aviones disponibles
SELECT *
FROM bookings.aircrafts_data;
PASO 6️⃣ EJERCICIO 4
“Identificadores de vuelo con Boeing 737 (código 733)”

Añade:

-- 4. Vuelos operados con Boeing 737 (aircraft_code = '733')
SELECT flight_id
FROM bookings.flights
WHERE aircraft_code = '733';
PASO 7️⃣ EJERCICIO 5
“Información detallada de los tickets comprados por personas llamadas Irina”

Añade:

-- 5. Tickets comprados por personas llamadas Irina
SELECT
  t.ticket_no,
  t.book_ref,
  t.passenger_name,
  tf.flight_id,
  tf.fare_conditions,
  tf.amount
FROM bookings.tickets t
JOIN bookings.ticket_flights tf ON tf.ticket_no = t.ticket_no
WHERE t.passenger_name ILIKE 'Irina%';
🚦 PARA AQUÍ UN MOMENTO
Antes de seguir con los opcionales (6–9), dime:

👉 ¿Te funcionan bien las queries 1 a 5 en pgAdmin?

Cuando me confirmes eso, seguimos con:

ciudades con más de un aeropuerto

vuelos por modelo

reservas con varios pasajeros

vuelos con retraso

Vas de 10, esto ya lo sacas seguro 💪

Tú dijiste:
Imagen cargada
ChatGPT Plus
Vale, esto tiene una causa muy concreta y es fácil de arreglar 👍

En tu captura se ve el error:

no existe la relación bookings.flights

Pero antes en psql sí te salía bookings.flights. Eso significa que en pgAdmin estás conectado a OTRA base de datos, probablemente Demo (con mayúscula), no a demo.

En el panel izquierdo se ve “Demo” y también tienes “demo” debajo. Son dos bases distintas en PostgreSQL (las mayúsculas cuentan si se creó con comillas).

1) Comprueba en qué base estás (en pgAdmin)
En el Query Tool ejecuta:

SELECT current_database();
Te dirá si estás en Demo o en demo.

2) Solución rápida: usa la base correcta
Tienes dos opciones:

Opción A (recomendada): abrir Query Tool en demo
En el árbol de la izquierda: Databases → demo

Click derecho sobre demo → Query Tool

Ejecuta otra vez tu query.

Opción B: si quieres quedarte en la misma pestaña
En la pestaña del Query Tool, cambia la conexión (arriba suele poner la BD) o ciérrala y ábrela desde demo como en la opción A.

3) Confirma que existe el esquema y tablas en esa BD
En el Query Tool (ya en demo) ejecuta:

SELECT schema_name
FROM information_schema.schemata
ORDER BY 1;
Debe salir bookings.

Y luego:

SELECT table_name
FROM information_schema.tables
WHERE table_schema='bookings'
ORDER BY 1;
Debe salir flights, bookings, tickets, etc.

4) Reintenta el ejercicio 1
SELECT flight_id, status
FROM bookings.flights
WHERE status = 'On Time';
Dime qué devuelve SELECT current_database();
Con eso te digo exactamente si estabas en Demo o en demo y seguimos con las queries 1–5 sin más errores.

Tú dijiste:
Imagen cargada
 vale ahora ya esta . ya sabemos que funciona ahjopra empezemos desde el principio , vete guiandome paso a paso
ChatGPT Plus
Perfecto ✅ Ya lo tienes funcionando (te salen 518 filas), así que ahora sí: empezamos el Proyecto 4 desde el principio, pero ya con la BD bien cargada.

A partir de ahora el método será:

Ejecutas la query en pgAdmin (BD demo) y compruebas el resultado.

Si está bien, la copias al fichero IntroBBDD.sql en VSCode.

0) Preparación del fichero en VSCode
Abre tu carpeta del repo en VSCode.

Crea (o abre) el archivo: IntroBBDD.sql

Pega esta cabecera:

-- Proyecto 4: SQL
-- Base de datos: demo (schema bookings)
-- Alumno: TU NOMBRE
-- Fecha: 2025-12-15
Guarda.

1) Ejercicio 1
✅ Ya lo has hecho. Añádelo al archivo:

-- 1) Vuelos con status 'On Time'
SELECT flight_id, status
FROM bookings.flights
WHERE status = 'On Time';
2) Ejercicio 2
“Todas las columnas de bookings con total_amount > 1.000.000”

En pgAdmin (BD demo) ejecuta:

-- 2) Reservas con total_amount > 1.000.000
SELECT *
FROM bookings.bookings
WHERE total_amount > 1000000;
📌 Si te devuelve 0 filas, no pasa nada: significa que en el dataset “small” no hay reservas tan altas (pero la query está correcta).
Si quieres verificar rápido que funciona, prueba un umbral menor (solo para comprobar), por ejemplo > 100000 (pero en el fichero deja 1.000.000, que es lo que piden).

✅ Cuando lo ejecutes, copia la query tal cual a IntroBBDD.sql.

3) Ejercicio 3
“Todas las columnas de los modelos de aviones disponibles”

En tu base, la tabla se llama aircrafts_data (con s), como vimos antes.

Ejecuta:

-- 3) Modelos de aviones disponibles
SELECT *
FROM bookings.aircrafts_data;
Cópiala a IntroBBDD.sql.

4) Ejercicio 4
“Identificadores de vuelo que han volado con Boeing 737 (código 733)”

Ejecuta:

-- 4) Vuelos con Boeing 737 (aircraft_code = '733')
SELECT flight_id
FROM bookings.flights
WHERE aircraft_code = '733';
Cópiala a IntroBBDD.sql.

5) Ejercicio 5
“Información detallada de los tickets comprados por personas llamadas Irina”

Ejecuta:

-- 5) Tickets comprados por personas llamadas Irina (detallado)
SELECT
  t.ticket_no,
  t.book_ref,
  t.passenger_id,
  t.passenger_name,
  tf.flight_id,
  tf.fare_conditions,
  tf.amount
FROM bookings.tickets t
JOIN bookings.ticket_flights tf ON tf.ticket_no = t.ticket_no
WHERE t.passenger_name ILIKE 'Irina%';
Cópiala a IntroBBDD.sql.

Tu siguiente acción (ahora mismo)
Ejecuta el Ejercicio 2 en pgAdmin y dime:

¿Cuántas filas te devuelve? (aunque sea 0)

Y seguimos inmediatamente con el 3, 4 y 5 si hiciera falta ajustar algo.

Tú dijiste:
quiero que me copies el enunciado que pide el profesor , tal cual lo pide sin modoficar nada . vuelveme a mandar todos asi
ChatGPT Plus
Perfecto 👍
Te copio EL ENUNCIADO EXACTO, tal cual lo pide el profesor, sin modificar absolutamente nada.
Esto es lo que puedes pegar al inicio de tu trabajo o tener como referencia.

Proyecto 4: SQL
Ahora te toca a ti poner en práctica lo aprendido.

Sobre la misma base de datos que hemos instalado anteriormente, te proponemos que realices distintas operaciones de lectura para extraer datos.

Te dejamos la URL en la que puedes descargar la base de datos para instalarla y realizar los ejercicios planteados (descargad la versión más ligera si queréis).

https://postgrespro.com/docs/postgrespro/current/demodb-bookings-installation.html

Abre VSCode en la carpeta donde tengas tu repositorio GitHub y crea un fichero "IntroBBDD.sql".
Según vayas completando los ejercicios en PostgreSQL, ve copiando las sentencias en el fichero en VSCode.

Ejercicios obligatorios
1. Escribe una consulta que recupere los Vuelos (flights) y su identificador que figuren con status On Time.

2. Escribe una consulta que extraiga todas las columnas de la tabla bookings y refleje todas las reservas que han supuesto una cantidad total mayor a 1.000.000 (Unidades monetarias).

Nota: las tablas son públicas de Rusia, por tanto son Rublos sus unidades monetarias.

3. Escribe una consulta que extraiga todas las columnas de los datos de los modelos de aviones disponibles (aircraft_data).
Puede que os aparezca en alguna actualización como "aircrafts_data", revisad las tablas y elegid la que corresponda.

4. Con el resultado anterior visualizado previamente, escribe una consulta que extraiga los identificadores de vuelo que han volado con un Boeing 737.
(Código Modelo Avión = 733)

5. Escribe una consulta que te muestre la información detallada de los tickets que han comprado las personas que se llaman Irina.

Queries opcionales para continuar practicando
6. Mostrar las ciudades con más de un aeropuerto.

7. Mostrar el número de vuelos por modelo de avión.

8. Reservas con más de un billete (varios pasajeros).

9. Vuelos con retraso de salida superior a una hora.

Una vez hayas completado los ejercicios, haz commit en un repositorio para subir tus cambios y poder compartirlos.
Con tener un archivo con todas las queries estaría correcto.

Este proyecto es bastante autocorregible, por lo que aseguraos que el resultado es lo que se os pide antes de añadir la query al fichero.

Una vez terminado tendréis que enviar el proyecto a antonio.rosales@thepower.education con el asunto:

Proyecto 4: SQL – Vuestro nombre

y en el cuerpo del correo el link de un repositorio de GitHub.

Cuando quieras, en el siguiente mensaje seguimos ejercicio por ejercicio, verificando que cada query responde exactamente a lo que pide el enunciado 👌

Tú dijiste:
pero mandame el enunciado con el codigo , para ir copiandolo 1 a 1 en visuale studio code
ChatGPT Plus
Perfecto 👍
Te lo mando tal y como lo pide el profesor, pero con cada enunciado seguido inmediatamente por su código SQL, listo para copiar y pegar 1 a 1 en IntroBBDD.sql en VSCode.

👉 NO modifico el texto del enunciado, solo añado el SQL debajo.

Proyecto 4: SQL
Ahora te toca a ti poner en práctica lo aprendido.

Sobre la misma base de datos que hemos instalado anteriormente, te proponemos que realices distintas operaciones de lectura para extraer datos.

Te dejamos la URL en la que puedes descargar la base de datos para instalarla y realizar los ejercicios planteados (descargad la versión más ligera si queréis).

https://postgrespro.com/docs/postgrespro/current/demodb-bookings-installation.html

Abre VSCode en la carpeta donde tengas tu repositorio GitHub y crea un fichero "IntroBBDD.sql".
Según vayas completando los ejercicios en PostgreSQL, ve copiando las sentencias en el fichero en VSCode.

1. Escribe una consulta que recupere los Vuelos (flights) y su identificador que figuren con status On Time.
-- 1. Vuelos (flights) y su identificador con status On Time
SELECT flight_id, status
FROM bookings.flights
WHERE status = 'On Time';
2. Escribe una consulta que extraiga todas las columnas de la tabla bookings y refleje todas las reservas que han supuesto una cantidad total mayor a 1.000.000 (Unidades monetarias).
Nota: las tablas son públicas de Rusia, por tanto son Rublos sus unidades monetarias.

-- 2. Reservas con importe total mayor a 1.000.000
SELECT *
FROM bookings.bookings
WHERE total_amount > 1000000;
3. Escribe una consulta que extraiga todas las columnas de los datos de los modelos de aviones disponibles (aircraft_data).
Puede que os aparezca en alguna actualización como "aircrafts_data", revisad las tablas y elegid la que corresponda.

-- 3. Modelos de aviones disponibles
SELECT *
FROM bookings.aircrafts_data;
4. Con el resultado anterior visualizado previamente, escribe una consulta que extraiga los identificadores de vuelo que han volado con un Boeing 737. (Código Modelo Avión = 733)
-- 4. Identificadores de vuelo que han volado con un Boeing 737
SELECT flight_id
FROM bookings.flights
WHERE aircraft_code = '733';
5. Escribe una consulta que te muestre la información detallada de los tickets que han comprado las personas que se llaman Irina.
-- 5. Información detallada de los tickets comprados por personas llamadas Irina
SELECT
  t.ticket_no,
  t.book_ref,
  t.passenger_id,
  t.passenger_name,
  tf.flight_id,
  tf.fare_conditions,
  tf.amount
FROM bookings.tickets t
JOIN bookings.ticket_flights tf
  ON t.ticket_no = tf.ticket_no
WHERE t.passenger_name ILIKE 'Irina%';
Queries opcionales para continuar practicando
6. Mostrar las ciudades con más de un aeropuerto.
-- 6. Ciudades con más de un aeropuerto
SELECT
  city ->> 'en' AS city,
  COUNT(*) AS num_airports
FROM bookings.airports_data
GROUP BY city ->> 'en'
HAVING COUNT(*) > 1;

--7. Mostrar el número de vuelos por modelo de avión.--

-- 7. Número de vuelos por modelo de avión
SELECT aircraft_code, COUNT(*) AS num_flights
FROM bookings.flights
GROUP BY aircraft_code
ORDER BY num_flights DESC;

--8. Reservas con más de un billete (varios pasajeros).--

-- 8. Reservas con más de un billete
SELECT
  b.book_ref,
  COUNT(t.ticket_no) AS num_tickets
FROM bookings.bookings b
JOIN bookings.tickets t
  ON b.book_ref = t.book_ref
GROUP BY b.book_ref
HAVING COUNT(t.ticket_no) > 1;


--9. Vuelos con retraso de salida superior a una hora.--

-- 9. Vuelos con retraso de salida superior a una hora
SELECT
  flight_id,
  scheduled_departure,
  actual_departure,
  actual_departure - scheduled_departure AS delay
FROM bookings.flights
WHERE actual_departure IS NOT NULL
  AND actual_departure - scheduled_departure > INTERVAL '1 hour';





