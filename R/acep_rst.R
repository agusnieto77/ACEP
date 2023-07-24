#' @title Serie temporal de indices de conflictividad.
#' @description Función que devuelve los indices de conflictividad
#' agrupados por segmento de tiempo: dia, mes, anio.
#' @param datos data frame con las variables 'fecha' (en formato Date),
#' 'n_palabras' (numérica), conflictos' (numérica), 'intensidad' (numérica).
#' @param fecha columna de data frame que contiene el
#' vector de fechas en formato date.
#' @param frecp columna de data frame que contiene el
#' vector de frecuencia de palabras por texto.
#' @param frecm columna de data frame que contiene el
#' vector de menciones del diccionario por texto.
#' @param st parámetro para establecer el segmento temporal
#' a ser agrupado: anio, mes, día.
#' @param u umbral de menciones para contabilizar una nota
#' como nota que refiere a un conflicto.
#' @param d cantidad de decimales, por defecto tiene 4 pero
#' se puede modificar.
#' @importFrom stats aggregate
#' @return Si todas las entradas son correctas,
#' la salida sera una base de datos en formato tabular
#' con nuevas variables.
#' @keywords resumen
#' @examples
#' datos <- acep_bases$rp_procesada
#' fecha <- datos$fecha
#' n_palabras <- datos$n_palabras
#' conflictos <- datos$conflictos
#' datos_procesados_anio <- acep_rst(datos,
#' fecha, n_palabras, conflictos, st = 'anio', u = 4)
#' datos_procesados_mes <- acep_rst(datos,
#' fecha, n_palabras, conflictos)
#' datos_procesados_dia <- acep_rst(datos,
#' fecha, n_palabras, conflictos, st = 'dia', d = 3)
#' head(datos_procesados_anio)
#' head(datos_procesados_mes)
#' head(datos_procesados_dia)
#' @export
acep_rst <- function(datos, fecha, frecp, frecm,
                     st = "mes", u = 2, d = 4) {
  if(!is.data.frame(datos)){
    return(message("No ingresaste un marco de datos en el par\u00e1metro datos.
                   Vuelve a intentarlo ingresando un marco de datos!"))
  }
  if((paste(names(datos), collapse = '') != "fechan_palabrasconflictosintensidad")){
    return(message("No ingresaste un marco de datos adecuado en el par\u00e1metro datos.
                   Vuelve a intentarlo ingresando un marco de datos adecuado!"))
  }
  if(is.data.frame(fecha)){
    return(message("No ingresaste un vector Date en el par\u00e1metro fecha.
                   Vuelve a intentarlo ingresando un vector de fechas!"))
  }
  if(!all(is.na(as.Date(as.character(fecha),format="%Y-%m-%d"))) == FALSE){
    return(message("No ingresaste un vector Date en el par\u00e1metro fecha.
                   Vuelve a intentarlo ingresando un vector de fechas!"))
  }
  if(!is.numeric(frecp)){
    return(message("No ingresaste un vector numerico en el par\u00e1metro frecp.
                   Vuelve a intentarlo ingresando un vector num\u00e9rico!"))
  }
  if(!is.numeric(frecm)){
    return(message("No ingresaste un vector numerico en el par\u00e1metro frecm.
                   Vuelve a intentarlo ingresando un vector num\u00e9rico!"))
  } else {
    if((paste(names(datos),collapse = '') == "fechan_palabrasconflictosintensidad") &&
       is.data.frame(datos) == TRUE) {
      tryCatch({
  datos <- datos
  datos$anio <- format(fecha, "%Y")
  datos$mes <- paste0(datos$anio, "-", format(fecha, "%m"))
  datos$dia <- fecha
  datos$csn <- ifelse(datos$conflictos > u, 1, 0)
  st  <- if (st == "anio") {
    st <- datos$anio
  } else if (st == "mes") {
    st <- datos$mes
  } else if (st == "dia") {
    st <- datos$dia
    }
  frec_notas <- stats::aggregate(st, by = list(st), FUN = length)
  colnames(frec_notas) <- c("st", "frecn")
  frec_notas_conf <- stats::aggregate(
    csn ~ st, datos, function(x) c(frec_notas_conf = sum(x)))
  frec_palabras <- stats::aggregate(
    frecp ~ st, datos, function(x) c(frec_palabras = sum(x)))
  frec_conflict <- stats::aggregate(
    frecm ~ st, datos, function(x) c(frec_conflict = sum(x)))
  frec_int_acum <- stats::aggregate(
    intensidad ~ st, datos, function(x) c(frec_int_acum = sum(x)))
  colnames(frec_int_acum) <- c("st", "intac")
  frec_pal_con <-
    merge(frec_notas,
          merge(frec_notas_conf,
                merge(frec_palabras,
                      merge(frec_conflict, frec_int_acum))))
  frec_pal_con$intensidad <- acep_int(frec_pal_con$frecm,
                                      frec_pal_con$frecp,
                                      decimales = d)
  frec_pal_con$int_notas_confl <- acep_int(frec_pal_con$csn,
                                           frec_pal_con$frecn,
                                           decimales = d)
  return(frec_pal_con)
      }
      )
    }
  }
}
