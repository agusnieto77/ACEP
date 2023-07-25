#' @title Colección de notas.
#' @description Contiene colecciones de notas de distintos
#' portales noticiosos (una muestra corta).
#' Una segunda colección es de notas del periódico bahiense La Nueva.
#' También tiene resúmenes estadísticos de las bases completas
#' para el desarrollo de los ejemplos de las funciones.
#' @format Es una lista con 8 objetos.
#'\describe{
#' \item{la_nueva}{es una url para la descarga de una muestra del
#' corpus de notas de La Nueva Provincia de Bahía Blanca}
#' \item{rev_puerto}{es una url para la descarga del corpus de notas
#' de la Revista Puerto}
#' \item{rp_procesada}{es un data frame con indicadores de
#' conflictividad basados en los datos de la Revista Puerto}
#' \item{lc_mdp}{es una url para la descarga del corpus
#' de notas de La Capital}
#' \item{rp_mdp}{es una url para la descarga del corpus de notas
#' de la Revista Puerto}
#' \item{ed_neco}{es una url para la descarga del corpus de notas
#' de Ecos Diarios}
#' \item{ln_bb}{es una url para la descarga del corpus de
#' notas de La Nueva}
#' \item{ln_arg}{es una url para la descarga del corpus de
#' notas de La Nación}
#' \item{spacy_postag}{es un data.frame con una oración procesada con spacyr}
#' \item{titulares}{es un vector con titulares de notas referidas a conflictos sociales}
#'}
#' @docType data
#' @usage data(acep_bases)
#' @references Nieto, Agustín 2020 «Intersecciones entre historia digital e
#' historia social: un ejercicio de lectura distante sobre la
#' conflictividad marítima en la historia argentina reciente».
#' Drassana: revista del Museu Maritim (28):122-42.
#' (\href{https://observatoriodeconflictividad.org/nietohd.pdf}{Revista Drassana})
#' @source \href{https://revistapuerto.com.ar/}{Revista Puerto}
#' @source \href{https://www.lanueva.com/}{La Nueva}
#' @keywords datos
#' @examples
#' acep_bases$rp_procesada[1:6, ]
"acep_bases"
