# Función para extraer tripletes SVO (Sujeto-Verbo-Objeto).

Función que devuelve seis objetos data.frame con etiquetado POS (modelo
spacyr) y relaciones sintácticas (modelo rsyntax) que permiten
reconstruir estructuras sintácticas como SVO y Sujeto-Predicado. Una vez
seleccionadas las notas periodísticas referidas a conflictos, esta
función permite extraer sujetos de la protesta, acción realizada y
objeto(s) de la acción. También devuelve entidades nombradas (NER).

## Usage

``` r
acep_svo(acep_tokenindex, prof_s = 3, prof_o = 3, u = 1)
```

## Source

[Dependencias Universales para taggeo
POS](https://universaldependencies.org/)

[Sobre el paquete
rsyntax](https://cran.r-project.org/web/packages/rsyntax/rsyntax.pdf)

## Arguments

- acep_tokenindex:

  data.frame con el etiquetado POS y las relaciones de dependencia
  generado con la función acep_postag.

- prof_s:

  es un numero entero positivo que determina la profundidad a la que se
  buscan las relaciones dentro del sujeto. Este parámetro se hereda del
  la función children() del paquete {rsyntax}. Se recomienda no superar
  el valor 2.

- prof_o:

  es un numero entero positivo que determina la profundidad a la que se
  buscan las relaciones dentro del objeto. Este parámetro se hereda del
  la función children() del paquete {rsyntax}. Se recomienda no superar
  el valor 2.

- u:

  numero entero que indica el umbral de palabras del objeto en la
  reconstrucción SVO.

## Value

Si todas las entradas son correctas, la salida sera una lista con tres
bases de datos en formato tabular.

## References

Welbers, K., Atteveldt, W. van, & Kleinnijenhuis, J. 2021. Extracting
semantic relations using syntax: An R package for querying and reshaping
dependency trees. Computational Communication Research, 3-2, 1-16.
[(link al
articulo)](https://www.aup-online.com/content/journals/10.5117/CCR2021.2.003.WELB?TRACK)

## Examples

``` r
if (FALSE) { # \dontrun{
acep_svo(acep_bases$spacy_postag)
} # }
```
