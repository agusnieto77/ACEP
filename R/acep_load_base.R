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
#' @importFrom httr GET
#' @return Si todas las entradas son correctas,
#' la salida sera una base de datos en formato tabular con un corpus de notas.
#' @examples
#' bd_sismos <- acep_bases$rev_puerto
#' head(acep_load_base(tag = bd_sismos))
#' @export
acep_load_base <- function(tag) {
  if (httr::GET(tag)$status_code != 200){
    message("La URL parece no existir. Intentalo con otra url!")
  } else {
    message("Descargando...")
    tryCatch({
      nombre <- basename(tag)
      destfile <- file.path(tempdir(), nombre)
      download.file(tag, destfile)
      readRDS(destfile)
    }
    )
  }
}
