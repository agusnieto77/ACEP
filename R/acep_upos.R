#' @title Función para etiquetado POS, lematizacion, tokenizacion.
#' @description
#' Función que devuelve un marco de datos objetos con
#' etiquetado POS (modelo udpipe) para su posterior
#' procesamiento con la función acep_postag.
#' @param texto vector con los textos a procesar.
#' @param modelo idioma del modelo de etiquetado POS del paquete {udpipe}.
#' @importFrom udpipe udpipe
#' @importFrom rsyntax as_tokenindex
#' @return Si todas las entradas son correctas, la salida sera un marco de datos con 17 variables.
#' @references Welbers, K., Atteveldt, W. van, & Kleinnijenhuis, J. 2021. Extracting semantic relations using syntax: An R package for querying and reshaping dependency trees. Computational Communication Research, 3-2, 1-16.
#' \href{https://www.aup-online.com/content/journals/10.5117/CCR2021.2.003.WELB?TRACK}{(link al articulo)}
#' @source \href{https://universaldependencies.org/}{Dependencias Universales para taggeo POS}
#' @source \href{https://ufal.mff.cuni.cz/~straka/papers/2017-conll_udpipe.pdf}{Sobre el modelo UDPipe}
#' @source \href{https://cran.r-project.org/web/packages/rsyntax/rsyntax.pdf}{Sobre el paquete rsyntax}
#' @keywords sintaxis
#' @examples
#' \dontrun{
#' texto <- "El SOIP declara la huelga en demanda de aumento salarial."
#' acep_upos(texto)
#'}
#' @export
acep_upos <- function(texto, modelo = "spanish"
){
  if (!is.character(texto)) {
    return(message("El par\u00e1metro 'texto' debe ser una cadena de caracteres"))
  }
  available_models <- c('english', 'portuguese', 'spanish')
  if (!modelo %in% available_models) {
    return(
      message(
        "El par\u00e1metro 'core' debe ser un modelo 'udpipe' v\u00e1lido del espa\u00f1ol, ingl\u00e9s o portugu\u00e9s"))
  }
  texto <- gsub(",\\S", ", ", texto)
  texto <- gsub("(\\s[A-Z])\\.\\s", "\\1 ", texto)
  texto <- gsub("(\\s[A-Z][a-zA-Z]*);\\s", "\\1, ", texto)
  texto <- gsub(";(\\s[a-zA-Z]*|\\s[a-zA-Z]*\\s[a-zA-Z]*|\\s[a-zA-Z]*\\s[a-zA-Z]*\\s[a-zA-Z]*);\\s", "\\1, ", texto)
  texto <- gsub(";(\\s[a-zA-Z]*\\.\\s|\\s[a-zA-Z]*\\s[a-zA-Z]*\\.\\s|\\s[a-zA-Z]*\\s[a-zA-Z]*\\s[a-zA-Z]*\\.\\s)", "\\1", texto)
  texto <- gsub(";(\\s[a-zA-Z]*\\.\\b|\\s[a-zA-Z]*\\s[a-zA-Z]*\\.\\b|\\s[a-zA-Z]*\\s[a-zA-Z]*\\s[a-zA-Z]*\\.\\b)", "\\1", texto)
  abrev <- c("Arq\\.", "Agr\\.", "art\\.", "atte\\.", "aprox\\.", "Av\\.",
             "Avda\\.", "Bco\\.", "Bs\\.", "As\\.", "c\\.", "Cap\\.", "Fed\\.",
             "Comp\\.", "C\\u00eda\\.", "Cit\\.", "cja\\.", "c\\u00f3d\\.", "Cte\\.", "cta\\.",
             "Dpto\\.", "cit\\.", "Dr\\.", "Dra\\.", "Ej\\.", "esq\\.", "Excmo\\.",
             "Excma\\.", "cit\\.", "Flia\\.", "Gral\\.", "hs\\.", "hnos\\.",
             "Ing\\.", "Izq\\.", "Kg\\.", "Km\\.", "Lic\\.", "Ma\\.", "m\\u00e1x\\.",
             "Min\\.", "M\\u00edn\\.", "Nro\\.", "N\\u00fam\\.", "Op\\.", "P\\.", "P\\u00e1g\\.",
             "pdo\\.", "ppdo\\.", "Prof\\.", "Profra\\.", "Sr\\.", "Sra\\.", "Sres\\.",
             "Srta\\.", "Sta\\.", "Sto\\.", "Tel\\.", "Ud\\.", "Udes\\.", "V\\.",
             "Vda\\.", "Vdo\\.", "Vol\\.", "Vols\\.", "Vta\\.", "Vd\\.", "Vds\\.")
  abrev <- paste0(" ", abrev)
  abrev <- c(abrev, ACEP::acep_min(abrev))
  for (i in abrev) {
    texto <- gsub(i, gsub("\\.","",i), texto)
  }
  acep_udpipe <- udpipe::udpipe(x = texto, object = modelo)
  acep_udpipe <- subset(acep_udpipe, !is.na(dep_rel))
  acep_udpipe$doc_id <- as.integer(gsub("doc", "", acep_udpipe$doc_id))
  acep_udpipe$sentence <- gsub("^\\n*|^\n*\\s*|^\\s*|^\\s*\n*|*\n$|*\\s*\n$|*\\s$|*\n*\\s$", "", acep_udpipe$sentence)
  acep_udpipe <- subset(acep_udpipe, sentence != "")
  acep_udpipe$dep_rel <- gsub("root", "ROOT", acep_udpipe$dep_rel)
  acep_udpipe$head_token_id <- ifelse(acep_udpipe$head_token_id == 0, NA, acep_udpipe$head_token_id)
  acep_udpipe$head_token_id <- as.integer(acep_udpipe$head_token_id)
  colnames(acep_udpipe) <- c("doc_id","paragraph_id","sentence","sent","start","end","term_id","token_id",
                             "token","lemma","pos","xpos","morph","parent","relation","deps","misc")
  acep_udpipe <- rsyntax::as_tokenindex(acep_udpipe)
  return(acep_udpipe)
}
