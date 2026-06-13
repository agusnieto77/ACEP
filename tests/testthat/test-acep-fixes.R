# Regression tests for the 0.1.2 audit fixes and coverage for the pipeline
# subsystem. Every test here is offline and deterministic (no network, no
# optional dependencies), so they also run on CRAN and give the core API a
# real regression safety net.

# ---------------------------------------------------------------------------
# acep_detect: word-boundary fix (\\b was being inserted as a literal 'b')
# ---------------------------------------------------------------------------
test_that("acep_detect respects space-padded word boundaries", {
  # Space-padded term -> word boundary: matches the whole word only.
  expect_equal(acep_detect("El SOIP fue al paro", " paro "), 1)
  expect_equal(acep_detect("hubo paros pero no", " paro "), 0)
  # Unpadded term keeps the documented partial-match behavior.
  expect_equal(acep_detect("hubo paros", "paro"), 1)
})

# ---------------------------------------------------------------------------
# acep_count / acep_detect: regex metacharacters in dictionaries are escaped
# (previously crashed with U_REGEX_MISMATCHED_PAREN or matched as wildcards)
# ---------------------------------------------------------------------------
test_that("dictionary terms with regex metacharacters are treated literally", {
  expect_silent(acep_count("texto a(b cualquiera", "a(b"))
  expect_equal(acep_count("texto a(b a(b", "a(b"), 2)
  expect_equal(acep_count("precio: $5 y (oferta)", c("$5", "(oferta)")), 2)
  expect_equal(acep_detect("precio $5", "$5"), 1)
  # A dot must be literal, not a wildcard: 'a.b' must not match 'axb'.
  expect_equal(acep_count("axb a.b", "a.b"), 1)
})

# ---------------------------------------------------------------------------
# acep_clean: accented UPPERCASE stopwords are removed (encoding/order fix)
# ---------------------------------------------------------------------------
test_that("acep_clean removes accented uppercase stopwords like their lowercase form", {
  expect_equal(acep_clean("Reclaman MÁS salario"), acep_clean("Reclaman más salario"))
  expect_equal(acep_clean("Dijo que SÍ al paro"), acep_clean("Dijo que sí al paro"))
})

# ---------------------------------------------------------------------------
# acep_extract: NA in -> NA out (not the literal string "NA")
# ---------------------------------------------------------------------------
test_that("acep_extract returns a real NA for NA input", {
  out <- acep_extract(c("huelga y piquete", NA), c("huel", "piq"))
  expect_true(is.na(out[[2]]))
  expect_false(identical(out[[2]], "NA"))
})

# ---------------------------------------------------------------------------
# acep_token: NA input is dropped instead of producing NA token rows
# ---------------------------------------------------------------------------
test_that("acep_token does not emit NA token rows", {
  tk <- acep_token(c("huelga obrera", NA))
  expect_false(any(is.na(tk$tokens)))
})

# ---------------------------------------------------------------------------
# acep_token_table: prop is computed over the full corpus, not the top-u subset
# ---------------------------------------------------------------------------
test_that("acep_token_table prop uses the full corpus as denominator", {
  tokens <- c(rep("a", 50), rep("b", 30), rep("c", 10), rep("d", 5), rep("e", 5))
  tab <- acep_token_table(tokens, u = 3)
  expect_equal(tab$prop[tab$token == "a"], 0.5)
  # The displayed top-3 proportions must not sum to 1 (the corpus is larger).
  expect_lt(sum(tab$prop), 1)
})

# ---------------------------------------------------------------------------
# acep_corpus: input validation
# ---------------------------------------------------------------------------
test_that("acep_corpus validates id length and metadata type", {
  expect_error(acep_corpus(c("a", "b"), id = "uno_solo"), "misma longitud")
  expect_error(acep_corpus("a", metadata = "no_es_lista"), "lista")
  expect_s3_class(acep_corpus(c("a", "b"), id = c("x", "y")), "acep_corpus")
})

