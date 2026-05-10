test_that("optimization fixtures provide offline clean inputs", {
  inputs <- acep_fixture_clean_text()

  expect_equal(length(inputs), 2)
  expect_equal(inputs[[1]], "El SUTEBA fue al paro. Reclaman mejoras salariales.")
  expect_match(inputs[[2]], "#Paro", fixed = TRUE)
})

test_that("optimization fixtures provide deterministic offline flows", {
  count_fixture <- acep_fixture_count()
  pos_fixture <- acep_fixture_pos()
  provider_success <- acep_fixture_provider_success()
  provider_error <- acep_fixture_provider_error()

  expect_equal(count_fixture$dic, c("paro", "lucha", "piquetes"))
  expect_s3_class(pos_fixture, "tokenIndex")
  expect_equal(names(provider_success), c("provider", "status_code", "body"))
  expect_equal(provider_error$status_code, 401L)
})

test_that("acep_clean current behavior is characterized", {
  cleaned <- acep_clean(acep_fixture_clean_text())

  expect_equal(
    cleaned,
    c("suteba paro reclaman mejoras salariales", "marcha mar plata")
  )
  expect_snapshot_value(cleaned, style = "json2")
})

test_that("acep_clean edge behavior is approval-tested before optimization", {
  edge_text <- c(
    "ÁÉÍÓÚ Ñandú!!! https://example.com/@uno #Etiqueta 😊\nMartes 25 de Mayo",
    "Sin cambios? ABC 123 @user #Hash http://foo.bar"
  )
  accent_text <- c("Árbol Ñandú y Educación", "Lunes, Mayo 25!!!")

  expect_equal(acep_clean(edge_text), c("aeiou nandu", "cambios abc"))
  expect_equal(
    acep_clean(accent_text, rm_stopwords = FALSE, rm_shortwords = FALSE),
    c("arbol nandu y educacion", "")
  )
  expect_equal(
    acep_clean(accent_text, rm_cesp = FALSE, rm_stopwords = FALSE, rm_shortwords = FALSE),
    c("árbol ñandú y educación", "")
  )
  expect_equal(
    acep_clean("Uno\nDos   Tres", rm_stopwords = FALSE, rm_shortwords = FALSE, rm_punt = FALSE, rm_num = FALSE),
    "uno dos tres"
  )
  expect_equal(
    acep_clean("Uno\nDos   Tres", rm_stopwords = FALSE, rm_shortwords = FALSE, rm_whitespace = FALSE),
    "uno dos   tres"
  )
  expect_equal(length(acep_clean(edge_text)), length(edge_text))
})

test_that("acep_count current behavior is characterized", {
  fixture <- acep_fixture_count()
  counted <- acep_count(fixture$texto, fixture$dic)

  expect_equal(counted, c(3L, 2L, 0L))
  expect_snapshot_value(counted, style = "json2")
})

test_that("acep_count edge semantics are approval-tested before optimization", {
  edge_text <- c(
    "paro paros paro.",
    "Paro PARO paro",
    "sin datos",
    NA_character_,
    "",
    "piquetes, lucha; paro!"
  )
  repeated_dic <- c("paro", "lucha", "piquetes", "paro")

  expect_equal(acep_count(edge_text, repeated_dic), c(3L, 1L, 0L, NA_integer_, 0L, 3L))
  expect_equal(
    acep_count(edge_text, repeated_dic, use_cache = FALSE),
    acep_count(edge_text, repeated_dic, use_cache = TRUE)
  )
  expect_equal(acep_count(c("el paro y paros", "paro"), " paro ", use_cache = FALSE), c(1L, 1L))
  expect_equal(acep_count("paro, paro. paros", "paro", use_cache = FALSE), 3L)
  expect_equal(acep_count("Árbol árbol arbol", c("árbol", "arbol"), use_cache = FALSE), 2L)
})

test_that("acep_count cache reuses normalized repeated dictionaries", {
  acep_clear_regex_cache()
  on.exit(acep_clear_regex_cache(), add = TRUE)

  expect_equal(acep_count("paro paro", c("paro", "paro")), 2L)
  expect_equal(acep_count("paro paro", "paro"), 2L)
  expect_equal(acep_regex_cache_size(), 1L)
})

