#' @title Funcion para extraer triplets SVO (Sujeto-Verbo-Objeto).
#' @description
#' Funcion que devuelve seis objetos data.frame con
#' etiquetado POS (modelo spacyr) y relaciones sintacticas
#' (modelo rsyntax) que permiten reconstruir estructuras
#' sintacticas como SVO y Sujeto-Predicado. Una vez seleccionadas
#' las notas periodisticas referidas a conflictos, esta funcion permite
#' extraer sujetos de la protesta, accion realizada y objeto(s) de la accion.
#' Tambien devuelve entidades nombradas (NER).
#' @param acep_tokenindex data.frame con el etiquetado POS y las relaciones
#' de dependencia generado con la funcion acep_postag.
#' @param prof_s es un numero entero positivo que determina la profundidad a la que se
#' buscan las relaciones dentro del sujeto. Este parametro se hereda del la funcion children()
#' del paquete {rsyntax}. Se recomienda no superar el valor 2.
#' @param prof_o es un numero entero positivo que determina la profundidad a la que se
#' buscan las relaciones dentro del objeto. Este parametro se hereda del la funcion children()
#' del paquete {rsyntax}. Se recomienda no superar el valor 2.
#' @param relaciones vector con las etiquetas de relaciones que se usaran en la funcion de relleno.
#' Este parametro se hereda de la funcion custom_fill() del paquete {rsyntax}.
#' @param conexiones es un parametro heredado del paquete {rsyntax} que controla
#' el comportamiento si la profundidad es > 1 y se utilizan filtros.
#' Si es FALSE, se recuperan todos los padres/hijos hasta la profundidad dada, y luego se filtran.
#' De esta manera, los nietos que satisfacen las condiciones del filtro se recuperan incluso si
#' sus padres no satisfacen las condiciones. Si es TRUE, el filtro se aplica en cada nivel de
#' profundidad, de modo que solo se recuperan las ramas totalmente conectadas de los nodos que
#' satisfacen las condiciones. Este parametro se hereda de la funcion custom_fill() del paquete {rsyntax}.
#' @param rel_s vector de etiquetas de relaciones sintacticas en el sujeto.
#' Este parametro se hereda del la funcion children() del paquete {rsyntax}.
#' @param rel_o vector de etiquetas de relaciones sintacticas en el objeto.
#' Este parametro se hereda del la funcion children() del paquete {rsyntax}.
#' @param rel_evs etiqueta de relaciones a ser agregada en la reconstruccion del sujeto.
#' @param rel_evp etiqueta de relaciones a ser agregada en la reconstruccion del predicado.
#' @param u numero entero que indica el umbral de palabras del objeto en la reconstruccion SVO.
#' @param idioma del modelo udpipe.
#' @export acep_svo
#' @importFrom stats na.omit
#' @importFrom rsyntax as_tokenindex custom_fill tquery children annotate_tqueries
#' @importFrom dplyr filter mutate group_by summarise ungroup rename distinct select left_join case_when arrange desc count
#' @importFrom stringr str_trim str_replace_all str_detect
#' @importFrom tidyr separate
#' @importFrom udpipe udpipe
#' @return Si todas las entradas son correctas, la salida sera una lista con tres bases de datos en formato tabular.
#' @references Welbers, K., Atteveldt, W. van, & Kleinnijenhuis, J. 2021. Extracting semantic relations using syntax: An R package for querying and reshaping dependency trees. Computational Communication Research, 3-2, 1-16.
#' \href{https://www.aup-online.com/content/journals/10.5117/CCR2021.2.003.WELB?TRACK}{(link al articulo)}
#' @source \href{https://universaldependencies.org/}{Dependencias Universales para taggeo POS}
#' @source \href{https://cran.r-project.org/web/packages/rsyntax/rsyntax.pdf}{Sobre el paquete rsyntax}
#' @keywords sintaxis
#' @examples
#'\dontrun{
#' acep_svo(acep_bases$spacy_postag)
#'}
#' @export
acep_svo <- function(acep_tokenindex,
                     prof_s = 2,
                     prof_o = 2,
                     relaciones = c("flat","fixed","appos"),
                     conexiones = FALSE,
                     rel_s = c("nsubj", "conj", "nmod"),
                     rel_o = c("obj","obl","amod"),
                     rel_evs = "nsubj",
                     rel_evp = "obj",
                     u = 1,
                     idioma = "spanish"
){

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

  acep_annotate <- acep_annotate |> dplyr::group_by(doc_id, sentence) |>
    dplyr::mutate(s_p = ifelse(token_id < token_id[which(s_v_o == "verbo")][1], "sujeto", "predicado")) |>
    dplyr::ungroup()

  acep_annotate_verbos <- unique(acep_annotate[ , c("token")]$token)
  acep_annotate_verbos <- udpipe::udpipe(x = acep_annotate_verbos, object = idioma)[ , c("sentence", "feats")]
  names(acep_annotate_verbos) <- c("token", "morph")

  acep_annotate <- acep_annotate |> dplyr::left_join(acep_annotate_verbos, by = "token")

  acep_annotate <- acep_annotate |>
    dplyr::mutate(conjugaciones = dplyr::case_when(
      stringr::str_detect(morph, "Past") ~ "pasado",
      stringr::str_detect(morph, "Pres") ~ "presente",
      stringr::str_detect(morph, "Fut") ~ "futuro"
    ))

  acep_annotate <- acep_annotate |> dplyr::group_by(doc_id, sentence) |>
    dplyr::mutate(sent_ = paste(token, collapse = " ")) |> dplyr::ungroup()

  acep_annotate_o <- acep_annotate
  acep_annotate$relation <- gsub(":pass", "", acep_annotate$relation)
  no_procesadas <- acep_annotate |> dplyr::filter(is.na(s_p)) |>
    dplyr::distinct(doc_id, sentence, sent_) |>
    dplyr::rename(oracion_id = sentence,
                  oracion = sent_)
  sust_pred <- acep_annotate |>
    dplyr::group_by(doc_id, sentence, sent_) |>
    dplyr::summarise(
      sust_pred = paste0(ifelse(s_p == "predicado" & pos == "PROPN" | s_p == "predicado" & pos == "NOUN", token, ""), collapse = "|"),
      .groups = "drop"
    ) |>
    dplyr::mutate(sust_pred = stringr::str_replace_all(sust_pred, "  ", " ")) |>
    dplyr::mutate(sust_pred = stringr::str_replace_all(sust_pred, "\\|+", "|")) |>
    dplyr::mutate(sust_pred = stringr::str_replace_all(sust_pred, "\\|", " | ")) |>
    dplyr::mutate(sust_pred = stringr::str_replace_all(sust_pred, "^ \\|", "|")) |>
    dplyr::mutate(sust_pred = stringr::str_replace_all(sust_pred, "\\| $", "|")) |>
    dplyr::select(sent_, sust_pred)
  acep_return <-  dplyr::filter(acep_annotate, !is.na(s_v_o_fill))
  acep_return <- acep_return |> dplyr::filter(pos != "ADP")
  acep_return <- acep_return |>
    dplyr::group_by(doc_id, sentence, sent_) |>
    dplyr::summarise(
      sent_ = unique(sent_),
      sujetos = paste0(ifelse(s_p == "sujeto" & relation == "nsubj" | s_p == "sujeto" & relation == rel_evs, token, ""), collapse = " "),
      verbos = paste0(ifelse(relation == "ROOT" , token, ""), collapse = " "),
      predicados = paste0(stats::na.omit(ifelse(relation == "obj" | relation == rel_evp, token, NA))[1:u], collapse = " "),
      eventos = paste0(sujetos, " -> ", verbos, " -> ", predicados),
      sujeto = paste0(ifelse(s_p == "sujeto" & s_v_o == "sujeto", token, ""), collapse = " ") |> stringr::str_trim(),
      predicado = paste0(ifelse(s_p == "predicado", token, ""), collapse = " ") |> stringr::str_trim(),
      verbo = paste0(ifelse(relation == "ROOT", token, ""), collapse = " ") |> stringr::str_trim(),
      lemma_verb = paste0(ifelse(relation == "ROOT", lemma, ""), collapse = " ") |> stringr::str_trim(),
      conjugaciones = paste0(ifelse(s_v_o == "verbo", conjugaciones, ""), collapse = " ") |> stringr::str_trim(),
      aux_verbos = paste0(ifelse(pos == "VERB" , token, ""), collapse = " ") |> stringr::str_trim(),
      entidades = paste0(ifelse(pos == "PROPN" , token, ""), collapse = " ") |> stringr::str_trim(),
      .groups = "drop"
    )
  acep_return$entidades <- gsub("\\s[a-z]+\\s+", "  ", acep_return$entidades)
  acep_return$entidades <- gsub("\\s\\s+", "  ", acep_return$entidades)
  acep_return$entidades <- gsub("\\s\\s+", " | ", acep_return$entidades)
  acep_return$entidades <- gsub("(\\b[A-Z]+\\b)", "| \\1 |", acep_return$entidades)
  acep_return$entidades <- gsub("\\| \\|", "|", acep_return$entidades)
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
  acep_return <- acep_return |> dplyr::left_join(sust_pred, by = "sent_")
  acep_return <- acep_return |> dplyr::rename(oracion_id = sentence,
                                              oracion = sent_)
  acep_ret <- acep_return[ , c(1:2, 7)] |>
    tidyr::separate(eventos, c("sujeto", "verbo", "objeto"), sep = " -> ", remove = FALSE)
  acep_sp <- acep_return[ , c(1:2, 8:15)]
  acep_lista_lemmas <- acep_annotate_o |> dplyr::filter(nchar(token) > 1) |>
    dplyr::filter(pos != "NUM", pos != "PUNCT", pos != "X", pos != "DET",
                  pos != "ADP", pos != "ADV", pos != "CCONJ", pos != "INTJ",
                  pos != "PRON", pos != "SCONJ", pos != "SYM") |>
    dplyr::count(token, lemma) |> dplyr::arrange(dplyr::desc(n))
  acep_svo_list <- list(acep_annotate_svo = acep_annotate_o[ , c(1:25)],
                        acep_pro_svo = acep_return[ , c(1:2, 7:15)] |>
                          tidyr::separate(eventos, c("sujeto_svo", "root", "objeto"),
                                          sep = " -> ", remove = FALSE),
                        acep_list_svo = acep_ret,
                        acep_sp = acep_sp,
                        acep_lista_lemmas = acep_lista_lemmas,
                        acep_no_procesadas = no_procesadas)
  return(acep_svo_list)
}
