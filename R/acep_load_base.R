#' @title Carga los corpus y las bases creadas por el Observatorio.
#' @description Función para cargar bases de datos disponibles online.
#' Por ahora están disponibles las siguientes bases: Revista Puerto 'rp_mdp';
#' La Nueva 'ln_bb', La Capital 'lc_mdp', Ecos Diarios 'ed_neco',
#' La Nación 'ln_arg'
#' @param tag etiqueta identificatoria del data frame a cargar:
#' acep_bases$rp_mdp, acep_bases$ln_bb, acep_bases$lc_mdp,
#' acep_bases$ed_neco, acep_bases$ln_arg
#' @keywords datos
#' @importFrom utils download.file
#' @importFrom httr GET http_error status_code timeout
#' @return Si la descarga es exitosa, devuelve una base de datos en formato
#' tabular con un corpus de notas. Ante un fallo de red, una URL inexistente o
#' un error de lectura, informa el problema con un `message()` y devuelve `NULL`
#' de forma invisible.
#' @examples
#' \dontrun{
#' bd_sismos <- acep_bases$rev_puerto
#' head(acep_load_base(tag = bd_sismos))
#' }
#' @export
acep_load_base <- function(tag) {
  if (!is.character(tag) || length(tag) != 1L || is.na(tag)) {
    stop("El parametro 'tag' debe ser una unica URL de tipo caracter.",
         call. = FALSE)
  }

  respuesta <- tryCatch(
    httr::GET(tag, httr::timeout(60)),
    error = function(e) {
      message("No se pudo conectar con la URL: ", conditionMessage(e))
      NULL
    }
  )
  if (is.null(respuesta)) {
    return(invisible(NULL))
  }
  if (httr::http_error(respuesta)) {
    message("La URL parece no existir o no esta disponible (HTTP ",
            httr::status_code(respuesta), "). Intentalo con otra url!")
    return(invisible(NULL))
  }

  message("Descargando...")
  tryCatch({
    nombre <- basename(tag)
    destfile <- file.path(tempdir(), nombre)
    utils::download.file(tag, destfile, quiet = TRUE, mode = "wb")
    readRDS(destfile)
  },
  error = function(e) {
    message("Error al descargar o leer el archivo: ", conditionMessage(e))
    invisible(NULL)
  })
}
