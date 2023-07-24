#' @title Limpieza de texto.
#' @description Función que limpia y normaliza las notas/textos.
#' @param x vector de textos al que se le aplica la
#' función de limpieza de texto.
#' @param rm_hashtag remueve los hashtags.
#' @param rm_emoji remueve los emojis.
#' @param rm_punt remueve la puntuación.
#' @param rm_num remueve números.
#' @param rm_whitespace remueve los espacios en blanco.
#' @param rm_newline remueve los saltos de línea.
#' @param rm_cesp remueve caracteres especiales.
#' @param rm_stopwords remueve palabras vacías.
#' @param rm_dias remueve los dias de la semana.
#' @param rm_meses remueve los meses del año.
#' @param rm_shortwords remueve las palabras cortas.
#' @param rm_url remueve las url.
#' @param rm_users remueve las menciones de usuarixs de redes sociales.
#' @param other_sw su valor por defecto es NULL, sirve para ampliar el
#' listado de stopwords con un nuevo vector de palabras.
#' @param u umbral de caracteres para la función rm_shortwords.
#' @param tolower convierte los textos a minúsculas.
#' @return Si todas las entradas son correctas,
#' la salida sera un vector de textos normalizados.
#' @importFrom utils read.delim
#' @keywords limpieza normalización
#' @examples
#' acep_clean("El SUTEBA fue al paro. Reclaman mejoras salariales.", rm_punt = FALSE)
#' @export
acep_clean <- function(x,
                       tolower = TRUE,
                       rm_cesp = TRUE,
                       rm_emoji = TRUE,
                       rm_hashtag = TRUE,
                       rm_users = TRUE,
                       rm_punt = TRUE,
                       rm_num = TRUE,
                       rm_url = TRUE,
                       rm_meses = TRUE,
                       rm_dias = TRUE,
                       rm_stopwords = TRUE,
                       rm_shortwords = TRUE,
                       rm_newline = TRUE,
                       rm_whitespace = TRUE,
                       other_sw = NULL,
                       u = 1) {
  if(!is.vector(x) | is.list(x)){
    return(message("No ingresaste un vector en el par\u00e1metro x.
                   Vuelve a intentarlo ingresando un vector!"))
  } else {
    if(is.vector(x) & !is.list(x)) {
      out <- tryCatch({
      if (tolower) {
        x <- gsub(pattern = "([[:upper:]])", perl = TRUE,
                  replacement = "\\L\\1", x)
        }
      if (tolower) {
        tildes <- readRDS(
          url(
            "https://observatoriodeconflictividad.org/basesdatos/tildes.rds"))
        x <- chartr(tildes, tolower(tildes), x)
        }
      if (rm_cesp) {
        tildes <- readRDS(
          url(
            "https://observatoriodeconflictividad.org/basesdatos/tildes.rds"))
        sintildes <- readRDS(
          url(
            "https://observatoriodeconflictividad.org/basesdatos/sintildes.rds"))
        x <- chartr(tildes, sintildes, x)
        }
      if (rm_url) {
        x <- gsub(ACEP::acep_rs$url, "", x, perl = TRUE)
        }
      if (rm_emoji) {
        emojis <- utils::read.delim(
          'https://raw.githubusercontent.com/HDyCSC/datos/main/emojis.txt',
          header = FALSE)$V1
        x <- gsub(emojis, " ", x, perl = TRUE)
        }
      if (rm_hashtag) {
        x <- gsub(ACEP::acep_rs$hashtag, "", x, perl = TRUE)
        }
      if (rm_users) {
        x <- gsub(ACEP::acep_rs$users, "", x, perl = TRUE)
        }
      if (rm_punt) {
        punt1 <- utils::read.delim(
          'https://raw.githubusercontent.com/HDyCSC/datos/main/punt1.txt',
          header = FALSE)$V1
        x <- gsub(punt1, " ", x, perl = TRUE)
        }
      if (rm_num) {
        x <- gsub(ACEP::acep_rs$num, "", x, perl = TRUE)
        }
      if (rm_meses) {
        meses <- utils::read.delim(
          'https://raw.githubusercontent.com/HDyCSC/datos/main/meses.txt',
          header = FALSE)$V1
        x <- gsub(meses, "", x, perl = TRUE)
        }
      if (rm_dias) {
        dias <- utils::read.delim(
          'https://raw.githubusercontent.com/HDyCSC/datos/main/dias.txt',
          header = FALSE)$V1
        x <- gsub(dias, "", x, perl = TRUE)
        }
      if (rm_stopwords) {
        stopwords <- readRDS(
          url(
            "https://github.com/HDyCSC/datos/raw/222dd7c060fabc2904c1ceffbea6958f9a275b57/stopwords.rds"))
        if (is.null(other_sw)) {
          x <- gsub(stopwords, " ", x, perl = FALSE)
        } else {
          othersw <- paste0("|\\b", other_sw, "\\b", collapse = "")
          x <- gsub(paste0(stopwords, othersw), " ", x, perl = FALSE)
        }
      }
      if (rm_shortwords) {
        x <- gsub(paste0("\\b[[:alpha:]]{1,", u, "}\\b"), " ", x, perl = FALSE)
        }
      if (rm_punt) {
        punt1 <- utils::read.delim(
          'https://raw.githubusercontent.com/HDyCSC/datos/main/punt1.txt',
          header = FALSE)$V1
        x <- gsub(paste0("\\b",punt1,"\\b"), "", x, perl = TRUE)
        }
      if (rm_newline) {
        x <- gsub(ACEP::acep_rs$saltos, " ", x, perl = TRUE)
        }
      if (rm_whitespace) {
        gsub(ACEP::acep_rs$espacios, "", x, perl = TRUE)
      } else {
        x
      }
      }
      )
    }
    return(out)
  }
}
