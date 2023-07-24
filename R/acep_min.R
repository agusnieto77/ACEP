#' @title Convierte caracteres a minúsculas
#' @description Esta función toma un vector de texto y convierte todas las letras
#' mayusculas en minúsculas, manteniendo el resto de los caracteres sin cambios.
#' @param x Un vector de texto (caracteres) que se desea convertir a minúsculas.
#' @return Devuelve un nuevo vector con todas las letras en minúsculas.
#' @examples
#' vector_texto <- c("SUTEBA", "Sindicato", "PEN")
#' acep_min(vector_texto)
#' vector_numeros <- c(1, 2, 3, 4, 5)
#' acep_min(vector_numeros)
#' vector_mezclado <- c("Soip", 123, "CGT")
#' acep_min(vector_mezclado)
#' @keywords caracteres, texto
#' @export
acep_min <- function(x) {
  if (is.character(x)) {
    f_minusculas <- function(t) {
      codigo_utf8 <- utf8ToInt(t)
      mayusculas <- codigo_utf8 >= 65 & codigo_utf8 <= 90
      codigo_utf8[mayusculas] <- codigo_utf8[mayusculas] + 32
      minusculas <- intToUtf8(codigo_utf8)
      return(minusculas)
    }
    t_minusculas <- vapply(x, f_minusculas, character(1))
    names(t_minusculas) <- NULL
    return(t_minusculas)
  } else {
    return(
    message("No ingresaste un vector de texto.
            Vuelve a intentarlo ingresando un vector de texto.")
    )
  }
}
