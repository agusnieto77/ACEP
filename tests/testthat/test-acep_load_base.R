
test_that("ACEP LOAD", {
  skip_if_offline()
  skip_on_cran()
  tag <- 'https://github.com/HDyCSC/datos/raw/67100a9b73c3fc9053c9dc9227a113bc2d317dae/bd_sismos_mdp.rds'
  oc <- acep_load_base(tag = tag)
  dimensiones <- length(oc$id)
  expect_equal(dimensiones, 5132)
})
