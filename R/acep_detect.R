#' @title Detección de menciones de palabras.
#' @description Función que detecta de menciones de palabras que refieren a conflictos en cada una de las notas/textos.
#' @param x vector de textos al que se le aplica la función de detección de menciones de palabras del diccionario.
#' @param y vector de palabras del diccionario utilizado.
#' @param u umbral para atribuir valor positivo a la detección de las menciones.
#' @param tolower convierte los textos a minúsculas.
#' @keywords indicadores
#' @examples
#' rev_puerto <- acep_bases$rev_puerto
#' dicc_violencia <- acep_diccionarios$dicc_viol_gp
#' rev_puerto$conflictos_detect <- acep_detect(rev_puerto$nota, dicc_violencia)
#' rev_puerto |> head()
#' @export

acep_detect <- function(x, y, u = 1, tolower = TRUE) {
  dicc = paste0(y, collapse = '|')
  if(tolower == TRUE){
    detect <- sapply(gregexpr(dicc, tolower(x)), function(z) sum(z != -1))
  } else {
    detect <- sapply(gregexpr(dicc, x), function(z) sum(z != -1))
  }
  ifelse(detect >= u, 1, 0)
}
