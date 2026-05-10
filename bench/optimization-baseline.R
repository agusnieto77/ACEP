# Manual optimization baseline for ACEP hot paths.
#
# Run locally from the repository root with:
#   Rscript bench/optimization-baseline.R
#
# This script is intentionally not wired into CI. It records small/medium timing
# baselines before optimization work changes runtime behavior.

if (requireNamespace("pkgload", quietly = TRUE)) {
  pkgload::load_all(".", quiet = TRUE)
} else {
  library(ACEP)
}

time_case <- function(label, expr, iterations = 5L) {
  expr <- substitute(expr)
  env <- parent.frame()
  timings <- replicate(iterations, system.time(eval(expr, env))[['elapsed']])

  data.frame(
    case = label,
    iterations = iterations,
    min_seconds = min(timings),
    median_seconds = stats::median(timings),
    max_seconds = max(timings),
    stringsAsFactors = FALSE
  )
}

clean_small <- c(
  "El SUTEBA fue al paro. Reclaman mejoras salariales.",
  "Viernes 12: @soip marcha en Mar del Plata!!! https://example.com #Paro 😊"
)
clean_medium <- rep(clean_small, 100L)

count_small <- c("paro lucha paro", "piquetes y paros", "sin coincidencias")
count_medium <- rep(count_small, 100L)
count_dictionary <- c("paro", "lucha", "piquetes")

svo_small <- ACEP::acep_bases$spacy_postag
svo_medium <- do.call(rbind, replicate(20L, svo_small, simplify = FALSE))
svo_medium$doc_id <- rep(seq_len(20L), each = nrow(svo_small))
class(svo_medium) <- class(svo_small)

results <- rbind(
  time_case("acep_clean small", acep_clean(clean_small)),
  time_case("acep_clean medium", acep_clean(clean_medium)),
  time_case("acep_count small", acep_count(count_small, count_dictionary)),
  time_case("acep_count medium", acep_count(count_medium, count_dictionary)),
  time_case("acep_svo small", acep_svo(svo_small)),
  time_case("acep_svo medium", acep_svo(svo_medium), iterations = 3L)
)

print(results, row.names = FALSE)
