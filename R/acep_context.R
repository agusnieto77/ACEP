#' @title Función para extraer contexto de palabras o frases.
#' @description Función que devuelve un data.frame con el contexto
#' de una o más palabras o frases según una ventana de palabras hacia
#' las izquierda y otra ventana de palabras hacia la derecha.
#' @param texto vector con los textos a procesar.
#' @param clave vector de palabras clave a contextualizar.
#' @param izq número de palabras de la ventana hacia la izquierda.
#' @param der número de palabras de la ventana hacia la derecha.
#' @param ci expresión regular a la izquierda de la palabra clave.
#' @param cd expresión regular a la derecha de la palabra clave.
#' @return Si todas las entradas son correctas,
#' la salida sera un data frame con el id de los textos
#' procesado y el contexto de las palabras y/o frases entradas.
#' @keywords tokens contexto
#' @examples
#' texto <- "El SOIP para por aumento de salarios"
#' texto_context <- acep_context(texto = texto, clave = "para")
#' texto_context
#' @export
acep_context <- function(texto, clave, izq = 1, der = 1, ci = "\\b", cd = "\\S*"){
  texto <- gsub("\\|", "", texto)
  if (!is.character(texto)) {
    return(message(
      "No ingresaste un vector de texto en el par\u00e1metro 'texto'.
    Vuelve a intentarlo ingresando un vector de texto."))
  }
  if (!is.character(clave)) {
    return(message(
      "No ingresaste un vector de texto en el par\u00e1metro 'clave'.
    Vuelve a intentarlo ingresando un vector de texto."))
  }
  if (!is.character(ci)) {
    return(message(
      "No ingresaste un string en el par\u00e1metro 'ci'.
    Vuelve a intentarlo ingresando una ExpReg."))
  }
  if (!is.character(cd)) {
    return(message(
      "No ingresaste un string en el par\u00e1metro 'cd'.
    Vuelve a intentarlo ingresando una ExpReg."))
  }
  if (!is.numeric(izq)) {
    return(message(
      "No ingresaste un vector num\u00e9rico en el par\u00e1metro 'izq'.
    Vuelve a intentarlo ingresando un vector num\u00e9rico"))
  }
  if (!is.numeric(der)) {
    return(message(
      "No ingresaste un vector num\u00e9rico en el par\u00e1metro 'der'.
    Vuelve a intentarlo ingresando un vector num\u00e9rico."))
  } else {
    nwi <- "\\S*\\s*"
    nwd <- "\\s*\\S*"

    lista_frases <- c()

    for (c in clave) {
      claveb <- paste0(ci, c, cd, collapse = "|")
      capturar <- paste0(
        "(", paste0(rep(nwi,izq), collapse = ""),
        claveb, paste0(rep(nwd, der), collapse = ""), ")")

      for (o in seq_along(texto)) {
        oraciones <- unlist(
          strsplit(texto[o],
                   "(?<=[a-z]\\.|\\?|\\!)\\s*(?=[A-Z]|\n\\s[A-Z])",
                   perl=T))

        for (i in seq_along(oraciones)) {
          vector <- unlist(regmatches(oraciones[i],
                                      gregexpr(capturar,
                                               oraciones[i])))

          for (v in seq_along(vector)) {
            claves <- unlist(
              regmatches(vector[v], gregexpr(claveb, vector[v])))
            lista <- sapply(
              seq_along(vector[v]),
              function(x) sub(claveb,
                              paste0("\\| ",
                                     claves[x], " \\|"),
                              vector[v][x]))
            contexto <- trimws(strsplit(lista, "|",
                                        fixed = TRUE)[[1]])
            lista_frases <- rbind(
              lista_frases,
              data.frame(doc_id = o, oraciones_id = i,
                         texto = lista, w_izq = contexto[1],
                         key = contexto[2],
                         w_der = contexto[3]))
          }
        }
      }
    }

    return(lista_frases)
  }
}
