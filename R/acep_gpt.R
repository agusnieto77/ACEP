#' @title Interacción con modelos GPT usando Structured Outputs
#' @description
#' Función para interactuar con la API de OpenAI utilizando Structured Outputs,
#' una funcionalidad que garantiza respuestas en formato JSON que cumplen estrictamente
#' con un esquema predefinido. Esto elimina la necesidad de parseo y validación manual,
#' haciendo las respuestas más confiables y estructuradas. Compatible con modelos
#' `gpt-4o` y `gpt-4o-mini`.
#'
#' @param texto Texto a analizar con GPT. Puede ser una noticia, tweet, documento, etc.
#' @param instrucciones Instrucciones en lenguaje natural que indican al modelo qué hacer
#'   con el texto. Ejemplo: "Extrae todas las entidades nombradas", "Clasifica el sentimiento".
#' @param modelo Modelo de OpenAI a utilizar. Opciones: `"gpt-4o-mini"` (más rápido y económico),
#'   `"gpt-4o"` (más potente), `"gpt-4o-2024-08-06"`, `"gpt-4o-2024-11-20"`. Por defecto: `"gpt-4o-mini"`.
#' @param api_key Clave de API de OpenAI. Si no se proporciona, busca la variable de
#'   entorno `OPENAI_API_KEY`. Para obtener una clave: https://platform.openai.com/api-keys
#' @param schema Esquema JSON que define la estructura de la respuesta. Puede usar
#'   `acep_gpt_schema()` para obtener esquemas predefinidos o crear uno personalizado.
#'   Si es `NULL`, usa un esquema simple con campo "respuesta".
#' @param parse_json Lógico. Si `TRUE` (por defecto), parsea automáticamente el JSON
#'   a un objeto R (lista o data frame). Si `FALSE`, devuelve el JSON como string.
#' @param temperature Parámetro de temperatura (0-2). Valores bajos (0-0.3) generan
#'   respuestas más deterministas y consistentes. Valores altos (0.7-1) más creativas.
#'   Por defecto: 0 (máxima determinismo).
#' @param max_tokens Número máximo de tokens en la respuesta. Por defecto: 2000.
#' @param top_p Parámetro top-p para nucleus sampling (0-1). Controla la diversidad
#'   de la respuesta. Por defecto: 0.2.
#' @param frequency_penalty Penalización por repetición de tokens frecuentes (-2 a 2).
#'   Por defecto: 0.2.
#' @param seed Semilla numérica para reproducibilidad. Usar el mismo seed con los
#'   mismos parámetros genera respuestas idénticas. Por defecto: 123456.
#'
#' @return Si `parse_json=TRUE`, devuelve una lista o data frame con la respuesta
#'   estructurada según el esquema. Si `parse_json=FALSE`, devuelve un string JSON.
#'
#' @export
#' @examples
#' \dontrun{
#' # Extraer entidades de un texto
#' texto <- "El SUTEBA convocó a un paro en Buenos Aires el 15 de marzo."
#' instrucciones <- "Extrae todas las entidades nombradas del texto."
#' schema <- acep_gpt_schema("extraccion_entidades")
#' resultado <- acep_gpt(texto, instrucciones, schema = schema)
#' print(resultado)
#'
#' # Análisis de sentimiento
#' texto <- "La protesta fue pacífica y bien organizada."
#' schema <- acep_gpt_schema("sentimiento")
#' resultado <- acep_gpt(texto, "Analiza el sentimiento del texto", schema = schema)
#' print(resultado$sentimiento_general)
#'
#' # Clasificar noticia
#' texto <- "Trabajadores reclamaron mejoras salariales."
#' schema <- acep_gpt_schema("clasificacion")
#' resultado <- acep_gpt(texto, "Clasifica esta noticia", schema = schema)
#' print(resultado$categoria)
#' }
acep_gpt <- function(texto,
                      instrucciones,
                      modelo = "gpt-4o-mini",
                      api_key = Sys.getenv("OPENAI_API_KEY"),
                      schema = NULL,
                      parse_json = TRUE,
                      temperature = 0,
                      max_tokens = 2000,
                      top_p = 0.2,
                      frequency_penalty = 0.2,
                      seed = 123456) {
  
  # Validaciones
  if (!is.character(texto) || nchar(texto) == 0) {
    stop("El parámetro 'texto' debe ser una cadena de caracteres no vacía")
  }
  if (!is.character(instrucciones) || nchar(instrucciones) == 0) {
    stop("El parámetro 'instrucciones' debe ser una cadena de caracteres no vacía")
  }
  if (api_key == "") {
    stop("API key no encontrada. Define la variable de entorno OPENAI_API_KEY o pasa el parámetro api_key")
  }
  
  # Validar modelo compatible con Structured Outputs
  modelos_compatibles <- c("gpt-4o-mini", "gpt-4o", "gpt-4o-2024-08-06", "gpt-4o-2024-11-20")
  if (!modelo %in% modelos_compatibles) {
    warning(sprintf("El modelo '%s' puede no ser compatible con Structured Outputs. Modelos recomendados: %s",
                    modelo, paste(modelos_compatibles, collapse = ", ")))
  }
  
  # Esquema por defecto si no se proporciona uno
  if (is.null(schema)) {
    schema <- list(
      type = "object",
      properties = list(
        respuesta = list(
          type = "string",
          description = "Respuesta principal a la pregunta o instrucción"
        )
      ),
      required = I(c("respuesta")),  # Usar I() para proteger el array de auto_unbox
      additionalProperties = FALSE
    )
  }
  
  # Construir prompt del sistema
  system_prompt <- "Eres un asistente experto en análisis de texto. Debes responder SIEMPRE siguiendo exactamente el esquema JSON proporcionado. Sé preciso, conciso y basa tus respuestas únicamente en el texto proporcionado."
  
  # Construir prompt del usuario
  user_prompt <- sprintf("Texto a analizar:\n%s\n\nInstrucciones:\n%s", texto, instrucciones)
  
  # Construir body de la petición
  body <- list(
    model = modelo,
    messages = list(
      list(role = "system", content = system_prompt),
      list(role = "user", content = user_prompt)
    ),
    response_format = list(
      type = "json_schema",
      json_schema = list(
        name = "respuesta_estructurada",
        strict = TRUE,
        schema = schema
      )
    ),
    temperature = temperature,
    max_tokens = max_tokens,
    top_p = top_p,
    frequency_penalty = frequency_penalty,
    seed = seed
  )
  
  # Realizar petición a la API
  tryCatch({
    output <- httr::POST(
      url = "https://api.openai.com/v1/chat/completions",
      httr::add_headers(
        "Content-Type" = "application/json",
        "Authorization" = paste("Bearer", api_key)
      ),
      body = jsonlite::toJSON(body, auto_unbox = TRUE, pretty = FALSE),  # Serializar con auto_unbox pero protegiendo arrays con I()
      encode = "raw"
    )
    
    # Verificar código HTTP
    if (httr::status_code(output) != 200) {
      error_content <- httr::content(output, as = "parsed")
      stop(sprintf("Error HTTP %d: %s", 
                   httr::status_code(output),
                   error_content$error$message))
    }
    
    # Extraer respuesta
    respuesta_json <- httr::content(output, as = "parsed")$choices[[1]]$message$content
    
    # Verificar respuesta vacía
    if (is.null(respuesta_json) || nchar(respuesta_json) == 0) {
      stop("La API devolvió una respuesta vacía. Verifica tu prompt y esquema.")
    }
    
    # Parsear JSON si se solicita
    if (parse_json) {
      resultado <- jsonlite::fromJSON(respuesta_json, simplifyVector = TRUE)
      return(resultado)
    } else {
      return(respuesta_json)
    }
    
  }, error = function(e) {
    stop(sprintf("Error al interactuar con la API de OpenAI: %s", conditionMessage(e)))
  })
}


