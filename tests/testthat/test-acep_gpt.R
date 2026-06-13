# Offline validation tests (no network). Request-building and JSON parsing
# helpers are characterized in test-optimization-safety.R.
test_that("acep_gpt valida texto e instrucciones no vacios", {
  expect_error(acep_gpt("", "instrucciones", api_key = "fake"),
               "cadena de caracteres no vacia")
  expect_error(acep_gpt("texto", "", api_key = "fake"),
               "cadena de caracteres no vacia")
})

test_that("acep_gpt exige una API key", {
  expect_error(acep_gpt("texto", "instrucciones", api_key = ""),
               "API key no encontrada")
})
