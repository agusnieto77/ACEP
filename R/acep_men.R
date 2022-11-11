#' @title Frecuencia de menciones de palabras.
#' @description Funcion que cuenta la frecuencia de menciones de
#' palabras que refieren a conflictos en cada una de las notas/textos.
#' @param x vector de textos al que se le aplica la funcion de conteo
#' de la frecuencia de menciones de palabras del diccionario.
#' @param y vector de palabras del diccionario utilizado.
#' @param tolower convierte los textos a minusculas.
#' @export acep_men
#' @return Si todas las entradas son correctas,
#' la salida sera un vector con una frecuencia
#' de palabras de un diccionario.
#' @keywords indicadores
#' @examples
#' df <- data.frame(texto = c("El SUTEBA fue al paro. Reclaman mejoras salariales.",
#' "El SOIP lleva adelante un plan de lucha con paros y piquetes."))
#' diccionario <- c("paro", "lucha", "piquetes")
#' df$detect <- acep_men(df$texto, diccionario)
#' df
#' @export
acep_men <- function(x, y, tolower = TRUE) {
  if(is.vector(x) != TRUE | is.list(x) == TRUE){
    mensaje <- "No ingresaste un vector en el parametro x. Vuelve a intentarlo ingresando un vector!"
    return(message(mensaje))
  }
  if(is.vector(y) != TRUE | is.list(x) == TRUE){
    mensaje <- "No ingresaste un vector en el parametro y. Vuelve a intentarlo ingresando un vector!"
    return(message(mensaje))
  } else {
    if(is.vector(x) == TRUE & is.list(x) != TRUE) {
      out <- tryCatch({
        dicc <- paste0(y, collapse = "|")
        if (tolower == TRUE) {
          vapply(gregexpr(dicc, tolower(x), perl = TRUE),
                 function(z) sum(z != -1), c(frec = 0))
        } else {
          vapply(gregexpr(dicc, x, perl = TRUE),
                 function(z) sum(z != -1), c(frec = 0))
        }
      }
      )
    }
    return(out)
  }
}
