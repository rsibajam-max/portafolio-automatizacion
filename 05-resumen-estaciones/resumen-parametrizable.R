# ============================================================
# Resumen parametrizable de variables por estación (IMN)
# ============================================================
# Versión didáctica del resumen: tiene las variantes de consulta
# comentadas, para mostrar cómo cambiar entre distintas
# agregaciones (por mes, por día, por rango de fechas).
#
# A diferencia de resumen-mensual.R, esta versión no incluye
# tryCatch ni validaciones de formato. Es más legible como
# plantilla, pero menos robusta.
#
# Forma parte del sistema de captura del IMN.
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
  # Divide la fecha en 3 variables (fecha/hora/ampm)
  pr <- read.csv(file = files[i], sep = ",")
  date <- pr$fecha # Carga solo la fecha de los datos
  rs <- strsplit(date, split = " ") # Divide por espacios vacíos
  rs <- as.data.frame(do.call(rbind, rs))
  colnames(rs) <- c("dias", "hora", "am")
  dia <- rs$dia

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
  colnames(df) <- c("dia", "mes", "x")
  df <- data.frame(df)
  anoHora <- select(df, x)
  anoHora <- str_split_fixed(anoHora$x, " ", 2)
  colnames(anoHora) <- c("ano", "hora")
  anoHora <- data.frame(anoHora)

  # Une todo
  df2 <- select(df, dia, mes)
  df3 <- cbind(df2, anoHora, resultado)

  # ------------------------------------------------------------
  # Variantes de consulta (descomentar la que se quiera usar)
  # ------------------------------------------------------------

  # Consulta por una fecha en particular
  # consulta <- subset(df3, df3$dia == "10" & df3$mes == "06" & df3$ano == "2023")

  # Resumen por año-mes: lluvia acumulada
  # consulta <- df3 %>% group_by(ano, mes) %>% summarise(lluvia = sum(lluvia))

  # Resumen por año-mes: temperatura promedio
  # consulta <- df3 %>% group_by(ano, mes) %>% summarise(temp = mean(temp, na.rm = TRUE))

  # Consulta por un rango de días
  consulta <- subset(df3, df3$dia >= "01" & df3$dia <= "12" & df3$mes == "11" & df3$ano == "2024")
  consulta <- consulta %>% group_by(dia) %>% summarise(lluvia = sum(lluvia))

  # Consulta por un rango de días y obtener resumen
  # consulta <- subset(df3, df3$dia >= 01 & df3$dia <= 15 & df3$mes == "09" & df3$ano == "2023")
  # consulta <- consulta %>% group_by(dia) %>% summarise(lluvia = sum(lluvia))

  # Consulta por un mes y año
  # consulta <- subset(df3, df3$mes == "10" & df3$ano == "2023")

  # ------------------------------------------------------------

  consulta <- mutate(consulta, archivo_origen = files[i])
  resultado_final <- bind_rows(resultado_final, consulta)
}

write.csv(resultado_final, file = "resultado_final_consulta.csv", append = FALSE, quote = FALSE,
          sep = ";", col.names = FALSE, row.names = FALSE)
