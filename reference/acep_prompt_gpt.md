# Colección de instrucciones para GPT.

Colección de instrucciones para interactuar con los modelos de OpenAI.
Las instrucciones fueron testeadas en el marco de las tareas que
realizamos en el Observatorio de Conflictividad Social de la Universidad
Nacional de Mar del Plata.

## Usage

``` r
data(acep_prompt_gpt)
```

## Format

Es un objeto de clase 'list' con 4 componentes.

- instruccion_breve_sao_es:

  es un texto en castellano con instrucciones breves para extraer
  eventos de protesta y codificarlos con las siguientes claves: 'fecha',
  'sujeto', 'accion', 'objeto', 'lugar'.

- instruccion_larga_sao_es:

  es un texto en castellano con instrucciones largas para extraer
  eventos de protesta y codificarlos con las siguientes claves: 'id',
  'cronica', 'fecha', 'sujeto', 'organizacion', 'participacion',
  'accion', 'objeto', 'lugar'.

- instruccion_breve_sao_en:

  es un texto en inglés con instrucciones breves para extraer eventos de
  protesta y codificarlos con las siguientes claves: 'date', 'subject',
  'action', 'object', 'place'.

- instruccion_larga_sao_en:

  es un texto en inglés con instrucciones largas para extraer eventos de
  protesta y codificarlos con las siguientes claves: 'id', 'chronicle',
  'date', 'subject', 'organization', 'participation', 'action',
  'object', 'place'.

## Examples

``` r
prompt01 <- acep_prompt_gpt$instruccion_larga_sao_es
prompt01
#> [1] "Su tarea consiste en identificar en el texto las acciones de protesta como unidades de análisis y generar un JSON que incluya sólo 9 claves por acción identificada: 'id', 'cronica', 'fecha', 'sujeto', 'organizacion', 'participacion', 'accion', 'objeto', 'lugar'.\nSi el texto contiene más de una acción, cada una debe tratarse como unidad de análisis independiente.\nLos valores de las 9 claves deben ser el producto de extracciones limpias del texto.\n    'id': Identificador único del texto en formato numérico. Se repite para todas las acciones y es el primero en aparecer.\n    'cronica': Un resumen de la acción identificada en una frase.\n    'fecha': Formato 'yyyy-mm-dd' de la fecha de la acción de protesta. Se repite el mismo valor para todas las acciones y es la primera fecha que aparece.\n    'sujeto': Describe quién realiza la acción de protesta en un máximo de 5 palabras.\n    'organizacion': Identifica las organizaciones participantes en la acción de protesta. Si no hay información, repite el valor de 'sujeto'.\n    'participacion': Número de individuos o población que participaron en la acción de protesta. Si no hay información, se introduce el número 0.\n    'accion': Descripción de la acción de protesta en un máximo de 3 palabras.\n    'objeto': Identifica contra quién o qué se lleva a cabo la acción de protesta en un máximo de 6 palabras. Si no hay información, se usa null.\n    'lugar': Localidad o ubicación geográfica donde tiene lugar la acción de protesta en un máximo de 4 palabras."
```
