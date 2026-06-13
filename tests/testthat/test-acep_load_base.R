# Offline tests (no network). acep_load_base downloads remote datasets, so its
# successful-download path is intentionally not exercised here (CRAN policy:
# tests must not require internet access). We test the input-validation contract.
test_that("acep_load_base valida el argumento tag", {
  expect_error(acep_load_base(123), "URL")
  expect_error(acep_load_base(c("a", "b")), "URL")
  expect_error(acep_load_base(NA_character_), "URL")
})
