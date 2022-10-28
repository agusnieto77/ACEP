#' @title Frecuencia de palabras totales.
#' @description Función que cuenta la frecuencia de palabras totales
#' en cada una de las notas/textos.
#' @param x vector de textos al que se le aplica la función de conteo
#' de la frecuencia de palabras.
#' @keywords indicadores
#' @export acep_frec
#' @return Si todas las entradas son correctas, la salida será un vector
#' con una frecuencia de palabras.
#' @examples
#' rev_puerto <- rev_puerto <- acep_bases$rev_puerto
#' rev_puerto$n_palabras <- acep_frec(rev_puerto$nota)
#' rev_puerto |> head()
#' @export
acep_frec <- function(x) {
  vapply(strsplit(x, " "), length, c(frec = 0))
  }
