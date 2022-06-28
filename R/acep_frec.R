#' @title Frecuencia de menciones de palabras.
#' @description Función que cuenta la frecuencia de menciones de palabras que refieren a conflictos en cada una de las notas/textos.
#' @param x vector de textos al que se le aplica la función de conteo de la frecuencia de menciones de palabras del diccionario.
#' @param y vector de palabras del diccionario utilizado.
#' @param tolower convierte los textos a minúsculas.
#' @examples
#' notas$conflictos <- acep_frec(notas$nota, dicc_violencia)
#'

acep_frec <- function(x,y,tolower = TRUE) {
  dicc = paste0(y, collapse = '|')
  if(tolower == TRUE){
    sapply(gregexpr(dicc, tolower(x)), function(z) sum(z != -1))
  } else {
    sapply(gregexpr(dicc, x), function(z) sum(z != -1))
  }
}
