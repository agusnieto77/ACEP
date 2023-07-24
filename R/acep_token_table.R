#' @title Tabla de frecuencia de palabras tokenizadas.
#' @description Función que cuenta la frecuencia de palabras tokenizadas.
#' @param x vector de palabras tokenizadas.
#' @param u número de corte para el top de palabras más frecuentes.
#' @return Si todas las entradas son correctas,
#' la salida sera una tabla con la frecuencia relativa y
#' absoluta de palabras tokenizadas.
#' @keywords tokens tablas
#' @examples
#' tokens <- c(rep("paro",15), rep("piquete",25), rep("corte",20), rep("manifestación",10),
#' rep("bloqueo",5), rep("alerta",16), rep("ciudad",12), rep("sindicato",11), rep("paritaria",14),
#' rep("huelga",14), rep("escrache",15))
#' acep_token_table(tokens)
#' @export
acep_token_table <- function(x, u = 10) {
  if(!is.character(x) | is.list(x)){
    return(message("No ingresaste un vector en el par\u00e1metro x.
            Vuelve a intentarlo ingresando un vector!"))
  }
  if (!is.numeric(u)) {
    return(message("El par\u00e1metro 'u' debe ser un n\u00famero entero positivo"))
  } else {
      tryCatch({
  tabla_token <- as.data.frame(base::table(x))
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
