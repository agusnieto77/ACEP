#' @title Serie temporal de índices de conflictividad.
#' @description Función que devuelve los índices de conflictividad agrupados por segmento de tiempo: día, mes, año.
#' @param datos data frame con los textos a procesar.
#' @param fecha columna de data frame que contiene el vector de fechas en formato date.
#' @param frecp columna de data frame que contiene el vector de frecuencia de palabras por texto.
#' @param frecm columna de data frame que contiene el vector de menciones del diccionario por texto.
#' @param d cantidad de decimales, por defecto tiene 4 pero se puede modificar.
#' @examples
#' datos <- acep_db(acep_bases$rev_puerto, acep_bases$rev_puerto$nota, acep_diccionarios$dicc_viol_gp, 4)
#' datos_procesados_anio <- acep_rst(datos, datos$fecha, datos$n_palabras, datos$conflictos, st = 'anio', d = 5)
#' datos_procesados_mes <- acep_rst(datos, datos$fecha, datos$n_palabras, datos$conflictos)
#' datos_procesados_dia <- acep_rst(datos, datos$fecha, datos$n_palabras, datos$conflictos, st = 'dia', d = 3)

acep_rst <- function(datos, fecha, frecp, frecm, st = 'mes', d = 4) {
  datos = datos
  datos$anio <- format(fecha,"%Y")
  datos$mes <- paste0(datos$anio,'-',format(fecha,"%m"))
  datos$dia <- fecha
  st = if(st == 'anio') {st = datos$anio} else if(st == 'mes') {st = datos$mes} else if(st == 'dia') {st = datos$dia}
  frec_conflict <- aggregate(frecm ~ st, datos, function(x) c(frec_conflict = sum(x)))
  frec_palabras <- aggregate(frecp ~ st, datos, function(x) c(frec_palabras = sum(x)))
  frec_pal_con <- merge(frec_palabras, frec_conflict)
  frec_pal_con$int <- acep_int(frec_pal_con$frecm, frec_pal_con$frecp, decimales = d)
  return(frec_pal_con)
}
