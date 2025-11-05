#' @title Interaccion con modelos de IA usando OpenRouter
#' @description
#' Funcion para interactuar con multiples proveedores de IA (OpenAI, Anthropic, Google,
#' Meta, etc.) a traves de la API unificada de OpenRouter. Soporta Structured Outputs
#' para modelos compatibles (OpenAI GPT-4o+, Fireworks, y otros). OpenRouter normaliza
#' las diferencias entre proveedores, permitiendo acceder a 400+ modelos con una sola API.
#' Ideal para comparar modelos o usar fallbacks automaticos.
#'
#' @param texto Texto a analizar. Puede ser una noticia, tweet, documento, etc.
#' @param instrucciones Instrucciones en lenguaje natural que indican al modelo que hacer
#'   con el texto. Ejemplo: "Extrae todas las entidades nombradas", "Clasifica el sentimiento".
#' @param modelo Modelo a utilizar con formato "proveedor/modelo". Ejemplos populares:
#'   - OpenAI: `"openai/gpt-4o-mini"` (rapido y economico), `"openai/gpt-4o"` (potente)
#'   - Anthropic: `"anthropic/claude-sonnet-4-5"`, `"anthropic/claude-3-5-haiku-20241022"`
#'   - Google: `"google/gemini-2.5-flash"`, `"google/gemini-2.0-flash-001"`
#'   - Meta: `"meta-llama/llama-3.3-70b-instruct"`, `"meta-llama/llama-4-maverick:free"`
#'   - Qwen: `"qwen/qwen3-next-80b-a3b-instruct-2509"`
#'   - DeepSeek: `"deepseek/deepseek-chat-v3-0324:free"`, `"deepseek/deepseek-r1:free"`
#'   Por defecto: `"openai/gpt-4o-mini"`. Ver lista completa: https://openrouter.ai/models
#' @param api_key Clave de API de OpenRouter. Si no se proporciona, busca la variable de
#'   entorno `OPENROUTER_API_KEY`. Para obtener una clave: https://openrouter.ai/settings/keys
#' @param schema Esquema JSON que define la estructura de la respuesta. Puede usar
#'   `acep_gpt_schema()` para obtener esquemas predefinidos o crear uno personalizado.
#'   Si es `NULL`, usa un esquema simple con campo "respuesta".
#'   NOTA: Structured Outputs solo funciona con modelos compatibles (OpenAI GPT-4o+, Fireworks).
#'   Para otros modelos, se usara JSON mode basico.
#' @param parse_json Logico. Si `TRUE` (por defecto), parsea automaticamente el JSON
#'   a un objeto R (lista o data frame). Si `FALSE`, devuelve el JSON como string.
#' @param temperature Parametro de temperatura (0-2). Valores bajos (0-0.3) generan
#'   respuestas mas deterministas. Valores altos (0.7-1) mas creativas. Por defecto: 0.
#' @param max_tokens Numero maximo de tokens en la respuesta. Por defecto: 2000.
#' @param top_p Parametro top-p para nucleus sampling (0-1). Por defecto: 0.2.
#' @param app_name Nombre de tu aplicacion (opcional). Se muestra en openrouter.ai/activity.
#' @param site_url URL de tu aplicacion (opcional). Para estadisticas en OpenRouter.
#' @param use_fallback Logico. Si `TRUE`, OpenRouter usara modelos alternativos si el
#'   modelo solicitado no esta disponible. Por defecto: FALSE.
#'
#' @return Si `parse_json=TRUE`, devuelve una lista o data frame con la respuesta
#'   estructurada segun el esquema. Si `parse_json=FALSE`, devuelve un string JSON.
#'
#' @details
#' OpenRouter abstrae las diferencias entre proveedores, mapeando automaticamente los
#' parametros a la interfaz nativa de cada modelo. Los parametros no soportados por un
#' modelo son ignorados silenciosamente. Esto permite usar la misma funcion para
#' cualquier modelo sin preocuparse por las especificidades de cada API.
#'
#' Para Structured Outputs estrictos, recomendamos usar modelos OpenAI (gpt-4o+) o
#' Fireworks. Otros modelos intentaran seguir el esquema pero sin garantias estrictas.
#'
#' @export
#' @examples
#' \dontrun{
#' # Configurar API key
#' Sys.setenv(OPENROUTER_API_KEY = "tu-api-key")
#'
#' # Usar GPT-4o mini (rapido y economico)
#' texto <- "El SUTEBA convoco a un paro en Buenos Aires el 15 de marzo."
#' resultado <- acep_openrouter(texto, "Extrae las entidades nombradas",
#'                               modelo = "openai/gpt-4o-mini",
#'                               schema = acep_gpt_schema("extraccion_entidades"))
#'
#' # Comparar con Claude
#' resultado_claude <- acep_openrouter(texto, "Extrae las entidades nombradas",
#'                                      modelo = "anthropic/claude-sonnet-4-5",
#'                                      schema = acep_gpt_schema("extraccion_entidades"))
#'
#' # Usar modelo gratuito
#' resultado_free <- acep_openrouter(texto, "Clasifica el sentimiento",
#'                                    modelo = "meta-llama/llama-4-maverick:free",
#'                                    schema = acep_gpt_schema("sentimiento"))
#'
#' # Con metadata de aplicacion
#' resultado <- acep_openrouter(texto, "Analiza el texto",
#'                               app_name = "Mi App de Analisis",
#'                               site_url = "https://miapp.com")
#' }
acep_openrouter <- function(texto,
                            instrucciones,
                            modelo = "openai/gpt-4o-mini",
                            api_key = Sys.getenv("OPENROUTER_API_KEY"),
                            schema = NULL,
                            parse_json = TRUE,
                            temperature = 0,
                            max_tokens = 2000,
                            top_p = 0.2,
                            app_name = NULL,
                            site_url = NULL,
                            use_fallback = FALSE) {

  # Validaciones
  if (!is.character(texto) || nchar(texto) == 0) {
    stop("El parametro 'texto' debe ser una cadena de caracteres no vacia")
  }
  if (!is.character(instrucciones) || nchar(instrucciones) == 0) {
    stop("El parametro 'instrucciones' debe ser una cadena de caracteres no vacia")
  }
  if (api_key == "") {
    stop("API key no encontrada. Define la variable de entorno OPENROUTER_API_KEY o pasa el parametro api_key")
  }

  # Determinar si el modelo soporta Structured Outputs estrictos
  # Segun https://openrouter.ai/docs/features/structured-outputs
  # Solo OpenAI GPT-4o+ y Fireworks tienen soporte completo
  soporta_structured_outputs <- grepl("^openai/gpt-4o", modelo) ||
                                 grepl("^openai/gpt-5", modelo) ||
                                 grepl("^openai/o1", modelo) ||
                                 grepl("^openai/o4", modelo) ||
                                 grepl("^fireworks/", modelo)

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

  # Construir prompt del sistema
  system_prompt <- "Eres un asistente experto en analisis de texto. Debes responder SIEMPRE siguiendo exactamente el esquema JSON proporcionado. Se preciso, conciso y basa tus respuestas unicamente en el texto proporcionado."

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
    top_p = top_p
  )

  # Agregar response_format para modelos que lo soporten
  if (soporta_structured_outputs) {
    body$response_format <- list(
      type = "json_schema",
      json_schema = list(
        name = "respuesta_estructurada",
        strict = TRUE,
        schema = schema
      )
    )
  } else {
    # Para modelos sin Structured Outputs, usar JSON mode basico
    body$response_format <- list(type = "json_object")
    # Agregar instruccion explicita para JSON en el prompt del sistema
    body$messages[[1]]$content <- paste0(
      body$messages[[1]]$content,
      " Responde SIEMPRE en formato JSON valido."
    )
  }

  # Agregar provider preferences si se solicita fallback
  if (use_fallback) {
    body$route <- "fallback"
  }

  # Construir headers - httr::add_headers necesita argumentos nombrados, no una lista
  headers_call <- list(
    "Content-Type" = "application/json",
    "Authorization" = paste("Bearer", api_key)
  )

  if (!is.null(site_url)) {
    headers_call$`HTTP-Referer` <- site_url
  }

  if (!is.null(app_name)) {
    headers_call$`X-Title` <- app_name
  }

  # Realizar peticion a la API
  tryCatch({
    output <- httr::POST(
      url = "https://openrouter.ai/api/v1/chat/completions",
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

    respuesta_json <- respuesta_parsed$choices[[1]]$message$content

    # Verificar respuesta vacia
    if (is.null(respuesta_json) || nchar(respuesta_json) == 0) {
      stop("La API devolvio una respuesta vacia. Verifica tu prompt y esquema.")
    }

    # Limpiar JSON de markdown si es necesario
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

  }, error = function(e) {
    stop(sprintf("Error al interactuar con la API de OpenRouter: %s", conditionMessage(e)))
  })
}
