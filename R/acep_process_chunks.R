#' Procesamiento de textos en lotes para optimizar memoria
#'
#' @description
#' Divide un vector grande de textos en lotes (chunks) mas pequenos y los procesa
#' secuencialmente aplicando una funcion de ACEP. Esta estrategia permite analizar
#' corpus extensos (millones de documentos) sin superar la capacidad de memoria RAM
#' disponible. La funcion combina automaticamente los resultados de todos los lotes.
#'
#' @param texto Vector de caracteres con los textos a procesar.
#' @param funcion Funcion de ACEP a aplicar a cada lote. Ejemplos: `acep_clean`,
#'   `acep_token`, `acep_count`, `acep_upos`, etc. Debe ser una funcion que acepte
#'   un vector de textos como primer argumento.
#' @param chunk_size Numero de textos por lote. Valores mas bajos reducen el consumo
#'   de memoria pero aumentan el tiempo total de procesamiento. Por defecto: 1000.
#' @param show_progress Logico. Si `TRUE`, muestra mensajes informativos sobre el
#'   progreso del procesamiento (que lote se esta procesando). Por defecto: `TRUE`.
#' @param ... Argumentos adicionales que se pasan directamente a la funcion especificada
#'   en el parametro `funcion`. Ejemplo: si `funcion = acep_clean`, puede pasar
#'   `rm_stopwords = TRUE`, `tolower = TRUE`, etc.
#'
#' @return El tipo de resultado depende de la funcion aplicada:
#' \itemize{
#'   \item Si la funcion retorna un vector, devuelve un vector combinado
#'   \item Si la funcion retorna un data frame, devuelve un data frame combinado (rbind)
#'   \item Si la funcion retorna una lista, devuelve una lista de listas
#' }
#'
#' @export
#' @examples
#' \dontrun{
#' # Procesar 10,000 textos con limpieza en lotes de 1000
#' textos_limpios <- acep_process_chunks(
#'   texto = corpus_grande,
#'   funcion = acep_clean,
#'   chunk_size = 1000,
#'   rm_stopwords = TRUE
#' )
#'
#' # Tokenizar corpus masivo
#' tokens <- acep_process_chunks(
#'   texto = corpus_masivo,
#'   funcion = acep_token,
#'   chunk_size = 500,
#'   tolower = TRUE
#' )
#'
#' # Contar menciones en corpus grande
#' diccionario <- c("paro", "huelga", "protesta")
#' frecuencias <- acep_process_chunks(
#'   texto = corpus_grande,
#'   funcion = acep_count,
#'   chunk_size = 2000,
#'   dic = diccionario
#' )
#' }
#'
#' @export
acep_process_chunks <- function(texto,
                                funcion,
                                chunk_size = 1000,
                                show_progress = TRUE,
                                ...) {
  
  # Validaciones
  if (!is.character(texto)) {
    stop("El parametro 'texto' debe ser un vector de caracteres")
  }

  if (!is.function(funcion)) {
    stop("El parametro 'funcion' debe ser una funcion")
  }

  if (!is.numeric(chunk_size) || chunk_size <= 0) {
    stop("El parametro 'chunk_size' debe ser un numero positivo")
  }

  if (!is.logical(show_progress)) {
    stop("El parametro 'show_progress' debe ser TRUE o FALSE")
  }

  # Calcular numero de chunks
  n_textos <- length(texto)
  n_chunks <- ceiling(n_textos / chunk_size)

  if (show_progress) {
    message(sprintf("Procesando %d textos en %d chunks de %d",
                    n_textos, n_chunks, chunk_size))
  }

  # Crear lista para almacenar resultados
  resultados <- vector("list", n_chunks)

  # Procesar cada chunk
  for (i in seq_len(n_chunks)) {
    # Calcular indices del chunk
    inicio <- (i - 1) * chunk_size + 1
    fin <- min(i * chunk_size, n_textos)

    if (show_progress) {
      message(sprintf("Chunk %d/%d (textos %d-%d)", i, n_chunks, inicio, fin))
    }

    # Extraer chunk de textos
    chunk <- texto[inicio:fin]

    # Procesar chunk con la funcion
    resultados[[i]] <- funcion(chunk, ...)

    # Garbage collection cada 10 chunks para liberar memoria
    if (i %% 10 == 0) {
      gc(verbose = FALSE)
    }
  }

  # Combinar resultados segun el tipo
  if (is.data.frame(resultados[[1]])) {
    # Si es data.frame, usar rbind
    resultado_final <- do.call(rbind, resultados)
  } else if (is.vector(resultados[[1]])) {
    # Si es vector, usar unlist
    resultado_final <- unlist(resultados, use.names = FALSE)
  } else if (is.list(resultados[[1]])) {
    # Si es lista, mantener como lista de listas
    resultado_final <- resultados
  } else {
    # Tipo desconocido, devolver lista
    warning("Tipo de resultado desconocido, devolviendo lista")
    resultado_final <- resultados
  }
  
  if (show_progress) {
    message("Procesamiento completado")
  }
  
  return(resultado_final)
}
