# Offline validation tests (no network).
test_that("acep_openrouter valida texto e instrucciones no vacios", {
  expect_error(acep_openrouter("", "instrucciones", api_key = "fake"),
               "cadena de caracteres no vacia")
  expect_error(acep_openrouter("texto", "", api_key = "fake"),
               "cadena de caracteres no vacia")
})

test_that("acep_openrouter exige una API key", {
  expect_error(acep_openrouter("texto", "instrucciones", api_key = ""),
               "API key no encontrada")
})
