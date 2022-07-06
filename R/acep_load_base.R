#' @title Carga bases de datos creadas por el Observatorio.
#' @description Función para cargar bases de datos disponibles online. Por ahora están disponibles las siguientes bases: Revista Puerto 'rp_mdp'; La Nueva 'ln_bb', La Capital 'lc_mdp', Ecos Diarios 'ed_neco', La Nación 'ln_arg'
#' @param tag etiqueta identificatoria del data frame a cargar: acep_bases$rp_mdp, acep_bases$ln_bb, acep_bases$lc_mdp, acep_bases$ed_neco, acep_bases$ln_arg
#' @keywords datos
#' @export acep_load_base
#' @examples
#' \dontrun{acep_load_base(tag = acep_bases$rp_mdp) |> head()}

acep_load_base <- function(tag){return(readRDS(url(tag,"rb")))}
