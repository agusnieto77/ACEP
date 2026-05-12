# Limpieza de texto con ACEP

Este artículo se propone explicar las distintas maneras de ejecutar la
función
[`acep_clean()`](https://agusnieto77.github.io/ACEP/reference/acep_clean.md).
En primer lugar, corresponde mencionar los parámetros que conforman la
función: Tolower, rm_cesp, rm_emoji, rm_hashtag, rm_users, rm_punt,
rm_num, rm_url, rm_meses, rm_dias, rm_stopwords, rm_shortwords,
rm_newline, rm_whitespace, other_sw.

Por defecto, todos los parámetros están seteados con el valor TRUE, es
decir que están activados a excepción de other_sw. Este parámetro está
marcado como NULL.

Para comprender el funcionamiento de
[`acep_clean()`](https://agusnieto77.github.io/ACEP/reference/acep_clean.md),
repasaremos cada uno de los parámetros con ejemplos. Utilizaremos una
base sintética de textos breves sobre protestas y reclamos para que la
vignette pueda reconstruirse sin depender de descargas externas.

## to lower

El parámetro tolower refiere a llevar todo el texto a minúscula.
Teniendo en cuenta que R es un software “case sensitive” (es decir,
sensible a las mayúsculas y minúsculas) resulta de interés que todas las
palabras queden en minúscula para que al realizar un conteo, no se
consideren distintas las palabras que difieran en el tipeo de mayúscula
o minúscula.

Lo que haremos será aislar cada uno de los parámetros, poniéndolos en
FALSE a excepción del que queremos probar.

En primer lugar cargamos la base de ejemplo:

``` r

library(ACEP)

base <- rep(c(
  "La Fraternidad anunció un paro de trenes en noviembre.\nMás información en https://example.com",
  "@usuario reclamó mejoras salariales!!! #Transporte 😊",
  "Martes 08 de noviembre: trabajadores en paro total.",
  "El sindicato pidió 123 respuestas al gobierno municipal.",
  "A b c de la protesta"
), length.out = 500)
```

Seleccionemos ahora tan sólo un tweet:

``` r

primer_tweet <- base[2]

primer_tweet
```

    #> [1] "@usuario reclamó mejoras salariales!!! #Transporte 😊"

Vemos que tiene algunas letras en mayúscula. Aplicamos el parámetro
tolower de la función
[`acep_clean()`](https://agusnieto77.github.io/ACEP/reference/acep_clean.md)
y verificamos el resultado.

``` r

minus <- acep_clean(primer_tweet,
               tolower = TRUE,
               rm_cesp = FALSE,
               rm_emoji = FALSE,
               rm_hashtag = FALSE,
               rm_users = FALSE,
               rm_punt = FALSE,
               rm_num = FALSE,
               rm_url = FALSE,
               rm_meses = FALSE,
               rm_dias = FALSE,
               rm_stopwords = FALSE,
               rm_shortwords = FALSE,
               rm_newline = FALSE,
               rm_whitespace = FALSE,
               other_sw = NULL)

cat(paste("****SIN tolower****\n", primer_tweet, "****\n", sep=""))
```

    #> ****SIN tolower****
    #> @usuario reclamó mejoras salariales!!! #Transporte 😊****

``` r

cat(paste("****CON tolower****\n", minus, "****\n", sep=""))
```

    #> ****CON tolower****
    #> @usuario reclamó mejoras salariales!!! #transporte 😊****

Efectivamente, los caracteres en mayúscula pasan a minúscula.

## rm_cesp

El parámetros rm_cesp refiere a los caracteres especiales. Es común que
en una base conformada por tweets (aunque no solamente) aparezcan muchos
caracteres especiales tales como tildes. Estos caracteres no hacen
ningún aporte al análisis semántico por lo que es conveniente
removerlos. Al igual que el caso anterior, aislamos el parámetro
rm_cesp.

``` r

cesp <- acep_clean(primer_tweet,
                     tolower = FALSE,
                     rm_cesp = TRUE,
                     rm_emoji = FALSE,
                     rm_hashtag = FALSE,
                     rm_users = FALSE,
                     rm_punt = FALSE,
                     rm_num = FALSE,
                     rm_url = FALSE,
                     rm_meses = FALSE,
                     rm_dias = FALSE,
                     rm_stopwords = FALSE,
                     rm_shortwords = FALSE,
                     rm_newline = FALSE,
                     rm_whitespace = FALSE,
                     other_sw = NULL)

cat(paste("****SIN rm_cesp****\n", primer_tweet, "****\n", sep=""))
```

    #> ****SIN rm_cesp****
    #> @usuario reclamó mejoras salariales!!! #Transporte 😊****

``` r

cat(paste("****CON rm_cesp****\n", cesp, "****\n", sep=""))
```

    #> ****CON rm_cesp****
    #> @usuario reclamo mejoras salariales!!! #Transporte 😊****

En este caso hay sólo una tilde en “conciliación” y fue removida.

## Emoji

Es común que aparezcan emojis en tweets o texto obtenido a través de
redes sociales. Estos caracteres puede ser problemáticos para el
análisis de texto y por este motivo se remueven con el parámetro
rm_emoji.

``` r

emoji <- acep_clean(primer_tweet,
                     tolower = FALSE,
                     rm_cesp = FALSE,
                     rm_emoji = TRUE,
                     rm_hashtag = FALSE,
                     rm_users = FALSE,
                     rm_punt = FALSE,
                     rm_num = FALSE,
                     rm_url = FALSE,
                     rm_meses = FALSE,
                     rm_dias = FALSE,
                     rm_stopwords = FALSE,
                     rm_shortwords = FALSE,
                     rm_newline = FALSE,
                     rm_whitespace = FALSE,
                     other_sw = NULL)

cat(paste("****SIN rm_emoji****\n", primer_tweet, "***\n", sep=""))
```

    #> ****SIN rm_emoji****
    #> @usuario reclamó mejoras salariales!!! #Transporte 😊***

``` r

cat(paste("****CON rm_emoji****\n", emoji, "****\n", sep=""))
```

    #> ****CON rm_emoji****
    #> @usuario reclamó mejoras salariales!!! #Transporte  ****

## Hashtag

Los \#hashtags son muy comunes en los textos de redes sociales. Son
también caracteres que esconden palabras cuando realizamos un análisis
semántico. Para removerlos, utilizamos el parámetro rm_hashtag.
Utilizamos otro tweet de la base que contiene \#hashtag

``` r

con_hash <- base[40]
hash <- acep_clean(base[40],
                     tolower = FALSE,
                     rm_cesp = FALSE,
                     rm_emoji = FALSE,
                     rm_hashtag = TRUE,
                     rm_users = FALSE,
                     rm_punt = FALSE,
                     rm_num = FALSE,
                     rm_url = FALSE,
                     rm_meses = FALSE,
                     rm_dias = FALSE,
                     rm_stopwords = FALSE,
                     rm_shortwords = FALSE,
                     rm_newline = FALSE,
                     rm_whitespace = FALSE,
                     other_sw = NULL)

cat(paste("****SIN rm_hashtag****\n", con_hash, "****\n", sep=""))
```

    #> ****SIN rm_hashtag****
    #> A b c de la protesta****

``` r

cat(paste("****CON rm_hashtag****\n", hash, "****\n", sep=""))
```

    #> ****CON rm_hashtag****
    #> A b c de la protesta****

NOTA: se elimina todo el \#hashtags, no sólo el símbolo (#Transporte)

## Users

La mención de usuarios es algo que suele aparecer en análisis de texto
en redes. Respuestas a otros tweets o menciones a usuarios que queremos
remover. Para esto utilizamos el parámetro rm_users

``` r

con_user <- base[12]
user <- acep_clean(base[12],
                     tolower = FALSE,
                     rm_cesp = FALSE,
                     rm_emoji = FALSE,
                     rm_hashtag = FALSE,
                     rm_users = TRUE,
                     rm_punt = FALSE,
                     rm_num = FALSE,
                     rm_url = FALSE,
                     rm_meses = FALSE,
                     rm_dias = FALSE,
                     rm_stopwords = FALSE,
                     rm_shortwords = FALSE,
                     rm_newline = FALSE,
                     rm_whitespace = FALSE,
                     other_sw = NULL)

cat(paste("****SIN rm_users****\n", con_user, "****\n", sep=""))
```

    #> ****SIN rm_users****
    #> @usuario reclamó mejoras salariales!!! #Transporte 😊****

``` r

cat(paste("****CON rm_users****\n", user, "****\n", sep=""))
```

    #> ****CON rm_users****
    #>  reclamó mejoras salariales!!! #Transporte 😊****

NOTA: Igual que con el \#hashtag, quita todo, no sólo el símbolo @

## Puntuación

La puntuación son caracteres que pueden aparecer muchísimas veces, pero
nuevamente, aportan a la compresión lectora pero no al conteo de
palabras o análisis semántica. La podemos remover con el parámetro
rm_punt.

``` r

punt <- base[13]
s_punt <- acep_clean(base[13],
                     tolower = FALSE,
                     rm_cesp = FALSE,
                     rm_emoji = FALSE,
                     rm_hashtag = FALSE,
                     rm_users = FALSE,
                     rm_punt = TRUE,
                     rm_num = FALSE,
                     rm_url = FALSE,
                     rm_meses = FALSE,
                     rm_dias = FALSE,
                     rm_stopwords = FALSE,
                     rm_shortwords = FALSE,
                     rm_newline = FALSE,
                     rm_whitespace = FALSE,
                     other_sw = NULL)

cat(paste("****SIN rm_punt****\n", punt, "****\n", sep=""))
```

    #> ****SIN rm_punt****
    #> Martes 08 de noviembre: trabajadores en paro total.****

``` r

cat(paste("****CON rm_punt****\n", s_punt, "****\n", sep=""))
```

    #> ****CON rm_punt****
    #> Martes 08 de noviembre  trabajadores en paro total ****

## Números

Siguiendo la misma lógica, los números no aportan información relevante
y requieren ser limpiados de nuestra base. Más aún en análisis de texto
obtenido a través de redes sociales, ya sea por nombres de usuario o
información codificada, aparece una gran cantidad de números. Se remueve
con el parámetro rm_num.

``` r

num <- base[70]
num_s <- acep_clean(base[70],
                     tolower = FALSE,
                     rm_cesp = FALSE,
                     rm_emoji = FALSE,
                     rm_hashtag = FALSE,
                     rm_users = FALSE,
                     rm_punt = FALSE,
                     rm_num = TRUE,
                     rm_url = FALSE,
                     rm_meses = FALSE,
                     rm_dias = FALSE,
                     rm_stopwords = FALSE,
                     rm_shortwords = FALSE,
                     rm_newline = FALSE,
                     rm_whitespace = FALSE,
                     other_sw = NULL)

cat(paste("****SIN rm_num****\n", num, "****\n", sep=""))
```

    #> ****SIN rm_num****
    #> A b c de la protesta****

``` r

cat(paste("****CON rm_num****\n", num_s, "****\n", sep=""))
```

    #> ****CON rm_num****
    #> A b c de la protesta****

## URLs

Las URLs aparecen comúnmente, links o imágenes que se codifican como
urls. Para removerlas usamos el parámetro rm_url

``` r

num <- base[70]
num_s <- acep_clean(base[70],
                     tolower = FALSE,
                     rm_cesp = FALSE,
                     rm_emoji = FALSE,
                     rm_hashtag = FALSE,
                     rm_users = FALSE,
                     rm_punt = FALSE,
                     rm_num = FALSE,
                     rm_url = TRUE,
                     rm_meses = FALSE,
                     rm_dias = FALSE,
                     rm_stopwords = FALSE,
                     rm_shortwords = FALSE,
                     rm_newline = FALSE,
                     rm_whitespace = FALSE,
                     other_sw = NULL)

cat(paste("****SIN rm_url****\n", num, "****\n", sep=""))
```

    #> ****SIN rm_url****
    #> A b c de la protesta****

``` r

cat(paste("****CON rm_url****\n", num_s,  "****\n", sep=""))
```

    #> ****CON rm_url****
    #> A b c de la protesta****

## Meses

En el caso de querer remover meses del año, podemos utilizar el
parámetro rm_meses. En este caso, el tweet tiene la palabra “noviembre”

``` r

meses <- base[70]
meses_s <- acep_clean(base[70],
                     tolower = FALSE,
                     rm_cesp = FALSE,
                     rm_emoji = FALSE,
                     rm_hashtag = FALSE,
                     rm_users = FALSE,
                     rm_punt = FALSE,
                     rm_num = FALSE,
                     rm_url = FALSE,
                     rm_meses = TRUE,
                     rm_dias = FALSE,
                     rm_stopwords = FALSE,
                     rm_shortwords = FALSE,
                     rm_newline = FALSE,
                     rm_whitespace = FALSE,
                     other_sw = NULL)

cat(paste("****SIN rm_mes****\n", meses, "****\n", sep=""))
```

    #> ****SIN rm_mes****
    #> A b c de la protesta****

``` r

cat(paste("****CON rm_mes****\n", meses_s, "****\n", sep=""))
```

    #> ****CON rm_mes****
    #> A b c de la protesta****

## Días

En el caso de querer remover días de la semana, podemos utilizar el
parámetro rm_dias. En este caso, el tweet tiene la palabra “martes”

``` r

dia <- base[429]
dia_s <- acep_clean(base[429],
                     tolower = FALSE,
                     rm_cesp = FALSE,
                     rm_emoji = FALSE,
                     rm_hashtag = FALSE,
                     rm_users = FALSE,
                     rm_punt = FALSE,
                     rm_num = FALSE,
                     rm_url = FALSE,
                     rm_meses = FALSE,
                     rm_dias = TRUE,
                     rm_stopwords = FALSE,
                     rm_shortwords = FALSE,
                     rm_newline = FALSE,
                     rm_whitespace = FALSE,
                     other_sw = NULL)

cat(paste("****SIN rm_dias****\n", dia, "****\n", sep=""))
```

    #> ****SIN rm_dias****
    #> El sindicato pidió 123 respuestas al gobierno municipal.****

``` r

cat(paste("****CON rm_dias****\n", dia_s, "****\n", sep=""))
```

    #> ****CON rm_dias****
    #> El sindicato pidió 123 respuestas al gobierno municipal.****

## Stop words

Las stopwords son palabras que tienen distintas funciones aportando a la
comprensión del texto. Sin embargo, si buscamos realizar un conteo de
palabras, resultan contraproducentes ya que se repiten muchas veces y no
aportan al contenido. Se pueden remover con el parámetro rm_stopwords.

La lista de palabras consideradas “stop words” depende del idioma y del
dominio del corpus. En este ejemplo usamos la configuración interna de
[`acep_clean()`](https://agusnieto77.github.io/ACEP/reference/acep_clean.md).

``` r

stopwords <- c("de", "la", "el")
stopw <- base[429]
stopw_w <- acep_clean(base[429],
                     tolower = FALSE,
                     rm_cesp = FALSE,
                     rm_emoji = FALSE,
                     rm_hashtag = FALSE,
                     rm_users = FALSE,
                     rm_punt = FALSE,
                     rm_num = FALSE,
                     rm_url = FALSE,
                     rm_meses = FALSE,
                     rm_dias = FALSE,
                     rm_stopwords = TRUE,
                     rm_shortwords = FALSE,
                     rm_newline = FALSE,
                     rm_whitespace = FALSE,
                     other_sw = NULL)

cat(paste("****SIN rm_stopwords****\n", stopw, "****\n", sep=""))
```

    #> ****SIN rm_stopwords****
    #> El sindicato pidió 123 respuestas al gobierno municipal.****

``` r

cat(paste("****CON rm_stopwords****\n", stopw_w, "****\n", sep=""))
```

    #> ****CON rm_stopwords****
    #> El sindicato pidió 123 respuestas   gobierno municipal.****

## Short words

En caso de querer eliminar las palabras de 1 sólo caracter que pueden
quedar como “residuos” de limpiezas previas y que probablemente no
tengan contenido útil, lo hacemos con el parámetro rm_shortwords.

``` r

short <- base[97]
short_s <- acep_clean(base[97],
                     tolower = FALSE,
                     rm_cesp = FALSE,
                     rm_emoji = FALSE,
                     rm_hashtag = FALSE,
                     rm_users = FALSE,
                     rm_punt = FALSE,
                     rm_num = FALSE,
                     rm_url = FALSE,
                     rm_meses = FALSE,
                     rm_dias = FALSE,
                     rm_stopwords = FALSE,
                     rm_shortwords = TRUE,
                     rm_newline = FALSE,
                     rm_whitespace = FALSE,
                     other_sw = NULL)

cat(paste("****SIN rm_shortwords****\n", short, "****\n", sep=""))
```

    #> ****SIN rm_shortwords****
    #> @usuario reclamó mejoras salariales!!! #Transporte 😊****

``` r

cat(paste("****CON rm_shortwords****\n", short_s, "****\n", sep=""))
```

    #> ****CON rm_shortwords****
    #> @usuario reclamó mejoras salariales!!! #Transporte 😊****

## New line

El parámetro rm_newline se utiliza en caso de querer eliminar los saltos
de línea. En este ejemplo hay un salgo de línea antes del link del final
del tweet.

``` r

newl <- base[2]
newl_s <- acep_clean(base[2],
                     tolower = FALSE,
                     rm_cesp = FALSE,
                     rm_emoji = FALSE,
                     rm_hashtag = FALSE,
                     rm_users = FALSE,
                     rm_punt = FALSE,
                     rm_num = FALSE,
                     rm_url = FALSE,
                     rm_meses = FALSE,
                     rm_dias = FALSE,
                     rm_stopwords = FALSE,
                     rm_shortwords = FALSE,
                     rm_newline = TRUE,
                     rm_whitespace = FALSE,
                     other_sw = NULL)

cat(paste("****SIN rm_newline****\n",newl, "****\n", sep=""))
```

    #> ****SIN rm_newline****
    #> @usuario reclamó mejoras salariales!!! #Transporte 😊****

``` r

cat(paste("****CON rm_newline****\n",newl_s, "****\n", sep=""))
```

    #> ****CON rm_newline****
    #> @usuario reclamó mejoras salariales!!! #Transporte 😊****

## Whitespace

Ya sea porque los usuarios tipean dobles espacios por error o por
limpiezas previas, suelen quedar espacios en blanco en los textos que no
ayudan a la legibilidad del texto. El parámetro rm_whitespace elimina
los espacios en blanco.

En este ejemplo, entre “en nuestro” hay un doble espacio.

``` r

white <- base[60]
white_s <- acep_clean(base[60],
                     tolower = FALSE,
                     rm_cesp = FALSE,
                     rm_emoji = FALSE,
                     rm_hashtag = FALSE,
                     rm_users = FALSE,
                     rm_punt = FALSE,
                     rm_num = FALSE,
                     rm_url = FALSE,
                     rm_meses = FALSE,
                     rm_dias = FALSE,
                     rm_stopwords = FALSE,
                     rm_shortwords = FALSE,
                     rm_newline = FALSE,
                     rm_whitespace = TRUE,
                     other_sw = NULL)

cat(paste("****SIN rm_whitespace****\n", white, "****\n", sep=""))
```

    #> ****SIN rm_whitespace****
    #> A b c de la protesta****

``` r

cat(paste("****CON rm_whitespace****\n", white_s, "****\n", sep=""))
```

    #> ****CON rm_whitespace****
    #> A b c de la protesta****

## Other Stop words

Es posible que la lista de stop words no sea exhaustiva. Si el usuario
desea agregar palabras a la lista de stop words, lo puede hacer con el
parámetro other_sw. En este ejemplo, agregamos la palabra “Fraternidad”
como stop word para que la detect y la remueva. Hay que tener en cuenta
que para este caso, también debe estar en TRUE el parámetro
“rm_stopwords”. Posteriormente, se agrega entre comillas la palabra de
remover. En caso de querer agregar más de una palabra, se puede crear un
vector string con cada una de las palabras separadas por coma. En este
caso se agregan las palabras “conciliación” y “Fraternidad”.

``` r

osw <- base[2]
osw_s <- acep_clean(base[2],
                     tolower = FALSE,
                     rm_cesp = FALSE,
                     rm_emoji = FALSE,
                     rm_hashtag = FALSE,
                     rm_users = FALSE,
                     rm_punt = FALSE,
                     rm_num = FALSE,
                     rm_url = FALSE,
                     rm_meses = FALSE,
                     rm_dias = FALSE,
                     rm_stopwords = TRUE,
                     rm_shortwords = FALSE,
                     rm_newline = FALSE,
                     rm_whitespace = FALSE,
                     other_sw = c("conciliación", "Fraternidad"))

cat(paste("****SIN other_sw****\n", osw, "****\n", sep=""))
```

    #> ****SIN other_sw****
    #> @usuario reclamó mejoras salariales!!! #Transporte 😊****

``` r

cat(paste("****CON other_sw****\n", osw_s, "****\n", sep=""))
```

    #> ****CON other_sw****
    #> @usuario reclamó mejoras salariales!!! #Transporte 😊****
