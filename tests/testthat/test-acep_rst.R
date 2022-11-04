
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


test_that("ACEP RST ANIO E1", {
  skip_if_offline()
  skip_on_cran()
  datos <- acep_bases$rp_procesada
  datos_procesados_anio <- acep_rst(datos$fecha,
                                    datos$fecha,
                                    datos$n_palabras,
                                    datos$conflictos,
                                    st = "anio", u = 4)
  dimensiones <- 12
  expect_equal(dimensiones, 12)
})

test_that("ACEP RST DIA E2", {
  skip_if_offline()
  skip_on_cran()
  datos <- acep_bases$rp_procesada
  names(datos) <- c("A", "B", "C", "D")
  datos_procesados_dia <- acep_rst(datos,
                                   datos$fecha,
                                   datos$n_palabras,
                                   datos$conflictos,
                                   st = "dia")
  dimensiones <- 2895
  expect_equal(dimensiones, 2895)
})

test_that("ACEP RST MES E3", {
  skip_if_offline()
  skip_on_cran()
  datos <- acep_bases$rp_procesada
  datos_procesados_mes <- acep_rst(datos,
                                   datos,
                                   datos$n_palabras,
                                   datos$conflictos,
                                   st = "mes")
  dimensiones <- 142
  expect_equal(dimensiones, 142)
})


test_that("ACEP RST ANIO E4", {
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

test_that("ACEP RST DIA E5", {
  skip_if_offline()
  skip_on_cran()
  datos <- acep_bases$rp_procesada
  datos_procesados_dia <- acep_rst(datos,
                                   datos$n_palabras,
                                   datos$n_palabras,
                                   datos$conflictos,
                                   st = "dia")
  dimensiones <- 2895
  expect_equal(dimensiones, 2895)
})

test_that("ACEP RST MES E6", {
  skip_if_offline()
  skip_on_cran()
  datos <- acep_bases$rp_procesada
  datos_procesados_mes <- acep_rst(datos,
                                   datos$fecha,
                                   datos$n_palabras,
                                   datos$fecha,
                                   st = "mes")
  dimensiones <- 142
  expect_equal(dimensiones, 142)
})


test_that("ACEP RST MES E7", {
  skip_if_offline()
  skip_on_cran()
  datos <- acep_bases$rp_procesada
  datos_procesados_mes <- acep_rst(datos,
                                   datos$fecha,
                                   datos$fecha,
                                   datos$conflictos,
                                   st = "mes")
  dimensiones <- 142
  expect_equal(dimensiones, 142)
})
