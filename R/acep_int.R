#' @title Índice de intensidad.
#' @description Función que elabora un indice de intensidad en
#' base a la relación entre palabras totales y palabras del diccionario
#' presentes en el texto.
#' @param pc vector numérico con la frecuencia de palabras conflictivas
#' presentes en cada texto.
#' @param pt vector de palabras totales en cada texto.
#' @param decimales cantidad de decimales, por defecto tiene 4
#' pero se puede modificar.
#' @return Si todas las entradas son correctas,
#' la salida sera un vector numérico.
#' @keywords indicadores frecuencia tokens
#' @examples
#' conflictos <- c(1, 5, 0, 3, 7)
#' palabras <- c(4, 11, 12, 9, 34)
#' acep_int(conflictos, palabras, 3)
#' @export
acep_int <- function(pc, pt, decimales = 4) {
  if(!is.numeric(pc)){
    return(message(
      "No ingresaste un vector num\u00e9rico en el par\u00e1metro 'pc'.
      Vuelve a intentarlo ingresando un vector num\u00e9rico!"))
  }
  if(!is.numeric(pt)){
    return(message(
      "No ingresaste un vector num\u00e9rico en el par\u00e1metro' pt'.
      Vuelve a intentarlo ingresando un vector num\u00e9rico!"))
  } else {
    if(is.numeric(pc)) {
      tryCatch({
        if(is.numeric(pt)){
          round(pc / pt, decimales)
        }
      }
      )
    }
  }
}
