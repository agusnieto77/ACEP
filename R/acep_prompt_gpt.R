#' @title Colección de instrucciones para GPT.
#' @description Colección de instrucciones para interactuar con los modelos
#' de OpenAI. Las instrucciones fueron testeadas en el marco de las tareas
#' que realizamos en el Observatorio de Conflictividad Social de la
#' Universidad Nacional de Mar del Plata.
#' @format Es un objeto de clase 'list' con 1 componente.
#'\describe{
#' \item{dicc_confl_gp}{es un texto con instrucciones para que el modelo
#'  gpt-3 turbo de OpenAI devuelva una codificación de eventos de protesta.}
#'}
#' @docType data
#' @usage data(acep_prompt_gpt)
#' @keywords diccionarios
#' @examples
#' prompt01 <- acep_prompt_gpt$instrucciones_gpt
#' prompt01
"acep_prompt_gpt"
