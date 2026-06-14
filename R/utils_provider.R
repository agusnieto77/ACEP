#' Eliminar recursivamente una clave de un esquema con estructura anidada
#'
#' Recorre el esquema (objetos anidados, items de arrays) y elimina todas las
#' apariciones de `key`, no solo la del nivel raiz. Util para proveedores cuyo
#' formato de esquema no admite ciertas claves (por ejemplo `additionalProperties`
#' en el responseSchema de Gemini).
#' @keywords internal
.acep_provider_strip_key <- function(schema, key) {
  if (is.list(schema)) {
    schema[[key]] <- NULL
    schema <- lapply(schema, .acep_provider_strip_key, key = key)
  }
  schema
}

#' @keywords internal
proteger_arrays_schema <- function(schema) {
  if (is.list(schema)) {
    if ("required" %in% names(schema)) {
      schema$required <- I(schema$required)
    }
    if ("enum" %in% names(schema)) {
      schema$enum <- I(schema$enum)
    }
    schema <- lapply(schema, proteger_arrays_schema)
  }
  schema
}

.acep_provider_validate_request_inputs <- function(texto, instrucciones, api_key, api_key_env) {
  if (!is.character(texto) || nchar(texto) == 0) {
    stop("El parametro 'texto' debe ser una cadena de caracteres no vacia")
  }
  if (!is.character(instrucciones) || nchar(instrucciones) == 0) {
    stop("El parametro 'instrucciones' debe ser una cadena de caracteres no vacia")
  }
  if (api_key == "") {
    stop(sprintf(
      "API key no encontrada. Define la variable de entorno %s o pasa el parametro api_key",
      api_key_env
    ))
  }
  invisible(NULL)
}

.acep_provider_default_schema <- function(additional_properties = TRUE, protect_arrays = TRUE) {
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
  if (isTRUE(additional_properties)) {
    schema$additionalProperties <- FALSE
  }
  if (isTRUE(protect_arrays)) {
    schema <- proteger_arrays_schema(schema)
  }
  schema
}

.acep_provider_user_prompt <- function(texto, instrucciones) {
  sprintf("Texto a analizar:\n%s\n\nInstrucciones:\n%s", texto, instrucciones)
}

.acep_provider_schema_field_descriptions <- function(schema) {
  vapply(names(schema$properties), function(campo) {
    desc <- schema$properties[[campo]]$description
    if (!is.null(desc)) {
      sprintf("- %s: %s", campo, desc)
    } else {
      sprintf("- %s", campo)
    }
  }, character(1))
}

.acep_provider_endpoint <- function(provider, modelo = NULL) {
  switch(
    provider,
    openai = "https://api.openai.com/v1/chat/completions",
    anthropic = "https://api.anthropic.com/v1/messages",
    gemini = sprintf(
      "https://generativelanguage.googleapis.com/v1beta/models/%s:generateContent",
      modelo
    ),
    together = "https://api.together.xyz/v1/chat/completions",
    openrouter = "https://openrouter.ai/api/v1/chat/completions",
    stop(sprintf("Proveedor no soportado: %s", provider), call. = FALSE)
  )
}

.acep_openai_token_limit_field <- function(modelo) {
  if (grepl("^gpt-5", modelo) || grepl("^o1", modelo) || grepl("^o4", modelo)) {
    "max_completion_tokens"
  } else {
    "max_tokens"
  }
}

.acep_openrouter_model_supports_structured_outputs <- function(modelo_slug) {
  grepl("^openai/gpt-4o", modelo_slug) ||
    grepl("^openai/gpt-5", modelo_slug) ||
    grepl("^openai/o1", modelo_slug) ||
    grepl("^openai/o4", modelo_slug) ||
    grepl("^google/gemini", modelo_slug) ||
    grepl("^fireworks/", modelo_slug)
}

