#' @title Detección de menciones de palabras.
#' @description Función que detecta de menciones de palabras que
#' refieren a conflictos en cada una de las notas/textos.
#' @param x vector de textos al que se le aplica la función de
#' detección de menciones de palabras del diccionario.
#' @param y vector de palabras del diccionario utilizado.
#' @param u umbral para atribuir valor positivo a la
#' detección de las menciones.
#' @param tolower convierte los textos a minúsculas.
#' @return Si todas las entradas son correctas,
#' la salida sera un vector numérico.
#' @importFrom stringr str_count
#' @keywords indicadores frecuencia tokens
#' @examples
#' df <- data.frame(texto = c("El SUTEBA fue al paro. Reclaman mejoras salariales.",
#' "El SOIP lleva adelante un plan de lucha con paros y piquetes."))
#' diccionario <- c("paro", "lucha", "piquetes")
#' df$detect <- acep_detect(df$texto, diccionario)
#' df
#' @export
acep_detect <- function(x, y, u = 1, tolower = TRUE) {
  validate_character(x, "x")
  validate_character(y, "y")
  validate_numeric(u, "u", min = 0)
  validate_logical(tolower, "tolower")

  if (tolower) {
    x <- tolower(x)
  }

  out <- tryCatch({
    dicc <- paste0(gsub("^ | $", "\\b", y), collapse = "|")
    detect <- stringr::str_count(x, dicc)
    ifelse(as.numeric(detect) >= u, 1, 0)
  })

  return(out)
}