test_that("acep_svo stable return schemas are characterized", {
  svo <- acep_svo(acep_fixture_svo())

  expect_equal(
    names(svo),
    c(
      "acep_annotate_svo", "acep_pro_svo", "acep_list_svo", "acep_sp",
      "acep_lista_lemmas", "acep_no_procesadas"
    )
  )
  expect_equal(svo$acep_list_svo$eventos[[1]], "SOIP -> declara -> Mar huelga")
  expect_equal(svo$acep_list_svo$sujeto[[1]], "SOIP")
  expect_equal(svo$acep_list_svo$verbo[[1]], "declara")
  expect_equal(svo$acep_list_svo$objeto[[1]], "Mar huelga")
  expect_snapshot_value(
    lapply(svo, function(x) list(class = class(x), dim = dim(x), names = names(x))),
    style = "json2"
  )
})

test_that("acep_svo repeated-document semantics are approval-tested before optimization", {
  tokenindex <- do.call(rbind, replicate(3L, acep_fixture_svo(), simplify = FALSE))
  tokenindex$doc_id <- rep(seq_len(3L), each = nrow(acep_fixture_svo()))
  class(tokenindex) <- class(acep_fixture_svo())

  svo <- acep_svo(tokenindex)

  expected_events <- rep("SOIP -> declara -> Mar huelga", 3L)

  expect_equal(svo$acep_list_svo$doc_id, 1:3)
  expect_equal(svo$acep_list_svo$oracion_id, rep(1L, 3L))
  expect_equal(svo$acep_list_svo$eventos, expected_events)
  expect_equal(svo$acep_list_svo$sujeto, rep("SOIP", 3L))
  expect_equal(svo$acep_list_svo$verbo, rep("declara", 3L))
  expect_equal(svo$acep_list_svo$objeto, rep("Mar huelga", 3L))
  expect_equal(nrow(svo$acep_no_procesadas), 0L)
})

test_that("acep_svo token aggregation helper preserves fallback semantics", {
  collapse_tokens <- getFromNamespace(".acep_svo_collapse_tokens", "ACEP")
  tokenindex <- acep_fixture_svo()
  annotated <- tokenindex
  annotated$s_p <- ifelse(annotated$token %in% c("Mar", "Plata", "SOIP"), "sujeto", "predicado")

  subject_tokens <- subset(annotated, s_p == "sujeto")
  collapsed_subject <- collapse_tokens(subject_tokens, annotated, "sujeto")

  expect_equal(names(collapsed_subject), c("doc_id", "sentence", "sujeto"))
  expect_equal(collapsed_subject$doc_id, 1L)
  expect_equal(collapsed_subject$sentence, 1L)
  expect_equal(collapsed_subject$sujeto, "Mar Plata SOIP")

  empty_predicate <- collapse_tokens(
    annotated[0, ],
    annotated,
    "predicados"
  )

  expect_equal(names(empty_predicate), c("doc_id", "sentence", "predicados"))
  expect_equal(nrow(empty_predicate), 1L)
  expect_true(is.na(empty_predicate$predicados[[1]]))

  collapsed_sent <- collapse_tokens(subject_tokens, annotated, "conjugaciones", c("doc_id", "sentence", "sent"))
  expect_equal(names(collapsed_sent), c("doc_id", "sentence", "sent", "conjugaciones"))
  expect_equal(collapsed_sent$conjugaciones, "Mar Plata SOIP")
})

test_that("acep_postag helper normalizes parsed chunks without changing row semantics", {
  normalize_parse <- getFromNamespace(".acep_postag_normalize_parse", "ACEP")

  parsed <- data.frame(
    doc_id = c("text1", "text2", "text3"),
    sentence = c(1L, 1L, 1L),
    token = c("Mar", "", "SOIP"),
    morph = I(list("Number=Sing", "Space=Yes", "Number=Sing")),
    sent = I(list(" En Mar\n", "\n", " reclaman ")),
    stringsAsFactors = FALSE
  )

  normalized <- normalize_parse(parsed, doc_id_offset = 10L)

  expect_equal(normalized$doc_id, c(11L, 13L))
  expect_equal(normalized$sent, c("En Mar", "reclaman"))
  expect_equal(normalized$morph, c("Number=Sing", "Number=Sing"))
  expect_equal(normalized$token, c("Mar", "SOIP"))

  empty_normalized <- normalize_parse(parsed[2, ], doc_id_offset = 0L)
  expect_equal(nrow(empty_normalized), 0L)
  expect_equal(names(empty_normalized), names(parsed))
})

