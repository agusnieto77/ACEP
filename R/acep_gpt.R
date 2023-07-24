#' @title Función para interactuar con los modelos  de OpenAI.
#' @description Función para interactuar con los modelos de OpenAI
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
#' @importFrom httr POST add_headers content_type_json content
#' @return Si todas las entradas son correctas,
#' la salida sera una cadena de caracteres con la
#' información solicitada.
#' @keywords tripletes gpt
#' @examples
#' \dontrun{
#' texto <- "El SOIP declaro la huelga por aumento de salarios."
#' pregunta <- "¿Cual es el sujeto de la acción? Ejemplo de respuesta:
#' 'El sujeto de la acción es: la CGT'"
#' api_gpt_acep <- gpt_api
#' texto_gpt <- acep_gpt(texto = texto, instrucciones = pregunta,
#' gpt_api = api_gpt_acep,
#' url = "https://api.openai.com/v1/chat/completions",
#' modelo = "gpt-3.5-turbo-0613", rol = "user")
#' cat(texto_gpt)
#'}
#' @export
acep_gpt <- function(texto, instrucciones, gpt_api = Sys.getenv("OPENAI_API_KEY"), url, modelo, rol) {
  if (!is.character(texto) || !is.character(instrucciones) ||
      !is.character(gpt_api) || !is.character(url) ||
      !is.character(modelo) || !is.character(rol)) {
    return(message("Todos los par\u00e1metro deben ser cadenas de caracteres."))
  }
  if (is.null(gpt_api) || gpt_api == "") {
    return(message("La clave API de OpenAI no est\u00e1 configurada."))
  }
  contenido <- paste(instrucciones,
                     "El texto a analizar aparece a continuaci\u00f3n",
                     "delimitado por '```': \n```", texto, "```", sep = " ")
  tryCatch({
    output <- httr::POST(
      url = url,
      httr::add_headers(Authorization = paste("Bearer", gpt_api)),
      httr::content_type_json(),
      encode = "json",
      body = list(
        model = modelo,
        messages = list(
          list(
            role = rol,
            content = contenido
          )
        )
      )
    )
    respuesta <- httr::content(output)$choices[[1]]$message$content
    if (is.null(respuesta)) {
      return(message("Los par\u00e1metro ingrasados tienen valores incorrectos."))
    } else {
      return(respuesta)
    }
  }, error = function(e) {
    stop("Error al interactuar con la API de OpenAI: ", conditionMessage(e))
  })
}
