#' @title Funcion para extraer triplets SVO (Sujeto-Verbo-Objeto).
#' @description Funcion que devuelve tres objetos data.frame con
#' etiquetado POS y relaciones sintacticas que permiten reconstruir
#' estructuras sintacticas como SVO y Sujeto-Predicado
#' @param texto vector con los textos a procesar.
#' @param prof_s profundidad de relaciones sintacticas para el sujeto.
#' @param prof_o profundidad de relaciones sintacticas para el objeto.
#' @param rel_s vector de etiquetas de relaciones sintacticas en el sujeto.
#' @param rel_o vector de etiquetas de relaciones sintacticas en el objeto.
#' @export acep_svo
#' @importFrom udpipe udpipe
#' @importFrom rsyntax as_tokenindex custom_fill tquery children annotate_tqueries
#' @importFrom dplyr filter group_by summarise ungroup
#' @importFrom stringr str_trim
#' @return Si todas las entradas son correctas,
#' la salida sera una lista con tres bases de datos en formato tabular.
#' @keywords sintaxis
#' @examples
#' texto <- "El SOIP para por aumento de salarios"
#' texto_svo <- acep_svo(texto)
#' texto_svo
#' @export
acep_svo <- function(texto, prof_s = 1, prof_o = 1,
                     rel_s = c('nsubj', 'conj'),
                     rel_o = c('obj','obl','nmod')){
  texto <- gsub("\\bal\\b|\\bdel\\b", 'el', texto)
  acep_udpipe <- udpipe::udpipe(texto, "spanish")
  acep_tokenindex <- rsyntax::as_tokenindex(acep_udpipe)
  fill <- rsyntax::custom_fill(relation = c('flat','fixed','compount'), connected=TRUE)
  direct <- rsyntax::tquery(
    label = 'verb', upos = 'VERB', fill = FALSE,
    rsyntax::children(label = 'subject', relation = rel_s, depth = prof_s, fill),
    rsyntax::children(label = 'object', relation = rel_o, depth = prof_o, fill))
  acep_annotate <- rsyntax::annotate_tqueries(acep_tokenindex, 'clause', direct, overwrite = T)
  acep_return <-  dplyr::filter(acep_annotate, !is.na(clause_fill)) |>
    dplyr::group_by(doc_id, paragraph_id, sentence, sentence_txt) |>
    dplyr::summarise(
      oracion = unique(sentence_txt),
      eventos = paste0(token, collapse = " -> "),
      sujeto = paste0(ifelse(clause == "subject", token, ""), collapse = " ") |> stringr::str_trim(),
      verbo = paste0(ifelse( clause == "verb", token, ""), collapse = " ") |> stringr::str_trim(),
      objeto = paste0(ifelse( clause == "object", token, ""), collapse = " ") |> stringr::str_trim(),
      predicado = paste(verbo, objeto, collapse = " ")
    ) |> dplyr::ungroup()
  acep_ret <- acep_return[ , c(1:3, 6)]
  acep_sp <- acep_return[ , c(1:3, 7:10)]
  acep_svo_list <- list(acep_annotate_svo = acep_annotate,
                        acep_list_svo = acep_ret,
                        acep_sp = acep_sp)
  return(acep_svo_list)
}
