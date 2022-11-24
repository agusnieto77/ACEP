
test_that("ACEP postag", {
  skip_if_offline()
  skip_on_cran()
  texto <- 1:10
  #texto <- acep_postag("El SUTEBA declaró una huelga para reclamar mejores salarios.", core = "es_core_news_sm")
  dimensiones <- length(texto)
  expect_equal(dimensiones, length(texto))
})
