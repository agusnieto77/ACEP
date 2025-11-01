#' @title Etiquetado POS adaptativo con optimizaciones avanzadas
#' @description Version optimizada de acep_postag que se adapta automaticamente al tamano del input.
#' Implementa procesamiento por lotes (chunking) para grandes volumenes, cache de geocodificacion
#' para evitar consultas repetidas, y estrategias de procesamiento adaptativas segun la cantidad
#' de textos. Puede procesar desde 10 hasta millones de textos de forma eficiente.
#' @param texto Vector de caracteres con los textos a procesar.
#' @param core Idioma del modelo de etiquetado POS del paquete \code{spacyr}. Opciones disponibles:
#' 'es_core_news_sm', 'es_core_news_md', 'es_core_news_lg' (espanol),
#' 'pt_core_news_sm', 'pt_core_news_md', 'pt_core_news_lg' (portugues),
#' 'en_core_web_sm', 'en_core_web_md', 'en_core_web_lg', 'en_core_web_trf' (ingles).
#' Default: "es_core_news_lg".
#' @param bajar_core Parametro booleano que define si descargar o no el modelo de etiquetado POS.
#' Default: TRUE.
#' @param inst_spacy Parametro booleano que define si instalar o no spacy (Python).
#' Default: FALSE.
#' @param inst_miniconda Parametro booleano que define si instalar o no miniconda.
#' Default: FALSE.
#' @param inst_reticulate Parametro booleano que define si instalar o no el paquete \code{reticulate}.
#' Default: FALSE.
#' @param chunk_size Tamano de los lotes para procesamiento chunking. Ajustar segun RAM disponible:
#' 500 para sistemas con 2-4 GB RAM, 1000 para 8 GB RAM (default), 2000-5000 para 16+ GB RAM.
#' Default: 1000.
#' @param geocode_cache_file Ruta del archivo JSON para guardar cache de geocodificacion.
#' Permite evitar consultas repetidas a la API de Nominatim y compartir cache entre proyectos.
#' Default: "geocode_cache.json".
#' @param use_cache Parametro booleano que activa/desactiva el sistema de cache de geocodificacion.
#' Desactivar para forzar re-geocodificacion de todas las ubicaciones.
#' Default: TRUE.
#' @param show_progress Parametro booleano que controla la visualizacion de mensajes de progreso
#' durante el procesamiento. Util para operaciones largas.
#' Default: TRUE.
#' @importFrom utils install.packages
#' @importFrom spacyr spacy_install spacy_download_langmodel spacy_initialize spacy_parse entity_consolidate entity_extract nounphrase_consolidate nounphrase_extract spacy_finalize
#' @importFrom rsyntax as_tokenindex
#' @importFrom tidygeocoder geo
#' @importFrom reticulate install_miniconda
#' @importFrom jsonlite read_json write_json
#' @return Lista con seis elementos en formato tabular:
#' \itemize{
#'   \item \code{texto_tag}: Data frame con tokens etiquetados (POS, lemas, dependencias, etc.)
#'   \item \code{texto_tag_entity}: Data frame con entidades nombradas consolidadas
#'   \item \code{texto_only_entity}: Data frame con solo las entidades extraidas
#'   \item \code{texto_only_entity_loc}: Data frame con entidades de tipo LOC geocodificadas (lat/long)
#'   \item \code{texto_nounphrase}: Data frame con frases nominales consolidadas
#'   \item \code{texto_only_nounphrase}: Data frame con solo las frases nominales extraidas
#' }
#' @details
#' La funcion implementa dos estrategias de procesamiento automaticas:
#' \itemize{
#'   \item \strong{Batch Processing} (<= 100 textos): Procesa todos los textos en una sola llamada
#'   para maxima velocidad.
#'   \item \strong{Chunking} (> 100 textos): Divide los textos en lotes del tamano especificado
#'   en \code{chunk_size} para controlar el uso de memoria y permitir procesamiento de grandes volumenes.
#' }
#'
#' El sistema de cache de geocodificacion guarda las coordenadas de ubicaciones ya consultadas
#' en formato JSON, evitando consultas repetidas a la API de Nominatim (que tiene limite de 1 req/seg).
#' Esto puede reducir el tiempo de procesamiento en 50-90% en ejecuciones posteriores con ubicaciones repetidas.
#'
#' Para datasets muy grandes (>100,000 textos), se recomienda procesar en lotes usando la funcion
#' auxiliar proporcionada en los ejemplos y guardar resultados incrementalmente.
#' @keywords etiquetado optimizacion chunking cache
#' @examples
#' \dontrun{
#' # Ejemplo basico con pocos textos
#' textos <- c(
#'   "En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.",
#'   "La manifestacion se realizo en Buenos Aires el 15 de marzo.",
#'   "El presidente visito Cordoba para inaugurar la nueva planta."
#' )
#' resultado <- acep_postag(texto = textos, bajar_core = FALSE)
#' head(resultado$texto_tag)
#'
#' # Ejemplo con dataset mediano y configuracion personalizada
#' resultado <- acep_postag(
#'   texto = mis_1000_textos,
#'   bajar_core = FALSE,
#'   chunk_size = 500,
#'   geocode_cache_file = "cache/ubicaciones_argentina.json",
#'   use_cache = TRUE
#' )
#'
#' # Ver ubicaciones geocodificadas
#' head(resultado$texto_only_entity_loc)
#'
#' # Procesamiento incremental para datasets muy grandes
#' procesar_incremental <- function(textos, batch_size = 10000) {
#'   dir.create("resultados", showWarnings = FALSE)
#'   n_batches <- ceiling(length(textos) / batch_size)
#'
#'   for (i in 1:n_batches) {
#'     start_idx <- (i - 1) * batch_size + 1
#'     end_idx <- min(i * batch_size, length(textos))
#'     batch <- textos[start_idx:end_idx]
#'
#'     resultado <- acep_postag(
#'       texto = batch,
#'       bajar_core = FALSE,
#'       chunk_size = 2000,
#'       use_cache = TRUE,
#'       geocode_cache_file = "cache_global.json"
#'     )
#'
#'     saveRDS(resultado, sprintf("resultados/batch_%04d.rds", i))
#'     message(sprintf("Batch %d/%d completado", i, n_batches))
#'   }
#' }
#'
#' # Usar funcion incremental
#' procesar_incremental(mis_millones_de_textos, batch_size = 10000)
#'
#' # Ver contenido del cache
#' cache <- jsonlite::read_json("geocode_cache.json", simplifyVector = TRUE)
#' print(paste("Ubicaciones en cache:", nrow(cache)))
#' }
#' @export
acep_postag <- function(texto,
                        core = "es_core_news_lg",
                        bajar_core = TRUE,
                        inst_spacy = FALSE,
                        inst_miniconda = FALSE,
                        inst_reticulate = FALSE,
                        chunk_size = 1000,
                        geocode_cache_file = "geocode_cache.json",
                        use_cache = TRUE,
                        show_progress = TRUE) {
  
  # Validaciones de parametros
  if (!is.character(texto)) {
    stop("El parametro 'texto' debe ser un vector de caracteres")
  }
  if (!is.logical(inst_reticulate)) {
    stop("El parametro 'inst_reticulate' debe ser un valor booleano: TRUE o FALSE")
  }
  if (!is.logical(inst_miniconda)) {
    stop("El parametro 'inst_miniconda' debe ser un valor booleano: TRUE o FALSE")
  }
  if (!is.logical(inst_spacy)) {
    stop("El parametro 'inst_spacy' debe ser un valor booleano: TRUE o FALSE")
  }
  if (!is.logical(bajar_core)) {
    stop("El parametro 'bajar_core' debe ser un valor booleano: TRUE o FALSE")
  }
  if (!is.logical(use_cache)) {
    stop("El parametro 'use_cache' debe ser un valor booleano: TRUE o FALSE")
  }
  if (!is.logical(show_progress)) {
    stop("El parametro 'show_progress' debe ser un valor booleano: TRUE o FALSE")
  }
  if (!is.numeric(chunk_size) || chunk_size < 1) {
    stop("El parametro 'chunk_size' debe ser un numero entero positivo")
  }
  
  available_models <- c('es_core_news_sm','es_core_news_md','es_core_news_lg',
                        'pt_core_news_sm','pt_core_news_md','pt_core_news_lg',
                        'en_core_web_sm','en_core_web_md','en_core_web_lg','en_core_web_trf')
  
  if (!core %in% available_models) {
    stop(paste("El parametro 'core' debe ser un modelo valido del espanol, ingles o portugues:",
               paste0(available_models, collapse = ", ")))
  }
  
  # Instalaciones condicionales
  if (inst_reticulate) {
    utils::install.packages("reticulate")
  }
  if (inst_miniconda) {
    reticulate::install_miniconda()
  }
  if (inst_spacy) {
    spacyr::spacy_install()
  }
  if (bajar_core) {
    spacyr::spacy_download_langmodel(core)
  }
  
  # Inicializar spaCy
  spacyr::spacy_initialize(model = core)
  
  # Determinar estrategia de procesamiento
  n_textos <- length(texto)

  if (show_progress) {
    message(sprintf("Procesando %d textos...", n_textos))
  }

  # Estrategia 1: Batch processing para pocos textos (<= 100)
  if (n_textos <= 100) {
    if (show_progress) {
      message("Usando batch processing (todos los textos juntos)")
    }
    
    texto_tag <- suppressWarnings({
      spacyr::spacy_parse(texto,
                          pos = TRUE,
                          tag = FALSE,
                          lemma = TRUE,
                          entity = TRUE,
                          dependency = TRUE,
                          nounphrase = TRUE,
                          multithread = TRUE,
                          additional_attributes = c("is_upper", "is_title", "is_quote",
                                                   "ent_iob_","ent_iob", "is_left_punct",
                                                   "is_right_punct", "morph", "sent"))
    })
    
    # Convertir columnas especiales
    texto_tag$morph <- sapply(texto_tag$morph, as.character)
    texto_tag$sent <- sapply(texto_tag$sent, as.character)
    texto_tag$doc_id <- as.integer(gsub("text", "", texto_tag$doc_id))
    
  } else {
    # Estrategia 2: Chunking para muchos textos (> 100)
    if (show_progress) {
      message(sprintf("Usando chunking (lotes de %d textos)", chunk_size))
    }
    
    # Dividir en chunks
    n_chunks <- ceiling(n_textos / chunk_size)
    texto_tag_list <- vector("list", n_chunks)
    
    for (i in 1:n_chunks) {
      start_idx <- (i - 1) * chunk_size + 1
      end_idx <- min(i * chunk_size, n_textos)
      chunk_textos <- texto[start_idx:end_idx]
      
      if (show_progress) {
        message(sprintf("Procesando chunk %d/%d (textos %d-%d)", i, n_chunks, start_idx, end_idx))
      }
      
      chunk_tag <- suppressWarnings({
        spacyr::spacy_parse(chunk_textos,
                            pos = TRUE,
                            tag = FALSE,
                            lemma = TRUE,
                            entity = TRUE,
                            dependency = TRUE,
                            nounphrase = TRUE,
                            multithread = TRUE,
                            additional_attributes = c("is_upper", "is_title", "is_quote",
                                                     "ent_iob_","ent_iob", "is_left_punct",
                                                     "is_right_punct", "morph", "sent"))
      })
      
      # Convertir columnas especiales inmediatamente
      chunk_tag$morph <- sapply(chunk_tag$morph, as.character)
      chunk_tag$sent <- sapply(chunk_tag$sent, as.character)
      
      # Ajustar doc_id para que sea continuo
      chunk_tag$doc_id <- as.integer(gsub("text", "", chunk_tag$doc_id)) + start_idx - 1
      
      texto_tag_list[[i]] <- chunk_tag
    }
    
    # Combinar todos los chunks
    texto_tag <- do.call(rbind, texto_tag_list)
  }
  
  # Limpiar columna sent
  texto_tag$sent <- trimws(gsub("\\n+", "", texto_tag$sent))
  texto_tag <- texto_tag[texto_tag$sent != "", ]
  
  # Procesamiento de entidades y frases nominales
  if (show_progress) {
    message("Consolidando entidades y frases nominales...")
  }
  
  texto_tag_entity <- spacyr::entity_consolidate(texto_tag)
  texto_only_entity <- spacyr::entity_extract(texto_tag, type = "all")
  texto_nounphrase <- spacyr::nounphrase_consolidate(texto_tag)
  texto_only_nounphrase <- spacyr::nounphrase_extract(texto_tag)
  
  # Finalizar spaCy
  spacyr::spacy_finalize()
  
  # Convertir a tokenindex
  texto_tag <- rsyntax::as_tokenindex(texto_tag)
  
  # Geocodificacion con cache
  texto_only_entity_loc <- unique(texto_only_entity[texto_only_entity$entity_type == "LOC", ])

  if (nrow(texto_only_entity_loc) > 0) {
    texto_only_entity_loc$entity_ <- gsub("_", " ", texto_only_entity_loc$entity)
    unique_locations <- unique(texto_only_entity_loc$entity_)

    if (show_progress) {
      message(sprintf("Geocodificando %d ubicaciones unicas...", length(unique_locations)))
    }

    # Cargar cache existente si esta habilitado
    if (use_cache && file.exists(geocode_cache_file)) {
      if (show_progress) {
        message(sprintf("Cargando cache desde: %s", geocode_cache_file))
      }
      cached_geocoder <- jsonlite::read_json(geocode_cache_file, simplifyVector = TRUE)
    } else {
      cached_geocoder <- data.frame(entity_ = character(),
                                     lat = numeric(),
                                     long = numeric(),
                                     stringsAsFactors = FALSE)
    }

    # Identificar ubicaciones que necesitan geocodificacion
    new_locations <- setdiff(unique_locations, cached_geocoder$entity_)

    if (length(new_locations) > 0) {
      if (show_progress) {
        message(sprintf("Geocodificando %d ubicaciones nuevas (usando cache para %d)...",
                       length(new_locations),
                       length(unique_locations) - length(new_locations)))
      }

      # Geocodificar solo ubicaciones nuevas
      new_geocoder <- tidygeocoder::geo(new_locations, method = "osm")
      names(new_geocoder) <- c("entity_", "lat", "long")

      # Combinar con cache
      cached_geocoder <- rbind(cached_geocoder, new_geocoder)

      # Guardar cache actualizado
      if (use_cache) {
        jsonlite::write_json(cached_geocoder, geocode_cache_file, pretty = TRUE)
        if (show_progress) {
          message(sprintf("Cache actualizado: %s", geocode_cache_file))
        }
      }
    } else {
      if (show_progress) {
        message("Todas las ubicaciones encontradas en cache")
      }
    }

    # Usar cache para merge
    texto_geocoder <- cached_geocoder[cached_geocoder$entity_ %in% unique_locations, ]
    
    # Merge con entidades
    texto_only_entity_loc <- merge(texto_only_entity_loc, texto_geocoder, 
                                   by = "entity_", all.x = TRUE)
    names(texto_only_entity_loc) <- c("entity_", "doc_id", "sentence", "entity", 
                                      "entity_type", "lat", "long")
    
    texto_only_entity_loc <- merge(texto_only_entity_loc, 
                                   unique(texto_tag[, c("doc_id", "sentence")]), 
                                   by = c("doc_id", "sentence"))
    texto_only_entity_loc <- unique(texto_only_entity_loc[!is.na(texto_only_entity_loc$lat), ])
  } else {
    texto_only_entity_loc <- data.frame(entity_ = character(),
                                        doc_id = integer(),
                                        sentence = integer(),
                                        entity = character(),
                                        entity_type = character(),
                                        lat = numeric(),
                                        long = numeric(),
                                        stringsAsFactors = FALSE)
  }
  
  if (show_progress) {
    message("Procesamiento completado")
  }
  
  # Retornar lista de resultados
  return(list(
    texto_tag = texto_tag,
    texto_tag_entity = texto_tag_entity,
    texto_only_entity = texto_only_entity,
    texto_only_entity_loc = texto_only_entity_loc,
    texto_nounphrase = texto_nounphrase,
    texto_only_nounphrase = texto_only_nounphrase
  ))
}
