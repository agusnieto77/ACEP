context("test-acep_load_base")

test_that("ACEP LOAD", {
  skip_if_offline()
  skip_on_cran()
  tag <- 'https://estudiosmaritimossociales.org/ejemplo.rds'
  rp <- acep_load_base(tag = tag)
  dimensiones <- length(rp$nota)
  expect_equal(dimensiones, 32)
})


