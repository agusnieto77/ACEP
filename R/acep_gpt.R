#' @title Funcion para interactuar con los modelos  de OpenAI.
#' @description Funcion para interactuar con los modelos de OpenAI
#' desde las claves API secretas y pagas.
#' @param texto texto a procesar.
#' @param instrucciones indicaciones de contexto que se le
#' proporcionan al modelo de lenguaje GPT para influir en
#' su generación de texto.
#' @param gpt_api clave API secreta.
#' @param url ruta de API utilizada para enviar solicitudes de
#' generación de texto basadas en el modelo de lenguaje GPT de OpenAI.
#' @param modelo modelo de lenguaje GPT de OpenAI.
#' @param rol le asigna al modelo una perspectiva específica o
#' un punto de vista particular al generar texto.
#' @export acep_gpt
#' @importFrom httr POST add_headers content_type_json content
#' @return Si todas las entradas son correctas,
#' la salida sera una cadena de caracteres con la
#' información solicitada.
#' @keywords gpt
#' @examples
#' \dontrun{
#' texto <- "El SOIP declaro la huelga por aumento de salarios."
#' pregunta <- "¿Cual es el sujeto de la accion? Ejemplo de respuesta:
#' 'El sujeto de la accion es: la CGT'"
#' api_gpt_acep <- gpt_api
#' texto_gpt <- acep_gpt(texto = texto, instrucciones = pregunta,
#' gpt_api = api_gpt_acep,
#' url = "https://api.openai.com/v1/chat/completions",
#' modelo = "gpt-3.5-turbo-0613", rol = "user")
#' cat(texto_gpt)
#'}
#' @export
acep_gpt <- function(texto, instrucciones, gpt_api, url, modelo, rol) {

  contenido <- base::paste(instrucciones,
                  "El texto a analizar aparece a continuacion",
                  "delimitado por '```': \n```", texto, "```", sep = " ")

  output <- httr::POST(
    url = url,
    httr::add_headers(Authorization = base::paste("Bearer", gpt_api)),
    httr::content_type_json(),
    encode = "json",
    body = base::list(
      model = modelo,
      messages = base::list(
        base::list(
          role = rol,
          content = contenido
        )
      )
    )
  )

  respuesta <- httr::content(output)$choices[[1]]$message$content

  return(respuesta)

}
