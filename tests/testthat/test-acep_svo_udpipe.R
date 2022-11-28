
test_that("ACEP svo udpipe", {
  skip_if_offline()
  skip_on_cran()
  svo_udpipe <- acep_svo_udpipe("En Mar del Plata el SOIP decreta una huelga contra la CAIPA en reclamo de aumento salarial.")
  dimensiones <- length(svo_udpipe)
  expect_equal(dimensiones, length(svo_udpipe))
})
