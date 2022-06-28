#' @title Colección de diccionarios.
#' @description Función que carga un set de diccionarios de diferentes orígenes.
#' El diccionario de palabras que refieren a conflictos llamado dicc_conflictos
#' fue extraído de Palazzo (2017).
#' @examples
#' diccionarios
#'

dicc_conflictos <- strsplit(readLines("./R/dicc/dicc_conflictos.txt"),
                            split = ', ', fixed=T)[[1]]

dicc_violencia <- strsplit(readChar("./R/dicc/dicc_violencia.txt",
                                    file.info("./R/dicc/dicc_violencia.txt")[1]),
                           split = ', ', fixed=T)[[1]]
