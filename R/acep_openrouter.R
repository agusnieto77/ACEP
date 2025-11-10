#' @title Interaccion con modelos de IA usando OpenRouter
#' @description
#' Funcion para interactuar con multiples proveedores de IA (OpenAI, Anthropic, Google,
#' Meta, etc.) a traves de la API unificada de OpenRouter. Soporta Structured Outputs
#' para modelos compatibles (OpenAI GPT-4o+, Fireworks, y otros). OpenRouter normaliza
#' las diferencias entre proveedores, permitiendo acceder a 400+ modelos con una sola API.
#' Ideal para comparar modelos o usar fallbacks automaticos.
#'
#' @section MODELOS COMPATIBLES Y PROBADOS (ACTUALIZADO):
#' \subsection{OpenAI - Familia GPT-5 (Ultima Generacion)}{
#' \itemize{
#'   \item \code{openai/gpt-5} - Modelo principal GPT-5
#'   \item \code{openai/gpt-5-pro} - Version Pro, maxima precision
#'   \item \code{openai/gpt-5-mini} - Version mini, economica
#'   \item \code{openai/gpt-5-nano} - Version nano, ultrarrapida
#'   \item \code{openai/gpt-5-chat} - Optimizado para chat
#' }
#' }
#' \subsection{OpenAI - Familia GPT-4.1}{
#' \itemize{
#'   \item \code{openai/gpt-4.1} - Modelo principal GPT-4.1
#'   \item \code{openai/gpt-4.1-mini} - Version mini
#'   \item \code{openai/gpt-4.1-nano} - Version nano
#' }
#' }
#' \subsection{OpenAI - Familia GPT-4}{
#' \itemize{
#'   \item \code{openai/gpt-4o} - GPT-4 optimizado
#'   \item \code{openai/gpt-4o-mini} - Economico, rapido, ideal para produccion
#'   \item \code{openai/gpt-4-turbo} - Version turbo
#'   \item \code{openai/gpt-4} - Modelo base GPT-4
#' }
#' }
#' \subsection{OpenAI - Familia GPT-3.5}{
#' \itemize{
#'   \item \code{openai/gpt-3.5-turbo} - Version turbo, economica
#' }
#' }
#' \subsection{OpenAI - Modelos OSS (Open Source Style)}{
#' \itemize{
#'   \item \code{openai/gpt-oss-120b} - Modelo grande (120B parametros)
#'   \item \code{openai/gpt-oss-120b:exacto} - Version exacta
#'   \item \code{openai/gpt-oss-20b} - Modelo pequeno (20B parametros)
#'   \item \code{openai/gpt-oss-20b:free} - Version gratuita
#' }
#' }
#' \subsection{xAI - Familia Grok 4 (Ultima Generacion)}{
#' \itemize{
#'   \item \code{x-ai/grok-4} - Modelo principal Grok 4
#'   \item \code{x-ai/grok-4-fast} - Version rapida, optimizada
#' }
#' }
#' \subsection{xAI - Familia Grok 3}{
#' \itemize{
#'   \item \code{x-ai/grok-3} - Modelo principal Grok 3
#'   \item \code{x-ai/grok-3-mini} - Version mini, economica
#'   \item \code{x-ai/grok-3-beta} - Version beta
#'   \item \code{x-ai/grok-3-mini-beta} - Version mini beta
#' }
#' }
#' \subsection{DeepSeek - Familia V3 (Ultima Generacion)}{
#' \itemize{
#'   \item \code{deepseek/deepseek-v3.2-exp} - Version experimental 3.2
#'   \item \code{deepseek/deepseek-v3.1-terminus} - Version terminus 3.1
#'   \item \code{deepseek/deepseek-v3.1-terminus:exacto} - Version terminus exacta
#' }
#' }
#' \subsection{DeepSeek - Familia R1 (Razonamiento)}{
#' \itemize{
#'   \item \code{deepseek/deepseek-r1-0528} - Version R1 de mayo 2028
#'   \item \code{deepseek/deepseek-r1} - Modelo principal R1
#'   \item \code{deepseek/deepseek-r1:free} - Version R1 gratuita
#' }
#' }
#' \subsection{DeepSeek - R1 Distilled (Basado en Llama)}{
#' \itemize{
#'   \item \code{deepseek/deepseek-r1-distill-llama-70b} - R1 destilado en Llama 70B
#'   \item \code{deepseek/deepseek-r1-distill-llama-70b:free} - Version gratuita
#' }
#' }
#' \subsection{DeepSeek - Chat y Otros}{
#' \itemize{
#'   \item \code{deepseek/deepseek-chat} - Optimizado para chat
#' }
#' }
#' \subsection{DeepCogito - Modelos Especializados}{
#' \itemize{
#'   \item \code{deepcogito/cogito-v2-preview-deepseek-671b} - Modelo cogito 671B basado en DeepSeek
#' }
#' }
#' \subsection{Meta Llama - Familia 4}{
#' \itemize{
#'   \item \code{meta-llama/llama-4-maverick} - Llama 4 Maverick
#' }
#' }
#' \subsection{Meta Llama - Familia 3.3}{
#' \itemize{
#'   \item \code{meta-llama/llama-3.3-70b-instruct} - Version de pago
#'   \item \code{meta-llama/llama-3.3-70b-instruct:free} - Version gratuita
#' }
#' }
#' \subsection{Meta Llama - Familia 3.2}{
#' \itemize{
#'   \item \code{meta-llama/llama-3.2-90b-vision-instruct} - Con capacidades de vision
#' }
#' }
#' \subsection{Meta Llama - Familia 3.1}{
#' \itemize{
#'   \item \code{meta-llama/llama-3.1-405b-instruct} - Modelo grande 405B
#'   \item \code{meta-llama/llama-3.1-70b-instruct} - Modelo mediano 70B
#' }
#' }
#' \subsection{NousResearch - Modelos Hermes}{
#' \itemize{
#'   \item \code{nousresearch/hermes-3-llama-3.1-405b} - Hermes 3 basado en Llama 405B
#' }
#' }
#' \subsection{Mistral AI - Familia Magistral}{
#' \itemize{
#'   \item \code{mistralai/magistral-medium-2506} - Magistral medium
#'   \item \code{mistralai/magistral-medium-2506:thinking} - Con razonamiento extendido
#' }
#' }
#' \subsection{Mistral AI - Otros Modelos}{
#' \itemize{
#'   \item \code{mistralai/mistral-large-2407} - Mistral large
#'   \item \code{mistralai/mixtral-8x22b-instruct} - Mixtral 8x22B (MoE)
#' }
#' }
#' \subsection{MoonshotAI - Familia Kimi K2}{
#' \itemize{
#'   \item \code{moonshotai/kimi-k2} - Modelo principal Kimi K2
#'   \item \code{moonshotai/kimi-k2-0905} - Version 09/05
#'   \item \code{moonshotai/kimi-k2-0905:exacto} - Version exacta
#'   \item \code{moonshotai/kimi-k2-thinking} - Con razonamiento extendido
#' }
#' }
#' \subsection{Qwen - Familia Qwen3 (235B - Modelos Grandes)}{
#' \itemize{
#'   \item \code{qwen/qwen3-235b-a22b-2507} - Modelo grande 235B (version 2507)
#'   \item \code{qwen/qwen3-235b-a22b} - Modelo grande 235B
#'   \item \code{qwen/qwen3-235b-a22b-thinking-2507} - Con razonamiento extendido
#'   \item \code{qwen/qwen3-max} - Version maxima
#' }
#' }
#' \subsection{Qwen - Familia Qwen3 (30B-80B - Modelos Medianos)}{
#' \itemize{
#'   \item \code{qwen/qwen3-next-80b-a3b-instruct} - Modelo next 80B
#'   \item \code{qwen/qwen3-32b} - Modelo 32B
#'   \item \code{qwen/qwen3-30b-a3b} - Modelo 30B
#'   \item \code{qwen/qwen3-30b-a3b-instruct-2507} - Version instruct 2507
#'   \item \code{qwen/qwen3-30b-a3b:free} - Version 30B gratuita
#' }
#' }
#' \subsection{Qwen - Familia Qwen3 (Modelos Pequenos)}{
#' \itemize{
#'   \item \code{qwen/qwen3-14b:free} - Modelo 14B gratuito
#'   \item \code{qwen/qwen3-4b:free} - Modelo 4B gratuito, ultrarrapido
#' }
#' }
#' \subsection{Qwen - Familia Qwen 2.5}{
#' \itemize{
#'   \item \code{qwen/qwen-2.5-72b-instruct} - Modelo 2.5 generacion anterior
#'   \item \code{qwen/qwen-plus} - Version plus
#' }
#' }
#' \subsection{Google Gemini - Familia 2.5 (Ultima Generacion)}{
#' \itemize{
#'   \item \code{google/gemini-2.5-flash} - Rapido, ultima generacion
#'   \item \code{google/gemini-2.5-pro} - Mayor precision, ultima generacion
#'   \item \code{google/gemini-2.5-flash-lite} - Ultrarrapido, ligero
#'   \item \code{google/gemini-2.5-flash-preview-09-2025} - Preview version septiembre
#'   \item \code{google/gemini-2.5-flash-lite-preview-09-2025} - Preview lite septiembre
#' }
#' }
#' \subsection{Google Gemini - Familia 2.0}{
#' \itemize{
#'   \item \code{google/gemini-2.0-flash-001} - Version estable 2.0
#'   \item \code{google/gemini-2.0-flash-lite-001} - Version ligera 2.0
#' }
#' }
#' \subsection{Google Gemini - Familia 1.5}{
#' \itemize{
#'   \item \code{google/gemini-pro-1.5} - Version anterior, estable
#' }
#' }
#' \subsection{Anthropic Claude - Familia Haiku (Rapidos y Economicos)}{
#' \itemize{
#'   \item \code{anthropic/claude-3.5-haiku} - Version 3.5, muy rapido
#'   \item \code{anthropic/claude-3-haiku} - Version 3, economico
#'   \item \code{anthropic/claude-haiku-4.5} - Ultima version, mas preciso
#' }
#' }
#' \subsection{Anthropic Claude - Familia Sonnet (Equilibrados)}{
#' \itemize{
#'   \item \code{anthropic/claude-3.5-sonnet} - Popular, buen balance
#'   \item \code{anthropic/claude-3.7-sonnet} - Version mejorada
#'   \item \code{anthropic/claude-3.7-sonnet:thinking} - Con razonamiento extendido
#'   \item \code{anthropic/claude-sonnet-4} - Generacion 4
#'   \item \code{anthropic/claude-sonnet-4.5} - Ultima version, mas preciso
#' }
#' }
#' \subsection{Anthropic Claude - Familia Opus (Maxima Precision)}{
#' \itemize{
#'   \item \code{anthropic/claude-3-opus} - Version 3, muy preciso
#'   \item \code{anthropic/claude-opus-4} - Generacion 4
#'   \item \code{anthropic/claude-opus-4.1} - Ultima version disponible
#' }
#' }
#' **Importante:** los modelos etiquetados como `:free` operan con cuotas comunitarias
#' y suelen estar sometidos a limites de tasa estrictos por parte de OpenRouter. Es
#' frecuente recibir respuestas HTTP 429 (Too Many Requests) cuando la demanda supera
#' la cuota disponible; este codigo indica que el proveedor rechazo la peticion para
#' proteger la infraestructura compartida. Si ocurre, espera unos segundos y reintenta,
#' o selecciona la variante de pago equivalente (sin sufijo `:free`) o activa `use_fallback`
#' para que OpenRouter cambie automaticamente a un modelo disponible.
#'
#' @param texto Texto a analizar. Puede ser una noticia, tweet, documento, etc.
#' @param instrucciones Instrucciones en lenguaje natural que indican al modelo que hacer
#'   con el texto. Ejemplo: "Extrae todas las entidades nombradas", "Clasifica el sentimiento".
#' @param modelo Modelo a utilizar con formato "proveedor/modelo". Ejemplos populares:
#'   - OpenAI: `"openai/gpt-4o-mini"` (rapido y economico), `"openai/gpt-4o"` (potente)
#'   - Anthropic: `"anthropic/claude-sonnet-4.5"`, `"anthropic/claude-3.5-haiku"`
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
#'   proveedor primario falla. Por defecto: FALSE (sin fallbacks).
#' @param fallback_provider_order Vector opcional de slugs de proveedores para forzar
#'   un orden especifico de enrutamiento (ej.: `c("openai", "anthropic")`). Requiere
#'   `use_fallback = TRUE` para habilitar intentos sucesivos.
#' @param fallback_models Vector opcional de modelos alternativos (en formato
#'   `"proveedor/modelo"`) que se probaran en orden si el modelo principal devuelve un
#'   error recuperable (429, 5xx, timeouts). Ideal para definir variantes pagas cuando
#'   la version `:free` alcance su limite.
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
#' Cuando `use_fallback = TRUE`, la funcion configura el objeto `provider` de OpenRouter
#' para conservar la resiliencia ante errores transitorios y, si se define
#' `fallback_models`, intenta llamar secuencialmente a cada modelo alternativo ante
#' codigos recuperables (429, 5xx, timeouts). Esto evita depender del campo `route`,
#' ya deprecado en la API.
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
#'                                      modelo = "anthropic/claude-sonnet-4.5",
#'                                      schema = acep_gpt_schema("extraccion_entidades"))
#'
#' # Usar modelo gratuito
#' resultado_free <- acep_openrouter(texto, "Clasifica el sentimiento",
#'                                    modelo = "meta-llama/llama-4-maverick:free",
#'                                    schema = acep_gpt_schema("sentimiento"))
#'
#' # Definir fallback hacia variantes pagas o proveedores alternativos
#' resultado_resiliente <- acep_openrouter(
#'   texto,
#'   "Extrae las entidades nombradas",
#'   modelo = "meta-llama/llama-4-maverick:free",
#'   schema = acep_gpt_schema("extraccion_entidades"),
#'   use_fallback = TRUE,
#'   fallback_models = c("meta-llama/llama-4-maverick", "openai/gpt-4o-mini")
#' )
#'
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
                            use_fallback = FALSE,
                            fallback_provider_order = NULL,
                            fallback_models = NULL) {

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
  if (!is.logical(use_fallback) || length(use_fallback) != 1 || is.na(use_fallback)) {
    stop("El parametro 'use_fallback' debe ser TRUE o FALSE")
  }
  if (!is.null(fallback_provider_order)) {
    if (!is.character(fallback_provider_order) || length(fallback_provider_order) == 0) {
      stop("El parametro 'fallback_provider_order' debe ser un vector de caracteres con al menos un proveedor")
    }
    if (any(!nzchar(fallback_provider_order))) {
      stop("Los valores de 'fallback_provider_order' no pueden ser cadenas vacias")
    }
    if (!use_fallback) {
      stop("Para usar 'fallback_provider_order' debes activar 'use_fallback = TRUE'")
    }
  }
  if (!is.null(fallback_models)) {
    if (!is.character(fallback_models)) {
      stop("El parametro 'fallback_models' debe ser un vector de caracteres")
    }
    if (any(!nzchar(fallback_models))) {
      stop("Los valores de 'fallback_models' no pueden ser cadenas vacias")
    }
  }

  # Determinar si el modelo soporta Structured Outputs estrictos
  # Segun https://openrouter.ai/docs/features/structured-outputs
  # OpenAI GPT-4o+, Google Gemini y Fireworks tienen soporte completo
  # Para otros modelos (Anthropic, Meta, etc.) usar JSON mode básico
  modelo_soporta_structured <- function(modelo_slug) {
    grepl("^openai/gpt-4o", modelo_slug) ||
      grepl("^openai/gpt-5", modelo_slug) ||
      grepl("^openai/o1", modelo_slug) ||
      grepl("^openai/o4", modelo_slug) ||
      grepl("^google/gemini", modelo_slug) ||
      grepl("^fireworks/", modelo_slug)
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
    schema <- proteger_arrays_schema(schema)
  }

  # Prompts predefinidos (structured vs JSON mode basico)
  system_prompt_structured <- "Eres un asistente experto en analisis de texto. Debes responder SIEMPRE siguiendo exactamente el esquema JSON proporcionado. Se preciso, conciso y basa tus respuestas unicamente en el texto proporcionado."
  campos_descripciones <- sapply(names(schema$properties), function(campo) {
    desc <- schema$properties[[campo]]$description
    if (!is.null(desc)) {
      sprintf("- %s: %s", campo, desc)
    } else {
      sprintf("- %s", campo)
    }
  })
  campos_texto <- paste(campos_descripciones, collapse = "\n")
  system_prompt_json <- sprintf(
    "Eres un asistente experto en analisis de texto. Debes responder SIEMPRE en formato JSON valido con los siguientes campos:\n\n%s\n\nSe preciso, conciso y basa tus respuestas unicamente en el texto proporcionado. Responde UNICAMENTE con el JSON de datos, sin texto adicional antes o despues.",
    campos_texto
  )

  # Candidatos a modelo (principal + fallbacks definidos)
  modelos_candidatos <- unique(c(modelo, fallback_models))
  if (length(modelos_candidatos) == 0 || any(!nzchar(modelos_candidatos))) {
    stop("Debes especificar al menos un modelo valido para la solicitud")
  }

  # Construir prompt del usuario
  user_prompt <- sprintf("Texto a analizar:\n%s\n\nInstrucciones:\n%s", texto, instrucciones)

  # Construir body de la peticion
  body <- list(
    messages = list(
      list(role = "system", content = NULL),
      list(role = "user", content = user_prompt)
    ),
    temperature = temperature,
    max_tokens = max_tokens,
    top_p = top_p
  )

  provider_config <- list()
  if (!is.null(fallback_provider_order)) {
    provider_config$order <- fallback_provider_order
  }
  if (!use_fallback) {
    provider_config$allow_fallbacks <- FALSE
  }
  if (length(provider_config) > 0) {
    body$provider <- provider_config
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

  # Realizar peticion a la API con soporte de fallbacks
  fallback_retryable_codes <- c(408L, 409L, 425L, 429L, 500:599)
  errores_detalle <- list()
  registrar_error <- function(modelo_intentado, detalle) {
    errores_detalle[[length(errores_detalle) + 1]] <<- list(modelo = modelo_intentado, detalle = detalle)
  }
  ultimo_error <- "Error desconocido"

  for (i in seq_along(modelos_candidatos)) {
    modelo_actual <- modelos_candidatos[[i]]
    soporta_structured_actual <- modelo_soporta_structured(modelo_actual)

    body$model <- modelo_actual
    body$messages[[1]]$content <- if (soporta_structured_actual) system_prompt_structured else system_prompt_json
    if (soporta_structured_actual) {
      body$response_format <- list(
        type = "json_schema",
        json_schema = list(
          name = "respuesta_estructurada",
          strict = TRUE,
          schema = schema
        )
      )
    } else {
      body$response_format <- list(type = "json_object")
    }

    respuesta_http <- tryCatch({
      list(
        ok = TRUE,
        result = httr::POST(
          url = "https://openrouter.ai/api/v1/chat/completions",
          do.call(httr::add_headers, headers_call),
          body = jsonlite::toJSON(body, auto_unbox = TRUE, pretty = FALSE),
          encode = "raw"
        )
      )
    }, error = function(e) {
      list(ok = FALSE, error = conditionMessage(e))
    })

    if (!respuesta_http$ok) {
      detalle_error <- sprintf("Error de conexion: %s", respuesta_http$error)
      registrar_error(modelo_actual, detalle_error)
      ultimo_error <- detalle_error
      if (i < length(modelos_candidatos)) {
        next
      } else {
        break
      }
    }

    output <- respuesta_http$result
    status_code <- httr::status_code(output)

    if (status_code != 200) {
      error_content <- httr::content(output, as = "parsed")
      error_msg <- if (!is.null(error_content$error$message)) {
        error_content$error$message
      } else if (!is.null(error_content$error)) {
        as.character(error_content$error)
      } else {
        "Error desconocido"
      }
      detalle_status <- sprintf("Error HTTP %d: %s", status_code, error_msg)
      registrar_error(modelo_actual, detalle_status)
      ultimo_error <- detalle_status
      if (i < length(modelos_candidatos) && status_code %in% fallback_retryable_codes) {
        next
      } else {
        break
      }
    }

    respuesta_parsed <- httr::content(output, as = "parsed")

    if (is.null(respuesta_parsed$choices) || length(respuesta_parsed$choices) == 0) {
      stop("La API devolvio una respuesta vacia. Verifica tu prompt y esquema.")
    }

    respuesta_json <- respuesta_parsed$choices[[1]]$message$content

    if (is.null(respuesta_json) || nchar(respuesta_json) == 0) {
      stop("La API devolvio una respuesta vacia. Verifica tu prompt y esquema.")
    }

    respuesta_json <- gsub("^```json\\s*", "", respuesta_json, perl = TRUE)
    respuesta_json <- gsub("^```\\s*", "", respuesta_json, perl = TRUE)
    respuesta_json <- gsub("\\s*```$", "", respuesta_json, perl = TRUE)
    respuesta_json <- trimws(respuesta_json)

    if (parse_json) {
      tryCatch({
        resultado <- jsonlite::fromJSON(respuesta_json, simplifyVector = TRUE)
        return(resultado)
      }, error = function(e) {
        stop(sprintf(
          "Error al parsear JSON de la respuesta. Contenido recibido (primeros 200 chars):\n%s\n\nError de parseo: %s",
          substr(respuesta_json, 1, 200),
          conditionMessage(e)
        ))
      })
    } else {
      return(respuesta_json)
    }
  }

  if (length(errores_detalle) > 0) {
    detalles_texto <- paste(
      vapply(
        errores_detalle,
        function(err) sprintf("- %s: %s", err$modelo, err$detalle),
        character(1)
      ),
      collapse = "\n"
    )
    stop(sprintf(
      "Error al interactuar con la API de OpenRouter: %s\nIntentos realizados:\n%s",
      ultimo_error,
      detalles_texto
    ))
  } else {
    stop(sprintf("Error al interactuar con la API de OpenRouter: %s", ultimo_error))
  }
}
