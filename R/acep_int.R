#' @title Indice de intensidad.
#' @description Funcion que elabora un indice de intensidad en
#' base a la relacion entre palabras totales y palabras del diccionario
#' presentes en el texto.
#' @param pc vector numerico con la frecuencia de palabras conflictivas
#' presentes en cada texto.
#' @param pt vector de palabras totales en cada texto.
#' @param decimales cantidad de decimales, por defecto tiene 4
#' pero se puede modificar.
#' @export acep_int
#' @return Si todas las entradas son correctas,
#' la salida sera un vector numerico.
#' @keywords indicadores
#' @examples
#' conflictos <- c(1, 5, 0, 3, 7)
#' palabras <- c(4, 11, 12, 9, 34)
#' acep_int(conflictos, palabras, 3)
#' @export
acep_int <- function(pc, pt, decimales = 4) {
  if(is.numeric(pc) != TRUE){
    mensaje <- "No ingresaste un vector numerico en el parametro pc. Vuelve a intentarlo ingresando un vector numerico!"
    return(message(mensaje))
  }
  if(is.numeric(pt) != TRUE){
    mensaje <- "No ingresaste un vector numerico en el parametro pc. Vuelve a intentarlo ingresando un vector numerico!"
    return(message(mensaje))
  } else {
    if(is.numeric(pc) == TRUE) {
      tryCatch({
        if(is.numeric(pt) == TRUE){
          round(pc / pt, decimales)
        }
      }
      )
    }
  }
}
