# Changelog

## ACEP 0.1.0.9000 (versión en desarrollo)

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

## ACEP 0.0.21 (versión CRAN vigente)

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