test_that("acep_postag chunk helper preserves contiguous text boundaries", {
  text_chunks <- getFromNamespace(".acep_postag_text_chunks", "ACEP")

  chunks <- text_chunks(letters[1:5], chunk_size = 2L)

  expect_equal(length(chunks), 3L)
  expect_equal(chunks[[1]]$start_idx, 1L)
  expect_equal(chunks[[1]]$end_idx, 2L)
  expect_equal(chunks[[1]]$texto, letters[1:2])
  expect_equal(chunks[[2]]$start_idx, 3L)
  expect_equal(chunks[[2]]$end_idx, 4L)
  expect_equal(chunks[[3]]$start_idx, 5L)
  expect_equal(chunks[[3]]$end_idx, 5L)
  expect_equal(chunks[[3]]$texto, "e")

  one_chunk <- text_chunks(c("uno", "dos"), chunk_size = 10L)
  expect_equal(length(one_chunk), 1L)
  expect_equal(one_chunk[[1]]$texto, c("uno", "dos"))
})

test_that("acep_postag location helper preserves LOC merge and empty schemas", {
  prepare_locations <- getFromNamespace(".acep_postag_prepare_loc_entities", "ACEP")

  entities <- data.frame(
    doc_id = c(1L, 1L, 2L, 2L),
    sentence = c(1L, 1L, 1L, 1L),
    entity = c("Mar_del_Plata", "Mar_del_Plata", "SOIP", "Buenos_Aires"),
    entity_type = c("LOC", "LOC", "ORG", "LOC"),
    stringsAsFactors = FALSE
  )
  tokenindex <- data.frame(
    doc_id = c(1L, 1L, 2L),
    sentence = c(1L, 1L, 1L),
    token = c("Mar", "Plata", "Buenos"),
    stringsAsFactors = FALSE
  )

  prepared <- prepare_locations(entities, tokenindex)

  expect_equal(names(prepared), c("entity_", "doc_id", "sentence", "entity", "entity_type"))
  expect_equal(prepared$entity_, c("Mar del Plata", "Buenos Aires"))
  expect_equal(prepared$doc_id, c(1L, 2L))
  expect_equal(prepared$entity_type, c("LOC", "LOC"))

  empty_prepared <- prepare_locations(entities[entities$entity_type == "ORG", ], tokenindex)
  expect_equal(
    names(empty_prepared),
    c("entity_", "doc_id", "sentence", "entity", "entity_type", "lat", "long")
  )
  expect_equal(nrow(empty_prepared), 0L)
})

test_that("acep_postag_hibrido helpers preserve chunk, parse, and LOC pre-geocode semantics", {
  normalize_parse <- getFromNamespace(".acep_postag_hibrido_normalize_parse", "ACEP")
  text_chunks <- getFromNamespace(".acep_postag_hibrido_text_chunks", "ACEP")
  prepare_locations <- getFromNamespace(".acep_postag_hibrido_prepare_loc_entities", "ACEP")

  parsed <- data.frame(
    doc_id = c("text1", "text2", "text3"),
    sentence = c(1L, 1L, 1L),
    token = c("Mar", "", "SOIP"),
    morph = I(list("Number=Sing", "Space=Yes", "Number=Sing")),
    sent = I(list(" En Mar\n", "\n", " reclaman ")),
    stringsAsFactors = FALSE
  )

  normalized <- normalize_parse(parsed, doc_id_offset = 20L)

  expect_equal(normalized$doc_id, c(21L, 23L))
  expect_equal(normalized$sent, c("En Mar", "reclaman"))
  expect_equal(normalized$morph, c("Number=Sing", "Number=Sing"))
  expect_equal(normalized$token, c("Mar", "SOIP"))

  chunks <- text_chunks(letters[1:5], chunk_size = 2L)
  expect_equal(length(chunks), 3L)
  expect_equal(chunks[[1]]$start_idx, 1L)
  expect_equal(chunks[[1]]$end_idx, 2L)
  expect_equal(chunks[[1]]$texto, letters[1:2])
  expect_equal(chunks[[2]]$start_idx, 3L)
  expect_equal(chunks[[2]]$end_idx, 4L)
  expect_equal(chunks[[3]]$start_idx, 5L)
  expect_equal(chunks[[3]]$end_idx, 5L)
  expect_equal(chunks[[3]]$texto, "e")

  entities <- data.frame(
    doc_id = c(1L, 1L, 2L, 2L),
    sentence = c(1L, 1L, 1L, 1L),
    entity = c("Mar_del_Plata", "Mar_del_Plata", "SOIP", "Buenos_Aires"),
    entity_type = c("LOC", "LOC", "ORG", "LOC"),
    stringsAsFactors = FALSE
  )

  prepared <- prepare_locations(entities)

  expect_equal(names(prepared), c("doc_id", "sentence", "entity", "entity_type", "entity_"))
  expect_equal(prepared$entity_, c("Mar del Plata", "Buenos Aires"))
  expect_equal(prepared$doc_id, c(1L, 2L))
  expect_equal(prepared$entity_type, c("LOC", "LOC"))

  empty_prepared <- prepare_locations(entities[entities$entity_type == "ORG", ])
  expect_equal(
    names(empty_prepared),
    c("entity_", "doc_id", "sentence", "entity", "entity_type", "lat", "long")
  )
  expect_equal(nrow(empty_prepared), 0L)
})

