# Crear patrón regex para diccionarios de conteo

Escapa los metacaracteres de cada término (para tratarlos como texto
literal, evitando coincidencias accidentales o errores de regex) y
convierte un espacio inicial o final en un límite de palabra (\b), de
modo que " paro " coincida solo con la palabra completa.

## Usage

``` r
.acep_count_pattern(dic)
```
