#' @title Funcion para extraer triplets SVO (Sujeto-Verbo-Objeto).
#' @description Funcion que devuelve cinco objetos data.frame con
#' etiquetado POS (modelo udpipe) y relaciones sintacticas
#' (modelo rsyntax) que permiten reconstruir estructuras
#' sintacticas como SVO y Sujeto-Predicado. Una vez seleccionadas
#' las notas periodisticas referidas a conflictos, esta función permite
#' extraer sujetos de la protesta, acción realizada y objeto(s) de la acción.
#' @param texto vector con los textos a procesar.
#' @param modelo idioma del modelo de etiquetado POS del paquete {udpipe}.
#' @param prof_s profundidad de relaciones sintacticas para el sujeto.
#' @param prof_o profundidad de relaciones sintacticas para el objeto.
#' @param relaciones vector con las relaciones de analisis sintactico del paquete {rsyntax}.
#' @param conexiones es un parámetro heredado del paquete {rsyntax} que controla
#' el comportamiento si la profundidad es > 1 y se utilizan filtros.
#' Si es FALSE, se recuperan todos los padres/hijos hasta la profundidad dada, y luego se filtran.
#' De esta manera, los nietos que satisfacen las condiciones del filtro se recuperan incluso si
#' sus padres no satisfacen las condiciones. Si es TRUE, el filtro se aplica en cada nivel de
#' profundidad, de modo que sólo se recuperan las ramas totalmente conectadas de los nodos que
#' satisfacen las condiciones.
#' @param rel_s vector de etiquetas de relaciones sintacticas en el sujeto.
#' @param rel_o vector de etiquetas de relaciones sintacticas en el objeto.
#' @param rel_evs etiqueta de relaciones a ser agregada en la reconstruccion del sujeto.
#' @param rel_evp etiqueta de relaciones a ser agregada en la reconstruccion del objeto.
#' @param u numero entero que indica el umbral de palabras del objeto en la reconstruccion SVO.
#' @export acep_svo
#' @importFrom stats na.omit
#' @importFrom udpipe udpipe
#' @importFrom rsyntax as_tokenindex custom_fill tquery children annotate_tqueries
#' @importFrom dplyr filter mutate group_by summarise ungroup rename distinct select left_join case_when
#' @importFrom stringr str_trim str_replace_all str_detect
#' @importFrom tidyr separate
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
    label = "verbo", upos = "VERB", fill = FALSE,
    rsyntax::children(label = "sujeto", relation = rel_s, depth = prof_s, fill),
    rsyntax::children(label = "objeto", relation = rel_o, depth = prof_o, fill))
  indirect <- rsyntax::tquery(
    label = "verbo", upos = "VERB", fill = FALSE,
    rsyntax::children(label = "sujeto", relation = "nsubj:pass", depth = prof_s, fill),
    rsyntax::children(label = "objeto", relation = rel_o, depth = prof_o, fill))
  acep_annotate <- rsyntax::annotate_tqueries(acep_tokenindex, "s_v_o", direct, indirect, overwrite = FALSE)
  acep_annotate <- acep_annotate |> dplyr::group_by(doc_id, paragraph_id, sentence, sentence_txt) |>
    dplyr::mutate(s_p = ifelse(token_id < token_id[which(s_v_o == "verbo")][1], "sujeto", "predicado")) |>
    dplyr::ungroup()
  acep_annotate$doc_id  <- gsub("doc", "", acep_annotate$doc_id)
  acep_annotate$doc_id  <- as.integer(acep_annotate$doc_id)
  acep_annotate <- acep_annotate |>
    dplyr::mutate(conjugaciones = dplyr::case_when(
    stringr::str_detect(feats, "Past") ~ "pasado",
    stringr::str_detect(feats, "Pres") ~ "presente",
    stringr::str_detect(feats, "Fut") ~ "futuro"
    ))
  acep_annotate_o <- acep_annotate
  acep_annotate$relation <- gsub(":pass", "", acep_annotate$relation)
  no_procesadas <- acep_annotate |> dplyr::filter(is.na(s_p)) |>
    dplyr::distinct(doc_id, paragraph_id, sentence, sentence_txt, sentence_txt) |>
    dplyr::rename(parrafo_id = paragraph_id,
                  oracion_id = sentence,
                  oracion = sentence_txt)
  sust_pred <- acep_annotate |>
    dplyr::group_by(doc_id, paragraph_id, sentence, sentence_txt) |>
    dplyr::summarise(
      sust_pred = paste0(ifelse(s_p == "predicado" & upos == "PROPN" | s_p == "predicado" & upos == "NOUN", token, ""), collapse = "|"),
      .groups = "drop"
    ) |>
    dplyr::mutate(sust_pred = stringr::str_replace_all(sust_pred, "  ", " ")) |>
    dplyr::mutate(sust_pred = stringr::str_replace_all(sust_pred, "\\|+", "|")) |>
    dplyr::mutate(sust_pred = stringr::str_replace_all(sust_pred, "\\|", " | ")) |>
    dplyr::mutate(sust_pred = stringr::str_replace_all(sust_pred, "^ \\|", "|")) |>
    dplyr::mutate(sust_pred = stringr::str_replace_all(sust_pred, "\\| $", "|")) |>
    dplyr::select(sentence_txt, sust_pred)
  acep_return <-  dplyr::filter(acep_annotate, !is.na(s_v_o_fill))
  acep_return <- acep_return |> dplyr::filter(upos != "ADP")
  acep_return <- acep_return |>
    dplyr::group_by(doc_id, paragraph_id, sentence, sentence_txt) |>
    dplyr::summarise(
      sentence_txt = unique(sentence_txt),
      sujetos = paste0(ifelse(s_p == "sujeto" & relation == "nsubj" | relation == rel_evs, token, ""), collapse = " "),
      verbos = paste0(ifelse(relation == "ROOT" , token, ""), collapse = " "),
      predicados = stats::na.omit(ifelse(relation == "obj" | relation == rel_evp, token, NA))[u],
      eventos = paste0(sujetos, " -> ", verbos, " -> ", predicados),
      sujeto = paste0(ifelse(s_p == "sujeto" & s_v_o == "sujeto", token, ""), collapse = " ") |> stringr::str_trim(),
      predicado = paste0(ifelse(s_p == "predicado", token, ""), collapse = " ") |> stringr::str_trim(),
      verbo = paste0(ifelse(relation == "ROOT", token, ""), collapse = " ") |> stringr::str_trim(),
      lemma_verb = paste0(ifelse(relation == "ROOT", lemma, ""), collapse = " ") |> stringr::str_trim(),
      conjugaciones = paste0(ifelse(s_v_o == "verbo", conjugaciones, ""), collapse = " ") |> stringr::str_trim(),
      .groups = "drop"
    )
  acep_return$conjugaciones <- gsub("(^[a-zA-Z]+)\\s.+", "\\1", acep_return$conjugaciones)
  acep_return$eventos <- gsub("\\s+", " ", acep_return$eventos)
  acep_return$eventos <- gsub(" -> $", "", acep_return$eventos)
  acep_return$eventos <- gsub("^\\s*", "", acep_return$eventos)
  acep_return$eventos <- gsub("*\\s$", "", acep_return$eventos)
  acep_return <- acep_return |> dplyr::left_join(sust_pred, by = "sentence_txt")
  acep_return <- acep_return |> dplyr::rename(parrafo_id = paragraph_id,
                                              oracion_id = sentence,
                                              oracion = sentence_txt)
  acep_ret <- acep_return[ , c(1:3, 8)] |>
    tidyr::separate(eventos, c("sujeto", "verbo", "objeto"), sep = " -> ", remove = FALSE)
  acep_sp <- acep_return[ , c(1:3, 9:14)]
  acep_svo_list <- list(acep_annotate_svo = acep_annotate_o[ , c(1:22)],
                        acep_pro_svo = acep_return[ , c(1:4, 8:14)],
                        acep_list_svo = acep_ret,
                        acep_sp = acep_sp,
                        no_procesadas = no_procesadas)
  return(acep_svo_list)
}
