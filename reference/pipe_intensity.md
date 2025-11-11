# Cálculo de intensidad en pipeline

Calcula el índice de intensidad normalizado dentro de un flujo pipeline.
La intensidad se define como la proporción de menciones del diccionario
respecto al total de palabras: intensidad = frecuencia / n_palabras.

## Usage

``` r
pipe_intensity(result, decimales = 4)
```

## Arguments

- result:

  Objeto \`acep_result\` que debe contener una columna \`frecuencia\`.
  Típicamente proviene de \`pipe_count()\`.

- decimales:

  Número de decimales para redondear el índice de intensidad. Por
  defecto: 4.

## Value

Objeto \`acep_result\` con tipo \`"intensidad"\` que incluye columnas
adicionales: \`n_palabras\` e \`intensidad\`.

## Examples

``` r
# Calcular intensidad desde resultado de conteo
textos <- c("El SUTEBA va al paro", "SOIP en lucha y paro")
corpus <- acep_corpus(textos)
diccionario <- c("paro", "lucha")
resultado <- pipe_count(corpus, diccionario)
resultado_intensidad <- pipe_intensity(resultado, decimales = 4)
print(resultado_intensidad)
#> acep_result object
#> ==================
#> Tipo: intensidad 
#> Filas: 2 
#> Columnas: 5 
#> Creado: 2025-11-11 17:17:57 
#> 
#> Primeras filas:
#>   id                texto frecuencia n_palabras intensidad
#> 1  1 El SUTEBA va al paro          1          5        0.2
#> 2  2 SOIP en lucha y paro          2          5        0.4
```
