#' @title Colección de diccionarios.
#' @description Colección de diccionarios que reúne diccionarios
#' de diferentes orígenes. El diccionario dicc_confl_sismos fue construido
#' en el marco del Observatorio de Conflictividad de la UNMdP.
#' Los diccionarios dicc_confl_gp y dicc_viol_gp fueron extraídos de
#' Albrieu y Palazzo (2020).
#' @format Es un objeto de clase 'list' con 3 componentes. Cada componente es
#' una cadena de caracteres de longitud 1 con la URL de un diccionario `.rds`
#' descargable; usá \code{\link{acep_load_base}} para obtener el vector de
#' palabras correspondiente.
#'\describe{
#' \item{dicc_confl_gp}{URL al diccionario de términos que refieren a conflictos}
#' \item{dicc_viol_gp}{URL al diccionario de términos que refieren a violencia}
#' \item{dicc_confl_sismos}{URL al diccionario de términos que refieren a conflictos}
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
#' \dontrun{
#' diccionario <- acep_load_base(acep_diccionarios$dicc_viol_gp)
#' diccionario
#' }
"acep_diccionarios"
