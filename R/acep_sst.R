#' @title Serie temporal de índices de conflictividad.
#' @description Función que devuelve los indices de conflictividad
#' agrupados por segmento de tiempo: 'dia', 'mes', 'anio'. Esta función
#' viene a reemplazar a acep_rst. Simplifica los parámetros.
#' @param datos data frame con las variables 'fecha' (en formato Date),
#' 'n_palabras' (numérica), conflictos' (numérica), 'intensidad' (numérica).
#' Las ultimas tres se pueden construir en un solo paso con la función 'acep_db'
#' o en tres pasos con las funciones 'acep_frec', 'acep_men', 'acep_int'.
#' @param st parámetro para establecer el segmento temporal
#' a ser agrupado: 'anio', 'mes', 'dia'.
#' @param u umbral de menciones para contabilizar una nota
#' como nota que refiere a un conflicto, por defecto tiene 2
#' pero se puede modificar.
#' @param d cantidad de decimales, por defecto tiene 4 pero
#' se puede modificar.
#' @importFrom stats aggregate
#' @return Si todas las entradas son correctas,
#' la salida sera una base de datos en formato tabular
#' con nuevas variables.
#' @keywords resumen
#' @examples
#' datos <- acep_bases$rp_procesada
#' head(datos)
#' datos_procesados_anio <- acep_sst(datos, st='anio', u=4)
#' datos_procesados_mes <- acep_sst(datos)
#' datos_procesados_dia <- acep_sst(datos, st ='dia', d=3)
#' head(datos_procesados_anio)
#' head(datos_procesados_mes)
#' head(datos_procesados_dia)
#' @export
acep_sst <- function(datos, st = "mes", u = 2, d = 4) {
  validate_dataframe(datos, required_cols = c("fecha", "n_palabras", "conflictos", "intensidad"), arg_name = "datos")
  validate_choice(st, choices = c("anio", "mes", "dia"), arg_name = "st")
  validate_numeric(u, "u", min = 0)
  validate_numeric(d, "d", min = 0)

  tryCatch({
    datos$anio <- format(datos$fecha, "%Y")
    datos$mes <- paste0(datos$anio, "-", format(datos$fecha, "%m"))
    datos$dia <- datos$fecha
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
      datos$n_palabras ~ st, datos, function(x) c(frec_palabras = sum(x)))
    colnames(frec_palabras) <- c("st", "frecp")

    frec_conflict <- stats::aggregate(
      datos$conflictos ~ st, datos, function(x) c(frec_conflict = sum(x)))
    colnames(frec_conflict) <- c("st", "frecm")

    frec_int_acum <- stats::aggregate(
      datos$intensidad ~ st, datos, function(x) c(frec_int_acum = sum(x)))
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
  })
}

