#' @title Grafico de barras de palabras mas recurrentes en un corpus.
#' @description Funcion que devuelve un grafico de barras con las palabras
#' mas recurrentes en un corpus textual.
#' @param x vector de palabras tokenizadas.
#' @param u numero de corte para el top de palabras mas frecuentes.
#' @param frec parametro para determinar si los valores se visualizaran
#' como frecuencia absoluta o relativa.
#' @export acep_token_plot
#' @return Si todas las entradas son correctas,
#' la salida sera un grafico de barras.
#' @keywords visualizacion
#' @examples
#' tokens <- c(rep("paro",15), rep("piquete",25), rep("corte",20), rep("manifestacion",10),
#' rep("bloqueo",5), rep("alerta",16), rep("ciudad",12), rep("sindicato",11), rep("paritaria",14),
#' rep("huelga",14), rep("escrache",15))
#' acep_token_plot(tokens)
#' @export
acep_token_plot <- function(x, u = 10, frec = TRUE) {
  if(is.vector(x) != TRUE | is.list(x) == TRUE){
    mensaje <- "No ingresaste un vector en el parametro x. Vuelve a intentarlo ingresando un vector!"
    return(message(mensaje))
  } else {
    if(is.vector(x) == TRUE & is.list(x) != TRUE) {
      tryCatch({
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
        )
      }
    }
  }
