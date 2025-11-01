#' Pipe operator para ACEP
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL

#' @title Limpieza de texto en pipeline
#' @description
#' Aplica limpieza y normalización de texto dentro de un flujo pipeline.
#' Esta función actúa como adaptador de `acep_clean()` para trabajar con
#' objetos `acep_corpus`, registrando las transformaciones aplicadas.
#'
#' @param corpus Objeto `acep_corpus` o vector de caracteres. Si se pasa un vector,
#'   se crea automáticamente un objeto `acep_corpus`.
#' @param ... Argumentos para `acep_clean()`. Ejemplos: `rm_stopwords = TRUE`,
#'   `rm_num = TRUE`, `tolower = TRUE`, `rm_punt = TRUE`.
#'
#' @return Objeto `acep_corpus` con el campo `texto_procesado` actualizado
#'   y registro de la transformación en `procesamiento$limpieza`.
#'
#' @export
#' @examples
#' # Crear corpus y limpiar
#' textos <- c("El SUTEBA va al paro!!!", "SOIP protesta 123")
#' corpus <- acep_corpus(textos)
#' corpus_limpio <- pipe_clean(corpus, rm_punt = TRUE, rm_num = TRUE)
#' print(corpus_limpio)
pipe_clean <- function(corpus, ...) {
  if (inherits(corpus, "acep_corpus")) {
    texto_limpio <- acep_clean(corpus$texto_original, ...)
    corpus$texto_procesado <- texto_limpio
    corpus$procesamiento$limpieza <- list(funcion = "acep_clean", args = list(...))
    return(corpus)
  } else {
    # Si es vector, crear corpus
    corpus_nuevo <- acep_corpus(corpus)
    return(pipe_clean(corpus_nuevo, ...))
  }
}

#' @title Conteo de menciones en pipeline
#' @description
#' Cuenta las menciones de palabras de un diccionario dentro de un flujo pipeline.
#' Esta función extrae los textos de un `acep_corpus` (procesados o originales)
#' y aplica `acep_count()` para detectar ocurrencias del diccionario.
#'
#' @param corpus Objeto `acep_corpus`. Debe ser un corpus válido creado con
#'   `acep_corpus()` o resultado de `pipe_clean()`.
#' @param dic Vector de caracteres con las palabras del diccionario a buscar.
#' @param ... Argumentos adicionales (actualmente no utilizados, reservado para
#'   futuras extensiones).
#'
#' @return Objeto `acep_result` con tipo `"frecuencia"` que contiene un data frame con:
#'   `id`, `texto` y `frecuencia` de menciones por texto.
#'
#' @export
#' @examples
#' # Contar menciones en corpus
#' textos <- c("El SUTEBA va al paro", "SOIP en lucha y paro")
#' corpus <- acep_corpus(textos)
#' diccionario <- c("paro", "lucha", "protesta")
#' resultado <- pipe_count(corpus, diccionario)
#' print(resultado)
pipe_count <- function(corpus, dic, ...) {
  if (!inherits(corpus, "acep_corpus")) {
    stop("pipe_count requiere un objeto acep_corpus", call. = FALSE)
  }

  texto_usar <- if (!is.null(corpus$texto_procesado)) {
    corpus$texto_procesado
  } else {
    corpus$texto_original
  }

  frecuencias <- acep_count(texto_usar, dic, ...)

  resultado <- data.frame(
    id = corpus$id,
    texto = texto_usar,
    frecuencia = frecuencias,
    stringsAsFactors = FALSE
  )

  acep_result(resultado, tipo = "frecuencia",
              metadata = list(diccionario = dic, corpus = corpus))
}

#' @title Cálculo de intensidad en pipeline
#' @description
#' Calcula el índice de intensidad normalizado dentro de un flujo pipeline.
#' La intensidad se define como la proporción de menciones del diccionario
#' respecto al total de palabras: intensidad = frecuencia / n_palabras.
#'
#' @param result Objeto `acep_result` que debe contener una columna `frecuencia`.
#'   Típicamente proviene de `pipe_count()`.
#' @param decimales Número de decimales para redondear el índice de intensidad.
#'   Por defecto: 4.
#'
#' @return Objeto `acep_result` con tipo `"intensidad"` que incluye columnas
#'   adicionales: `n_palabras` e `intensidad`.
#'
#' @export
#' @examples
#' # Calcular intensidad desde resultado de conteo
#' textos <- c("El SUTEBA va al paro", "SOIP en lucha y paro")
#' corpus <- acep_corpus(textos)
#' diccionario <- c("paro", "lucha")
#' resultado <- pipe_count(corpus, diccionario)
#' resultado_intensidad <- pipe_intensity(resultado, decimales = 4)
#' print(resultado_intensidad)
pipe_intensity <- function(result, decimales = 4) {
  if (!inherits(result, "acep_result")) {
    stop("pipe_intensity requiere un objeto acep_result", call. = FALSE)
  }

  if (!"frecuencia" %in% names(result$data)) {
    stop("El resultado debe contener columna 'frecuencia'", call. = FALSE)
  }

  # Calcular frecuencia de palabras totales
  freq_total <- stringr::str_count(result$data$texto, "\\S+")

  result$data$n_palabras <- freq_total
  result$data$intensidad <- acep_int(result$data$frecuencia, freq_total, decimales)
  result$tipo <- "intensidad"

  result
}

