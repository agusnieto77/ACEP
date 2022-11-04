
test_that("ACEP Frec", {
  skip_if_offline()
  skip_on_cran()
  frec <- acep_frec("El SUTEBA fue al paro. Reclaman mejoras salariales.")
  dimensiones <- length(frec)
  expect_equal(dimensiones, length(frec))
})

test_that("ACEP Frec E1", {
  skip_if_offline()
  skip_on_cran()
  df <- data.frame(texto =
                     c("El SUTEBA fue al paro. Reclaman mejoras salariales.",
                       "El SOIP lleva adelante un plan de lucha con paros y piquetes."))
  frec <- acep_frec(df)
  dimensiones <- length(frec)
  expect_equal(dimensiones, length(frec))
})
