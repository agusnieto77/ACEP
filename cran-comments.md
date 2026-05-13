## R CMD check results

GitHub Actions completed successfully for commit
`9658f4aca76b94304fc10b415c61b1d3fb79ead0`:

* `R-CMD-check`: success, Ubuntu latest, R release
* `test-coverage`: success, Ubuntu latest, R release
* `pkgdown`: success, Ubuntu latest, R release

Local `R CMD check --as-cran ACEP_0.1.1.tar.gz` completed with:

* 0 errors
* 1 warning
* 3 notes

The warning and one note are local environment limitations:

* `qpdf` is not installed locally, so PDF size reduction checks could not run.
* HTML validation was skipped because the `tidy` command is not installed locally.

The second note is a local time verification note: `unable to verify current time`.

The remaining note is the CRAN incoming feasibility note showing this hotfix is
submitted 3 days after the previous release. This short interval is intentional:
the patch fixes the current CRAN `r-devel-windows-x86_64` ERROR caused by
external network/SSL failures during examples and vignette rebuilding.

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
* Local, Pop!_OS 22.04, R 4.5.1, `R CMD check --as-cran`

## Downstream dependencies

There are no known downstream dependencies.
