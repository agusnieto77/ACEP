# Procesamiento de textos en lotes para optimizar memoria

Divide un vector grande de textos en lotes (chunks) mas pequenos y los
procesa secuencialmente aplicando una funcion de ACEP. Esta estrategia
permite analizar corpus extensos (millones de documentos) sin superar la
capacidad de memoria RAM disponible. La funcion combina automaticamente
los resultados de todos los lotes.

## Usage

``` r
acep_process_chunks(
  texto,
  funcion,
  chunk_size = 1000,
  show_progress = TRUE,
  ...
)
```

## Arguments

- texto:

  Vector de caracteres con los textos a procesar.

- funcion:

  Funcion de ACEP a aplicar a cada lote. Ejemplos: \`acep_clean\`,
  \`acep_token\`, \`acep_count\`, \`acep_upos\`, etc. Debe ser una
  funcion que acepte un vector de textos como primer argumento.

- chunk_size:

  Numero de textos por lote. Valores mas bajos reducen el consumo de
  memoria pero aumentan el tiempo total de procesamiento. Por defecto:
  1000.

- show_progress:

  Logico. Si \`TRUE\`, muestra mensajes informativos sobre el progreso
  del procesamiento (que lote se esta procesando). Por defecto:
  \`TRUE\`.

- ...:

  Argumentos adicionales que se pasan directamente a la funcion
  especificada en el parametro \`funcion\`. Ejemplo: si \`funcion =
  acep_clean\`, puede pasar \`rm_stopwords = TRUE\`, \`tolower = TRUE\`,
  etc.

## Value

El tipo de resultado depende de la funcion aplicada:

- Si la funcion retorna un vector, devuelve un vector combinado

- Si la funcion retorna un data frame, devuelve un data frame combinado
  (rbind)

- Si la funcion retorna una lista, devuelve una lista de listas

## Examples

``` r
if (FALSE) { # \dontrun{
# Procesar 10,000 textos con limpieza en lotes de 1000
textos_limpios <- acep_process_chunks(
  texto = corpus_grande,
  funcion = acep_clean,
  chunk_size = 1000,
  rm_stopwords = TRUE
)

# Tokenizar corpus masivo
tokens <- acep_process_chunks(
  texto = corpus_masivo,
  funcion = acep_token,
  chunk_size = 500,
  tolower = TRUE
)

# Contar menciones en corpus grande
diccionario <- c("paro", "huelga", "protesta")
frecuencias <- acep_process_chunks(
  texto = corpus_grande,
  funcion = acep_count,
  chunk_size = 2000,
  dic = diccionario
)
} # }
```
