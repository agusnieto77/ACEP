context("test-acep_db")

test_that("ACEP DB", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_load_base('rp_mdp')
  rp_procesada <- acep_db(rev_puerto, rev_puerto$nota, acep_diccionarios$dicc_viol_gp, 4)
  dimensiones <- length(rev_puerto$nota)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})
