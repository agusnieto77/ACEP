
test_that("ACEP LOAD", {
  skip_if_offline()
  skip_on_cran()
  tag <- 'https://zenodo.org/record/6835713/files/bd_sismos_mdp.rds?download=1'
  oc <- acep_load_base(tag = tag)
  dimensiones <- length(oc$id)
  expect_equal(dimensiones, 5132)
})


