# Tope de entradas del caché de regex

Cuando el caché alcanza este tamaño se vacía antes de agregar una nueva
entrada, evitando crecimiento de memoria sin límite en sesiones largas
que usan muchos diccionarios distintos. Un fallo de caché solo recompila
el patrón, por lo que la cota no afecta la correctitud de los conteos.

## Usage

``` r
.acep_regex_cache_max
```

## Format

An object of class `integer` of length 1.
