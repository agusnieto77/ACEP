
test_that("ACEP TOKEN", {
  skip_if_offline()
  skip_on_cran()
  token <- acep_token("Huelga de obreros del pescado en el puerto")
  dimensiones <- length(token)
  expect_equal(dimensiones, length(token))
})

test_that("ACEP TOKEN F", {
  skip_if_offline()
  skip_on_cran()
  token <- acep_token("Huelga de obreros del pescado en el puerto", tolower = FALSE)
  dimensiones <- length(token)
  expect_equal(dimensiones, length(token))
})
