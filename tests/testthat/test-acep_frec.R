
test_that("ACEP Frec", {
  skip_if_offline()
  skip_on_cran()
  frec <- acep_frec("El SUTEBA fue al paro. Reclaman mejoras salariales.")
  dimensiones <- length(frec)
  expect_equal(dimensiones, length(frec))
})
