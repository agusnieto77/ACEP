# Changelog

## ACEP 0.1.2

### Correcciones (cambian resultados)

- [`acep_clean()`](https://agusnieto77.github.io/ACEP/reference/acep_clean.md):
  ahora remueve correctamente las stopwords acentuadas escritas en
  MAYÚSCULA (p. ej. “MÁS”, “SÍ”). Antes el plegado de tildes corría
  después de la remoción de stopwords y esas palabras quedaban sin
  filtrar.
- [`acep_count()`](https://agusnieto77.github.io/ACEP/reference/acep_count.md)
  /
  [`acep_detect()`](https://agusnieto77.github.io/ACEP/reference/acep_detect.md):
  los términos del diccionario que contienen metacaracteres de
  expresiones regulares (`(`, `)`, `.`, `$`, etc.) ahora se tratan como
  texto literal. Antes podían producir coincidencias erróneas o abortar
  con un error de regex. Además,
  [`acep_detect()`](https://agusnieto77.github.io/ACEP/reference/acep_detect.md)
  aplica los límites de palabra (`\b`) de la misma forma que
  [`acep_count()`](https://agusnieto77.github.io/ACEP/reference/acep_count.md)
  cuando el término viene rodeado de espacios (antes el `\b` se
  insertaba como una “b” literal).
- [`acep_token_table()`](https://agusnieto77.github.io/ACEP/reference/acep_token_table.md)
  y
  [`acep_token_plot()`](https://agusnieto77.github.io/ACEP/reference/acep_token_plot.md):
  la proporción (`prop`) se calcula sobre el total del corpus y no sobre
  el subconjunto de las `u` palabras más frecuentes, coincidiendo con la
  definición documentada en la viñeta.
- [`acep_extract()`](https://agusnieto77.github.io/ACEP/reference/acep_extract.md):
  una entrada `NA` ahora devuelve `NA` real en lugar de la cadena
  literal `"NA"`.
- [`acep_token()`](https://agusnieto77.github.io/ACEP/reference/acep_token.md):
  descarta entradas `NA` en vez de generar filas de tokens `NA`.

### Correcciones (sin cambios de comportamiento esperados)

- [`acep_token_plot()`](https://agusnieto77.github.io/ACEP/reference/acep_token_plot.md):
  restaura el estado gráfico
  [`par()`](https://rdrr.io/r/graphics/par.html) al salir
  ([`on.exit()`](https://rdrr.io/r/base/on.exit.html)), cumpliendo con
  la política de CRAN.
- Proveedores de IA en la nube
  ([`acep_gpt()`](https://agusnieto77.github.io/ACEP/reference/acep_gpt.md),
  [`acep_claude()`](https://agusnieto77.github.io/ACEP/reference/acep_claude.md),
  [`acep_gemini()`](https://agusnieto77.github.io/ACEP/reference/acep_gemini.md),
  [`acep_together()`](https://agusnieto77.github.io/ACEP/reference/acep_together.md),
  [`acep_openrouter()`](https://agusnieto77.github.io/ACEP/reference/acep_openrouter.md)):
  se agregó el parámetro `timeout` (120 s por defecto) y un timeout HTTP
  efectivo, evitando que una conexión estancada bloquee la sesión de R
  indefinidamente.
- Todos los proveedores de IA comparten ahora un extractor de mensajes
  de error HTTP robusto
  ([`.acep_provider_http_error_message()`](https://agusnieto77.github.io/ACEP/reference/dot-acep_provider_http_error_message.md))
  que no falla cuando el cuerpo de error es atómico, de texto plano
  (HTML 5xx) o no tiene el campo `error$message` (p. ej. respuestas
  429/5xx).
- [`acep_gemini()`](https://agusnieto77.github.io/ACEP/reference/acep_gemini.md)
  y
  [`acep_claude()`](https://agusnieto77.github.io/ACEP/reference/acep_claude.md):
  se elimina `additionalProperties` de forma recursiva en los esquemas
  anidados (antes solo se quitaba del nivel raíz).
- [`acep_load_base()`](https://agusnieto77.github.io/ACEP/reference/acep_load_base.md):
  maneja fallos de red/URL con `tryCatch`, agrega timeout y devuelve
  `NULL` de forma controlada en lugar de propagar errores crudos.
- `plot.acep_result()`: el gráfico de serie temporal ahora pasa los
  vectores correctos a
  [`acep_plot_st()`](https://agusnieto77.github.io/ACEP/reference/acep_plot_st.md)
  (antes le pasaba un data frame y fallaba).
- [`acep_corpus()`](https://agusnieto77.github.io/ACEP/reference/acep_corpus.md):
  valida que `id` tenga la misma longitud que `texto` y que `metadata`
  sea una lista.
- [`acep_upos()`](https://agusnieto77.github.io/ACEP/reference/acep_upos.md)
  y
  [`acep_svo()`](https://agusnieto77.github.io/ACEP/reference/acep_svo.md):
  las validaciones de entrada ahora usan
  [`stop()`](https://rdrr.io/r/base/stop.html) en vez de devolver `NULL`
  silenciosamente.
- Los proveedores de IA en la nube comparten un helper interno
  ([`.acep_provider_post()`](https://agusnieto77.github.io/ACEP/reference/dot-acep_provider_post.md))
  para construir la petición HTTP, eliminando duplicación (refactor
  interno, sin cambios de comportamiento).
- [`acep_count()`](https://agusnieto77.github.io/ACEP/reference/acep_count.md):
  el caché de expresiones regulares ahora está acotado (máximo 1000
  patrones; se vacía al alcanzarlo) para evitar crecimiento de memoria
  sin límite en sesiones largas con muchos diccionarios distintos.

### CRAN y dependencias

- Se declara `grDevices` en `Imports` (se usaba vía `::` sin declarar).
- Se eliminaron los campos redundantes `Author`/`Maintainer` del
  `DESCRIPTION` (se derivan de `Authors@R`).
- Se excluyen del build los artefactos `vignettes/geocode_cache.json` y
  demás archivos `geocode_cache.json`/`Rplots.pdf` (y se quitaron del
  repositorio).

### Documentación

- Se corrigió la documentación de los datos `acep_diccionarios` (son
  URLs, no vectores de palabras), `acep_rs` (tipo, `sw2`, `emojis`) y
  `acep_prompt_gpt` (6 componentes, incluyendo los prompts de sistema).
- [`acep_gpt()`](https://agusnieto77.github.io/ACEP/reference/acep_gpt.md):
  la descripción refleja todos los modelos soportados.

### Tests

- Se reemplazaron los tests tautológicos y los stubs vacíos por
  aserciones reales y deterministas (offline), incluyendo cobertura del
  subsistema de pipeline (`acep_corpus`, `pipe_*`, `acep_pipeline`) y de
  las correcciones de esta versión. Las pruebas del núcleo ahora se
  ejecutan también en CRAN.

## ACEP 0.1.1

CRAN release: 2026-05-14

### Hotfix CRAN

- Se actualizaron ejemplos y viñetas para evitar descargas externas
  durante los checks de CRAN.
- Los ejemplos de
  [`acep_load_base()`](https://agusnieto77.github.io/ACEP/reference/acep_load_base.md)
  y `acep_diccionarios` que requieren internet ahora quedan marcados
  como no ejecutables.
- Las viñetas usan datos incluidos en el paquete o ejemplos sintéticos,
  reduciendo fallas por red/SSL en plataformas de CRAN.

## ACEP 0.1.0

CRAN release: 2026-05-10

### Lanzamiento

- ACEP 0.1.0 fue publicado en CRAN el 2026-05-10.
- Esta versión consolida la optimización del paquete, reduce
  dependencias obligatorias y deja como opcionales varias integraciones
  NLP/geocodificación.

### Nuevas funcionalidades

- Se agregó
  [`acep_corpus()`](https://agusnieto77.github.io/ACEP/reference/acep_corpus.md):
  constructor de objetos corpus para trabajar con pipelines de
  procesamiento de texto.
- Se agregó
  [`acep_result()`](https://agusnieto77.github.io/ACEP/reference/acep_result.md):
  constructor de objetos resultado con métodos de impresión y resumen.
- Se agregó
  [`acep_pipeline()`](https://agusnieto77.github.io/ACEP/reference/acep_pipeline.md):
  pipeline completo que integra limpieza, conteo e intensidad.
- Se agregaron funciones pipeline para análisis composable:
  - [`pipe_clean()`](https://agusnieto77.github.io/ACEP/reference/pipe_clean.md):
    limpieza de texto en pipeline
  - [`pipe_count()`](https://agusnieto77.github.io/ACEP/reference/pipe_count.md):
    conteo de menciones en pipeline
  - [`pipe_intensity()`](https://agusnieto77.github.io/ACEP/reference/pipe_intensity.md):
    cálculo de intensidad en pipeline
  - [`pipe_timeseries()`](https://agusnieto77.github.io/ACEP/reference/pipe_timeseries.md):
    generación de series temporales en pipeline
- Se agregó
  [`acep_postag_hibrido()`](https://agusnieto77.github.io/ACEP/reference/acep_postag_hibrido.md):
  etiquetado POS, lematización y extracción de entidades con spacyr.
- Se agregó
  [`acep_process_chunks()`](https://agusnieto77.github.io/ACEP/reference/acep_process_chunks.md):
  procesamiento de textos en lotes para gestionar grandes volúmenes de
  datos.
- Se agregó
  [`acep_gpt_schema()`](https://agusnieto77.github.io/ACEP/reference/acep_gpt_schema.md):
  esquemas JSON predefinidos para análisis de texto con GPT.
- Se agregó
  [`acep_ollama()`](https://agusnieto77.github.io/ACEP/reference/acep_ollama.md):
  interacción con modelos de lenguaje de Ollama tanto locales como cloud
  usando structured outputs. Permite ejecutar análisis sin costos en
  local y activar modelos gigantes (DeepSeek 671B, Kimi 1T, Qwen3 Coder)
  con una API key opcional.
- Se agregó
  [`acep_ollama_setup()`](https://agusnieto77.github.io/ACEP/reference/acep_ollama_setup.md):
  guía de instalación y configuración de Ollama.
- Se agregó
  [`acep_together()`](https://agusnieto77.github.io/ACEP/reference/acep_together.md):
  integración con TogetherAI para acceder a modelos open source (Llama,
  Qwen, DeepSeek, Moonshot) con JSON mode, esquemas validados y
  postprocesamiento automático.
- **Nuevas funciones de IA con Structured Outputs**:
  - [`acep_claude()`](https://agusnieto77.github.io/ACEP/reference/acep_claude.md):
    interacción con modelos Anthropic Claude (Sonnet 4.5, Claude 3.5,
    Claude 3) usando tool calling forzado para structured outputs
  - [`acep_gemini()`](https://agusnieto77.github.io/ACEP/reference/acep_gemini.md):
    interacción con modelos Google Gemini (2.5 y 2.0) usando
    responseSchema con OpenAPI 3.0. Incluye acceso gratuito limitado
  - [`acep_openrouter()`](https://agusnieto77.github.io/ACEP/reference/acep_openrouter.md):
    gateway unificado para acceder a 400+ modelos de 60+ proveedores
    (OpenAI, Anthropic, Google, Meta, Qwen, DeepSeek) con una sola API y
    soporte de fallback automático
- Se agregaron funciones auxiliares para gestión de caché:
  - [`acep_clear_regex_cache()`](https://agusnieto77.github.io/ACEP/reference/acep_clear_regex_cache.md):
    limpia el caché de expresiones regulares
  - [`acep_regex_cache_size()`](https://agusnieto77.github.io/ACEP/reference/acep_regex_cache_size.md):
    consulta el tamaño del caché

### Mejoras en funciones existentes

- [`acep_count()`](https://agusnieto77.github.io/ACEP/reference/acep_count.md):
  se incorporó sistema de caché de expresiones regulares para mejorar
  rendimiento.
- [`acep_gpt()`](https://agusnieto77.github.io/ACEP/reference/acep_gpt.md):
  se actualizó completamente para soportar Structured Outputs de OpenAI
  con esquemas JSON. Ahora incluye:
  - Soporte para modelos GPT-4o, GPT-4.1, GPT-5, o1 y o4
  - Detección automática de parámetro correcto (`max_tokens` vs
    `max_completion_tokens`) según el modelo
  - Validación flexible con patrones regex para modelos futuros
  - Compatibilidad con todos los modelos que soporten Structured Outputs
- [`acep_clean()`](https://agusnieto77.github.io/ACEP/reference/acep_clean.md):
  renombrada desde `acep_cleaning()` para mayor consistencia.
- [`acep_ollama()`](https://agusnieto77.github.io/ACEP/reference/acep_ollama.md):
  ahora detecta el tipo de endpoint (localhost o cloud), permite fijar
  `max_tokens`, usa hosts remotos con autenticación mediante
  `OLLAMA_API_KEY` y elimina la dependencia obligatoria de `ollamar`.
- [`acep_openrouter()`](https://agusnieto77.github.io/ACEP/reference/acep_openrouter.md):
  agrega listado actualizado de modelos GPT-5, Grok 4, DeepSeek V3/R1,
  Llama 4 y Mixtral, aplica fallback inteligente entre candidatos,
  refuerza la validación JSON y reporta el detalle de errores por
  intento.

### Datos y recursos

- `acep_bases`: se reorganizó la documentación e incorpora el data frame
  `lc_720` con 720 notas anotadas manualmente para evaluar diccionarios
  y extracción estructurada de eventos de protesta.

### Documentación

- Se mejoró la documentación de todas las funciones nuevas y
  modificadas.
- Se agregaron ejemplos prácticos a todas las funciones operativas.
- Se actualizó README.Rmd con la lista completa de funciones del
  paquete, incluyendo las 4 nuevas funciones de IA.
- Se documentó la instalación base liviana y las dependencias opcionales
  para NLP/geocodificación.
- Se actualizaron todas las viñetas para usar las nuevas funciones.
- Se documentó
  [`acep_together()`](https://agusnieto77.github.io/ACEP/reference/acep_together.md)
  y las mejoras de
  [`acep_ollama()`](https://agusnieto77.github.io/ACEP/reference/acep_ollama.md)/[`acep_openrouter()`](https://agusnieto77.github.io/ACEP/reference/acep_openrouter.md),
  con ejemplos para modo cloud, fallback y JSON mode.
- Se agregó documentación completa para las funciones de IA:
  - Guías de uso con ejemplos para cada proveedor (OpenAI, Anthropic,
    Google, OpenRouter, TogetherAI, Ollama cloud)
  - Tabla comparativa de características entre proveedores
  - Instrucciones para configuración de API keys
  - Ejemplos de uso intercambiable entre diferentes APIs manteniendo la
    misma interfaz

## ACEP 0.0.2.9005 (versión en desarrollo)

- Se actualizó y mejoró la función para interactuar con los modelos de
  OpenAI.

## ACEP 0.0.3.9004 (versión en desarrollo vigente)

- Se mejoraron las funciones existentes y se creó la función
  acep_upos().

## ACEP 0.0.3.9003 (versión en desarrollo)

- Se crearon nuevas funciones y se mejoraron las existentes.

## ACEP 0.0.3.9002 (versión en desarrollo)

- Incorporamos una función para extraer palabras clave de corpus de
  texto en base a un diccionario.

- Se creo una nueva función para interactuar con la api de OpenAI.

## ACEP 0.0.3.9001 (versión en desarrollo)

- Se mejoraron las nuevas funciones para contexto de texto y
  tokenización.

## ACEP 0.0.21 (versión CRAN anterior)

CRAN release: 2022-11-05

- Se mejoraron las nuevas funciones para limpieza de texto, tokenización
  y detección de menciones.

## ACEP 0.0.2.9000 (versión en desarrollo)

- Se mejoraron las nuevas funciones para limpieza de texto, tokenización
  y detección de menciones.

## ACEP 0.0.2 (versión CRAN)

CRAN release: 2022-10-30

- Se agregaron nuevas funciones para limpieza de texto, tokenizacion y
  detección de menciones.

## ACEP 0.0.1.9000 (versión en desarrollo)

- se agregaron nuevas funciones.
- se agregaron nuevas bases de datos.
- se agregaron nuevas descripciones.
- se agregaron nuevos ejemplos.

## ACEP 0.0.1 (versión CRAN)

CRAN release: 2022-07-18

- Se ha añadido un archivo `NEWS.md` para seguir los cambios en el
  paquete.
