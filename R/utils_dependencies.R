#' Check optional package availability
#'
#' Internal helper for optional integrations.
#'
#' @noRd
acep_require_namespace <- function(pkg, feature) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    stop(
      sprintf(
        "La funcionalidad '%s' requiere instalar el paquete opcional '%s'. Instala el paquete con: install.packages(\"%s\")",
        feature,
        pkg,
        pkg
      ),
      call. = FALSE
    )
  }

  invisible(NULL)
}
