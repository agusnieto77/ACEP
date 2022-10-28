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
#' @param other_sw su valor por defecto es NULL, sirve para ampliar el listado de stopwords con un nuevo vector de palabras.
#' @param u umbral de caracteres para la función rm_shortwords.
#' @param tolower convierte los textos a minúsculas.
#' @keywords normalización
#' @examples
#' rev_puerto <- acep_bases$rev_puerto
#' rev_puerto$nota_limpia <- acep_clean(rev_puerto$nota)
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
                       other_sw = NULL,
                       u = 1) {

  if(tolower == TRUE){
    x <- gsub(pattern = '([[:upper:]])', perl = TRUE, replacement = '\\L\\1', x)}
  if(tolower == TRUE){
    x <- chartr(ACEP::acep_rs$tildes, tolower(ACEP::acep_rs$tildes), x)}
  if(rm_cesp == TRUE){
    x <- chartr(ACEP::acep_rs$tildes, ACEP::acep_rs$sintildes, x)}
  if(rm_url == TRUE){
    x <- gsub(ACEP::acep_rs$url, '', x, perl = TRUE)}
  if(rm_emoji == TRUE){
    x <- gsub(ACEP::acep_rs$emojis, ' ', x, perl = TRUE)}
  if(rm_hashtag == TRUE){
    x <- gsub(ACEP::acep_rs$hashtag, '', x, perl = TRUE)}
  if(rm_users == TRUE){
    x <- gsub(ACEP::acep_rs$users, '', x, perl = TRUE)}
  if(rm_punt == TRUE){
    x <- gsub(ACEP::acep_rs$punt1, ' ', x, perl = TRUE)}
  if(rm_num == TRUE){
    x <- gsub(ACEP::acep_rs$num, '', x, perl = TRUE)}
  if(rm_meses == TRUE){
    x <- gsub(ACEP::acep_rs$meses, '', x, perl = TRUE)}
  if(rm_dias == TRUE){
    x <- gsub(ACEP::acep_rs$dias, '', x, perl = TRUE)}
  if(rm_stopwords == TRUE){
    if(is.null(other_sw)){
      x <- gsub(ACEP::acep_rs$stopwords, " ", x, perl = FALSE)
    } else {
      othersw <- paste0('|\\b',other_sw,'\\b', collapse = '')
      x <- gsub(paste0(ACEP::acep_rs$stopwords,othersw), " ", x, perl = FALSE)
    }
  }
  if(rm_shortwords == TRUE){
    x <- gsub(paste0('\\b[[:alpha:]]{1,',u,'}\\b'), ' ', x, perl = FALSE)}
  if(rm_punt == TRUE){
    x <- gsub(ACEP::acep_rs$punt2, '', x, perl = TRUE)}
  if(rm_newline == TRUE){
    x <- gsub(ACEP::acep_rs$saltos, ' ', x, perl = TRUE)}
  if(rm_whitespace == TRUE){
    gsub(ACEP::acep_rs$espacios, '', x, perl = TRUE)
  } else {
    x
  }
}
