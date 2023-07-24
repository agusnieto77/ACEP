#' @title Gráfico de barras de palabras mas recurrentes en un corpus.
#' @description Función que devuelve un gráfico de barras con las palabras
#' mas recurrentes en un corpus textual.
#' @param x vector de palabras tokenizadas.
#' @param u numero de corte para el top de palabras mas frecuentes.
#' @param frec parámetro para determinar si los valores se visualizaran
#' como frecuencia absoluta o relativa.
#' @return Si todas las entradas son correctas,
#' la salida sera un gráfico de barras.
#' @keywords visualizacion
#' @examples
#' tokens <- c(rep("paro",15), rep("piquete",25), rep("corte",20), rep("manifestación",10),
#' rep("bloqueo",5), rep("alerta",16), rep("ciudad",12), rep("sindicato",11), rep("paritaria",14),
#' rep("huelga",14), rep("escrache",15))
#' acep_token_plot(tokens)
#' @export
acep_token_plot <- function(x, u = 10, frec = TRUE) {
  par(mar=c(6,9,4,1))
  if(!is.character(x) | is.list(x)){
    return(message("No ingresaste un vector en el par\u00e1metro x.
           Vuelve a intentarlo ingresando un vector!"))
  }
  if (!is.logical(frec)) {
    return(message("Debe ingresar un valor booleano: TRUE o FALSE"))
  }
  if (!is.numeric(u)) {
    message("El par\u00e1metro 'u' debe ser un n\u00famero entero positivo")
    } else {
      tryCatch({
        if (frec) {
          tabla_token <- as.data.frame(base::table(x))
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
    tabla_token <- as.data.frame(base::table(x))
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
      })
  }
  }
