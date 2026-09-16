# 02 — Backup diario de históricos

Copia de seguridad diaria de los CSV históricos del sistema de captura del IMN.

## Problema

El sistema de scraping reescribe los CSV históricos cada día. Un error en el script, una interrupción a mitad de la escritura, o un fallo en el procesamiento puede corromper el archivo o perder datos. No hay forma de recuperar el estado anterior si no se respalda antes.

## Solución

Script en R que:

- Copia todos los CSV del directorio de estaciones a una carpeta con la fecha del día.
- Se ejecuta **antes** de la corrida diaria del scraping.
- Crea un respaldo por cada día, permitiendo restaurar cualquier versión anterior.

## Estructura resultante
BACKUP/
├── 20240915/
│ ├── IMN-Laurel historico.csv
│ ├── IMN-Upala historico.csv
│ └── ...
├── 20240916/
│ └── ...
└── 20240917/
└── ...


## Herramientas

- **R**: `fs` (manejo de archivos y carpetas).

## Cómo correrlo

1. Ajustar las rutas de origen (`origen`) y destino (`destino`) al sistema.
2. Ejecutar el script. Se crea la carpeta del día y se copian los CSV.

## Notas de diseño

- La carpeta se nombra con formato `YYYYMMDD`, lo que permite ordenar alfabéticamente y filtrar por fecha sin parsear strings.
- Se copian solo archivos `.csv` para evitar incluir archivos temporales u otros que puedan existir en el directorio.
- Si se ejecuta dos veces el mismo día, sobreescribe la carpeta del día anterior con el estado más reciente.
