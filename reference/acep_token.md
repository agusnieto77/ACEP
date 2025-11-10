# Tokenizador.

Función que tokeniza las notas/textos.

## Usage

``` r
acep_token(x, tolower = TRUE, cleaning = TRUE)
```

## Arguments

- x:

  vector de textos al que se le aplica la función de tokenización.

- tolower:

  convierte los textos a minúsculas.

- cleaning:

  hace una limpieza de los textos.

## Value

Si todas las entradas son correctas, la salida será un data.frame con
las palabras tokenizadas.

## Examples

``` r
acep_token("Huelga de obreros del pescado en el puerto")
#>   texto_id  tokens
#> 1        1  huelga
#> 2        1 obreros
#> 3        1 pescado
#> 4        1  puerto
```
