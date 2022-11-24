
test_that("ACEP svo", {
  skip_if_offline()
  skip_on_cran()
  texto <- acep_postag("El SUTEBA fue al paro por mejoras salariales.", bajar_core = FALSE)
  acep_svo(texto$texto_tag)
  dimensiones <- length(texto)
  expect_equal(dimensiones, length(texto))
})
