context("test-acep_men")

test_that("ACEP Men Tolower T", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_load_base('rp_mdp')
  dicc_violencia <- acep_diccionarios$dicc_viol_gp
  rev_puerto$conflictos <- acep_men(rev_puerto$nota, dicc_violencia)
  dimensiones <- length(rev_puerto$nota)
  expect_equal(dimensiones, length(rev_puerto$conflictos))
})

test_that("ACEP Men Tolower F", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_load_base('rp_mdp')
  dicc_violencia <- acep_diccionarios$dicc_viol_gp
  rev_puerto$conflictos <- acep_men(rev_puerto$nota, dicc_violencia, tolower = FALSE)
  dimensiones <- length(rev_puerto$nota)
  expect_equal(dimensiones, length(rev_puerto$conflictos))
})

