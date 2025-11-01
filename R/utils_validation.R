#' Validate Character Input
#'
#' @description Internal helper function to validate character vector inputs.
#' @param x The input to validate.
#' @param arg_name Name of the argument being validated (for error messages).
#' @param allow_null Logical. If TRUE, NULL values are accepted. Default FALSE.
#' @return Throws an error if validation fails, otherwise returns invisibly.
#' @keywords internal
#' @noRd
validate_character <- function(x, arg_name = "x", allow_null = FALSE) {
  if (allow_null && is.null(x)) {
    return(invisible(NULL))
  }

  if (!is.character(x) || is.list(x)) {
    stop(
      sprintf("El parametro '%s' debe ser un vector de texto (character).\n", arg_name),
      sprintf("Recibido: %s", class(x)[1]),
      call. = FALSE
    )
  }

  invisible(NULL)
}

#' Validate Numeric Input
#'
#' @description Internal helper function to validate numeric inputs.
#' @param x The input to validate.
#' @param arg_name Name of the argument being validated (for error messages).
#' @param min Optional minimum value (inclusive).
#' @param max Optional maximum value (inclusive).
#' @param allow_null Logical. If TRUE, NULL values are accepted. Default FALSE.
#' @return Throws an error if validation fails, otherwise returns invisibly.
#' @keywords internal
#' @noRd
validate_numeric <- function(x, arg_name = "x", min = NULL, max = NULL, allow_null = FALSE) {
  if (allow_null && is.null(x)) {
    return(invisible(NULL))
  }

  if (!is.numeric(x)) {
    stop(
      sprintf("El parametro '%s' debe ser numerico.\n", arg_name),
      sprintf("Recibido: %s", class(x)[1]),
      call. = FALSE
    )
  }

  if (!is.null(min) && any(x < min, na.rm = TRUE)) {
    stop(
      sprintf("El parametro '%s' debe ser >= %s", arg_name, min),
      call. = FALSE
    )
  }

  if (!is.null(max) && any(x > max, na.rm = TRUE)) {
    stop(
      sprintf("El parametro '%s' debe ser <= %s", arg_name, max),
      call. = FALSE
    )
  }

  invisible(NULL)
}

#' Validate Logical Input
#'
#' @description Internal helper function to validate logical (boolean) inputs.
#' @param x The input to validate.
#' @param arg_name Name of the argument being validated (for error messages).
#' @return Throws an error if validation fails, otherwise returns invisibly.
#' @keywords internal
#' @noRd
validate_logical <- function(x, arg_name = "x") {
  if (!is.logical(x) || length(x) != 1) {
    stop(
      sprintf("El parametro '%s' debe ser un valor logico (TRUE o FALSE).\n", arg_name),
      sprintf("Recibido: %s", paste(class(x), collapse = ", ")),
      call. = FALSE
    )
  }

  invisible(NULL)
}

#' Validate Data Frame Structure
#'
#' @description Internal helper function to validate data frame structure.
#' @param df The data frame to validate.
#' @param required_cols Character vector of required column names.
#' @param arg_name Name of the argument being validated (for error messages).
#' @return Throws an error if validation fails, otherwise returns invisibly.
#' @keywords internal
#' @noRd
validate_dataframe <- function(df, required_cols = NULL, arg_name = "datos") {
  if (!is.data.frame(df)) {
    stop(
      sprintf("El parametro '%s' debe ser un data frame.\n", arg_name),
      sprintf("Recibido: %s", class(df)[1]),
      call. = FALSE
    )
  }

  if (!is.null(required_cols)) {
    missing_cols <- setdiff(required_cols, names(df))

    if (length(missing_cols) > 0) {
      stop(
        sprintf("El data frame '%s' debe contener las siguientes columnas: %s\n",
                arg_name, paste(required_cols, collapse = ", ")),
        sprintf("Columnas faltantes: %s\n", paste(missing_cols, collapse = ", ")),
        sprintf("Columnas disponibles: %s", paste(names(df), collapse = ", ")),
        call. = FALSE
      )
    }
  }

  invisible(NULL)
}

#' Validate Date Vector
#'
#' @description Internal helper function to validate Date vectors.
#' @param x The input to validate.
#' @param arg_name Name of the argument being validated (for error messages).
#' @return Throws an error if validation fails, otherwise returns invisibly.
#' @keywords internal
#' @noRd
validate_date <- function(x, arg_name = "fecha") {
  if (!inherits(x, "Date")) {
    # Try to check if it can be converted
    if (is.character(x)) {
      test_date <- try(as.Date(x), silent = TRUE)
      if (inherits(test_date, "try-error")) {
        stop(
          sprintf("El parametro '%s' debe ser un vector de tipo Date o convertible a Date.\n", arg_name),
          sprintf("Recibido: %s\n", class(x)[1]),
          "Sugerencia: Use as.Date() para convertir su vector de fechas.",
          call. = FALSE
        )
      }
    } else {
      stop(
        sprintf("El parametro '%s' debe ser un vector de tipo Date.\n", arg_name),
        sprintf("Recibido: %s\n", class(x)[1]),
        "Sugerencia: Use as.Date() para convertir su vector de fechas.",
        call. = FALSE
      )
    }
  }

  invisible(NULL)
}

#' Validate Choice from Options
#'
#' @description Internal helper function to validate that input matches one of allowed options.
#' @param x The input to validate.
#' @param choices Character vector of allowed values.
#' @param arg_name Name of the argument being validated (for error messages).
#' @return Throws an error if validation fails, otherwise returns invisibly.
#' @keywords internal
#' @noRd
validate_choice <- function(x, choices, arg_name = "x") {
  if (length(x) != 1 || !x %in% choices) {
    stop(
      sprintf("El parametro '%s' debe ser uno de: %s\n",
              arg_name, paste(choices, collapse = ", ")),
      sprintf("Recibido: %s", x),
      call. = FALSE
    )
  }

  invisible(NULL)
}
