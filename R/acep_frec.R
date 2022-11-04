#' @title Frecuencia de palabras totales.
#' @description Funcion que cuenta la frecuencia de palabras totales
#' en cada una de las notas/textos.
#' @param x vector de textos al que se le aplica la funcion de conteo
#' de la frecuencia de palabras.
#' @keywords indicadores
#' @export acep_frec
#' @return Si todas las entradas son correctas, la salida sera un vector
#' con una frecuencia de palabras.
#' @examples
#' acep_frec("El SUTEBA fue al paro. Reclaman mejoras salariales.")
#' @export
acep_frec <- function(x) {
  if(is.vector(x) == TRUE){
    out <- tryCatch({
      vapply(strsplit(x, " "), length, c(frec = 0))
    }
    )
    return(out)
  } else {
    message("No ingresaste un vector. Vuelve a intentarlo ingresando un vector!")
  }
}
