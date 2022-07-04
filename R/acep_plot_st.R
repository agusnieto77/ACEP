#' @title Gráfico de barras de la serie temporal de índices de conflictividad.
#' @description Función que devuelve un gráfico de barras con la serie temporal de índices de conflictividad por día, mes o año.
#' @param x vector de valores del eje x (por ejemplo, fechas).
#' @param y vector de valores numéricos del eje y (por ejemplo, menciones).
#' @param t titulo del gráfico.
#' @param ejex nombre del eje x.
#' @param ejey nombre del eje y.
#' @param etiquetax orientación de las etiquetas del eje x ('horizontal' | 'vertical').
#' @export acep_plot_st
#' @importFrom graphics title barplot
#' @keywords visualización
#' @examples
#' rev_puerto <- acep_bases$rev_puerto
#' dicc_violencia <- acep_diccionarios$dicc_viol_gp
#' datos <- acep_db(rev_puerto, rev_puerto$nota, dicc_violencia, 4)
#' fecha <- datos$fecha
#' n_palabras <- datos$n_palabras
#' conflictos <- datos$conflictos
#' dpa <- acep_rst(datos, fecha, n_palabras, conflictos, st = 'anio')
#' acep_plot_st(dpa$st, dpa$frecm,
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
  graphics::title(xlab = ejex, line=-0.1, cex.lab = 1.0)
  graphics::title(ylab = ejey, line=-1.0, cex.lab = 1.0)
}
