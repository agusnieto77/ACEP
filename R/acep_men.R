#' @title Frecuencia de menciones de palabras.
#' @description Función que cuenta la frecuencia de menciones de
#' palabras que refieren a conflictos en cada una de las notas/textos.
#' @param x vector de textos al que se le aplica la función de conteo
#' de la frecuencia de menciones de palabras del diccionario.
#' @param y vector de palabras del diccionario utilizado.
#' @param tolower convierte los textos a minúsculas.
#' @return Si todas las entradas son correctas,
#' la salida sera un vector con una frecuencia
#' de palabras de un diccionario.
#' @keywords indicadores frecuencia tokens
#' @examples
#' df <- data.frame(texto = c("El SUTEBA fue al paro.
#' Reclaman mejoras salariales.",
#' "El SOIP lleva adelante un plan de lucha con paros y piquetes."))
#' diccionario <- c("paro", "lucha", "piquetes")
#' df$detect <- acep_men(df$texto, diccionario)
#' df
#' @export
acep_men <- function(x, y, tolower = TRUE) {
  if (!is.character(x)) {
    message("No ingresaste un vector en el par\u00e1metro x.
    Vuelve a intentarlo ingresando un vector!")
  } else if (!is.character(y)) {
    message("No ingresaste un vector en el par\u00e1metro y.
    Vuelve a intentarlo ingresando un vector!")
  } else {
    dicc <- paste0(gsub("^ | $", "\\\\b", y), collapse = "|")
    detect <- sapply(x, function(text) {
      if (tolower) {
        sum(gregexpr(dicc, tolower(text), perl = TRUE)[[1]] != -1)
      } else {
        sum(gregexpr(dicc, text, perl = TRUE)[[1]] != -1)
      }
    })
    return(as.numeric(detect))
  }
}
