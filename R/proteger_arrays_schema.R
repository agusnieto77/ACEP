# Función auxiliar para proteger arrays en esquemas
proteger_arrays_schema <- function(schema) {
  if (is.list(schema)) {
    # Proteger el campo 'required' si existe
    if ("required" %in% names(schema)) {
      schema$required <- I(schema$required)
    }
    # Proteger el campo 'enum' si existe
    if ("enum" %in% names(schema)) {
      schema$enum <- I(schema$enum)
    }
    # Recursivamente proteger subesquemas
    schema <- lapply(schema, proteger_arrays_schema)
  }
  return(schema)
}

# Actualizar acep_gpt_schema para usar la función auxiliar
acep_gpt_schema <- function(tipo = "extraccion_entidades") {
  
  esquemas <- list(
    
    # Esquema para extracción de entidades
    extraccion_entidades = list(
      type = "object",
      properties = list(
        personas = list(
          type = "array",
          items = list(type = "string"),
          description = "Lista de personas mencionadas"
        ),
        organizaciones = list(
          type = "array",
          items = list(type = "string"),
          description = "Lista de organizaciones mencionadas"
        ),
        lugares = list(
          type = "array",
          items = list(type = "string"),
          description = "Lista de lugares mencionados"
        ),
        fechas = list(
          type = "array",
          items = list(type = "string"),
          description = "Lista de fechas mencionadas"
        ),
        eventos = list(
          type = "array",
          items = list(type = "string"),
          description = "Lista de eventos mencionados"
        )
      ),
      required = c("personas", "organizaciones", "lugares", "fechas", "eventos"),
      additionalProperties = FALSE
    ),
    
    # Esquema para clasificación
    clasificacion = list(
      type = "object",
      properties = list(
        categoria = list(
          type = "string",
          description = "Categoría principal del texto"
        ),
        confianza = list(
          type = "number",
          description = "Nivel de confianza de 0 a 1"
        ),
        justificacion = list(
          type = "string",
          description = "Breve justificación de la clasificación"
        )
      ),
      required = c("categoria", "confianza", "justificacion"),
      additionalProperties = FALSE
    ),
    
    # Esquema para análisis de sentimiento
    sentimiento = list(
      type = "object",
      properties = list(
        sentimiento_general = list(
          type = "string",
          enum = c("positivo", "negativo", "neutral"),
          description = "Sentimiento general del texto"
        ),
        puntuacion = list(
          type = "number",
          description = "Puntuación de sentimiento de -1 (muy negativo) a 1 (muy positivo)"
        ),
        aspectos = list(
          type = "array",
          items = list(
            type = "object",
            properties = list(
              aspecto = list(type = "string"),
              sentimiento = list(type = "string", enum = c("positivo", "negativo", "neutral"))
            ),
            required = c("aspecto", "sentimiento"),
            additionalProperties = FALSE
          ),
          description = "Sentimientos por aspecto específico"
        )
      ),
      required = c("sentimiento_general", "puntuacion", "aspectos"),
      additionalProperties = FALSE
    ),
    
    # Esquema para resumen
    resumen = list(
      type = "object",
      properties = list(
        resumen_corto = list(
          type = "string",
          description = "Resumen en una oración"
        ),
        resumen_detallado = list(
          type = "string",
          description = "Resumen detallado en 2-3 oraciones"
        ),
        puntos_clave = list(
          type = "array",
          items = list(type = "string"),
          description = "Lista de puntos clave del texto"
        )
      ),
      required = c("resumen_corto", "resumen_detallado", "puntos_clave"),
      additionalProperties = FALSE
    ),
    
    # Esquema para pregunta-respuesta
    qa = list(
      type = "object",
      properties = list(
        respuesta = list(
          type = "string",
          description = "Respuesta a la pregunta"
        ),
        confianza = list(
          type = "string",
          enum = c("alta", "media", "baja"),
          description = "Nivel de confianza en la respuesta"
        ),
        cita_textual = list(
          type = "string",
          description = "Cita textual del texto que respalda la respuesta"
        )
      ),
      required = c("respuesta", "confianza", "cita_textual"),
      additionalProperties = FALSE
    ),
    
    # Esquema para extracción de tripletes
    tripletes = list(
      type = "object",
      properties = list(
        tripletes = list(
          type = "array",
          items = list(
            type = "object",
            properties = list(
              sujeto = list(type = "string"),
              predicado = list(type = "string"),
              objeto = list(type = "string")
            ),
            required = c("sujeto", "predicado", "objeto"),
            additionalProperties = FALSE
          ),
          description = "Lista de tripletes extraídos del texto"
        )
      ),
      required = c("tripletes"),
      additionalProperties = FALSE
    )
  )
  
  if (!tipo %in% names(esquemas)) {
    stop(sprintf("Tipo de esquema no válido. Opciones: %s", paste(names(esquemas), collapse = ", ")))
  }
  
  # Proteger arrays antes de devolver
  return(proteger_arrays_schema(esquemas[[tipo]]))
}
