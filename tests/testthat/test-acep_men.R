
test_that("ACEP Men Tolower T", {
  skip_if_offline()
  skip_on_cran()
  df <- data.frame(texto =
  c("El SUTEBA fue al paro. Reclaman mejoras salariales.",
    "El SOIP lleva adelante un plan de lucha con paros y piquetes."))
  diccionario <- c("paro", "lucha", "piquetes")
  df$detect <- acep_men(df$texto, diccionario)
  dimensiones <- length(df$detect)
  expect_equal(dimensiones, length(df$detect))
})

test_that("ACEP Men Tolower F", {
  skip_if_offline()
  skip_on_cran()
  df <- data.frame(texto =
  c("El SUTEBA fue al paro. Reclaman mejoras salariales.",
    "El SOIP lleva adelante un plan de lucha con paros y piquetes."))
  diccionario <- c("paro", "lucha", "piquetes")
  df$detect <- acep_men(df$texto, diccionario, tolower = FALSE)
  dimensiones <- length(df$detect)
  expect_equal(dimensiones, length(df$detect))
})

test_that("ACEP Men Tolower T E1", {
  skip_if_offline()
  skip_on_cran()
  df <- data.frame(texto =
                     c("El SUTEBA fue al paro. Reclaman mejoras salariales.",
                       "El SOIP lleva adelante un plan de lucha con paros y piquetes."))
  diccionario <- c("paro", "lucha", "piquetes")
  df$detect <- acep_men(df, diccionario)
  dimensiones <- length(df$detect)
  expect_equal(dimensiones, length(df$detect))
})

test_that("ACEP Men Tolower T E2", {
  skip_if_offline()
  skip_on_cran()
  df <- data.frame(texto =
                     c("El SUTEBA fue al paro. Reclaman mejoras salariales.",
                       "El SOIP lleva adelante un plan de lucha con paros y piquetes."))
  diccionario <- c("paro", "lucha", "piquetes")
  df$detect <- acep_men(df$texto, df)
  dimensiones <- length(df$detect)
  expect_equal(dimensiones, length(df$detect))
})
