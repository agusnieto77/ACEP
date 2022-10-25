
test_that("ACEP TOKEN PLOT T", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_clean(acep_bases$rev_puerto$titulo)
  rev_puerto_token <- acep_token(rev_puerto)
  acep_token_plot(rev_puerto_token$token)
  dimensiones <- length(rev_puerto_token$token)
  expect_equal(dimensiones, length(rev_puerto_token$id_doc))
})

test_that("ACEP TOKEN PLOT F", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_clean(acep_bases$rev_puerto$titulo)
  rev_puerto_token <- acep_token(rev_puerto)
  acep_token_plot(rev_puerto_token$token, frec = FALSE)
  dimensiones <- length(rev_puerto_token$token)
  expect_equal(dimensiones, length(rev_puerto_token$id_doc))
})
