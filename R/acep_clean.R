#' @title Limpieza de texto.
#' @description Función que limpia y normaliza las notas/textos.
#' @param x vector de textos al que se le aplica la
#' función de limpieza de texto.
#' @param rm_hashtag remueve los hashtags.
#' @param rm_emoji remueve los emojis.
#' @param rm_punt remueve la puntuación.
#' @param rm_num remueve números.
#' @param rm_whitespace remueve los espacios en blanco.
#' @param rm_newline remueve los saltos de linea.
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
#' @keywords limpieza normalización
#' @examples
#' acep_clean("El SUTEBA fue al paro. Reclaman mejoras salariales.", rm_stopword = FALSE)
#' acep_clean("El SUTEBA fue al paro. Reclaman mejoras salariales.", rm_stopword = TRUE)
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
    return(message("No ingresaste un vector en el parametro x.
           Vuelve a intentarlo ingresando un vector!"))
  }
  if (!is.logical(tolower) || !is.logical(rm_cesp) ||
      !is.logical(rm_emoji) || !is.logical(rm_hashtag) ||
      !is.logical(rm_users) || !is.logical(rm_punt) ||
      !is.logical(rm_num) || !is.logical(rm_url) ||
      !is.logical(rm_meses) || !is.logical(rm_dias) ||
      !is.logical(rm_stopwords) || !is.logical(rm_shortwords)||
      !is.logical(rm_newline) || !is.logical(rm_whitespace)) {
    return(message("Debe ingresar un valor booleano: TRUE o FALSE"))
  } else {
    if(is.vector(x) & !is.list(x)) {
      out <- tryCatch({
      if (tolower) {
        x <- gsub(pattern = "([[:upper:]])", perl = TRUE,
                  replacement = "\\L\\1", x)
      }
      if (rm_stopwords) {
        if (is.null(other_sw)) {
          x <- gsub(
            paste(
              ACEP::acep_rs$sw1,
              ACEP::acep_rs$sw2,
              collapse = ""),
            " ", x, perl = FALSE)
        } else {
          othersw <- paste0("|\\b", other_sw, "\\b", collapse = "")
          x <- gsub(
            paste0(
              paste(
                ACEP::acep_rs$sw1,
                ACEP::acep_rs$sw2,
                collapse = ""),
              othersw),
            " ", x, perl = FALSE)
        }
      }
      if (tolower) {
        x <- chartr(ACEP::acep_rs$tildes,
                    tolower(ACEP::acep_rs$tildes), x)
        }
      if (rm_cesp) {
        x <- chartr(ACEP::acep_rs$tildes,
                    ACEP::acep_rs$sintildes, x)
        }
      if (rm_url) {
        x <- gsub(ACEP::acep_rs$url, "", x, perl = TRUE)
        }
      if (rm_emoji) {
        x <- gsub(ACEP::acep_rs$emojis, " ", x, perl = TRUE)
        }
      if (rm_hashtag) {
        x <- gsub(ACEP::acep_rs$hashtag, "", x, perl = TRUE)
        }
      if (rm_users) {
        x <- gsub(ACEP::acep_rs$users, "", x, perl = TRUE)
        }
      if (rm_punt) {
        x <- gsub(ACEP::acep_rs$punt, " ", x, perl = TRUE)
        }
      if (rm_num) {
        x <- gsub(ACEP::acep_rs$num, "", x, perl = TRUE)
      }
      if (rm_meses) {
        x <- gsub(ACEP::acep_rs$meses, "", x, perl = TRUE)
        }
      if (rm_dias) {
        x <- gsub(ACEP::acep_rs$dias, "", x, perl = TRUE)
        }
      if (rm_shortwords) {
        x <- gsub(paste0("\\b[[:alpha:]]{1,", u, "}\\b"), " ", x, perl = FALSE)
        }
      if (rm_punt) {
        x <- gsub(paste0("\\b", ACEP::acep_rs$punt,"\\b"), "", x, perl = TRUE)
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
