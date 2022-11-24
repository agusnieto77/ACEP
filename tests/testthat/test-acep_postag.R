
test_that("ACEP postag", {
  skip_if_offline()
  skip_on_cran()
  texto <- acep_postag("SUTEBA went on strike for better salaries.", core = "en_core_web_sm")
  dimensiones <- length(texto)
  expect_equal(dimensiones, length(texto))
})
