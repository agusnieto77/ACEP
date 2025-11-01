# Script de Refactorización - FASE 1
# Ejecutar este script para aplicar todos los cambios de FASE 1
# Fecha: 2025-10-28

library(here)

# ==============================================================================
# PASO 1: BACKUP DE ARCHIVOS ORIGINALES
# ==============================================================================

cat("=== FASE 1: LIMPIEZA Y CONSOLIDACIÓN ===\n\n")
cat("Paso 1: Creando backup de archivos originales...\n")

backup_dir <- here::here("backup_fase1")
if (!dir.exists(backup_dir)) {
  dir.create(backup_dir)
}

archivos_a_backup <- c(
  "R/acep_clean.R",
  "R/acep_men.R",
  "R/acep_rst.R",
  "R/acep_count.R",
  "R/acep_detect.R",
  "R/acep_int.R",
  "R/acep_frec.R",
  "R/acep_sst.R"
)

for (archivo in archivos_a_backup) {
  file.copy(
    here::here(archivo),
    file.path(backup_dir, basename(archivo)),
    overwrite = TRUE
  )
}

cat("✓ Backup completado en:", backup_dir, "\n\n")

# ==============================================================================
# PASO 2: CREAR WRAPPER DE DEPRECACIÓN PARA acep_clean()
# ==============================================================================

cat("Paso 2: Creando wrapper de deprecación para acep_clean()...\n")

acep_clean_nuevo <- '#\' @title Limpieza de texto (DEPRECATED).
#\' @description ESTA FUNCIÓN ESTÁ DEPRECADA. Use \\code{\\link{acep_cleaning}} en su lugar,
#\' que es significativamente más rápida al usar datos locales en lugar de descargas externas.
#\'
#\' Ver vignette \'rendimiento_funciones_acep\' para comparación de tiempos de ejecución.
#\' @param x vector de textos al que se le aplica la función de limpieza de texto.
#\' @param tolower convierte los textos a minúsculas.
#\' @param rm_cesp remueve caracteres especiales.
#\' @param rm_emoji remueve los emojis.
#\' @param rm_hashtag remueve los hashtags.
#\' @param rm_users remueve las menciones de usuarixs de redes sociales.
#\' @param rm_punt remueve la puntuación.
#\' @param rm_num remueve números.
#\' @param rm_url remueve las url.
#\' @param rm_meses remueve los meses del año.
#\' @param rm_dias remueve los dias de la semana.
#\' @param rm_stopwords remueve palabras vacías.
#\' @param rm_shortwords remueve las palabras cortas.
#\' @param rm_newline remueve los saltos de línea.
#\' @param rm_whitespace remueve los espacios en blanco.
#\' @param other_sw su valor por defecto es NULL, sirve para ampliar el
#\' listado de stopwords con un nuevo vector de palabras.
#\' @param u umbral de caracteres para la función rm_shortwords.
#\' @return Si todas las entradas son correctas, la salida sera un vector de textos normalizados.
#\' @seealso \\code{\\link{acep_cleaning}} para la versión mejorada y más rápida.
#\' @keywords limpieza normalización deprecated
#\' @examples
#\' \\dontrun{
#\' # Esta función está deprecada. Use acep_cleaning() en su lugar:
#\' acep_cleaning("El SUTEBA fue al paro. Reclaman mejoras salariales.", rm_punt = FALSE)
#\' }
#\' @export
acep_clean <- function(x,
                       tolower = TRUE,
                       rm_cesp = TRUE,
                       rm_emoji = TRUE,
                       rm_hashtag = TRUE,
                       rm_users = TRUE,
                       rm_punt = TRUE,
                       rm_num = TRUE,
                       rm_url = TRUE,
                       rm_meses = TRUE,
                       rm_dias = TRUE,
                       rm_stopwords = TRUE,
                       rm_shortwords = TRUE,
                       rm_newline = TRUE,
                       rm_whitespace = TRUE,
                       other_sw = NULL,
                       u = 1) {

  .Deprecated(
    "acep_cleaning",
    package = "ACEP",
    msg = paste(
      "\\nLa función \'acep_clean()\' está deprecada y será eliminada en una futura versión.\\n",
      "Por favor use \'acep_cleaning()\' que es significativamente más rápida.\\n",
      "Ver vignette(\'rendimiento_funciones_acep\') para comparación de tiempos."
    )
  )

  # Redirigir a acep_cleaning con los mismos parámetros
  acep_cleaning(
    x = x,
    tolower = tolower,
    rm_cesp = rm_cesp,
    rm_emoji = rm_emoji,
    rm_hashtag = rm_hashtag,
    rm_users = rm_users,
    rm_punt = rm_punt,
    rm_num = rm_num,
    rm_url = rm_url,
    rm_meses = rm_meses,
    rm_dias = rm_dias,
    rm_stopwords = rm_stopwords,
    rm_shortwords = rm_shortwords,
    rm_newline = rm_newline,
    rm_whitespace = rm_whitespace,
    other_sw = other_sw,
    u = u
  )
}
'

