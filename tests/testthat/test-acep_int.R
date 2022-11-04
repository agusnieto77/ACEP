
test_that("ACEP INT", {
  skip_if_offline()
  skip_on_cran()
  conflictos <- c(1, 5, 0, 3, 7)
  palabras <- c(4, 11, 12, 9, 34)
  int <- acep_int(conflictos, palabras, 3)
  dimensiones <- length(int)
  expect_equal(dimensiones, length(int))
})
