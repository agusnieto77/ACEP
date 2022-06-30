#' @title Indice de intensidad.
#' @description Funcion que elabora un indice de intensidad en base a la relacion entre palabras totales y palabras del diccionario presentes en el texto.
#' @param pc vector numerico con la frecuencia de palabras conflictivas presentes en cada texto.
#' @param pt vector de palabras totales en cada texto.
#' @param decimales cantidad de decimales, por defecto tiene 4 pero se puede modificar.
#' @examples
#' rev_puerto$intensidad <- acep_int(rev_puerto$conflictos, rev_puerto$n_palabras, 2)

acep_int <- function(pc, pt, decimales = 4){round(pc/pt, decimales)}
