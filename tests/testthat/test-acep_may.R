
test_that("ACEP May", {
  skip_if_offline()
  skip_on_cran()
  minusculas <- acep_may(c("SUTEBA", "Sindicato", "PEN"))
  dimensiones <- length(minusculas)
  expect_equal(dimensiones, length(minusculas))
})
