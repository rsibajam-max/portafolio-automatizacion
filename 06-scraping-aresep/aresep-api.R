# ============================================================
# Consumo de API de ARESEP — histórico de agua potable
# ============================================================
# Descarga el histórico completo de datos de agua potable
# desde la API de datos abiertos de ARESEP.
#
# La API es OData y devuelve los datos por año, así que el
# script itera sobre un rango de años y combina los resultados.
#
# Los datos se actualizan aproximadamente cada 3 meses, por lo
# que no es necesario correr el script con frecuencia.
#
# Ver README.md para el contexto completo.
# ============================================================

library(httr2)
library(dplyr)
library(purrr)

# Función para obtener los datos de un año específico
obtener_aresep <- function(anio) {
  
  url <- paste0(
    "https://datos.aresep.go.cr/ws.datosabiertos/Services/IA/",
    "AguaPotable.svc/ObtenerHistoricoMercado/",
    anio
  )
  
  respuesta <- request(url) |>
    req_perform() |>
    resp_body_json()
  
  respuesta$value
}

# Recorre los años y muestra el progreso
for (anio in 2010:2026) {
  
  datos_anio <- obtener_aresep(anio)
  
  cat(
    anio, 
    "->", 
    nrow(datos_anio), 
    "registros\n"
  )
}

# Combina todos los años en un solo dataframe
datos <- map_dfr(2010:2026, obtener_aresep)

# Exporta el histórico completo a CSV en UTF-8
write.csv2(
  datos,
  "ARESEP_mercado_agua_historico.csv",
  row.names = FALSE,
  fileEncoding = "UTF-8"
)
