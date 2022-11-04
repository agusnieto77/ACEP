#' @title Carga bases de datos creadas por el Observatorio.
#' @description Funcion para cargar bases de datos disponibles online.
#' Por ahora estan disponibles las siguientes bases: Revista Puerto 'rp_mdp';
#' La Nueva 'ln_bb', La Capital 'lc_mdp', Ecos Diarios 'ed_neco',
#' La Nacion 'ln_arg'
#' @param tag etiqueta identificatoria del data frame a cargar:
#' acep_bases$rp_mdp, acep_bases$ln_bb, acep_bases$lc_mdp,
#' acep_bases$ed_neco, acep_bases$ln_arg
#' @keywords datos
#' @export acep_load_base
#' @importFrom utils download.file
#' @return Si todas las entradas son correctas,
#' la salida sera una base de datos en formato tabular con un corpus de notas.
#' @examples
#' bd_sismos <- acep_bases$rev_puerto
#' acep_load_base(tag = bd_sismos) |> head()
#' @export
acep_load_base <- function(tag) {
  out <- tryCatch(
    { message("Descargando...")
      url <- gsub("\\?download=1", "", tag)
      nombre <- basename(url)
      destfile <- file.path(tempdir(), nombre)
      download.file(url, destfile)
      readRDS(destfile)
    },
    error=function(cond) {
      message(paste("La URL parece no existir:", url))
      message("Este es el mensaje de error original:")
      message(cond)
      return(message("\nIntentalo nuevamente!"))
    },
    warning=function(cond) {
      message(paste("La URL causo una advertencia:", url))
      message("Este es el mensaje de advertencia original:")
      message(cond)
      return(message("\nIntentalo nuevamente!"))
    }
  )
  return(out)
}
