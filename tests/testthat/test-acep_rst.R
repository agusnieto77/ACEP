
test_that("ACEP RST ANIO", {
  skip_if_offline()
  skip_on_cran()
  datos <- acep_bases$rp_procesada
  datos_procesados_anio <- acep_rst(datos,
                                    datos$fecha,
                                    datos$n_palabras,
                                    datos$conflictos,
                                    st = "anio", u = 4)
  dimensiones <- length(datos_procesados_anio$st)
  expect_equal(dimensiones, 12)
})

test_that("ACEP RST DIA", {
  skip_if_offline()
  skip_on_cran()
  datos <- acep_bases$rp_procesada
  datos_procesados_dia <- acep_rst(datos,
                                   datos$fecha,
                                   datos$n_palabras,
                                   datos$conflictos,
                                   st = "dia")
  dimensiones <- length(datos_procesados_dia$st)
  expect_equal(dimensiones, 2895)
})

test_that("ACEP RST MES", {
  skip_if_offline()
  skip_on_cran()
  datos <- acep_bases$rp_procesada
  datos_procesados_mes <- acep_rst(datos,
                                   datos$fecha,
                                   datos$n_palabras,
                                   datos$conflictos,
                                   st = "mes")
  dimensiones <- length(datos_procesados_mes$st)
  expect_equal(dimensiones, 142)
})
