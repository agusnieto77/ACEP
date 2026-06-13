# Offline tests (no network).
test_that("acep_db agrega columnas de frecuencia, menciones e intensidad", {
  df <- data.frame(texto = c("El SUTEBA fue al paro. Reclaman mejoras salariales.",
                             "El SOIP lleva adelante un plan de lucha con paros y piquetes."))
  diccionario <- c("paro", "lucha", "piquetes")
  db <- acep_db(df, df$texto, diccionario, 4)

  expect_s3_class(db, "data.frame")
  expect_equal(nrow(db), 2)
  expect_true(all(c("n_palabras", "conflictos", "intensidad") %in% names(db)))
  expect_equal(db$conflictos, c(1, 3))
})

test_that("acep_db informa entradas invalidas", {
  df <- data.frame(texto = c("El SUTEBA fue al paro.", "El SOIP en lucha."))
  diccionario <- c("paro", "lucha")
  expect_message(acep_db(diccionario, df$texto, diccionario, 4), "marco de datos")
  expect_message(acep_db(df, df, diccionario, 4), "par.metro 't'")
  expect_message(acep_db(df, df$texto, df, 4), "par.metro 'd'")
})
