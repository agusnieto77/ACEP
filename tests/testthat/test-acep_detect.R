
test_that("ACEP DETECT", {
  skip_if_offline()
  skip_on_cran()
  df <- data.frame(texto = c("El SUTEBA fue al paro. Reclaman mejoras salariales.",
  "El SOIP lleva adelante un plan de lucha con paros y piquetes."))
  diccionario <- c("paro", "lucha", "piquetes")
  detect <- acep_detect(df$texto, diccionario)
  dimensiones <- length(detect)
  expect_equal(dimensiones, length(detect))
})

test_that("ACEP DETECT F", {
  skip_if_offline()
  skip_on_cran()
  df <- data.frame(texto = c("El SUTEBA fue al paro. Reclaman mejoras salariales.",
                             "El SOIP lleva adelante un plan de lucha con paros y piquetes."))
  diccionario <- c("paro", "lucha", "piquetes")
  detect <- acep_detect(df$texto, diccionario, tolower = FALSE)
  dimensiones <- length(detect)
  expect_equal(dimensiones, length(detect))
})

test_that("ACEP DETECT E1", {
  skip_if_offline()
  skip_on_cran()
  df <- data.frame(texto = c("El SUTEBA fue al paro. Reclaman mejoras salariales.",
                             "El SOIP lleva adelante un plan de lucha con paros y piquetes."))
  diccionario <- c("paro", "lucha", "piquetes")
  detect <- acep_detect(df, diccionario)
  dimensiones <- 1
  expect_equal(dimensiones, length(dimensiones))
})
