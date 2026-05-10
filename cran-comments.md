## R CMD check results

0 errors | 1 warning | 2 notes

The warning and one note are local environment limitations:

* `qpdf` is not installed locally, so PDF size reduction checks could not run.
* HTML validation was skipped because the `tidy` command is not installed locally.

The remaining note is the CRAN incoming maintainer spelling note: the
maintainer email is unchanged, but the maintainer name now includes the accent
used elsewhere in the package metadata (`Agustín Nieto`).

## Release summary

This is a major update release of ACEP.

Key changes:

* Added composable text-processing pipeline helpers.
* Added and improved structured-output LLM provider wrappers.
* Reduced mandatory dependency footprint by moving heavy NLP/geocoding
  packages to Suggests with explicit runtime guidance.
* Improved `acep_count()` performance with regex caching.
* Added characterization tests and offline safety fixtures.
* Updated README and vignettes for current install and usage guidance.

## Test environments

* GitHub Actions, R-CMD-check, Ubuntu latest, R release
* GitHub Actions, test-coverage, Ubuntu latest, R release
* GitHub Actions, pkgdown, Ubuntu latest, R release
* Local, Pop!_OS 22.04, R 4.5.1, `R CMD check --as-cran`

## Downstream dependencies

There are no known downstream dependencies.
