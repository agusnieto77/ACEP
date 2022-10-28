#' @title Resumen visual de la serie temporal de los índices de conflictividad.
#' @description Función que devuelve un panel visual de cuatro gráficos
#' de barras con variables proxy de los índices de conflictividad agrupados
#' por segmento de tiempo.
#' @param db data frame con datos procesados.
#' @param tagx orientación de las etiquetas del
#' eje x ('horizontal' | 'vertical').
#' @export acep_plot_rst
#' @importFrom graphics par
#' @return Si todas las entradas son correctas,
#' la salida será una imagen de cuatro paneles.
#' @keywords visualización
#' @examples
#' datos <- acep_bases$rp_procesada
#' fecha <- datos$fecha
#' n_palabras <- datos$n_palabras
#' conflictos <- datos$conflictos
#' datos_procesados_anio <- acep_rst(datos,
#' fecha, n_palabras, conflictos, st = 'anio')
#' acep_plot_rst(datos_procesados_anio, tagx = 'vertical')
#' @export
acep_plot_rst <- function(db, tagx = "horizontal") {
  oldpar <- par(no.readonly = TRUE)
  on.exit(par(oldpar))
  db <- db
  par(mfrow = c(2, 2))
  acep_plot_st(db$st, db$int_notas_confl,
               t = "Eventos de protesta",
               etiquetax = tagx)
  acep_plot_st(db$st, db$frecm,
               t = "Acciones de protesta",
               etiquetax = tagx)
  acep_plot_st(db$st, db$intensidad,
               t = "Intensidad de la protesta",
               etiquetax = tagx)
  acep_plot_st(db$st, db$intac,
               t = "Intensidad acumulada de la protesta",
               etiquetax = tagx)
  par(mfrow = c(1, 1))
}
