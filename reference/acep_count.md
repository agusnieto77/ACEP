# Conteo de menciones de palabras de un diccionario

Cuenta el número de veces que aparecen palabras de un diccionario en
cada texto. Los términos se tratan como texto literal: sus
metacaracteres de expresiones regulares se escapan automáticamente. De
forma predeterminada también cuenta coincidencias parciales (por
ejemplo, "paro" coincide dentro de "paros"); para exigir límites de
palabra (word boundaries) y evitar coincidencias parciales, rodeá cada
término con espacios (por ejemplo, " paro "). Incluye un sistema de
caché que almacena los patrones regex compilados para acelerar
ejecuciones repetidas con el mismo diccionario. El caché se acota
automáticamente (máximo 1000 patrones) para evitar crecimiento de
memoria sin límite en sesiones largas; también podés vaciarlo
manualmente con \`acep_clear_regex_cache()\`.

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
