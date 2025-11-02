#' @title Interaccion con modelos Ollama locales usando Structured Outputs
#' @description
#' Funcion para interactuar con modelos de lenguaje locales usando Ollama.
#' Similar a acep_gpt() pero ejecuta modelos en tu computadora sin necesidad
#' de API keys ni costos. Soporta structured outputs para garantizar respuestas
#' en formato JSON que cumplen con un esquema predefinido.
#'
#' @param texto Texto a analizar. Puede ser una noticia, tweet, documento, etc.
#' @param instrucciones Instrucciones en lenguaje natural que indican al modelo que hacer
#'   con el texto. Ejemplo: "Extrae todas las entidades nombradas", "Clasifica el sentimiento".
#' @param modelo Modelo de Ollama a utilizar. Ejemplos: "qwen2.5, llama3.1", "mistral",
#'   "phi3", "gemma2". Por defecto: "qwen3:1.7b". Debe estar previamente descargado con
#'   `ollama pull nombre_modelo` desde la terminal o desde `ollamar::pull('nombre del modelo')` en consola.
#' @param schema Esquema JSON que define la estructura de la respuesta. Puede usar
#'   `acep_gpt_schema()` para obtener esquemas predefinidos o crear uno personalizado.
#'   Si es NULL, usa un esquema simple con campo "respuesta".
#' @param parse_json Logico. Si TRUE (por defecto), parsea automaticamente el JSON
#'   a un objeto R (lista o data frame). Si FALSE, devuelve el JSON como string.
#' @param temperature Parametro de temperatura (0-2). Valores bajos (0-0.3) generan
#'   respuestas mas deterministas. Valores altos (0.7-1) mas creativas. Por defecto: 0.
#' @param host URL del servidor Ollama. Por defecto: "http://localhost:11434"
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
#' }

acep_ollama <- function(texto,
                        instrucciones,
                        modelo = "qwen3:1.7b",
                        schema = NULL,
                        parse_json = TRUE,
                        temperature = 0,
                        host = "http://localhost:11434",
                        seed = 123456) {
  
  # Verificar que ollamar este instalado
  if (!requireNamespace("ollamar", quietly = TRUE)) {
    stop("El paquete 'ollamar' no esta instalado. Instalalo con: install.packages('ollamar')")
  }
  
  # Validaciones
  if (!is.character(texto) || nchar(texto) == 0) {
    stop("El parametro 'texto' debe ser una cadena de caracteres no vacia")
  }
  if (!is.character(instrucciones) || nchar(instrucciones) == 0) {
    stop("El parametro 'instrucciones' debe ser una cadena de caracteres no vacia")
  }
  
  # Verificar que Ollama este corriendo
  tryCatch({
    ollamar::list_models(host = host)
  }, error = function(e) {
    stop(paste0(
      "No se puede conectar a Ollama en ", host, ". ",
      "Asegurate de que Ollama este corriendo. ",
      "Puedes iniciarlo con 'ollama serve' en la terminal."
    ))
  })
  
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
  system_prompt <- acep_prompt_gpt$system_prompt_01_es
  
  # Construir prompt del usuario con el esquema
  user_prompt <- sprintf(
    "Texto a analizar:\n%s\n\nInstrucciones:\n%s\n\nDebes responder en formato JSON siguiendo este esquema:\n%s",
    texto,
    instrucciones,
    jsonlite::toJSON(schema, auto_unbox = TRUE, pretty = TRUE)
  )
  
  # Realizar peticion a Ollama con structured output
  tryCatch({
    # Usar ollamar::chat con formato estructurado
    respuesta <- ollamar::chat(
      model = modelo,
      messages = list(
        list(role = "system", content = system_prompt),
        list(role = "user", content = user_prompt)
      ),
      format = schema,
      temperature = temperature,
      seed = seed,
      output = "structured",
      host = host
    )
    
    # Verificar respuesta vacia
    if (is.null(respuesta)) {
      stop("Ollama devolvio una respuesta vacia. Verifica tu prompt y esquema.")
    }
    
    # Si parse_json es FALSE, convertir a JSON string
    if (!parse_json && is.list(respuesta)) {
      return(jsonlite::toJSON(respuesta, auto_unbox = TRUE, pretty = TRUE))
    }
    
    # Si ya es una lista estructurada, devolverla directamente
    return(respuesta)
    
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
  
  cat("4. INSTALAR OLLAMAR EN R:\n")
  cat("   install.packages('ollamar')  # Recomendado para structured outputs\n")
  
  cat("5. VERIFICAR INSTALACION:\n")
  cat("   ollamar::list_models()  # Debe mostrar los modelos descargados\n\n")
  
  cat("6. EJEMPLO DE USO:\n")
  cat('   texto <- "El SUTEBA convoco a un paro en Buenos Aires."\n')
  cat('   schema <- acep_gpt_schema("extraccion_entidades")\n')
  cat('   resultado <- acep_ollama(texto, "Extrae entidades", schema = schema)\n\n')
  
  invisible(NULL)
}
