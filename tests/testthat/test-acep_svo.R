# Offline validation test (no network, no optional deps). The happy path is
# characterized end-to-end in test-optimization-safety.R using a bundled fixture.
test_that("acep_svo rechaza entradas que no son tokenIndex", {
  expect_error(acep_svo("no es un tokenindex"), "tokenIndex")
  expect_error(acep_svo(data.frame(a = 1)), "tokenIndex")
})
