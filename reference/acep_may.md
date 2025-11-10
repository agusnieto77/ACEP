# Convierte caracteres a mayusculas.

Esta función toma un vector de texto y convierte todas las letras
minúsculas en mayúsculas, manteniendo el resto de los caracteres sin
cambios.

## Usage

``` r
acep_may(x)
```

## Arguments

- x:

  es un vector de texto (caracteres) que se desea convertir a
  mayúsculas.

## Value

Devuelve un nuevo vector con todas las letras en mayúsculas.

## Examples

``` r
vector_texto <- c("soip", "cGt", "Sutna")
acep_may(vector_texto)
#> [1] "SOIP"  "CGT"   "SUTNA"
vector_numeros <- c(1, 2, 3, 4, 5)
acep_may(vector_numeros)
#> No ingresaste un vector de texto.
#>             Vuelve a intentarlo ingresando un vector de texto.
vector_mezclado <- c("sutna", 123, "Ate")
acep_may(vector_mezclado)
#> [1] "SUTNA" "123"   "ATE"  
```
