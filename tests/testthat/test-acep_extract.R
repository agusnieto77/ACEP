# Offline tests (no network).
test_that("acep_extract extrae las palabras clave del texto", {
  out <- acep_extract("hola mundo cruel", c("mund", "cru"))
  expect_type(out, "character")
  expect_true(grepl("mundo", out))
  expect_true(grepl("cruel", out))
})

test_that("acep_extract devuelve NA real para entradas NA", {
  out <- acep_extract(c("hola mundo", NA), "mund")
  expect_true(is.na(out[[2]]))
})
