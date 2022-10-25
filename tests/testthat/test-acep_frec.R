
test_that("ACEP Frec", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto
  rev_puerto$n_palabras <- acep_frec(rev_puerto$nota)
  dimensiones <- length(rev_puerto$nota)
  expect_equal(dimensiones, length(rev_puerto$n_palabras))
})


