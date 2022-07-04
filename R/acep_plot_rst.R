#' @title Resumen visual de la serie temporal de los índices de conflictividad.
#' @description Función que devuelve un panel visual de cuatro gráficos de barras con variables proxy de los índices de conflictividad agrupados por segmento de tiempo.
#' @param db data frame con datos procesados.
#' @param tagx orientación de las etiquetas del eje x ('horizontal' | 'vertical').
#' @export acep_plot_rst
#' @importFrom graphics par
#' @keywords visualización
#' @examples
#' rev_puerto <- acep_bases$rev_puerto
#' dicc_violencia <- acep_diccionarios$dicc_viol_gp
#' datos <- acep_db(rev_puerto, rev_puerto$nota, dicc_violencia, 4)
#' datos_procesados_anio <- acep_rst(datos, datos$fecha, datos$n_palabras, datos$conflictos, st = 'anio')
#' acep_plot_rst(datos_procesados_anio, tagx = 'vertical')


acep_plot_rst <- function(db, tagx = 'horizontal') {
  db = db
  graphics::par(mfrow = c(2, 2))
  acep_plot_st(db$st, db$int_notas_confl, t = 'Eventos de protesta', etiquetax = tagx)
  acep_plot_st(db$st, db$frecm, t = 'Acciones de protesta', etiquetax = tagx)
  acep_plot_st(db$st, db$intensidad, t = 'Intensidad de la protesta', etiquetax = tagx)
  acep_plot_st(db$st, db$intac, t = 'Intensidad acumulada de la protesta', etiquetax = tagx)
  par(mfrow = c(1, 1))
}

