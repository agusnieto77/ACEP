# Consultar tamaño del caché de regex

Devuelve el número de patrones regex almacenados actualmente en el caché
interno de \`acep_count()\`. Cada diccionario único genera una entrada
en el caché.

## Usage

``` r
acep_regex_cache_size()
```

## Value

Número entero con la cantidad de patrones en caché.

## Examples

``` r
# Ver cuántos patrones hay en caché
acep_regex_cache_size()
#> [1] 1
```
