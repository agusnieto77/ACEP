#' @title Constructor de corpus para analisis de texto
#' @description
#' Crea un objeto de clase `acep_corpus` que encapsula una coleccion de textos
#' junto con su metadata asociada. Este objeto esta disenado para trabajar
#' con las funciones pipeline de ACEP (`pipe_clean`, `pipe_count`, etc.),
#' permitiendo un flujo de trabajo encadenado y manteniendo trazabilidad
#' de las transformaciones aplicadas.
#'
#' @param texto Vector de caracteres con los textos a almacenar en el corpus.
#' @param metadata Lista opcional con informacion adicional sobre el corpus
#'   (ej: fuente, fecha de recoleccion, categorias tematicas).
#' @param id Vector opcional de identificadores unicos para cada texto.
#'   Si no se proporciona, se asignan IDs secuenciales (1, 2, 3, ...).
#'
#' @return Objeto de clase `acep_corpus` con la siguiente estructura:
#' \itemize{
#'   \item \code{texto_original}: Vector con los textos originales sin procesar
#'   \item \code{texto_procesado}: Vector con textos procesados (NULL inicialmente)
#'   \item \code{id}: Identificadores de cada texto
#'   \item \code{metadata}: Metadata adicional del corpus
#'   \item \code{procesamiento}: Registro de transformaciones aplicadas
#' }
#'
#' @export
#' @examples
#' # Crear corpus simple
#' textos <- c("El SUTEBA va al paro", "SOIP protesta por salarios")
#' corpus <- acep_corpus(textos)
#' print(corpus)
#'
#' # Crear corpus con metadata e IDs personalizados
#' corpus <- acep_corpus(
#'   texto = c("Noticia 1", "Noticia 2"),
#'   metadata = list(fuente = "Diario La Nacion", year = 2024),
#'   id = c("LN001", "LN002")
#' )
acep_corpus <- function(texto, metadata = NULL, id = NULL) {
  validate_character(texto, "texto")

  if (is.null(id)) {
    id <- seq_along(texto)
  }

  estructura <- structure(
    list(
      texto_original = texto,
      texto_procesado = NULL,
      id = id,
      metadata = metadata,
      procesamiento = list()
    ),
    class = "acep_corpus"
  )

  estructura
}

#' @export
print.acep_corpus <- function(x, ...) {
  cat("acep_corpus object\n")
  cat("==================\n")
  cat("Documentos:", length(x$texto_original), "\n")
  cat("Procesado:", !is.null(x$texto_procesado), "\n")
  cat("Pasos aplicados:", length(x$procesamiento), "\n")
  if (length(x$procesamiento) > 0) {
    cat("Funciones:", paste(names(x$procesamiento), collapse = ", "), "\n")
  }
  invisible(x)
}

#' @export
summary.acep_corpus <- function(object, ...) {
  cat("acep_corpus summary\n")
  cat("===================\n")
  cat("Total documentos:", length(object$texto_original), "\n")
  cat("Caracteres promedio:", mean(nchar(object$texto_original)), "\n")
  cat("Palabras promedio:", mean(stringr::str_count(object$texto_original, "\\S+")), "\n")
  cat("\nProcesamiento aplicado:\n")
  if (length(object$procesamiento) > 0) {
    for (i in seq_along(object$procesamiento)) {
      cat(sprintf("  %d. %s\n", i, names(object$procesamiento)[i]))
    }
  } else {
    cat("  (ninguno)\n")
  }
  invisible(object)
}

