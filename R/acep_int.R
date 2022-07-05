#' @title Índice de intensidad.
#' @description Función que elabora un indice de intensidad en base a la relación entre palabras totales y palabras del diccionario presentes en el texto.
#' @param pc vector numérico con la frecuencia de palabras conflictivas presentes en cada texto.
#' @param pt vector de palabras totales en cada texto.
#' @param decimales cantidad de decimales, por defecto tiene 4 pero se puede modificar.
#' @export acep_int
#' @keywords indicadores
#' @examples
#' rev_puerto <- acep_bases$rev_puerto
#' dicc_violencia <- acep_diccionarios$dicc_viol_gp
#' rev_puerto$n_palabras <- acep_frec(rev_puerto$nota)
#' rev_puerto$conflictos <- acep_men(rev_puerto$nota, dicc_violencia)
#' rev_puerto$intensidad <- acep_int(rev_puerto$conflictos, rev_puerto$n_palabras, 3)
#' rev_puerto |> head()

acep_int <- function(pc, pt, decimales = 4){round(pc/pt, decimales)}