# ---------------------------------------------------------------------------
# acep_load_base: input validation and graceful failure contract
# ---------------------------------------------------------------------------
test_that("acep_load_base validates its tag argument", {
  expect_error(acep_load_base(123), "URL")
  expect_error(acep_load_base(c("a", "b")), "URL")
  expect_error(acep_load_base(NA_character_), "URL")
})

# ---------------------------------------------------------------------------
# Pipeline subsystem coverage (acep_corpus / pipe_* / acep_pipeline)
# ---------------------------------------------------------------------------
test_that("acep_corpus builds the expected structure", {
  corpus <- acep_corpus(c("uno", "dos"), metadata = list(fuente = "test"))
  expect_s3_class(corpus, "acep_corpus")
  expect_equal(corpus$texto_original, c("uno", "dos"))
  expect_equal(corpus$id, 1:2)
  expect_null(corpus$texto_procesado)
})

test_that("pipe_clean processes a corpus and records the transformation", {
  corpus <- acep_corpus(c("El SUTEBA va al PARO!!!", "SOIP 123"))
  limpio <- pipe_clean(corpus, rm_num = TRUE, rm_punt = TRUE)
  expect_s3_class(limpio, "acep_corpus")
  expect_false(is.null(limpio$texto_procesado))
  expect_true("limpieza" %in% names(limpio$procesamiento))
})

test_that("pipe_clean accepts a bare character vector", {
  limpio <- pipe_clean(c("El SUTEBA va al paro", "SOIP en lucha"))
  expect_s3_class(limpio, "acep_corpus")
})

test_that("pipe_count returns an acep_result with frequencies", {
  corpus <- acep_corpus(c("paro y lucha", "sin nada"))
  res <- pipe_count(corpus, c("paro", "lucha"))
  expect_s3_class(res, "acep_result")
  expect_equal(res$tipo, "frecuencia")
  expect_equal(res$data$frecuencia, c(2, 0))
})

test_that("pipe_count requires an acep_corpus", {
  expect_error(pipe_count("no soy corpus", "paro"), "acep_corpus")
})

test_that("pipe_intensity computes intensity and keeps class/tipo in sync", {
  res <- pipe_intensity(pipe_count(acep_corpus(c("paro y lucha total", "sin nada aca")),
                                   c("paro", "lucha")))
  expect_equal(res$tipo, "intensidad")
  expect_true(all(c("n_palabras", "intensidad") %in% names(res$data)))
  expect_s3_class(res, "acep_result_intensidad")
})

test_that("pipe_intensity requires a frecuencia column", {
  expect_error(pipe_intensity(acep_result(data.frame(x = 1))), "frecuencia")
})

test_that("acep_pipeline runs the full flow end to end", {
  res <- acep_pipeline(c("El SUTEBA va al paro por mejoras", "SOIP en lucha"),
                       c("paro", "lucha"), clean = TRUE, rm_stopwords = TRUE)
  expect_s3_class(res, "acep_result")
  expect_equal(res$tipo, "intensidad")
  expect_equal(nrow(res$data), 2)
})

# ---------------------------------------------------------------------------
# acep_result S3 methods
# ---------------------------------------------------------------------------
test_that("acep_result print/summary/as.data.frame methods work", {
  res <- acep_result(data.frame(texto = c("a", "b"), frecuencia = c(1, 2)),
                     tipo = "frecuencia")
  expect_output(print(res), "acep_result object")
  expect_output(summary(res), "acep_result summary")
  expect_s3_class(as.data.frame(res), "data.frame")
})

test_that("plot.acep_result on a serie_temporal calls acep_plot_st without error", {
  df <- data.frame(st = c("2020", "2021", "2022"), frecn = c(10, 20, 15))
  res <- acep_result(df, tipo = "serie_temporal")
  pdf(NULL)
  on.exit(grDevices::dev.off())
  expect_no_error(plot(res))
})