writeLines(acep_clean_nuevo, here::here("R/acep_clean.R"))
cat("✓ acep_clean() refactorizada\n\n")

# ==============================================================================
# PASO 3: CREAR WRAPPER DE DEPRECACIÓN PARA acep_men()
# ==============================================================================

cat("Paso 3: Creando wrapper de deprecación para acep_men()...\n")

acep_men_nuevo <- '#\' @title Frecuencia de menciones de palabras (DEPRECATED).
#\' @description ESTA FUNCIÓN ESTÁ DEPRECADA. Use \\code{\\link{acep_count}} en su lugar,
#\' que es más rápida (usa vectorización con stringr) y tiene nombres de parámetros más claros.
#\' @param x vector de textos al que se le aplica la función de conteo
#\' de la frecuencia de menciones de palabras del diccionario.
#\' @param y vector de palabras del diccionario utilizado.
#\' @param tolower convierte los textos a minúsculas.
#\' @return Si todas las entradas son correctas, la salida sera un vector con una frecuencia
#\' de palabras de un diccionario.
#\' @seealso \\code{\\link{acep_count}} para la versión mejorada.
#\' @keywords indicadores frecuencia tokens deprecated
#\' @examples
#\' \\dontrun{
#\' # Esta función está deprecada. Use acep_count() en su lugar:
#\' df <- data.frame(texto = c("El SUTEBA fue al paro. Reclaman mejoras salariales.",
#\' "El SOIP lleva adelante un plan de lucha con paros y piquetes."))
#\' diccionario <- c("paro", "lucha", "piquetes")
#\' df$detect <- acep_count(df$texto, diccionario)
#\' df
#\' }
#\' @export
acep_men <- function(x, y, tolower = TRUE) {

  .Deprecated(
    "acep_count",
    package = "ACEP",
    msg = paste(
      "\\nLa función \'acep_men()\' está deprecada y será eliminada en una futura versión.\\n",
      "Por favor use \'acep_count(texto, dic)\' que es más rápida y tiene nombres de parámetros más claros."
    )
  )

  if (!tolower) {
    warning(
      "El parámetro \'tolower=FALSE\' no es soportado en acep_count(). ",
      "El texto será procesado tal como está (acep_count no modifica mayúsculas/minúsculas).",
      call. = FALSE
    )
  }

  # Redirigir a acep_count
  # Nota: acep_count no tiene parámetro tolower, siempre cuenta tal cual
  acep_count(texto = x, dic = y)
}
'

writeLines(acep_men_nuevo, here::here("R/acep_men.R"))
cat("✓ acep_men() refactorizada\n\n")

# ==============================================================================
# PASO 4: CREAR WRAPPER DE DEPRECACIÓN PARA acep_rst()
# ==============================================================================

cat("Paso 4: Creando wrapper de deprecación para acep_rst()...\n")

acep_rst_nuevo <- '#\' @title Serie temporal de índices de conflictividad (DEPRECATED).
#\' @description ESTA FUNCIÓN ESTÁ DEPRECADA. Use \\code{\\link{acep_sst}} en su lugar,
#\' que simplifica los parámetros (solo requiere el data frame con estructura correcta).
#\' @param datos data frame con las variables \'fecha\' (en formato Date),
#\' \'n_palabras\' (numérica), conflictos\' (numérica), \'intensidad\' (numérica).
#\' @param fecha columna de data frame que contiene el vector de fechas en formato date.
#\' @param frecp columna de data frame que contiene el vector de frecuencia de palabras por texto.
#\' @param frecm columna de data frame que contiene el vector de menciones del diccionario por texto.
#\' @param st parámetro para establecer el segmento temporal a ser agrupado: anio, mes, día.
#\' @param u umbral de menciones para contabilizar una nota como nota que refiere a un conflicto.
#\' @param d cantidad de decimales, por defecto tiene 4 pero se puede modificar.
#\' @importFrom stats aggregate
#\' @return Si todas las entradas son correctas, la salida sera una base de datos en formato tabular
#\' con nuevas variables.
#\' @seealso \\code{\\link{acep_sst}} para la versión mejorada.
#\' @keywords resumen deprecated
#\' @examples
#\' \\dontrun{
#\' # Esta función está deprecada. Use acep_sst() en su lugar:
#\' datos <- acep_bases$rp_procesada
#\' datos_procesados_anio <- acep_sst(datos, st = \'anio\', u = 4)
#\' datos_procesados_mes <- acep_sst(datos)
#\' datos_procesados_dia <- acep_sst(datos, st = \'dia\', d = 3)
#\' }
#\' @export
acep_rst <- function(datos, fecha, frecp, frecm,
                     st = "mes", u = 2, d = 4) {

  .Deprecated(
    "acep_sst",
    package = "ACEP",
    msg = paste(
      "\\nLa función \'acep_rst()\' está deprecada y será eliminada en una futura versión.\\n",
      "Por favor use \'acep_sst(datos, st, u, d)\' que simplifica los parámetros.\\n",
      "El data frame \'datos\' debe contener las columnas: fecha, n_palabras, conflictos, intensidad."
    )
  )

  # Redirigir a acep_sst asumiendo que datos ya tiene la estructura correcta
  acep_sst(datos = datos, st = st, u = u, d = d)
}
'

