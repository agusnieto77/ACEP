#' @title Tokenizador.
#' @description Funcion que tokeniza las notas/textos.
#' @param x vector de textos al que se le aplica la funcion de tokenizacion.
#' @param tolower convierte los textos a minusculas.
#' @keywords tokenizar
#' @examples
#' acep_token("Huelga de obreros del pescado en el puerto")
#' @export

acep_token <- function(x, tolower = TRUE) {
  if(is.vector(x) != TRUE){
    mensaje <- "No ingresaste un vector en el parametro x. Vuelve a intentarlo ingresando un vector!"
    return(message(mensaje))
  } else {
    if(is.vector(x) == TRUE) {
      tryCatch({
  if (tolower == TRUE) {
    id <- data.frame(id_doc = seq_len(length(x)), texto = x)
    id_token <- seq_len(length(unlist(strsplit(tolower(x), " "))))
    token <- unlist(strsplit(tolower(x), " "))
    texto <- rep(x, vapply(strsplit(x, " "), length, c(frec = 0)))
  } else {
    id  <- data.frame(id_doc = seq_len(length(x)), texto = x)
    id_token  <- seq_len(length(unlist(strsplit(x, " "))))
    token <- unlist(strsplit(x, " "))
    texto <- rep(x, vapply(strsplit(x, " "), length, c(frec = 0)))
  }
  df <- merge(data.frame(texto = texto,
                         id_token = id_token, token = token), id)
  df <- df[order(df$id_token, decreasing = FALSE), ]
  df$id_token_doc <- as.vector(unlist(aggregate(
    df$token ~ df$id_doc,
    FUN = function(x) seq_len(length(x)))[, 2]))
  df <- data.frame(
    id_doc = df$id_doc,
    texto = df$texto,
    id_token = df$id_token,
    id_token_doc = df$id_token_doc,
    token = df$token)
  return(df)
      }
      )
    }
  }
}

