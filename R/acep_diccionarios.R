#' @title Coleccion de diccionarios.
#' @description Coleccion de diccionarios que reune diccionarios
#' de diferentes origenes. El diccionario dicc_confl_acep fueron construidos
#' en el marco del Observatorio de Conflictividad de la UNMdP.
#' Los diccionarios dicc_confl_gp y dicc_viol_gp fueron extraidos de
#' Albrieu y Palazzo (2020).
#' @format Es un objeto de clase 'list' con 3 componentes.
#'\describe{
#' \item{dicc_confl_gp}{es un  vector con palabras de un diciconario
#' de terminos que refeiren a conflictos}
#' \item{dicc_viol_gp}{es un  vector con palabras de un diciconario
#' de terminos que refeiren a violencia}
#' \item{dicc_confl_sismos}{es un  vector con palabras de un diciconario
#' de terminos que refeiren a conflictos}
#'}
#' @docType data
#' @usage data(acep_diccionarios)
#' @references Albrieu, Ramiro y Gabriel Palazzo 2020 «Categorizacion de
#' conflictos sociales en el ambito de los recursos naturales: un estudio
#' de las actividades extractivas mediante la mineria de textos».
#' Revista CEPAL (131):29-59.
#' (\href{https://observatoriodeconflictividad.org/RVE131_AP.pdf}{Revista CEPAL})
#' @references Laitano, Guillermina y Agustin Nieto
#' «Analisis computacional de la conflictividad laboral en Mar del Plata
#' durante el gobierno de Cambiemos». Ponencia presentado en VI Workshop -
#' Los conflictos laborales en la Argentina del siglo XX y XXI:
#' un abordaje interdisciplinario de conceptos, problemas y escalas de analisis,
#' Tandil, 2021.
#' @source \href{https://revistapuerto.com.ar/}{Revista Puerto}
#' @source \href{https://www.lanueva.com/}{La Nueva}
#' @keywords diccionarios
#' @examples
#' diccionario <- acep_load_base(acep_diccionarios$dicc_viol_gp)
#' diccionario
"acep_diccionarios"