writeLines(acep_rst_nuevo, here::here("R/acep_rst.R"))
cat("✓ acep_rst() refactorizada\n\n")

# ==============================================================================
# PASO 5: REFACTORIZAR acep_count() CON HELPERS
# ==============================================================================

cat("Paso 5: Refactorizando acep_count() con helpers...\n")

acep_count_nuevo <- '#\' @title Frecuencia de menciones de palabras.
#\' @description Reemplaza a la función \'acep_men\' que cuenta la frecuencia de
#\' menciones de palabras que refieren a conflictos en cada una de las notas/textos.
#\' @param texto vector de textos al que se le aplica la función de conteo
#\' de la frecuencia de menciones de palabras del diccionario.
#\' @param dic vector de palabras del diccionario utilizado.
#\' @return Si todas las entradas son correctas,
#\' la salida sera un vector con una frecuencia
#\' de palabras de un diccionario.
#\' @keywords indicadores frecuencia tokens
#\' @importFrom stringr str_count
#\' @examples
#\' df <- data.frame(texto = c("El SUTEBA fue al paro. Reclaman mejoras salariales.",
#\' "El SOIP lleva adelante un plan de lucha con paros y piquetes."))
#\' diccionario <- c("paro", "lucha", "piquetes")
#\' df$detect <- acep_count(df$texto, diccionario)
#\' df
#\' @export
acep_count <- function(texto, dic) {
  validate_character(texto, "texto")
  validate_character(dic, "dic")

  dicc <- paste0(gsub("^ | $", "\\\\b", dic), collapse = "|")
  detect <- stringr::str_count(texto, dicc)
  return(detect)
}
'

writeLines(acep_count_nuevo, here::here("R/acep_count.R"))
cat("✓ acep_count() refactorizada\n\n")

# ==============================================================================
# PASO 6: REFACTORIZAR acep_detect() CON HELPERS
# ==============================================================================

cat("Paso 6: Refactorizando acep_detect() con helpers...\n")

acep_detect_nuevo <- '#\' @title Detección de menciones de palabras.
#\' @description Función que detecta de menciones de palabras que
#\' refieren a conflictos en cada una de las notas/textos.
#\' @param x vector de textos al que se le aplica la función de
#\' detección de menciones de palabras del diccionario.
#\' @param y vector de palabras del diccionario utilizado.
#\' @param u umbral para atribuir valor positivo a la
#\' detección de las menciones.
#\' @param tolower convierte los textos a minúsculas.
#\' @return Si todas las entradas son correctas,
#\' la salida sera un vector numérico.
#\' @importFrom stringr str_count
#\' @keywords indicadores frecuencia tokens
#\' @examples
#\' df <- data.frame(texto = c("El SUTEBA fue al paro. Reclaman mejoras salariales.",
#\' "El SOIP lleva adelante un plan de lucha con paros y piquetes."))
#\' diccionario <- c("paro", "lucha", "piquetes")
#\' df$detect <- acep_detect(df$texto, diccionario)
#\' df
#\' @export
acep_detect <- function(x, y, u = 1, tolower = TRUE) {
  validate_character(x, "x")
  validate_character(y, "y")
  validate_numeric(u, "u", min = 0)
  validate_logical(tolower, "tolower")

  if (tolower) {
    x <- tolower(x)
  }

  out <- tryCatch({
    dicc <- paste0(gsub("^ | $", "\\\\b", y), collapse = "|")
    detect <- stringr::str_count(x, dicc)
    ifelse(as.numeric(detect) >= u, 1, 0)
  })

  return(out)
}
'

writeLines(acep_detect_nuevo, here::here("R/acep_detect.R"))
cat("✓ acep_detect() refactorizada\n\n")

# ==============================================================================
# PASO 7: REFACTORIZAR acep_int() CON HELPERS
# ==============================================================================

cat("Paso 7: Refactorizando acep_int() con helpers...\n")

