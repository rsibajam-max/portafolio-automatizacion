# ============================================================
# Backup diario de los CSV históricos del sistema IMN
# ============================================================
# Copia todos los CSV del directorio de estaciones a una
# carpeta con la fecha del día, para preservar el estado
# previo a cada actualización.
#
# Se ejecuta antes de la corrida diaria del scraping.
# Ver README.md para el contexto completo.
# ============================================================

library(fs)

# Ajustar según tu sistema
origen  <- "ruta/a/estaciones"

# Crear nombre de carpeta con la fecha actual
fecha <- format(Sys.Date(), "%Y%m%d")

# Construir la ruta de destino
destino <- file.path("ruta/a/backup", fecha)
dir_create(destino)

# Rutas completas de origen
archivos <- list.files(path = origen, pattern = "\\.csv$", full.names = TRUE)

# Rutas de destino construidas a partir de los mismos nombres de archivo
destinos <- file.path(destino, basename(archivos))

file_copy(archivos, destinos, overwrite = TRUE)