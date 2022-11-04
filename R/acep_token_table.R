#' @title Tabla de frecuencia de palabras tokenizadas.
#' @description Funcion que cuenta la frecuencia de palabras tokenizadas.
#' @param x vector de palabras tokenizadas.
#' @param u numero de corte para el top de palabras mas frecuentes.
#' @export acep_token_table
#' @return Si todas las entradas son correctas,
#' la salida sera una tabla con la frecuencia relativa y
#' absoluta de palabras tokenizadas.
#' @keywords tablas
#' @examples
#' tokens <- c(rep("paro",15), rep("piquete",25), rep("corte",20), rep("manifestacion",10),
#' rep("bloqueo",5), rep("alerta",16), rep("ciudad",12), rep("sindicato",11), rep("paritaria",14),
#' rep("huelga",14), rep("escrache",15))
#' acep_token_table(tokens)
#' @export
acep_token_table <- function(x, u = 10) {
  if(is.vector(x) != TRUE){
    message("No ingresaste un vector en el parametro x. Vuelve a intentarlo ingresando un vector!")
  } else {
    if(is.vector(x) == TRUE) {
      tryCatch({
  tabla_token <- base::table(x) |> as.data.frame()
  tabla_token <- tabla_token[order(tabla_token$Freq, decreasing = TRUE), ]
  tabla_token <- utils::head(tabla_token, n = u)
  tabla_token$prop <- tabla_token$Freq / sum(tabla_token$Freq)
  tabla_token <- data.frame(
    token = tabla_token$x,
    frec = tabla_token$Freq,
    prop = tabla_token$prop)
  utils::head(tabla_token, n = u)
      }
      )
    }
  }
}
