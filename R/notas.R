#' @title Colección de notas de la Revista Puerto.
#' @description Función que carga más de 8000 notas sobre cuestiones pesqueras para el período 2009-2021.
#' @examples
#' notas
#'
#'
#'

notas <- readRDS("./R/data/notas_rev_puerto.rds")

notas <- notas[!duplicated(notas[,c('link')]),]

notas$fecha <- as.Date(notas$fecha, format = '%d/%m/%Y')
