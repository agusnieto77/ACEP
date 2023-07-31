#' @title Frecuencia de palabras totales.
#' @description Función que cuenta la frecuencia de palabras totales
#' en cada una de las notas/textos.
#' @param x vector de textos al que se le aplica la función de conteo
#' de la frecuencia de palabras.
#' @importFrom stringr str_count
#' @keywords indicadores frecuencia tokens
#' @return Si todas las entradas son correctas, la salida sera un vector
#' con una frecuencia de palabras.
#' @examples
#' acep_frec("El SUTEBA fue al paro. Reclaman mejoras salariales.")
#' @export
acep_frec <- function(x) {
  if(!is.character(x) || is.list(x)){
    return(message("No ingresaste un vector de texto.
           Vuelve a intentarlo ingresando un vector de texto!"))
  } else {
    out <- tryCatch({ str_count(x, "\\S+") })
    return(out)
  }
}
