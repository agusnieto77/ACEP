# Offline tests (no network).
test_that("acep_int calcula el indice de intensidad", {
  conflictos <- c(1, 5, 0, 3, 7)
  palabras <- c(4, 11, 12, 9, 34)
  int <- acep_int(conflictos, palabras, 3)
  expect_type(int, "double")
  expect_equal(int, round(conflictos / palabras, 3))
})

test_that("acep_int valida que pc sea numerico", {
  expect_error(acep_int(data.frame(x = 1:3), c(4, 11, 12), 3), "numerico")
})

test_that("acep_int valida que pt sea numerico", {
  expect_error(acep_int(c(1, 5, 0), data.frame(x = 1:3), 3), "numerico")
})
