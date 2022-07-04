context("test-acep_men")

test_that("ACEP Men", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto
  dicc_violencia <- acep_diccionarios$dicc_viol_gp
  rev_puerto$conflictos <- acep_men(rev_puerto$nota, dicc_violencia)
  dimensiones <- length(rev_puerto$nota)
  expect_equal(dimensiones, length(rev_puerto$conflictos))
})

