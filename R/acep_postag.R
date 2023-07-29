#' @title Función para etiquetado POS, lematización, tokenización, extracción de entidades.
#' @description
#' Función que devuelve seis objetos data.frame con
#' etiquetado POS (modelo spacyr) para su posterior
#' procesamiento con la función acep_postag.
#' @param texto vector con los textos a procesar.
#' @param core idioma del modelo de etiquetado POS del paquete {spacyr}.
#' @param bajar_core parámetro booleano que define si bajar o no el modelo de etiquetado POS.
#' @param inst_spacy parámetro booleano que define si instalar o no spacy (python).
#' @param inst_miniconda parámetro booleano que define si instalar o no miniconda.
#' Miniconda es un instalador mínimo gratuito para conda. Es una pequeña versión de
#' arranque de Anaconda que incluye solo conda, Python, los paquetes de los que dependen y
#' una pequeña cantidad de otros paquetes útiles, incluidos pip, zlib y algunos otros.
#' @param inst_reticulate parámetro booleano que define si instalar o no el paquete {reticulate}.
#' @export acep_postag
#' @importFrom utils install.packages
#' @importFrom spacyr spacy_install spacy_download_langmodel spacy_initialize spacy_parse entity_consolidate entity_extract nounphrase_consolidate nounphrase_extract spacy_finalize
#' @importFrom rsyntax as_tokenindex
#' @importFrom tidygeocoder geo
#' @importFrom reticulate install_miniconda
#' @return Si todas las entradas son correctas, la salida sera una lista con seis bases de datos en formato tabular.
#' @source \href{https://universaldependencies.org/}{Dependencias Universales para taggeo POS}
#' @source \href{https://cran.r-project.org/web/packages/spacyr/spacyr.pdf}{Sobre el modelo spaCy de Python para R}
#' @source \href{https://jessecambon.github.io/tidygeocoder/articles/tidygeocoder.html}{Sobre el paquete tidygeocoder}
#' @keywords etiquetado
#' @examples
#' \dontrun{
#' texto <- "En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial."
#' texto_postag <- acep_postag(texto)
#' texto_postag$texto_tag[ , c(1:8)]
#'}
#' @export
acep_postag <- function(texto,
                        core = "es_core_news_lg",
                        bajar_core = TRUE,
                        inst_spacy = FALSE,
                        inst_miniconda = FALSE,
                        inst_reticulate = FALSE

                        ){
  if (!is.character(texto)) {
    return(message("El par\u00e1metro 'texto' debe ser una cadena de caracteres"))
  }
  if (!is.logical(inst_reticulate)) {
    return(message("El par\u00e1metro 'inst_reticulate' debe ser un valor booleano: TRUE o FALSE"))
  }
  if (!is.logical(inst_miniconda)) {
    return(message("El par\u00e1metro 'inst_miniconda' debe ser un valor booleano: TRUE o FALSE"))
  }
  if (!is.logical(inst_spacy)) {
    return(message("El par\u00e1metro 'inst_spacy' debe ser un valor booleano: TRUE o FALSE"))
  }
  if (!is.logical(bajar_core)) {
    return(message("El par\u00e1metro 'bajar_core' debe ser un valor booleano: TRUE o FALSE"))
  }
  available_models <- c('es_core_news_sm','es_core_news_md','es_core_news_lg',
                        'pt_core_news_sm','pt_core_news_md','pt_core_news_lg',
                        'en_core_web_sm','en_core_web_md','en_core_web_lg','en_core_web_trf')
  if (!core %in% available_models) {
    return(
      message(
        "El par\u00e1metro 'core' debe ser un modelo 'core' v\u00e1lido del espa\u00f1ol, ingl\u00e9s o portugu\u00e9s: ",
        paste0(available_models, collapse = ", ")))
  }
  if (inst_reticulate) {
    utils::install.packages("reticulate")
  }
  if (inst_reticulate) {
    reticulate::install_miniconda()
  }
  if (inst_spacy) {
    spacyr::spacy_install()
  }
  if (bajar_core) {
    spacyr::spacy_download_langmodel(core)
  }
  spacyr::spacy_initialize(model = core)

  texto_tag <- data.frame()
  for (i in seq_along(texto)) {
    postag <-
      suppressWarnings({
        spacyr::spacy_parse(texto[i],
                            pos = TRUE,
                            tag = FALSE,
                            lemma = TRUE,
                            entity = TRUE,
                            dependency = TRUE,
                            nounphrase = TRUE,
                            multithread = TRUE,
                            additional_attributes =
                              c("is_upper", "is_title", "is_quote",
                                "ent_iob_","ent_iob", "is_left_punct",
                                "is_right_punct", "morph", "sent"))})
    postag$doc_id <- i
    texto_tag <- rbind(texto_tag, postag)
  }
  texto_tag$morph <- sapply(texto_tag$morph, function(m) paste0(m))
  texto_tag$sent <- sapply(texto_tag$sent, function(s) paste0(s))
  texto_tag$doc_id <- as.integer(gsub("text", "", texto_tag$doc_id))
  texto_tag$sent <- gsub("^\\n*|^\n*\\s*|^\\s*|^\\s*\n*|*\n$|*\\s*\n$|*\\s$|*\n*\\s$", "", texto_tag$sent)
  texto_tag <- subset(texto_tag, sent != "")
  texto_tag_entity <- spacyr::entity_consolidate(texto_tag)
  texto_only_entity <- spacyr::entity_extract(texto_tag, type = "all")
  texto_nounphrase <- spacyr::nounphrase_consolidate(texto_tag)
  texto_only_nounphrase <- spacyr::nounphrase_extract(texto_tag)
  spacyr::spacy_finalize()
  texto_tag <- rsyntax::as_tokenindex(texto_tag)
  texto_only_entity_loc <- texto_only_entity
  texto_only_entity_loc <- unique(subset(texto_only_entity_loc, entity_type == "LOC"))
  texto_only_entity_loc$entity_ <- gsub("_", " ", texto_only_entity_loc$entity)
  texto_geocoder <- tidygeocoder::geo(unique(texto_only_entity_loc$entity_), method = "osm")
  names(texto_geocoder) <- c("entity_", "lat", "long")
  texto_only_entity_loc <- merge(x = texto_only_entity_loc, y = texto_geocoder, by = "entity_", all.x = TRUE)
  names(texto_only_entity_loc) <- c("entity_", "doc_id", "sentence", "entity", "entity_type", "lat", "long")
  texto_only_entity_loc <- merge(texto_only_entity_loc, texto_tag[ , c("doc_id", "sentence")], by = c("doc_id", "sentence"))
  texto_only_entity_loc <- unique(subset(texto_only_entity_loc, !is.na(lat)))
  texto_tag <- list(texto_tag = texto_tag,
                    texto_tag_entity = texto_tag_entity,
                    texto_only_entity = texto_only_entity,
                    texto_only_entity_loc = texto_only_entity_loc,
                    texto_nounphrase = texto_nounphrase,
                    texto_only_nounphrase = texto_only_nounphrase
  )
  return(texto_tag)
}
