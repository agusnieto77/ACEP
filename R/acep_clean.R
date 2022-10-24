#' @title Limpieza de texto.
#' @description Función que limpia y normaliza las notas/textos.
#' @param x vector de textos al que se le aplica la función de limpieza de texto.
#' @param rm_hashtag remueve los hashtags.
#' @param rm_emoji remueve los emojis.
#' @param rm_punt remueve la puntuación.
#' @param rm_num remueve números.
#' @param rm_whitespace remueve los espacios en blanco.
#' @param rm_newline remueve los saltos de línea.
#' @param rm_cesp remueve caracteres especiales.
#' @param rm_stopwords remueve palabras vacías.
#' @param rm_dias remueve los días de la semana.
#' @param rm_meses remueve los meses del año.
#' @param rm_shortwords remueve las palabras cortas.
#' @param rm_url remueve las url.
#' @param rm_users remueve las menciones de usuarixs de redes sociales.
#' @param u umbral de caracteres para la función rm_shortwords.
#' @param tolower convierte los textos a minúsculas.
#' @keywords normalización
#' @examples
#' rev_puerto <- acep_bases$rev_puerto
#' rev_puerto$conflictos <- acep_clean(rev_puerto$nota)
#' rev_puerto |> head()
#' @export

acep_clean <- function(x,
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
                       u = 1) {

  punt = '[[:punct:]]*'
  num = '[[:digit:]]*'
  hashtag = '#\\S+'
  espacios = "^ *|(?<= ) | *$"
  saltos = '[ \t\r\n]'
  shortwords = paste0('\\b[[:alpha:]]{1,',u,'}\\b')
  url = paste0('http\\S+|ftp\\S+|Http\\S+|Ftp\\S+', '|', toupper('http\\S+|ftp\\S+'))
  users = '@\\S+'

  if(tolower == TRUE){
    x <- tolower(x)}
  if(rm_cesp == TRUE){
    x <- chartr(ACEP::acep_rs$tildes, ACEP::acep_rs$sintildes, x)}
  if(rm_emoji == TRUE){
    x <- gsub(ACEP::acep_rs$emoji, " ", x, perl = TRUE)}
  if(rm_hashtag == TRUE){
    x <- gsub(hashtag, "", x, perl = TRUE)}
  if(rm_users == TRUE){
    x <- gsub(users, "", x, perl = TRUE)}
  if(rm_punt == TRUE){
    x <- gsub(punt, "", x, perl = TRUE)}
  if(rm_num == TRUE){
    x <- gsub(num, "", x, perl = TRUE)}
  if(rm_url == TRUE){
    x <- gsub(url, "", x, perl = TRUE)}
  if(rm_meses == TRUE){
    x <- gsub(ACEP::acep_rs$meses, "", x, perl = TRUE)}
  if(rm_dias == TRUE){
    x <- gsub(ACEP::acep_rs$dias, "", x, perl = TRUE)}
  if(rm_stopwords == TRUE){
    x <- gsub(ACEP::acep_rs$stopwords, " ", x, perl = FALSE)}
  if(rm_shortwords == TRUE){
    x <- gsub(shortwords, " ", x, perl = FALSE)}
  if(rm_newline == TRUE){
    x <- gsub(saltos, " ", x, perl = TRUE)}
  if(rm_whitespace == TRUE){
    gsub(espacios, "", x, perl = TRUE)
  } else {
    x
  }
}
