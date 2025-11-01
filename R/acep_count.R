#' Cache para regex compilados
#' @keywords internal
.acep_regex_cache <- new.env(parent = emptyenv())

#' @title Conteo de menciones de palabras de un diccionario
#' @description
#' Cuenta el número de veces que aparecen palabras de un diccionario en cada texto.
#' Utiliza expresiones regulares con límites de palabra (word boundaries) para
#' evitar coincidencias parciales. Incluye un sistema de caché que almacena los
#' patrones regex compilados para acelerar ejecuciones repetidas con el mismo diccionario.
#' @param texto vector de textos al que se le aplica la función de conteo.
#' @param dic vector de palabras del diccionario utilizado.
#' @param use_cache logical, usar caché de regex (default TRUE).
#' @return Vector con frecuencia de palabras del diccionario.
#' @keywords indicadores frecuencia tokens
#' @importFrom stringr str_count
#' @examples
#' df <- data.frame(texto = c("El SUTEBA fue al paro. Reclaman mejoras salariales.",
#' "El SOIP lleva adelante un plan de lucha con paros y piquetes."))
#' diccionario <- c("paro", "lucha", "piquetes")
#' df$detect <- acep_count(df$texto, diccionario)
#' df
#' @export
acep_count <- function(texto, dic, use_cache = TRUE) {
  validate_character(texto, "texto")
  validate_character(dic, "dic")

  # Crear hash del diccionario para caché
  if (use_cache) {
    dic_hash <- paste0(sort(dic), collapse = "")

    # Buscar en caché
    if (exists(dic_hash, envir = .acep_regex_cache)) {
      dicc <- get(dic_hash, envir = .acep_regex_cache)
    } else {
      # Compilar y guardar en caché
      dicc <- paste0(gsub("^ | $", "\\\\b", dic), collapse = "|")
      assign(dic_hash, dicc, envir = .acep_regex_cache)
    }
  } else {
    dicc <- paste0(gsub("^ | $", "\\\\b", dic), collapse = "|")
  }

  stringr::str_count(texto, dicc)
}

#' @title Limpiar caché de expresiones regulares
#' @description
#' Elimina todos los patrones regex almacenados en el caché interno de `acep_count()`.
#' Útil para liberar memoria cuando se han procesado muchos diccionarios diferentes
#' o cuando se quiere forzar la recompilación de patrones.
#'
#' @return Devuelve `NULL` invisiblemente.
#' @export
#' @examples
#' # Limpiar el caché
#' acep_clear_regex_cache()
acep_clear_regex_cache <- function() {
  rm(list = ls(envir = .acep_regex_cache), envir = .acep_regex_cache)
  invisible(NULL)
}

#' @title Consultar tamaño del caché de regex
#' @description
#' Devuelve el número de patrones regex almacenados actualmente en el caché
#' interno de `acep_count()`. Cada diccionario único genera una entrada en el caché.
#'
#' @return Número entero con la cantidad de patrones en caché.
#' @export
#' @examples
#' # Ver cuántos patrones hay en caché
#' acep_regex_cache_size()
acep_regex_cache_size <- function() {
  length(ls(envir = .acep_regex_cache))
}
