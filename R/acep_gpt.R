#' @title Funcion auxiliar para proteger arrays en esquemas JSON
#' @description
#' Protege arrays en esquemas JSON para evitar que jsonlite::toJSON los convierta
#' incorrectamente. Aplica I() a campos 'required' y 'enum' recursivamente.
#' @param schema Esquema JSON como lista de R
#' @return Esquema con arrays protegidos
#' @keywords internal
proteger_arrays_schema <- function(schema) {
  if (is.list(schema)) {
    # Proteger el campo 'required' si existe
    if ("required" %in% names(schema)) {
      schema$required <- I(schema$required)
    }
    # Proteger el campo 'enum' si existe
    if ("enum" %in% names(schema)) {
      schema$enum <- I(schema$enum)
    }
    # Recursivamente proteger subesquemas
    schema <- lapply(schema, proteger_arrays_schema)
  }
  return(schema)
}

#' @title Interaccion con modelos GPT usando Structured Outputs
#' @description
#' Funcion para interactuar con la API de OpenAI utilizando Structured Outputs,
#' una funcionalidad que garantiza respuestas en formato JSON que cumplen estrictamente
#' con un esquema predefinido. Esto elimina la necesidad de parseo y validacion manual,
#' haciendo las respuestas mas confiables y estructuradas. Compatible con modelos
#' `gpt-4o` y `gpt-4o-mini`.
#'
#' @param texto Texto a analizar con GPT. Puede ser una noticia, tweet, documento, etc.
#' @param instrucciones Instrucciones en lenguaje natural que indican al modelo que hacer
#'   con el texto. Ejemplo: "Extrae todas las entidades nombradas", "Clasifica el sentimiento".
#' @param modelo Modelo de OpenAI a utilizar. Compatible con Structured Outputs:
#'   `"gpt-4o-mini"` (mas rapido y economico), `"gpt-4o"`, `"gpt-4o-2024-08-06"` (mas potente),
#'   `"gpt-4.1"`, `"gpt-5-nano"`, `"gpt-5-mini"`, `"o1-mini"`, `"o4-mini"`, entre otros.
#'   Por defecto: `"gpt-4o-mini"`. Ver: https://platform.openai.com/docs/guides/structured-outputs
#' @param api_key Clave de API de OpenAI. Si no se proporciona, busca la variable de
#'   entorno `OPENAI_API_KEY`. Para obtener una clave: https://platform.openai.com/api-keys
#' @param schema Esquema JSON que define la estructura de la respuesta. Puede usar
#'   `acep_gpt_schema()` para obtener esquemas predefinidos o crear uno personalizado.
#'   Si es `NULL`, usa un esquema simple con campo "respuesta".
#' @param parse_json Logico. Si `TRUE` (por defecto), parsea automaticamente el JSON
#'   a un objeto R (lista o data frame). Si `FALSE`, devuelve el JSON como string.
#' @param temperature Parametro de temperatura (0-2). Valores bajos (0-0.3) generan
#'   respuestas mas deterministas y consistentes. Valores altos (0.7-1) mas creativas.
#'   Por defecto: 0 (maxima determinismo).
#'   NOTA: Los modelos gpt-5, o1 y o4 solo aceptan temperature = 1 (default de OpenAI).
#' @param max_tokens Numero maximo de tokens en la respuesta. Por defecto: 2000.
#' @param top_p Parametro top-p para nucleus sampling (0-1). Controla la diversidad
#'   de la respuesta. Por defecto: 0.2.
#'   NOTA: Ignorado en modelos gpt-5, o1 y o4.
#' @param frequency_penalty Penalizacion por repeticion de tokens frecuentes (-2 a 2).
#'   Por defecto: 0.2. NOTA: Ignorado en modelos gpt-5, o1 y o4.
#' @param seed Semilla numerica para reproducibilidad. Usar el mismo seed con los
#'   mismos parametros genera respuestas identicas. Por defecto: 123456.
#'   NOTA: Ignorado en modelos gpt-5, o1 y o4.
#'
#' @return Si `parse_json=TRUE`, devuelve una lista o data frame con la respuesta
#'   estructurada segun el esquema. Si `parse_json=FALSE`, devuelve un string JSON.
#'
#' @details
#' **Diferencias entre modelos:**
#'
#' - **Modelos GPT-4o/GPT-4.1**: Soportan todos los parametros (temperature, top_p,
#'   frequency_penalty, seed). Usan `max_tokens`.
#'
#' - **Modelos GPT-5/o1/o4**: Solo aceptan temperature = 1 (default). Los parametros
#'   temperature, top_p, frequency_penalty y seed son automaticamente omitidos.
#'   Usan `max_completion_tokens` en lugar de `max_tokens`.
#'
#' La funcion maneja estas diferencias automaticamente segun el modelo especificado.
#'
#' @export
#' @examples
#' \dontrun{
#' # Extraer entidades de un texto
#' texto <- "El SUTEBA convoco a un paro en Buenos Aires el 15 de marzo."
#' instrucciones <- "Extrae todas las entidades nombradas del texto."
#' schema <- acep_gpt_schema("extraccion_entidades")
#' resultado <- acep_gpt(texto, instrucciones, schema = schema)
#' print(resultado)
#'
#' # Analisis de sentimiento
#' texto <- "La protesta fue pacifica y bien organizada."
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
    stop("El parametro 'texto' debe ser una cadena de caracteres no vacia")
  }
  if (!is.character(instrucciones) || nchar(instrucciones) == 0) {
    stop("El parametro 'instrucciones' debe ser una cadena de caracteres no vacia")
  }
  if (api_key == "") {
    stop("API key no encontrada. Define la variable de entorno OPENAI_API_KEY o pasa el parametro api_key")
  }
  
  # Validar modelo compatible con Structured Outputs
  # Segun https://platform.openai.com/docs/guides/structured-outputs
  # Structured Outputs funciona con: gpt-4o-mini, gpt-4o-2024-08-06 y versiones posteriores
  modelos_compatibles <- c(
    # Serie gpt-4o
    "gpt-4o-mini", "gpt-4o-mini-2024-07-18", "gpt-4o", "gpt-4o-2024-08-06", "gpt-4o-2024-11-20",
    # Serie gpt-4.1 (mencionado en docs de streaming)
    "gpt-4.1",
    # Serie gpt-5
    "gpt-5-nano", "gpt-5-mini",
    # Serie o1 y o4 (modelos de razonamiento)
    "o1", "o1-mini", "o1-preview", "o4-mini"
  )

  # Verificar compatibilidad - pero permitir cualquier modelo que empiece con patrones conocidos
  es_compatible <- modelo %in% modelos_compatibles ||
                   grepl("^gpt-4o", modelo) ||
                   grepl("^gpt-4\\.1", modelo) ||
                   grepl("^gpt-5", modelo) ||
                   grepl("^o1", modelo) ||
                   grepl("^o4", modelo)

  if (!es_compatible) {
    warning(sprintf("El modelo '%s' puede no ser compatible con Structured Outputs. Modelos recomendados: gpt-4o-mini, gpt-4o-2024-08-06 y versiones posteriores",
                    modelo))
  }

  # Determinar si el modelo usa max_completion_tokens en lugar de max_tokens
  # Los modelos de razonamiento (o1, o4) y gpt-5 usan max_completion_tokens
  usa_max_completion_tokens <- grepl("^gpt-5", modelo) ||
                                grepl("^o1", modelo) ||
                                grepl("^o4", modelo)

  # Determinar si el modelo solo acepta temperature = 1 (valor por defecto)
  # Los modelos gpt-5 y o1/o4 no permiten temperature = 0
  solo_temperatura_default <- grepl("^gpt-5", modelo) ||
                               grepl("^o1", modelo) ||
                               grepl("^o4", modelo)
  
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
    response_format = list(
      type = "json_schema",
      json_schema = list(
        name = "respuesta_estructurada",
        strict = TRUE,
        schema = schema
      )
    )
  )

  # Agregar parametros de generacion solo si el modelo los acepta
  # Los modelos gpt-5 y o1/o4 solo aceptan temperature = 1 (default)
  if (!solo_temperatura_default) {
    body$temperature <- temperature
    body$top_p <- top_p
    body$frequency_penalty <- frequency_penalty
    body$seed <- seed
  }

  # Agregar el parametro correcto segun el modelo
  if (usa_max_completion_tokens) {
    body$max_completion_tokens <- max_tokens
  } else {
    body$max_tokens <- max_tokens
  }
  
  # Realizar peticion a la API
  tryCatch({
    output <- httr::POST(
      url = "https://api.openai.com/v1/chat/completions",
      httr::add_headers(
        "Content-Type" = "application/json",
        "Authorization" = paste("Bearer", api_key)
      ),
      body = jsonlite::toJSON(body, auto_unbox = TRUE, pretty = FALSE),
      encode = "raw"
    )

    # Verificar codigo HTTP
    if (httr::status_code(output) != 200) {
      error_content <- httr::content(output, as = "parsed")
      stop(sprintf("Error HTTP %d: %s",
                   httr::status_code(output),
                   error_content$error$message))
    }

    # Extraer respuesta
    respuesta_json <- httr::content(output, as = "parsed")$choices[[1]]$message$content

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
    stop(sprintf("Error al interactuar con la API de OpenAI: %s", conditionMessage(e)))
  })
}


