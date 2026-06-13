# Offline validation tests (no network, no udpipe model download).
test_that("acep_upos rechaza texto que no es caracter", {
  expect_error(acep_upos(1:10, modelo = "spanish"), "cadena de caracteres")
})

test_that("acep_upos rechaza modelos invalidos", {
  expect_error(acep_upos("texto de prueba", modelo = "klingon"), "modelo")
})
