# ============================================================
# Selección de estaciones por categoría (región, cuenca, etc.)
# ============================================================
# Copia los CSV históricos de las estaciones que cumplen un
# criterio (por ejemplo, región = "Pacífico Norte") desde el
# directorio general de estaciones a una carpeta de trabajo.
#
# Se usa para análisis específicos por región, cuenca, cantón
# o provincia, sin tener que trabajar con las ~50 estaciones
# a la vez.
#
# Requiere un archivo de guía con la metadata de cada estación
# (región, provincia, cantón, cuenca, archivo). Ver README.md.
# ============================================================

library(dplyr)
library(fs)

# Ajustar según tu sistema
setwd("ruta/a/tus/datos")

# Leer la guía de estaciones
guia <- read.csv(file = "guia estaciones.csv", sep = ";")

# Seleccionar por categoría: cambiar el valor por la categoría deseada.
# Ejemplos: "Pacifico Norte", "Valle Central", "Caribe Sur", etc.
seleccionado <- subset(guia, guia$Region == "Pacifico Norte")

# Obtener solo la columna con el nombre del archivo de cada estación
seleccionado <- select(seleccionado, Archivo)

# Convertir a vector de caracteres para usar como patrón en list.files
sel_chr <- as.character(seleccionado[ , ])

# Buscar en el directorio de estaciones los archivos que coincidan
# con cualquiera de los nombres seleccionados.
# El paste0 con collapse = "|" construye una expresión del tipo
# "laurel|upala|nicoya" que list.files interpreta como alternancia.
list <- list.files(
  path = "ruta/a/estaciones",
  pattern = paste0(sel_chr, collapse = "|"),
  full.names = TRUE
)

# Copiar los archivos a la carpeta de trabajo
destino <- "ruta/a/estaciones-seleccionadas"
file_copy(list, destino, overwrite = FALSE)

# Categorías disponibles (según la división del IMN):
# Pacifico Norte
# Pacifico Central
# Pacifico Sur
# Zona Norte
# Valle Central
# Caribe Norte
# Caribe Sur
