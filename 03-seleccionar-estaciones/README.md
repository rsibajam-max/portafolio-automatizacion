# 03 — Selección de estaciones por categoría

Script para copiar un subconjunto de los CSV históricos del sistema IMN según la región, cuenca, cantón o provincia de cada estación.

## Problema

El sistema captura datos de ~50 estaciones. Para análisis específicos (por ejemplo, solo las estaciones del Pacífico Norte, o solo las de una cuenca), trabajar con todas a la vez es incómodo y no siempre tiene sentido.

## Solución

Script en R que:

- Lee una guía con la metadata de cada estación.
- Filtra las estaciones que cumplen un criterio (por ejemplo, `Region == "Pacifico Norte"`).
- Copia solo los CSV de esas estaciones a una carpeta de trabajo aparte.

## Guía de estaciones

El script requiere un archivo `guia estaciones.csv` con separador `;` y estas columnas:

- `Nombre` — nombre de la estación.
- `Canton`, `Provincia`, `Region`, `Cuenca` — criterios de filtrado.
- `Codigo` — código interno.
- `Archivo` — nombre del CSV del histórico (ej: `IMN-Laurel historico.csv`).

La guía incluye más estaciones que las actualmente capturadas: hay estaciones fuera de servicio, y otras que pueden agregarse al sistema en cualquier momento. El filtro se aplica sobre cualquiera de las columnas de categoría; solo hay que cambiar la condición en el `subset()`.

*Nota: la guía `guia estaciones.csv` no se incluye en este repositorio. Es un archivo propio del sistema que asocia cada estación con su metadata geográfica.*

## Herramientas

- **R**: `dplyr` (filtrado), `fs` (copia de archivos).

## Cómo correrlo

1. Ajustar las rutas (`setwd()`, `path` en `list.files`, `destino`).
2. Asegurar que `guia estaciones.csv` existe en el directorio de trabajo.
3. Cambiar la categoría en el `subset()` según lo que se quiera seleccionar.
4. Ejecutar el script. Se copian los CSV a la carpeta de destino.

## Notas de diseño

- El filtro por categoría usa `subset()` sobre la columna deseada. Para cambiar el criterio (provincia, cuenca, etc.) solo hay que modificar la columna y el valor.
- Los nombres de archivo seleccionados se combinan en una expresión tipo `"laurel|upala|nicoya"` para usar en `list.files`, que la interpreta como alternancia. Esto evita copiar archivos en un bucle.
- `overwrite = FALSE` evita sobreescribir selecciones previas. Si se quiere refrescar la selección, hay que borrar la carpeta de destino primero o cambiar a `overwrite = TRUE`.

## Categorías del IMN

La página del IMN divide las estaciones en 7 regiones:

- Pacífico Norte
- Pacífico Central
- Pacífico Sur
- Zona Norte
- Valle Central
- Caribe Norte
- Caribe Sur
