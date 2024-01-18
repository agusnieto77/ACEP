#' @title Función para interactuar con los modelos  de OpenAI.
#' @description Función para interactuar con los modelos de OpenAI
#' desde las claves API secretas y pagas.
#' @param texto texto a procesar.
#' @param instrucciones indicaciones de contexto que se le
#' proporcionan al modelo de lenguaje GPT para influir en
#' su generación de texto.
#' @param gpt_api clave API secreta.
#' @param modelo modelo de lenguaje GPT de OpenAI.
#' @importFrom httr POST add_headers content
#' @importFrom jsonlite toJSON
#' @return Si todas las entradas son correctas,
#' la salida sera una cadena de caracteres con la
#' información solicitada.
#' @keywords tripletes gpt
#' @examples
#' \dontrun{
#' texto <- "El SOIP declaro la huelga por aumento de salarios."
#' pregunta <- "¿Cuál es el sujeto de la acción? Ejemplo de respuesta: CGT'"
#' texto_gpt <- acep_gpt(texto = texto, instrucciones = pregunta)
#' cat(texto_gpt)
#'}
#' @export
acep_gpt <- function(texto,
                     instrucciones,
                     gpt_api = Sys.getenv("OPENAI_API_KEY"),
                     modelo = "gpt-3.5-turbo-1106") {
  stopifnot(is.character(texto),
            is.character(instrucciones),
            is.character(modelo))
  if (nchar(gpt_api) == 0) {
    stop("La clave API de OpenAI no est\u00e1 configurada.")
  }
  contenido <- paste(instrucciones,
                     " | El texto a analizar aparece a continuaci\u00f3n:\n",
                     texto,
                     sep = " ")
  body <- list(
    model = modelo,
    seed=123456,
    temperature=0,
    response_format = list(type = "json_object"),
    messages = list(
      list(role = "system", content = "You are a helpful assistant designed to output JSON."),
      list(role = "user", content = contenido)
    )
  )
  json_body <- jsonlite::toJSON(body, auto_unbox = TRUE)
  headers <- c(
    `Content-Type` = "application/json",
    Authorization = paste("Bearer", gpt_api)
  )
  tryCatch({
    output <- httr::POST(
      url = "https://api.openai.com/v1/chat/completions",
      body = json_body,
      httr::add_headers(.headers=headers)
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
