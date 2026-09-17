# Portafolio de Automatización

Scripts de automatización en R para captura, procesamiento y respaldo de datos meteorológicos del IMN (Instituto Meteorológico Nacional de Costa Rica).

## Proyectos

- **[01 — Scraping de estaciones del IMN](01-scraping-imn/README.md)**: captura diaria de ~50 estaciones desde HTML, con histórico propio en CSV.
- **[02 — Backup diario de históricos](02-backup-diario/README.md)**: copia de seguridad por fecha antes de cada corrida.
- **[03 — Selección de estaciones por categoría](03-seleccionar-estaciones/README.md)**: copia un subconjunto de históricos según región, cuenca, cantón o provincia.
- **[04 — Automatización diaria con .bat](04-automatizacion-bat/README.md)**: ejecución diaria de los scripts con el Programador de tareas de Windows.
- **[05 — Resumen de variables por estación](05-resumen-estaciones/README.md)**: consolidado de totales y promedios por estación.

## Herramientas

- R
- Windows: `.bat` + Programador de tareas

## Contexto

Estos scripts forman parte de un sistema que captura y acumula datos de ~50 estaciones meteorológicas del IMN. El IMN publica cada estación en una tabla HTML sin API, y mantiene solo una ventana móvil de ~24 horas. El sistema respalda y acumula los datos diariamente para construir series históricas propias.

Ver cada proyecto para detalles.
