# ============================================================
# Scraping de la estación Laurel / Corredores, Puntarenas - IMN
# ============================================================
# Este script es un ejemplo representativo del sistema completo
# que captura datos diarios de ~50 estaciones del IMN.
# El sistema real usa 3 archivos .R agrupando ~20 estaciones
# cada uno, para facilitar el mantenimiento manual.
#
# Ver README.md para el contexto completo.
#
# Notas:
# - Los nombres de variables (upala, upalaNew, up, etc.) son
#   heredados de una plantilla común entre estaciones. Se
#   conservan por continuidad con el sistema en producción.
# - Las constantes p y aux están calibradas a mano para esta
#   estación, según el número de filas de encabezado/pie que
#   publica el IMN en el HTML.
# - El flujo de escritura/lectura del CSV usa separadores
#   distintos (; al escribir, , al leer). Es intencional y
#   forma parte de la convención del sistema.
# ============================================================

library(rvest)
library(dplyr)

# Ajustar según tu sistema
setwd("ruta/a/tus/datos")

###################################### Laurel / Corredores, Puntarenas ######################################

url <- 'https://www.imn.ac.cr/especial/tablas/laurel.html'
cast <- read_html(url) %>% html_nodes("td") %>% html_text()  # ubica la información de las tablas

a <- data.frame(cast)
colnames(a) <- "valores"
a <- within(data = a, Position <- data.frame
            (do.call('rbind', strsplit(as.character(valores), "\r\n", fixed = TRUE))))  # elimina lo que no se ocupa y crea una columna nueva

colnames(a) <- c("valores", "Position")
a <- select(a, valores = Position)  # selecciona la información útil
z <- nrow(a)  # valor auxiliar para tomar tablas de cualquier tamaño en la página web IMN
a2 <- data.frame(1:z)  # crea un conteo de los valores
colnames(a2) <- c("id")
A <- cbind(a2, a)  # combina los dataframes
p <- z - 100

aux <- (z - p) / 4  # valor auxiliar para repetir los números, considerando tablas de diferentes tamaños
aux
a <- A[-c((z - (p - 1)):z), ]  # elimina los datos de +, que se descargan
num <- c(rep(1:4, aux))
num <- data.frame(num)
num
a <- cbind(num, a$valores)
colnames(a) <- c("numero", "valores")

# se crea un data frame de complemento para acomodar los datos
nombres <- c("Fecha", "temp", "lluva", "P_atm")
num1 <- c(1, 2, 3, 4)
num1 <- data.frame(num1)
tabla <- cbind(num1, nombres)
colnames(tabla) <- c("numero", "variables")
tabla <- data.frame(tabla)

colnames(num) <- c("numero")

tabla2 <- num %>% left_join(tabla)  # uno las tablas

# unir tablas
tabla3 <- cbind(tabla2, a)

# las tablas están desordenadas / se hace un proceso para ordenar todo en columnas usando el número como índice y reemplazando las , con .
fecha <- tabla3[tabla3$numero == 1, ]
fecha <- fecha$valores
fecha <- data.frame(fecha)

temp <- tabla3[tabla3$numero == 2, ]
temp <- temp$valores
temp <- as.numeric(gsub(",", ".", temp))
temp <- data.frame(temp)

lluvia <- tabla3[tabla3$numero == 3, ]
lluvia <- lluvia$valores
lluvia <- as.numeric(gsub(",", ".", lluvia))
lluvia <- data.frame(lluvia)

P_atm <- tabla3[tabla3$numero == 4, ]
P_atm <- P_atm$valores
P_atm <- data.frame(P_atm)

upalaNew <- cbind(fecha, temp, lluvia)  # se une todo para tenerlo como columnas
upalaNew

# ---- Bootstrap: solo para la primera corrida de una estación nueva ----
# Descomentar al arrancar una estación nueva. Dejar comentado en corridas normales.
#write.csv(upalaNew, file = "ejemplo-salida.csv", append = FALSE, quote = FALSE, sep = ";",
#          col.names = FALSE, row.names = FALSE)

upala <- read.csv(file = "ejemplo-salida.csv", sep = ",")  # este archivo es el histórico que se debe actualizar
upala <- select(upala, -indice)

x <- dim(upala)
x <- nrow(upala)
ind <- data.frame(1:x)  # índice para acomodar los números de 1 al tamaño del archivo histórico

colnames(ind) <- "indice"
data.frame(ind)
upala <- cbind(ind, upala)

x1 <- nrow(upalaNew)
ind2 <- data.frame((x + x1):(x + 1))  # índice del tamaño del archivo histórico hasta la suma de los valores descargados del IMN
data.frame(ind2)

colnames(ind2) <- "indice"
upalaNew <- cbind(ind2, upalaNew)
up <- rbind(upala, upalaNew)  # se unen las filas y calzan los índices calculados anteriormente
up <- up %>% arrange(indice)  # se acomoda por índice para tener los valores ordenados

up <- select(up, -indice)  # se saca el índice y P_atm, ya que se ocupa eliminar los valores repetidos (estos valores no son iguales en las dos tablas)
up <- unique(up)  # elimina los valores repetidos y ordena la tabla

z <- nrow(up)
indice <- data.frame(1:z)  # genera un nuevo índice del tamaño del nuevo dataframe, para facilitar ordenar datos
data.frame(indice)
colnames(indice) <- "indice"
up <- cbind(indice, up)

write.csv(up, file = "ejemplo-salida.csv", append = FALSE, quote = FALSE, sep = ";",
          col.names = FALSE, row.names = FALSE)
