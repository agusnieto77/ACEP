
test_that("ACEP claude", {
  skip_if_offline()
  skip_on_cran()
  texto <- 1:10
  dimensiones <- length(texto)
  expect_equal(dimensiones, length(texto))
})
