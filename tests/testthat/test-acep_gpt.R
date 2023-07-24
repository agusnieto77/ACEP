
test_that("ACEP gpt", {
  skip_if_offline()
  skip_on_cran()
  texto <- acep_gpt(texto = 1:10, instrucciones = pregunta,
                    gpt_api = api_gpt_acep,
                    url = "https://api.openai.com/v1/chat/completions",
                    modelo = "gpt-3.5-turbo-0613", rol = "user")
  dimensiones <- length(texto)
  expect_equal(dimensiones, length(texto))
})
