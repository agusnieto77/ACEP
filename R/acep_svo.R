#' @title Función para extraer tripletes SVO (Sujeto-Verbo-Objeto).
#' @description
#' Función que devuelve seis objetos data.frame con
#' etiquetado POS (modelo spacyr) y relaciones sintácticas
#' (modelo rsyntax) que permiten reconstruir estructuras
#' sintácticas como SVO y Sujeto-Predicado. Una vez seleccionadas
#' las notas periodísticas referidas a conflictos, esta función permite
#' extraer sujetos de la protesta, acción realizada y objeto(s) de la acción.
#' También devuelve entidades nombradas (NER).
#' @param acep_tokenindex data.frame con el etiquetado POS y las relaciones
#' de dependencia generado con la función acep_postag.
#' @param prof_s es un numero entero positivo que determina la profundidad a la que se
#' buscan las relaciones dentro del sujeto. Este parámetro se hereda del la función children()
#' del paquete {rsyntax}. Se recomienda no superar el valor 2.
#' @param prof_o es un numero entero positivo que determina la profundidad a la que se
#' buscan las relaciones dentro del objeto. Este parámetro se hereda del la función children()
#' del paquete {rsyntax}. Se recomienda no superar el valor 2.
#' @param u numero entero que indica el umbral de palabras del objeto en la reconstrucción SVO.
#' @importFrom stats ave setNames
#' @importFrom rsyntax as_tokenindex custom_fill tquery children annotate_tqueries
#' @return Si todas las entradas son correctas, la salida sera una lista con tres bases de datos en formato tabular.
#' @references Welbers, K., Atteveldt, W. van, & Kleinnijenhuis, J. 2021. Extracting semantic relations using syntax:
#' An R package for querying and reshaping dependency trees. Computational Communication Research, 3-2, 1-16.
#' \href{https://www.aup-online.com/content/journals/10.5117/CCR2021.2.003.WELB?TRACK}{(link al articulo)}
#' @source \href{https://universaldependencies.org/}{Dependencias Universales para taggeo POS}
#' @source \href{https://cran.r-project.org/web/packages/rsyntax/rsyntax.pdf}{Sobre el paquete rsyntax}
#' @keywords tripletes sintaxis
#' @examples
#'\dontrun{
#' acep_svo(acep_bases$spacy_postag)
#'}
#' @export
acep_svo <- function(acep_tokenindex,
                     prof_s = 3,
                     prof_o = 3,
                     u = 1
){
  relaciones = c("flat","fixed","appos", "nmod", "amod")
  conexiones = FALSE
  rel_s = c("nsubj", "conj")
  rel_o = c("obj", "obl", "advcl", "xcomp", "conj", "acl")
  rel_evs = "nsubj"
  rel_evp = "obj"
  if (class(acep_tokenindex)[1] != "tokenIndex") {
    return(
      message(
        "El par\u00e1metro 'acep_tokenindex' debe ser de clase 'tokenIndex'"))
  }
  if (!is.numeric(prof_s) | prof_s > 5 | prof_s < 1) {
    return(
      message(
        "El par\u00e1metro 'prof_s' debe ser de un n\u00famero entero positivo entre 1 y 5"))
  }
  if (!is.numeric(prof_o) | prof_o > 5 | prof_o < 1) {
    return(
      message(
        "El par\u00e1metro 'prof_o' debe ser de un n\u00famero entero positivo entre 1 y 5"))
  }
  if (!is.numeric(u) | u > 5 | u < 1) {
    return(
      message(
        "El par\u00e1metro 'u' debe ser de un n\u00famero entero positivo entre 1 y 5"))
  }

  fill <- rsyntax::custom_fill(relation = relaciones, min_window = c(1,1), connected = conexiones)

  direct <- rsyntax::tquery(
    label = "verbo", pos = "VERB", fill = FALSE,
    rsyntax::children(label = "sujeto", relation = rel_s, depth = prof_s, fill),
    rsyntax::children(label = "objeto", relation = rel_o, depth = prof_o, fill))

  indirect <- rsyntax::tquery(
    label = "verbo", pos = "VERB", fill = FALSE,
    rsyntax::children(label = "sujeto", relation = "nsubj:pass", depth = prof_s, fill),
    rsyntax::children(label = "objeto", relation = rel_o, depth = prof_o, fill))

  acep_annotate <- rsyntax::annotate_tqueries(acep_tokenindex, "s_v_o", direct, indirect, overwrite = FALSE)

  acep_annotate <- subset(acep_annotate, pos != "SPACE")

  acep_annotate$s_p <- ifelse(acep_annotate$pos == "VERB" & acep_annotate$relation == "ROOT", "predicado", "")

  acep_annotate$s_p <- with(acep_annotate,
                            ave(s_p, doc_id, sentence,
                                FUN = function(x) ifelse(cumsum(x == "predicado") > 0, "predicado", "sujeto")))

  acep_annotate$conjugaciones <- ifelse(grepl("Past", acep_annotate$morph), "pasado",
                                        ifelse(grepl("Pres", acep_annotate$morph), "presente",
                                               ifelse(grepl("Fut", acep_annotate$morph), "futuro", NA)))

  acep_annotate_o <- acep_annotate

  acep_annotate$relation <- gsub(":pass", "", acep_annotate$relation)

  sust_pred <- subset(acep_annotate, s_p == "predicado" & (pos == "PROPN" | pos == "NOUN"))

  if (nrow(sust_pred) > 0) {
    sust_pred <- setNames(
      subset(
        aggregate(
          token ~ doc_id + sentence,
          sust_pred,
          paste0, collapse = " | "),
        select = c(doc_id, sentence, token)),
      c("doc_id", "sentence", "sust_pred"))
  } else {
    sust_pred <- setNames(
      subset(
        aggregate(
          token ~ doc_id + sentence,
          acep_annotate,
          paste0, collapse = " "),
        select = c(doc_id, sentence, token)),
      c("doc_id", "sentence", "sust_pred"))
    sust_pred$sust_pred <- NA
  }

  acep_return <-  subset(acep_annotate, !is.na(s_v_o_fill))
  acep_return <- subset(acep_return, pos != "ADP")

  sujetos <- subset(acep_return, s_p == "sujeto" & relation == "nsubj" |
                      s_p == "sujeto" & relation == rel_evs)

  if (nrow(sujetos) > 0) {
    sujetos <- setNames(
      aggregate(
        token ~ doc_id + sentence,
        sujetos,
        paste0, collapse = " "),
      c("doc_id", "sentence", "sujetos"))
  } else {
    sujetos <- setNames(
      aggregate(
        token ~ doc_id + sentence,
        acep_annotate,
        paste0, collapse = " "),
      c("doc_id", "sentence", "sujetos"))
    sujetos$sujetos <- NA
  }

  verbos <- subset(acep_return, relation == "ROOT")

  if (nrow(verbos) > 0) {
    verbos <- setNames(
      aggregate(
        token ~ doc_id + sentence,
        verbos,
        paste0, collapse = " "),
      c("doc_id", "sentence", "verbos"))
  } else {
    verbos <- setNames(
      aggregate(
        token ~ doc_id + sentence,
        acep_annotate,
        paste0, collapse = " "),
      c("doc_id", "sentence", "verbos"))
    verbos$verbos <- NA
  }

  predicados <- subset(acep_return, relation == "obj" | relation == "obl")

  if (nrow(predicados) > 0) {
    predicados <- setNames(
      aggregate(
        token ~ doc_id + sentence,
        predicados,
        paste0, collapse = " "),
      c("doc_id", "sentence", "predicados"))
  } else {
    predicados <- setNames(
      aggregate(
        token ~ doc_id + sentence,
        acep_annotate,
        paste0, collapse = " "),
      c("doc_id", "sentence", "predicados"))
    predicados$predicados <- NA
  }

  sujeto <- subset(acep_return, s_p == "sujeto")

  if (nrow(sujeto) > 0) {
    sujeto <- setNames(
      aggregate(
        token ~ doc_id + sentence,
        sujeto,
        paste0, collapse = " "),
      c("doc_id", "sentence", "sujeto"))
  } else {
    sujeto <- setNames(
      aggregate(
        token ~ doc_id + sentence,
        acep_annotate,
        paste0, collapse = " "),
      c("doc_id", "sentence", "sujeto"))
    sujeto$sujeto <- NA
  }

  predicado <- subset(acep_return, s_p == "predicado")

  if (nrow(predicado) > 0) {
    predicado <- setNames(
      aggregate(
        token ~ doc_id + sentence,
        predicado,
        paste0, collapse = " "),
      c("doc_id", "sentence", "predicado"))
  } else {
    predicado <- setNames(
      aggregate(
        token ~ doc_id + sentence,
        acep_annotate,
        paste0, collapse = " "),
      c("doc_id", "sentence", "predicado"))
    predicado$predicado <- NA
  }

  verbo <- subset(acep_return, relation == "ROOT")

  if (nrow(verbo) > 0) {
    verbo <- setNames(
      aggregate(
        token ~ doc_id + sentence,
        verbo,
        paste0, collapse = " "),
      c("doc_id", "sentence", "verbo"))
  } else {
    verbo <- setNames(
      aggregate(
        token ~ doc_id + sentence,
        acep_annotate,
        paste0, collapse = " "),
      c("doc_id", "sentence", "verbo"))
    verbo$verbo <- NA
  }

  conjugaciones <- subset(acep_return, s_v_o == "verbo")

  if (nrow(conjugaciones) > 0) {
    conjugaciones <- setNames(
      aggregate(
        token ~ doc_id + sentence + sent,
        conjugaciones,
        paste0, collapse = " "),
      c("doc_id", "sentence", "sent", "conjugaciones"))
  } else {
    conjugaciones <- setNames(
      aggregate(
        token ~ doc_id + sentence + sent,
        acep_annotate,
        paste0, collapse = " "),
      c("doc_id", "sentence", "sent", "conjugaciones"))
    conjugaciones$conjugaciones <- NA
  }

  lemma_verb <- subset(acep_return, relation == "ROOT")

  if (nrow(lemma_verb) > 0) {
    lemma_verb <- setNames(
      aggregate(
        token ~ doc_id + sentence,
        lemma_verb,
        paste0, collapse = " "),
      c("doc_id", "sentence", "lemma_verb"))
  } else {
    lemma_verb <- setNames(
      aggregate(
        token ~ doc_id + sentence,
        acep_annotate,
        paste0, collapse = " "),
      c("doc_id", "sentence", "lemma_verb"))
    lemma_verb$lemma_verb <- NA
  }

  aux_verbos <- subset(acep_return, pos == "VERB" & !is.na(parent))

  if (nrow(aux_verbos) > 0) {
    aux_verbos <- setNames(
      aggregate(
        token ~ doc_id + sentence,
        aux_verbos,
        paste0, collapse = " "),
      c("doc_id", "sentence", "aux_verbos"))
  } else {
    aux_verbos <- setNames(
      aggregate(
        token ~ doc_id + sentence,
        acep_annotate,
        paste0, collapse = " "),
      c("doc_id", "sentence", "aux_verbos"))
    aux_verbos$aux_verbos <- NA
  }

  entidades <- subset(acep_return, pos == "PROPN")

  if (nrow(entidades) > 0) {
    entidades <- setNames(
      aggregate(
        token ~ doc_id + sentence,
        entidades,
        paste0, collapse = " "),
      c("doc_id", "sentence", "entidades"))
  } else {
    entidades <- setNames(
      aggregate(
        token ~ doc_id + sentence,
        acep_annotate,
        paste0, collapse = " "),
      c("doc_id", "sentence", "entidades"))
    entidades$entidades <- NA
  }

  acep_return <-
    merge(
      merge(
        merge(
          merge(
            merge(
              merge(
                merge(
                  merge(
                    merge(
                      sujetos, verbos, all.x = TRUE),
                    predicados, all.x = TRUE),
                  sujeto, all.x = TRUE),
                predicado, all.x = TRUE),
              verbo, all.x = TRUE),
            conjugaciones, all.x = TRUE),
          lemma_verb, all.x = TRUE),
        aux_verbos, all.x = TRUE),
      entidades, all.x = TRUE)

  orac_com <- unique(subset(acep_annotate, select = c(doc_id, sentence, sent)))
  orac_fil <- unique(subset(acep_return, select = c(doc_id, sentence, sent)))

  anti_join <- merge(orac_com, orac_fil, by = c('doc_id', 'sentence'), all.x = TRUE)
  anti_join <- subset(anti_join, is.na(sent.y))

  no_procesadas <- setNames(subset(anti_join, select = c(doc_id, sentence, sent.x)), c("doc_id", "oracion_id", "oracion"))

  acep_return$eventos <- paste0(acep_return$sujetos, " -> ", acep_return$verbos, " -> ", acep_return$predicados)

  acep_return$entidades <- gsub("\\s[a-z]+\\s+", "  ", acep_return$entidades)
  acep_return$entidades <- gsub("\\s\\s+", "  ", acep_return$entidades)
  acep_return$entidades <- gsub("\\s\\s+", " | ", acep_return$entidades)
  acep_return$entidades <- gsub("\\| \\|", "|", acep_return$entidades)
  acep_return$entidades <- gsub("\\s+", " | ", acep_return$entidades)
  acep_return$entidades <- gsub("\\s+", " ", acep_return$entidades)
  acep_return$entidades <- paste0("| ", acep_return$entidades, " |", sep = "")
  acep_return$entidades <- gsub("\\| \\|", "|", acep_return$entidades)
  acep_return$entidades <- gsub("\\|  \\|", "", acep_return$entidades)
  acep_return$aux_verbos <- gsub("\\s+", " | ", acep_return$aux_verbos)
  acep_return$aux_verbos <- gsub("\\s+", " ", acep_return$aux_verbos)
  acep_return$aux_verbos <- paste0("| ", acep_return$aux_verbos, " |", sep = "")
  acep_return$aux_verbos <- gsub("\\| \\|", "|", acep_return$aux_verbos)
  acep_return$aux_verbos <- gsub("\\|  \\|", "", acep_return$aux_verbos)
  acep_return$conjugaciones <- gsub("(^[a-zA-Z]+)\\s.+", "\\1", acep_return$conjugaciones)
  acep_return$eventos <- gsub("\\s+", " ", acep_return$eventos)
  acep_return$eventos <- gsub(" -> $", "", acep_return$eventos)
  acep_return$eventos <- gsub("^\\s*", "", acep_return$eventos)
  acep_return$eventos <- gsub("*\\s$", "", acep_return$eventos)
  acep_return$eventos <- gsub("^-> ", "NA -> ", acep_return$eventos)
  acep_return$eventos <- gsub("-> ->", "-> NA ->", acep_return$eventos)

  acep_return <- merge(acep_return, sust_pred, all.x = TRUE)

  acep_return <- acep_return[ , c('doc_id','sentence','sujetos','verbos',
                                  'predicados','sujeto','entidades','eventos',
                                  'predicado','verbo','lemma_verb','aux_verbos',
                                  'sust_pred')]

  acep_return <- acep_return[order(acep_return$doc_id), ]

  row.names(acep_return) <- 1:length(acep_return$doc_id)

  names(acep_return)[names(acep_return) == "sentence"] <- "oracion_id"
  names(acep_return)[names(acep_return) == "sent"] <- "oracion"

  acep_ret <- acep_return[, c("doc_id","oracion_id","eventos")]

  acep_ret <- cbind(acep_ret, do.call("rbind", strsplit(as.character(acep_ret$eventos), " -> ", fixed = TRUE)))

  names(acep_ret)[names(acep_ret) == "1"] <- "sujeto"
  names(acep_ret)[names(acep_ret) == "2"] <- "verbo"
  names(acep_ret)[names(acep_ret) == "3"] <- "objeto"

  acep_sp <- acep_return[ , c("doc_id","oracion_id","sujeto","predicado","verbo",
                              "lemma_verb","aux_verbos","entidades","sust_pred")]

  acep_lista_lemmas <- subset(acep_annotate_o, nchar(token) > 1)

  acep_lista_lemmas <- subset(acep_lista_lemmas, !pos %in% c("NUM", "PUNCT", "X", "DET", "ADP", "ADV", "CCONJ", "INTJ", "PRON", "SCONJ", "SYM", "SPACE"))

  acep_lista_lemmas <- stats::setNames(as.data.frame(table(acep_lista_lemmas$lemma)), c("lemma", "n"))

  acep_lista_lemmas <- acep_lista_lemmas[order(acep_lista_lemmas$n, decreasing = TRUE), ]

  acep_pro_svo  <- acep_return[ , c('doc_id','oracion_id','eventos','sujeto','predicado','verbo',
                                    'lemma_verb','aux_verbos','entidades','sust_pred')]

  acep_pro_svo <- cbind(acep_pro_svo, do.call("rbind", strsplit(as.character(acep_pro_svo$eventos), " -> ", fixed = TRUE)))

  names(acep_pro_svo)[names(acep_pro_svo) == "1"] <- "sujeto_svo"
  names(acep_pro_svo)[names(acep_pro_svo) == "2"] <- "root"
  names(acep_pro_svo)[names(acep_pro_svo) == "3"] <- "objeto"

  acep_pro_svo <- acep_pro_svo[ , c("doc_id","oracion_id","eventos","sujeto_svo",
                                    "root","objeto","sujeto","predicado","verbo",
                                    "lemma_verb","aux_verbos","entidades","sust_pred")]

  if (length(table(acep_annotate_o$conjugaciones)) == 0) {
    acep_svo_list <-  "No hay oraciones procesables."
    message(acep_svo_list)
  } else {

    acep_svo_list <- list(acep_annotate_svo = acep_annotate_o,
                          acep_pro_svo = acep_pro_svo,
                          acep_list_svo = acep_ret,
                          acep_sp = acep_sp,
                          acep_lista_lemmas = acep_lista_lemmas,
                          acep_no_procesadas = no_procesadas)
    acep_svo_list
  }
}
