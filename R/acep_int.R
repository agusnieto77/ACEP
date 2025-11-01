#' @title Índice de intensidad.
#' @description Función que elabora un indice de intensidad en
#' base a la relación entre palabras totales y palabras del diccionario
#' presentes en el texto.
#' @param pc vector numérico con la frecuencia de palabras conflictivas
#' presentes en cada texto.
#' @param pt vector de palabras totales en cada texto.
#' @param decimales cantidad de decimales, por defecto tiene 4
#' pero se puede modificar.
#' @return Si todas las entradas son correctas,
#' la salida sera un vector numérico.
#' @keywords indicadores frecuencia tokens
#' @examples
#' conflictos <- c(1, 5, 0, 3, 7)
#' palabras <- c(4, 11, 12, 9, 34)
#' acep_int(conflictos, palabras, 3)
#' @export
acep_int <- function(pc, pt, decimales = 4) {
  validate_numeric(pc, "pc", min = 0)
  validate_numeric(pt, "pt", min = 0)
  validate_numeric(decimales, "decimales", min = 0)

  tryCatch({
    round(pc / pt, decimales)
  })
}

