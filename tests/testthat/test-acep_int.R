
test_that("ACEP INT", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto
  dicc_violencia <- acep_diccionarios$dicc_viol_gp
  rev_puerto$n_palabras <- acep_frec(rev_puerto$nota)
  rev_puerto$conflictos <- acep_men(rev_puerto$nota,
                                    dicc_violencia)
  rev_puerto$intensidad <- acep_int(rev_puerto$conflictos,
                                    rev_puerto$n_palabras, 3)
  dimensiones <- length(rev_puerto$nota)
  expect_equal(dimensiones, length(rev_puerto$intensidad))
})
