#' @title Serie temporal de indices de conflictividad.
#' @description Funcion que devuelve los indices de conflictividad
#' agrupados por segmento de tiempo: dia, mes, anio.
#' @param datos data frame con los textos a procesar.
#' @param fecha columna de data frame que contiene el
#' vector de fechas en formato date.
#' @param frecp columna de data frame que contiene el
#' vector de frecuencia de palabras por texto.
#' @param frecm columna de data frame que contiene el
#' vector de menciones del diccionario por texto.
#' @param st parametro para establecer el segmento temporal
#' a ser agrupado: anio, mes, dia.
#' @param u umbral de menciones para contabilizar una nota
#' como nota que refiere a un conflicto.
#' @param d cantidad de decimales, por defecto tiene 4 pero
#' se puede modificar.
#' @export acep_rst
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
#' datos_procesados_anio |> head()
#' datos_procesados_mes |> head()
#' datos_procesados_dia |> head()
#' @export
acep_rst <- function(datos, fecha, frecp, frecm,
                     st = "mes", u = 2, d = 4) {
  if(is.data.frame(datos) != TRUE){
    mensaje <- "No ingresaste un marco de datos en el parametro datos. Vuelve a intentarlo ingresando un marco de datos!"
    return(message(mensaje))
  }
  if((paste(names(datos),collapse = '') != "fechan_palabrasconflictosintensidad")){
    mensaje <- "No ingresaste un marco de datos adecuado en el parametro datos. Vuelve a intentarlo ingresando un marco de datos adecuado!"
    return(message(mensaje))
  }
  if(is.data.frame(fecha) == TRUE){
    mensaje <- "No ingresaste un vector Date en el parametro fecha. Vuelve a intentarlo ingresando un vector de fechas!"
    return(message(mensaje))
  }
  if(!all(is.na(as.Date(as.character(fecha),format="%Y-%m-%d"))) == FALSE){
    mensaje <- "No ingresaste un vector Date en el parametro fecha. Vuelve a intentarlo ingresando un vector de fechas!"
    return(message(mensaje))
  }
  if(is.numeric(fecha) == TRUE){
    mensaje <- "No ingresaste un vector Date en el parametro fecha. Vuelve a intentarlo ingresando un vector de fechas!"
    return(message(mensaje))
  }
  if(!is.numeric(frecp)){
    mensaje <- "No ingresaste un vector numerico en el parametro frecp. Vuelve a intentarlo ingresando un vector numerico!"
    return(message(mensaje))
  }
  if(!is.numeric(frecm)){
    mensaje <- "No ingresaste un vector numerico en el parametro frecm. Vuelve a intentarlo ingresando un vector numerico!"
    return(message(mensaje))
  } else {
    if((paste(names(datos),collapse = '') == "fechan_palabrasconflictosintensidad") && is.data.frame(datos) == TRUE) {
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
