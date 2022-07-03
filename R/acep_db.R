#' @title Frecuencia, menciones e intensidad.
#' @description Función que usa las funciones acep_frec, acep_men y acep_int y devuelve una tabla con tres columnas nuevas: número de palabras, número de menciones del diccionario, índice de intensidad.
#' @param db data frame con los textos a procesar.
#' @param t columna de data frame que contiene el vector de textos a procesar.
#' @param d diccionario en formato vector.
#' @param n cantidad de decimales del índice de intensidad.
#' @keywords indicadores
#' @examples
#' rp_procesada <- acep_db(acep_bases$rev_puerto, acep_bases$rev_puerto$nota, acep_diccionarios$dicc_viol_gp, 4)
#' rp_procesada |> head()

acep_db <- function(db, t, d, n){
  db = db
  db$n_palabras <- acep_frec(t)
  db$conflictos <- acep_men(t, d)
  db$intensidad <- acep_int(db$conflictos, db$n_palabras, n)
  return(db)
}
