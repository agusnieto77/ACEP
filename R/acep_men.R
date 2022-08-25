#' @title Frecuencia de menciones de palabras.
#' @description Función que cuenta la frecuencia de menciones de palabras que refieren a conflictos en cada una de las notas/textos.
#' @param x vector de textos al que se le aplica la función de conteo de la frecuencia de menciones de palabras del diccionario.
#' @param y vector de palabras del diccionario utilizado.
#' @param tolower convierte los textos a minúsculas.
#' @export acep_men
#' @return Si todas las entradas son correctas, la salida será un vector con una frecuencia de palabras de un diccionario.
#' @keywords indicadores
#' @examples
#' rev_puerto <- acep_bases$rev_puerto
#' dicc_violencia <- acep_diccionarios$dicc_viol_gp
#' rev_puerto$conflictos <- acep_men(rev_puerto$nota, dicc_violencia)
#' rev_puerto |> head()
#' @export
acep_men <- function(x,y,tolower = TRUE) {
  dicc = paste0(y, collapse = '|')
  if(tolower == TRUE){
    sapply(gregexpr(dicc, tolower(x), perl=TRUE), function(z) sum(z != -1))
  } else {
    sapply(gregexpr(dicc, x, perl=TRUE), function(z) sum(z != -1))
  }
}

