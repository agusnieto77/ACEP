
test_that("ACEP SST ANIO", {
  skip_if_offline()
  skip_on_cran()
  datos <- acep_bases$rp_procesada
  datos_procesados_anio <- acep_sst(datos,
                                    st = "anio", u = 4)
  dimensiones <- 12
  expect_equal(dimensiones, 12)
})

test_that("ACEP SST DIA", {
  skip_if_offline()
  skip_on_cran()
  datos <- acep_bases$rp_procesada
  datos_procesados_dia <- acep_sst(datos,
                                   st = "dia")
  dimensiones <- 2895
  expect_equal(dimensiones, 2895)
})

test_that("ACEP SST MES", {
  skip_if_offline()
  skip_on_cran()
  datos <- acep_bases$rp_procesada
  datos_procesados_mes <- acep_sst(datos,
                                   st = "mes")
  dimensiones <- 142
  expect_equal(dimensiones, 142)
})


test_that("ACEP SST ANIO E1", {
  skip_if_offline()
  skip_on_cran()
  datos <- acep_bases$rp_procesada
  datos_procesados_anio <- acep_sst(datos$fecha,
                                    st = "anio", u = 4)
  dimensiones <- 12
  expect_equal(dimensiones, 12)
})

test_that("ACEP SST DIA E2", {
  skip_if_offline()
  skip_on_cran()
  datos <- acep_bases$rp_procesada
  names(datos) <- c("A", "B", "C", "D")
  datos_procesados_dia <- acep_sst(datos,
                                   st = "dia")
  dimensiones <- 2895
  expect_equal(dimensiones, 2895)
})

test_that("ACEP SST MES E3", {
  skip_if_offline()
  skip_on_cran()
  datos <- acep_bases$rp_procesada
  datos_procesados_mes <- acep_sst(datos,
                                   st = "mes")
  dimensiones <- 142
  expect_equal(dimensiones, 142)
})


test_that("ACEP SST ANIO E4", {
  skip_if_offline()
  skip_on_cran()
  datos <- acep_bases$rp_procesada
  datos_procesados_anio <- acep_sst(datos,
                                    st = "anio", u = 4)
  dimensiones <- 12
  expect_equal(dimensiones, 12)
})

test_that("ACEP SST DIA E5", {
  skip_if_offline()
  skip_on_cran()
  datos <- acep_bases$rp_procesada
  datos_procesados_dia <- acep_sst(datos,
                                   st = "dia")
  dimensiones <- 2895
  expect_equal(dimensiones, 2895)
})

test_that("ACEP SST MES E6", {
  skip_if_offline()
  skip_on_cran()
  datos <- acep_bases$rp_procesada
  datos_procesados_mes <- acep_sst(datos,
                                   st = "mes")
  dimensiones <- 142
  expect_equal(dimensiones, 142)
})


test_that("ACEP SST MES E7", {
  skip_if_offline()
  skip_on_cran()
  datos <- acep_bases$rp_procesada
  datos_procesados_mes <- acep_sst(datos,
                                   st = "mes")
  dimensiones <- 142
  expect_equal(dimensiones, 142)
})
