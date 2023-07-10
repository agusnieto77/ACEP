#' @title Funcion para buscar y extraer palabras en un texto
#' @description Esta funcion busca palabras clave en un texto y
#' extrae los resultados en un formato especifico.
#' @param texto El texto en el que se buscarán las palabras clave.
#' @param dicc Un vector con las palabras clave a buscar.
#' @keywords buscar palabras texto diccionario
#' @param sep El separador utilizado para concatenar las
#' palabras clave encontradas (por defecto: " | ").
#' @param tolower convierte los textos a minusculas.
#' @examples
#' texto <- "Los obreros del pescado, en el marco de una huelga y
#' realizaron una manifestación con piquete en el puerto de la ciudad."
#' dicc <- c("huel", "manif", "piq")
#' acep_extract(texto, dicc)
#' @export
acep_extract <- function(texto, dicc, sep = " | ", tolower = TRUE) {
  if (is.vector(texto) == TRUE & is.list(texto) != TRUE) {
    out <- tryCatch({
      p_extract <- character(length(texto))
      claves <- paste0(dicc, "\\w*\\b", collapse = "|")
      if (tolower == TRUE) {
        for (i in seq_along(texto)) {
          palabras_encontradas <- regmatches(tolower(texto[i]), gregexpr(claves, tolower(texto[i])))[[1]]
          p_extract[i] <- paste(palabras_encontradas, collapse = sep)
        }
      } else {
        for (i in seq_along(texto)) {
          palabras_encontradas <- regmatches(texto[i], gregexpr(claves, texto[i]))[[1]]
          p_extract[i] <- paste(palabras_encontradas, collapse = sep)
        }
      }
      p_extract
    })
    return(out)
  } else {
    message("No ingresaste un vector. Vuelve a intentarlo ingresando un vector!")
  }
}
