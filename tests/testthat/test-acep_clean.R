
test_that("ACEP CLEAN", {
  skip_if_offline()
  skip_on_cran()
  clean <- acep_clean("El SUTEBA fue al paro. Reclaman mejoras salariales.")
  dimensiones <- length(clean)
  expect_equal(dimensiones, length(clean))
})

test_that("ACEP CLEAN TF", {
  skip_if_offline()
  skip_on_cran()
  clean <- acep_clean("El SUTEBA fue al paro. Reclaman mejoras salariales.", tolower = FALSE)
  dimensiones <- length(clean)
  expect_equal(dimensiones, length(clean))
})

test_that("ACEP CLEAN RMCF", {
  skip_if_offline()
  skip_on_cran()
  clean <- acep_clean("El SUTEBA fue al paro. Reclaman mejoras salariales.", rm_cesp = FALSE)
  dimensiones <- length(clean)
  expect_equal(dimensiones, length(clean))
})

test_that("ACEP CLEAN RMEF", {
  skip_if_offline()
  skip_on_cran()
  clean <- acep_clean("El SUTEBA fue al paro. Reclaman mejoras salariales.", rm_emoji = FALSE)
  dimensiones <- length(clean)
  expect_equal(dimensiones, length(clean))
})

test_that("ACEP CLEAN RMHF", {
  skip_if_offline()
  skip_on_cran()
  clean <- acep_clean("El SUTEBA fue al paro. Reclaman mejoras salariales.", rm_hashtag = FALSE)
  dimensiones <- length(clean)
  expect_equal(dimensiones, length(clean))
})

test_that("ACEP CLEAN RMUF", {
  skip_if_offline()
  skip_on_cran()
  clean <- acep_clean("El SUTEBA fue al paro. Reclaman mejoras salariales.", rm_users = FALSE)
  dimensiones <- length(clean)
  expect_equal(dimensiones, length(clean))
})

test_that("ACEP CLEAN RMPF", {
  skip_if_offline()
  skip_on_cran()
  clean <- acep_clean("El SUTEBA fue al paro. Reclaman mejoras salariales.", rm_punt = FALSE)
  dimensiones <- length(clean)
  expect_equal(dimensiones, length(clean))
})

test_that("ACEP CLEAN RMNF", {
  skip_if_offline()
  skip_on_cran()
  clean <- acep_clean("El SUTEBA fue al paro. Reclaman mejoras salariales.", rm_num = FALSE)
  dimensiones <- length(clean)
  expect_equal(dimensiones, length(clean))
})

test_that("ACEP CLEAN RMURLF", {
  skip_if_offline()
  skip_on_cran()
  clean <- acep_clean("El SUTEBA fue al paro. Reclaman mejoras salariales.", rm_url = FALSE)
  dimensiones <- length(clean)
  expect_equal(dimensiones, length(clean))
})

test_that("ACEP CLEAN RMMF", {
  skip_if_offline()
  skip_on_cran()
  clean <- acep_clean("El SUTEBA fue al paro. Reclaman mejoras salariales.", rm_meses = FALSE)
  dimensiones <- length(clean)
  expect_equal(dimensiones, length(clean))
})

test_that("ACEP CLEAN RMDF", {
  skip_if_offline()
  skip_on_cran()
  clean <- acep_clean("El SUTEBA fue al paro. Reclaman mejoras salariales.", rm_dias = FALSE)
  dimensiones <- length(clean)
  expect_equal(dimensiones, length(clean))
})

test_that("ACEP CLEAN RMSTWF", {
  skip_if_offline()
  skip_on_cran()
  clean <- acep_clean("El SUTEBA fue al paro. Reclaman mejoras salariales.", rm_stopwords = FALSE)
  dimensiones <- length(clean)
  expect_equal(dimensiones, length(clean))
})

test_that("ACEP CLEAN RMSTWTN", {
  skip_if_offline()
  skip_on_cran()
  clean <- acep_clean("El SUTEBA fue al paro. Reclaman mejoras salariales.",
    other_sw = c("mar", "plata", "puerto")
    )
  dimensiones <- length(clean)
  expect_equal(dimensiones, length(clean))
})

test_that("ACEP CLEAN RMSHWF", {
  skip_if_offline()
  skip_on_cran()
  clean <- acep_clean("El SUTEBA fue al paro. Reclaman mejoras salariales.",
    rm_shortwords = FALSE)
  dimensiones <- length(clean)
  expect_equal(dimensiones, length(clean))
})

test_that("ACEP CLEAN RMNLF", {
  skip_if_offline()
  skip_on_cran()
  clean <- acep_clean("El SUTEBA fue al paro. Reclaman mejoras salariales.",
    rm_newline = FALSE)
  dimensiones <- length(clean)
  expect_equal(dimensiones, length(clean))
})

test_that("ACEP CLEAN RMWSF", {
  skip_if_offline()
  skip_on_cran()
  clean <- acep_clean("El SUTEBA fue al paro. Reclaman mejoras salariales.",
    rm_whitespace = FALSE)
  dimensiones <- length(clean)
  expect_equal(dimensiones, length(clean))
})

test_that("ACEP CLEAN ERROR", {
  skip_if_offline()
  skip_on_cran()
  df <- data.frame(V1=c(1:10), V2=c(letters[1:10]))
  clean <- acep_clean(df)
  dimensiones <- length(clean)
  expect_equal(dimensiones, length(clean))
})
