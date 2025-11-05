#' @title Interaccion con modelos Claude usando Structured Outputs
#' @description
#' Funcion para interactuar con la API de Anthropic Claude utilizando Tool Calling
#' para garantizar respuestas en formato JSON que cumplen estrictamente con un esquema
#' predefinido. A diferencia de OpenAI, Anthropic utiliza "forced tool use" para
#' lograr structured outputs, definiendo el esquema deseado como input_schema de una
#' herramienta y forzando al modelo a usarla. Compatible con todos los modelos Claude.
#'
#' @param texto Texto a analizar con Claude. Puede ser una noticia, tweet, documento, etc.
#' @param instrucciones Instrucciones en lenguaje natural que indican al modelo que hacer
#'   con el texto. Ejemplo: "Extrae todas las entidades nombradas", "Clasifica el sentimiento".
#' @param modelo Modelo de Claude a utilizar. Modelos disponibles (ordenados por potencia):
#'   - Claude 4.5: `"claude-sonnet-4-5-20250929"` (mas reciente y potente),
#'     `"claude-haiku-4-5-20251001"` (rapido)
#'   - Claude 4.1: `"claude-opus-4-1-20250805"` (razonamiento excepcional)
#'   - Claude 4: `"claude-opus-4-20250514"`, `"claude-sonnet-4-20250514"`
#'   - Claude 3.7: `"claude-3-7-sonnet-20250219"`
#'   - Claude 3.5: `"claude-3-5-haiku-20241022"` (rapido y economico)
#'   - Claude 3: `"claude-3-opus-20240229"`, `"claude-3-haiku-20240307"`
#'   Por defecto: `"claude-sonnet-4-20250514"`. Ver: https://docs.anthropic.com/en/docs/about-claude/models
#' @param api_key Clave de API de Anthropic. Si no se proporciona, busca la variable de
#'   entorno `ANTHROPIC_API_KEY`. Para obtener una clave: https://console.anthropic.com/
#' @param schema Esquema JSON que define la estructura de la respuesta. Puede usar
#'   `acep_gpt_schema()` para obtener esquemas predefinidos o crear uno personalizado.
#'   Si es `NULL`, usa un esquema simple con campo "respuesta".
#' @param parse_json Logico. Si `TRUE` (por defecto), parsea automaticamente el JSON
#'   a un objeto R (lista o data frame). Si `FALSE`, devuelve el JSON como string.
#' @param temperature Parametro de temperatura (0-1). Valores bajos (0-0.3) generan
#'   respuestas mas deterministas y consistentes. Valores altos (0.7-1) mas creativas.
#'   Por defecto: 0 (maxima determinismo).
#'   NOTA: Anthropic no permite usar `temperature` y `top_p` simultaneamente.
#' @param max_tokens Numero maximo de tokens en la respuesta. Por defecto: 2000.
#' @param top_p Parametro top-p para nucleus sampling (0-1). Controla la diversidad
#'   de la respuesta. Por defecto: 0.2.
#'   NOTA: Solo se usa si `temperature` es 0 (valor por defecto).
#' @param top_k Parametro top-k (solo disponible en Claude). Limita la seleccion a los
#'   K tokens mas probables. Por defecto: NULL (deshabilitado).
#'
#' @return Si `parse_json=TRUE`, devuelve una lista o data frame con la respuesta
#'   estructurada segun el esquema. Si `parse_json=FALSE`, devuelve un string JSON.
#'
#' @details
#' **Diferencias importantes entre modelos Claude:**
#'
#' - **Claude Sonnet 4.5** (`claude-sonnet-4-5`): NO permite `temperature` y `top_p`
#'   simultaneamente. La funcion solo envia uno de los dos si fue modificado del default.
#'
#' - **Otros modelos Claude** (`claude-sonnet-4-20250514`, `claude-3-5-haiku-20241022`,
#'   `claude-3-opus-20240229`, etc.): SI permiten ambos parametros simultaneamente.
#'
#' La funcion detecta automaticamente el modelo y aplica la logica correcta.
#'
#' @export
#' @examples
#' \dontrun{
#' # Extraer entidades de un texto
#' texto <- "El SUTEBA convoco a un paro en Buenos Aires el 15 de marzo."
#' instrucciones <- "Extrae todas las entidades nombradas del texto."
#' schema <- acep_gpt_schema("extraccion_entidades")
#' resultado <- acep_claude(texto, instrucciones, schema = schema)
#' print(resultado)
#'
#' # Analisis de sentimiento
#' texto <- "La protesta fue pacifica y bien organizada."
#' schema <- acep_gpt_schema("sentimiento")
#' resultado <- acep_claude(texto, "Analiza el sentimiento del texto", schema = schema)
#' print(resultado$sentimiento_general)
#'
#' # Clasificar noticia
#' texto <- "Trabajadores reclamaron mejoras salariales."
#' schema <- acep_gpt_schema("clasificacion")
#' resultado <- acep_claude(texto, "Clasifica esta noticia", schema = schema)
#' print(resultado$categoria)
#' }
acep_claude <- function(texto,
                        instrucciones,
                        modelo = "claude-sonnet-4-20250514",
                        api_key = Sys.getenv("ANTHROPIC_API_KEY"),
                        schema = NULL,
                        parse_json = TRUE,
                        temperature = 0,
                        max_tokens = 2000,
                        top_p = 0.2,
                        top_k = NULL) {

  # Validaciones
  if (!is.character(texto) || nchar(texto) == 0) {
    stop("El parametro 'texto' debe ser una cadena de caracteres no vacia")
  }
  if (!is.character(instrucciones) || nchar(instrucciones) == 0) {
    stop("El parametro 'instrucciones' debe ser una cadena de caracteres no vacia")
  }
  if (api_key == "") {
    stop("API key no encontrada. Define la variable de entorno ANTHROPIC_API_KEY o pasa el parametro api_key")
  }

  # Validar modelos compatibles (listado oficial de la API de Anthropic)
  modelos_compatibles <- c(
    # Claude 4.5
    "claude-sonnet-4-5-20250929", "claude-haiku-4-5-20251001",
    # Claude 4.1
    "claude-opus-4-1-20250805",
    # Claude 4
    "claude-opus-4-20250514", "claude-sonnet-4-20250514",
    # Claude 3.7
    "claude-3-7-sonnet-20250219",
    # Claude 3.5
    "claude-3-5-haiku-20241022",
    # Claude 3
    "claude-3-opus-20240229", "claude-3-haiku-20240307"
  )

  # Verificar compatibilidad con patrones
  es_compatible <- modelo %in% modelos_compatibles ||
                   grepl("^claude-(sonnet|opus|haiku)-4", modelo) ||
                   grepl("^claude-3-", modelo)

  if (!es_compatible) {
    warning(sprintf("El modelo '%s' puede no ser compatible. Modelos recomendados: claude-sonnet-4-5-20250929, claude-opus-4-1-20250805, claude-3-5-haiku-20241022",
                    modelo))
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

  # Remover additionalProperties si existe (no es necesario para Anthropic)
  schema$additionalProperties <- NULL

  # Construir prompt del sistema
  system_prompt <- "Eres un asistente experto en analisis de texto. Debes responder SIEMPRE usando la herramienta proporcionada siguiendo exactamente el esquema especificado. Se preciso, conciso y basa tus respuestas unicamente en el texto proporcionado."

  # Construir prompt del usuario
  user_prompt <- sprintf("Texto a analizar:\n%s\n\nInstrucciones:\n%s", texto, instrucciones)

  # Definir la herramienta con el esquema como input_schema
  # Esto es el "truco" de Anthropic para structured outputs
  tool <- list(
    name = "respuesta_estructurada",
    description = "Herramienta para devolver la respuesta estructurada siguiendo el esquema especificado",
    input_schema = schema
  )

  # Construir body de la peticion
  body <- list(
    model = modelo,
    max_tokens = max_tokens,
    system = system_prompt,
    messages = list(
      list(
        role = "user",
        content = user_prompt
      )
    ),
    tools = list(tool),
    # Forzar el uso de la herramienta especifica
    tool_choice = list(
      type = "tool",
      name = "respuesta_estructurada"
    )
  )

  # Anthropic: algunos modelos no permiten temperature y top_p simultaneamente
  # Modelo claude-sonnet-4-5 NO acepta ambos parametros
  # Otros modelos (claude-sonnet-4-20250514, claude-3-x) SI los aceptan

  # Detectar si es Sonnet 4.5 (el unico que tiene restriccion estricta)
  es_sonnet_4_5 <- grepl("^claude-sonnet-4-5", modelo)

  if (es_sonnet_4_5) {
    # Para Sonnet 4.5: solo enviar uno si fue modificado del default
    if (temperature != 0) {
      body$temperature <- temperature
    } else if (top_p != 0.2) {
      body$top_p <- top_p
    }
    # Si ambos son defaults, no enviar ninguno
  } else {
    # Para otros modelos Claude: enviar ambos si fueron especificados
    if (temperature != 0) {
      body$temperature <- temperature
    }
    if (top_p != 0.2) {
      body$top_p <- top_p
    }
  }

  # Agregar top_k solo si se especifica (parametro opcional de Claude)
  if (!is.null(top_k)) {
    body$top_k <- top_k
  }

  # Realizar peticion a la API
  tryCatch({
    output <- httr::POST(
      url = "https://api.anthropic.com/v1/messages",
      httr::add_headers(
        "Content-Type" = "application/json",
        "x-api-key" = api_key,
        "anthropic-version" = "2023-06-01"
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
    if (is.null(respuesta_parsed$content) || length(respuesta_parsed$content) == 0) {
      stop("La API devolvio una respuesta vacia. Verifica tu prompt y esquema.")
    }

    # Buscar el bloque tool_use en el contenido
    tool_use_block <- NULL
    for (block in respuesta_parsed$content) {
      if (!is.null(block$type) && block$type == "tool_use") {
        tool_use_block <- block
        break
      }
    }

    if (is.null(tool_use_block)) {
      stop("La respuesta no contiene un bloque tool_use. Verifica la configuracion.")
    }

    # Extraer el input de la herramienta (que es nuestro JSON estructurado)
    resultado <- tool_use_block$input

    # Si parse_json es FALSE, convertir a JSON string
    if (!parse_json) {
      return(jsonlite::toJSON(resultado, auto_unbox = TRUE, pretty = TRUE))
    } else {
      # Normalizar la estructura usando jsonlite para evitar anidamiento extra
      # Anthropic devuelve arrays con anidamiento adicional que necesitamos simplificar
      resultado_json <- jsonlite::toJSON(resultado, auto_unbox = TRUE)
      resultado_normalizado <- jsonlite::fromJSON(resultado_json, simplifyVector = TRUE)
      return(resultado_normalizado)
    }

  }, error = function(e) {
    stop(sprintf("Error al interactuar con la API de Anthropic: %s", conditionMessage(e)))
  })
}
