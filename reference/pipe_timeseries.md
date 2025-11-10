# Generación de series temporales en pipeline

Crea agregaciones temporales de índices de conflictividad dentro de un
flujo pipeline. Agrupa los resultados por segmentos temporales (día,
mes, año) y calcula estadísticas resumidas usando \`acep_sst()\`.

## Usage

``` r
pipe_timeseries(data, st = "mes", u = 2, d = 4)
```

## Arguments

- data:

  Data frame o objeto \`acep_result\` que contenga columnas: \`fecha\`
  (o variable temporal), \`n_palabras\`, \`conflictos\`, \`intensidad\`.

- st:

  Segmento temporal para agrupar. Valores: \`"dia"\`, \`"mes"\`,
  \`"anio"\`. Por defecto: \`"mes"\`.

- u:

  Umbral para calcular métricas categóricas. Por defecto: 2.

- d:

  Número de decimales para redondear. Por defecto: 4.

## Value

Objeto \`acep_result\` con tipo \`"serie_temporal"\` que contiene
agregaciones por período temporal.

## Examples

``` r
if (FALSE) { # \dontrun{
# Crear serie temporal desde data frame con fechas
data <- data.frame(
  fecha = as.Date(c("2024-01-15", "2024-01-20", "2024-02-10")),
  n_palabras = c(100, 150, 120),
  conflictos = c(5, 8, 6),
  intensidad = c(0.05, 0.053, 0.05)
)
serie <- pipe_timeseries(data, st = "mes", u = 2)
print(serie)
} # }
```
