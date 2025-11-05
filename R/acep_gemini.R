#' @title Interaccion con modelos Gemini usando Structured Outputs
#' @description
#' Funcion para interactuar con la API de Google Gemini utilizando Structured Outputs
#' nativos. Gemini soporta generacion de JSON estructurado mediante el parametro
#' `responseSchema` que garantiza que las respuestas cumplan con el esquema definido.
#' Compatible con todos los modelos Gemini 2.5 y Gemini 2.0. Acceso gratuito para
#' uso limitado disponible en Google AI Studio.
#'
#' @param texto Texto a analizar con Gemini. Puede ser una noticia, tweet, documento, etc.
#' @param instrucciones Instrucciones en lenguaje natural que indican al modelo que hacer
#'   con el texto. Ejemplo: "Extrae todas las entidades nombradas", "Clasifica el sentimiento".
#' @param modelo Modelo de Gemini a utilizar. Opciones recomendadas:
#'   - Gemini 2.5: `"gemini-2.5-flash"` (rapido, multimodal, por defecto),
#'     `"gemini-2.5-flash-lite"` (mas economico), `"gemini-2.5-pro"` (mas potente)
#'   - Gemini 2.0: `"gemini-2.0-flash"`, `"gemini-2.0-flash-lite"`
#'   Por defecto: `"gemini-2.5-flash"`. Ver: https://ai.google.dev/gemini-api/docs/models
#' @param api_key Clave de API de Google Gemini. Si no se proporciona, busca la variable de
#'   entorno `GEMINI_API_KEY`. Para obtener una clave: https://aistudio.google.com/apikey
#' @param schema Esquema JSON que define la estructura de la respuesta. Puede usar
#'   `acep_gpt_schema()` para obtener esquemas predefinidos o crear uno personalizado.
#'   Si es `NULL`, usa un esquema simple con campo "respuesta".
#'   NOTA: Gemini usa un subconjunto de OpenAPI 3.0 Schema para definir estructuras.
#' @param parse_json Logico. Si `TRUE` (por defecto), parsea automaticamente el JSON
#'   a un objeto R (lista o data frame). Si `FALSE`, devuelve el JSON como string.
#' @param temperature Parametro de temperatura (0-2). Valores bajos (0-0.3) generan
#'   respuestas mas deterministas. Valores altos (0.7-1) mas creativas. Por defecto: 0.
#'   Valor recomendado por Google: 1.0.
#' @param max_tokens Numero maximo de tokens en la respuesta. Por defecto: 2000.
#' @param top_p Parametro top-p para nucleus sampling (0-1). Controla la diversidad
#'   de la respuesta. Por defecto: 0.95 (valor tipico para Gemini).
#' @param top_k Parametro top-k. Limita la seleccion a los K tokens mas probables.
#'   Por defecto: 40 (valor tipico para Gemini).
#'
#' @return Si `parse_json=TRUE`, devuelve una lista o data frame con la respuesta
#'   estructurada segun el esquema. Si `parse_json=FALSE`, devuelve un string JSON.
#'
#' @details
#' La API de Gemini usa un enfoque diferente para structured outputs:
#' - Define `responseMimeType: "application/json"` en `generationConfig`
#' - Usa `responseSchema` con formato OpenAPI 3.0 Schema
#' - Soporta tipos: string, integer, number, boolean, array, object
#' - Campo opcional `propertyOrdering` controla orden de propiedades en respuesta
#'
#' Diferencias importantes con OpenAI:
#' - No requiere campo `additionalProperties: false` (se maneja automaticamente)
#' - Los campos son opcionales por defecto (usar `required` para campos obligatorios)
#' - El esquema cuenta como tokens de entrada
#'
#' @export
#' @examples
#' \dontrun{
#' # Configurar API key
#' Sys.setenv(GEMINI_API_KEY = "tu-api-key")
#'
#' # Extraer entidades con Gemini 2.5 Flash
#' texto <- "El SUTEBA convoco a un paro en Buenos Aires el 15 de marzo."
#' resultado <- acep_gemini(texto, "Extrae las entidades nombradas",
#'                          schema = acep_gpt_schema("extraccion_entidades"))
#'
#' # Analisis de sentimiento con modelo economico
#' resultado <- acep_gemini(texto, "Analiza el sentimiento",
#'                          modelo = "gemini-2.5-flash-lite",
#'                          schema = acep_gpt_schema("sentimiento"))
#'
#' # Usar Gemini 2.0 Flash Lite (mas rapido)
#' resultado <- acep_gemini(texto, "Extrae entidades",
#'                          modelo = "gemini-2.0-flash-lite",
#'                          schema = acep_gpt_schema("extraccion_entidades"))
#' }
acep_gemini <- function(texto,
                        instrucciones,
                        modelo = "gemini-2.5-flash",
                        api_key = Sys.getenv("GEMINI_API_KEY"),
                        schema = NULL,
                        parse_json = TRUE,
                        temperature = 0,
                        max_tokens = 2000,
                        top_p = 0.95,
                        top_k = 40) {

  # Validaciones
  if (!is.character(texto) || nchar(texto) == 0) {
    stop("El parametro 'texto' debe ser una cadena de caracteres no vacia")
  }
  if (!is.character(instrucciones) || nchar(instrucciones) == 0) {
    stop("El parametro 'instrucciones' debe ser una cadena de caracteres no vacia")
  }
  if (api_key == "") {
    stop("API key no encontrada. Define la variable de entorno GEMINI_API_KEY o pasa el parametro api_key")
  }

  # Validar modelos compatibles
  modelos_compatibles <- c(
    # Gemini 2.5 (modelos principales disponibles)
    "gemini-2.5-flash", "gemini-2.5-flash-lite", "gemini-2.5-pro",
    # Gemini 2.0
    "gemini-2.0-flash", "gemini-2.0-flash-lite"
  )

  # Verificar compatibilidad con patrones
  es_compatible <- modelo %in% modelos_compatibles ||
                   grepl("^gemini-2\\.5", modelo) ||
                   grepl("^gemini-2\\.0", modelo)

  if (!es_compatible) {
    warning(sprintf(
      "El modelo '%s' puede no ser compatible. Modelos recomendados: gemini-2.5-flash, gemini-2.5-pro, gemini-2.0-flash, gemini-2.0-flash-lite. NOTA: Gemini 1.x esta deprecado.",
      modelo
    ))
  }

  # Esquema por defecto si no se proporciona uno
  if (is.null(schema)) {
    schema <- list(
      type = "object",
      properties = list(
        respuesta = list(
          type = "string",
          description = "Respuesta principal a la pregunta o instruccion"
        )
      ),
      required = c("respuesta")
    )
  }

  # Convertir esquema al formato de Gemini (OpenAPI 3.0 Schema)
  # Gemini no requiere additionalProperties: false
  schema$additionalProperties <- NULL

  # Construir el prompt combinado (sistema + usuario)
  # Gemini no tiene roles separados en la misma manera que OpenAI/Anthropic
  prompt_completo <- sprintf(
    "Eres un asistente experto en analisis de texto. Debes responder SIEMPRE siguiendo exactamente el esquema JSON proporcionado. Se preciso, conciso y basa tus respuestas unicamente en el texto proporcionado.\n\nTexto a analizar:\n%s\n\nInstrucciones:\n%s",
    texto,
    instrucciones
  )

  # Construir body de la peticion
  body <- list(
    contents = list(
      list(
        parts = list(
          list(text = prompt_completo)
        )
      )
    ),
    generationConfig = list(
      temperature = temperature,
      maxOutputTokens = max_tokens,
      topP = top_p,
      topK = top_k,
      responseMimeType = "application/json",
      responseSchema = schema
    )
  )

  # Construir URL con el modelo y accion
  url <- sprintf(
    "https://generativelanguage.googleapis.com/v1beta/models/%s:generateContent",
    modelo
  )

  # Realizar peticion a la API
  tryCatch({
    output <- httr::POST(
      url = url,
      httr::add_headers(
        "Content-Type" = "application/json",
        "x-goog-api-key" = api_key
      ),
      body = jsonlite::toJSON(body, auto_unbox = TRUE, pretty = FALSE),
      encode = "raw"
    )

    # Verificar codigo HTTP
    if (httr::status_code(output) != 200) {
      error_content <- httr::content(output, as = "parsed")
      error_msg <- if (!is.null(error_content$error$message)) {
        error_content$error$message
      } else {
        "Error desconocido"
      }
      stop(sprintf("Error HTTP %d: %s", httr::status_code(output), error_msg))
    }

    # Extraer respuesta
    respuesta_parsed <- httr::content(output, as = "parsed")

    # Verificar que hay contenido
    if (is.null(respuesta_parsed$candidates) || length(respuesta_parsed$candidates) == 0) {
      stop("La API devolvio una respuesta vacia. Verifica tu prompt y esquema.")
    }

    # Extraer el texto de la respuesta
    # Estructura de Gemini: candidates[[1]]$content$parts[[1]]$text
    candidate <- respuesta_parsed$candidates[[1]]

    # Verificar si hay bloqueo por seguridad
    if (!is.null(candidate$finishReason) && candidate$finishReason != "STOP") {
      finish_reason <- candidate$finishReason
      if (finish_reason == "SAFETY") {
        stop("La respuesta fue bloqueada por razones de seguridad. Intenta con un prompt diferente.")
      } else {
        warning(sprintf("La generacion termino con razon: %s", finish_reason))
      }
    }

    if (is.null(candidate$content) || is.null(candidate$content$parts)) {
      stop("La respuesta no contiene contenido valido.")
    }

    respuesta_json <- candidate$content$parts[[1]]$text

    # Verificar respuesta vacia
    if (is.null(respuesta_json) || nchar(respuesta_json) == 0) {
      stop("La API devolvio una respuesta vacia. Verifica tu prompt y esquema.")
    }

    # Parsear JSON si se solicita
    if (parse_json) {
      resultado <- jsonlite::fromJSON(respuesta_json, simplifyVector = TRUE)
      return(resultado)
    } else {
      return(respuesta_json)
    }

  }, error = function(e) {
    stop(sprintf("Error al interactuar con la API de Gemini: %s", conditionMessage(e)))
  })
}
