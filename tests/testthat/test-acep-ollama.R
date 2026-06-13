# Offline validation tests (no network). These paths fire before any HTTP call.
test_that("acep_ollama valida texto e instrucciones no vacios", {
  expect_error(acep_ollama("", "instrucciones"),
               "cadena de caracteres no vacia")
  expect_error(acep_ollama("texto", ""),
               "cadena de caracteres no vacia")
})

test_that("acep_ollama exige api_key para hosts remotos", {
  expect_error(
    acep_ollama("texto", "instrucciones", host = "https://ollama.com", api_key = ""),
    "api_key"
  )
})
