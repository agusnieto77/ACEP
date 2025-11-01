#' @title Etiquetado POS, lematización y extracción de entidades con spacyr
#' @description
#' Realiza análisis lingüístico completo de textos usando la biblioteca spaCy a través
#' de spacyr. Incluye: etiquetado POS (Part-of-Speech), lematización, tokenización,
#' extracción de entidades nombradas, frases nominales y geocodificación de ubicaciones.
#' La función procesa automáticamente grandes volúmenes de texto dividiéndolos en lotes
#' (chunks) y soporta procesamiento paralelo para acelerar el análisis
#'
#' @param texto Vector de caracteres con los textos a analizar.
#' @param core Modelo de lenguaje de spaCy a utilizar. Opciones: `"es_core_news_sm"`,
#'   `"es_core_news_md"`, `"es_core_news_lg"` (español), `"en_core_web_sm"`,
#'   `"en_core_web_md"`, `"en_core_web_lg"` (inglés), `"pt_core_news_sm"`,
#'   `"pt_core_news_md"`, `"pt_core_news_lg"` (portugués). Por defecto: `"es_core_news_lg"`.
#' @param bajar_core Lógico. Si `TRUE`, descarga automáticamente el modelo si no está instalado.
#' @param inst_spacy Lógico. Si `TRUE`, instala la biblioteca spaCy en el entorno Python.
#' @param inst_miniconda Lógico. Si `TRUE`, instala Miniconda (necesario para spaCy).
#' @param inst_reticulate Lógico. Si `TRUE`, instala el paquete reticulate de R.
#' @param chunk_size Número de textos a procesar por lote. Valores más bajos consumen
#'   menos memoria pero tardan más. Por defecto: 1000.
#' @param parallel_chunks Lógico. Si `TRUE`, procesa los lotes en paralelo usando
#'   múltiples núcleos del CPU. Requiere los paquetes `future` y `furrr`. Por defecto: `FALSE`.
#' @param n_cores Número de núcleos de CPU a usar en modo paralelo. Si es `NULL`,
#'   detecta automáticamente el número de núcleos disponibles menos uno.
#' @param geocode_cache_file Ruta al archivo JSON donde se almacena el caché de
#'   geocodificación para evitar consultas repetidas. Por defecto: `"geocode_cache.json"`.
#' @param use_cache Lógico. Si `TRUE`, usa y actualiza el caché de geocodificación.
#' @param show_progress Lógico. Si `TRUE`, muestra mensajes de progreso en la consola.
#'
#' @return Lista con 6 data frames que contienen diferentes niveles de análisis:
#' \itemize{
#'   \item \code{texto_tag}: Tokenización completa con etiquetas POS, lemas, dependencias
#'     sintácticas y atributos morfológicos para cada token
#'   \item \code{texto_tag_entity}: Tokens con entidades nombradas consolidadas
#'     (ej: "Mar del Plata" como una sola entidad en lugar de 3 tokens separados)
#'   \item \code{texto_only_entity}: Solo las entidades nombradas extraídas
#'     (personas, organizaciones, ubicaciones, fechas, etc.)
#'   \item \code{texto_only_entity_loc}: Entidades de tipo ubicación (LOC)
#'     con coordenadas geográficas (latitud/longitud) obtenidas mediante geocodificación
#'   \item \code{texto_nounphrase}: Tokens con frases nominales consolidadas
#'   \item \code{texto_only_nounphrase}: Solo las frases nominales extraídas
#' }
#'
#' @export
#' @examples
#' \dontrun{
#' # Análisis básico de un texto
#' texto <- "El SUTEBA convocó a un paro en Mar del Plata el 15 de marzo."
#' resultado <- acep_postag_hibrido(texto)
#'
#' # Ver tokens con etiquetas POS
#' head(resultado$texto_tag)
#'
#' # Ver entidades nombradas
#' print(resultado$texto_only_entity)
#'
#' # Ver ubicaciones geocodificadas
#' print(resultado$texto_only_entity_loc)
#'
#' # Procesar múltiples textos con procesamiento paralelo
#' textos <- c("Primera noticia sobre conflictos.",
#'             "Segunda noticia sobre protestas.",
#'             "Tercera noticia sobre reclamos.")
#' resultado <- acep_postag_hibrido(textos,
#'                                  parallel_chunks = TRUE,
#'                                  chunk_size = 100)
#' }
acep_postag_hibrido <- function(texto,
                                core = "es_core_news_lg",
                                bajar_core = TRUE,
                                inst_spacy = FALSE,
                                inst_miniconda = FALSE,
                                inst_reticulate = FALSE,
                                chunk_size = 1000,
                                parallel_chunks = FALSE,
                                n_cores = NULL,
                                geocode_cache_file = "geocode_cache.json",
                                use_cache = TRUE,
                                show_progress = TRUE) {
  
  # Validaciones
  if (!is.character(texto)) {
    stop("El parámetro 'texto' debe ser una cadena de caracteres")
  }
  if (!is.logical(inst_reticulate)) {
    stop("El parámetro 'inst_reticulate' debe ser un valor booleano: TRUE o FALSE")
  }
  if (!is.logical(inst_miniconda)) {
    stop("El parámetro 'inst_miniconda' debe ser un valor booleano: TRUE o FALSE")
  }
  if (!is.logical(inst_spacy)) {
    stop("El parámetro 'inst_spacy' debe ser un valor booleano: TRUE o FALSE")
  }
  if (!is.logical(bajar_core)) {
    stop("El parámetro 'bajar_core' debe ser un valor booleano: TRUE o FALSE")
  }
  if (!is.logical(parallel_chunks)) {
    stop("El parámetro 'parallel_chunks' debe ser un valor booleano: TRUE o FALSE")
  }
  if (!is.logical(use_cache)) {
    stop("El parámetro 'use_cache' debe ser un valor booleano: TRUE o FALSE")
  }
  if (!is.logical(show_progress)) {
    stop("El parámetro 'show_progress' debe ser un valor booleano: TRUE o FALSE")
  }
  
  available_models <- c('es_core_news_sm','es_core_news_md','es_core_news_lg',
                        'pt_core_news_sm','pt_core_news_md','pt_core_news_lg',
                        'en_core_web_sm','en_core_web_md','en_core_web_lg','en_core_web_trf')
  if (!core %in% available_models) {
    stop("El parámetro 'core' debe ser un modelo 'core' válido del español, inglés o portugués: ",
         paste0(available_models, collapse = ", "))
  }
  
  # Instalaciones
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
  
  # Inicializar spaCy en proceso principal
  spacyr::spacy_initialize(model = core)
  
  n_textos <- length(texto)
  
  # Determinar estrategia de procesamiento
  if (n_textos <= 100) {
    # Batch processing para pocos textos
    if (show_progress) {
      message(sprintf("Procesando %d textos en modo batch...", n_textos))
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
    # Chunking para muchos textos
    n_chunks <- ceiling(n_textos / chunk_size)
    
    if (show_progress) {
      if (parallel_chunks) {
        message(sprintf("Procesando %d textos en %d chunks (paralelo con %d cores)...", 
                        n_textos, n_chunks, ifelse(is.null(n_cores), parallel::detectCores() - 1, n_cores)))
      } else {
        message(sprintf("Procesando %d textos en %d chunks (secuencial)...", n_textos, n_chunks))
      }
    }
    
    if (parallel_chunks && n_chunks >= 2) {
      # Modo paralelo: paralelizar chunks
      if (!requireNamespace("future", quietly = TRUE)) {
        stop("El paquete 'future' es necesario para paralelización. Instálalo con: install.packages('future')")
      }
      if (!requireNamespace("furrr", quietly = TRUE)) {
        stop("El paquete 'furrr' es necesario para paralelización. Instálalo con: install.packages('furrr')")
      }
      
      # Configurar plan paralelo
      if (is.null(n_cores)) {
        n_cores <- parallel::detectCores() - 1
      }
      future::plan(future::multisession, workers = n_cores)
      
      # Crear índices de chunks
      chunk_indices <- split(1:n_textos, ceiling(seq_along(texto) / chunk_size))
      
      texto_tag_list <- furrr::future_map(seq_along(chunk_indices), function(chunk_num) {
        indices <- chunk_indices[[chunk_num]]
        
        # Cada worker inicializa su propia sesión de spaCy
        tryCatch({
          spacyr::spacy_initialize(model = core)
        }, error = function(e) {
          # Si ya está inicializado, continuar
        })
        
        chunk_textos <- texto[indices]
        
        postag <- suppressWarnings({
          spacyr::spacy_parse(chunk_textos,
                              pos = TRUE,
                              tag = FALSE,
                              lemma = TRUE,
                              entity = TRUE,
                              dependency = TRUE,
                              nounphrase = TRUE,
                              multithread = FALSE,  # Evitar conflictos
                              additional_attributes = c("is_upper", "is_title", "is_quote",
                                                        "ent_iob_","ent_iob", "is_left_punct",
                                                        "is_right_punct", "morph", "sent"))
        })
        
        # Convertir columnas especiales ANTES de devolver
        postag$morph <- sapply(postag$morph, as.character)
        postag$sent <- sapply(postag$sent, as.character)
        
        # Extraer número de doc_id original (text1 -> 1, text2 -> 2, etc.)
        original_doc_nums <- as.integer(gsub("text", "", postag$doc_id))
        # Calcular offset basado en el chunk
        offset <- (chunk_num - 1) * chunk_size
        # Asignar nuevos doc_ids únicos
        postag$doc_id <- paste0("text", original_doc_nums + offset)
        
        return(postag)
      }, .progress = show_progress, .options = furrr::furrr_options(seed = TRUE))
      
      # Restaurar plan secuencial
      future::plan(future::sequential)
      
      # Combinar resultados
      texto_tag <- do.call(rbind, texto_tag_list)
      texto_tag$doc_id <- as.integer(gsub("text", "", texto_tag$doc_id))
      
    } else {
      # Modo secuencial: procesar chunks uno por uno
      texto_tag_list <- vector("list", n_chunks)
      
      for (i in seq_len(n_chunks)) {
        start_idx <- (i - 1) * chunk_size + 1
        end_idx <- min(i * chunk_size, n_textos)
        
        if (show_progress) {
          message(sprintf("Procesando chunk %d/%d (textos %d-%d)", i, n_chunks, start_idx, end_idx))
        }
        
        chunk_textos <- texto[start_idx:end_idx]
        
        postag <- suppressWarnings({
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
        
        # Convertir columnas especiales
        postag$morph <- sapply(postag$morph, as.character)
        postag$sent <- sapply(postag$sent, as.character)
        
        # Extraer número de doc_id original
        original_doc_nums <- as.integer(gsub("text", "", postag$doc_id))
        # Calcular offset basado en el chunk
        offset <- (i - 1) * chunk_size
        # Asignar nuevos doc_ids únicos
        postag$doc_id <- paste0("text", original_doc_nums + offset)
        
        texto_tag_list[[i]] <- postag
        
        # Liberar memoria cada 10 chunks
        if (i %% 10 == 0) {
          gc()
        }
      }
      
      # Combinar resultados
      texto_tag <- do.call(rbind, texto_tag_list)
      texto_tag$doc_id <- as.integer(gsub("text", "", texto_tag$doc_id))
    }
  }
  
  # Limpiar texto
  texto_tag$sent <- trimws(gsub("\\n+", "", texto_tag$sent))
  texto_tag <- texto_tag[texto_tag$sent != "", ]
  
  # Procesamiento de entidades y frases nominales
  if (show_progress) {
    message("Consolidando entidades nombradas...")
  }
  texto_tag_entity <- spacyr::entity_consolidate(texto_tag)
  texto_only_entity <- spacyr::entity_extract(texto_tag, type = "all")
  
  if (show_progress) {
    message("Consolidando frases nominales...")
  }
  texto_nounphrase <- spacyr::nounphrase_consolidate(texto_tag)
  texto_only_nounphrase <- spacyr::nounphrase_extract(texto_tag)
  
  spacyr::spacy_finalize()
  
  texto_tag <- rsyntax::as_tokenindex(texto_tag)
  
  # Geocodificación con caché
  texto_only_entity_loc <- unique(texto_only_entity[texto_only_entity$entity_type == "LOC", ])
  
  if (nrow(texto_only_entity_loc) > 0) {
    texto_only_entity_loc$entity_ <- gsub("_", " ", texto_only_entity_loc$entity)
    unique_locations <- unique(texto_only_entity_loc$entity_)
    
    # Cargar caché si existe
    cached_geocoder <- data.frame(entity_ = character(), lat = numeric(), long = numeric())
    if (use_cache && file.exists(geocode_cache_file)) {
      if (show_progress) {
        message(sprintf("Cargando caché de geocodificación desde %s...", geocode_cache_file))
      }
      cached_geocoder <- jsonlite::read_json(geocode_cache_file, simplifyVector = TRUE)
    }
    
    # Geocodificar solo ubicaciones nuevas
    new_locations <- setdiff(unique_locations, cached_geocoder$entity_)
    
    if (length(new_locations) > 0) {
      if (show_progress) {
        message(sprintf("Geocodificando %d ubicaciones nuevas...", length(new_locations)))
      }
      new_geocoder <- tidygeocoder::geo(new_locations, method = "osm")
      names(new_geocoder) <- c("entity_", "lat", "long")
      
      # Combinar con caché
      cached_geocoder <- rbind(cached_geocoder, new_geocoder)
      
      # Guardar caché actualizado
      if (use_cache) {
        jsonlite::write_json(cached_geocoder, geocode_cache_file, pretty = TRUE)
        if (show_progress) {
          message(sprintf("Caché actualizado: %d ubicaciones totales", nrow(cached_geocoder)))
        }
      }
    } else {
      if (show_progress) {
        message("Todas las ubicaciones están en caché")
      }
    }
    
    # Usar caché para merge
    texto_geocoder <- cached_geocoder[cached_geocoder$entity_ %in% unique_locations, ]
    
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
                                        long = numeric())
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
