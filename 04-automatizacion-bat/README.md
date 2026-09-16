# 04 — Automatización diaria con .bat + Programador de tareas

Ejecución automatizada de los scripts R del sistema IMN usando el Programador de tareas de Windows.

## Problema

El sistema tiene varios scripts R que deben correr en orden cada día:

1. Backup de los históricos previos.
2. Scraping y actualización de los 3 archivos de estaciones.
3. Procesamiento posterior (si aplica).

Ejecutar todo a mano cada mañana no es viable. Y no se puede depender de recordar hacerlo: si un día se olvida, los datos se pierden porque el IMN solo mantiene una ventana móvil de ~24 horas.

## Solución

Un archivo `.bat` que invoca los scripts R en el orden correcto, programado a través del Programador de tareas de Windows para correr automáticamente todos los días.

## Estructura del .bat

Cada script R se invoca con tres líneas:

```bat
cd "carpeta_de_trabajo"
"ruta/al/R.exe" CMD BATCH "ruta/al/script.R"
cd "ruta/al/archivo.Rout"
```
## Configuración en el Programador de tareas

1. Abrir el Programador de tareas de Windows.
2. Crear una nueva tarea.
3. **Desencadenador**: diario, a la hora deseada.
4. **Acción**: ejecutar el `.bat`.
5. Guardar.

## Cómo adaptarlo

Para otro sistema:

1. Ajustar las rutas de R y de los scripts.
2. Agregar un bloque por cada script R que se quiera correr.
3. Programar el `.bat` desde el Programador de tareas.
