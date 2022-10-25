
test_that("ACEP TOKEN", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto[1:10,]
  rev_puerto_token <- acep_token(rev_puerto$nota)
  dimensiones <- length(rev_puerto_token$token)
  expect_equal(dimensiones, length(rev_puerto_token$id_token))
})

test_that("ACEP TOKEN F", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto[1:10,]
  rev_puerto_token <- acep_token(rev_puerto$nota, tolower = FALSE)
  dimensiones <- length(rev_puerto_token$token)
  expect_equal(dimensiones, length(rev_puerto_token$id_token))
})