test_that("public exports and hot-path formals are snapshotted", {
  hot_path_formals <- function(fn) {
    vapply(formals(fn), function(arg) paste(deparse(arg), collapse = ""), character(1))
  }

  api <- list(
    exports = sort(getNamespaceExports("ACEP")),
    formals = list(
      acep_clean = hot_path_formals(acep_clean),
      acep_count = hot_path_formals(acep_count),
      acep_svo = hot_path_formals(acep_svo)
    )
  )

  expect_true("acep_clean" %in% api$exports)
  expect_true("acep_count" %in% api$exports)
  expect_true("acep_svo" %in% api$exports)
  expect_equal(api$formals$acep_count[["use_cache"]], "TRUE")
  expect_snapshot_value(api, style = "json2")
})

test_that("manual optimization baseline script is present but not CI-wired", {
  baseline_path <- testthat::test_path("..", "..", "bench", "optimization-baseline.R")

  expect_true(file.exists(baseline_path))
  expect_equal(basename(baseline_path), "optimization-baseline.R")
})

test_that("package footprint artifacts are excluded from source builds", {
  buildignore_path <- testthat::test_path("..", "..", ".Rbuildignore")
  buildignore <- readLines(buildignore_path, warn = FALSE)

  expect_true("^vignettes/.*\\.udpipe$" %in% buildignore)
  expect_true("^bench/.*\\.csv$" %in% buildignore)
  expect_true("^bench/.*\\.rds$" %in% buildignore)
})

test_that("acep_bases canonical data file exposes stable object names and metadata", {
  describe_data_file <- function(path) {
    env <- new.env(parent = emptyenv())
    objects <- load(path, envir = env)
    value <- env[["acep_bases"]]

    list(
      objects = sort(objects),
      class = class(value),
      names = names(value),
      element_classes = lapply(value, class),
      rows = vapply(value, NROW, integer(1)),
      columns = vapply(value, NCOL, integer(1)),
      column_names = lapply(value, names)
    )
  }

  rdata_path <- testthat::test_path("..", "..", "data", "acep_bases.RData")
  rda_path <- testthat::test_path("..", "..", "data", "acep_bases.rda")
  rda_metadata <- describe_data_file(rda_path)

  expect_false(file.exists(rdata_path))
  expect_equal(rda_metadata$objects, "acep_bases")
  expect_equal(
    rda_metadata$names,
    c(
      "ed_neco", "la_nueva", "lc_720", "lc_mdp", "ln_arg", "ln_bb",
      "rev_puerto", "rp_mdp", "rp_procesada", "spacy_postag", "titulares"
    )
  )
  expect_equal(
    rda_metadata$rows[c("lc_720", "rp_procesada", "spacy_postag", "titulares")],
    c(lc_720 = 720L, rp_procesada = 7816L, spacy_postag = 15L, titulares = 8L)
  )
  expect_equal(
    names(ACEP::acep_bases),
    rda_metadata$names
  )
})

test_that("optional dependency helper reports clear Spanish installation guidance", {
  require_helper <- getFromNamespace("acep_require_namespace", "ACEP")

  expect_null(require_helper("stats", "conteo base"))
  expect_error(
    require_helper("acepPaqueteInexistente", "prueba opcional"),
    "La funcionalidad 'prueba opcional' requiere instalar el paquete opcional 'acepPaqueteInexistente'. Instala el paquete con: install.packages\\(\"acepPaqueteInexistente\"\\)",
    fixed = FALSE
  )
})

