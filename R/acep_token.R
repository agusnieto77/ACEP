#' @title Tokenizador.
#' @description Función que tokeniza las notas/textos.
#' @param x vector de textos al que se le aplica la función de tokenización.
#' @param tolower convierte los textos a minúsculas.
#' @param cleaning hace una limpieza de los textos.
#' @return Si todas las entradas son correctas,
#' la salida será un data.frame con las palabras tokenizadas.
#' @keywords tokenizar
#' @examples
#' acep_token("Huelga de obreros del pescado en el puerto")
#' @export

acep_token <- function(x, tolower = TRUE, cleaning = TRUE) {
  if (!is.logical(tolower) | !is.logical(cleaning)) {
    return(message("Debe ingresar un valor booleano: TRUE o FALSE"))
  }
  if (!is.character(x) | is.list(x)){
    return(message("No ingresaste un vector en el par\u00e1metro x.
                   Vuelve a intentarlo ingresando un vector!"))
  }
  if (tolower) {
    x <- ACEP::acep_min(x)
  }
  if (cleaning) {
    x <- acep_clean(x)
  }
  texto_id <- seq_along(x)
  tokens <- lapply(x, function(texto) {
    tokens <- unlist(strsplit(texto, "\\W+"))
    tokens <- tokens[tokens != ""]
    return(tokens)
  })

  df <- data.frame(texto_id = rep(texto_id, sapply(tokens, length)), tokens = unlist(tokens))
  return(df)
}