.acep_provider_auth_headers <- function(provider, api_key, site_url = NULL, app_name = NULL) {
  headers <- switch(
    provider,
    openai = list("Content-Type" = "application/json", "Authorization" = paste("Bearer", api_key)),
    anthropic = list(
      "Content-Type" = "application/json",
      "x-api-key" = api_key,
      "anthropic-version" = "2023-06-01"
    ),
    gemini = list("Content-Type" = "application/json", "x-goog-api-key" = api_key),
    together = list("Content-Type" = "application/json", "Authorization" = paste("Bearer", api_key)),
    openrouter = list("Content-Type" = "application/json", "Authorization" = paste("Bearer", api_key)),
    stop(sprintf("Proveedor no soportado: %s", provider), call. = FALSE)
  )
  if (provider == "openrouter") {
    if (!is.null(site_url)) {
      headers$`HTTP-Referer` <- site_url
    }
    if (!is.null(app_name)) {
      headers$`X-Title` <- app_name
    }
  }
  headers
}

#' Ejecutar una peticion POST a un proveedor de IA
#'
#' Centraliza la construccion de la peticion HTTP comun a los proveedores en la
#' nube: serializa el cuerpo a JSON con `auto_unbox = TRUE`, arma las cabeceras,
#' aplica un timeout y realiza el POST. El ensamblado del `body` y el parseo de
#' la respuesta siguen siendo especificos de cada proveedor.
#' @keywords internal
.acep_provider_post <- function(url, headers, body, timeout = 120, encode = "raw") {
  httr::POST(
    url = url,
    do.call(httr::add_headers, headers),
    body = jsonlite::toJSON(body, auto_unbox = TRUE, pretty = FALSE),
    encode = encode,
    httr::timeout(timeout)
  )
}

.acep_provider_extract_chat_content <- function(respuesta_parsed) {
  if (is.null(respuesta_parsed$choices) || length(respuesta_parsed$choices) == 0) {
    stop("La API devolvio una respuesta vacia. Verifica tu prompt y esquema.")
  }
  respuesta_json <- respuesta_parsed$choices[[1]]$message$content
  if (is.null(respuesta_json) || nchar(respuesta_json) == 0) {
    stop("La API devolvio una respuesta vacia. Verifica tu prompt y esquema.")
  }
  respuesta_json
}

#' Extraer un mensaje de error legible de una respuesta HTTP de error
#'
#' Maneja de forma robusta los distintos cuerpos de error que puede devolver una
#' API: una lista con `error$message`, un campo `error` atomico (una cadena en
#' lugar de un objeto), un cuerpo de texto plano (p. ej. una pagina HTML de un
#' gateway 5xx) o un contenido nulo. Nunca falla con
#' "$ operator is invalid for atomic vectors".
#' @keywords internal
.acep_provider_http_error_message <- function(error_content) {
  err <- if (is.list(error_content)) error_content$error else NULL
  if (is.list(err) && !is.null(err$message)) {
    err$message
  } else if (!is.null(err)) {
    paste(as.character(err), collapse = " ")
  } else if (is.character(error_content)) {
    substr(error_content, 1, 500)
  } else {
    "Error desconocido"
  }
}

.acep_provider_clean_json_response <- function(respuesta_json) {
  respuesta_json <- gsub("^```json\\s*", "", respuesta_json, perl = TRUE)
  respuesta_json <- gsub("^```\\s*", "", respuesta_json, perl = TRUE)
  respuesta_json <- gsub("\\s*```$", "", respuesta_json, perl = TRUE)
  trimws(respuesta_json)
}

.acep_provider_parse_json_response <- function(respuesta_json, parse_json = TRUE, clean_markdown = TRUE) {
  if (isTRUE(clean_markdown)) {
    respuesta_json <- .acep_provider_clean_json_response(respuesta_json)
  }
  if (!parse_json) {
    return(respuesta_json)
  }
  tryCatch({
    jsonlite::fromJSON(respuesta_json, simplifyVector = TRUE)
  }, error = function(e) {
    stop(sprintf(
      "Error al parsear JSON de la respuesta. Contenido recibido (primeros 200 chars):\n%s\n\nError de parseo: %s",
      substr(respuesta_json, 1, 200),
      conditionMessage(e)
    ))
  })
}
