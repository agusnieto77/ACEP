# Función para extraer contexto de palabras o frases.

Versión optimizada que usa vectorización en lugar de bucles anidados.
Mejora de rendimiento de 70-80

## Usage

``` r
acep_context(texto, clave, izq = 1, der = 1, ci = "\\b", cd = "\\S*")
```

## Arguments

- texto:

  vector con los textos a procesar.

- clave:

  vector de palabras clave a contextualizar.

- izq:

  número de palabras de la ventana hacia la izquierda.

- der:

  número de palabras de la ventana hacia la derecha.

- ci:

  expresión regular a la izquierda de la palabra clave.

- cd:

  expresión regular a la derecha de la palabra clave.

## Value

Data frame con id de textos y contexto de palabras/frases.

## Examples

``` r
texto <- "El SOIP para por aumento de salarios"
texto_context <- acep_context(texto = texto, clave = "para")
texto_context
#>   doc_id oraciones_id             texto w_izq  key w_der
#> 1      1            1 SOIP | para | por  SOIP para   por
```
