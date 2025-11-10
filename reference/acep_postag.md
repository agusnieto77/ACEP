# Etiquetado POS adaptativo con optimizaciones avanzadas

Version optimizada de acep_postag que se adapta automaticamente al
tamano del input. Implementa procesamiento por lotes (chunking) para
grandes volumenes, cache de geocodificacion para evitar consultas
repetidas, y estrategias de procesamiento adaptativas segun la cantidad
de textos. Puede procesar desde 10 hasta millones de textos de forma
eficiente.

## Usage

``` r
acep_postag(
  texto,
  core = "es_core_news_lg",
  bajar_core = TRUE,
  inst_spacy = FALSE,
  inst_miniconda = FALSE,
  inst_reticulate = FALSE,
  chunk_size = 1000,
  geocode_cache_file = "geocode_cache.json",
  use_cache = TRUE,
  show_progress = TRUE
)
```

## Arguments

- texto:

  Vector de caracteres con los textos a procesar.

- core:

  Idioma del modelo de etiquetado POS del paquete `spacyr`. Opciones
  disponibles: 'es_core_news_sm', 'es_core_news_md', 'es_core_news_lg'
  (espanol), 'pt_core_news_sm', 'pt_core_news_md', 'pt_core_news_lg'
  (portugues), 'en_core_web_sm', 'en_core_web_md', 'en_core_web_lg',
  'en_core_web_trf' (ingles). Default: "es_core_news_lg".

- bajar_core:

  Parametro booleano que define si descargar o no el modelo de
  etiquetado POS. Default: TRUE.

- inst_spacy:

  Parametro booleano que define si instalar o no spacy (Python).
  Default: FALSE.

- inst_miniconda:

  Parametro booleano que define si instalar o no miniconda. Default:
  FALSE.

- inst_reticulate:

  Parametro booleano que define si instalar o no el paquete
  `reticulate`. Default: FALSE.

- chunk_size:

  Tamano de los lotes para procesamiento chunking. Ajustar segun RAM
  disponible: 500 para sistemas con 2-4 GB RAM, 1000 para 8 GB RAM
  (default), 2000-5000 para 16+ GB RAM. Default: 1000.

- geocode_cache_file:

  Ruta del archivo JSON para guardar cache de geocodificacion. Permite
  evitar consultas repetidas a la API de Nominatim y compartir cache
  entre proyectos. Default: "geocode_cache.json".

- use_cache:

  Parametro booleano que activa/desactiva el sistema de cache de
  geocodificacion. Desactivar para forzar re-geocodificacion de todas
  las ubicaciones. Default: TRUE.

- show_progress:

  Parametro booleano que controla la visualizacion de mensajes de
  progreso durante el procesamiento. Util para operaciones largas.
  Default: TRUE.

## Value

Lista con seis elementos en formato tabular:

- `texto_tag`: Data frame con tokens etiquetados (POS, lemas,
  dependencias, etc.)

- `texto_tag_entity`: Data frame con entidades nombradas consolidadas

- `texto_only_entity`: Data frame con solo las entidades extraidas

- `texto_only_entity_loc`: Data frame con entidades de tipo LOC
  geocodificadas (lat/long)

- `texto_nounphrase`: Data frame con frases nominales consolidadas

- `texto_only_nounphrase`: Data frame con solo las frases nominales
  extraidas

## Details

La funcion implementa dos estrategias de procesamiento automaticas:

- **Batch Processing** (\<= 100 textos): Procesa todos los textos en una
  sola llamada para maxima velocidad.

- **Chunking** (\> 100 textos): Divide los textos en lotes del tamano
  especificado en `chunk_size` para controlar el uso de memoria y
  permitir procesamiento de grandes volumenes.

El sistema de cache de geocodificacion guarda las coordenadas de
ubicaciones ya consultadas en formato JSON, evitando consultas repetidas
a la API de Nominatim (que tiene limite de 1 req/seg). Esto puede
reducir el tiempo de procesamiento en 50-90

Para datasets muy grandes (\>100,000 textos), se recomienda procesar en
lotes usando la funcion auxiliar proporcionada en los ejemplos y guardar
resultados incrementalmente.

## Examples

``` r
if (FALSE) { # \dontrun{
# Ejemplo basico con pocos textos
textos <- c(
  "En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.",
  "La manifestacion se realizo en Buenos Aires el 15 de marzo.",
  "El presidente visito Cordoba para inaugurar la nueva planta."
)
resultado <- acep_postag(texto = textos, bajar_core = FALSE)
head(resultado$texto_tag)

# Ejemplo con dataset mediano y configuracion personalizada
resultado <- acep_postag(
  texto = mis_1000_textos,
  bajar_core = FALSE,
  chunk_size = 500,
  geocode_cache_file = "cache/ubicaciones_argentina.json",
  use_cache = TRUE
)

# Ver ubicaciones geocodificadas
head(resultado$texto_only_entity_loc)

# Procesamiento incremental para datasets muy grandes
procesar_incremental <- function(textos, batch_size = 10000) {
  dir.create("resultados", showWarnings = FALSE)
  n_batches <- ceiling(length(textos) / batch_size)

  for (i in 1:n_batches) {
    start_idx <- (i - 1) * batch_size + 1
    end_idx <- min(i * batch_size, length(textos))
    batch <- textos[start_idx:end_idx]

    resultado <- acep_postag(
      texto = batch,
      bajar_core = FALSE,
      chunk_size = 2000,
      use_cache = TRUE,
      geocode_cache_file = "cache_global.json"
    )

    saveRDS(resultado, sprintf("resultados/batch_%04d.rds", i))
    message(sprintf("Batch %d/%d completado", i, n_batches))
  }
}

# Usar funcion incremental
procesar_incremental(mis_millones_de_textos, batch_size = 10000)

# Ver contenido del cache
cache <- jsonlite::read_json("geocode_cache.json", simplifyVector = TRUE)
print(paste("Ubicaciones en cache:", nrow(cache)))
} # }
```
