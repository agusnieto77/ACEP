# Limpiar caché de expresiones regulares

Elimina todos los patrones regex almacenados en el caché interno de
\`acep_count()\`. Útil para liberar memoria cuando se han procesado
muchos diccionarios diferentes o cuando se quiere forzar la
recompilación de patrones.

## Usage

``` r
acep_clear_regex_cache()
```

## Value

Devuelve \`NULL\` invisiblemente.

## Examples

``` r
# Limpiar el caché
acep_clear_regex_cache()
```