test_that("heavy NLP and geocoding dependencies are optional in DESCRIPTION", {
  description_path <- testthat::test_path("..", "..", "DESCRIPTION")
  description <- read.dcf(description_path)[1, ]
  imports <- trimws(unlist(strsplit(description[["Imports"]], ",")))
  suggests <- trimws(unlist(strsplit(description[["Suggests"]], ",")))

  optional_packages <- c("spacyr", "reticulate", "udpipe", "rsyntax", "tidygeocoder")
  core_packages <- c("httr", "jsonlite", "stringr", "magrittr")

  expect_false(any(optional_packages %in% imports))
  expect_true(all(optional_packages %in% suggests))
  expect_true(all(core_packages %in% imports))
})

test_that("optional dependency entry points guard their package-specific paths", {
  function_body <- function(name) paste(deparse(body(get(name, envir = asNamespace("ACEP")))), collapse = "\n")

  postag_body <- function_body("acep_postag")
  postag_hibrido_body <- function_body("acep_postag_hibrido")
  upos_body <- function_body("acep_upos")
  svo_body <- function_body("acep_svo")

  expect_match(postag_body, 'acep_require_namespace\\("spacyr", "acep_postag"\\)')
  expect_match(postag_body, 'acep_require_namespace\\("rsyntax", "acep_postag"\\)')
  expect_match(postag_body, 'acep_require_namespace\\("tidygeocoder", "acep_postag"\\)')
  expect_match(postag_body, 'acep_require_namespace\\("reticulate", "acep_postag"\\)')

  expect_match(postag_hibrido_body, 'acep_require_namespace\\("spacyr", "acep_postag_hibrido"\\)')
  expect_match(postag_hibrido_body, 'acep_require_namespace\\("rsyntax", "acep_postag_hibrido"\\)')
  expect_match(postag_hibrido_body, 'acep_require_namespace\\("tidygeocoder", "acep_postag_hibrido"\\)')
  expect_match(postag_hibrido_body, 'acep_require_namespace\\("reticulate", "acep_postag_hibrido"\\)')

  expect_match(upos_body, 'acep_require_namespace\\("udpipe", "acep_upos"\\)')
  expect_match(upos_body, 'acep_require_namespace\\("rsyntax", "acep_upos"\\)')
  expect_match(svo_body, 'acep_require_namespace\\("rsyntax", "acep_svo"\\)')
})

test_that("provider wrappers keep only core HTTP/JSON dependencies mandatory", {
  provider_functions <- c(
    "acep_claude", "acep_gemini", "acep_gpt", "acep_ollama",
    "acep_openrouter", "acep_together"
  )
  provider_sources <- vapply(
    provider_functions,
    function(name) paste(deparse(body(get(name, envir = asNamespace("ACEP")))), collapse = "\n"),
    character(1)
  )

  expect_true(any(grepl("httr::", provider_sources, fixed = TRUE)))
  expect_true(any(grepl("jsonlite::", provider_sources, fixed = TRUE)))
  expect_false(any(grepl("spacyr::|reticulate::|tidygeocoder::|rsyntax::|udpipe::", provider_sources)))
})