#' @title Esquemas JSON predefinidos para analisis de texto con GPT
#' @description
#' Proporciona esquemas JSON predefinidos y validados para casos de uso comunes
#' en analisis de texto con GPT. Estos esquemas garantizan respuestas estructuradas
#' y consistentes para tareas como extraccion de entidades, clasificacion, analisis
#' de sentimiento, resumen, pregunta-respuesta, extraccion de tripletes y analisis
#' de acciones de protesta.
#'
#' @param tipo Tipo de esquema a devolver. Opciones:
#' \itemize{
#'   \item \code{"extraccion_entidades"}: Extrae personas, organizaciones, lugares, fechas y eventos
#'   \item \code{"clasificacion"}: Clasifica el texto en categorias con nivel de confianza
#'   \item \code{"sentimiento"}: Analiza sentimiento general y por aspectos especificos
#'   \item \code{"resumen"}: Genera resumenes cortos y detallados con puntos clave
#'   \item \code{"qa"}: Responde preguntas con citas textuales y nivel de confianza
#'   \item \code{"tripletes"}: Extrae relaciones sujeto-predicado-objeto
#'   \item \code{"protesta_breve"}: Extrae informacion basica de acciones de protesta (fecha, sujeto, accion, objeto, lugar)
#'   \item \code{"protesta_detallada"}: Extrae informacion detallada de multiples acciones de protesta con 9 campos por accion
#' }
#'
#' @return Lista con esquema JSON compatible con OpenAI Structured Outputs.
#'   Puede usarse directamente en el parametro `schema` de `acep_gpt()` o `acep_ollama()`.
#'
#' @export
#' @examples
#' # Obtener esquema para extraccion de entidades
#' schema_entidades <- acep_gpt_schema("extraccion_entidades")
#' names(schema_entidades$properties)  # personas, organizaciones, lugares, fechas, eventos
#'
#' # Obtener esquema para clasificacion
#' schema_clasif <- acep_gpt_schema("clasificacion")
#' names(schema_clasif$properties)  # categoria, confianza, justificacion
#'
#' # Obtener esquema para analisis de sentimiento
#' schema_sent <- acep_gpt_schema("sentimiento")
#' names(schema_sent$properties)  # sentimiento_general, puntuacion, aspectos
#'
#' # Obtener esquema para analisis breve de protestas
#' schema_protesta <- acep_gpt_schema("protesta_breve")
#' names(schema_protesta$properties)  # fecha, sujeto, accion, objeto, lugar
#'
#' # Obtener esquema para analisis detallado de protestas
#' schema_protesta_det <- acep_gpt_schema("protesta_detallada")
#' names(schema_protesta_det$properties)  # acciones (array con 9 campos cada una)
acep_gpt_schema <- function(tipo = "extraccion_entidades") {
  
  esquemas <- list(
    
    # Esquema para extraccion de entidades
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
      required = c("personas", "organizaciones", "lugares", "fechas", "eventos"),
      additionalProperties = FALSE
    ),

    # Esquema para clasificacion
    clasificacion = list(
      type = "object",
      properties = list(
        categoria = list(
          type = "string",
          description = "Categoria principal del texto"
        ),
        confianza = list(
          type = "number",
          description = "Nivel de confianza de 0 a 1"
        ),
        justificacion = list(
          type = "string",
          description = "Breve justificacion de la clasificacion"
        )
      ),
      required = c("categoria", "confianza", "justificacion"),
      additionalProperties = FALSE
    ),

    # Esquema para analisis de sentimiento
    sentimiento = list(
      type = "object",
      properties = list(
        sentimiento_general = list(
          type = "string",
          enum = c("positivo", "negativo", "neutral"),
          description = "Sentimiento general del texto"
        ),
        puntuacion = list(
          type = "number",
          description = "Puntuacion de sentimiento de -1 (muy negativo) a 1 (muy positivo)"
        ),
        aspectos = list(
          type = "array",
          items = list(
            type = "object",
            properties = list(
              aspecto = list(type = "string"),
              sentimiento = list(type = "string", enum = c("positivo", "negativo", "neutral"))
            ),
            required = c("aspecto", "sentimiento"),
            additionalProperties = FALSE
          ),
          description = "Sentimientos por aspecto especifico"
        )
      ),
      required = c("sentimiento_general", "puntuacion", "aspectos"),
      additionalProperties = FALSE
    ),

    # Esquema para resumen
    resumen = list(
      type = "object",
      properties = list(
        resumen_corto = list(
          type = "string",
          description = "Resumen en una oracion"
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
      required = c("resumen_corto", "resumen_detallado", "puntos_clave"),
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
          enum = c("alta", "media", "baja"),
          description = "Nivel de confianza en la respuesta"
        ),
        cita_textual = list(
          type = "string",
          description = "Cita textual del texto que respalda la respuesta"
        )
      ),
      required = c("respuesta", "confianza", "cita_textual"),
      additionalProperties = FALSE
    ),

    # Esquema para extraccion de tripletes (sujeto-predicado-objeto)
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
            required = c("sujeto", "predicado", "objeto"),
            additionalProperties = FALSE
          ),
          description = "Lista de tripletes extraidos del texto"
        )
      ),
      required = c("tripletes"),
      additionalProperties = FALSE
    ),
    
    # Esquema para analisis breve de protestas
    protesta_breve = list(
      type = "object",
      properties = list(
        fecha = list(
          type = "string",
          description = "Fecha de la accion de protesta en formato yyyy-mm-dd"
        ),
        sujeto = list(
          type = "string",
          description = "Quien realiza la accion de protesta (maximo 5 palabras)"
        ),
        accion = list(
          type = "string",
          description = "Formato de la accion de protesta (maximo 3 palabras)"
        ),
        objeto = list(
          type = "string",
          description = "Contra quien o que se realiza la accion de protesta (maximo 6 palabras). Usar null si no hay informacion"
        ),
        lugar = list(
          type = "string",
          description = "Localizacion geografica de la accion de protesta (maximo 4 palabras). Usar null si no hay informacion"
        )
      ),
      required = c("fecha", "sujeto", "accion", "objeto", "lugar"),
      additionalProperties = FALSE
    ),

    # Esquema para analisis detallado de protestas
    protesta_detallada = list(
      type = "object",
      properties = list(
        acciones = list(
          type = "array",
          items = list(
            type = "object",
            properties = list(
              id = list(
                type = "number",
                description = "Identificador unico del texto en formato numerico. Se repite para todas las acciones"
              ),
              cronica = list(
                type = "string",
                description = "Resumen de la accion identificada en una frase"
              ),
              fecha = list(
                type = "string",
                description = "Fecha de la accion de protesta en formato yyyy-mm-dd. Se repite para todas las acciones"
              ),
              sujeto = list(
                type = "string",
                description = "Quien realiza la accion de protesta (maximo 5 palabras)"
              ),
              organizacion = list(
                type = "string",
                description = "Organizaciones participantes en la accion de protesta. Si no hay informacion, repetir el valor de sujeto"
              ),
              participacion = list(
                type = "number",
                description = "Numero de individuos que participaron en la accion de protesta. Si no hay informacion, usar 0"
              ),
              accion = list(
                type = "string",
                description = "Descripcion de la accion de protesta (maximo 3 palabras)"
              ),
              objeto = list(
                type = "string",
                description = "Contra quien o que se lleva a cabo la accion de protesta (maximo 6 palabras). Usar null si no hay informacion"
              ),
              lugar = list(
                type = "string",
                description = "Localidad o ubicacion geografica de la accion de protesta (maximo 4 palabras)"
              )
            ),
            required = c("id", "cronica", "fecha", "sujeto", "organizacion", "participacion", "accion", "objeto", "lugar"),
            additionalProperties = FALSE
          ),
          description = "Lista de acciones de protesta identificadas en el texto. Cada accion es una unidad de analisis independiente"
        )
      ),
      required = c("acciones"),
      additionalProperties = FALSE
    )
  )
  
  if (!tipo %in% names(esquemas)) {
    stop(sprintf("Tipo de esquema no valido. Opciones: %s", paste(names(esquemas), collapse = ", ")))
  }
  
  return(proteger_arrays_schema(esquemas[[tipo]]))
}
