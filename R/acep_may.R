#' @title Convierte caracteres a mayusculas.
#' @description Esta función toma un vector de texto y convierte todas las letras
#' minúsculas en mayúsculas, manteniendo el resto de los caracteres sin cambios.
#' @param x es un vector de texto (caracteres) que se desea convertir a mayúsculas.
#' @return Devuelve un nuevo vector con todas las letras en mayúsculas.
#' @examples
#' vector_texto <- c("soip", "cGt", "Sutna")
#' acep_may(vector_texto)
#' vector_numeros <- c(1, 2, 3, 4, 5)
#' acep_may(vector_numeros)
#' vector_mezclado <- c("sutna", 123, "Ate")
#' acep_may(vector_mezclado)
#' @keywords caracteres texto
#' @export
acep_may <- function(x) {
  if (is.character(x)) {
    f_mayusculas <- function(t) {
      codigo_utf8 <- utf8ToInt(t)
      minusculas <- codigo_utf8 >= 97 & codigo_utf8 <= 122
      codigo_utf8[minusculas] <- codigo_utf8[minusculas] - 32
      mayusculas <- intToUtf8(codigo_utf8)
      return(mayusculas)
    }
    t_mayusculas <- vapply(x, f_mayusculas, character(1))
    names(t_mayusculas) <- NULL
    return(t_mayusculas)
  } else {
    return(
    message("No ingresaste un vector de texto.
            Vuelve a intentarlo ingresando un vector de texto.")
    )
  }
}
