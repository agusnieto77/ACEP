context("test-acep_plot_rst")

test_that("ACEP Plot RST", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_bases$rev_puerto
  dicc_violencia <- acep_diccionarios$dicc_viol_gp
  datos <- acep_db(rev_puerto, rev_puerto$nota, dicc_violencia, 4)
  datos_procesados_anio <- acep_rst(datos, datos$fecha, datos$n_palabras, datos$conflictos, st = 'anio')
  prst <- acep_plot_rst(datos_procesados_anio, tagx = 'vertical')
  dimensiones <- length(prst)
  expect_equal(dimensiones, 1)
})

