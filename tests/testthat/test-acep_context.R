
test_that("ACEP Context", {
  skip_if_offline()
  skip_on_cran()
  texto <- acep_context(texto = "El SUTEBA fue al paro por mejoras salariales.",
                        clave = "paro")
  dimensiones <- length(texto)
  expect_equal(dimensiones, length(texto))
})
