# Limpieza de texto.

Función que limpia y normaliza las notas/textos.

## Usage

``` r
acep_clean(
  x,
  tolower = TRUE,
  rm_cesp = TRUE,
  rm_emoji = TRUE,
  rm_hashtag = TRUE,
  rm_users = TRUE,
  rm_punt = TRUE,
  rm_num = TRUE,
  rm_url = TRUE,
  rm_meses = TRUE,
  rm_dias = TRUE,
  rm_stopwords = TRUE,
  rm_shortwords = TRUE,
  rm_newline = TRUE,
  rm_whitespace = TRUE,
  other_sw = NULL,
  u = 1
)
```

## Arguments

- x:

  vector de textos al que se le aplica la función de limpieza de texto.

- tolower:

  convierte los textos a minúsculas.

- rm_cesp:

  remueve caracteres especiales.

- rm_emoji:

  remueve los emojis.

- rm_hashtag:

  remueve los hashtags.

- rm_users:

  remueve las menciones de usuarixs de redes sociales.

- rm_punt:

  remueve la puntuación.

- rm_num:

  remueve números.

- rm_url:

  remueve las url.

- rm_meses:

  remueve los meses del año.

- rm_dias:

  remueve los dias de la semana.

- rm_stopwords:

  remueve palabras vacías.

- rm_shortwords:

  remueve las palabras cortas.

- rm_newline:

  remueve los saltos de linea.

- rm_whitespace:

  remueve los espacios en blanco.

- other_sw:

  su valor por defecto es NULL, sirve para ampliar el listado de
  stopwords con un nuevo vector de palabras.

- u:

  umbral de caracteres para la función rm_shortwords.

## Value

Si todas las entradas son correctas, la salida sera un vector de textos
normalizados.

## Examples

``` r
acep_clean("El SUTEBA fue al paro. Reclaman mejoras salariales.", rm_stopword = FALSE)
#> [1] "el suteba fue al paro reclaman mejoras salariales"
acep_clean("El SUTEBA fue al paro. Reclaman mejoras salariales.", rm_stopword = TRUE)
#> [1] "suteba paro reclaman mejoras salariales"
```
