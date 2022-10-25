#' @title Tokenizador.
#' @description Función que tokeniza las notas/textos.
#' @param x vector de textos al que se le aplica la función de tokenización.
#' @param tolower convierte los textos a minúsculas.
#' @keywords tokenizar
#' @examples
#' rev_puerto <- acep_bases$rev_puerto
#' rev_puerto_token <- acep_token(rev_puerto$nota)
#' rev_puerto_token |> head()
#' @export

acep_token <- function(x, tolower = TRUE) {
  if(tolower == TRUE){
    id = data.frame(id_doc = 1:length(x), texto = x)
    id_token = 1:length(unlist(strsplit(tolower(x), " ")))
    token <- unlist(strsplit(tolower(x), " "))
    texto <- rep(x,sapply(strsplit(x, ' '), length))
  } else {
    id = data.frame(id_doc = 1:length(x), texto = x)
    id_token = 1:length(unlist(strsplit(x, " ")))
    token <- unlist(strsplit(x, " "))
    texto <- rep(x,sapply(strsplit(x, ' '), length))
  }
  df <- merge(data.frame(texto = texto, id_token = id_token,token = token),id)
  df <- df[order(df$id_token, decreasing = FALSE),]
  df$id_token_doc <- as.vector(unlist(aggregate(df$token ~ df$id_doc, FUN=function(x) 1:length(x))[,2]))
  df <- data.frame(id_doc = df$id_doc, texto = df$texto, id_token = df$id_token, id_token_doc = df$id_token_doc, token = df$token)
  return(df)
}