test_that("provider shared helpers preserve schema protection, prompts, endpoints, and headers", {
  default_schema <- getFromNamespace(".acep_provider_default_schema", "ACEP")
  user_prompt <- getFromNamespace(".acep_provider_user_prompt", "ACEP")
  schema_fields <- getFromNamespace(".acep_provider_schema_field_descriptions", "ACEP")
  provider_endpoint <- getFromNamespace(".acep_provider_endpoint", "ACEP")
  provider_headers <- getFromNamespace(".acep_provider_auth_headers", "ACEP")
  openai_token_field <- getFromNamespace(".acep_openai_token_limit_field", "ACEP")
  openrouter_structured <- getFromNamespace(".acep_openrouter_model_supports_structured_outputs", "ACEP")

  schema <- default_schema()

  expect_equal(schema$type, "object")
  expect_equal(names(schema$properties), "respuesta")
  expect_equal(unclass(schema$required), "respuesta")
  expect_true(inherits(schema$required, "AsIs"))
  expect_false(is.null(schema$additionalProperties))

  gemini_schema <- default_schema(additional_properties = FALSE, protect_arrays = FALSE)
  expect_equal(names(gemini_schema), c("type", "properties", "required"))
  expect_false(inherits(gemini_schema$required, "AsIs"))

  expect_equal(
    user_prompt("Texto de prueba", "Extrae campos"),
    "Texto a analizar:\nTexto de prueba\n\nInstrucciones:\nExtrae campos"
  )
  expect_equal(
    unname(schema_fields(acep_gpt_schema("clasificacion"))),
    c(
      "- categoria: Categoria principal del texto",
      "- confianza: Nivel de confianza de 0 a 1",
      "- justificacion: Breve justificacion de la clasificacion"
    )
  )

  expect_equal(provider_endpoint("openai"), "https://api.openai.com/v1/chat/completions")
  expect_equal(provider_endpoint("anthropic"), "https://api.anthropic.com/v1/messages")
  expect_equal(
    provider_endpoint("gemini", modelo = "gemini-2.5-flash"),
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"
  )
  expect_equal(provider_endpoint("together"), "https://api.together.xyz/v1/chat/completions")
  expect_equal(provider_endpoint("openrouter"), "https://openrouter.ai/api/v1/chat/completions")
  expect_equal(openai_token_field("gpt-4o-mini"), "max_tokens")
  expect_equal(openai_token_field("gpt-5-mini"), "max_completion_tokens")
  expect_equal(openai_token_field("o4-mini"), "max_completion_tokens")
  expect_true(openrouter_structured("openai/gpt-4o-mini"))
  expect_true(openrouter_structured("google/gemini-2.5-flash"))
  expect_false(openrouter_structured("anthropic/claude-sonnet-4.5"))

  openrouter_headers <- provider_headers(
    "openrouter",
    api_key = "clave",
    site_url = "https://acep.test",
    app_name = "ACEP"
  )
  expect_equal(openrouter_headers$Authorization, "Bearer clave")
  expect_equal(openrouter_headers$`HTTP-Referer`, "https://acep.test")
  expect_equal(openrouter_headers$`X-Title`, "ACEP")
})

test_that("provider response helpers parse JSON and preserve Spanish error behavior without network", {
  validate_inputs <- getFromNamespace(".acep_provider_validate_request_inputs", "ACEP")
  clean_json <- getFromNamespace(".acep_provider_clean_json_response", "ACEP")
  parse_json <- getFromNamespace(".acep_provider_parse_json_response", "ACEP")
  chat_content <- getFromNamespace(".acep_provider_extract_chat_content", "ACEP")

  expect_null(validate_inputs("texto", "instrucciones", "clave", "OPENAI_API_KEY"))
  expect_error(
    validate_inputs("", "instrucciones", "clave", "OPENAI_API_KEY"),
    "El parametro 'texto' debe ser una cadena de caracteres no vacia",
    fixed = TRUE
  )
  expect_error(
    validate_inputs("texto", "", "clave", "OPENAI_API_KEY"),
    "El parametro 'instrucciones' debe ser una cadena de caracteres no vacia",
    fixed = TRUE
  )
  expect_error(
    validate_inputs("texto", "instrucciones", "", "OPENAI_API_KEY"),
    "API key no encontrada. Define la variable de entorno OPENAI_API_KEY o pasa el parametro api_key",
    fixed = TRUE
  )

  fenced <- "```json\n{\"respuesta\":\"ok\"}\n```"
  expect_equal(clean_json(fenced), "{\"respuesta\":\"ok\"}")
  expect_equal(parse_json(fenced, parse_json = FALSE), "{\"respuesta\":\"ok\"}")
  expect_equal(parse_json(fenced, parse_json = TRUE), list(respuesta = "ok"))
  expect_error(
    parse_json("{no valido", parse_json = TRUE),
    "Error al parsear JSON de la respuesta. Contenido recibido",
    fixed = TRUE
  )

  parsed <- list(choices = list(list(message = list(content = "{\"respuesta\":\"ok\"}"))))
  expect_equal(chat_content(parsed), "{\"respuesta\":\"ok\"}")
  expect_error(
    chat_content(list(choices = list())),
    "La API devolvio una respuesta vacia. Verifica tu prompt y esquema.",
    fixed = TRUE
  )
})
