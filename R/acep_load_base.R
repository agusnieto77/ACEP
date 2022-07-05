#' @title Carga bases de datos creadas por el Observatorio.
#' @description Función para cargar bases de datos disponibles online. Por ahora están disponibles las siguientes bases: Revista Puerto 'rp_mdp'; La Nueva 'ln_bb'
#' @param tag etiqueta identificatoria del data frame a cargar: 'rp_mdp', 'ln_bb'
#' @keywords datos
#' @export acep_load_base
#' @examples
#' \dontrun{acep_load_base('rp_mdp') |> head()}

acep_load_base <- function(tag){
  return(readRDS(url(paste0("https://zenodo.org/record/6795998/files/", tag,".rds"),"rb")))
  }



