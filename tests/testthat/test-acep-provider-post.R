# Offline test of the shared provider POST helper. httr::POST is mocked so no
# network call is made; we only verify the request is assembled correctly.
test_that(".acep_provider_post forwards url, JSON body and encode to httr::POST", {
  post_fn <- getFromNamespace(".acep_provider_post", "ACEP")
  captured <- NULL

  testthat::local_mocked_bindings(
    POST = function(url, ..., body, encode) {
      captured <<- list(url = url, body = body, encode = encode)
      structure(list(status_code = 200L), class = "response")
    },
    .package = "httr"
  )

  res <- post_fn(
    url = "https://example.test/api",
    headers = list("Content-Type" = "application/json",
                   "Authorization" = "Bearer clave"),
    body = list(model = "demo", n = 1),
    timeout = 99
  )

  expect_equal(captured$url, "https://example.test/api")
  expect_equal(captured$encode, "raw")
  # body is serialized to JSON with auto_unbox (scalars, not arrays)
  expect_match(as.character(captured$body), "\"model\":\"demo\"", fixed = TRUE)
  expect_match(as.character(captured$body), "\"n\":1", fixed = TRUE)
})
