# Etiquetado POS, lematizacion y extraccion de entidades con spacyr

Realiza analisis linguistico completo de textos usando la biblioteca
spaCy a traves de spacyr. Incluye: etiquetado POS (Part-of-Speech),
lematizacion, tokenizacion, extraccion de entidades nombradas, frases
nominales y geocodificacion de ubicaciones. La funcion procesa
automaticamente grandes volumenes de texto dividiendolos en lotes
(chunks) y soporta procesamiento paralelo para acelerar el analisis

## Usage

``` r
acep_postag_hibrido(
  texto,
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
  show_progress = TRUE
)
```

## Arguments

- texto:

  Vector de caracteres con los textos a analizar.

- core:

  Modelo de lenguaje de spaCy a utilizar. Opciones:
  \`"es_core_news_sm"\`, \`"es_core_news_md"\`, \`"es_core_news_lg"\`
  (espanol), \`"en_core_web_sm"\`, \`"en_core_web_md"\`,
  \`"en_core_web_lg"\` (ingles), \`"pt_core_news_sm"\`,
  \`"pt_core_news_md"\`, \`"pt_core_news_lg"\` (portugues). Por defecto:
  \`"es_core_news_lg"\`.

- bajar_core:

  Logico. Si \`TRUE\`, descarga automaticamente el modelo si no esta
  instalado.

- inst_spacy:

  Logico. Si \`TRUE\`, instala la biblioteca spaCy en el entorno Python.

- inst_miniconda:

  Logico. Si \`TRUE\`, instala Miniconda (necesario para spaCy).

- inst_reticulate:

  Logico. Si \`TRUE\`, instala el paquete reticulate de R.

- chunk_size:

  Numero de textos a procesar por lote. Valores mas bajos consumen menos
  memoria pero tardan mas. Por defecto: 1000.

- parallel_chunks:

  Logico. Si \`TRUE\`, procesa los lotes en paralelo usando multiples
  nucleos del CPU. Requiere los paquetes \`future\` y \`furrr\`. Por
  defecto: \`FALSE\`.

- n_cores:

  Numero de nucleos de CPU a usar en modo paralelo. Si es \`NULL\`,
  detecta automaticamente el numero de nucleos disponibles menos uno.

- geocode_cache_file:

  Ruta al archivo JSON donde se almacena el cache de geocodificacion
  para evitar consultas repetidas. Por defecto:
  \`"geocode_cache.json"\`.

- use_cache:

  Logico. Si \`TRUE\`, usa y actualiza el cache de geocodificacion.

- show_progress:

  Logico. Si \`TRUE\`, muestra mensajes de progreso en la consola.

## Value

Lista con 6 data frames que contienen diferentes niveles de analisis:

- `texto_tag`: Tokenizacion completa con etiquetas POS, lemas,
  dependencias sintacticas y atributos morfologicos para cada token

- `texto_tag_entity`: Tokens con entidades nombradas consolidadas (ej:
  "Mar del Plata" como una sola entidad en lugar de 3 tokens separados)

- `texto_only_entity`: Solo las entidades nombradas extraidas (personas,
  organizaciones, ubicaciones, fechas, etc.)

- `texto_only_entity_loc`: Entidades de tipo ubicacion (LOC) con
  coordenadas geograficas (latitud/longitud) obtenidas mediante
  geocodificacion

- `texto_nounphrase`: Tokens con frases nominales consolidadas

- `texto_only_nounphrase`: Solo las frases nominales extraidas

## Examples

``` r
if (FALSE) { # \dontrun{
# Analisis basico de un texto
texto <- "El SUTEBA convoco a un paro en Mar del Plata el 15 de marzo."
resultado <- acep_postag_hibrido(texto)

# Ver tokens con etiquetas POS
head(resultado$texto_tag)

# Ver entidades nombradas
print(resultado$texto_only_entity)

# Ver ubicaciones geocodificadas
print(resultado$texto_only_entity_loc)

# Procesar multiples textos con procesamiento paralelo
textos <- c("Primera noticia sobre conflictos.",
            "Segunda noticia sobre protestas.",
            "Tercera noticia sobre reclamos.")
resultado <- acep_postag_hibrido(textos,
                                 parallel_chunks = TRUE,
                                 chunk_size = 100)
} # }
```
