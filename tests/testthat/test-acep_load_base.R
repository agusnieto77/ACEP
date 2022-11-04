
test_that("ACEP LOAD", {
  skip_if_offline()
  skip_on_cran()
  bd_sismos <- acep_bases$rev_puerto
  base <- acep_load_base(tag = bd_sismos) |> head()
  dimensiones <- length(base)
  expect_equal(dimensiones, length(base))
})

test_that("ACEP LOAD", {
  skip_if_offline()
  skip_on_cran()
  bd_sismos <- "https://observatoriodeconflictividad.org/basesdatos/sintildestyy"
  acep_load_base(tag = bd_sismos)
  dimensiones <- 12
  expect_equal(dimensiones, 12)
})
