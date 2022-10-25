
test_that("ACEP Plot ST", {
  skip_if_offline()
  skip_on_cran()
  datos <- acep_bases$rp_procesada[1:2000,]
  datos_procesados_anio <- acep_rst(datos, datos$fecha, datos$n_palabras, datos$conflictos, st = 'mes')
  pst <- acep_plot_st(datos_procesados_anio$st, datos_procesados_anio$frecm,
                t = 'Evolución de la conflictividad en el sector pesquero argentino',
                ejex = 'Meses analizados',
                ejey = 'Menciones de términos del diccionario de conflictos',
                etiquetax = 'horizontal')
  dimensiones <- length(pst)
  expect_equal(dimensiones, 0)
})

