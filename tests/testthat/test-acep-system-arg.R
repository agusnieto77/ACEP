# Tests for the unified `system` (persona) argument added in 0.2.0.
# All offline: httr::POST is mocked, so the request body is captured without
# any network call. The critical property is BYTE-IDENTITY at system = NULL
# (zero regression vs 0.1.x), plus that a custom `system` reaches the wire.

# Persona literals as they existed in 0.1.x (the contract we must preserve).
PERSONA_JSON_SCHEMA <- "Eres un asistente experto en analisis de texto. Debes responder SIEMPRE siguiendo exactamente el esquema JSON proporcionado. Se preciso, conciso y basa tus respuestas unicamente en el texto proporcionado."
PERSONA_CLAUDE <- "Eres un asistente experto en analisis de texto. Debes responder SIEMPRE usando la herramienta proporcionada siguiendo exactamente el esquema especificado. Se preciso, conciso y basa tus respuestas unicamente en el texto proporcionado."

# Capture the JSON request body of a provider call by mocking httr::POST.
capture_body <- function(expr) {
  captured <- NULL
  testthat::local_mocked_bindings(
    POST = function(url, ..., body) {
      captured <<- jsonlite::fromJSON(body, simplifyVector = FALSE)
      stop("CAPTURED_BODY")
    },
    .package = "httr"
  )
  suppressWarnings(suppressMessages(tryCatch(expr, error = function(e) NULL)))
  captured
}

# --- resolver -------------------------------------------------------------
test_that(".acep_provider_resolve_system preserves default and applies override", {
  f <- getFromNamespace(".acep_provider_resolve_system", "ACEP")
  expect_identical(f(NULL, "persona por defecto"), "persona por defecto")
  expect_identical(f("mi persona", "persona por defecto"), "mi persona")
  expect_error(f("", "x"), "system")
  expect_error(f(c("a", "b"), "x"), "system")
  expect_error(f(123, "x"), "system")
  expect_error(f(NA_character_, "x"), "system")
})

# --- shared json system prompt is byte-identical to the 0.1.x literal -----
test_that(".acep_provider_json_system_prompt reproduces the 0.1.x JSON literal", {
  f <- getFromNamespace(".acep_provider_json_system_prompt", "ACEP")
  expected <- paste0(
    "Eres un asistente experto en analisis de texto. Debes responder SIEMPRE ",
    "en formato JSON valido con los siguientes campos:\n\n- respuesta: dato\n\n",
    "Se preciso, conciso y basa tus respuestas unicamente en el texto ",
    "proporcionado. Responde UNICAMENTE con el JSON de datos, sin texto ",
    "adicional antes o despues."
  )
  expect_identical(
    f("Eres un asistente experto en analisis de texto.", "- respuesta: dato"),
    expected
  )
})

# --- byte-identity at system = NULL, per provider -------------------------
test_that("acep_gpt sends the 0.1.x persona when system is NULL", {
  b <- capture_body(acep_gpt("texto", "instr", api_key = "k", system = NULL))
  expect_equal(b$messages[[1]]$content, PERSONA_JSON_SCHEMA)
})

test_that("acep_claude sends the 0.1.x persona when system is NULL", {
  b <- capture_body(acep_claude("texto", "instr", api_key = "k", system = NULL))
  expect_equal(b$system, PERSONA_CLAUDE)
})

test_that("acep_gemini prepends the 0.1.x persona when system is NULL", {
  b <- capture_body(acep_gemini("TEXTO", "INSTR", api_key = "k", system = NULL))
  expected <- paste0(PERSONA_JSON_SCHEMA,
                     "\n\nTexto a analizar:\nTEXTO\n\nInstrucciones:\nINSTR")
  expect_equal(b$contents[[1]]$parts[[1]]$text, expected)
})

test_that("acep_together (json) sends the 0.1.x persona when system is NULL", {
  b <- capture_body(acep_together("texto", "instr", api_key = "k", system = NULL))
  # default schema -> single field "respuesta"
  expect_true(startsWith(b$messages[[1]]$content,
                         "Eres un asistente experto en analisis de texto. Debes responder SIEMPRE en formato JSON valido"))
  expect_true(grepl("respuesta", b$messages[[1]]$content, fixed = TRUE))
})

test_that("acep_openrouter sends the 0.1.x structured persona when system is NULL", {
  # default model openai/gpt-4o-mini supports structured outputs
  b <- capture_body(acep_openrouter("texto", "instr", api_key = "k", system = NULL))
  expect_equal(b$messages[[1]]$content, PERSONA_JSON_SCHEMA)
})

test_that("acep_ollama sends the data-sourced persona when system is NULL", {
  b <- capture_body(acep_ollama("texto", "instr", host = "https://ollama.com",
                                api_key = "k", system = NULL))
  expect_equal(b$messages[[1]]$content, ACEP::acep_prompt_gpt$system_prompt_01_es)
})

# --- a custom `system` reaches the wire -----------------------------------
test_that("a custom system persona reaches the request body", {
  marca <- "PERSONA CUSTOM DE PRUEBA 12345"
  b_gpt <- capture_body(acep_gpt("t", "i", api_key = "k", system = marca))
  expect_equal(b_gpt$messages[[1]]$content, marca)

  b_oll <- capture_body(acep_ollama("t", "i", host = "https://ollama.com",
                                    api_key = "k", system = marca))
  expect_equal(b_oll$messages[[1]]$content, marca)

  # together: custom persona must keep the JSON field block
  b_tog <- capture_body(acep_together("t", "i", api_key = "k", system = marca))
  expect_true(startsWith(b_tog$messages[[1]]$content, marca))
  expect_true(grepl("formato JSON valido", b_tog$messages[[1]]$content, fixed = TRUE))
})

# --- together: prompt_system modes interact correctly with `system` -------
test_that("acep_together texto mode keeps 0.1.x persona at NULL and honors system", {
  persona_texto <- "Eres un asistente experto en analisis de texto. Responde de manera clara, precisa y concisa. Basa tus respuestas unicamente en el texto proporcionado."
  b_null <- capture_body(acep_together("t", "i", api_key = "k",
                                       prompt_system = "texto", system = NULL))
  expect_equal(b_null$messages[[1]]$content, persona_texto)

  b_sys <- capture_body(acep_together("t", "i", api_key = "k",
                                      prompt_system = "texto", system = "MARCA"))
  expect_equal(b_sys$messages[[1]]$content, "MARCA")
})

test_that("acep_together custom prompt_system: system overrides persona, NULL keeps prompt_system", {
  b_null <- capture_body(acep_together("t", "i", api_key = "k",
                                       prompt_system = "Mi prompt personalizado", system = NULL))
  expect_equal(b_null$messages[[1]]$content, "Mi prompt personalizado")

  b_sys <- capture_body(acep_together("t", "i", api_key = "k",
                                      prompt_system = "Mi prompt personalizado", system = "MARCA"))
  expect_equal(b_sys$messages[[1]]$content, "MARCA")
})
