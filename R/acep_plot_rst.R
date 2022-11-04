#' @title Resumen visual de la serie temporal de los indices de conflictividad.
#' @description Funcion que devuelve un panel visual de cuatro graficos
#' de barras con variables proxy de los indices de conflictividad agrupados
#' por segmento de tiempo.
#' @param db data frame con datos procesados.
#' @param tagx orientacion de las etiquetas del
#' eje x ('horizontal' | 'vertical').
#' @export acep_plot_rst
#' @importFrom graphics par
#' @return Si todas las entradas son correctas,
#' la salida sera una imagen de cuatro paneles.
#' @keywords visualizacion
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
    if(is.data.frame(db) != TRUE){
      mensaje <- "No ingresaste un marco de datos en el parametro db. Vuelve a intentarlo ingresando un marco de datos!"
      return(message(mensaje))
  }
  if((paste(names(db),collapse = '') != "stfrecncsnfrecpfrecmintacintensidadint_notas_confl")){
    mensaje <- "No ingresaste un marco de datos adecuado en el parametro db. Vuelve a intentarlo ingresando un marco de datos adecuado!"
    return(message(mensaje))
  } else {
    if((paste(names(db),collapse = '') == "stfrecncsnfrecpfrecmintacintensidadint_notas_confl") && is.data.frame(db) == TRUE) {
      tryCatch({
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
    )
  }
}
}
