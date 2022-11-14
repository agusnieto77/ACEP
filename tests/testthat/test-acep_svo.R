
test_that("ACEP svo", {
  skip_if_offline()
  skip_on_cran()
  texto <- acep_svo("El SUTEBA fue al paro por mejoras salariales.")
  dimensiones <- length(texto)
  expect_equal(dimensiones, length(texto))
})
