
test_that("ACEP CLEAN", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto[1:10, ]
  rev_puerto$titulo_clean <- acep_clean(rev_puerto$titulo)
  dimensiones <- length(rev_puerto$titulo)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})

test_that("ACEP CLEAN TF", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto[1:10, ]
  rev_puerto$titulo_clean <- acep_clean(rev_puerto$titulo, tolower = FALSE)
  dimensiones <- length(rev_puerto$titulo)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})

test_that("ACEP CLEAN RMCF", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto[1:10, ]
  rev_puerto$titulo_clean <- acep_clean(rev_puerto$titulo, rm_cesp = FALSE)
  dimensiones <- length(rev_puerto$titulo)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})

test_that("ACEP CLEAN RMEF", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto[1:10, ]
  rev_puerto$titulo_clean <- acep_clean(rev_puerto$titulo, rm_emoji = FALSE)
  dimensiones <- length(rev_puerto$titulo)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})

test_that("ACEP CLEAN RMHF", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto[1:10, ]
  rev_puerto$titulo_clean <- acep_clean(rev_puerto$titulo, rm_hashtag = FALSE)
  dimensiones <- length(rev_puerto$titulo)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})

test_that("ACEP CLEAN RMUF", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto[1:10, ]
  rev_puerto$titulo_clean <- acep_clean(rev_puerto$titulo, rm_users = FALSE)
  dimensiones <- length(rev_puerto$titulo)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})

test_that("ACEP CLEAN RMPF", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto[1:10, ]
  rev_puerto$titulo_clean <- acep_clean(rev_puerto$titulo, rm_punt = FALSE)
  dimensiones <- length(rev_puerto$titulo)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})

test_that("ACEP CLEAN RMNF", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto[1:10, ]
  rev_puerto$titulo_clean <- acep_clean(rev_puerto$titulo, rm_num = FALSE)
  dimensiones <- length(rev_puerto$titulo)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})

test_that("ACEP CLEAN RMURLF", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto[1:10, ]
  rev_puerto$titulo_clean <- acep_clean(rev_puerto$titulo, rm_url = FALSE)
  dimensiones <- length(rev_puerto$titulo)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})

test_that("ACEP CLEAN RMMF", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto[1:10, ]
  rev_puerto$titulo_clean <- acep_clean(rev_puerto$titulo, rm_meses = FALSE)
  dimensiones <- length(rev_puerto$titulo)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})

test_that("ACEP CLEAN RMDF", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto[1:10, ]
  rev_puerto$titulo_clean <- acep_clean(rev_puerto$titulo, rm_dias = FALSE)
  dimensiones <- length(rev_puerto$titulo)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})

test_that("ACEP CLEAN RMSTWF", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto[1:10, ]
  rev_puerto$titulo_clean <- acep_clean(rev_puerto$titulo, rm_stopwords = FALSE)
  dimensiones <- length(rev_puerto$titulo)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})

test_that("ACEP CLEAN RMSTWTN", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto[1:10, ]
  rev_puerto$titulo_clean <- acep_clean(rev_puerto$titulo, other_sw = c('mar','plata','puerto'))
  dimensiones <- length(rev_puerto$titulo)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})

test_that("ACEP CLEAN RMSHWF", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto[1:10, ]
  rev_puerto$titulo_clean <- acep_clean(rev_puerto$titulo, rm_shortwords = FALSE)
  dimensiones <- length(rev_puerto$titulo)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})

test_that("ACEP CLEAN RMNLF", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto[1:10, ]
  rev_puerto$titulo_clean <- acep_clean(rev_puerto$titulo, rm_newline = FALSE)
  dimensiones <- length(rev_puerto$titulo)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})

test_that("ACEP CLEAN RMWSF", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto[1:10, ]
  rev_puerto$titulo_clean <- acep_clean(rev_puerto$titulo, rm_whitespace = FALSE)
  dimensiones <- length(rev_puerto$titulo)
  expect_equal(dimensiones, length(rev_puerto$fecha))
})
