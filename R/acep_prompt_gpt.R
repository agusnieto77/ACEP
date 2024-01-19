#' @title Colección de instrucciones para GPT.
#' @description Colección de instrucciones para interactuar con los modelos
#' de OpenAI. Las instrucciones fueron testeadas en el marco de las tareas
#' que realizamos en el Observatorio de Conflictividad Social de la
#' Universidad Nacional de Mar del Plata.
#' @format Es un objeto de clase 'list' con 4 componentes.
#'\describe{
#' \item{instruccion_breve_sao_es}{es un texto en castellano con instrucciones breves para
#'  extraer eventos de protesta y codificarlos con las siguientes claves: 'fecha',
#'  'sujeto', 'accion', 'objeto', 'lugar'.}
#'  \item{instruccion_larga_sao_es}{es un texto en castellano con instrucciones largas para
#'  extraer eventos de protesta y codificarlos con las siguientes claves: 'id',
#'  'cronica', 'fecha', 'sujeto', 'organizacion', 'participacion', 'accion',
#'  'objeto', 'lugar'.}
#' \item{instruccion_breve_sao_en}{es un texto en inglés con instrucciones breves para
#'  extraer eventos de protesta y codificarlos con las siguientes claves: 'date',
#'  'subject', 'action', 'object', 'place'.}
#'  \item{instruccion_larga_sao_en}{es un texto en inglés con instrucciones largas para
#'  extraer eventos de protesta y codificarlos con las siguientes claves: 'id',
#'  'chronicle', 'date', 'subject', 'organization', 'participation', 'action',
#'  'object', 'place'.}
#'}
#' @docType data
#' @usage data(acep_prompt_gpt)
#' @keywords diccionarios
#' @examples
#' prompt01 <- acep_prompt_gpt$instrucciones_gpt
#' prompt01
"acep_prompt_gpt"
