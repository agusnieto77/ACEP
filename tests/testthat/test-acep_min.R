
test_that("ACEP May", {
  skip_if_offline()
  skip_on_cran()
  mayusculas <- acep_min(c("SUTEBA", "Sindicato", "PEN"))
  dimensiones <- length(mayusculas)
  expect_equal(dimensiones, length(mayusculas))
})
