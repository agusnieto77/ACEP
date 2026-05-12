## R CMD check results

Pending final `R CMD check --as-cran` before submission.

Local lightweight verification for this patch:

* Changed Rd files parse successfully.
* Changed R source files parse successfully.
* Executable R chunks extracted from changed vignettes parse successfully.

No package build was run while preparing this patch.

## Resubmission

This is a patch release addressing a CRAN check failure on
`r-devel-windows-x86_64` caused by transient SSL/network errors while examples
and vignettes downloaded external resources from GitHub.

The package code was not changed. The release only makes examples and vignettes
CRAN-safe by avoiding executable external downloads during checks.

## Release summary

This is a CRAN hotfix release of ACEP.

Key changes:

* Marked external-download examples as non-executable.
* Replaced executable vignette downloads with bundled data or synthetic examples.
* Preserved interactive guidance for users who want to load external datasets.

## Test environments

* GitHub Actions, R-CMD-check, Ubuntu latest, R release
* GitHub Actions, test-coverage, Ubuntu latest, R release
* GitHub Actions, pkgdown, Ubuntu latest, R release
* Local, Pop!_OS 22.04, R 4.5.1, lightweight parse checks only

## Downstream dependencies

There are no known downstream dependencies.
