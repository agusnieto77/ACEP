#' @title Carga bases de datos creadas por el Observatorio.
#' @description Función para cargar bases de datos disponibles online.
#' Por ahora están disponibles las siguientes bases: Revista Puerto 'rp_mdp';
#' La Nueva 'ln_bb', La Capital 'lc_mdp', Ecos Diarios 'ed_neco',
#' La Nación 'ln_arg'
#' @param tag etiqueta identificatoria del data frame a cargar:
#' acep_bases$rp_mdp, acep_bases$ln_bb, acep_bases$lc_mdp,
#' acep_bases$ed_neco, acep_bases$ln_arg
#' @keywords datos
#' @export acep_load_base
#' @importFrom utils download.file
#' @return Si todas las entradas son correctas,
#' la salida será una base de datos en formato tabular con un corpus de notas.
#' @examples
#' bd_sismos <-
#' 'https://zenodo.org/record/6835713/files/bd_sismos_mdp.rds?download=1'
#' acep_load_base(tag = bd_sismos) |> head()
#' @export
acep_load_base <- function(tag) {
  url <- gsub("\\?download=1", "", tag)
  nombre <- basename(url)
  destfile <- file.path(tempdir(), nombre)
  download.file(url, destfile)
  readRDS(destfile)
}
