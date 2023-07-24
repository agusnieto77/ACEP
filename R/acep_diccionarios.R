#' @title Colección de diccionarios.
#' @description Colección de diccionarios que reúne diccionarios
#' de diferentes orígenes. El diccionario dicc_confl_acep fueron construidos
#' en el marco del Observatorio de Conflictividad de la UNMdP.
#' Los diccionarios dicc_confl_gp y dicc_viol_gp fueron extraídos de
#' Albrieu y Palazzo (2020).
#' @format Es un objeto de clase 'list' con 3 componentes.
#'\describe{
#' \item{dicc_confl_gp}{es un vector con palabras de un diccionario
#' de términos que refieren a conflictos}
#' \item{dicc_viol_gp}{es un  vector con palabras de un diccionario
#' de términos que refieren a violencia}
#' \item{dicc_confl_sismos}{es un  vector con palabras de un diccionario
#' de términos que refieren a conflictos}
#'}
#' @docType data
#' @usage data(acep_diccionarios)
#' @references Albrieu, Ramiro y Gabriel Palazzo 2020 «Categorización de
#' conflictos sociales en el ámbito de los recursos naturales: un estudio
#' de las actividades extractivas mediante la minería de textos».
#' Revista CEPAL (131):29-59.
#' (\href{https://observatoriodeconflictividad.org/RVE131_AP.pdf}{Revista CEPAL})
#' @references Laitano, Guillermina y Agustín Nieto
#' «Análisis computacional de la conflictividad laboral en Mar del Plata
#' durante el gobierno de Cambiemos». Ponencia presentado en VI Workshop -
#' Los conflictos laborales en la Argentina del siglo XX y XXI:
#' un abordaje interdisciplinario de conceptos, problemas y escalas de análisis,
#' Tandil, 2021.
#' @source \href{https://revistapuerto.com.ar/}{Revista Puerto}
#' @source \href{https://www.lanueva.com/}{La Nueva}
#' @keywords diccionarios
#' @examples
#' diccionario <- acep_load_base(acep_diccionarios$dicc_viol_gp)
#' diccionario
"acep_diccionarios"
