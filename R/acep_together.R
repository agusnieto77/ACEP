#' @title Interaccion con modelos de IA usando TogetherAI
#' @description
#' Funcion para interactuar con modelos de IA a traves de la API de TogetherAI.
#' TogetherAI proporciona acceso a modelos open-source de alta calidad como
#' Llama, Qwen, Mistral, DeepSeek y muchos otros. Soporta JSON mode para
#' respuestas estructuradas. La API es compatible con el formato de OpenAI,
#' lo que facilita la integracion.
#'
#' @param texto Texto a analizar. Puede ser una noticia, tweet, documento, etc.
#' @param instrucciones Instrucciones en lenguaje natural que indican al modelo que hacer
#'   con el texto. Ejemplo: "Extrae todas las entidades nombradas", "Clasifica el sentimiento".
#' @param modelo Modelo a utilizar. Ejemplos populares:
#'   - Moonshot: `"moonshotai/Kimi-K2-Instruct-0905"` (128K context)
#'   - Meta Llama: `"meta-llama/Meta-Llama-3.1-405B-Instruct-Turbo"`, `"meta-llama/Llama-3.3-70B-Instruct-Turbo"`
#'   - Qwen: `"Qwen/Qwen2.5-72B-Instruct-Turbo"`, `"Qwen/QwQ-32B-Preview"`
#'   - Mistral: `"mistralai/Mixtral-8x22B-Instruct-v0.1"`, `"mistralai/Mistral-7B-Instruct-v0.3"`
#'   - DeepSeek: `"deepseek-ai/DeepSeek-V3"`, `"deepseek-ai/DeepSeek-R1"`
#'   - Google: `"google/gemma-2-27b-it"`, `"google/gemma-2-9b-it"`
#'   Por defecto: `"meta-llama/Meta-Llama-3.1-70B-Instruct-Turbo"`.
#'   Ver lista completa: https://docs.together.ai/docs/chat-models
#' @param api_key Clave de API de TogetherAI. Si no se proporciona, busca la variable de
#'   entorno `TOGETHER_API_KEY`. Para obtener una clave: https://api.together.xyz/settings/api-keys
#' @param schema Esquema JSON que define la estructura de la respuesta. Puede usar
#'   `acep_gpt_schema()` para obtener esquemas predefinidos o crear uno personalizado.
#'   Si es `NULL`, usa un esquema simple con campo "respuesta".
#'   NOTA: TogetherAI soporta JSON mode con \code{response_format: \{type: "json_object"\}} para
#'   modelos compatibles. Consulta la lista de modelos soportados en:
#'   https://docs.together.ai/docs/json-mode
#' @param parse_json Logico. Si `TRUE` (por defecto), parsea automaticamente el JSON
#'   a un objeto R (lista o data frame). Si `FALSE`, devuelve el JSON como string.
#' @param temperature Parametro de temperatura (0-2). Valores bajos (0-0.3) generan
#'   respuestas mas deterministas. Valores altos (0.7-1) mas creativas. Por defecto: 0.
#' @param max_tokens Numero maximo de tokens en la respuesta. Por defecto: 2000.
#' @param top_p Parametro top-p para nucleus sampling (0-1). Por defecto: 0.2.
#' @param top_k Parametro top-k para muestreo. Limita las opciones a los k tokens mas probables.
#'   Por defecto: 50. Usar 0 o -1 para desactivar.
#' @param repetition_penalty Penalizacion por repeticion de tokens (0.1-2.0).
#'   Valores > 1 penalizan repeticiones. Por defecto: 1.
#' @param stop Secuencias de parada opcionales. Vector de strings que detienen la generacion.
#'   Por defecto: NULL.
#' @param prompt_system Prompt del sistema que define el comportamiento del modelo. Opciones:
#'   - `"json"` (por defecto): Usa un prompt estructurado que instruye al modelo a responder
#'     SOLO en formato JSON siguiendo el esquema proporcionado. Agrega \code{response_format: \{type: "json_object"\}}
#'   - `"texto"`: Usa un prompt simple para respuestas en texto plano sin estructura.
#'     Elimina automaticamente el contenido de pensamiento (<think>...</think>) de modelos como Qwen3-Thinking
#'   - String personalizado: Cualquier texto que definas como prompt del sistema
#'
#' @return Si `parse_json=TRUE`, devuelve una lista o data frame con la respuesta
#'   estructurada segun el esquema. Si `parse_json=FALSE`, devuelve un string JSON.
#'
#' @details
#' **Sobre TogetherAI:**
#'
#' TogetherAI es una plataforma especializada en modelos open-source que ofrece:
#' - Precios competitivos y modelos gratuitos
#' - Alta velocidad de inferencia optimizada
#' - Acceso a modelos de ultima generacion (Llama, Qwen, DeepSeek, etc.)
#' - API compatible con formato OpenAI
#'
#' **JSON Mode:**
#'
#' La funcion utiliza JSON mode de TogetherAI para obtener respuestas estructuradas.
#' Cuando `prompt_system = "json"`, la funcion:
#' 1. Incluye el esquema JSON en el prompt del sistema (REQUERIDO por TogetherAI)
#' 2. Agrega \code{response_format: \{type: "json_object"\}} al body de la peticion
#' 3. Instruye explicitamente al modelo a responder SOLO en JSON
#'
#' Esta combinacion de esquema textual + \code{response_format} asegura respuestas JSON validas
#' y consistentes en cada llamada.
#'
#' **Modelos compatibles con JSON mode:**
#'
#' Los modelos mas recientes que soportan JSON mode incluyen:
#' - Qwen3, Qwen2.5 (Instruct, Coder, VL, Thinking)
#' - DeepSeek-R1, DeepSeek-V3
#' - Meta Llama 3.1, 3.3, 4
#' - Mistral 7B Instruct
#' - Google Gemma
#'
#' Ver lista completa: https://docs.together.ai/docs/json-mode
#'
#' **Validaciones:**
#'
#' La funcion incluye validacion de limite de tokens. Si la respuesta es truncada
#' por `max_tokens`, devuelve un mensaje claro indicando que se necesitan mas tokens.
#'
#' @export
#' @examples
#' \dontrun{
#' # Configurar API key
#' Sys.setenv(TOGETHER_API_KEY = "tu-api-key")
#'
#' # Usar Llama 3.1 70B (rapido y potente)
#' texto <- "El SUTEBA convoco a un paro en Buenos Aires el 15 de marzo."
#' resultado <- acep_together(texto, "Extrae las entidades nombradas",
#'                            modelo = "meta-llama/Meta-Llama-3.1-70B-Instruct-Turbo",
#'                            schema = acep_gpt_schema("extraccion_entidades"))
#'
#' # Usar Qwen para analisis de sentimiento
#' resultado_qwen <- acep_together(texto, "Clasifica el sentimiento",
#'                                 modelo = "Qwen/Qwen2.5-72B-Instruct-Turbo",
#'                                 schema = acep_gpt_schema("sentimiento"))
#'
#' # Usar DeepSeek-V3
#' resultado_ds <- acep_together(texto, "Analiza el texto",
#'                               modelo = "deepseek-ai/DeepSeek-V3",
#'                               schema = acep_gpt_schema("clasificacion"))
#'
#' # Usar Moonshot Kimi con 128K context
#' resultado_kimi <- acep_together(texto, "Resume el texto",
#'                                 modelo = "moonshotai/Kimi-K2-Instruct-0905",
#'                                 schema = acep_gpt_schema("resumen"))
#'
#' # Usar modo texto plano (sin estructura JSON)
#' resultado_texto <- acep_together(texto, "Resume este texto en una frase",
#'                                  modelo = "meta-llama/Meta-Llama-3.1-70B-Instruct-Turbo",
#'                                  prompt_system = "texto",
#'                                  parse_json = FALSE)
#' print(resultado_texto)  # Devuelve string de texto plano
#'
#' # Usar prompt del sistema personalizado
#' resultado_custom <- acep_together(
#'   texto,
#'   "Analiza el sentimiento",
#'   modelo = "Qwen/Qwen2.5-72B-Instruct-Turbo",
#'   prompt_system = paste(
#'     "Eres un experto en analisis de sentimientos politicos.",
#'     "Se objetivo y neutral."
#'   ),
#'   parse_json = FALSE
#' )
#' }
acep_together <- function(texto,
                          instrucciones,
                          modelo = "meta-llama/Meta-Llama-3.1-70B-Instruct-Turbo",
                          api_key = Sys.getenv("TOGETHER_API_KEY"),
                          schema = NULL,
                          parse_json = TRUE,
                          temperature = 0,
                          max_tokens = 2000,
                          top_p = 0.2,
                          top_k = 50,
                          repetition_penalty = 1,
                          stop = NULL,
                          prompt_system = "json") {

  # Validaciones
  if (!is.character(texto) || nchar(texto) == 0) {
    stop("El parametro 'texto' debe ser una cadena de caracteres no vacia")
  }
  if (!is.character(instrucciones) || nchar(instrucciones) == 0) {
    stop("El parametro 'instrucciones' debe ser una cadena de caracteres no vacia")
  }
  if (api_key == "") {
    stop("API key no encontrada. Define la variable de entorno TOGETHER_API_KEY o pasa el parametro api_key")
  }

  # Construir prompt del sistema segun el tipo especificado
  if (prompt_system == "json") {
    # Modo JSON: Fuerza respuestas estructuradas en JSON

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
        required = c("respuesta"),
        additionalProperties = FALSE
      )
      schema <- proteger_arrays_schema(schema)
    }

    # Construir descripcion de campos esperados del esquema
    # Extraer nombres y descripciones de los campos del schema
    campos_descripciones <- sapply(names(schema$properties), function(campo) {
      desc <- schema$properties[[campo]]$description
      if (!is.null(desc)) {
        sprintf("- %s: %s", campo, desc)
      } else {
        sprintf("- %s", campo)
      }
    })
    campos_texto <- paste(campos_descripciones, collapse = "\n")

    # Prompt del sistema con instrucciones para JSON
    # TogetherAI usa JSON mode basico (type: json_object), no Structured Outputs estrictos
    # NO incluimos el esquema completo para evitar que el modelo lo devuelva como respuesta
    system_prompt <- sprintf(
      "Eres un asistente experto en analisis de texto. Debes responder SIEMPRE en formato JSON valido con los siguientes campos:\n\n%s\n\nSe preciso, conciso y basa tus respuestas unicamente en el texto proporcionado. Responde UNICAMENTE con el JSON de datos, sin texto adicional antes o despues.",
      campos_texto
    )

  } else if (prompt_system == "texto") {
    # Modo texto plano: Respuestas sin estructura especifica
    system_prompt <- "Eres un asistente experto en analisis de texto. Responde de manera clara, precisa y concisa. Basa tus respuestas unicamente en el texto proporcionado."

  } else {
    # Prompt personalizado: Usa el string proporcionado directamente
    system_prompt <- prompt_system
  }

  # Construir prompt del usuario
  user_prompt <- sprintf("Texto a analizar:\n%s\n\nInstrucciones:\n%s", texto, instrucciones)

  # Construir body de la peticion
  body <- list(
    model = modelo,
    messages = list(
      list(role = "system", content = system_prompt),
      list(role = "user", content = user_prompt)
    ),
    temperature = temperature,
    max_tokens = max_tokens,
    top_p = top_p,
    top_k = top_k,
    repetition_penalty = repetition_penalty
  )

  # Agregar response_format para JSON mode solo si prompt_system es "json"
  # TogetherAI soporta response_format segun https://docs.together.ai/docs/json-mode
  if (prompt_system == "json") {
    body$response_format <- list(
      type = "json_object"
    )
  }

  # Agregar secuencias de parada si se especifican
  if (!is.null(stop)) {
    body$stop <- stop
  }

  # Construir headers
  headers_call <- list(
    "Content-Type" = "application/json",
    "Authorization" = paste("Bearer", api_key)
  )

  # Realizar peticion a la API
  tryCatch({
    output <- httr::POST(
      url = "https://api.together.xyz/v1/chat/completions",
      do.call(httr::add_headers, headers_call),
      body = jsonlite::toJSON(body, auto_unbox = TRUE, pretty = FALSE),
      encode = "raw"
    )

    # Verificar codigo HTTP
    if (httr::status_code(output) != 200) {
      error_content <- httr::content(output, as = "parsed")
      error_msg <- if (!is.null(error_content$error$message)) {
        error_content$error$message
      } else if (!is.null(error_content$error)) {
        as.character(error_content$error)
      } else {
        "Error desconocido"
      }
      stop(sprintf("Error HTTP %d: %s", httr::status_code(output), error_msg))
    }

    # Extraer respuesta
    respuesta_parsed <- httr::content(output, as = "parsed")

    # Verificar que hay contenido
    if (is.null(respuesta_parsed$choices) || length(respuesta_parsed$choices) == 0) {
      stop("La API devolvio una respuesta vacia. Verifica tu prompt y esquema.")
    }

    # Verificar si la respuesta fue truncada por limite de tokens
    finish_reason <- respuesta_parsed$choices[[1]]$finish_reason
    if (!is.null(finish_reason) && finish_reason == "length") {
      stop("La respuesta fue truncada debido al limite de max_tokens. Se necesitan mas tokens para obtener una respuesta valida. Aumenta el valor de max_tokens.")
    }

    respuesta_json <- respuesta_parsed$choices[[1]]$message$content

    # Verificar respuesta vacia
    if (is.null(respuesta_json) || nchar(respuesta_json) == 0) {
      stop("La API devolvio una respuesta vacia. Verifica tu prompt y esquema.")
    }

    # Procesar respuesta segun el modo
    if (prompt_system == "json") {
      # Modo JSON: Limpiar markdown y parsear
      # Algunos modelos envuelven el JSON en ```json...``` o ```...```
      respuesta_json <- gsub("^```json\\s*", "", respuesta_json, perl = TRUE)
      respuesta_json <- gsub("^```\\s*", "", respuesta_json, perl = TRUE)
      respuesta_json <- gsub("\\s*```$", "", respuesta_json, perl = TRUE)
      respuesta_json <- trimws(respuesta_json)

      # Parsear JSON si se solicita
      if (parse_json) {
        tryCatch({
          resultado <- jsonlite::fromJSON(respuesta_json, simplifyVector = TRUE)
          return(resultado)
        }, error = function(e) {
          # Si falla el parseo, informar con el contenido original
          stop(sprintf(
            "Error al parsear JSON de la respuesta. Contenido recibido (primeros 200 chars):\n%s\n\nError de parseo: %s",
            substr(respuesta_json, 1, 200),
            conditionMessage(e)
          ))
        })
      } else {
        return(respuesta_json)
      }
    } else {
      # Modo texto plano o personalizado: Limpiar y devolver
      # Eliminar contenido de pensamiento (thinking) si existe
      # Algunos modelos como Qwen3-Thinking generan contenido entre <think>...</think>
      # La etiqueta inicial puede estar o no, pero la de cierre siempre está
      respuesta_limpia <- gsub("(<think>)?[\\s\\S]*?</think>\\s*", "", respuesta_json, perl = TRUE, ignore.case = TRUE)
      respuesta_limpia <- trimws(respuesta_limpia)

      return(respuesta_limpia)
    }

  }, error = function(e) {
    stop(sprintf("Error al interactuar con la API de TogetherAI: %s", conditionMessage(e)))
  })
}
