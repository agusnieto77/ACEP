# Offline validation tests (no network).
test_that("acep_claude valida texto e instrucciones no vacios", {
  expect_error(acep_claude("", "instrucciones", api_key = "fake"),
               "cadena de caracteres no vacia")
  expect_error(acep_claude("texto", "", api_key = "fake"),
               "cadena de caracteres no vacia")
})

test_that("acep_claude exige una API key", {
  expect_error(acep_claude("texto", "instrucciones", api_key = ""),
               "API key no encontrada")
})
