# ACEP 0.1.0.9000 (versión en desarrollo)

## Nuevas funcionalidades

* Se agregó `acep_corpus()`: constructor de objetos corpus para trabajar con pipelines de procesamiento de texto.
* Se agregó `acep_result()`: constructor de objetos resultado con métodos de impresión y resumen.
* Se agregó `acep_pipeline()`: pipeline completo que integra limpieza, conteo e intensidad.
* Se agregaron funciones pipeline para análisis composable:
  - `pipe_clean()`: limpieza de texto en pipeline
  - `pipe_count()`: conteo de menciones en pipeline
  - `pipe_intensity()`: cálculo de intensidad en pipeline
  - `pipe_timeseries()`: generación de series temporales en pipeline
* Se agregó `acep_postag_hibrido()`: etiquetado POS, lematización y extracción de entidades con spacyr.
* Se agregó `acep_process_chunks()`: procesamiento de textos en lotes para gestionar grandes volúmenes de datos.
* Se agregó `acep_gpt_schema()`: esquemas JSON predefinidos para análisis de texto con GPT.
* Se agregó `acep_ollama()`: interacción con modelos de lenguaje locales usando Ollama con soporte para structured outputs. Permite ejecutar análisis de texto sin costos ni API keys, manteniendo privacidad total de los datos.
* Se agregó `acep_ollama_setup()`: guía de instalación y configuración de Ollama.
* Se agregaron funciones auxiliares para gestión de caché:
  - `acep_clear_regex_cache()`: limpia el caché de expresiones regulares
  - `acep_regex_cache_size()`: consulta el tamaño del caché

## Mejoras en funciones existentes

* `acep_count()`: se incorporó sistema de caché de expresiones regulares para mejorar rendimiento.
* `acep_gpt()`: se actualizó para usar Structured Outputs de OpenAI con esquemas JSON.
* `acep_clean()`: renombrada desde `acep_cleaning()` para mayor consistencia.

## Documentación

* Se mejoró la documentación de todas las funciones nuevas y modificadas.
* Se agregaron ejemplos prácticos a todas las funciones operativas.
* Se actualizó README.Rmd con la lista completa de funciones del paquete.
* Se actualizaron todas las viñetas para usar las nuevas funciones.

# ACEP 0.0.2.9005 (versión en desarrollo)

* Se actualizó y mejoró la función para interactuar con los modelos de OpenAI.

# ACEP 0.0.3.9004 (versión en desarrollo vigente)

* Se mejoraron las funciones existentes y se creó la función acep_upos().

# ACEP 0.0.3.9003 (versión en desarrollo)

* Se crearon nuevas funciones y se mejoraron las existentes.

# ACEP 0.0.3.9002 (versión en desarrollo)

* Incorporamos una función para extraer palabras clave de corpus de texto en base a un diccionario.

* Se creo una nueva función para interactuar con la api de OpenAI.

# ACEP 0.0.3.9001 (versión en desarrollo)

* Se mejoraron las nuevas funciones para contexto de texto y tokenización.

# ACEP 0.0.21 (versión CRAN vigente)

* Se mejoraron las nuevas funciones para limpieza de texto, tokenización y detección de menciones.

# ACEP 0.0.2.9000 (versión en desarrollo)

* Se mejoraron las nuevas funciones para limpieza de texto, tokenización y detección de menciones.

# ACEP 0.0.2 (versión CRAN)

* Se agregaron nuevas funciones para limpieza de texto, tokenizacion y detección de menciones.

# ACEP 0.0.1.9000 (versión en desarrollo)

* se agregaron nuevas funciones.
* se agregaron nuevas bases de datos.
* se agregaron nuevas descripciones.
* se agregaron nuevos ejemplos.

# ACEP 0.0.1 (versión CRAN)

* Se ha añadido un archivo `NEWS.md` para seguir los cambios en el paquete.
