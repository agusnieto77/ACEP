# Pipeline completo de análisis de conflictividad

Ejecuta un flujo de trabajo completo de análisis de texto que incluye:
limpieza opcional, conteo de menciones de un diccionario, y cálculo de
intensidad. Esta función encadena automáticamente las funciones
\`pipe_clean()\`, \`pipe_count()\` y \`pipe_intensity()\` para facilitar
análisis rápidos.

## Usage

``` r
acep_pipeline(texto, dic, clean = TRUE, ...)
```

## Arguments

- texto:

  Vector de caracteres con los textos a analizar.

- dic:

  Vector de caracteres con las palabras del diccionario de
  conflictividad (o cualquier otro diccionario temático) a buscar en los
  textos.

- clean:

  Lógico. Si \`TRUE\` (por defecto), aplica limpieza y normalización al
  texto antes del análisis usando \`acep_clean()\`.

- ...:

  Argumentos adicionales para pasar a \`acep_clean()\` cuando \`clean =
  TRUE\`. Por ejemplo: \`rm_stopwords = TRUE\`, \`rm_num = TRUE\`,
  \`tolower = TRUE\`.

## Value

Objeto de clase \`acep_result\` con tipo \`"intensidad"\` que contiene:

- `id`: Identificadores de cada texto

- `texto`: Textos analizados (limpios si \`clean = TRUE\`)

- `frecuencia`: Número de menciones del diccionario por texto

- `n_palabras`: Número total de palabras por texto

- `intensidad`: Índice normalizado de intensidad (frecuencia/n_palabras)

## Examples

``` r
if (FALSE) { # \dontrun{
# Pipeline completo con limpieza
textos <- c("El SUTEBA va al paro por mejoras salariales",
            "SOIP en lucha contra despidos")
dic_conflictos <- c("paro", "lucha", "reclamo", "protesta")
resultado <- acep_pipeline(textos, dic_conflictos,
                           clean = TRUE, rm_stopwords = TRUE)
print(resultado)

# Pipeline sin limpieza
resultado <- acep_pipeline(textos, dic_conflictos, clean = FALSE)
} # }
```
