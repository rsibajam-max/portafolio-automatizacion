# 06 — Consumo de API de ARESEP

Script para descargar el histórico de datos de agua potable desde la API de datos abiertos de ARESEP (Autoridad Reguladora de los Servicios Públicos de Costa Rica).

## Problema

ARESEP publica datos históricos de su mercado de agua potable a través de una API OData, pero:

- Los datos están organizados por año, requiriendo múltiples llamadas para obtener el histórico completo.
- La API devuelve JSON, que hay que procesar para convertirlo en un dataframe utilizable.
- No hay una descarga directa del histórico completo.

## Solución

Script en R que:

- Consume la API de ARESEP usando `httr2`.
- Itera sobre los años 2010-2026.
- Combina los resultados de cada año en un solo dataframe con `purrr::map_dfr`.
- Exporta el histórico completo a CSV en formato UTF-8.

## API

La API es del tipo OData, disponible en:
https://datos.aresep.go.cr/ws.datosabiertos/Services/IA/AguaPotable.svc

Cada año se consulta con la ruta:
/ObtenerHistoricoMercado/{anio}

La respuesta es JSON, con la estructura típica de OData:

```json
{
  "value": [
    { "campo1": "valor1", "campo2": "valor2" },
    { "campo1": "valor1", "campo2": "valor2" }
  ]
}
```
## Herramientas
R: httr2 (HTTP moderno), purrr (iteración), dplyr (procesamiento).

##Cómo correrlo
Ajustar el rango de años si es necesario (por defecto 2010-2026).

Ejecutar el script. Se descargan todos los años y se genera un CSV.

## Notas de diseño
Uso de httr2: paquete moderno de R para HTTP, con sintaxis basada en pipes (|>).

map_dfr sobre los años: aplicación funcional de la función de descarga a cada año, combinando los resultados en un solo dataframe.

Frecuencia de actualización: ARESEP actualiza estos datos aproximadamente cada 3 meses, por lo que no es necesario correr el script con frecuencia.

Exportación en UTF-8: se usa write.csv2 con fileEncoding = "UTF-8" para preservar tildes y caracteres especiales de los datos.

## Contexto
Este proyecto es independiente del sistema IMN. Los datos de ARESEP no tienen una ubicación geográfica asociada que permita ligarlos con las estaciones meteorológicas, así que sirven como dataset separado.

El objetivo es mantener una copia local del histórico de ARESEP por si se necesita para análisis o para preservar datos que podrían desaparecer de la API.
