
test_that("ACEP Count", {
  skip_if_offline()
  skip_on_cran()
  df <- data.frame(texto =
                     c("El SOIP fue al paro. Reclaman mejoras salariales.",
                       "El SOIP lleva adelante un plan de lucha con paros y piquetes."))
  diccionario <- c("paro", "lucha", "piquetes")
  df$detect <- acep_count(df$texto, diccionario)
  dimensiones <- length(df$detect)
  expect_equal(dimensiones, length(df$detect))
})
