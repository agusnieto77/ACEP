#' @title Colección de diccionarios.
#' @description Función que carga un set de diccionarios de diferentes orígenes.
#' Los diccionarios de palabras que refieren a conflictos y a violencia llamados
#' dicc_conflictos y dicc_violencia fueron extraídos de Albrieu y Palazzo (2020).
#' @examples
#' dicc_conflictos <- diccionarios$dicc_conflictos
#' dicc_violencia <-diccionarios$dicc_violencia
#' @references
#' Albrieu, Ramiro, y Gabriel Palazzo. 2020. «Categorización de conflictos sociales en el ámbito de los recursos naturales: un estudio de las actividades extractivas mediante la minería de textos». Revista CEPAL (131):29-59.


diccionarios <- list(
  dicc_conflictos = strsplit(readLines("./R/dicc/dicc_conflictos.txt"),
                             split = ', ', fixed=T)[[1]],
  dicc_violencia = strsplit(readChar("./R/dicc/dicc_violencia.txt",
                                     file.info("./R/dicc/dicc_violencia.txt")[1]),
                            split = ', ', fixed=T)[[1]]
  )
