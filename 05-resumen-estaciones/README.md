# 05 — Resumen de variables por estación

Scripts para consolidar los históricos de varias estaciones en un solo archivo con resúmenes de variables meteorológicas (lluvia, temperatura, etc.) por mes, por día, o por rango de fechas.

Este script forma parte del sistema de captura del IMN. Consume los CSV generados por el script de scraping (`01-scraping-imn`) y produce reportes agregados para análisis.

## Problema

Cada estación tiene su propio CSV histórico con datos horarios. Para análisis agregados (comparar estaciones, generar reportes, calcular totales de lluvia o promedios de temperatura), procesar cada archivo por separado es lento y propenso a errores.

## Solución

Dos scripts que hacen lo mismo con énfasis distintos:

- **`resumen-mensual.R`** — script de producción. Procesa todos los CSV de un directorio, valida el formato de cada uno, y genera un consolidado con el acumulado mensual. Robusto ante errores: si un archivo falla, sigue con el siguiente.
- **`resumen-parametrizable.R`** — versión didáctica del mismo proceso. Tiene las variantes de consulta comentadas, para mostrar cómo cambiar entre distintas agregaciones:
  - Total de lluvia por año-mes.
  - Promedio de temperatura por año-mes.
  - Total de lluvia por rango de días.
  - Consulta por fecha específica.

## Robustez

El script de producción incluye:

- `tryCatch` por cada archivo, para que un error no bloquee el resto.
- Verificaciones de formato en varios puntos (columnas esperadas, splits de fecha, número de columnas resultantes).
- Salto explícito de archivos con problemas, con mensaje a consola.

El script parametrizable no incluye estas validaciones, para que el código sea más legible como plantilla.

## Salida

Un CSV con columnas:

- `ano`, `mes`, `dia` — según la consulta activa.
- `lluvia` o `temp` — según la variable agregada.
- `archivo_origen` — nombre del archivo del que provino cada registro.

La columna `archivo_origen` permite rastrear cada resultado hasta el archivo original.

## Herramientas

- **R**: `dplyr`, `tidyr` (dentro de `tidyverse`).

## Cómo correrlo

1. Colocar todos los CSV a procesar en un directorio.
2. Ajustar la ruta en `setwd()`.
3. Elegir cuál script correr:
   - Producción: `resumen-mensual.R`.
   - Plantilla: `resumen-parametrizable.R`, descomentando la consulta deseada.
4. Ejecutar. Se genera un CSV con el consolidado.

## Relación con otros proyectos

- **Consume**: los CSV generados por `01-scraping-imn`.
- **Es parte del flujo**: que se ejecuta automáticamente vía `04-automatizacion-bat`.

## Notas de diseño

- El script procesa **todos** los CSV del directorio. Si un archivo no tiene la estructura esperada, se salta y sigue.
- El formato de fecha que se parsea es `DD/MM/YYYY HH:MM a.m./p.m.`, específico del IMN.
- La columna `archivo_origen` se agregó para poder auditar después de dónde vino cada fila del consolidado.

## Casos de uso

- Generar resúmenes mensuales de lluvia o temperatura para todas las estaciones.
- Preparar datos para reportes de un período específico.
- Detectar estaciones con datos incompletos.
- Comparar entre estaciones en un mismo período.
