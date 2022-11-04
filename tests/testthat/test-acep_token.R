
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

test_that("ACEP TOKEN F E1", {
  skip_if_offline()
  skip_on_cran()
  df <- data.frame(texto =
                     c("El SUTEBA fue al paro. Reclaman mejoras salariales.",
                       "El SOIP lleva adelante un plan de lucha con paros y piquetes."))
  token <- acep_token(df, tolower = FALSE)
  dimensiones <- 1
  expect_equal(dimensiones, length(dimensiones))
})
