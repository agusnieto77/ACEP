# Índice de intensidad.

Función que elabora un indice de intensidad en base a la relación entre
palabras totales y palabras del diccionario presentes en el texto.

## Usage

``` r
acep_int(pc, pt, decimales = 4)
```

## Arguments

- pc:

  vector numérico con la frecuencia de palabras conflictivas presentes
  en cada texto.

- pt:

  vector de palabras totales en cada texto.

- decimales:

  cantidad de decimales, por defecto tiene 4 pero se puede modificar.

## Value

Si todas las entradas son correctas, la salida sera un vector numérico.

## Examples

``` r
conflictos <- c(1, 5, 0, 3, 7)
palabras <- c(4, 11, 12, 9, 34)
acep_int(conflictos, palabras, 3)
#> [1] 0.250 0.455 0.000 0.333 0.206
```
