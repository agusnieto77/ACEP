#' @title Resumen visual de la serie temporal de los indices de conflictividad.
#' @description Función que devuelve un panel visual de cuatro gráficos
#' de barras con variables proxy de los indices de conflictividad agrupados
#' por segmento de tiempo.
#' @param datos data frame con datos procesados.
#' @param tagx orientación de las etiquetas del
#' eje x ('horizontal' | 'vertical').
#' @export acep_plot_rst
#' @importFrom graphics par
#' @return Si todas las entradas son correctas,
#' la salida sera una imagen de cuatro paneles.
#' @keywords visualización
#' @examples
#' datos <- acep_bases$rp_procesada
#' datos_procesados_anio <- acep_sst(datos, st = 'anio')
#' acep_plot_rst(datos_procesados_anio, tagx = 'vertical')
#' @export
acep_plot_rst <- function(datos, tagx = "horizontal") {
  if (paste(names(datos), collapse = "") != "stfrecncsnfrecpfrecmintacintensidadint_notas_confl") {
    return(message("Debe ingresar un dataframe construido con la funcion 'acep_rst'."))
  } else {
    tryCatch({
      oldpar <- par(no.readonly = TRUE)
      on.exit(par(oldpar))
      datos <- datos
      par(mfrow = c(2, 2))
      acep_plot_st(datos$st, datos$int_notas_confl,
                   t = "Eventos de protesta",
                   etiquetax = tagx,
                   color = "plasma")
      acep_plot_st(datos$st, datos$frecm,
                   t = "Acciones de protesta",
                   etiquetax = tagx,
                   color = "mako")
      acep_plot_st(datos$st, datos$intensidad,
                   t = "Intensidad de la protesta",
                   etiquetax = tagx,
                   color = "inferno")
      acep_plot_st(datos$st, datos$intac,
                   t = "Intensidad acumulada de la protesta",
                   etiquetax = tagx,
                   color = "viridis")
      par(mfrow = c(1, 1))
    })
  }
}
