#' @title Serie temporal de índices de conflictividad.
#' @description Función que devuelve los índices de conflictividad agrupados por segmento de tiempo: día, mes, año.
#' @param x vector de valores del eje x (por ejemplo, fechas).
#' @param y vector de valores numéricos del eje y (por ejemplo, menciones).
#' @param t titulo del gráfico.
#' @param ejex nombre del eje x.
#' @param ejey nombre del eje y.
#' @param etiquetax orientación de las etiquetas del eje x ('horizontal' | 'vertical').
#' @examples
#' datos <- acep_db(acep_bases$rev_puerto, acep_bases$rev_puerto$nota, acep_diccionarios$dicc_viol_gp, 4)
#' datos_procesados_anio <- acep_rst(datos, datos$fecha, datos$n_palabras, datos$conflictos, st = 'anio')
#' acep_plot_st(datos_procesados_anio$st, datos_procesados_anio$frecm,
#'              t = 'Evolución de la conflictividad en el sector pesquero argentino',
#'              ejex = 'Años analizados',
#'              ejey = 'Menciones de términos del diccionario de conflictos',
#'              etiquetax = 'horizontal')


acep_plot_st <- function(x, y, t = '', ejex = '', ejey = '', etiquetax = 'horizontal') {
  etiquetax = if(etiquetax == 'horizontal') {etiquetax = 0} else if(etiquetax == 'vertical') {etiquetax = 2}
  graphics::barplot (y ~ x,
                     main = t,
                     ylab = '',
                     xlab = '',
                     cex.names=1.0,
                     border = "skyblue",
                     col = "pink",
                     density = 70,
                     las = etiquetax)
  title(xlab = ejex, line=-0.1, cex.lab = 1.0)
  title(ylab = ejey, line=-1.0, cex.lab = 1.0)
}
