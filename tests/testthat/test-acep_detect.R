
test_that("ACEP DETECT", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto
  dicc_violencia <- acep_diccionarios$dicc_viol_gp
  rev_puerto$conflictos_detect <- acep_detect(rev_puerto$nota,
                                              dicc_violencia)
  dimensiones <- length(rev_puerto$nota)
  expect_equal(dimensiones, length(rev_puerto$conflictos_detect))
})

test_that("ACEP DETECT F", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto
  dicc_violencia <- acep_diccionarios$dicc_viol_gp
  rev_puerto$conflictos_detect <- acep_detect(rev_puerto$nota,
                                              dicc_violencia,
                                              tolower = FALSE)
  dimensiones <- length(rev_puerto$nota)
  expect_equal(dimensiones, length(rev_puerto$conflictos_detect))
})
