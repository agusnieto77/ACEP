#' @title Interaccion con modelos Ollama locales y cloud usando Structured Outputs
#' @description
#' Funcion para interactuar con modelos de lenguaje usando Ollama.
#' Soporta tanto modelos locales (ejecutados en tu computadora sin costos)
#' como modelos cloud de Ollama (modelos grandes como DeepSeek 671B, Qwen3 Coder 480B,
#' Kimi 1T que se ejecutan en la nube sin necesidad de GPU local).
#' Utiliza structured outputs para garantizar respuestas en formato JSON que
#' cumplen con un esquema predefinido.
#'
#' @param texto Texto a analizar. Puede ser una noticia, tweet, documento, etc.
#' @param instrucciones Instrucciones en lenguaje natural que indican al modelo que hacer
#'   con el texto. Ejemplo: "Extrae todas las entidades nombradas", "Clasifica el sentimiento".
#' @param modelo Modelo de Ollama a utilizar.
#'   - Para Ollama local: "qwen3:1.7b", "llama3.2:latest", "mistral", "phi3", "gemma2"
#'     (debe estar previamente descargado con `ollama pull nombre_modelo`)
#'   - Para Ollama Cloud API: modelos cloud especificos disponibles sin GPU local:
#'     "deepseek-v3.1:671b-cloud", "gpt-oss:20b-cloud", "gpt-oss:120b-cloud",
#'     "kimi-k2:1t-cloud", "qwen3-coder:480b-cloud", "glm-4.6:cloud", "minimax-m2:cloud"
#'   Por defecto: "qwen3:1.7b"
#' @param schema Esquema JSON que define la estructura de la respuesta. Puede usar
#'   `acep_gpt_schema()` para obtener esquemas predefinidos o crear uno personalizado.
#'   Si es NULL, usa un esquema simple con campo "respuesta".
#' @param parse_json Logico. Si TRUE (por defecto), parsea automaticamente el JSON
#'   a un objeto R (lista o data frame). Si FALSE, devuelve el JSON como string.
#' @param temperature Parametro de temperatura (0-2). Valores bajos (0-0.3) generan
#'   respuestas mas deterministas. Valores altos (0.7-1) mas creativas. Por defecto: 0.
#' @param max_tokens Numero maximo de tokens en la respuesta. Por defecto: 4000.
#' @param host URL del servidor Ollama. Por defecto: "http://localhost:11434" para uso local.
#'   Para usar Ollama Cloud API, especificar "https://ollama.com" (sin /api, se agrega automaticamente).
#' @param api_key API key para Ollama API remota. Solo requerido si usas un servidor remoto.
#'   Por defecto busca la variable de entorno OLLAMA_API_KEY. Para uso local (localhost) no es necesario.
#' @param seed Semilla numerica para reproducibilidad. Por defecto: 123456.
#'
#' @return Si parse_json=TRUE, devuelve una lista o data frame con la respuesta
#'   estructurada segun el esquema. Si parse_json=FALSE, devuelve un string JSON.
#'
#' @export
#' @examples
#' \dontrun{
#' # Primero, instalar Ollama y descargar un modelo:
#' # Terminal: ollama pull llama3.1
#'
#' # Extraer entidades de un texto
#' texto <- "El SUTEBA convoco a un paro en Buenos Aires el 15 de marzo."
#' instrucciones <- "Extrae todas las entidades nombradas del texto."
#' schema <- acep_gpt_schema("extraccion_entidades")
#' resultado <- acep_ollama(texto, instrucciones, schema = schema)
#' print(resultado)
#'
#' # Analisis de sentimiento
#' texto <- "La protesta fue pacifica y bien organizada."
#' schema <- acep_gpt_schema("sentimiento")
#' resultado <- acep_ollama(texto, "Analiza el sentimiento del texto", schema = schema)
#' print(resultado$sentimiento_general)
#'
#' # Usar Ollama Cloud API (requiere API key)
#' # Los modelos cloud se ejecutan sin necesidad de GPU local
#' Sys.setenv(OLLAMA_API_KEY = "tu-api-key")
#' resultado_remoto <- acep_ollama(
#'   texto = texto,
#'   instrucciones = "Extrae entidades",
#'   modelo = "deepseek-v3.1:671b-cloud",  # Modelo cloud de 671B parametros
#'   host = "https://ollama.com",
#'   schema = acep_gpt_schema("extraccion_entidades")
#' )
#'
#' }

