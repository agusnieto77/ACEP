#' @title Funcion para extraer contexto de palabras o frases.
#' @description Funcion que devuelve un data.frame con el contexto
#' de una o más palabras o frases según una ventana de palabras hacia
#' las izquierda y otra ventana de palabras hacia la derecha.
#' @param texto vector con los textos a procesar.
#' @param clave vector de palabras clave a contextualizar.
#' @param izq numero de palabras de la ventana hacia la izquierda.
#' @param der numero de palabras de la ventana hacia la derecha.
#' @export acep_context
#' @return Si todas las entradas son correctas,
#' la salida sera un data frame con el id de los textos
#' procesado y el contexto de las palabras y/o frases entradas.
#' @keywords contexto
#' @examples
#' texto <- "El SOIP para por aumento de salarios"
#' texto_context <- acep_context(texto = texto, clave = "para")
#' texto_context
#' @export
acep_context <- function(texto, clave, izq = 1, der = 1){
  nwi <- "[[:graph:]]*[[:space:]]*"
  nwd <- "[[:space:]]*[[:graph:]]*"
  lista_frases <- c()
  doc_id <- c()
  for (c in clave) {
    claveb <- paste0(c, "[[:graph:]]*", collapse = "|")
    capturar <- paste0("(", paste0(rep(nwi,izq), collapse = ""),
                       claveb, paste0(rep(nwd, der), collapse = ""), ")")
    for (i in seq_along(texto)) {
      lista <- unlist(regmatches(texto[i], gregexpr(capturar, texto[i])))
      doc_id <- append(doc_id, rep(i, length(lista)))
      claves <- sub(paste0(".* (", claveb, ").*"), "\\1", texto[i])
      lista <- gsub(claveb, paste0("\\| ", claves, " \\|"), lista)
      lista_frases <- append(lista_frases, lista)
    }
  }
  lista_frases <- data.frame(doc_id = doc_id, contexto = lista_frases)
  return(lista_frases)
}
