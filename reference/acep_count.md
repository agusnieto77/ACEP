# Conteo de menciones de palabras de un diccionario

Cuenta el número de veces que aparecen palabras de un diccionario en
cada texto. Utiliza expresiones regulares con límites de palabra (word
boundaries) para evitar coincidencias parciales. Incluye un sistema de
caché que almacena los patrones regex compilados para acelerar
ejecuciones repetidas con el mismo diccionario.

## Usage

``` r
acep_count(texto, dic, use_cache = TRUE)
```

## Arguments

- texto:

  vector de textos al que se le aplica la función de conteo.

- dic:

  vector de palabras del diccionario utilizado.

- use_cache:

  logical, usar caché de regex (default TRUE).

## Value

Vector con frecuencia de palabras del diccionario.

## Examples

``` r
df <- data.frame(texto = c("El SUTEBA fue al paro. Reclaman mejoras salariales.",
"El SOIP lleva adelante un plan de lucha con paros y piquetes."))
diccionario <- c("paro", "lucha", "piquetes")
df$detect <- acep_count(df$texto, diccionario)
df
#>                                                           texto detect
#> 1           El SUTEBA fue al paro. Reclaman mejoras salariales.      1
#> 2 El SOIP lleva adelante un plan de lucha con paros y piquetes.      3
```
