
test_that("ACEP DB", {
  skip_if_offline()
  skip_on_cran()
  df <- data.frame(texto = c("El SUTEBA fue al paro. Reclaman mejoras salariales.",
                             "El SOIP lleva adelante un plan de lucha con paros y piquetes."))
  diccionario <- c("paro", "lucha", "piquetes")
  db <- acep_db(df, df$texto, diccionario, 4)
  dimensiones <- length(df)
  expect_equal(dimensiones, length(df))
})
