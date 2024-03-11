#' @title Frecuencia de menciones de palabras.
#' @description Reemplaza a la función 'acep_men' que cuenta la frecuencia de
#' menciones de palabras que refieren a conflictos en cada una de las notas/textos.
#' @param texto vector de textos al que se le aplica la función de conteo
#' de la frecuencia de menciones de palabras del diccionario.
#' @param dic vector de palabras del diccionario utilizado.
#' @return Si todas las entradas son correctas,
#' la salida sera un vector con una frecuencia
#' de palabras de un diccionario.
#' @keywords indicadores frecuencia tokens
#' @importFrom stringr str_count
#' @examples
#' df <- data.frame(texto = c("El SUTEBA fue al paro. Reclaman mejoras salariales.",
#' "El SOIP lleva adelante un plan de lucha con paros y piquetes."))
#' diccionario <- c("paro", "lucha", "piquetes")
#' df$detect <- acep_men(df$texto, diccionario)
#' df
#' @export
acep_count <- function(texto, dic) {
  if (!is.character(texto)) {
    return(message("No ingresaste un vector de texto en el par\u00e1metro 'texto'"))
  }
  if (!is.character(dic)) {
    return(message("No ingresaste un vector de texto en el par\u00e1metro 'dic'"))
  } else {
    dicc <- paste0(gsub("^ | $", "\\\\b", dic), collapse = "|")
    detect <- stringr::str_count(texto, dicc)
    return(detect)
  }
}
