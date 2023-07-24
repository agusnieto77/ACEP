
test_that("ACEP extract", {
  skip_if_offline()
  skip_on_cran()
  texto <- acep_extract("hola mundo", "mundo")
  dimensiones <- length(texto)
  expect_equal(dimensiones, length(texto))
})
