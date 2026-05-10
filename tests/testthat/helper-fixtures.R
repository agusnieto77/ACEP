acep_fixture_clean_text <- function() {
  c(
    "El SUTEBA fue al paro. Reclaman mejoras salariales.",
    "Viernes 12: @soip marcha en Mar del Plata!!! https://example.com #Paro 😊"
  )
}

acep_fixture_count <- function() {
  list(
    texto = c("paro lucha paro", "piquetes y paros", "sin coincidencias"),
    dic = c("paro", "lucha", "piquetes")
  )
}

acep_fixture_pos <- function() {
  ACEP::acep_bases$spacy_postag
}

acep_fixture_svo <- function() {
  acep_fixture_pos()
}

acep_fixture_provider_success <- function() {
  list(
    provider = "openrouter",
    status_code = 200L,
    body = list(choices = list(list(message = list(content = "respuesta fixture"))))
  )
}

acep_fixture_provider_error <- function() {
  list(
    provider = "openrouter",
    status_code = 401L,
    body = list(error = list(message = "API key inválida"))
  )
}

acep_skip_if_network_required <- function(reason = "offline safety fixture avoids network/API calls") {
  testthat::skip(reason)
}

acep_skip_if_external_model_required <- function(reason = "offline safety fixture avoids external NLP model downloads") {
  testthat::skip(reason)
}
