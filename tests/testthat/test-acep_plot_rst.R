
test_that("ACEP Plot RST", {
  skip_if_offline()
  skip_on_cran()
  datos <- acep_bases$rp_procesada
  datos_procesados_anio <- acep_rst(datos,
                                    datos$fecha,
                                    datos$n_palabras,
                                    datos$conflictos,
                                    st = "anio")
  prst <- acep_plot_rst(datos_procesados_anio, tagx = "vertical")
  dimensiones <- length(prst)
  expect_equal(dimensiones, 1)
})
