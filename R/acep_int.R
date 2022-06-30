#' @title Índice de intensidad.
#' @description Función que elabora un indice de intensidad en base a la relación entre palabras totales y palabras del diccionario presentes en el texto.
#' @param pc vector numérico con la frecuencia de palabras conflictivas presentes en cada texto.
#' @param pt vector de palabras totales en cada texto.
#' @param decimales cantidad de decimales, por defecto tiene 4 pero se puede modificar.
#' @examples
#' acep_bases$rev_puerto$intensidad <- acep_int(acep_bases$rev_puerto$conflictos, acep_bases$rev_puerto$n_palabras, 3)

acep_int <- function(pc, pt, decimales = 4){round(pc/pt, decimales)}
