
test_that("ACEP upos", {
  skip_if_offline()
  skip_on_cran()
  texto <- acep_upos(1:10,
    modelo = "spanish")
  dimensiones <- length(texto)
  expect_equal(dimensiones, length(texto))
})
