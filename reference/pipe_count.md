# Conteo de menciones en pipeline

Cuenta las menciones de palabras de un diccionario dentro de un flujo
pipeline. Esta función extrae los textos de un \`acep_corpus\`
(procesados o originales) y aplica \`acep_count()\` para detectar
ocurrencias del diccionario.

## Usage

``` r
pipe_count(corpus, dic, ...)
```

## Arguments

- corpus:

  Objeto \`acep_corpus\`. Debe ser un corpus válido creado con
  \`acep_corpus()\` o resultado de \`pipe_clean()\`.

- dic:

  Vector de caracteres con las palabras del diccionario a buscar.

- ...:

  Argumentos adicionales (actualmente no utilizados, reservado para
  futuras extensiones).

## Value

Objeto \`acep_result\` con tipo \`"frecuencia"\` que contiene un data
frame con: \`id\`, \`texto\` y \`frecuencia\` de menciones por texto.

## Examples

``` r
# Contar menciones en corpus
textos <- c("El SUTEBA va al paro", "SOIP en lucha y paro")
corpus <- acep_corpus(textos)
diccionario <- c("paro", "lucha", "protesta")
resultado <- pipe_count(corpus, diccionario)
print(resultado)
#> acep_result object
#> ==================
#> Tipo: frecuencia 
#> Filas: 2 
#> Columnas: 3 
#> Creado: 2025-11-10 00:42:22 
#> 
#> Primeras filas:
#>   id                texto frecuencia
#> 1  1 El SUTEBA va al paro          1
#> 2  2 SOIP en lucha y paro          2
```