acep_ollama <- function(texto,
                        instrucciones,
                        modelo = "qwen3:1.7b",
                        schema = NULL,
                        parse_json = TRUE,
                        temperature = 0,
                        max_tokens = 4000,
                        host = "http://localhost:11434",
                        api_key = Sys.getenv("OLLAMA_API_KEY"),
                        seed = 123456) {

  # Validaciones
  if (!is.character(texto) || nchar(texto) == 0) {
    stop("El parametro 'texto' debe ser una cadena de caracteres no vacia")
  }
  if (!is.character(instrucciones) || nchar(instrucciones) == 0) {
    stop("El parametro 'instrucciones' debe ser una cadena de caracteres no vacia")
  }

  # Detectar si es servidor remoto o local
  is_remote <- !grepl("localhost|127\\.0\\.0\\.1", host, ignore.case = TRUE)

  # Si es servidor remoto, verificar API key
  if (is_remote && (is.null(api_key) || api_key == "")) {
    stop(paste0(
      "Para usar Ollama API remota (", host, ") necesitas proporcionar un api_key. ",
      "Define la variable de entorno OLLAMA_API_KEY o pasa el parametro api_key."
    ))
  }

  # Verificar que Ollama este corriendo (solo para localhost)
  if (!is_remote) {
    tryCatch({
      test_response <- httr::GET(paste0(host, "/api/tags"), httr::timeout(5))
      if (httr::status_code(test_response) != 200) {
        stop("Ollama no responde")
      }
    }, error = function(e) {
      stop(paste0(
        "No se puede conectar a Ollama en ", host, ". ",
        "Asegurate de que Ollama este corriendo. ",
        "Puedes iniciarlo con 'ollama serve' en la terminal."
      ))
    })
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
      required = c("respuesta"),
      additionalProperties = FALSE
    )
  }

  # Construir prompt del sistema
  system_prompt <- ACEP::acep_prompt_gpt$system_prompt_01_es

  # Construir prompt del usuario con el esquema
  user_prompt <- sprintf(
    "Texto a analizar:\n%s\n\nInstrucciones:\n%s\n\nDebes responder en formato JSON siguiendo este esquema:\n%s",
    texto,
    instrucciones,
    jsonlite::toJSON(schema, auto_unbox = TRUE, pretty = TRUE)
  )

  # Realizar peticion a Ollama con structured output
  tryCatch({
    if (is_remote) {
      # Para servidores remotos, usar httr directamente con endpoint /api/chat
      api_url <- paste0(host, "/api/chat")

      # Construir body de la peticion siguiendo formato Ollama chat
      body <- list(
        model = modelo,
        messages = list(
          list(role = "system", content = system_prompt),
          list(role = "user", content = user_prompt)
        ),
        format = schema,
        stream = FALSE,
        options = list(
          temperature = temperature,
          seed = seed,
          num_predict = max_tokens
        )
      )

      # Realizar peticion con o sin autenticacion
      if (!is.null(api_key) && api_key != "") {
        # Con API key (Ollama Cloud)
        output <- httr::POST(
          url = api_url,
          body = jsonlite::toJSON(body, auto_unbox = TRUE),
          httr::add_headers(
            "Content-Type" = "application/json",
            "Authorization" = paste("Bearer", api_key)
          ),
          httr::timeout(120)
        )
      } else {
        # Sin API key (servidor remoto sin auth)
        output <- httr::POST(
          url = api_url,
          body = jsonlite::toJSON(body, auto_unbox = TRUE),
          httr::content_type_json(),
          httr::timeout(120)
        )
      }

      # Verificar codigo HTTP
      if (httr::status_code(output) != 200) {
        error_content <- httr::content(output, as = "text", encoding = "UTF-8")
        stop(sprintf("Error HTTP %d: %s", httr::status_code(output), error_content))
      }

      # Extraer respuesta
      contenido <- httr::content(output, as = "text", encoding = "UTF-8")
      respuesta_parsed <- jsonlite::fromJSON(contenido)

      # Verificar si la respuesta fue truncada por limite de tokens
      # Ollama usa done_reason: "length" cuando se alcanza el límite
      if (!is.null(respuesta_parsed$done_reason) && respuesta_parsed$done_reason == "length") {
        stop("La respuesta fue truncada debido al limite de max_tokens. Se necesitan mas tokens para obtener una respuesta valida. Aumenta el valor de max_tokens.")
      }

      # La respuesta de Ollama chat API viene en message.content
      # Nota: algunos modelos razonadores (como qwen3) pueden tener "content" vacío
      # y el JSON en "thinking"
      respuesta_json <- respuesta_parsed$message$content

      # Si response está vacío pero hay thinking, usar thinking
      if ((is.null(respuesta_json) || nchar(respuesta_json) == 0) && !is.null(respuesta_parsed$message$thinking)) {
        respuesta_json <- respuesta_parsed$message$thinking
      }

      # Verificar respuesta vacia
      if (is.null(respuesta_json) || nchar(respuesta_json) == 0) {
        stop("Ollama devolvio una respuesta vacia. Verifica tu prompt y esquema.")
      }

      # Limpiar JSON de markdown si es necesario
      # Algunos modelos envuelven el JSON en ```json...``` o ```...```
      respuesta_json <- gsub("```json|```", "", respuesta_json)
      respuesta_json <- trimws(respuesta_json)

      # Parsear JSON si se solicita
      if (parse_json) {
        respuesta <- jsonlite::fromJSON(respuesta_json, simplifyVector = TRUE)
        return(respuesta)
      } else {
        return(respuesta_json)
      }

    } else {
      # Para servidores locales, usar httr directamente (mismo comportamiento que remoto)
      api_url <- paste0(host, "/api/chat")

      # Construir body de la peticion siguiendo formato Ollama chat
      body <- list(
        model = modelo,
        messages = list(
          list(role = "system", content = system_prompt),
          list(role = "user", content = user_prompt)
        ),
        format = schema,
        stream = FALSE,
        options = list(
          temperature = temperature,
          seed = seed,
          num_predict = max_tokens
        )
      )

      # Realizar peticion local sin autenticacion
      output <- httr::POST(
        url = api_url,
        body = jsonlite::toJSON(body, auto_unbox = TRUE),
        httr::content_type_json(),
        httr::timeout(120)
      )

      # Verificar codigo HTTP
      if (httr::status_code(output) != 200) {
        error_content <- httr::content(output, as = "text", encoding = "UTF-8")
        stop(sprintf("Error HTTP %d: %s", httr::status_code(output), error_content))
      }

      # Extraer respuesta (misma lógica que para servidores remotos)
      contenido <- httr::content(output, as = "text", encoding = "UTF-8")
      respuesta_parsed <- jsonlite::fromJSON(contenido)

      # Verificar si la respuesta fue truncada por limite de tokens
      # Ollama usa done_reason: "length" cuando se alcanza el límite
      if (!is.null(respuesta_parsed$done_reason) && respuesta_parsed$done_reason == "length") {
        stop("La respuesta fue truncada debido al limite de max_tokens. Se necesitan mas tokens para obtener una respuesta valida. Aumenta el valor de max_tokens.")
      }

      # La respuesta de Ollama chat API viene en message.content
      # Nota: algunos modelos razonadores (como qwen3) pueden tener "content" vacío
      # y el JSON en "thinking"
      respuesta_json <- respuesta_parsed$message$content

      # Si response está vacío pero hay thinking, usar thinking
      if ((is.null(respuesta_json) || nchar(respuesta_json) == 0) && !is.null(respuesta_parsed$message$thinking)) {
        respuesta_json <- respuesta_parsed$message$thinking
      }

      # Verificar respuesta vacia
      if (is.null(respuesta_json) || nchar(respuesta_json) == 0) {
        stop("Ollama devolvio una respuesta vacia. Verifica tu prompt y esquema.")
      }

      # Limpiar JSON de markdown si es necesario
      # Algunos modelos envuelven el JSON en ```json...``` o ```...```
      respuesta_json <- gsub("```json|```", "", respuesta_json)
      respuesta_json <- trimws(respuesta_json)

      # Parsear JSON si se solicita
      if (parse_json) {
        respuesta <- jsonlite::fromJSON(respuesta_json, simplifyVector = TRUE)
        return(respuesta)
      } else {
        return(respuesta_json)
      }
    }

  }, error = function(e) {
    stop(sprintf("Error al interactuar con Ollama: %s", conditionMessage(e)))
  })
}

