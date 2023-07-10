#' @title Grafico de barras de la serie temporal de indices de conflictividad.
#' @description Funcion que devuelve un grafico de barras con la serie
#' temporal de indices de conflictividad por dia, mes o anio.
#' @param x vector de valores del eje x (por ejemplo, fechas).
#' @param y vector de valores numericos del eje y (por ejemplo, menciones).
#' @param t titulo del grafico.
#' @param ejex nombre del eje x.
#' @param ejey nombre del eje y.
#' @param etiquetax orientacion de las etiquetas del
#' eje x ('horizontal' | 'vertical').
#' @param color color de las barras.
#' @export acep_plot_st
#' @importFrom graphics title barplot
#' @keywords visualizacion
#' @return Si todas las entradas son correctas,
#' la salida sera una imagen de un panel.
#' @examples
#' datos <- acep_bases$rp_procesada
#' fecha <- datos$fecha
#' n_palabras <- datos$n_palabras
#' conflictos <- datos$conflictos
#' dpa <- acep_rst(datos,
#' fecha, n_palabras, conflictos, st = 'anio')
#' acep_plot_st(
#' dpa$st, dpa$frecm,
#' t = 'Evolucion de la conflictividad en el sector pesquero argentino',
#' ejex = 'Anios analizados',
#' ejey = 'Menciones de terminos del diccionario de conflictos',
#' etiquetax = 'horizontal')
#' @export
acep_plot_st <- function(x, y, t = "", ejex = "",
                         ejey = "", etiquetax = "horizontal", color = "mint") {
  c <- y
  c <- if (max(c)-min(c) < 10) {
    c <- c*10000
  } else {
    c
  }
  etiquetax  <- if (etiquetax == "horizontal") {
    etiquetax <- 0
  } else if (etiquetax == "vertical") {
    etiquetax <- 2
  }
    if(is.vector(x) != TRUE | is.list(x) == TRUE){
      mensaje <- "No ingresaste un vector en el parametro x. Vuelve a intentarlo ingresando un vector!"
      return(message(mensaje))
    }
    if(is.numeric(y) != TRUE){
      mensaje <- "No ingresaste un vector numerico en el parametro y. Vuelve a intentarlo ingresando un vector numerico!"
      return(message(mensaje))
    } else {
      if(is.vector(x) == TRUE & is.list(x) != TRUE) {
        tryCatch({
  graphics::barplot(y ~ x,
                   main = t,
                   ylab = "",
                   xlab = "",
                   cex.names = 1.0,
                   border = "grey",
                   col = grDevices::hcl.colors(max(c), alpha = 0.5, color, rev = TRUE)[c],
                   las = etiquetax)
  graphics::title(xlab = ejex, line = -0.1, cex.lab = 1.0)
  graphics::title(ylab = ejey, line = -1.0, cex.lab = 1.0)
        }
        )
      }
    }
}
