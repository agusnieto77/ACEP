#' @title Función para buscar y extraer palabras en un texto.
#' @description Esta función busca palabras clave en un texto y
#' extrae los resultados en un formato especifico.
#' @param texto El texto en el que se buscaran las palabras clave.
#' @param dic Un vector con las palabras clave a buscar.
#' @param sep El separador utilizado para concatenar las
#' palabras clave encontradas (por defecto: " | ").
#' @param izq expresión regular para incorporar otros caracteres a
#' la izquierda de los términos del vector 'dic'.
#' @param der expresión regular para incorporar otros caracteres a
#' la derecha de los términos del vector 'dic'.
#' @return Si todas las entradas son correctas,
#' la salida sera un vector de tipo caracter.
#' procesado y el contexto de las palabras y/o frases entradas.
#' @importFrom stringr str_extract_all
#' @keywords buscar palabras texto diccionario
#' @examples
#' texto <- "Los obreros del pescado, en el marco de una huelga y
#' realizaron una manifestación con piquete en el puerto de la ciudad."
#' dicc <- c("huel", "manif", "piq")
#' acep_extract(texto, dicc)
#' @export
acep_extract <- function(texto, dic, sep="; ", izq="\\b\\w*", der="\\w*\\b") {
  if (!is.character(texto)) {
    return(message(
      "No ingresaste un vector de texto en el par\u00e1metro 'texto'.
      Vuelve a intentarlo ingresando un vector de texto!"))
  }
  if (!is.character(dic)) {
    return(message(
      "No ingresaste un vector de texto en el par\u00e1metro 'dic'.
      Vuelve a intentarlo ingresando un vector de texto!"))
  }
  if (!is.character(sep) && !is.null(sep)) {
    return(message(
      "No ingresaste un caracter separador en el par\u00e1metro 'sep'."))
  }
  if (!is.character(izq) && !is.null(izq)) {
    return(message(
      "No ingresaste una expresi\u00f3n regular en el par\u00e1metro 'izq'."))
  }
  if (!is.character(der) && !is.null(der)) {
    return(message(
      "No ingresaste una expresi\u00f3n regular en el par\u00e1metro 'der'."))
  } else {
    sapply(texto, function(txt) {
      dic <- gsub(" $", "\\\\b", dic)
      x <- paste0(izq, gsub("^ ", "", dic), der, collapse = "|")
      key_words <- unlist(stringr::str_extract_all(txt, x))
      key_words <- key_words[sapply(key_words, length) > 0]
      if (!is.null(sep)) {
        paste(key_words, collapse = sep)
      } else {
        unname(sapply(key_words, function(x) unlist(x)))
      }
    }, USE.NAMES = FALSE)
  }
}
