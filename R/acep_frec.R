#' @title Frecuencia de menciones de palabras que refieren a conflictos.
#' @description Función que cuenta la frecuencia de menciones de palabras que refieren a conflictos en cada una de las notas/textos.
#' @param x vector de textos al que se le aplica la función de conteo de la frecuencia de menciones de palabras que refieren a conflictos.
#' @examples
#' notas$conflictos <- acep_frec(notas$nota)
#'

acep_frec <- function(x) {
  dicc = 'protesta|huelga|piquete|conflicto'
  stringr::str_count(x,dicc)
}
