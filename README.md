# Ejemplo: scraping de una estación del IMN

Este es **un ejemplo representativo** de un sistema que captura
datos diarios de ~50 estaciones meteorológicas del IMN
(Instituto Meteorológico Nacional de Costa Rica).

Se incluye solo **una estación** (Laurel, Puntarenas) como muestra
del patrón que se repite para cada una.

## Problema

El IMN publica los datos de cada estación en una tabla HTML,
sin API, mantiene solo una ventana móvil de ~24 horas.
Los datos anteriores se pierden y no hay forma de recuperarlos.

## Solución

Script en R que:
1. Descarga la tabla HTML de la estación.
2. La limpia y reorganiza en 4 columnas (fecha, temp, lluvia, presión).
3. La acumula en un histórico propio en CSV.
4. Se ejecuta automáticamente todos los días vía `.bat`
   + Programador de tareas de Windows.

## Particularidades del IMN

La fuente tiene varias complicaciones:

- La tabla viene en una sola columna** con los valores concatenados;
  hay que separarlos y reordenarlos por tipo de variable.
- Cada estación tiene un número distinto de filas** de encabezado/pie,
  por lo que las constantes `p` y `aux` están calibradas a mano.
- El IMN no corrige datos**, así que el histórico acumulado
  es responsabilidad del propio sistema.

## Herramientas

- **R**: `rvest` (scraping HTML), `dplyr` (manipulación)
- **Windows**: `.bat` + Programador de tareas
- **Backup**: copia por fecha por medio de otro codigo.

## Archivos

- `scraping-laurel.R` — script completo, listo para correr.
- `ejemplo-salida.csv` — muestra del histórico resultante (10 filas).

## Notas de diseño

- Se usan 3 archivos `.R` agrupando ~20 estaciones cada uno,
  para facilitar el mantenimiento manual.
- Si una estación falla, el script se detiene y se corrige a mano
  antes de la siguiente corrida. Es una decisión deliberada:
  el operador revisa logs diariamente.
- El sistema tiene hasta 8 años de datos acumulados para las primeras estaciones corriendo.

## Cómo correrlo

1. Ajustar la ruta de trabajo (`setwd()`).
2. Colocar el CSV histórico (si existe) en el mismo directorio.
3. Ejecutar el script. Se actualiza el histórico con datos nuevos.

*Nota: los nombres de archivos y rutas en este ejemplo están
genéricos. En producción cada estación tiene su propio CSV.*
