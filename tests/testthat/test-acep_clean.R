context("test-acep_clean")

test_that("ACEP CLEAN", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto
  rev_puerto$nota_clean <- acep_clean(rev_puerto$nota)
  dimensiones <- length(rev_puerto$nota)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})
