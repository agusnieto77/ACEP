#' @title Cadenas de caracteres para limpiar y normalizar textos.
#' @description Cadenas de caracteres y expresiones regulares
#' para limpiar y normalizar textos.
#' @format Es un objeto de clase 'list' con 14 componentes (cadenas de
#' caracteres y expresiones regulares).
#'\describe{
#' \item{sw1}{es un string de palabras vacias.}
#' \item{sw2}{es un string de palabras vacias (complemento de sw1).}
#' \item{dias}{es un string de dias.}
#' \item{meses}{es un string de meses.}
#' \item{emojis}{es un string con expresiones regulares para emojis.}
#' \item{sintildes}{es un string de letras sin tildes.}
#' \item{tildes}{es un string de letras con tildes.}
#' \item{punt}{es un string de puntuación.}
#' \item{num}{es una expresión regular para números.}
#' \item{hashtag}{es una expresión regular para hashtag.}
#' \item{espacios}{es una expresión regular para espacios.}
#' \item{saltos}{es una expresión regular para saltos de línea.}
#' \item{url}{es una expresión regular para urls.}
#' \item{users}{es una expresión regular para usuarixs.}
#' }
#' @docType data
#' @usage data(acep_rs)
#' @keywords expresiones regulares
#' @examples
#' print(acep_rs)
"acep_rs"
