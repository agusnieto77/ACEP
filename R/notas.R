#' @title Colección de notas de la Revista Puerto.
#' @description Función que carga más de 8000 notas sobre cuestiones pesqueras para el período 2009-2021.
#' @examples
#' notas
#'
#'
#'
require(magrittr)
require(lubridate)
require(dplyr)

notas <- readRDS(url("https://estudiosmaritimossociales.org/modulo_3/notas_rev_puerto.rds","rb")) %>% mutate(fecha = dmy(fecha)) %>% distinct(link, .keep_all = TRUE)
