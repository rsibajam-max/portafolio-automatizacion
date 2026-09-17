# ============================================================
# Resumen mensual de variables por estación (IMN)
# ============================================================
# Procesa todos los CSV de un directorio y genera un consolidado
# con el acumulado mensual de lluvia por estación.
#
# Robusto ante errores: cada archivo se procesa dentro de un
# tryCatch, y se validan varios puntos del formato. Si un
# archivo falla, se salta y continúa con el siguiente.
#
# Forma parte del sistema de captura del IMN. Consume los CSV
# generados por el script de scraping (01-scraping-imn).
# Ver README.md para el contexto completo.
# ============================================================

library(dplyr)
library(tidyverse)

# Ajustar según tu sistema
setwd("ruta/a/tus/datos")

resultado_final <- data.frame()
files <- list.files(path = getwd(), pattern = "*.csv", full.names = FALSE)
files

for (i in 1:length(files)) {
  tryCatch({
    # Lee el archivo CSV
    pr <- read.csv(file = files[i], sep = ",")

    # Verifica que el archivo tenga las columnas necesarias
    if (!all(c("fecha", "indice") %in% colnames(pr))) {
      cat("El archivo", files[i], "no tiene las columnas necesarias\n")
      next # Salta al siguiente archivo
    }

    # Elimina filas con valores nulos en 'fecha'
    pr <- pr[!is.na(pr$fecha), ]

    # Divide la fecha en 3 variables (fecha/hora/ampm)
    date <- pr$fecha # Carga solo la fecha de los datos
    rs <- strsplit(date, split = " ") # Divide por espacios vacíos
    rs <- as.data.frame(do.call(rbind, rs)) # Une las columnas en un dataframe

    # Verifica que rs tenga exactamente 3 columnas
    if (ncol(rs) != 3) {
      cat("El archivo", files[i], "tiene un formato de fecha inesperado\n")
      next
    }

    colnames(rs) <- c("dias", "hora", "am")
    dia <- rs$dias

    # Une la hora con am/pm
    hora <- paste(rs$hora, rs$am, sep = " ")
    hora <- data.frame(hora)

    # Une el índice/día/hora
    dia <- cbind(dia, hora)
    dia <- cbind(pr$indice, dia)
    colnames(dia) <- c("indice", "dia", "hora")

    # Une la fecha dividida con el archivo original por medio del índice
    resultado <- left_join(dia, pr, by = "indice")
    resultado <- select(resultado, -dia, -hora)

    # Divide la fecha en día/mes/año
    df <- str_split_fixed(resultado$fecha, "/", 3)
    if (ncol(df) != 3) {
      cat("El archivo", files[i], "tiene un problema en el formato de fecha\n")
      next
    }

    colnames(df) <- c("dia", "mes", "x")
    df <- data.frame(df)
    anoHora <- select(df, x)
    anoHora <- str_split_fixed(anoHora$x, " ", 2)

    # Verifica que anoHora tenga 2 columnas (año y hora)
    if (ncol(anoHora) != 2) {
      cat("El archivo", files[i], "tiene un problema en el formato de año y hora\n")
      next
    }

    colnames(anoHora) <- c("ano", "hora")
    anoHora <- data.frame(anoHora)

    # Une todas las partes
    df2 <- select(df, dia, mes)
    df3 <- cbind(df2, anoHora, resultado)

    # Resumen mensual: acumulado de lluvia por año-mes
    consulta <- df3 %>% group_by(ano, mes) %>% summarise(lluvia = sum(lluvia))

    # Agrega el nombre del archivo como referencia
    consulta <- mutate(consulta, archivo_origen = files[i])
    resultado_final <- bind_rows(resultado_final, consulta)

  }, error = function(e) {
    cat("Error procesando el archivo:", files[i], "\n")
  })
}

write.csv(resultado_final, file = "resultado_final_lluvia.csv", append = FALSE, quote = FALSE,
          sep = ";", col.names = FALSE, row.names = FALSE)
