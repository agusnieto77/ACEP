#' @title Funcion para extraer triplets SVO (Sujeto-Verbo-Objeto).
#' @description Funcion que devuelve cuatro objetos data.frame con
#' etiquetado POS y relaciones sintacticas que permiten reconstruir
#' estructuras sintacticas como SVO y Sujeto-Predicado.
#' @param texto vector con los textos a procesar.
#' @param modelo idioma del modelo de etiquetado POS del paquete {udpipe}.
#' @param prof_s profundidad de relaciones sintacticas para el sujeto.
#' @param prof_o profundidad de relaciones sintacticas para el objeto.
#' @param relaciones vector con las relaciones de analisis sintactico del paquete {rsyntax}.
#' @param conexiones parametro logico (TRUE/FALSE) para la reconstruccion de las conexiones sintacticas.
#' @param rel_s vector de etiquetas de relaciones sintacticas en el sujeto.
#' @param rel_o vector de etiquetas de relaciones sintacticas en el objeto.
#' @param rel_evs etiqueta de relaciones a ser agregada en la reconstruccion del sujeto.
#' @param rel_evp etiqueta de relaciones a ser agregada en la reconstruccion del objeto.
#' @param u numero entero que indica el umbral de palabras del objeto en la reconstruccion SVO.
#' @export acep_svo
#' @importFrom stats na.omit
#' @importFrom udpipe udpipe
#' @importFrom rsyntax as_tokenindex custom_fill tquery children annotate_tqueries
#' @importFrom dplyr filter mutate group_by summarise ungroup rename distinct select left_join
#' @importFrom stringr str_trim str_replace_all
#' @return Si todas las entradas son correctas,
#' la salida sera una lista con tres bases de datos en formato tabular.
#' @keywords sintaxis
#' @examples
#' texto <- "El SOIP declara la huelga en demanda de aumento salarial."
#' texto_svo <- acep_svo(texto)
#' texto_svo$acep_list_svo
#' @export
acep_svo <- function(texto,
                     modelo = "spanish",
                     prof_s = 2,
                     prof_o = 2,
                     relaciones = c("flat","fixed","compount"),
                     conexiones = FALSE,
                     rel_s = c("nsubj", "conj"),
                     rel_o = c("obj","obl","nmod"),
                     rel_evs = "nsubj",
                     rel_evp = "obj",
                     u = 1
){
  texto <- gsub("([A-Z])\\.\\s", "\\1 ", texto)
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
  abrev <- c(abrev, tolower(abrev))
  for (i in abrev) {
    texto <- gsub(i, gsub("\\.","",i), texto)
  }
  acep_udpipe <- udpipe::udpipe(x = texto, object = modelo)
  acep_udpipe <- acep_udpipe |> dplyr::filter(!is.na(dep_rel))
  acep_tokenindex <- rsyntax::as_tokenindex(acep_udpipe)
  fill <- rsyntax::custom_fill(relation = relaciones,
                               min_window = c(1,1), connected= conexiones)
  direct <- rsyntax::tquery(
    label = "verb", upos = "VERB", fill = FALSE,
    rsyntax::children(label = "subject", relation = rel_s, depth = prof_s, fill),
    rsyntax::children(label = "object", relation = rel_o, depth = prof_o, fill))
  acep_annotate <- rsyntax::annotate_tqueries(acep_tokenindex, "clause", direct, overwrite = T)
  acep_annotate <- acep_annotate |> group_by(doc_id, paragraph_id, sentence, sentence_txt) |>
    dplyr::mutate(clause2 = ifelse(token_id < token_id[which(clause == "verb")][1], "sujeto", "predicado")) |>
    dplyr::ungroup()
  acep_annotate$doc_id  <- gsub("doc", "", acep_annotate$doc_id)
  acep_annotate$doc_id  <- as.integer(acep_annotate$doc_id)
  no_procesadas <- acep_annotate |> dplyr::filter(is.na(clause2)) |>
    dplyr::distinct(doc_id, paragraph_id, sentence, sentence_txt, sentence_txt) |>
    dplyr::rename(parrafo_id = paragraph_id,
                  oracion_id = sentence,
                  oracion = sentence_txt)
  sust_pred <- acep_annotate |>
    dplyr::group_by(doc_id, paragraph_id, sentence, sentence_txt) |>
    dplyr::summarise(
      sust_pred = paste0(ifelse(clause2 == "predicado" & upos == "PROPN" | clause2 == "predicado" & upos == "NOUN", token, ""), collapse = "|"),
      .groups = "drop"
    ) |>
    dplyr::mutate(sust_pred = stringr::str_replace_all(sust_pred, "  ", " ")) |>
    dplyr::mutate(sust_pred = stringr::str_replace_all(sust_pred, "\\|+", "|")) |>
    dplyr::mutate(sust_pred = stringr::str_replace_all(sust_pred, "\\|", " | ")) |>
    dplyr::mutate(sust_pred = stringr::str_replace_all(sust_pred, "^ \\|", "|")) |>
    dplyr::mutate(sust_pred = stringr::str_replace_all(sust_pred, "\\| $", "|")) |>
    dplyr::select(sentence_txt, sust_pred)
  acep_return <-  dplyr::filter(acep_annotate, !is.na(clause_fill))
  acep_return <- acep_return |> dplyr::filter(upos != "ADP")
  acep_return <- acep_return |>
    dplyr::group_by(doc_id, paragraph_id, sentence, sentence_txt) |>
    dplyr::summarise(
      sentence_txt = unique(sentence_txt),
      sujetos = paste0(ifelse(clause2 == "sujeto" & relation == "nsubj" | relation == rel_evs, token, ""), collapse = " "),
      verbos = paste0(ifelse(relation == "ROOT" , token, ""), collapse = " "),
      predicados = stats::na.omit(ifelse(relation == "obj" | relation == rel_evp, token, NA))[u],
      eventos = paste0(sujetos, " -> ", verbos, " -> ", predicados),
      sujeto = paste0(ifelse(clause2 == "sujeto" & clause == "subject", token, ""), collapse = " ") |> stringr::str_trim(),
      predicado = paste0(ifelse(clause2 == "predicado", token, ""), collapse = " ") |> stringr::str_trim(),
      verbo = paste0(ifelse(relation == "ROOT", token, ""), collapse = " ") |> stringr::str_trim(),
      lemma_verb = paste0(ifelse(relation == "ROOT", lemma, ""), collapse = " ") |> stringr::str_trim(),
      .groups = "drop"
    )
  acep_return$eventos <- gsub("\\s+", " ", acep_return$eventos)
  acep_return$eventos <- gsub(" -> $", "", acep_return$eventos)
  acep_return$eventos <- gsub("^\\s*", "", acep_return$eventos)
  acep_return$eventos <- gsub("*\\s$", "", acep_return$eventos)
  acep_return <- acep_return |> dplyr::left_join(sust_pred, by = "sentence_txt")
  acep_return <- acep_return |> dplyr::rename(parrafo_id = paragraph_id,
                                              oracion_id = sentence,
                                              oracion = sentence_txt)
  acep_ret <- acep_return[ , c(1:3, 8)]
  acep_sp <- acep_return[ , c(1:3, 9:13)]
  acep_svo_list <- list(acep_annotate_svo = acep_annotate[ , c(1:21)],
                        acep_pro_svo = acep_return[ , c(1:4, 8:13)],
                        acep_list_svo = acep_ret,
                        acep_sp = acep_sp,
                        no_procesadas = no_procesadas)
  return(acep_svo_list)
}
