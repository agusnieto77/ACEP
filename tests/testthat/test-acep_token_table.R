
test_that("ACEP TOKEN TABLE", {
  skip_if_offline()
  skip_on_cran()
  tokens <- c(rep("paro",15), rep("piquete",25), rep("corte",20), rep("manifestacion",10),
  rep("bloqueo",5), rep("alerta",16), rep("ciudad",12), rep("sindicato",11), rep("paritaria",14),
  rep("huelga",14), rep("escrache",15))
  tokens <- acep_token_table(tokens)
  dimensiones <- length(tokens)
  expect_equal(dimensiones, length(tokens))
})