#' @title Esquemas JSON predefinidos para análisis de texto con GPT
#' @description
#' Proporciona esquemas JSON predefinidos y validados para casos de uso comunes
#' en análisis de texto con GPT. Estos esquemas garantizan respuestas estructuradas
#' y consistentes para tareas como extracción de entidades, clasificación, análisis
#' de sentimiento, resumen, pregunta-respuesta y extracción de tripletes.
#'
#' @param tipo Tipo de esquema a devolver. Opciones:
#' \itemize{
#'   \item \code{"extraccion_entidades"}: Extrae personas, organizaciones, lugares, fechas y eventos
#'   \item \code{"clasificacion"}: Clasifica el texto en categorías con nivel de confianza
#'   \item \code{"sentimiento"}: Analiza sentimiento general y por aspectos específicos
#'   \item \code{"resumen"}: Genera resúmenes cortos y detallados con puntos clave
#'   \item \code{"qa"}: Responde preguntas con citas textuales y nivel de confianza
#'   \item \code{"tripletes"}: Extrae relaciones sujeto-predicado-objeto
#' }
#'
#' @return Lista con esquema JSON compatible con OpenAI Structured Outputs.
#'   Puede usarse directamente en el parámetro `schema` de `acep_gpt()`.
#'
#' @export
#' @examples
#' # Obtener esquema para extracción de entidades
#' schema_entidades <- acep_gpt_schema("extraccion_entidades")
#' names(schema_entidades$properties)  # personas, organizaciones, lugares, fechas, eventos
#'
#' # Obtener esquema para clasificación
#' schema_clasif <- acep_gpt_schema("clasificacion")
#' names(schema_clasif$properties)  # categoria, confianza, justificacion
#'
#' # Obtener esquema para análisis de sentimiento
#' schema_sent <- acep_gpt_schema("sentimiento")
#' names(schema_sent$properties)  # sentimiento_general, puntuacion, aspectos
#'
#' # Ver todos los tipos disponibles
#' # extraccion_entidades, clasificacion, sentimiento, resumen, qa, tripletes
acep_gpt_schema <- function(tipo = "extraccion_entidades") {
  
  esquemas <- list(
    
    # Esquema para extracción de entidades
    extraccion_entidades = list(
      type = "object",
      properties = list(
        personas = list(
          type = "array",
          items = list(type = "string"),
          description = "Lista de personas mencionadas"
        ),
        organizaciones = list(
          type = "array",
          items = list(type = "string"),
          description = "Lista de organizaciones mencionadas"
        ),
        lugares = list(
          type = "array",
          items = list(type = "string"),
          description = "Lista de lugares mencionados"
        ),
        fechas = list(
          type = "array",
          items = list(type = "string"),
          description = "Lista de fechas mencionadas"
        ),
        eventos = list(
          type = "array",
          items = list(type = "string"),
          description = "Lista de eventos mencionados"
        )
      ),
      required = I(c("personas", "organizaciones", "lugares", "fechas", "eventos")),
      additionalProperties = FALSE
    ),
    
    # Esquema para clasificación
    clasificacion = list(
      type = "object",
      properties = list(
        categoria = list(
          type = "string",
          description = "Categoría principal del texto"
        ),
        confianza = list(
          type = "number",
          description = "Nivel de confianza de 0 a 1"
        ),
        justificacion = list(
          type = "string",
          description = "Breve justificación de la clasificación"
        )
      ),
      required = I(c("categoria", "confianza", "justificacion")),
      additionalProperties = FALSE
    ),
    
    # Esquema para análisis de sentimiento
    sentimiento = list(
      type = "object",
      properties = list(
        sentimiento_general = list(
          type = "string",
          enum = I(c("positivo", "negativo", "neutral")),
          description = "Sentimiento general del texto"
        ),
        puntuacion = list(
          type = "number",
          description = "Puntuación de sentimiento de -1 (muy negativo) a 1 (muy positivo)"
        ),
        aspectos = list(
          type = "array",
          items = list(
            type = "object",
            properties = list(
              aspecto = list(type = "string"),
              sentimiento = list(type = "string", enum = I(c("positivo", "negativo", "neutral")))
            ),
            required = I(c("aspecto", "sentimiento")),
            additionalProperties = FALSE
          ),
          description = "Sentimientos por aspecto específico"
        )
      ),
      required = I(c("sentimiento_general", "puntuacion", "aspectos")),
      additionalProperties = FALSE
    ),
    
    # Esquema para resumen
    resumen = list(
      type = "object",
      properties = list(
        resumen_corto = list(
          type = "string",
          description = "Resumen en una oración"
        ),
        resumen_detallado = list(
          type = "string",
          description = "Resumen detallado en 2-3 oraciones"
        ),
        puntos_clave = list(
          type = "array",
          items = list(type = "string"),
          description = "Lista de puntos clave del texto"
        )
      ),
      required = I(c("resumen_corto", "resumen_detallado", "puntos_clave")),
      additionalProperties = FALSE
    ),
    
    # Esquema para pregunta-respuesta
    qa = list(
      type = "object",
      properties = list(
        respuesta = list(
          type = "string",
          description = "Respuesta a la pregunta"
        ),
        confianza = list(
          type = "string",
          enum = I(c("alta", "media", "baja")),
          description = "Nivel de confianza en la respuesta"
        ),
        cita_textual = list(
          type = "string",
          description = "Cita textual del texto que respalda la respuesta"
        )
      ),
      required = I(c("respuesta", "confianza", "cita_textual")),
      additionalProperties = FALSE
    ),
    
    # Esquema para extracción de tripletes (sujeto-predicado-objeto)
    tripletes = list(
      type = "object",
      properties = list(
        tripletes = list(
          type = "array",
          items = list(
            type = "object",
            properties = list(
              sujeto = list(type = "string"),
              predicado = list(type = "string"),
              objeto = list(type = "string")
            ),
            required = I(c("sujeto", "predicado", "objeto")),
            additionalProperties = FALSE
          ),
          description = "Lista de tripletes extraídos del texto"
        )
      ),
      required = I(c("tripletes")),
      additionalProperties = FALSE
    )
  )
  
  if (!tipo %in% names(esquemas)) {
    stop(sprintf("Tipo de esquema no válido. Opciones: %s", paste(names(esquemas), collapse = ", ")))
  }
  
  return(esquemas[[tipo]])
}
