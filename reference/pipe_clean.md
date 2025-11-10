# Limpieza de texto en pipeline

Aplica limpieza y normalización de texto dentro de un flujo pipeline.
Esta función actúa como adaptador de \`acep_clean()\` para trabajar con
objetos \`acep_corpus\`, registrando las transformaciones aplicadas.

## Usage

``` r
pipe_clean(corpus, ...)
```

## Arguments

- corpus:

  Objeto \`acep_corpus\` o vector de caracteres. Si se pasa un vector,
  se crea automáticamente un objeto \`acep_corpus\`.

- ...:

  Argumentos para \`acep_clean()\`. Ejemplos: \`rm_stopwords = TRUE\`,
  \`rm_num = TRUE\`, \`tolower = TRUE\`, \`rm_punt = TRUE\`.

## Value

Objeto \`acep_corpus\` con el campo \`texto_procesado\` actualizado y
registro de la transformación en \`procesamiento\$limpieza\`.

## Examples

``` r
# Crear corpus y limpiar
textos <- c("El SUTEBA va al paro!!!", "SOIP protesta 123")
corpus <- acep_corpus(textos)
corpus_limpio <- pipe_clean(corpus, rm_punt = TRUE, rm_num = TRUE)
print(corpus_limpio)
#> acep_corpus object
#> ==================
#> Documentos: 2 
#> Procesado: TRUE 
#> Pasos aplicados: 1 
#> Funciones: limpieza 
```
