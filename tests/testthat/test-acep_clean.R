
test_that("ACEP CLEAN", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto
  rev_puerto$nota_clean <- acep_clean(rev_puerto$nota)
  dimensiones <- length(rev_puerto$nota)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})

test_that("ACEP CLEAN TF", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto
  rev_puerto$nota_clean <- acep_clean(rev_puerto$nota, tolower = FALSE)
  dimensiones <- length(rev_puerto$nota)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})

test_that("ACEP CLEAN RMCF", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto
  rev_puerto$nota_clean <- acep_clean(rev_puerto$nota, rm_cesp = FALSE)
  dimensiones <- length(rev_puerto$nota)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})

test_that("ACEP CLEAN RMEF", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto
  rev_puerto$nota_clean <- acep_clean(rev_puerto$nota, rm_emoji = FALSE)
  dimensiones <- length(rev_puerto$nota)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})

test_that("ACEP CLEAN RMHF", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto
  rev_puerto$nota_clean <- acep_clean(rev_puerto$nota, rm_hashtag = FALSE)
  dimensiones <- length(rev_puerto$nota)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})

test_that("ACEP CLEAN RMUF", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto
  rev_puerto$nota_clean <- acep_clean(rev_puerto$nota, rm_users = FALSE)
  dimensiones <- length(rev_puerto$nota)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})

test_that("ACEP CLEAN RMPF", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto
  rev_puerto$nota_clean <- acep_clean(rev_puerto$nota, rm_punt = FALSE)
  dimensiones <- length(rev_puerto$nota)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})

test_that("ACEP CLEAN RMNF", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto
  rev_puerto$nota_clean <- acep_clean(rev_puerto$nota, rm_num = FALSE)
  dimensiones <- length(rev_puerto$nota)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})

test_that("ACEP CLEAN RMURLF", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto
  rev_puerto$nota_clean <- acep_clean(rev_puerto$nota, rm_url = FALSE)
  dimensiones <- length(rev_puerto$nota)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})

test_that("ACEP CLEAN RMMF", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto
  rev_puerto$nota_clean <- acep_clean(rev_puerto$nota, rm_meses = FALSE)
  dimensiones <- length(rev_puerto$nota)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})

test_that("ACEP CLEAN RMDF", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto
  rev_puerto$nota_clean <- acep_clean(rev_puerto$nota, rm_dias = FALSE)
  dimensiones <- length(rev_puerto$nota)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})

test_that("ACEP CLEAN RMSTWF", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto
  rev_puerto$nota_clean <- acep_clean(rev_puerto$nota, rm_stopwords = FALSE)
  dimensiones <- length(rev_puerto$nota)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})

test_that("ACEP CLEAN RMSHWF", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto
  rev_puerto$nota_clean <- acep_clean(rev_puerto$nota, rm_shortwords = FALSE)
  dimensiones <- length(rev_puerto$nota)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})

test_that("ACEP CLEAN RMNLF", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto
  rev_puerto$nota_clean <- acep_clean(rev_puerto$nota, rm_newline = FALSE)
  dimensiones <- length(rev_puerto$nota)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})

test_that("ACEP CLEAN RMWSF", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto
  rev_puerto$nota_clean <- acep_clean(rev_puerto$nota, rm_whitespace = FALSE)
  dimensiones <- length(rev_puerto$nota)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})
