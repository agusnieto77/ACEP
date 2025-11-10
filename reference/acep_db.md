# Frecuencia, menciones e intensidad.

Función que usa las funciones acep_frec, acep_count y acep_int y
devuelve una tabla con tres columnas nuevas: numero de palabras, número
de menciones del diccionario, indice de intensidad.

## Usage

``` r
acep_db(db, t, d, n)
```

## Arguments

- db:

  data frame con los textos a procesar.

- t:

  columna de data frame que contiene el vector de textos a procesar.

- d:

  diccionario en formato vector.

- n:

  cantidad de decimales del indice de intensidad.

## Value

Si todas las entradas son correctas, la salida sera una base de datos en
formato tabular con tres nuevas variables.

## Examples

``` r
df <- data.frame(texto = c("El SUTEBA fue al paro. Reclaman mejoras salariales.",
"El SOIP lleva adelante un plan de lucha con paros y piquetes."))
diccionario <- c("paro", "lucha", "piquetes")
acep_db(df, df$texto, diccionario, 4)
#>                                                           texto n_palabras
#> 1           El SUTEBA fue al paro. Reclaman mejoras salariales.          8
#> 2 El SOIP lleva adelante un plan de lucha con paros y piquetes.         12
#>   conflictos intensidad
#> 1          1      0.125
#> 2          3      0.250
```
