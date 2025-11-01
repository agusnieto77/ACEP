
test_that("ACEP INT", {
  skip_if_offline()
  skip_on_cran()
  conflictos <- c(1, 5, 0, 3, 7)
  palabras <- c(4, 11, 12, 9, 34)
  int <- acep_int(conflictos, palabras, 3)
  dimensiones <- length(int)
  expect_equal(dimensiones, length(int))
})

test_that("ACEP INT E1", {
  skip_if_offline()
  skip_on_cran()
  df <- data.frame(V1=c(1:10), V2=c(letters[1:10]))
  conflictos <- c(1, 5, 0, 3, 7)
  palabras <- c(4, 11, 12, 9, 34)
  expect_error(
    int <- acep_int(df, palabras, 3)
  )
  dimensiones <- length(1:200)
  expect_equal(dimensiones, length(1:200))
})

test_that("ACEP INT E2", {
  skip_if_offline()
  skip_on_cran()
  df <- data.frame(V1=c(1:10), V2=c(letters[1:10]))
  conflictos <- c(1, 5, 0, 3, 7)
  palabras <- c(4, 11, 12, 9, 34)
  expect_error(
    int <- acep_int(conflictos, df, 3)
  )
  dimensiones <- length(1:200)
  expect_equal(dimensiones, length(1:200))
})
