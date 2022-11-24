
test_that("ACEP svo", {
  skip_if_offline()
  skip_on_cran()
  texto <- acep_postag("SUTEBA went on strike for better salaries.", bajar_core = FALSE, core = "en_core_web_sm")
  acep_svo(texto$texto_tag)
  dimensiones <- length(texto)
  expect_equal(dimensiones, length(texto))
})
