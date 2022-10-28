#' @title Tabla de frecuencia de palabras tokenizadas.
#' @description Función que cuenta la frecuencia de palabras tokenizadas.
#' @param x vector de palabras tokenizadas.
#' @param u numero de corte para el top de palabras más frecuentes.
#' @export acep_token_table
#' @return Si todas las entradas son correctas,
#' la salida será una tabla con la frecuencia relativa y
#' absoluta de palabras tokenizadas.
#' @keywords tablas
#' @examples
#' rev_puerto <- acep_clean(acep_bases$rev_puerto$titulo)
#' rev_puerto_token <- acep_token(rev_puerto)
#' acep_token_table(rev_puerto_token$token)
#' @export
acep_token_table <- function(x, u = 10) {
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
