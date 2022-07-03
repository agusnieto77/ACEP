#' @title Colección de notas.
#' @description Contiene colecciones de notas de distintos portales noticiosos. Una colección es de notas de la Revista Puerto de Mar del Plata, Argentina. Es una base de datos en formato tabular con 7816 observaciones y 6 variables: fecha, titulo, bajada, nota, imagen, link.
#' Una segunda colección es de notas del periódico bahiense La Nueva. Es una base de datos en formato tabular con 3889 observaciones y 7 variables: fecha, seccion, titulo, bajada, nota, link, img_link.
#' @docType data
#' @usage data(acep_bases)
#' @references Nieto, Agustín 2020 «Intersecciones entre historia digital e historia social: un ejercicio de lectura distante sobre la conflictividad marítima en la historia argentina reciente». Drassana: revista del Museu Maritim (28):122-42.
#' (\href{https://revistadrassana.cat/index.php/Drassana/article/view/650/765}{Revista Drassana})
#' @source \href{https://revistapuerto.com.ar/}{Revista Puerto}
#' @source \href{https://www.lanueva.com/}{La Nueva}
#' @examples
#' rev_puerto <- acep_bases$rev_puerto
#' head_la_nueva <- head(acep_bases$la_nueva, 50)
#' \donttest{acep_bases$rev_puerto |> dplyr::select(fecha,titulo) |> head()}
"acep_bases"
