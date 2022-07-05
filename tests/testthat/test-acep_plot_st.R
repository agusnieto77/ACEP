context("test-acep_plot_st")

test_that("ACEP Plot ST", {
  skip_if_offline()
  skip_on_cran()
  rev_puerto <- acep_load_base('rp_mdp')
  dicc_violencia <- acep_diccionarios$dicc_viol_gp
  datos <- acep_db(rev_puerto, rev_puerto$nota, dicc_violencia, 4)
  datos_procesados_anio <- acep_rst(datos, datos$fecha, datos$n_palabras, datos$conflictos, st = 'anio')
  pst <- acep_plot_st(datos_procesados_anio$st, datos_procesados_anio$frecm,
                t = 'Evolución de la conflictividad en el sector pesquero argentino',
                ejex = 'Años analizados',
                ejey = 'Menciones de términos del diccionario de conflictos',
                etiquetax = 'horizontal')
  dimensiones <- length(pst)
  expect_equal(dimensiones, 0)
})

