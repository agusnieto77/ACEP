#' @title Gráfico de barras de palabras más recurrentes en un corpus.
#' @description Función que devuelve un gráfico de barras con las palabras
#' más recurrentes en un corpus textual.
#' @param x vector de palabras tokenizadas.
#' @param u numero de corte para el top de palabras más frecuentes.
#' @param frec parámetro para determinar si los valores se visualizarán
#' como frecuencia absoluta o relativa.
#' @export acep_token_plot
#' @return Si todas las entradas son correctas,
#' la salida será un gráfico de barras.
#' @keywords visualización
#' @examples
#' rev_puerto <- acep_clean(acep_bases$rev_puerto$titulo)
#' rev_puerto_token <- acep_token(rev_puerto)
#' acep_token_plot(rev_puerto_token$token)
#' @export
acep_token_plot <- function(x, u = 10, frec = TRUE) {
  if (frec == TRUE) {
    tabla_token <- base::table(x) |> as.data.frame()
    tabla_token$x <- as.character(tabla_token$x)
    tabla_token <- tabla_token[order(tabla_token$Freq, decreasing = TRUE), ]
    tabla_token <- utils::head(tabla_token, n = u)
    tabla_token$prop <- tabla_token$Freq / sum(tabla_token$Freq)
    tabla_token <- data.frame(
      token = tabla_token$x,
      frec = tabla_token$Freq,
      prop = tabla_token$prop)
    tabla_token <- utils::head(tabla_token, n = u)
    tabla_token <- tabla_token[order(tabla_token$frec,
                                     decreasing = FALSE), ]
    graphics::barplot(
      height = tabla_token$frec,
      names = as.factor(tabla_token$token),
      col = grDevices::hcl.colors(u, "mint", rev = TRUE),
      xlab = "frecuencia",
      ylab = NULL,
      main = paste("Top", u, "de palabras frecuentes"),
      xlim = c(0, (max(tabla_token$frec) * 1.1)),
      horiz = TRUE,
      las = 1,
      cex.names = 0.8,
      cex.axis = 0.8
    )
  } else {
    tabla_token <- base::table(x) |> as.data.frame()
    tabla_token$x <- as.character(tabla_token$x)
    tabla_token <- tabla_token[order(tabla_token$Freq, decreasing = TRUE), ]
    tabla_token <- utils::head(tabla_token, n = u)
    tabla_token$prop <- tabla_token$Freq / sum(tabla_token$Freq)
    tabla_token <- data.frame(token = tabla_token$x,
                              frec = tabla_token$Freq,
                              prop = tabla_token$prop)
    tabla_token <- utils::head(tabla_token, n = u)
    tabla_token <- tabla_token[order(tabla_token$frec, decreasing = FALSE), ]
    graphics::barplot(
      height = tabla_token$prop,
      names = as.factor(tabla_token$token),
      col = grDevices::hcl.colors(u, "purp", rev = TRUE),
      xlab = "porcentaje",
      ylab = NULL,
      main = paste("Top", u, "de palabras frecuentes"),
      xlim = c(0, (max(tabla_token$prop) * 1.15)),
      horiz = TRUE,
      las = 1,
      cex.names = 0.8,
      cex.axis = 0.8
    )
  }

}
