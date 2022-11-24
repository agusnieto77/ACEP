
test_that("ACEP svo", {
  skip_if_offline()
  skip_on_cran()
  spacy_postag <- acep_svo(acep_bases$spacy_postag)
  dimensiones <- length(spacy_postag)
  expect_equal(dimensiones, length(spacy_postag))
})
