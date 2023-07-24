
test_that("ACEP postag", {
  skip_if_offline()
  skip_on_cran()
  texto <- acep_postag(1:10,
    core = "es_core_news_sm")
  dimensiones <- length(texto)
  expect_equal(dimensiones, length(texto))
})
