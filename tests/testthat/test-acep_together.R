# Offline validation tests (no network).
test_that("acep_together valida texto e instrucciones no vacios", {
  expect_error(acep_together("", "instrucciones", api_key = "fake"),
               "cadena de caracteres no vacia")
  expect_error(acep_together("texto", "", api_key = "fake"),
               "cadena de caracteres no vacia")
})

test_that("acep_together exige una API key", {
  expect_error(acep_together("texto", "instrucciones", api_key = ""),
               "API key no encontrada")
})
