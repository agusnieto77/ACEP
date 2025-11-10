# Convierte caracteres a minúsculas.

Esta función toma un vector de texto y convierte todas las letras
mayusculas en minúsculas, manteniendo el resto de los caracteres sin
cambios.

## Usage

``` r
acep_min(x)
```

## Arguments

- x:

  Un vector de texto (caracteres) que se desea convertir a minúsculas.

## Value

Devuelve un nuevo vector con todas las letras en minúsculas.

## Examples

``` r
vector_texto <- c("SUTEBA", "Sindicato", "PEN")
acep_min(vector_texto)
#> [1] "suteba"    "sindicato" "pen"      
vector_numeros <- c(1, 2, 3, 4, 5)
acep_min(vector_numeros)
#> No ingresaste un vector de texto.
#>             Vuelve a intentarlo ingresando un vector de texto.
vector_mezclado <- c("Soip", 123, "CGT")
acep_min(vector_mezclado)
#> [1] "soip" "123"  "cgt" 
```
