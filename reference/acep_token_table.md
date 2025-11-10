# Tabla de frecuencia de palabras tokenizadas.

Función que cuenta la frecuencia de palabras tokenizadas.

## Usage

``` r
acep_token_table(x, u = 10)
```

## Arguments

- x:

  vector de palabras tokenizadas.

- u:

  número de corte para el top de palabras más frecuentes.

## Value

Si todas las entradas son correctas, la salida sera una tabla con la
frecuencia relativa y absoluta de palabras tokenizadas.

## Examples

``` r
tokens <- c(rep("paro",15), rep("piquete",25), rep("corte",20), rep("manifestación",10),
rep("bloqueo",5), rep("alerta",16), rep("ciudad",12), rep("sindicato",11), rep("paritaria",14),
rep("huelga",14), rep("escrache",15))
acep_token_table(tokens)
#>            token frec       prop
#> 1        piquete   25 0.16447368
#> 2          corte   20 0.13157895
#> 3         alerta   16 0.10526316
#> 4       escrache   15 0.09868421
#> 5           paro   15 0.09868421
#> 6         huelga   14 0.09210526
#> 7      paritaria   14 0.09210526
#> 8         ciudad   12 0.07894737
#> 9      sindicato   11 0.07236842
#> 10 manifestación   10 0.06578947
```
