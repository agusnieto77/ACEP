require(purrr)
require(ACEP)
require(jsonlite)
require(dplyr)

acep_gpt_df <- function(textos) {
  map_df(seq_along(textos), function(i) {
    textos <- paste0("ID: ", seq_along(textos), " | ", textos)
    condicion_cumplida <- FALSE
    message(paste("Procesando ID:", i))
    instrucciones <- "Su tarea consiste en identificar en el texto las acciones de protesta como unidades de análisis y generar un JSON que incluya sólo 9 claves por acción identificada: 'id', 'cronica', 'fecha', 'sujeto', 'organizacion', 'participacion', 'accion', 'objeto', 'lugar'.\nSi el texto contiene más de una acción, cada una debe tratarse como unidad de análisis independiente.\nLos valores de las 9 claves deben ser el producto de extracciones limpias del texto.\n    'id': Identificador único del texto en formato numérico. Se repite para todas las acciones y es el primero en aparecer.\n    'cronica': Un resumen de la acción identificada en una frase.\n    'fecha': Formato 'yyyy-mm-dd' de la fecha de la acción de protesta. Se repite el mismo valor para todas las acciones y es la primera fecha que aparece.\n    'sujeto': Describe quién realiza la acción de protesta en un máximo de 5 palabras.\n    'organizacion': Identifica las organizaciones participantes en la acción de protesta. Si no hay información, repite el valor de 'sujeto'.\n    'participacion': Número de individuos o población que participaron en la acción de protesta. Si no hay información, se introduce el número 0.\n    'accion': Descripción de la acción de protesta en un máximo de 3 palabras.\n    'objeto': Identifica contra quién o qué se lleva a cabo la acción de protesta en un máximo de 6 palabras. Si no hay información, se usa 'sin datos'.\n    'lugar': Localidad o ubicación geográfica donde tiene lugar la acción de protesta en un máximo de 4 palabras."
    while (!condicion_cumplida) {
      salida <- acep_gpt(texto = textos[i], instrucciones = instrucciones)

      if (length(bind_rows(lapply(salida, fromJSON, simplifyDataFrame = TRUE))[[1]]) == 9) {
        salida_ok <- bind_rows(lapply(salida, fromJSON, simplifyDataFrame = TRUE))[[1]]
        condicion_cumplida <- TRUE
      } else {
        # Si no se cumple la condición, repetir la petición
        salida <- acep_gpt(texto = textos[i], instrucciones = instrucciones)
      }
    }
    return(salida_ok)
  })
}

acep_gpt_df(textos[1:3])