#' @title Constructor de resultados de analisis
#' @description
#' Crea un objeto de clase `acep_result` que encapsula los resultados de
#' un analisis de texto realizado con funciones de ACEP. Este objeto
#' proporciona metodos especializados para visualizacion (`plot()`),
#' resumen (`summary()`) y conversion a data frame (`as.data.frame()`).
#'
#' @param data Data frame con los resultados del analisis.
#' @param tipo Tipo de resultado que contiene el objeto. Valores comunes:
#'   `"frecuencia"`, `"intensidad"`, `"svo"`, `"serie_temporal"`, `"general"`.
#'   Este parametro determina el comportamiento de los metodos de impresion y visualizacion.
#' @param metadata Lista opcional con informacion sobre el analisis realizado
#'   (ej: diccionario utilizado, parametros aplicados, corpus de origen).
#'
#' @return Objeto de clase `acep_result` con la siguiente estructura:
#' \itemize{
#'   \item \code{data}: Data frame con los resultados del analisis
#'   \item \code{tipo}: Etiqueta del tipo de resultado
#'   \item \code{metadata}: Informacion adicional del analisis
#'   \item \code{fecha_creacion}: Timestamp de creacion del objeto
#' }
#'
#' @export
#' @examples
#' # Crear resultado de analisis de frecuencias
#' datos <- data.frame(
#'   texto = c("El SUTEBA va al paro", "SOIP protesta"),
#'   frecuencia = c(5, 3)
#' )
#' resultado <- acep_result(datos, tipo = "frecuencia")
#' print(resultado)
#' summary(resultado)
#'
#' # Convertir a data frame
#' df <- as.data.frame(resultado)
acep_result <- function(data, tipo = "general", metadata = NULL) {
  validate_dataframe(data, arg_name = "data")
  validate_character(tipo, "tipo")

  estructura <- structure(
    list(
      data = data,
      tipo = tipo,
      metadata = metadata,
      fecha_creacion = Sys.time()
    ),
    class = c(paste0("acep_result_", tipo), "acep_result", "list")
  )

  estructura
}

#' @importFrom utils head
#' @export
print.acep_result <- function(x, ...) {
  cat("acep_result object\n")
  cat("==================\n")
  cat("Tipo:", x$tipo, "\n")
  cat("Filas:", nrow(x$data), "\n")
  cat("Columnas:", ncol(x$data), "\n")
  cat("Creado:", format(x$fecha_creacion, "%Y-%m-%d %H:%M:%S"), "\n\n")
  cat("Primeras filas:\n")
  print(head(x$data, 3))
  invisible(x)
}

#' @export
summary.acep_result <- function(object, ...) {
  cat("acep_result summary\n")
  cat("===================\n")
  cat("Tipo:", object$tipo, "\n")
  cat("Dimensiones:", nrow(object$data), "x", ncol(object$data), "\n")
  cat("Columnas:", paste(names(object$data), collapse = ", "), "\n\n")

  # Resumen especifico por tipo
  if (object$tipo == "frecuencia" && "n_palabras" %in% names(object$data)) {
    cat("Estadisticas de frecuencia:\n")
    cat("  Total palabras:", sum(object$data$n_palabras, na.rm = TRUE), "\n")
    cat("  Promedio por documento:", mean(object$data$n_palabras, na.rm = TRUE), "\n")
  }

  if (object$tipo == "intensidad" && "intensidad" %in% names(object$data)) {
    cat("Estadisticas de intensidad:\n")
    cat("  Promedio:", mean(object$data$intensidad, na.rm = TRUE), "\n")
    cat("  Maximo:", max(object$data$intensidad, na.rm = TRUE), "\n")
  }

  invisible(object)
}

#' @export
as.data.frame.acep_result <- function(x, ...) {
  x$data
}

#' @export
plot.acep_result <- function(x, ...) {
  if (x$tipo == "serie_temporal" && all(c("st", "frecn") %in% names(x$data))) {
    acep_plot_st(x$data, ...)
  } else if ("intensidad" %in% names(x$data)) {
    barplot(x$data$intensidad,
            main = paste("Intensidad -", x$tipo),
            ylab = "Intensidad",
            ...)
  } else {
    message("No hay metodo de plot especifico para este tipo de resultado")
  }
  invisible(x)
}
