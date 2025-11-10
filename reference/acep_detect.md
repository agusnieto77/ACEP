# Detección de menciones de palabras.

Función que detecta de menciones de palabras que refieren a conflictos
en cada una de las notas/textos.

## Usage

``` r
acep_detect(x, y, u = 1, tolower = TRUE)
```

## Arguments

- x:

  vector de textos al que se le aplica la función de detección de
  menciones de palabras del diccionario.

- y:

  vector de palabras del diccionario utilizado.

- u:

  umbral para atribuir valor positivo a la detección de las menciones.

- tolower:

  convierte los textos a minúsculas.

## Value

Si todas las entradas son correctas, la salida sera un vector numérico.

## Examples

``` r
df <- data.frame(texto = c("El SUTEBA fue al paro. Reclaman mejoras salariales.",
"El SOIP lleva adelante un plan de lucha con paros y piquetes."))
diccionario <- c("paro", "lucha", "piquetes")
df$detect <- acep_detect(df$texto, diccionario)
df
#>                                                           texto detect
#> 1           El SUTEBA fue al paro. Reclaman mejoras salariales.      1
#> 2 El SOIP lleva adelante un plan de lucha con paros y piquetes.      1
```
