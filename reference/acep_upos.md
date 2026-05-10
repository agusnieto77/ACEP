# Función para etiquetado POS, lematización, tokenización.

Función que devuelve un marco de datos objetos con etiquetado POS
(modelo udpipe) para su posterior procesamiento con la función
acep_postag.

## Usage

``` r
acep_upos(texto, modelo = "spanish")
```

## Source

[Dependencias Universales para taggeo
POS](https://universaldependencies.org/)

[Sobre el modelo
UDPipe](https://ufal.mff.cuni.cz/~straka/papers/2017-conll_udpipe.pdf)

[Sobre el paquete rsyntax](https://CRAN.R-project.org/package=rsyntax)

## Arguments

- texto:

  vector con los textos a procesar.

- modelo:

  idioma del modelo de etiquetado POS del paquete `udpipe`.

## Value

Si todas las entradas son correctas, la salida sera un marco de datos
con 17 variables.

## References

Welbers, K., Atteveldt, W. van, & Kleinnijenhuis, J. 2021. Extracting
semantic relations using syntax: An R package for querying and reshaping
dependency trees. Computational Communication Research, 3-2, 1-16.
[doi:10.5117/CCR2021.2.003.WELB](https://doi.org/10.5117/CCR2021.2.003.WELB)

## Examples

``` r
if (FALSE) { # \dontrun{
texto <- "El SOIP declara la huelga en demanda de aumento salarial."
acep_upos(texto)
} # }
```
