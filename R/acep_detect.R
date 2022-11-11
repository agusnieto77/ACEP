#' @title Deteccion de menciones de palabras.
#' @description Funcion que detecta de menciones de palabras que
#' refieren a conflictos en cada una de las notas/textos.
#' @param x vector de textos al que se le aplica la funcion de
#' deteccion de menciones de palabras del diccionario.
#' @param y vector de palabras del diccionario utilizado.
#' @param u umbral para atribuir valor positivo a la
#' deteccion de las menciones.
#' @param tolower convierte los textos a minusculas.
#' @keywords indicadores
#' @examples
#' df <- data.frame(texto = c("El SUTEBA fue al paro. Reclaman mejoras salariales.",
#' "El SOIP lleva adelante un plan de lucha con paros y piquetes."))
#' diccionario <- c("paro", "lucha", "piquetes")
#' df$detect <- acep_detect(df$texto, diccionario)
#' df
#' @export

acep_detect <- function(x, y, u = 1, tolower = TRUE) {
  if(is.vector(x) == TRUE  & is.list(x) != TRUE){
  out <- tryCatch({
    dicc  <- paste0(y, collapse = "|")
    if (tolower == TRUE) {
      detect <- vapply(gregexpr(dicc, tolower(x)),
                       function(z) sum(z != -1), c(frec = 0))
    } else {
      detect <- vapply(gregexpr(dicc, x),
                       function(z) sum(z != -1), c(frec = 0))
    }
    ifelse(detect >= u, 1, 0)
  }
  )
  return(out)
} else {
    message("No ingresaste un vector. Vuelve a intentarlo ingresando un vector!")
  }
}
