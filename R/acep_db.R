#' @title Frecuencia, menciones e intensidad.
#' @description Función que usa las funciones acep_frec, acep_men y acep_int y
#' devuelve una tabla con tres columnas nuevas: numero de palabras,
#' número de menciones del diccionario, indice de intensidad.
#' @param db data frame con los textos a procesar.
#' @param t columna de data frame que contiene el vector
#' de textos a procesar.
#' @param d diccionario en formato vector.
#' @param n cantidad de decimales del indice de intensidad.
#' @return Si todas las entradas son correctas, la salida sera una
#' base de datos en formato tabular con tres nuevas variables.
#' @keywords indicadores frecuencia tokens
#' @examples
#' df <- data.frame(texto = c("El SUTEBA fue al paro. Reclaman mejoras salariales.",
#' "El SOIP lleva adelante un plan de lucha con paros y piquetes."))
#' diccionario <- c("paro", "lucha", "piquetes")
#' acep_db(df, df$texto, diccionario, 4)
#' @export
acep_db <- function(db, t, d, n) {
  if(!is.data.frame(db)){
    return(message("No ingresaste un marco de datos en el par\u00e1metro 'db'.
    Vuelve a intentarlo ingresando un marco de datos!"))
  }
  if(!is.character(t) | is.list(t)){
    return(message("No ingresaste un vector en el par\u00e1metro 't'.
    Vuelve a intentarlo ingresando un vector!"))
  }
  if(!is.character(d) | is.list(d)){
    return(message("No ingresaste un vector en el par\u00e1metro 'd'.
    Vuelve a intentarlo ingresando un vector!"))
  }
  if(!is.numeric(n)){
    return(message(
      "No ingresaste un n\u00famero entero positivo en el par\u00e1metro 'n'.
      Vuelve a intentarlo ingresando un vector!"))
  } else {
      tryCatch({
        if(is.data.frame(db)){
        #db <- db
        db$n_palabras <- acep_frec(t)
        db$conflictos <- acep_men(t, d)
        db$intensidad <- acep_int(db$conflictos, db$n_palabras, n)
        }
      }
      )
    return(db)
  }
}