#' @title Guia de instalacion y uso de Ollama
#' @description
#' Imprime instrucciones para instalar y configurar Ollama en tu sistema.
#'
#' @export
acep_ollama_setup <- function() {
  cat("=== GUIA DE INSTALACION DE OLLAMA ===\n\n")

  cat("1. INSTALAR OLLAMA:\n")
  cat("   - Linux/Mac: curl -fsSL https://ollama.com/install.sh | sh\n")
  cat("   - Windows: Descargar desde https://ollama.com/download\n\n")

  cat("2. INICIAR OLLAMA:\n")
  cat("   - Terminal: ollama serve\n")
  cat("   - (En Windows, Ollama se inicia automaticamente)\n\n")

  cat("3. DESCARGAR MODELOS:\n")
  cat("   - Terminal: ollama pull llama3.1\n")
  cat("   - Otros modelos: llama3.2, mistral, phi3, gemma2\n")
  cat("   - Ver todos: https://ollama.com/search \n\n")

  cat("4. VERIFICAR INSTALACION:\n")
  cat("   - Terminal: ollama list  # Debe mostrar los modelos descargados\n")
  cat("   - En R, acep_ollama se conecta automaticamente via httr\n\n")

  cat("5. PAQUETES R NECESARIOS:\n")
  cat("   install.packages(c('httr', 'jsonlite'))  # Ya incluidos con ACEP\n\n")

  cat("6. EJEMPLO DE USO:\n")
  cat('   texto <- "El SUTEBA convoco a un paro en Buenos Aires."\n')
  cat('   schema <- acep_gpt_schema("extraccion_entidades")\n')
  cat('   resultado <- acep_ollama(texto, "Extrae entidades", schema = schema)\n\n')

  invisible(NULL)
}
