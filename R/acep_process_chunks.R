#' Procesamiento de textos en lotes para optimizar memoria
#'
#' @description
#' Divide un vector grande de textos en lotes (chunks) más pequeños y los procesa
#' secuencialmente aplicando una función de ACEP. Esta estrategia permite analizar
#' corpus extensos (millones de documentos) sin superar la capacidad de memoria RAM
#' disponible. La función combina automáticamente los resultados de todos los lotes.
#'
#' @param texto Vector de caracteres con los textos a procesar.
#' @param funcion Función de ACEP a aplicar a cada lote. Ejemplos: `acep_clean`,
#'   `acep_token`, `acep_count`, `acep_upos`, etc. Debe ser una función que acepte
#'   un vector de textos como primer argumento.
#' @param chunk_size Número de textos por lote. Valores más bajos reducen el consumo
#'   de memoria pero aumentan el tiempo total de procesamiento. Por defecto: 1000.
#' @param show_progress Lógico. Si `TRUE`, muestra mensajes informativos sobre el
#'   progreso del procesamiento (qué lote se está procesando). Por defecto: `TRUE`.
#' @param ... Argumentos adicionales que se pasan directamente a la función especificada
#'   en el parámetro `funcion`. Ejemplo: si `funcion = acep_clean`, puede pasar
#'   `rm_stopwords = TRUE`, `tolower = TRUE`, etc.
#'
#' @return El tipo de resultado depende de la función aplicada:
#' \itemize{
#'   \item Si la función retorna un vector, devuelve un vector combinado
#'   \item Si la función retorna un data frame, devuelve un data frame combinado (rbind)
#'   \item Si la función retorna una lista, devuelve una lista de listas
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
    stop("El parámetro 'texto' debe ser un vector de caracteres")
  }
  
  if (!is.function(funcion)) {
    stop("El parámetro 'funcion' debe ser una función")
  }
  
  if (!is.numeric(chunk_size) || chunk_size <= 0) {
    stop("El parámetro 'chunk_size' debe ser un número positivo")
  }
  
  if (!is.logical(show_progress)) {
    stop("El parámetro 'show_progress' debe ser TRUE o FALSE")
  }
  
  # Calcular número de chunks
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
    # Calcular índices del chunk
    inicio <- (i - 1) * chunk_size + 1
    fin <- min(i * chunk_size, n_textos)
    
    if (show_progress) {
      message(sprintf("Chunk %d/%d (textos %d-%d)", i, n_chunks, inicio, fin))
    }
    
    # Extraer chunk de textos
    chunk <- texto[inicio:fin]
    
    # Procesar chunk con la función
    resultados[[i]] <- funcion(chunk, ...)
    
    # Garbage collection cada 10 chunks para liberar memoria
    if (i %% 10 == 0) {
      gc(verbose = FALSE)
    }
  }
  
  # Combinar resultados según el tipo
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
