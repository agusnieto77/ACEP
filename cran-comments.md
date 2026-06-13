## Release summary

This is a maintenance release of ACEP (0.1.2) with bug fixes, CRAN-policy
hardening, and a stronger offline test suite. No public function signatures were
removed or renamed; new arguments are additive with backward-compatible defaults.

Key changes:

* Correctness fixes in `acep_clean()` (accented uppercase stopwords),
  `acep_count()`/`acep_detect()` (regex metacharacters now treated literally and
  word boundaries applied consistently), `acep_token_table()`/`acep_token_plot()`
  (relative frequency computed over the full corpus), `acep_extract()`/`acep_token()`
  (`NA` handling) and `plot.acep_result()` (serie temporal plots).
* CRAN-policy fix: `acep_token_plot()` now restores `par()` on exit.
* Robustness: an HTTP `timeout` argument was added to the cloud AI providers, and
  network/error handling in `acep_load_base()` was hardened.
* `grDevices` is now declared in Imports (previously used via `::` only).
* Documentation of bundled datasets was corrected to match the actual objects.

## R CMD check results

Local `R CMD check --as-cran` (R 4.5.2, Windows) completed with:

* 0 errors
* 0 warnings
* 0 notes

## Test environments

* Local, Windows 10, R 4.5.2, `R CMD check --as-cran`
* GitHub Actions, R-CMD-check, Ubuntu latest, R release
* win-builder, R-devel (`devtools::check_win_devel()`)

## Downstream dependencies

There are no known downstream dependencies.
