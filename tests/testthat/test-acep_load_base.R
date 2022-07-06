context("test-acep_load_base")

test_that("ACEP LOAD", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_load_base(tag = acep_bases$rp_mdp)
  dimensiones <- length(rev_puerto$nota)
  expect_equal(dimensiones, 7816)
})


