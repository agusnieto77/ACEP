#' @title Funcion para buscar y extraer palabras en un texto
#' @description Esta funcion busca palabras clave en un texto y
#' extrae los resultados en un formato especifico.
#' @param texto El texto en el que se buscarán las palabras clave.
#' @param dicc Un vector con las palabras clave a buscar.
#' @keywords buscar palabras texto diccionario
#' @param sep El separador utilizado para concatenar las
#' palabras clave encontradas (por defecto: " | ").
#' @examples
#' texto <- "Los obreros del pescado están en huelga y
#' realizaron un piquete en el puerto"
#' dicc <- c("huel", "manif")
#' acep_extract(texto, dicc)
#' @export
acep_extract <- function(texto, dicc, sep = " | ") {
  patron <- paste0(dicc, "\\w*\\b")
  p_extract <- unlist(
    regmatches(texto,
               gregexpr(
                 paste(patron, collapse = "|"),
                 texto, ignore.case = TRUE)))
  p_extract <- gsub("[[:punct:]]", "", p_extract)
  resultados <- paste(p_extract, collapse = sep)
  return(resultados)
}
