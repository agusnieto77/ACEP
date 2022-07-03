#' @title Serie temporal de índices de conflictividad.
#' @description Función que devuelve los índices de conflictividad agrupados por segmento de tiempo: día, mes, año.
#' @param datos data frame con los textos a procesar.
#' @param fecha columna de data frame que contiene el vector de fechas en formato date.
#' @param frecp columna de data frame que contiene el vector de frecuencia de palabras por texto.
#' @param frecm columna de data frame que contiene el vector de menciones del diccionario por texto.
#' @param st parámetro para establecer el segmento temporal a ser agrupado: anio, mes, dia.
#' @param u umbral de menciones para contabilizar una nota como nota que refiere a un conflicto.
#' @param d cantidad de decimales, por defecto tiene 4 pero se puede modificar.
#' @examples
#' datos <- acep_db(acep_bases$rev_puerto, acep_bases$rev_puerto$nota, acep_diccionarios$dicc_viol_gp, 4)
#' datos_procesados_anio <- acep_rst(datos, datos$fecha, datos$n_palabras, datos$conflictos, st = 'anio', u = 4)
#' datos_procesados_mes <- acep_rst(datos, datos$fecha, datos$n_palabras, datos$conflictos)
#' datos_procesados_dia <- acep_rst(datos, datos$fecha, datos$n_palabras, datos$conflictos, st = 'dia', d = 3)

acep_rst <- function(datos, fecha, frecp, frecm, st = 'mes', u = 2, d = 4) {
  datos = datos
  datos$anio <- format(fecha,"%Y")
  datos$mes <- paste0(datos$anio,'-',format(fecha,"%m"))
  datos$dia <- fecha
  datos$csn <- ifelse(datos$conflictos > u, 1, 0)
  st = if(st == 'anio') {st = datos$anio} else if(st == 'mes') {st = datos$mes} else if(st == 'dia') {st = datos$dia}
  frec_notas <- aggregate(st, by = list(st), FUN = length)
  colnames(frec_notas) <- c('st','frecn')
  frec_notas_conf <- aggregate(csn ~ st, datos, function(x) c(frec_notas_conf = sum(x)))
  frec_palabras <- aggregate(frecp ~ st, datos, function(x) c(frec_palabras = sum(x)))
  frec_conflict <- aggregate(frecm ~ st, datos, function(x) c(frec_conflict = sum(x)))
  frec_int_acum <- aggregate(intensidad ~ st, datos, function(x) c(frec_int_acum = sum(x)))
  colnames(frec_int_acum) <- c('st','intac')
  frec_pal_con <- merge(frec_notas, merge(frec_notas_conf, merge(frec_palabras, merge(frec_conflict,frec_int_acum))))
  frec_pal_con$intensidad <- acep_int(frec_pal_con$frecm, frec_pal_con$frecp, decimales = d)
  frec_pal_con$int_notas_confl <- acep_int(frec_pal_con$csn, frec_pal_con$frecn, decimales = d)
  return(frec_pal_con)
}