#' @title Generación de series temporales en pipeline
#' @description
#' Crea agregaciones temporales de índices de conflictividad dentro de un flujo pipeline.
#' Agrupa los resultados por segmentos temporales (día, mes, año) y calcula
#' estadísticas resumidas usando `acep_sst()`.
#'
#' @param data Data frame o objeto `acep_result` que contenga columnas:
#'   `fecha` (o variable temporal), `n_palabras`, `conflictos`, `intensidad`.
#' @param st Segmento temporal para agrupar. Valores: `"dia"`, `"mes"`, `"anio"`.
#'   Por defecto: `"mes"`.
#' @param u Umbral para calcular métricas categóricas. Por defecto: 2.
#' @param d Número de decimales para redondear. Por defecto: 4.
#'
#' @return Objeto `acep_result` con tipo `"serie_temporal"` que contiene
#'   agregaciones por período temporal.
#'
#' @export
#' @examples
#' \dontrun{
#' # Crear serie temporal desde data frame con fechas
#' data <- data.frame(
#'   fecha = as.Date(c("2024-01-15", "2024-01-20", "2024-02-10")),
#'   n_palabras = c(100, 150, 120),
#'   conflictos = c(5, 8, 6),
#'   intensidad = c(0.05, 0.053, 0.05)
#' )
#' serie <- pipe_timeseries(data, st = "mes", u = 2)
#' print(serie)
#' }
pipe_timeseries <- function(data, st = "mes", u = 2, d = 4) {
  if (inherits(data, "acep_result")) {
    data <- data$data
  }

  serie <- acep_sst(data, st = st, u = u, d = d)

  acep_result(serie, tipo = "serie_temporal",
              metadata = list(st = st, umbral = u, decimales = d))
}

#' @title Pipeline completo de análisis de conflictividad
#' @description
#' Ejecuta un flujo de trabajo completo de análisis de texto que incluye:
#' limpieza opcional, conteo de menciones de un diccionario, y cálculo de
#' intensidad. Esta función encadena automáticamente las funciones `pipe_clean()`,
#' `pipe_count()` y `pipe_intensity()` para facilitar análisis rápidos.
#'
#' @param texto Vector de caracteres con los textos a analizar.
#' @param dic Vector de caracteres con las palabras del diccionario de conflictividad
#'   (o cualquier otro diccionario temático) a buscar en los textos.
#' @param clean Lógico. Si `TRUE` (por defecto), aplica limpieza y normalización
#'   al texto antes del análisis usando `acep_clean()`.
#' @param ... Argumentos adicionales para pasar a `acep_clean()` cuando `clean = TRUE`.
#'   Por ejemplo: `rm_stopwords = TRUE`, `rm_num = TRUE`, `tolower = TRUE`.
#'
#' @return Objeto de clase `acep_result` con tipo `"intensidad"` que contiene:
#' \itemize{
#'   \item \code{id}: Identificadores de cada texto
#'   \item \code{texto}: Textos analizados (limpios si `clean = TRUE`)
#'   \item \code{frecuencia}: Número de menciones del diccionario por texto
#'   \item \code{n_palabras}: Número total de palabras por texto
#'   \item \code{intensidad}: Índice normalizado de intensidad (frecuencia/n_palabras)
#' }
#'
#' @export
#' @examples
#' \dontrun{
#' # Pipeline completo con limpieza
#' textos <- c("El SUTEBA va al paro por mejoras salariales",
#'             "SOIP en lucha contra despidos")
#' dic_conflictos <- c("paro", "lucha", "reclamo", "protesta")
#' resultado <- acep_pipeline(textos, dic_conflictos,
#'                            clean = TRUE, rm_stopwords = TRUE)
#' print(resultado)
#'
#' # Pipeline sin limpieza
#' resultado <- acep_pipeline(textos, dic_conflictos, clean = FALSE)
#' }
acep_pipeline <- function(texto, dic, clean = TRUE, ...) {
  validate_character(texto, "texto")
  validate_character(dic, "dic")

  # Crear corpus
  corpus <- acep_corpus(texto)

  # Limpieza opcional
  if (clean) {
    corpus <- pipe_clean(corpus, ...)
  }

  # Análisis
  resultado <- pipe_count(corpus, dic)
  resultado <- pipe_intensity(resultado)

  resultado
}
