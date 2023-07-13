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

  for (c in clave) {
    claveb <- paste0(c, "[[:graph:]]*", collapse = "|")
    capturar <- paste0("(", paste0(rep(nwi,izq), collapse = ""),
                       claveb, paste0(rep(nwd, der), collapse = ""), ")")

    for (o in seq_along(texto)) {
      oraciones <- unlist(strsplit(texto[o], "(?<=[a-z]\\.|\\?|\\!)\\s*(?=[A-Z]|\n[A-Z])", perl=T))

      for (i in seq_along(oraciones)) {
        vector <- unlist(regmatches(oraciones[i], gregexpr(capturar, oraciones[i])))

        for (v in seq_along(vector)) {
          claves <- unlist(regmatches(vector[v], gregexpr(claveb, vector[v])))
          lista <- sapply(seq_along(vector[v]), function(x) sub(claveb, paste0("\\| ", claves[x], " \\|"), vector[v][x]))
          contexto <- trimws(strsplit(lista, "|", fixed = TRUE)[[1]])
          lista_frases <- rbind(lista_frases, data.frame(doc_id = o, oraciones_id = i, texto = lista, w_izq = contexto[1], key = contexto[2], w_der = contexto[3]))
        }
      }
    }
  }

  return(lista_frases)

}
