
test_that("ACEP postag", {
  skip_if_offline()
  skip_on_cran()
  texto <- acep_postag("El SUTEBA fue al paro por mejoras salariales.", bajar_core = FALSE)
  dimensiones <- length(texto)
  expect_equal(dimensiones, length(texto))
})