acep_int_nuevo <- '#\' @title Índice de intensidad.
#\' @description Función que elabora un indice de intensidad en
#\' base a la relación entre palabras totales y palabras del diccionario
#\' presentes en el texto.
#\' @param pc vector numérico con la frecuencia de palabras conflictivas
#\' presentes en cada texto.
#\' @param pt vector de palabras totales en cada texto.
#\' @param decimales cantidad de decimales, por defecto tiene 4
#\' pero se puede modificar.
#\' @return Si todas las entradas son correctas,
#\' la salida sera un vector numérico.
#\' @keywords indicadores frecuencia tokens
#\' @examples
#\' conflictos <- c(1, 5, 0, 3, 7)
#\' palabras <- c(4, 11, 12, 9, 34)
#\' acep_int(conflictos, palabras, 3)
#\' @export
acep_int <- function(pc, pt, decimales = 4) {
  validate_numeric(pc, "pc", min = 0)
  validate_numeric(pt, "pt", min = 0)
  validate_numeric(decimales, "decimales", min = 0)

  tryCatch({
    round(pc / pt, decimales)
  })
}
'

writeLines(acep_int_nuevo, here::here("R/acep_int.R"))
cat("✓ acep_int() refactorizada\n\n")

# ==============================================================================
# PASO 8: REFACTORIZAR acep_sst() CON HELPERS
# ==============================================================================

cat("Paso 8: Refactorizando acep_sst() con helpers...\n")

acep_sst_nuevo <- '#\' @title Serie temporal de índices de conflictividad.
#\' @description Función que devuelve los indices de conflictividad
#\' agrupados por segmento de tiempo: \'dia\', \'mes\', \'anio\'. Esta función
#\' viene a reemplazar a acep_rst. Simplifica los parámetros.
#\' @param datos data frame con las variables \'fecha\' (en formato Date),
#\' \'n_palabras\' (numérica), conflictos\' (numérica), \'intensidad\' (numérica).
#\' Las ultimas tres se pueden construir en un solo paso con la función \'acep_db\'
#\' o en tres pasos con las funciones \'acep_frec\', \'acep_men\', \'acep_int\'.
#\' @param st parámetro para establecer el segmento temporal
#\' a ser agrupado: \'anio\', \'mes\', \'dia\'.
#\' @param u umbral de menciones para contabilizar una nota
#\' como nota que refiere a un conflicto, por defecto tiene 2
#\' pero se puede modificar.
#\' @param d cantidad de decimales, por defecto tiene 4 pero
#\' se puede modificar.
#\' @importFrom stats aggregate
#\' @return Si todas las entradas son correctas,
#\' la salida sera una base de datos en formato tabular
#\' con nuevas variables.
#\' @keywords resumen
#\' @examples
#\' datos <- acep_bases$rp_procesada
#\' head(datos)
#\' datos_procesados_anio <- acep_sst(datos, st=\'anio\', u=4)
#\' datos_procesados_mes <- acep_sst(datos)
#\' datos_procesados_dia <- acep_sst(datos, st =\'dia\', d=3)
#\' head(datos_procesados_anio)
#\' head(datos_procesados_mes)
#\' head(datos_procesados_dia)
#\' @export
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
'

writeLines(acep_sst_nuevo, here::here("R/acep_sst.R"))
cat("✓ acep_sst() refactorizada\n\n")

# ==============================================================================
# PASO 9: RESUMEN Y SIGUIENTES PASOS
# ==============================================================================

cat("\n=== RESUMEN DE CAMBIOS ===\n\n")
cat("Archivos modificados:\n")
cat("  1. R/acep_clean.R - Wrapper de deprecación ✓\n")
cat("  2. R/acep_men.R - Wrapper de deprecación ✓\n")
cat("  3. R/acep_rst.R - Wrapper de deprecación ✓\n")
cat("  4. R/acep_count.R - Refactorizada con helpers ✓\n")
cat("  5. R/acep_detect.R - Refactorizada con helpers ✓\n")
cat("  6. R/acep_int.R - Refactorizada con helpers ✓\n")
cat("  7. R/acep_sst.R - Refactorizada con helpers ✓\n\n")

cat("Archivos de backup guardados en:", backup_dir, "\n\n")

cat("=== PRÓXIMOS PASOS ===\n\n")
cat("1. Regenerar documentación:\n")
cat("   devtools::document()\n\n")
cat("2. Ejecutar tests:\n")
cat("   devtools::test()\n\n")
cat("3. Verificar paquete:\n")
cat("   devtools::check()\n\n")
cat("4. Crear tests de deprecación (ver FASE1_REFACTORIZACION.md)\n\n")
cat("5. Actualizar README.md y vignettes\n\n")

cat("FASE 1 - Implementación completada ✓\n")
